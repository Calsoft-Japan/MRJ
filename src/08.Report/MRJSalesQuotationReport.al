report 50011 "MRJ Sales Quotation"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Sales Quotation (JP)';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJSalesQuotationReport.rdlc';
    dataset
    {

        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.")
                                where("Document Type" = const(Quote));
            RequestFilterFields = "No.", "Sell-to Customer No.";

            column(CurrencySymbol; GetCurrencySymbol()) { }

            // ==== Header fields ====
            column(QuoteNo; "No.") { }                         // 見積書番号
            column(QuoteDateTxt; QuoteDateTxt) { }             // 見積日 (2018年03月30日)
            column(TitleTxt; TitleTxt) { }                     // 御見積書（or 御見積書 兼 注文書）
            column(ShowOrderInfoHdr; ShowOrderInfo) { }           // (for internal use only)


            column(SellToCustomerNo; "Sell-to Customer No.") { }
            column(DocumentNo; "No.") { }

            // 担当者 / 支払条件 / 有効期限
            column(SalesPersonTxt; SalesPersonTxt) { }
            column(PaymentTermTxt; PaymentTermTxt) { }
            column(ExpirationDateTxt; ExpirationDateTxt) { }

            // Customer address (left)
            column(CustAddr; "Sell-to Address") { }
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CustAddr7; CustAddr[7]) { }
            column(CustAddr8; CustAddr[8]) { }
            column(CustPostCode; "Sell-to Post Code") { }     // 顧客郵便番号
            column(CustNo; "Sell-to Customer No.") { }   // 顧客コード

            // Company address (right)
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }
            column(CompanyFaxNo; CompanyInfo."Fax No.") { }   // 会社FAX番号
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { } // 会社電話番号
            column(SalesPersonName; SalesPersonTxt) { }        // 担当者名
            column(SellToContactTxt; SellToContactTxt) { }         // 請求先担当者

            // Totals for bottom-right
            column(TotalExclVAT; TotalExclVAT) { }             // 消費税抜合計
            column(TotalVAT; TotalVAT) { }                     // 消費税
            column(TotalInclVAT; TotalInclVAT) { }             // 消費税込合計

            // ==== Detail lines (品名 / 数量 / 単位 / 単価 / 金額) ====
            dataitem(SalesLine; "Sales Line")
            {
                DataItemLinkReference = SalesHeader;
                DataItemLink = "Document Type" = field("Document Type"),
                               "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(LineNo_; "No.") { }
                column(LineDescription; Description) { }     // 品名
                column(LineQuantity; Quantity) { }           // 数量
                column(LineUOM; "Unit of Measure Code") { }  // 単位
                column(LineUnitPrice; "Unit Price") { }      // 単価
                column(LineAmount; "Line Amount") { }        // 金額
                column(Type_Line; Type) { }
                column(ShowOrderInfo; ShowOrderInfo) { }
                column(TypeText; Format(Type)) { }
                column(TypeInt; Type.AsInteger()) { }
                column(LineNoInt; "Line No.") { }
            }

            // ==== 摘要 ====
            dataitem(SalesCommentLine; "Sales Comment Line")
            {
                DataItemLinkReference = SalesHeader;
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("Document Type", "No.", "Line No.")
                        where("Document Line No." = const(0));

                column(CommentText; Comment) { }
                column(CommentNo; "No.") { } // debug (optional)

                trigger OnPreDataItem()
                begin
                    SetRange("Document Type", "Document Type"::Quote);
                end;
            }


            trigger OnAfterGetRecord()
            var
                SalesLineTmp: Record "Sales Line";
            begin
                // ----- Title & dates -----
                if ShowOrderInfo then
                    TitleTxt := '御 見 積 書 兼 注 文 書'
                else
                    TitleTxt := '御 見 積 書';

                QuoteDateTxt := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                if "Quote Valid Until Date" <> 0D then
                    ExpirationDateTxt := Format("Quote Valid Until Date", 0, '<Year4>年<Month,2>月<Day,2>日')
                else
                    ExpirationDateTxt := '';

                // ----- Addresses -----
                Clear(CustAddr);
                Clear(CompanyAddr);

                FormatAddr.SalesHeaderSellTo(CustAddr, SalesHeader);
                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                if Customer.Get("Sell-to Customer No.") then begin
                    if Customer."NameTitle" <> '' then
                        CustAddr[1] := CustAddr[1] + ' ' + Customer."NameTitle";

                    SellToContactTxt := "Sell-to Contact";
                    if (SellToContactTxt <> '') and (Customer."ContactTitle" <> '') then
                        SellToContactTxt := SellToContactTxt + ' ' + Customer."ContactTitle";
                end else
                    SellToContactTxt := "Sell-to Contact";

                // ----- Salesperson -----
                if "Salesperson Code" <> '' then begin
                    SalesPerson.Get("Salesperson Code");
                    SalesPersonTxt := SalesPerson.Name;
                end else
                    SalesPersonTxt := '';

                // ----- Payment terms -----
                if "Payment Terms Code" <> '' then begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTermTxt := PaymentTerms.Description;
                end else
                    PaymentTermTxt := '';

                // ----- Totals from lines -----
                TotalExclVAT := 0;
                TotalInclVAT := 0;
                TotalVAT := 0;

                SalesLineTmp.Reset();
                SalesLineTmp.SetRange("Document Type", "Document Type");
                SalesLineTmp.SetRange("Document No.", "No.");
                if SalesLineTmp.FindSet() then
                    repeat
                        TotalExclVAT += SalesLineTmp."Line Amount";
                        TotalInclVAT += SalesLineTmp."Amount Including VAT";
                    until SalesLineTmp.Next() = 0;

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
                    field(ShowOrderInfo; ShowOrderInfo)
                    {
                        ApplicationArea = All;
                        Caption = 'Show order information';
                    }
                }
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        SalesPerson: Record "Salesperson/Purchaser";
        PaymentTerms: Record "Payment Terms";
        FormatAddr: Codeunit "Format Address";

        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        Customer: Record Customer;
        SellToContactTxt: Text[20];

        TitleTxt: Text[50];
        QuoteDateTxt: Text[50];
        ExpirationDateTxt: Text[50];
        SalesPersonTxt: Text[50];
        PaymentTermTxt: Text[100];

        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;
        ShowOrderInfo: Boolean; // from requestpage (used in later requirement)//

    local procedure GetCurrencySymbol(CurrCode: Code[10]): Text[10]
    begin
        // LCY only
        if (CurrCode = '') or (CurrCode = 'JPY') then
            exit('¥');

        // FCY → no symbol
        exit('');
    end;
}

