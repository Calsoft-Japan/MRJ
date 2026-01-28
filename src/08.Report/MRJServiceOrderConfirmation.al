report 50022 "MRJ Service Order Confirmation"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Service Order Confirmation';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJServiceOrderConfirmationReport.rdlc';

    dataset
    {
        dataitem(Header; "Service Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Customer No.";

            // --- Header Columns ---
            column(No_; "No.") { }
            column(Customer_No_; "Customer No.") { }
            column(txtDate; txtDate) { }
            column(SummarizeLines; SummarizeLines) { }
            column(TotalAmt; TotalAmt) { }
            column(TotalGrossAmt; TotalGrossAmt) { }
            column(PaymentTermsDesc; PaymentTermsDesc) { }
            column(PaymentMethodDesc; PaymentMethodDesc) { }

            // --- Customer Address (宛名) ---
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }

            // --- Company Information (自社情報) ---
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(CompanyAddr1; CompanyAddr[1]) { } // 自社名
            column(CompanyAddr2; CompanyAddr[2]) { } // 住所1
            column(CompanyAddr3; CompanyAddr[3]) { } // 住所2
            column(CompanyAddr4; CompanyAddr[4]) { } // 郵便番号等
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyEMail; CompanyInfo."E-Mail") { }
            column(CompanyHomePage; CompanyInfo."Home Page") { }
            column(CompanyRegistrationNo; CompanyInfo."Registration No.") { } // インボイス登録番号
            column(CompanyNameJP; CompanyInfo."Ship-to Name") { }

            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(CopyText; CopyText) { }

                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    dataitem(ServiceItemLine; "Service Item Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                        DataItemLinkReference = Header;
                        column(Line_Description; Description) { }
                        column(LineNo_ServLineType; "Line No.") { }
                        column(Description_ServLineType; Description) { }
                        column(ItemNo_ServLineType; "Item No.") { }
                        column(ServItemNo_ServLineType; "Service Item No.") { }
                        column(ServiceItemDesc; Description) { }
                        column(SerItmGrCode_ServLineType; "Service Item Group Code") { }
                        column(SerialNo_ServLineType; "Serial No.") { }
                        column(Warranty1_ServLineType; Warranty) { }

                        dataitem(ServiceLine; "Service Line")
                        {
                            DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), "Service Item Line No." = field("Line No.");
                            DataItemLinkReference = ServiceItemLine;
                            DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                            column(LineNo_ServLine; "Line No.") { }
                            column(Description_ServLine; Description) { }
                            column(Quantity_ServLine; Qty) { }
                            column(LineUOM; "Unit of Measure Code") { }
                            column(UnitPrice_ServLine; "Unit Price") { }
                            column(Amt; Amt) { }

                            trigger OnPreDataItem()
                            begin
                                if SummarizeLines then CurrReport.Break();
                            end;

                            trigger OnAfterGetRecord()
                            begin
                                CalculateAmounts(ServiceLine);
                                if (ShowQty = ShowQty::"Quantity Invoiced") and (Qty = 0) then
                                    CurrReport.Skip();
                            end;
                        }
                    }

                    dataitem(SummarizedLine; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(FlatLineDescription; FlatDescription) { }
                        column(FlatLineQuantity; FlatQty) { }
                        column(FlatLineAmount; FlatAmount) { }
                        column(FlatLineUOM; FlatUOM) { }

                        trigger OnPreDataItem()
                        begin
                            if not SummarizeLines then CurrReport.Break();
                            SummarizeServiceLines();
                            SetRange(Number, 1, TempServiceLine.Count());
                            if TempServiceLine.FindSet() then;
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            FlatDescription := TempServiceLine.Description;
                            FlatQty := TempServiceLine.Quantity;
                            FlatUOM := TempServiceLine."Unit of Measure Code";
                            FlatAmount := TempServiceLine."Line Amount";
                            if TempServiceLine.Next() = 0 then;
                        end;
                    }
                }
                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    SetRange(Number, 1, NoOfLoops);
                end;
            }

            trigger OnAfterGetRecord()
            var
                FormatAddr: Codeunit "Format Address";
                PaymentTerms: Record "Payment Terms";
                PaymentMethod: Record "Payment Method";
            begin
                // 日付フォーマット
                txtDate := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                // 会社情報の取得
                if CompanyInfo.Get() then
                    CompanyInfo.CalcFields(Picture);

                // 得意先住所の取得（アクセス権エラー回避のためHeaderを直接渡す）
                Clear(CustAddr);
                FormatAddr.ServiceOrderSellto(CustAddr, Header);

                // 会社住所の取得
                Clear(CompanyAddr);
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                // --- 支払条件の説明を取得 ---
                Clear(PaymentTermsDesc);
                if PaymentTerms.Get("Payment Terms Code") then
                    PaymentTermsDesc := PaymentTerms.Description;

                // --- 支払方法の説明を取得 ---
                Clear(PaymentMethodDesc);
                if PaymentMethod.Get("Payment Method Code") then
                    PaymentMethodDesc := PaymentMethod.Description;

                // 合計金額の計算
                TotalAmt := 0;
                TotalGrossAmt := 0;
                if SummarizeLines then
                    SummarizeServiceLines()
                else
                    PreCalculateTotals();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'オプション';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = '部数';
                    }
                    field(ShowQty; ShowQty)
                    {
                        ApplicationArea = Service;
                        Caption = '金額の基準';
                        OptionCaption = '数量,請求済数量';
                    }
                    field(SummarizeLinesField; SummarizeLines)
                    {
                        ApplicationArea = All;
                        Caption = '明細纏め';
                    }
                }
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        TempServiceLine: Record "Service Line" temporary;
        txtDate: Text[50];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[50];
        SummarizeLines: Boolean;
        ShowQty: Option Quantity,"Quantity Invoiced";
        Qty, Amt, GrossAmt, TotalAmt, TotalGrossAmt : Decimal;
        FlatDescription: Text;
        FlatQty, FlatAmount : Decimal;
        FlatUOM: Code[10];
        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        PaymentTermsDesc: Text[100];
        PaymentMethodDesc: Text[100];

    local procedure CalculateAmounts(var RecLine: Record "Service Line")
    begin
        if ShowQty = ShowQty::Quantity then begin
            Qty := RecLine.Quantity;
            Amt := RecLine."Line Amount";
            GrossAmt := RecLine."Amount Including VAT";
        end else begin
            Qty := RecLine."Quantity Invoiced";
            Amt := Round((Qty * RecLine."Unit Price") * (1 - RecLine."Line Discount %" / 100));
            GrossAmt := Round((1 + RecLine."VAT %" / 100) * Amt);
        end;
    end;

    local procedure PreCalculateTotals()
    var
        ServiceLineRec: Record "Service Line";
    begin
        ServiceLineRec.SetRange("Document Type", Header."Document Type");
        ServiceLineRec.SetRange("Document No.", Header."No.");
        if ServiceLineRec.FindSet() then
            repeat
                CalculateAmounts(ServiceLineRec);
                if not ((ShowQty = ShowQty::"Quantity Invoiced") and (Qty = 0)) then begin
                    TotalAmt += Amt;
                    TotalGrossAmt += GrossAmt;
                end;
            until ServiceLineRec.Next() = 0;
    end;

    local procedure SummarizeServiceLines()
    var
        ServiceLineRec: Record "Service Line";
        Res: Record Resource;
        ResGrp: Record "Resource Group";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        TargetResGrp: Code[20];
    begin
        TempServiceLine.Reset();
        TempServiceLine.DeleteAll();
        ServiceMgtSetup.Get();
        TotalAmt := 0;
        TotalGrossAmt := 0;

        ServiceLineRec.SetRange("Document Type", Header."Document Type");
        ServiceLineRec.SetRange("Document No.", Header."No.");
        if ServiceLineRec.FindSet() then
            repeat
                CalculateAmounts(ServiceLineRec);
                if (ShowQty = ShowQty::"Quantity Invoiced") and (Qty = 0) then
                    continue;

                TotalAmt += Amt;
                TotalGrossAmt += GrossAmt;

                TargetResGrp := '';
                if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and Res.Get(ServiceLineRec."No.") then begin
                    TargetResGrp := Res."Resource Group No.";
                    if (ServiceMgtSetup."Resource Group Filter" <> '') and (StrPos(ServiceMgtSetup."Resource Group Filter", TargetResGrp) > 0) then
                        TargetResGrp := ServiceMgtSetup."Resource Group for Sort";
                end;

                TempServiceLine.Reset();
                TempServiceLine.SetRange(Type, ServiceLineRec.Type::Resource);
                TempServiceLine.SetRange("Resource Group No.", TargetResGrp);
                if (TargetResGrp <> '') and TempServiceLine.FindFirst() then begin
                    TempServiceLine.Quantity += Qty;
                    TempServiceLine."Line Amount" += Amt;
                    TempServiceLine.Modify();
                end else begin
                    TempServiceLine.Init();
                    TempServiceLine.TransferFields(ServiceLineRec);
                    TempServiceLine.Quantity := Qty;
                    TempServiceLine."Line Amount" := Amt;
                    TempServiceLine."Resource Group No." := TargetResGrp;
                    if (TargetResGrp <> '') and ResGrp.Get(TargetResGrp) then
                        TempServiceLine.Description := ResGrp.Name;
                    TempServiceLine.Insert();
                end;
            until ServiceLineRec.Next() = 0;
    end;
}