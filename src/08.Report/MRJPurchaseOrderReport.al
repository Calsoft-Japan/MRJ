report 50018 "MRJ Purchase Order (JP)"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Purchase Order (JP)';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJPurchaseOrderReport_N.rdlc';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.";

            // ===== Header =====
            column(PurchaseOrderNo; "No.") { }                      // 発注書番号
            column(OrderDate; OrderDateParam) { }                   // 注文年月日

            //column(ExternalDocumentNo; "Vendor Order No.") { }    // optional 

            // 希望納期 / 支払方法
            column(RequestedReceiptDate; "Requested Receipt Date") { } // 希望納期
            column(PaymentTermTxt; PaymentTermTxt) { }                 // 支払条件(説明)
            column(PaymentMethodTxt; PaymentMethodTxt) { }             // 支払方法(説明 or 空)

            // ===== Vendor address (left block) =====
            column(VendorAddr1; VendAddr[1]) { }   // Name
            column(VendorAddr2; VendAddr[2]) { }   // Name 2 (if any)
            column(VendorAddr3; VendAddr[3]) { }   // Address 1
            column(VendorAddr4; VendAddr[4]) { }   // Address 2
            column(VendorAddr5; VendAddr[5]) { }   // City/County etc (depends on FormatAddr)
            column(VendorAddr6; VendAddr[6]) { }   // Post code etc (depends on FormatAddr)
            column(VendorPostCode; "Buy-from Post Code") { } // if you prefer direct
            column(VendorTel; VendorTelTxt) { }
            column(VendorFax; VendorFaxTxt) { }

            // ===== Company address (right block) =====
            column(CompanyName; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }

            // TEL/FAX (RC first; fallback CompanyInfo) -> "No. / No. 2"
            column(CompanyTelLine; CompanyTelTxt) { }
            column(CompanyFaxLine; CompanyFaxTxt) { }

            // 担当者 
            column(Purchaser; AssignedUserName) { }

            // Registration No. (optional)
            column(CompanyRegistrationLine; CompanyRegistrationLine) { }

            // ===== Ship-to block (bottom-left in sample) =====
            column(ShipToAddr1; ShipToAddr[1]) { }  // 出荷先住所: name
            column(ShipToAddr2; ShipToAddr[2]) { }
            column(ShipToAddr3; ShipToAddr[3]) { }
            column(ShipToAddr4; ShipToAddr[4]) { }
            column(ShipToAddr5; ShipToAddr[5]) { }
            column(ShipToAddr6; ShipToAddr[6]) { }
            column(ShipToTelLine; ShipToTelTxt) { }
            column(ShipToFaxLine; ShipToFaxTxt) { }

            // ===== Totals =====
            column(TotalExclVAT; TotalExclVAT) { }     // 消費税抜合計
            column(TotalVAT; TotalVAT) { }             // 消費税
            column(TotalInclVAT; TotalInclVAT) { }     // 消費税込合計

            // ===== Lines =====
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document Type" = field("Document Type"),
                               "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(ItemNo; "No.") { }                    // 品番
                column(LineDescription; Description) { }      // 品名
                column(LineDescription2; "Description 2") { }
                column(LineQuantity; Quantity) { }            // 数量
                column(LineUOM; "Unit of Measure Code") { }   // 単位
                column(LineUnitCost; "Direct Unit Cost") { }  // 単価 (PO is usually unit cost)
                column(LineAmount; "Line Amount") { }         // 金額
                column(Type_Line; Type) { }
            }

            // ===== VAT Summary (optional; if you have a VAT breakdown section) =====
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

            trigger OnAfterGetRecord()
            var
                RespCenter: Record "Responsibility Center";
                PurchLineTmp: Record "Purchase Line";
                VendorRec: Record Vendor;
                UserRec: Record User;
                VatPct: Decimal;
                BaseAmt: Decimal;
            begin
                // ----- Company Info -----
                if not CompanyInfo.Get() then
                    CompanyInfo.Get();

                // ----- Company JP block (RC first; fallback Company Info) -----
                Clear(CompanyAddr);
                if ("Responsibility Center" <> '') and RespCenter.Get("Responsibility Center") then
                    FormatAddr.RespCenter(CompanyAddr, RespCenter)
                else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                // ----- Company TEL/FAX -----
                CompanyTelTxt := '';
                CompanyFaxTxt := '';
                if ("Responsibility Center" <> '') and RespCenter.Get("Responsibility Center") then begin
                    CompanyTelTxt := BuildContactTxt('TEL', RespCenter."Phone No.", RespCenter."Phone No. 2");
                    CompanyFaxTxt := BuildContactTxt('FAX', RespCenter."Fax No.", RespCenter."Fax No. 2");
                end else begin
                    CompanyTelTxt := BuildContactTxt('TEL', CompanyInfo."Phone No.", CompanyInfo."Phone No. 2");
                    //CompanyFaxTxt := BuildContactTxt('FAX', CompanyInfo."Fax No.", CompanyInfo."Fax No. 2");
                end;

                // ----- Vendor address block (left) -----
                Clear(VendAddr);
                VendorTelTxt := '';
                VendorFaxTxt := '';

                if VendorRec.Get("Buy-from Vendor No.") then begin
                    FormatAddr.Vendor(VendAddr, VendorRec);
                    VendorTelTxt := BuildContactTxt('Tel.', VendorRec."Phone No.", '');
                    VendorFaxTxt := BuildContactTxt('Fax.', VendorRec."Fax No.", '');
                end;

                // ----- 担当者（Assigned User ID -> User Name） -----
                AssignedUserName := '';
                if ("Assigned User ID" <> '') and UserRec.Get("Assigned User ID") then
                    AssignedUserName := UserRec."Full Name";

                // ----- Payment terms/method -----
                PaymentTermTxt := '';
                if "Payment Terms Code" <> '' then
                    if PaymentTerms.Get("Payment Terms Code") then
                        PaymentTermTxt := PaymentTerms.Description;

                PaymentMethodTxt := '';
                if "Payment Method Code" <> '' then
                    if PaymentMethod.Get("Payment Method Code") then
                        PaymentMethodTxt := PaymentMethod.Description;

                // Registration line
                CompanyRegistrationLine := BuildRegistrationLine();

                // ----- Ship-to (出荷先住所) -----
                BuildShipToBlock("Purchase Header");

                // ----- Totals + VAT Summary -----
                TotalExclVAT := 0;
                TotalInclVAT := 0;
                TotalVAT := 0;

                Clear(VatPctList);
                Clear(VatSummaryDict);

                PurchLineTmp.Reset();
                PurchLineTmp.SetRange("Document Type", "Document Type");
                PurchLineTmp.SetRange("Document No.", "No.");
                PurchLineTmp.SetFilter(Type, '<>%1', PurchLineTmp.Type::" ");

                if PurchLineTmp.FindSet() then
                    repeat
                        TotalExclVAT += PurchLineTmp."Line Amount";
                        TotalInclVAT += PurchLineTmp."Amount Including VAT";

                        VatPct := PurchLineTmp."VAT %";
                        BaseAmt := PurchLineTmp."VAT Base Amount";

                        if not VatSummaryDict.ContainsKey(VatPct) then begin
                            VatSummaryDict.Add(VatPct, BaseAmt);
                            VatPctList.Add(VatPct);
                        end else
                            VatSummaryDict.Set(VatPct, VatSummaryDict.Get(VatPct) + BaseAmt);

                    until PurchLineTmp.Next() = 0;

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
                    field(OrderDateParam; OrderDateParam)
                    {
                        ApplicationArea = All;
                        Caption = '注文年月日';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            OrderDateParam := WorkDate();
        end;
    }

    var
        CompanyInfo: Record "Company Information";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        FormatAddr: Codeunit "Format Address";

        VendAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];

        ShipToAddr: array[8] of Text[100];
        ShipToTelTxt: Text[100];
        ShipToFaxTxt: Text[100];

        VendorTelTxt: Text[100];
        VendorFaxTxt: Text[100];

        CompanyTelTxt: Text[100];
        CompanyFaxTxt: Text[100];

        AssignedUserName: Text[100];

        OrderDateParam: Date;

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

        exit(LabelTxt + ' ' + ResultTxt);
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

    local procedure BuildShipToBlock(PurchHeader: Record "Purchase Header")
    var
        // uses fields on Purchase Header
        ShipName: Text[100];
        ShipName2: Text[100];
        ShipAddr: Text[100];
        ShipAddr2: Text[100];
        ShipPostCode: Code[20];
        ShipCity: Text[30];
        ShipCounty: Text[30];
    begin
        Clear(ShipToAddr);
        ShipToTelTxt := '';
        ShipToFaxTxt := '';

        // If Ship-to Code is used, these fields are usually populated on header.
        ShipName := PurchHeader."Ship-to Name";
        ShipName2 := PurchHeader."Ship-to Name 2";
        ShipAddr := PurchHeader."Ship-to Address";
        ShipAddr2 := PurchHeader."Ship-to Address 2";
        ShipPostCode := PurchHeader."Ship-to Post Code";
        ShipCity := PurchHeader."Ship-to City";
        ShipCounty := PurchHeader."Ship-to County";

        // Minimal JP-style lines (adjust to your RDLC needs)
        ShipToAddr[1] := ShipName;
        ShipToAddr[2] := ShipName2;
        ShipToAddr[3] := ShipAddr;
        ShipToAddr[4] := ShipAddr2;

        if ShipPostCode <> '' then
            ShipToAddr[5] := '〒' + ShipPostCode;

        if (ShipCity <> '') or (ShipCounty <> '') then
            ShipToAddr[6] := ShipCounty + ShipCity;

        // If you store ship-to phone/fax in custom fields, set them here.
        // (Standard Purchase Header does not always have Ship-to Phone/Fax fields.)
    end;
}
