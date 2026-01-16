report 50027 "MRJ Delivery Note"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Sales Shipment (JP)';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJDeliveryNoteReport.rdlc';

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";

            // ==== Header fields ====
            column(ShipmentNo; "No.") { }
            column(PostingDateTxt; PostingDateTxt) { }
            column(ShipmentDateTxt; ShipmentDateTxt) { }
            column(OrderNo; "Order No.") { }
            column(CustomerOrderNo; CustomerOrderNo) { }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code") { }

            // Sell-to (right)
            column(Sell_to_Name; "Sell-to Customer Name") { }
            column(Sell_to_Customer_No; "Sell-to Customer No.") { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(Sell_to_Address_2; "Sell-to Address 2") { }
            column(Sell_to_City; "Sell-to City") { }
            column(Sell_to_Post_Code; "Sell-to Post Code") { }
            column(Sell_to_Phone_No; "Sell-to Phone No.") { }

            // Ship-to (left)
            column(Ship_to_Customer_No; "Ship-to Code") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }

            // Qualified invoice requirement
            column(CompanyRegistrationNo; CompanyInfo."VAT Registration No.") { }

            // Totals (for header)
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }

            // ==== Detail lines ====
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLinkReference = "Sales Shipment Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineDescription; Description) { }
                column(LineQuantity; Quantity) { }
                column(LineUOM; "Unit of Measure Code") { }
                column(LineUnitPrice; "Unit Price") { }

                // Tax-excl line amount used on Delivery Note (must match totals)
                column(LineAmountExclVAT; LineAmtExclVAT) { }

                trigger OnAfterGetRecord()
                begin
                    LineAmtExclVAT := CalcShipmentLineBase("Sales Shipment Line");
                end;
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
                    VatSummaryDict.Get(VatPct, BaseDec);

                    if VatPct = 0 then
                        VATDisplayTxt := '非課税'
                    else
                        VATDisplayTxt := Format(VatPct) + '%対象';

                    VATBaseAmount := BaseDec;

                    // VAT amount per rate (FDD: round to 1 decimal place)
                    VATAmount := Round(VATBaseAmount * VatPct / 100, 0.1);
                end;
            }

            trigger OnAfterGetRecord()
            var
                SalesShptLineTmp: Record "Sales Shipment Line";
                SalesHeader: Record "Sales Header";
                LineVAT: Decimal;
            begin
                PostingDateTxt := Format("Posting Date", 0, '<Year4>年<Month,2>月<Day,2>日');
                ShipmentDateTxt := Format("Shipment Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                CustomerOrderNo := '';
                if "Order No." <> '' then begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange("No.", "Order No.");
                    if SalesHeader.FindFirst() then
                        CustomerOrderNo := SalesHeader."External Document No.";
                end;

                TotalExclVAT := 0;
                TotalVAT := 0;
                TotalInclVAT := 0;

                Clear(VatSummaryDict);
                Clear(VatPctList);

                SalesShptLineTmp.Reset();
                SalesShptLineTmp.SetRange("Document No.", "No.");

                if SalesShptLineTmp.FindSet() then
                    repeat
                        // Only include real item lines in totals and VAT summary
                        if SalesShptLineTmp.Type <> SalesShptLineTmp.Type::Item then
                            continue;

                        if SalesShptLineTmp.Quantity = 0 then
                            continue;

                        LineBase := CalcShipmentLineBase(SalesShptLineTmp);
                        if LineBase = 0 then
                            continue;

                        TotalExclVAT += LineBase;

                        // For header totals, keep consistent rounding with VAT summary (0.1)
                        LineVAT := Round(LineBase * SalesShptLineTmp."VAT %" / 100, 0.1);

                        TotalVAT += LineVAT;
                        TotalInclVAT += LineBase + LineVAT;

                        AddOrUpdateVatSummary(SalesShptLineTmp."VAT %", LineBase);

                    until SalesShptLineTmp.Next() = 0;
            end;
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        GLSetup.Get();

        AmountPrecision := GLSetup."Amount Rounding Precision";
        if AmountPrecision = 0 then
            AmountPrecision := 1; // safe default (JPY)
    end;

    // ===== Helpers =====

    local procedure CalcShipmentLineBase(var ShptLine: Record "Sales Shipment Line"): Decimal
    begin
        // Calculate line base amount without line discount amount field.
        exit(Round(ShptLine.Quantity * ShptLine."Unit Price", AmountPrecision));
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

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        AmountPrecision: Decimal;

        PostingDateTxt: Text[50];
        ShipmentDateTxt: Text[50];
        CustomerOrderNo: Text[50];

        LineAmtExclVAT: Decimal;
        LineBase: Decimal;

        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;

        VatSummaryDict: Dictionary of [Decimal, Decimal]; // Key: VAT %, Value: summed base
        VatPctList: List of [Decimal];

        VATDisplayTxt: Text[20];
        VATBaseAmount: Decimal;
        VATAmount: Decimal;
}
