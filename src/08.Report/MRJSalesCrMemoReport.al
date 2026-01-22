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
            column(OrderNo; "No.") { }                                      // 受注番号
            column(IssueDate; IssueDate) { }                                // 2018年06月25日 (formatted)
            column(ExternalDocumentNo; "External Document No.") { }         // 御注文番号
            column(DocumentNo; "No.") { }                                   // 内部管理用受注番号

            // 支払条件 / 支払方法
            column(PaymentTermTxt; PaymentTermTxt) { }
            column(PaymentMethodTxt; PaymentMethodTxt) { }

            // Customer address (left)
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CustAddr7; CustAddr[7]) { }
            column(CustAddr8; CustAddr[8]) { }
            column(CustPostCode; "Sell-to Post Code") { }                   // 顧客郵便番号
            column(CustNo; "Sell-to Customer No.") { }                      // 顧客コード

            // Company address (right)
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }
            column(CompanyFaxNo; CompanyInfo."Fax No.") { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(Sell_to_Contact; "Sell-to Contact") { }

            // Totals for bottom-right
            column(TotalExclVAT; TotalExclVAT) { }                          // 消費税抜合計
            column(TotalVAT; TotalVAT) { }                                  // 消費税
            column(TotalInclVAT; TotalInclVAT) { }                          // 消費税込合計

            // ==== Detail lines (品名 / 数量 / 単位 / 単価 / 金額) ====
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLinkReference = "Sales Cr.Memo Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo_; "No.") { }
                column(LineDescription; Description) { }                    // 品名
                column(LineDescription2; "Description 2") { }               // (optional)
                column(LineQuantity; Quantity) { }                          // 数量
                column(LineUOM; "Unit of Measure Code") { }                 // 単位
                column(LineUnitPrice; "Unit Price") { }                     // 単価
                column(LineAmount; "Line Amount") { }                       // 金額
                column(Type_Line; Type) { }                                 // RDLC conditions if needed
            }

            // ==== VAT Summary (dynamic via Integer) ====
            dataitem(VATSummary; Integer)
            {
                DataItemTableView = sorting(Number);

                // ① 非課税 / xx%対象
                column(VATDisplayTxt; VATDisplayTxt) { }
                // ② 課税対象額（税抜）
                column(VATBaseAmount; VATBaseAmount) { }
                // ③ 消費税（ラベル）
                column(VATLabelTxt; '消費税') { }
                // ④ 消費税額
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

                    // VAT amount per rate (round to 1 decimal place as requested)
                    VATAmount := Round(VATBaseAmount * VatPct / 100, 0.1);
                end;
            }

            // ==== 摘要 / コメント ====
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
                // ----- Date (JP format) -----
                IssueDate := Format("Posting Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                // ----- Customer address -----
                Clear(CustAddr);
                if Customer.Get("Sell-to Customer No.") then
                    FormatAddr.Customer(CustAddr, Customer)
                else
                    Clear(CustAddr);

                // ----- Company address -----
                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);

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

                // ----- Totals + VAT Summary from posted credit memo lines -----
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
                        // Totals
                        TotalExclVAT += CrMemoLineTmp."Line Amount";
                        TotalInclVAT += CrMemoLineTmp."Amount Including VAT";

                        // VAT Summary base by VAT %
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

    var
        CompanyInfo: Record "Company Information";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        FormatAddr: Codeunit "Format Address";
        Customer: Record Customer;

        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];

        IssueDate: Text[50];
        PaymentTermTxt: Text[100];
        PaymentMethodTxt: Text[100];

        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;

        // VAT Summary
        VatPctList: List of [Decimal];
        VatSummaryDict: Dictionary of [Decimal, Decimal];

        VATDisplayTxt: Text[30];
        VATBaseAmount: Decimal;
        VATAmount: Decimal;
}
