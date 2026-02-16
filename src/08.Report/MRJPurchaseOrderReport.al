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
            column(Currency_Code; "Currency Code") { }                       // 通貨コード
            column(PurchaseOrderNo; "No.") { }                              // 発注書番号
            column(Document_Date; "Document Date") { }                      // 注文年月日 

            // 希望納期 / 支払方法
            column(RequestedReceiptDate; "Requested Receipt Date") { } // 希望納期
            column(PaymentTermTxt; PaymentTermTxt) { }                 // 支払条件(説明)
            column(PaymentMethodTxt; PaymentMethodTxt) { }             // 支払方法(説明 or 空)

            // ===== Vendor address (left block) - from Vendor Card =====
            column(VendorAddr1; VendAddr[1]) { }
            column(VendorAddr2; VendAddr[2]) { }
            column(VendorAddr3; VendAddr[3]) { }
            column(VendorAddr4; VendAddr[4]) { }
            column(VendorAddr5; VendorPostCodeLine) { }
            column(VendorAddr6; VendAddr[6]) { }
            column(VendorAddr7; VendAddr[7]) { }
            column(VendorAddr8; VendAddr[8]) { }
            column(VendorContact; VendorContactTxt) { }


            column(VendorTel; VendorTelTxt) { }
            column(VendorFax; VendorFaxTxt) { }


            // ===== Company address (right block) =====
            column(CompanyName; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }

            // TEL/FAX (RC first; fallback CompanyInfo) -> "No. / No. 2"
            column(CompanyTelLine; CompanyTelTxt) { }
            column(CompanyFaxLine; CompanyFaxTxt) { }

            // 担当者 
            column(Purchaser; PurchaserName) { }        // Purchaser name

            // Registration No. (optional)
            //column(CompanyRegistrationLine; CompanyRegistrationLine) { }

            // ===== Ship-to block (bottom-left in sample) =====
            column(ShipToAddr1; "Ship-to Name") { }      // 出荷先住所: name
            column(ShipToAddr2; "Ship-to Post Code") { }
            column(ShipToAddr3; "Ship-to Address") { }
            column(ShipToAddr4; CompanyInfo."Phone No.") { }
            column(ShipToAddr5; CompanyInfo."Fax No.") { }

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

                column(ItemNo; "No.") { }                       // 品番
                column(LineDescription; Description) { }        // 品名
                column(LineDescription2; "Description 2") { }
                column(LineQuantity; Quantity) { }              // 数量
                column(LineUOM; "Unit of Measure") { }          // 単位
                column(LineUnitCost; "Direct Unit Cost") { }    // 単価 (PO is usually unit cost)
                column(LineAmount; "Line Amount") { }           // 金額
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
                    BaseDec: Decimal;
                begin
                    VatPctList.Get(Number, VatPct);
                    BaseDec := VatSummaryDict.Get(VatPct);

                    if VatPct = 0 then
                        VATDisplayTxt := '非課税'
                    else
                        VATDisplayTxt := Format(VatPct) + '%対象';

                    VATBaseAmount := BaseDec;
                    VATAmount := Round(VATBaseAmount * VatPct / 100, 0.01);
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

                if VendorRec.Get("Buy-from Vendor No.") then begin
                    FormatAddr.Vendor(VendAddr, VendorRec);

                    // Post Code: Vendor first, else header
                    if VendorRec."Post Code" <> '' then
                        VendorPostCodeLine := '〒' + VendorRec."Post Code"
                    else
                        if "Buy-from Post Code" <> '' then
                            VendorPostCodeLine := '〒' + "Buy-from Post Code";

                    // Contact: Header first, else Vendor's primary contact
                    if "Buy-from Contact" <> '' then
                        VendorContactTxt := "Buy-from Contact"
                    else begin
                        if (VendorRec."Primary Contact No." <> '') and ContactRec.Get(VendorRec."Primary Contact No.") then
                            VendorContactTxt := ContactRec.Name
                        else
                            VendorContactTxt := '';
                    end;

                    VendorTelTxt := BuildContactTxt('Tel.', VendorRec."Phone No.", '');
                    VendorFaxTxt := BuildContactTxt('Fax.', VendorRec."Fax No.", '');

                    VendAddr[1] := "Buy-from Vendor Name";
                    //VendAddr[2] := "Buy-from Vendor Name 2";
                    VendAddr[2] := "Buy-from Address";
                    VendAddr[3] := "Buy-from Address 2";
                end;

                // ----- 担当者（Purchaser Code -> Salesperson/Purchaser Name） -----                

                if ("Purchaser Code" <> '') then begin
                    PurchaserName := '';
                    if SalespersonPurchaser.Get("Purchaser Code") then
                        PurchaserName := SalespersonPurchaser.Name;
                end;

                // ----- Payment terms/method -----
                PaymentTermTxt := '';
                if "Prepmt. Payment Terms Code" <> '' then
                    if PaymentTerms.Get("Prepmt. Payment Terms Code") then
                        PaymentTermTxt := PaymentTerms.Description;

                PaymentMethodTxt := '';
                if "Payment Method Code" <> '' then
                    if PaymentMethod.Get("Payment Method Code") then
                        PaymentMethodTxt := PaymentMethod.Description;

                // ----- Ship-to (出荷先住所) -----
                BuildShipToBlock("Purchase Header");

                // ----- Totals + VAT Summary -----
                TotalExclVAT := 0;
                TotalVAT := 0;
                TotalInclVAT := 0;

                Clear(VatPctList);
                Clear(VatSummaryDict);

                PurchLineTmp.Reset();
                PurchLineTmp.SetRange("Document Type", "Document Type");
                PurchLineTmp.SetRange("Document No.", "No.");
                PurchLineTmp.SetFilter(Type, '<>%1', PurchLineTmp.Type::" ");

                if PurchLineTmp.FindSet() then
                    repeat
                        TotalExclVAT += PurchLineTmp."Line Amount";

                        VatPct := PurchLineTmp."VAT %";
                        BaseAmt := PurchLineTmp."VAT Base Amount";

                        // VAT Summary base per %
                        if not VatSummaryDict.ContainsKey(VatPct) then begin
                            VatSummaryDict.Add(VatPct, BaseAmt);
                            VatPctList.Add(VatPct);
                        end else
                            VatSummaryDict.Set(VatPct, VatSummaryDict.Get(VatPct) + BaseAmt);

                        // TotalVAT calculated from base * %
                        if VatPct <> 0 then
                            TotalVAT += Round(BaseAmt * VatPct / 100, 0.01);
                    until PurchLineTmp.Next() = 0;

                TotalInclVAT := TotalExclVAT + TotalVAT;

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
        SalespersonPurchaser: Record "Salesperson/Purchaser";
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
        PurchaserName: Text[100];

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
        VendorPostCodeLine: Text[50];
        VendorContactTxt: Text[100];
        ContactRec: Record Contact;

    local procedure BuildContactTxt(LabelTxt: Text; No1: Text; No2: Text): Text[100]
    var
        ResultTxt: Text[100];
    begin
        ResultTxt := '';

        if No1 <> '' then
            ResultTxt := No1;

        if No2 <> '' then begin
            if ResultTxt <> '' then
                ResultTxt += ', ' + No2
            else
                ResultTxt := No2;
        end;

        if ResultTxt = '' then
            exit('');

        exit(LabelTxt + ' ' + ResultTxt);
    end;

    // local procedure BuildRegistrationLine(): Text[100]
    // var
    //     RegNo: Text[50];
    // begin
    //     RegNo := CompanyInfo."Registration No.";
    //     if RegNo = '' then
    //         RegNo := CompanyInfo."VAT Registration No.";

    //     if RegNo = '' then
    //         exit('');

    //     exit('登録番号：' + RegNo);
    // end;

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
    end;
}
