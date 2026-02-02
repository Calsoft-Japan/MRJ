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
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(ShipmentNo; "No.") { }
            column(PostingDateTxt; PostingDateTxt) { }
            column(ShipmentDateTxt; ShipmentDateTxt) { }
            column(OrderNo; "Order No.") { }
            column(CustomerOrderNo; CustomerOrderNo) { }
            column(CustNo; "Sell-to Customer No.") { }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code") { }

            // Sell-to (right)
            column(CompanyAddr1; CompanyInfo.Name) { }
            column(CompanyAddr2; CompanyInfo."Post Code") { }
            column(CompanyAddr3; CompanyInfo.Address) { }
            column(CompanyAddr4; CompanyInfo."Fax No.") { }
            column(CompanyAddr5; CompanyInfo."Phone No.") { }

            // Ship-to (left)
            column(CustName; "Ship-to Name") { }
            column(CustAddr1; "Ship-to Post Code") { }
            column(CustAddr2; "Ship-to Address") { }
            column(CustAddr3; "Ship-to Address 2") { }
            column(CustAddr4; "Ship-to Contact") { }

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

                column(LineNo; "Line No.") { }
                column(LineDescription; Description) { }
                column(LineQuantity; Quantity) { }
                column(LineUOM; "Unit of Measure Code") { }
                column(LineUnitPrice; "Unit Price") { }

                // calculated (tax excl., incl. discount) from Sales Order line
                column(LineAmountExclVAT; LineAmtExclVAT) { }

                column(LineDiscountPct; "Line Discount %") { } // optional

                trigger OnAfterGetRecord()
                begin
                    LineAmtExclVAT := CalcShptLineAmountFromSource("Sales Shipment Line");
                end;
            }

            // ==== VAT Summary (dynamic via Integer) ====
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
                    VatSummaryDict.Get(VatPct, BaseDec);

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
                        // Include Item + Resource
                        if not (SalesShptLineTmp.Type in [SalesShptLineTmp.Type::Item, SalesShptLineTmp.Type::Resource]) then
                            continue;

                        if SalesShptLineTmp.Quantity = 0 then
                            continue;

                        // ✅ calculate base from source Sales Order line
                        LineBase := CalcShptLineAmountFromSource(SalesShptLineTmp);
                        if LineBase = 0 then
                            continue;

                        TotalExclVAT += LineBase;

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
            AmountPrecision := 1;
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

    local procedure CalcShptLineAmountFromSource(ShptLine: Record "Sales Shipment Line"): Decimal
    var
        SrcSalesLine: Record "Sales Line";
        Amt: Decimal;
    begin
        // Most environments: shipment amounts are 0; use source Sales Order line amount
        if (ShptLine."Order No." <> '') and (ShptLine."Order Line No." <> 0) then begin
            SrcSalesLine.Reset();
            SrcSalesLine.SetRange("Document Type", SrcSalesLine."Document Type"::Order);
            SrcSalesLine.SetRange("Document No.", ShptLine."Order No.");
            SrcSalesLine.SetRange("Line No.", ShptLine."Order Line No.");
            if SrcSalesLine.FindFirst() then
                exit(SrcSalesLine."Line Amount");
        end;

        // Fallback: compute from shipment fields
        Amt := ShptLine.Quantity * ShptLine."Unit Price" * (1 - ShptLine."Line Discount %" / 100);
        exit(Round(Amt, AmountPrecision));
    end;

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        AmountPrecision: Decimal;

        PostingDateTxt: Text[50];
        ShipmentDateTxt: Text[50];
        CustomerOrderNo: Text[50];

        LineBase: Decimal;
        LineAmtExclVAT: Decimal;

        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;

        VatSummaryDict: Dictionary of [Decimal, Decimal];
        VatPctList: List of [Decimal];

        VATDisplayTxt: Text[20];
        VATBaseAmount: Decimal;
        VATAmount: Decimal;
}
