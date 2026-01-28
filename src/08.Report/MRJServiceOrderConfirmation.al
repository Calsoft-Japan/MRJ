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
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }
            column(PaymentTermsDesc; PaymentTermsDesc) { }
            column(PaymentMethodDesc; PaymentMethodDesc) { }
            column(CurrencyCode_ServHeader; "Currency Code") { }
            column(CustPostCode; "Post Code") { } // 得意先郵便番号

            // --- Customer Address ---
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }

            // --- Company Information ---
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyRegistrationNo; CompanyInfo."Registration No.") { }
            column(CompanyNameJP; CompanyInfo."Ship-to Name") { }

            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(Number_CopyLoop; Number) { } // 重複回避フィルタ用

                dataitem(ServiceCommentLine; "Service Comment Line")
                {
                    DataItemLinkReference = Header;
                    DataItemLink = "Table Subtype" = field("Document Type"), "No." = field("No.");
                    DataItemTableView = sorting("Table Name", "Table Subtype", "No.", "Type", "Table Line No.", "Line No.")
                                        where("Table Name" = const("Service Header"));
                    column(CommentText; Comment) { }
                }

                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    // 1. 通常モード用のデータアイテム
                    dataitem(ServiceItemLine; "Service Item Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                        DataItemLinkReference = Header;

                        column(LineNo_ServLineType; "Line No.") { }
                        column(ItemNo_ServLineType; "Item No.") { }
                        column(ServItemNo_ServLineType; "Service Item No.") { }
                        column(Description_ServLineType; Description) { }
                        column(SerialNo_ServLineType; "Serial No.") { }
                        column(SerItmGrCode_ServLineType; "Service Item Group Code") { }
                        column(Warranty1_ServLineType; Warranty) { }

                        dataitem(ServiceLine; "Service Line")
                        {
                            DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), "Service Item Line No." = field("Line No.");
                            DataItemLinkReference = ServiceItemLine;

                            column(LineNo_ServLine; "Line No.") { }
                            column(Type_ServLine; Type) { } // ★追加
                            column(Description_ServLine; Description) { }

                            column(Quantity_ServLine; Qty) { }
                            column(Amt; Amt) { }
                            column(LineUOM; "Unit of Measure Code") { }
                            column(UnitPrice_ServLine; "Unit Price") { }


                            trigger OnPreDataItem()
                            begin
                                if SummarizeLines then CurrReport.Break();
                            end;

                            trigger OnAfterGetRecord()
                            begin
                                CalculateAmounts(ServiceLine);
                            end;
                        }
                    }

                    // 2. 明細纏めモード用のデータアイテム
                    dataitem(SummarizedLine; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(FlatLineDescription; FlatDescription) { }
                        column(FlatLineQuantity; FlatQty) { }
                        column(FlatLineAmount; FlatAmount) { }
                        column(FlatServItemNo; FlatServItemNo) { } // 纏め時でも機器番号を表示
                        column(FlatLineUOM; FlatUOM) { }

                        trigger OnPreDataItem()
                        begin
                            if not SummarizeLines then CurrReport.Break();
                            SummarizeServiceLines();
                            SetRange(Number, 1, TempServiceLine.Count());
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then TempServiceLine.FindSet() else TempServiceLine.Next();

                            FlatDescription := TempServiceLine.Description;
                            FlatQty := TempServiceLine.Quantity;
                            FlatAmount := TempServiceLine."Line Amount";
                            FlatServItemNo := TempServiceLine."Service Item No.";

                            FlatUOM := TempServiceLine."Unit of Measure Code";
                            FlatPrice := TempServiceLine."Unit Price";
                            FlatAmount := TempServiceLine."Line Amount";
                        end;
                    }
                }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, 1 + Abs(NoOfCopies));
                end;
            }

            trigger OnAfterGetRecord()
            var
                FormatAddr: Codeunit "Format Address";
                PaymentTerms: Record "Payment Terms";
                PaymentMethod: Record "Payment Method";
            begin
                // 初期化
                TotalAmt := 0;
                TotalGrossAmt := 0;

                txtDate := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');
                if CompanyInfo.Get() then CompanyInfo.CalcFields(Picture);

                FormatAddr.ServiceOrderSellto(CustAddr, Header);
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                if PaymentTerms.Get("Payment Terms Code") then PaymentTermsDesc := PaymentTerms.Description;
                if PaymentMethod.Get("Payment Method Code") then PaymentMethodDesc := PaymentMethod.Description;

                // 金額計算
                if SummarizeLines then SummarizeServiceLines() else PreCalculateTotals();

                TotalExclVAT := TotalAmt;
                TotalInclVAT := TotalGrossAmt;
                TotalVAT := TotalInclVAT - TotalExclVAT;
            end;
        }
    }

    var
        CompanyInfo: Record "Company Information";
        TempServiceLine: Record "Service Line" temporary;
        txtDate: Text[50];
        NoOfCopies: Integer;
        SummarizeLines: Boolean;
        ShowQty: Option Quantity,"Quantity Invoiced";
        Qty, Amt, GrossAmt, TotalAmt, TotalGrossAmt, TotalExclVAT, TotalInclVAT, TotalVAT : Decimal;
        FlatDescription: Text;
        FlatQty, FlatAmount : Decimal;
        FlatServItemNo: Code[20];

        FlatUOM: Code[10];
        FlatPrice: Decimal;
        CustAddr, CompanyAddr : array[8] of Text[100];
        PaymentTermsDesc, PaymentMethodDesc : Text[100];

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

    local procedure SummarizeServiceLines()
    var
        ServiceLineRec: Record "Service Line";
        Res: Record Resource;
    begin
        TempServiceLine.Reset();
        TempServiceLine.DeleteAll();
        TotalAmt := 0;
        TotalGrossAmt := 0;

        ServiceLineRec.SetRange("Document Type", Header."Document Type");
        ServiceLineRec.SetRange("Document No.", Header."No.");
        if ServiceLineRec.FindSet() then
            repeat
                CalculateAmounts(ServiceLineRec);
                TotalAmt += Amt;
                TotalGrossAmt += GrossAmt;

                TempServiceLine.Reset();
                TempServiceLine.SetRange(Description, ServiceLineRec.Description);
                if TempServiceLine.FindFirst() then begin
                    TempServiceLine.Quantity += Qty;
                    TempServiceLine."Line Amount" += Amt;
                    TempServiceLine.Modify();
                end else begin
                    TempServiceLine.Init();
                    TempServiceLine.TransferFields(ServiceLineRec);
                    TempServiceLine.Quantity := Qty;
                    TempServiceLine."Line Amount" := Amt;
                    TempServiceLine.Insert();
                end;
            until ServiceLineRec.Next() = 0;
    end;

    local procedure PreCalculateTotals()
    var
        ServiceLineRec: Record "Service Line";
    begin
        ServiceLineRec.SetRange("Document Type", Header."Document Type");
        ServiceLineRec.SetRange("Document No.", Header."No.");
        if ServiceLineRec.FindSet() then
            repeat
                // 各行の金額を、リクエストページのオプション（数量ベースか請求済ベースか）に従って計算
                CalculateAmounts(ServiceLineRec);

                // 請求済数量ベースの時、数量が0の行は合計に含めない
                if not ((ShowQty = ShowQty::"Quantity Invoiced") and (Qty = 0)) then begin
                    TotalAmt += Amt;
                    TotalGrossAmt += GrossAmt;
                end;
            until ServiceLineRec.Next() = 0;
    end;
}