report 50023 "MRJ Service Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Service Invoice';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJServiceInvoiceReport.rdlc';

    dataset
    {
        dataitem(SvcInvHdr; "Service Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Customer No.";

            // ---- Dates ----
            column(DocumentDateTxt; DocumentDateTxt) { }

            // ---- Seal toggle ----
            column(ShowSeal; ShowSeal) { }
            column(CompanyPic; CompanyInfo.Picture) { }
            column(CompanyStamp; CompanyInfo.Stamp) { }

            // ---- Identifiers ----
            column(BillToCustomerNo; "Bill-to Customer No.") { }
            column(OrderNo; "Order No.") { }
            column(InvNo; "No.") { }

            // ---- Customer (Left header block) ----
            column(CustName; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CustAddr7; CustAddr[7]) { } // TEL
            column(CustAddr8; CustAddr[8]) { } // FAX

            // ---- Company (Right header block) ----
            column(CompanyName; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr0; CompanyInfo."Post Code") { }

            // ---- Registration No. ----
            column(CompanyRegistrationLine; CompanyRegistrationLine) { }
            column(CompanyRegistrationNo; CompanyInfo."VAT Registration No.") { }

            //---- Payment details ----
            column(PaymentTermText; PaymentTermText) { }
            column(PaymentMethodText; PaymentMethodText) { }

            // ---- Bank (Company Info only as you requested) ----
            column(PaymentBank1; PaymentBank[1]) { }
            column(PaymentBank2; PaymentBank[2]) { }
            column(PaymentBank3; PaymentBank[3]) { }

            // ---- Totals ----
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }

            // =========================
            // Detail lines
            // =========================
            dataitem(SvcInvLine; "Service Invoice Line")
            {
                DataItemLinkReference = SvcInvHdr;
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo; "Line No.") { }
                column(NoLine; "No.") { }
                column(LineType; Type) { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(UOM; "Unit of Measure") { }
                column(LineDiscPercent; "Line Discount %") { }
                column(Warranty; Warranty) { }
                column(UnitPrice; "Unit Price") { }

                // amounts
                column(LineAmount; "Line Amount") { }
                column(LineVATPct; "VAT %") { }
            }

            // =========================
            // Comments (Service Comment Line)
            // =========================
            dataitem(SvcInvComment; "Service Comment Line")
            {
                DataItemLinkReference = SvcInvHdr;
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("Table Name", "Table Subtype", "No.", "Type", "Table Line No.", "Line No.");

                column(CommentDate; Date) { }
                column(CommentText; Comment) { }

                trigger OnPreDataItem()
                begin
                    SetFilter(Comment, '<>%1', '');

                    // Posted Service Invoice header comments only
                    SetRange("Table Name", "Table Name"::"Service Invoice Header");
                    SetRange("Table Line No.", 0);
                end;
            }

            // =========================
            // VAT Summary (Qualified Invoice)
            // =========================
            dataitem(VATSummary; Integer)
            {
                DataItemTableView = sorting(Number);

                column(VATDisplayTxt; VATDisplayTxt) { }   // 非課税 / 8%対象 / 10%対象
                column(VATBaseAmount; VATBaseAmount) { }   // base amount by VAT %
                column(VATLabelTxt; '消費税') { }          // label
                column(VATAmount; VATAmount) { }           // tax amount (round 0.1)

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
                    VatSummaryDict.Get(VatPct, BaseDec);

                    if VatPct = 0 then
                        VATDisplayTxt := '非課税'
                    else
                        VATDisplayTxt := Format(VatPct, 0, '<Integer>') + '%対象';

                    VATBaseAmount := BaseDec;

                    // round to one decimal place (as per your spec)
                    VATAmount := Round(VATBaseAmount * VatPct / 100, 0.1);
                end;
            }

            trigger OnAfterGetRecord()
            var
                RespCenter: Record "Responsibility Center";
                SvcInvLineTmp: Record "Service Invoice Line";
                LineBase: Decimal;
                LineVAT: Decimal;
            begin
                // Load Company Picture and Stamp
                CompanyInfo.CalcFields(Picture, Stamp);

                // Document Date (fallback to Posting Date)
                if "Document Date" <> 0D then
                    DocumentDateTxt := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日')
                else
                    DocumentDateTxt := Format("Posting Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                // Company address
                Clear(CompanyAddr);
                if ("Responsibility Center" <> '') and RespCenter.Get("Responsibility Center") then
                    FormatAddress.RespCenter(CompanyAddr, RespCenter)
                else
                    FormatAddress.Company(CompanyAddr, CompanyInfo);

                // Bank details: Company Info only (simple)
                FillPaymentBankFromCompanyInfo();

                // Customer bill-to address + TEL/FAX
                Clear(CustAddr);
                FillServiceInvBillTo(CustAddr, SvcInvHdr);

                // Registration line
                CompanyRegistrationLine := BuildRegistrationLine();

                // Keep header tight if you want
                ClearTrailingAddressLines();

                // Payment Terms
                Clear(PaymentTermText);
                if "Payment Terms Code" <> '' then
                    if PaymentTerms.Get("Payment Terms Code") then
                        PaymentTermText := PaymentTerms.Description;

                // Payment Method
                Clear(PaymentMethodText);
                if "Payment Method Code" <> '' then
                    if PaymentMethod.Get("Payment Method Code") then
                        PaymentMethodText := PaymentMethod.Description;

                // Totals + VAT Summary
                TotalExclVAT := 0;
                TotalVAT := 0;
                TotalInclVAT := 0;

                Clear(VatSummaryDict);
                Clear(VatPctList);

                SvcInvLineTmp.Reset();
                SvcInvLineTmp.SetRange("Document No.", "No.");

                if SvcInvLineTmp.FindSet() then
                    repeat
                        // FDD #1/#2: VAT Base Amount per VAT%
                        // Use Line Amount first for posted lines, fallback to Amount
                        LineBase := SvcInvLineTmp."Line Amount";
                        if LineBase = 0 then
                            LineBase := SvcInvLineTmp.Amount;

                        // Only summarize real amount lines
                        if LineBase = 0 then
                            continue;

                        // header totals (excl VAT)
                        TotalExclVAT += LineBase;

                        // FDD #1/#2: accumulate base by VAT%
                        AddOrUpdateVatSummary(SvcInvLineTmp."VAT %", LineBase);

                        // total VAT (FDD #4 rounding rule 0.1)
                        LineVAT := Round(LineBase * SvcInvLineTmp."VAT %" / 100, 0.1);
                        TotalVAT += LineVAT;
                        TotalInclVAT += LineBase + LineVAT;

                    until SvcInvLineTmp.Next() = 0;
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
                    field(ShowSeal; ShowSeal)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Seal';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        if not CompanyInfo.Get() then
            CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
        FormatAddress: Codeunit "Format Address";
        ShowSeal: Boolean;

        PaymentBank: array[3] of Text[50];
        CustAddr: array[8] of Text[90];
        CompanyAddr: array[8] of Text[90];

        CompanyRegistrationLine: Text[100];
        DocumentDateTxt: Text[50];

        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;

        VatSummaryDict: Dictionary of [Decimal, Decimal];
        VatPctList: List of [Decimal];

        VATDisplayTxt: Text[20];
        VATBaseAmount: Decimal;
        VATAmount: Decimal;

        PaymentTermText: Text[100];
        PaymentMethodText: Text[100];
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";

    // -------------------------
    // Bill-to address + TEL/FAX
    // -------------------------
    local procedure FillServiceInvBillTo(var Addr: array[8] of Text[90]; Hdr: Record "Service Invoice Header")
    var
        C: Record Customer;
        Tmp: array[8] of Text[100];
        i: Integer;
        TelTxt: Text[80];
        FaxTxt: Text[80];
    begin
        Clear(Addr);

        if (Hdr."Bill-to Customer No." = '') then
            exit;

        if not C.Get(Hdr."Bill-to Customer No.") then
            exit;

        FormatAddress.Customer(Tmp, C);
        for i := 1 to 8 do
            Addr[i] := CopyStr(Tmp[i], 1, MaxStrLen(Addr[i]));

        TelTxt := '';
        FaxTxt := '';

        if C."Phone No." <> '' then
            TelTxt := 'TEL: ' + C."Phone No.";

        if C."Fax No." <> '' then
            FaxTxt := 'FAX: ' + C."Fax No.";

        Addr[7] := CopyStr(TelTxt, 1, MaxStrLen(Addr[7]));
        Addr[8] := CopyStr(FaxTxt, 1, MaxStrLen(Addr[8]));
    end;

    // -------------------------
    // Bank (Company Info only)
    // -------------------------
    local procedure FillPaymentBankFromCompanyInfo()
    begin
        Clear(PaymentBank);
        PaymentBank[1] := CompanyInfo."Bank Name";
        PaymentBank[2] := CompanyInfo."Bank Branch No.";
        PaymentBank[3] := CompanyInfo."Bank Account No.";
    end;

    local procedure ClearTrailingAddressLines()
    var
        i: Integer;
    begin
        for i := 6 to 8 do begin
            CustAddr[i] := CustAddr[i];
            CompanyAddr[i] := '';
        end;
    end;

    // -------------------------
    // VAT summary helpers
    // -------------------------
    local procedure AddOrUpdateVatSummary(VatPct: Decimal; VatBase: Decimal)
    var
        CurrBase: Decimal;
    begin
        if VatBase = 0 then
            exit;

        if VatSummaryDict.ContainsKey(VatPct) then begin
            VatSummaryDict.Get(VatPct, CurrBase);
            CurrBase += VatBase;
            VatSummaryDict.Set(VatPct, CurrBase);

        end else begin
            VatSummaryDict.Add(VatPct, VatBase);
            InsertSortedVatPct(VatPct);
        end;

    end;

    local procedure InsertSortedVatPct(VatPct: Decimal)
    var
        i: Integer;
        Curr: Decimal;
    begin
        for i := 1 to VatPctList.Count() do begin
            VatPctList.Get(i, Curr);
            if VatPct < Curr then begin
                VatPctList.Insert(i, VatPct);
                exit;
            end;
            if VatPct = Curr then
                exit;
        end;
        VatPctList.Add(VatPct);
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

    local procedure GetYesNo(ValueBool: Boolean): Text[3]
    begin
        if ValueBool then
            exit('Yes')
        else
            exit('No');
    end;
}
