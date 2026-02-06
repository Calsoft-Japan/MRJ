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

            // ===== Header =====
            column(OrderNo; "No.") { }
            column(IssueDate; IssueDate) { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(DocumentNo; "No.") { }

            // Payment
            column(PaymentTermTxt; PaymentTermTxt) { }
            column(PaymentMethodTxt; PaymentMethodTxt) { }

            // Customer address
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; "Bill-to Customer No.") { }
            column(CustAddr3; "Bill-to Address") { }
            column(CustAddr4; "Bill-to Address 2") { }
            column(CustAddr5; "Bill-to Post Code") { }
            column(CustAddr6; "Bill-to Contact") { }

            // Company (JP)
            column(CompanyName; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }

            // TEL / FAX (Responsibility Center only)
            column(TelLine; TelLine) { }
            column(FaxLine; FaxLine) { }

            // Registration
            column(CompanyRegistrationLine; CompanyRegistrationLine) { }

            // Totals
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }

            // ===== Lines =====
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

            // ===== VAT Summary =====
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
                begin
                    VatPctList.Get(Number, VatPct);
                    VATBaseAmount := VatSummaryDict.Get(VatPct);

                    if VatPct = 0 then
                        VATDisplayTxt := '非課税'
                    else
                        VATDisplayTxt := Format(VatPct) + '%対象';

                    VATAmount := Round(VATBaseAmount * VatPct / 100, 0.1);
                end;
            }

            trigger OnAfterGetRecord()
            var
                RespCenter: Record "Responsibility Center";
                LineTmp: Record "Sales Cr.Memo Line";
                VatPct: Decimal;
            begin
                // Customer address
                Clear(CustAddr);
                if Customer.Get("Bill-to Customer No.") then
                    FormatAddr.Customer(CustAddr, Customer);

                // Company JP address
                if not CompanyInfo.Get() then
                    CompanyInfo.Get();

                Clear(CompanyAddr);
                if ("Responsibility Center" <> '') and RespCenter.Get("Responsibility Center") then
                    FormatAddr.RespCenter(CompanyAddr, RespCenter)
                else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                // TEL / FAX (RC only)
                TelLine := BuildRespCenterComm(true, "Responsibility Center");
                FaxLine := BuildRespCenterComm(false, "Responsibility Center");

                // Payment
                if PaymentTerms.Get("Payment Terms Code") then
                    PaymentTermTxt := PaymentTerms.Description;
                if PaymentMethod.Get("Payment Method Code") then
                    PaymentMethodTxt := PaymentMethod.Description;

                // Registration
                CompanyRegistrationLine := BuildRegistrationLine();

                // Totals
                Clear(VatPctList);
                Clear(VatSummaryDict);
                TotalExclVAT := 0;
                TotalInclVAT := 0;

                LineTmp.SetRange("Document No.", "No.");
                LineTmp.SetFilter(Type, '<>%1', LineTmp.Type::" ");

                if LineTmp.FindSet() then
                    repeat
                        TotalExclVAT += LineTmp."Line Amount";
                        TotalInclVAT += LineTmp."Amount Including VAT";

                        VatPct := LineTmp."VAT %";
                        if not VatSummaryDict.ContainsKey(VatPct) then begin
                            VatSummaryDict.Add(VatPct, LineTmp."VAT Base Amount");
                            VatPctList.Add(VatPct);
                        end else
                            VatSummaryDict.Set(VatPct,
                                VatSummaryDict.Get(VatPct) + LineTmp."VAT Base Amount");
                    until LineTmp.Next() = 0;

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
                        Caption = '発行日';
                        ApplicationArea = All;
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
        CompanyInfo: Record "Company Information";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        FormatAddr: Codeunit "Format Address";
        Customer: Record Customer;

        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];

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

        TelLine: Text[250];
        FaxLine: Text[250];

    // ===== Helpers =====

    local procedure BuildRegistrationLine(): Text[100]
    var
        RegNo: Text[50];
    begin
        RegNo := CompanyInfo."Registration No.";
        if RegNo = '' then
            RegNo := CompanyInfo."VAT Registration No.";
        if RegNo <> '' then
            exit('登録番号：' + RegNo);
        exit('');
    end;

    local procedure BuildRespCenterComm(IsTel: Boolean; RcCode: Code[10]): Text[250]
    var
        RC: Record "Responsibility Center";
        V1: Text[100];
        V2: Text[100];
    begin
        if (RcCode = '') or (not RC.Get(RcCode)) then
            exit('');

        if IsTel then begin
            V1 := RC."Phone No.";
            V2 := RC."Phone No. 2";
            exit(AddPrefix('Tel. ', Join2(V1, V2)));
        end else begin
            V1 := RC."Fax No.";
            V2 := RC."Fax No. 2";
            exit(AddPrefix('Fax. ', Join2(V1, V2)));
        end;
    end;

    local procedure Join2(T1: Text; T2: Text): Text[250]
    begin
        if (T1 <> '') and (T2 <> '') then
            exit(T1 + '、' + T2);
        if T1 <> '' then
            exit(T1);
        if T2 <> '' then
            exit(T2);
        exit('');
    end;

    local procedure AddPrefix(Prefix: Text; Value: Text): Text[250]
    begin
        if Value <> '' then
            exit(Prefix + Value);
        exit('');
    end;
}
