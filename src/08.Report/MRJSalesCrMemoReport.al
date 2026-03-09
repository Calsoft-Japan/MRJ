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

            // ==== Header fields (align with sample) ====
            column(IssueDate; IssueDate) { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(DocumentNo; "No.") { }

            // 支払条件 / 支払方法
            column(PaymentTermTxt; PaymentTermTxt) { }
            column(PaymentMethodTxt; PaymentMethodTxt) { }

            // Customer address (left)
            column(CustAddr1; CustAddr[1]) { }                      // Name
            column(CustAddr2; "Bill-to Customer No.") { }           // Customer No.
            column(CustAddr3; "Bill-to Address") { }                // Address 1
            column(CustAddr4; "Bill-to Address 2") { }              // Address 2
            column(CustAddr5; "Bill-to Post Code") { }              // Post Code
            column(CustAddr6; "Bill-to Contact") { }                // Contact

            // ==================================================
            // Company address (right) - JP block from FormatAddr
            // ==================================================
            column(CompanyName; CompanyAddr[1]) { }                 // JP (from FormatAddr)
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyInfo."Phone No.") { }
            column(CompanyAddr7; CompanyInfo."Fax No.") { }
            column(CompanyAddr0; CompanyInfo."Post Code") { }       // JP Post Code

            // TEL/FAX (RC first; fallback Company Info) -> "No. / No. 2"
            column(TelLine; CompanyTelTxt) { }
            column(FaxLine; CompanyFaxTxt) { }

            // ==================================================
            // Company EN 
            // ==================================================
            column(CompanyNameEN; CompanyNameEN) { }
            column(CompanyAddrEN; CompanyAddrEN) { }

            // ---- Registration No. ----
            column(CompanyRegistrationLine; CompanyRegistrationLine) { }

            // Totals for bottom-right
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }

            // ==== Detail lines ====
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

            // ==== VAT Summary ====
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

            // ==== コメント ====
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLinkReference = "Sales Cr.Memo Header";
                DataItemTableView = sorting("No.", "Document Line No.", "Line No.");
                DataItemLink = "No." = field("No.");

                column(CommentText; Comment) { }
            }

            trigger OnAfterGetRecord()
            var
                RespCenter: Record "Responsibility Center";
                CrMemoLineTmp: Record "Sales Cr.Memo Line";
                VatPct: Decimal;
                BaseAmt: Decimal;
            begin
                // ----- Customer address -----
                Clear(CustAddr);
                if Customer.Get("Bill-to Customer No.") then
                    FormatAddr.Customer(CustAddr, Customer)
                else
                    Clear(CustAddr);

                // ----- Company Info -----
                if not CompanyInfo.Get() then
                    CompanyInfo.Get();

                // ----- Company JP block (RC first; fallback Company Info) -----
                Clear(CompanyAddr);
                if ("Responsibility Center" <> '') and RespCenter.Get("Responsibility Center") then
                    FormatAddr.RespCenter(CompanyAddr, RespCenter)
                else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                // -----  TEL/FAX (RC first; fallback Company Info; include No.2) -----
                CompanyTelTxt := '';
                CompanyFaxTxt := '';

                if ("Responsibility Center" <> '') and RespCenter.Get("Responsibility Center") then begin
                    CompanyTelTxt := BuildContactTxt('TEL', RespCenter."Phone No.", RespCenter."Phone No. 2");
                    CompanyFaxTxt := BuildContactTxt('FAX', RespCenter."Fax No.", RespCenter."Fax No. 2");
                end else begin
                    CompanyTelTxt := BuildContactTxt('TEL', CompanyInfo."Phone No.", CompanyInfo."Phone No. 2");
                    //CompanyFaxTxt := BuildContactTxt('FAX', CompanyInfo."Fax No.", CompanyInfo."Fax No. 2");
                end;

                // ----- Company EN (RC Name2/Address2; fallback CompanyInfo) -----
                Clear(CompanyNameEN);
                Clear(CompanyAddrEN);

                if ("Responsibility Center" <> '') and RespCenter.Get("Responsibility Center") then begin
                    CompanyNameEN := RespCenter."Name 2";
                    CompanyAddrEN := RespCenter."Address 2";
                end else begin
                    CompanyNameEN := CompanyInfo."Name 2";
                    CompanyAddrEN := CompanyInfo."Address 2";
                end;

                // ----- Payment terms -----
                if "Payment Terms Code" <> '' then begin
                    if PaymentTerms.Get("Payment Terms Code") then
                        PaymentTermTxt := PaymentTerms.Description
                    else
                        PaymentTermTxt := '';
                end else
                    PaymentTermTxt := '';

                // ----- Payment method -----
                if "Payment Method Code" <> '' then begin
                    if PaymentMethod.Get("Payment Method Code") then
                        PaymentMethodTxt := PaymentMethod.Description
                    else
                        PaymentMethodTxt := '';
                end else
                    PaymentMethodTxt := '';

                // Registration line
                CompanyRegistrationLine := BuildRegistrationLine();

                // ----- Totals + VAT Summary -----
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
                        Caption = '発行日';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            IssueDate := WorkDate(); // default 発行日 = WORKDATE
        end;
    }

    var
        CompanyInfo: Record "Company Information";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        FormatAddr: Codeunit "Format Address";
        Customer: Record Customer;

        CustAddr: array[8] of Text[100];

        // JP formatted block
        CompanyAddr: array[8] of Text[100];

        // EN single-line outputs (RC Name2/Address2)
        CompanyNameEN: Text[100];
        CompanyAddrEN: Text[100];

        // TEL/FAX formatted outputs (No. / No.2)
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

    local procedure BuildContactTxt(LabelTxt: Text; No1: Text; No2: Text): Text[100]
    var
        ResultTxt: Text[100];
    begin
        ResultTxt := '';

        if No1 <> '' then
            ResultTxt := No1;

        if No2 <> '' then begin
            if ResultTxt <> '' then
                ResultTxt += ' / ' + No2
            else
                ResultTxt := No2;
        end;

        if ResultTxt = '' then
            exit('');

        exit(LabelTxt + ' : ' + ResultTxt);
    end;

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
