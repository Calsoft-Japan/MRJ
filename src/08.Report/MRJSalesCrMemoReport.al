report 50082 "MRJ Sales Credit Memo"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Sales Credit Memo (JP)';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJSalesCreditMemoReport.rdlc';

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";

            column(IssueDate; IssueDate) { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(DocumentNo; "No.") { }

            column(PaymentTermTxt; PaymentTermTxt) { }
            column(PaymentMethodTxt; PaymentMethodTxt) { }

            // Customer address
            column(CustAddr1; CustNameTxt) { }
            column(CustAddr2; "Bill-to Customer No.") { }
            column(CustAddr3; "Bill-to Address") { }
            column(CustAddr4; "Bill-to Address 2") { }
            column(CustAddr5; "Bill-to Post Code") { }
            column(CustAddr6; BillToContactTxt) { }

            // Company address
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }

            // ---- English Company Info ----//
            column(CompanyNameEN; CompanyAddrEN[1]) { }
            column(CompanyAddrEN2; CompanyAddrEN[2]) { }
            column(CompanyAddrEN3; CompanyAddrEN[3]) { }
            column(CompanyAddrEN4; CompanyAddrEN[4]) { }
            column(CompanyAddrEN5; CompanyAddrEN[5]) { }

            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyFaxNo; CompanyInfo."Fax No.") { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }

            column(TelLine; CompanyTelTxt) { }
            column(FaxLine; CompanyFaxTxt) { }

            column(CompanyRegistrationLine; CompanyRegistrationLine) { }

            // Totals
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }

            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLinkReference = "Sales Cr.Memo Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo_; "No.") { }
                column(LineDescription; Description) { }
                column(LineDescription2; "Description 2") { }
                column(LineQuantity; Quantity) { }
                column(LineUOM; "Unit of Measure Code") { }
                column(LineUnitPrice; "Unit Price") { }
                column(LineAmount; "Line Amount") { }
                column(Type_Line; Type) { }
            }

            dataitem(VATSummary; Integer)
            {
                DataItemTableView = sorting(Number);

                column(VATDisplayTxt; VATDisplayTxt) { }
                column(VATBaseAmount; VATBaseAmount) { }
                column(VATLabelTxt; '消費税') { }
                column(VATAmount; VATAmount) { }

                trigger OnPreDataItem()
                begin
                    if VatPctList.Count() = 0 then
                        CurrReport.Break();

                    SetRange(Number, 1, VatPctList.Count());
                end;

                trigger OnAfterGetRecord()
                var
                    VatPct: Decimal;
                    BaseDec: Decimal;
                begin
                    VatPctList.Get(Number, VatPct);
                    BaseDec := VatSummaryDict.Get(VatPct);

                    if VatPct = 0 then
                        VATDisplayTxt := '非課税'
                    else
                        VATDisplayTxt := Format(VatPct) + '%対象';

                    VATBaseAmount := BaseDec;
                    VATAmount := Round(VATBaseAmount * VatPct / 100, 0.1);
                end;
            }

            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLinkReference = "Sales Cr.Memo Header";
                DataItemTableView = sorting("No.", "Document Line No.", "Line No.");
                DataItemLink = "No." = field("No.");

                column(CommentText; Comment) { }
            }

            trigger OnAfterGetRecord()
            var
                CrMemoLineTmp: Record "Sales Cr.Memo Line";
                VatPct: Decimal;
                BaseAmt: Decimal;
            begin
                // Customer address
                CustNameTxt := "Bill-to Name";
                BillToContactTxt := "Bill-to Contact";

                if Customer.Get("Bill-to Customer No.") then begin
                    if Customer."NameTitle" <> '' then
                        CustNameTxt := CustNameTxt + ' ' + Customer."NameTitle";

                    if (BillToContactTxt <> '') and (Customer."ContactTitle" <> '') then
                        BillToContactTxt := BillToContactTxt + ' ' + Customer."ContactTitle";
                end;

                // Company information
                CompanyInfo.Get();
                Clear(CompanyAddr);
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                Clear(CompanyAddrEN);

                CompanyAddrEN[1] := CompanyInfo."English Name TJP";
                CompanyAddrEN[2] := CompanyInfo."English Address TJP";
                CompanyAddrEN[3] := CompanyInfo."English Address 2 TJP";
                CompanyAddrEN[4] := CompanyInfo."English Post Code TJP";
                CompanyAddrEN[5] := CompanyInfo."English City TJP";
                CompanyAddrEN[6] := CompanyInfo."Country/Region Code";

                CompanyTelTxt := 'TEL : ' + CompanyInfo."Phone No.";
                CompanyFaxTxt := 'FAX : ' + CompanyInfo."Fax No.";

                // Payment terms
                Clear(PaymentTermTxt);
                if ("Payment Terms Code" <> '') and PaymentTerms.Get("Payment Terms Code") then
                    PaymentTermTxt := PaymentTerms.Description;

                // Payment method
                Clear(PaymentMethodTxt);
                if ("Payment Method Code" <> '') and PaymentMethod.Get("Payment Method Code") then
                    PaymentMethodTxt := PaymentMethod.Description;

                // Registration No.
                CompanyRegistrationLine := BuildRegistrationLine();

                // Totals and VAT summary
                TotalExclVAT := 0;
                TotalInclVAT := 0;
                TotalVAT := 0;

                Clear(VatPctList);
                Clear(VatSummaryDict);

                CrMemoLineTmp.Reset();
                CrMemoLineTmp.SetRange("Document No.", "No.");
                CrMemoLineTmp.SetFilter(Type, '<>%1', CrMemoLineTmp.Type::" ");

                if CrMemoLineTmp.FindSet() then
                    repeat
                        TotalExclVAT += CrMemoLineTmp."Line Amount";
                        TotalInclVAT += CrMemoLineTmp."Amount Including VAT";

                        VatPct := CrMemoLineTmp."VAT %";
                        BaseAmt := CrMemoLineTmp."VAT Base Amount";

                        if not VatSummaryDict.ContainsKey(VatPct) then begin
                            VatSummaryDict.Add(VatPct, BaseAmt);
                            VatPctList.Add(VatPct);
                        end else
                            VatSummaryDict.Set(VatPct, VatSummaryDict.Get(VatPct) + BaseAmt);
                    until CrMemoLineTmp.Next() = 0;

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
                    field(IssueDate; IssueDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Issue Date';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            IssueDate := WorkDate();
        end;
    }

    var
        CustNameTxt: Text[100];
        BillToContactTxt: Text[100];
        CompanyInfo: Record "Company Information";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        FormatAddr: Codeunit "Format Address";
        Customer: Record Customer;

        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];

        CompanyNameEN: Text[100];
        CompanyAddrEN: array[8] of Text[100];
        CompanyTelTxt: Text[100];
        CompanyFaxTxt: Text[100];

        IssueDate: Date;
        PaymentTermTxt: Text[100];
        PaymentMethodTxt: Text[100];

        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;

        VatPctList: List of [Decimal];
        VatSummaryDict: Dictionary of [Decimal, Decimal];

        VATDisplayTxt: Text[30];
        VATBaseAmount: Decimal;
        VATAmount: Decimal;

        CompanyRegistrationLine: Text[100];

    local procedure BuildRegistrationLine(): Text[100]
    var
        RegNo: Text[50];
    begin
        RegNo := CompanyInfo."Registration No.";
        if RegNo = '' then
            RegNo := CompanyInfo."VAT Registration No.";

        if RegNo = '' then
            exit('');

        exit('登録番号：' + RegNo);
    end;
}