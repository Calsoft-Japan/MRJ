report 50018 "MRJ Purchase Order (JP)"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Purchase Order (JP)';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJPurchaseOrderReportN.rdlc';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.";

            // Header
            column(Currency_Code; "Currency Code") { }
            column(PurchaseOrderNo; "No.") { }
            column(Order_Date; "Order Date") { }
            column(Document_Date; "Document Date") { }

            column(RequestedReceiptDate; "Requested Receipt Date") { }
            column(PaymentTermTxt; PaymentTermTxt) { }
            column(PaymentMethodTxt; PaymentMethodTxt) { }

            // Vendor address
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

            // Company address
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }

            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyFaxNo; CompanyInfo."Fax No.") { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }

            // ---- English Company Info ----//
            column(CompanyNameEN; CompanyInfo."English Name TJP") { }
            column(CompanyAddrEN2; CompanyInfo."English Address TJP") { }
            column(CompanyAddrEN3; CompanyInfo."English Address 2 TJP") { }

            column(CompanyTelLine; CompanyTelTxt) { }
            column(CompanyFaxLine; CompanyFaxTxt) { }

            // Purchaser
            column(Purchaser; PurchaserName) { }

            // Ship-to block
            column(ShipToAddr1; "Ship-to Name") { }
            column(ShipToAddr2; "Ship-to Name 2") { }
            column(ShipToAddr3; "Ship-to Address") { }
            column(ShipToAddr4; "Ship-to Address 2") { }
            column(ShipToAddr5; "Ship-to Post Code") { }
            column(ShipToAddr6; "Ship-to County" + "Ship-to City") { }
            column(ShipToTelLine; "Ship-to Phone No.") { }

            // Totals
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document Type" = field("Document Type"),
                               "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(ItemNo; "No.") { }
                column(LineDescription; Description) { }
                column(LineDescription2; "Description 2") { }
                column(LineQuantity; Quantity) { }
                column(LineUOM; "Unit of Measure") { }
                column(LineUnitCost; "Direct Unit Cost") { }
                column(LineAmount; "Line Amount") { }
                column(Type_Line; Type) { }
            }

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
                PurchLineTmp: Record "Purchase Line";
                VendorRec: Record Vendor;
                VatPct: Decimal;
                BaseAmt: Decimal;
            begin
                // Company Information
                CompanyInfo.Get();
                Clear(CompanyAddr);
                FormatAddr.Company(CompanyAddr, CompanyInfo);



                // Vendor
                Clear(VendAddr);
                Clear(VendorPostCodeLine);
                Clear(VendorContactTxt);
                Clear(VendorTelTxt);
                Clear(VendorFaxTxt);

                if VendorRec.Get("Buy-from Vendor No.") then begin
                    FormatAddr.Vendor(VendAddr, VendorRec);

                    if VendorRec."Post Code" <> '' then
                        VendorPostCodeLine := '〒' + VendorRec."Post Code"
                    else
                        if "Buy-from Post Code" <> '' then
                            VendorPostCodeLine := '〒' + "Buy-from Post Code";

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
                    VendAddr[2] := "Buy-from Address";
                    VendAddr[3] := "Buy-from Address 2";

                    // add NameTitle to vendor/company name
                    if VendorRec."NameTitle" <> '' then
                        VendAddr[1] := VendAddr[1] + ' ' + VendorRec."NameTitle";

                    // add ContactTitle to contact name
                    if (VendorContactTxt <> '') and (VendorRec."ContactTitle" <> '') then
                        VendorContactTxt := VendorContactTxt + ' ' + VendorRec."ContactTitle";
                end;

                // Purchaser
                Clear(PurchaserName);
                if ("Purchaser Code" <> '') and SalespersonPurchaser.Get("Purchaser Code") then
                    PurchaserName := SalespersonPurchaser.Name;

                // Payment terms
                Clear(PaymentTermTxt);
                if ("Prepmt. Payment Terms Code" <> '') and PaymentTerms.Get("Prepmt. Payment Terms Code") then
                    PaymentTermTxt := PaymentTerms.Description;

                // Payment method
                Clear(PaymentMethodTxt);
                if ("Payment Method Code" <> '') and PaymentMethod.Get("Payment Method Code") then
                    PaymentMethodTxt := PaymentMethod.Description;

                // Ship-to
                BuildShipToBlock("Purchase Header");

                // Totals and VAT summary
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

                        if not VatSummaryDict.ContainsKey(VatPct) then begin
                            VatSummaryDict.Add(VatPct, BaseAmt);
                            VatPctList.Add(VatPct);
                        end else
                            VatSummaryDict.Set(VatPct, VatSummaryDict.Get(VatPct) + BaseAmt);

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
                        Caption = 'Order Date';
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
        ContactRec: Record Contact;

        VendAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];

        VendorTelTxt: Text[100];
        VendorFaxTxt: Text[100];
        CompanyTelTxt: Text[100];
        CompanyFaxTxt: Text[100];
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

        VendorPostCodeLine: Text[50];
        VendorContactTxt: Text[100];
        CompanyNameEN: Text[100];
        CompanyAddrEN: Text[100];

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

    local procedure BuildShipToBlock(PurchHeader: Record "Purchase Header")
    var
        ShipName: Text[100];
        ShipName2: Text[100];
        ShipAddr: Text[100];
        ShipAddr2: Text[100];
        ShipPostCode: Code[20];
        ShipCity: Text[30];
        ShipCounty: Text[30];
    begin
        Clear(ShipToAddr);

        ShipName := PurchHeader."Ship-to Name";
        ShipName2 := PurchHeader."Ship-to Name 2";
        ShipAddr := PurchHeader."Ship-to Address";
        ShipAddr2 := PurchHeader."Ship-to Address 2";
        ShipPostCode := PurchHeader."Ship-to Post Code";
        ShipCity := PurchHeader."Ship-to City";
        ShipCounty := PurchHeader."Ship-to County";

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