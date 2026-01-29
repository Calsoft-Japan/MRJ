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
            column(CustPostCode; "Post Code") { }

            // --- Customer & Company Address ---
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyRegistrationNo; CompanyInfo."Registration No.") { }
            column(CompanyNameJP; CompanyInfo."Ship-to Name") { }

            // --- 1. 通常の明細（Service Item Line 階層） ---
            dataitem(ServiceItemLine; "Service Item Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

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
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                    column(LineNo_ServLine; "Line No.") { }
                    column(Type_ServLine; Type) { }
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

            // --- 2. 明細纏め（Integer 階層） ---
            dataitem(SummarizedLine; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(FlatLineDescription; FlatDescription) { }
                column(FlatLineQuantity; FlatQty) { }
                column(FlatLineAmount; FlatAmount) { }
                column(FlatServItemNo; FlatServItemNo) { }
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
                end;
            }

            // --- 3. コメント行（Header 直下へ移動） ---
            dataitem(ServiceCommentLine; "Service Comment Line")
            {
                DataItemLinkReference = Header;
                DataItemLink = "Table Subtype" = field("Document Type"), "No." = field("No.");

                DataItemTableView = sorting("Table Name", "Table Subtype", "No.", "Type", "Table Line No.", "Line No.")
                        where("Table Name" = const("Service Header"), "Type" = const(General));

                column(No_SCL; "No.") { } // ★ここを追加（RDLCでの紐付け用）
                column(CommentText; Comment) { }
            }

            trigger OnAfterGetRecord()
            var
                FormatAddr: Codeunit "Format Address";
                PaymentTerms: Record "Payment Terms";
                PaymentMethod: Record "Payment Method";
            begin
                TotalAmt := 0;
                TotalGrossAmt := 0;

                txtDate := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');
                if CompanyInfo.Get() then CompanyInfo.CalcFields(Picture);

                FormatAddr.ServiceOrderSellto(CustAddr, Header);
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                if PaymentTerms.Get("Payment Terms Code") then PaymentTermsDesc := PaymentTerms.Description;
                if PaymentMethod.Get("Payment Method Code") then PaymentMethodDesc := PaymentMethod.Description;

                if SummarizeLines then
                    SummarizeServiceLines()
                else
                    PreCalculateTotals();

                TotalExclVAT := TotalAmt;
                TotalInclVAT := TotalGrossAmt;
                TotalVAT := TotalInclVAT - TotalExclVAT;
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
                    field(ShowQtyField; ShowQty)
                    {
                        ApplicationArea = Service;
                        Caption = '金額基準';
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
        SummarizeLines: Boolean;
        ShowQty: Option Quantity,"Quantity Invoiced";
        Qty, Amt, GrossAmt, TotalAmt, TotalGrossAmt, TotalExclVAT, TotalInclVAT, TotalVAT, FlatQty, FlatAmount, FlatPrice : Decimal;
        FlatDescription: Text;
        FlatServItemNo: Code[20];
        FlatUOM: Code[10];
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
                CalculateAmounts(ServiceLineRec);
                if not ((ShowQty = ShowQty::"Quantity Invoiced") and (Qty = 0)) then begin
                    TotalAmt += Amt;
                    TotalGrossAmt += GrossAmt;
                end;
            until ServiceLineRec.Next() = 0;
    end;
}