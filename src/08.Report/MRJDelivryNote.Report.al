report 50027 "MRJ Delivery Note"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Sales Order Confirmation (JP)';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\08.Report\MRJDeliveryNoteReport.rdlc';

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.")
                                where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.";

            // ==== Header fields (align with sample) ====
            column(OrderNo; "No.") { }                          // 受注番号
            column(OrderDateTxt; OrderDateTxt) { }              // 2018年06月25日
            column(CustomerOrderNo; CustomerOrderNo) { }        // 御注文番号 (External Document No.)
            column(DocumentNo; "No.") { }                       // 内部管理用受注番号

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
            column(CustPostCode; "Sell-to Post Code") { }       // 顧客郵便番号
            column(CustNo; "Sell-to Customer No.") { }          // 顧客コード

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

            // Totals for bottom-right
            column(TotalExclVAT; TotalExclVAT) { }              // 消費税抜合計
            column(TotalVAT; TotalVAT) { }                      // 消費税
            column(TotalInclVAT; TotalInclVAT) { }              // 消費税込合計

            // ==== Detail lines (品名 / 数量 / 単位 / 単価 / 金額) ====
            dataitem(SalesLine; "Sales Line")
            {
                DataItemLinkReference = SalesHeader;
                DataItemLink = "Document Type" = field("Document Type"),
                               "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(LineNo_; "No.") { }
                column(LineDescription; Description) { }        // 品名
                column(LineQuantity; Quantity) { }              // 数量
                column(LineUOM; "Unit of Measure Code") { }     // 単位
                column(LineUnitPrice; "Unit Price") { }         // 単価
                column(LineAmount; "Line Amount") { }           // 金額
                column(Type_Line; Type) { }                     // for RDLC conditions if needed
                column(SalesPersonName; SalesPersonTxt) { }     // 担当者名

                trigger OnAfterGetRecord()
                begin
                    if Type = Type::" " then
                        CurrReport.Skip();
                end;
            }

            // ==== VAT Summary (非課税/8%対象/10%対象) ====
            dataitem(VATSummary; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 .. 3));

                column(VATDisplayTxt; VATDisplayTxt) { }
                column(VATBaseAmount; VATBaseAmount) { }
                column(VATLabelTxt; '消費税') { }
                column(VATAmount; VATAmount) { }

                trigger OnAfterGetRecord()
                begin
                    Clear(VATDisplayTxt);
                    VATBaseAmount := 0;
                    VATAmount := 0;

                    case Number of
                        1:
                            if VATBase_0 <> 0 then begin
                                VATDisplayTxt := '非課税';
                                VATBaseAmount := VATBase_0;
                            end else
                                CurrReport.Skip();

                        2:
                            if VATBase_8 <> 0 then begin
                                VATDisplayTxt := '8%対象';
                                VATBaseAmount := VATBase_8;
                                VATAmount := VATAmount_8;
                            end else
                                CurrReport.Skip();

                        3:
                            if VATBase_10 <> 0 then begin
                                VATDisplayTxt := '10%対象';
                                VATBaseAmount := VATBase_10;
                                VATAmount := VATAmount_10;
                            end else
                                CurrReport.Skip();
                    end;
                end;
            }

            // ==== 摘要 / コメント ====
            dataitem(SalesCommentLine; "Sales Comment Line")
            {
                DataItemLinkReference = SalesHeader;
                DataItemTableView = sorting("Document Type", "No.", "Document Line No.", "Line No.")
                                    where("Document Type" = const(Order));
                DataItemLink = "No." = field("No.");

                column(CommentText; Comment) { }
            }

            trigger OnAfterGetRecord()
            var
                SalesLineTmp: Record "Sales Line";
            begin
                // ----- Date -----
                OrderDateTxt := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                // ----- Customer order no -----
                CustomerOrderNo := "External Document No.";

                // ----- Addresses -----
                FormatAddr.SalesHeaderSellTo(CustAddr, SalesHeader);

                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                // ----- Payment terms -----
                if "Payment Terms Code" <> '' then begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTermTxt := PaymentTerms.Description;
                end else
                    PaymentTermTxt := '';

                // ----- Payment method -----
                if "Payment Method Code" <> '' then begin
                    PaymentMethod.Get("Payment Method Code");
                    PaymentMethodTxt := PaymentMethod.Description;
                end else
                    PaymentMethodTxt := '';

                // ----- Salesperson -----
                SalesPersonTxt := '';
                if "Salesperson Code" <> '' then begin
                    SalesPerson.Get("Salesperson Code");
                    SalesPersonTxt := SalesPerson.Name;
                end;

                // ----- Totals + VAT Summary from lines -----
                TotalExclVAT := 0;
                TotalInclVAT := 0;
                TotalVAT := 0;

                VATBase_0 := 0;
                VATBase_8 := 0;
                VATBase_10 := 0;

                SalesLineTmp.Reset();
                SalesLineTmp.SetRange("Document Type", "Document Type");
                SalesLineTmp.SetRange("Document No.", "No.");
                SalesLineTmp.SetFilter(Type, '<>%1', SalesLineTmp.Type::" ");

                if SalesLineTmp.FindSet() then
                    repeat
                        TotalExclVAT += SalesLineTmp."Line Amount";
                        TotalInclVAT += SalesLineTmp."Amount Including VAT";

                        case SalesLineTmp."VAT %" of
                            0:
                                VATBase_0 += SalesLineTmp."VAT Base Amount";
                            8:
                                VATBase_8 += SalesLineTmp."VAT Base Amount";
                            10:
                                VATBase_10 += SalesLineTmp."VAT Base Amount";
                        end;
                    until SalesLineTmp.Next() = 0;

                TotalVAT := TotalInclVAT - TotalExclVAT;

                // VAT amount (round to 1 decimal place)
                VATAmount_8 := Round(VATBase_8 * 0.08, 0.1);
                VATAmount_10 := Round(VATBase_10 * 0.10, 0.1);
            end;
        }
    }

    var
        CompanyInfo: Record "Company Information";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        SalesPerson: Record "Salesperson/Purchaser";
        FormatAddr: Codeunit "Format Address";

        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];

        OrderDateTxt: Text[50];
        CustomerOrderNo: Text[50];

        PaymentTermTxt: Text[100];
        PaymentMethodTxt: Text[100];

        SalesPersonTxt: Text[100];

        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;

        // --- VAT Summary ---
        VATBase_0: Decimal;
        VATBase_8: Decimal;
        VATBase_10: Decimal;

        VATAmount_8: Decimal;
        VATAmount_10: Decimal;

        VATDisplayTxt: Text[20];
        VATBaseAmount: Decimal;
        VATAmount: Decimal;
}
