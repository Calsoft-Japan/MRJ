report 50022 "MRJ Service Order Confirmation"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Service Order Confirmation (JP)';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJServiceOrderConfirmationReport.rdlc';

    dataset
    {
        dataitem(ServiceHeader; "Service Header")
        {
            DataItemTableView = sorting("Document Type", "No.")
                                where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Customer No.";

            // ==== Header fields ====
            column(OrderNo; "No.") { }                         // 受注番号
            column(OrderDateTxt; OrderDateTxt) { }             // 2018年06月25日
            column(CustomerOrderNo; CustomerOrderNo) { }       // 御注文番号 (Your Reference)
            column(DocumentNo; "No.") { }                      // 内部管理用受注番号

            // 支払条件 / 支払方法 / 担当者名
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
            column(CustPostCode; "Post Code") { }            // 顧客郵便番号
            column(CustNo; "Customer No.") { }               // 顧客コード    


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

            // Totals
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }

            // ==== Detail lines (Service Lines) ====
            dataitem(ServiceLine; "Service Line")
            {
                DataItemLinkReference = ServiceHeader;
                DataItemLink = "Document Type" = field("Document Type"),
                               "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(LineNo_; "No.") { }
                column(LineDescription; Description) { }        // 品名
                column(LineDescription2; "Description 2") { }   // (品名2)
                column(LineQuantity; Quantity) { }              // 数量
                column(LineUOM; "Unit of Measure Code") { }     // 単位
                column(LineUnitPrice; "Unit Price") { }         // 単価
                column(LineAmount; "Line Amount") { }           // 金額
                column(Type_Line; Type) { }                     // RDLC判定用
            }

            // ==== 摘要 / コメント (Service Comment Line) ====
            dataitem(ServiceCommentLine; "Service Comment Line")
            {
                DataItemLinkReference = ServiceHeader;
                DataItemLink = "Table Subtype" = field("Document Type"),
                               "No." = field("No.");
                DataItemTableView = sorting("Table Name", "Table Subtype", "No.", "Type", "Table Line No.", "Line No.")
                                    where("Table Name" = const("Service Header"));

                column(CommentText; Comment) { }
            }

            trigger OnAfterGetRecord()
            var
                ServiceLineTmp: Record "Service Line";
            begin
                // ----- Date -----
                OrderDateTxt := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                // ----- Customer order no -----
                CustomerOrderNo := "Your Reference"; // サービスヘッダーでは Your Reference を使用することが多いです

                // ----- Addresses -----
                CompanyInfo.Get();
                FormatAddr.ServiceHeaderSellTo(CustAddr, ServiceHeader);
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                // ----- Payment terms -----
                if "Payment Terms Code" <> '' then begin
                    if PaymentTerms.Get("Payment Terms Code") then
                        PaymentTermTxt := PaymentTerms.Description;
                end else
                    PaymentTermTxt := '';

                // ----- Payment method -----
                if "Payment Method Code" <> '' then begin
                    if PaymentMethod.Get("Payment Method Code") then
                        PaymentMethodTxt := PaymentMethod.Description;
                end else
                    PaymentMethodTxt := '';

                // ----- Totals from lines -----
                TotalExclVAT := 0;
                TotalInclVAT := 0;
                TotalVAT := 0;

                ServiceLineTmp.Reset();
                ServiceLineTmp.SetRange("Document Type", "Document Type");
                ServiceLineTmp.SetRange("Document No.", "No.");
                // 空行を除外
                ServiceLineTmp.SetFilter(Type, '<>%1', ServiceLineTmp.Type::" ");

                if ServiceLineTmp.FindSet() then
                    repeat
                        TotalExclVAT += ServiceLineTmp."Line Amount";
                        TotalInclVAT += ServiceLineTmp."Amount Including VAT";
                    until ServiceLineTmp.Next() = 0;

                TotalVAT := TotalInclVAT - TotalExclVAT;
            end;
        }
    }

    var
        CompanyInfo: Record "Company Information";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        OrderDateTxt: Text[50];
        CustomerOrderNo: Text[50];
        PaymentTermTxt: Text[100];
        PaymentMethodTxt: Text[100];
        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;
}