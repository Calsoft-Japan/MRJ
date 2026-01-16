report 50014 "MRJ Sales Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Sales Invoice';
    DefaultLayout = RDLC;

    RDLCLayout = 'src\07.ReportLayout\MRJSalesInvoiceReport.rdlc';

    dataset
    {
        dataitem(SalesInvHdr; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Bill-to Customer No.";

            // ---- Dates ----
            column(OutputDateTxt; OutputDateTxt) { }              // 発行日（Issue Date text）
            column(PostingDate; "Posting Date") { }               // 伝票日付

            // ---- Identifiers ----
            column(BillToCustomerNo; "Bill-to Customer No.") { }  // 請求先得意先番号
            column(OrderNo; "Order No.") { }                      // 受注番号（必要に応じて）

            // ---- Customer (Left header block) ----
            column(CustName; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }

            // ---- Company (Right header block) ----
            column(CompanyName; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(Sell_to_Post_Code; "Sell-to Post Code") { }

            // ---- Registration No. ----
            column(CompanyRegistrationLine; CompanyRegistrationLine) { } // "登録番号：{Registration No.}"

            // ---- Payment Bank block (銀行口座) ----
            column(PaymentBankName; PaymentBank[1]) { }      // 例：みずほ銀行
            column(PaymentBankBranch; PaymentBank[2]) { }    // 例：大手町営業部
            column(PaymentBankAccount; PaymentBank[3]) { }   // 例：当座預金 0099673

            // ---- Totals (optional: if you want header totals) ----
            column(TotalExclVAT; TotalExclVAT) { }           // 税抜合計（VAT Base Amount合計）
            column(TotalVAT; TotalVAT) { }                   // 消費税合計（0.1丸め）
            column(TotalInclVAT; TotalInclVAT) { }           // 税込合計

            // Qualified invoice requirement
            column(CompanyRegistrationNo; CompanyInfo."VAT Registration No.") { }

            // =========================
            // Detail lines (Posted)
            // =========================
            dataitem(SalesInvLine; "Sales Invoice Line")
            {
                DataItemLinkReference = SalesInvHdr;
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo; "Line No.") { }
                column(LineType; Type) { }
                column(LineDescription; Description) { }
                column(LineQuantity; Quantity) { }
                column(LineUOM; "Unit of Measure Code") { }
                column(LineUnitPrice; "Unit Price") { }

                // Recommended for invoice: use posted base amount field
                column(LineAmountExclVAT; "VAT Base Amount") { } // 税抜金額（課税標準額）
                column(LineVATPct; "VAT %") { }                  // 税率

                // If your RDLC needs a “clean” amount instead of VAT Base Amount,
                // you can also expose Line Amount. (Uncomment if needed.)
                column(LineAmount; "VAT Base Amount") { }

                trigger OnAfterGetRecord()
                begin
                    // Keep dataset lightweight; invoice math uses posted fields.
                end;
            }

            // =========================
            // VAT Summary (dynamic via Integer)
            // =========================
            dataitem(VATSummary; Integer)
            {
                DataItemTableView = sorting(Number);

                column(VATDisplayTxt; VATDisplayTxt) { }      // 非課税 / xx%対象
                column(VATBaseAmount; VATBaseAmount) { }      // 課税対象額（税抜）
                column(VATLabelTxt; '消費税') { }             // 固定ラベル
                column(VATAmount; VATAmount) { }              // 税額（0.1丸め）

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
                        VATDisplayTxt := Format(VatPct) + '%対象';

                    VATBaseAmount := BaseDec;

                    // FDD: round to 1 decimal place
                    VATAmount := Round(VATBaseAmount * VatPct / 100, 0.1);
                end;
            }

            trigger OnAfterGetRecord()
            var
                RespCenter: Record "Responsibility Center";
                SalesInvLineTmp: Record "Sales Invoice Line";
                LineBase: Decimal;
                LineVAT: Decimal;
            begin
                // 1) Set report language from document language code (safe)
                //SetReportLanguageFromDoc();

                // 2) 発行日（Issue Date）text
                OutputDateTxt := FormatIssueDate(IssueDate, CurrReport.Language);

                // 3) Company address (Responsibility Center first; fallback to Company Info)
                Clear(CompanyAddr);

                if (SalesInvHdr."Responsibility Center" <> '') and RespCenter.Get(SalesInvHdr."Responsibility Center") then begin
                    FormatAddress.RespCenter(CompanyAddr, RespCenter);

                    // Optional: extra phone/fax lines
                    if RespCenter."Phone No. 2" <> '' then
                        CompanyAddr[6] := CompanyAddr[6] + ', ' + RespCenter."Phone No. 2";
                    if RespCenter."Fax No. 2" <> '' then
                        CompanyAddr[7] := CompanyAddr[7] + ', ' + RespCenter."Fax No. 2";

                    // Payment bank from Responsibility Center -> Bank Account
                    FillPaymentBankFromRespCenter(RespCenter);
                end else begin
                    FormatAddress.Company(CompanyAddr, CompanyInfo);
                    FillPaymentBankFromCompanyInfo();
                end;

                // 4) Customer Bill-to address on left
                Clear(CustAddr);
                FormatAddress.SalesInvBillTo(CustAddr, SalesInvHdr);

                // 5) Registration line: "登録番号：{Company Information.Registration No.}"
                CompanyRegistrationLine := BuildRegistrationLine();

                // 6) Clear trailing address lines (keep header tight)
                ClearTrailingAddressLines();

                // 7) Build VAT Summary + Totals from Posted Sales Invoice Line
                TotalExclVAT := 0;
                TotalVAT := 0;
                TotalInclVAT := 0;

                Clear(VatSummaryDict);
                Clear(VatPctList);

                SalesInvLineTmp.Reset();
                SalesInvLineTmp.SetRange("Document No.", "No.");

                if SalesInvLineTmp.FindSet() then
                    repeat
                        // Use posted values only
                        LineBase := SalesInvLineTmp."VAT Base Amount";
                        if LineBase = 0 then
                            continue;

                        TotalExclVAT += LineBase;

                        LineVAT := Round(LineBase * SalesInvLineTmp."VAT %" / 100, 0.1);
                        TotalVAT += LineVAT;
                        TotalInclVAT += LineBase + LineVAT;

                        AddOrUpdateVatSummary(SalesInvLineTmp."VAT %", LineBase);
                    until SalesInvLineTmp.Next() = 0;
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

    trigger OnInitReport()
    begin
        if not CompanyInfo.Get() then
            CompanyInfo.Get();
    end;

    // =========================
    // Vars
    // =========================
    var
        CompanyInfo: Record "Company Information";
        FormatAddress: Codeunit "Format Address";
        //Language: Codeunit "Language"; // If missing in your app, see fallback note below
        BankAccount: Record "Bank Account";

        PaymentBank: array[3] of Text[50];
        CustAddr: array[8] of Text[90];
        CompanyAddr: array[8] of Text[90];

        OutputDateTxt: Text[50];
        CompanyRegistrationLine: Text[100];
        IssueDate: Date;

        // Totals
        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;

        // VAT summary storage
        VatSummaryDict: Dictionary of [Decimal, Decimal]; // Key: VAT %, Value: summed base amount
        VatPctList: List of [Decimal];

        // VATSummary dataitem outputs
        VATDisplayTxt: Text[20];
        VATBaseAmount: Decimal;
        VATAmount: Decimal;

    // =========================
    // Helpers
    // =========================
    // local procedure SetReportLanguageFromDoc()
    // var
    //     LangId: Integer;
    // begin
    //     // Try to use document Language Code -> Language ID. Fallback to GlobalLanguage.
    //     LangId := 0;

    //     if SalesInvHdr."Language Code" <> '' then
    //         LangId := Language.GetLanguageId(SalesInvHdr."Language Code");

    //     if LangId <> 0 then
    //         CurrReport.Language := LangId
    //     else
    //         CurrReport.Language := GlobalLanguage;

    //     // If your environment does NOT have Codeunit "Language":
    //     // 1) remove "Language: Codeunit "Language";"
    //     // 2) replace this whole procedure with: CurrReport.Language := GlobalLanguage;
    // end;

    local procedure FormatIssueDate(IssDate: Date; LangId: Integer): Text[50]
    begin
        // JP: YYYY年MM月DD日, others: YYYY/MM/DD
        if LangId = 1041 then
            exit(StrSubstNo('%1年%2月%3日',
                Format(IssDate, 0, '<year4>'),
                Format(IssDate, 0, '<month,2>'),
                Format(IssDate, 0, '<day,2>')))
        else
            exit(Format(IssDate, 0, '<year4>/<month,2>/<day,2>'));
    end;


    local procedure FillPaymentBankFromCompanyInfo()
    begin
        Clear(PaymentBank);
        PaymentBank[1] := CompanyInfo."Bank Name";
        PaymentBank[2] := CompanyInfo."Bank Branch No.";
        PaymentBank[3] := CompanyInfo."Bank Account No.";
    end;

    local procedure FillPaymentBankFromRespCenter(RespCenter: Record "Responsibility Center")
    begin
        Clear(PaymentBank);

        if (RespCenter."Bank Account No." <> '') and BankAccount.Get(RespCenter."Bank Account No.") then begin
            // Standard fields
            PaymentBank[1] := BankAccount.Name;
            PaymentBank[2] := BankAccount."Bank Branch No.";
            PaymentBank[3] := BankAccount."Bank Account No.";
        end else
            FillPaymentBankFromCompanyInfo();
    end;

    local procedure ClearTrailingAddressLines()
    var
        i: Integer;
    begin
        // Remove unused tail lines to keep header tight
        for i := 6 to 8 do begin
            CustAddr[i] := '';
            CompanyAddr[i] := '';
        end;
    end;

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
        // Some JP setups use "Registration No.", others use "VAT Registration No."
        RegNo := CompanyInfo."Registration No.";
        if RegNo = '' then
            RegNo := CompanyInfo."VAT Registration No.";

        if RegNo = '' then
            exit(''); // return blank so RDLC can hide row

        exit('登録番号：' + RegNo);
    end;

}
