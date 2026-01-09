report 50014 "MRJ Sales Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Sales Invoice (JP)';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJSalesInvoiceReport.rdlc';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";

            // ==== Header fields ====
            column(Customer_No; "No.") { }
            column(PostingDateTxt; PostingDateTxt) { }
            column(ShipmentDateTxt; ShipmentDateTxt) { }
            column(OrderNo; "Order No.") { }
            column(CustomerOrderNo; CustomerOrderNo) { }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code") { }

            //Sell- to (right)
            column(Sell_to_Name; "Sell-to Customer Name") { }
            column(Sell_to_Customer_No; "Sell-to Customer No.") { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(Sell_to_Address_2; "Sell-to Address 2") { }
            column(Sell_to_Post_Code; "Sell-to Post Code") { }

            // Ship- to (left)
            column(Ship_to_Customer_No; "Ship-to Code") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }

            // Qualified invoice requirement
            column(CompanyRegistrationNo; CompanyInfo."VAT Registration No.") { }

            // Totals
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }

            // ==== Detail lines ====
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineDescription; Description) { }
                column(LineQuantity; Quantity) { }
                column(LineUOM; "Unit of Measure Code") { }
                column(LineUnitPrice; "Unit Price") { }

                // Tax-excl amount for shipment
                column(LineAmount; "VAT Base Amount") { }
            }

            // ==== VAT Summary (dynamic via Integer) ====
            dataitem(VATSummary; Integer)
            {
                DataItemTableView = sorting(Number);

                // ① 非課税 / xx%対象
                column(VATDisplayTxt; VATDisplayTxt) { }
                // ② VAT Base Amount (summed)
                column(VATBaseAmount; VATBaseAmount) { }
                // ③ 消費税ラベル
                column(VATLabelTxt; '消費税') { }
                // ④ VAT Amount
                column(VATAmount; VATAmount) { }

                trigger OnPreDataItem()
                begin
                    // If there is no VAT data, do not print this section
                    if VatPctList.Count() = 0 then
                        CurrReport.Break();

                    // Loop Integer from 1..N (N = number of VAT% buckets)
                    SetRange(Number, 1, VatPctList.Count());
                end;

                trigger OnAfterGetRecord()
                var
                    VatPct: Decimal;
                    BaseDec: Decimal;
                begin
                    // Get VAT% at current index (ascending order ensured by insertion)
                    VatPctList.Get(Number, VatPct);

                    // Get summed VAT Base Amount for this VAT%
                    VatSummaryDict.Get(VatPct, BaseDec);

                    if VatPct = 0 then
                        VATDisplayTxt := '非課税'
                    else
                        VATDisplayTxt := Format(VatPct) + '%対象';

                    VATBaseAmount := BaseDec;
                    VATAmount := RoundWithPrecision(VATBaseAmount * VatPct / 100);
                end;
            }

            trigger OnAfterGetRecord()
            var
                SalesShptLineTmp: Record "Sales Shipment Line";
                SalesHeader: Record "Sales Header";
                LineVAT: Decimal;
            begin
                // Dates (JP)
                PostingDateTxt := Format("Posting Date", 0, '<Year4>年<Month,2>月<Day,2>日');
                ShipmentDateTxt := Format("Shipment Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                // Customer Order No. (from Sales Order → External Document No.)
                CustomerOrderNo := '';
                if "Order No." <> '' then begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange("No.", "Order No.");
                    if SalesHeader.FindFirst() then
                        CustomerOrderNo := SalesHeader."External Document No.";
                end;

                // Totals reset
                TotalExclVAT := 0;
                TotalVAT := 0;
                TotalInclVAT := 0;

                // VAT summary reset
                Clear(VatSummaryDict);
                Clear(VatPctList);

                // Build totals + VAT summary buffer from Sales Shipment Lines
                SalesShptLineTmp.Reset();
                SalesShptLineTmp.SetRange("Document No.", "No.");

                if SalesShptLineTmp.FindSet() then
                    repeat
                        if SalesShptLineTmp."VAT Base Amount" = 0 then
                            continue;

                        // Totals (tax-excl, tax, tax-incl)
                        TotalExclVAT += SalesShptLineTmp."VAT Base Amount";

                        LineVAT := RoundWithPrecision(
                            SalesShptLineTmp."VAT Base Amount" * SalesShptLineTmp."VAT %" / 100
                        );
                        TotalVAT += LineVAT;
                        TotalInclVAT += SalesShptLineTmp."VAT Base Amount" + LineVAT;

                        // VAT Summary: per VAT% accumulate base amount
                        AddOrUpdateVatSummary(
                            SalesShptLineTmp."VAT %",
                            SalesShptLineTmp."VAT Base Amount"
                        );

                    until SalesShptLineTmp.Next() = 0;

                // (Optional) If you want these always consistent:
                // TotalInclVAT := RoundWithPrecision(TotalExclVAT + TotalVAT);
            end;
        }
    }

    trigger OnPreReport()
    begin
        // Load Company info and rounding once
        CompanyInfo.Get();
        GLSetup.Get();

        AmountPrecision := GLSetup."Amount Rounding Precision";
        if AmountPrecision = 0 then
            AmountPrecision := 1; // Safe default for JPY (¥ units)
    end;

    // Accumulate VAT summary using Dictionary(Key: VAT %, Value: Base Sum)
    // Maintain a sorted List of VAT% by insertion (ascending)
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
            //InsertSortedVatPct(VatPct);
        end;
    end;

    // local procedure InsertSortedVatPct(VatPct: Decimal)
    // var
    //     i: Integer;
    //     Curr: Decimal;
    // begin
    //     // Insert VAT% in ascending order to avoid needing List.Sort()
    //     for i := 1 to VatPctList.Count() do begin
    //         VatPctList.Get(i, Curr);
    //         if VatPct < Curr then begin
    //             VatPctList.Insert(i, VatPct);
    //             exit;
    //         end;
    //         if VatPct = Curr then
    //             exit; // already present (defensive)
    //     end;
    //     // Append if larger than all existing values or list empty
    //     VatPctList.Add(VatPct);
    // end;

    local procedure RoundWithPrecision(Amount: Decimal): Decimal
    begin
        exit(Round(Amount, AmountPrecision));
    end;

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        AmountPrecision: Decimal;

        PostingDateTxt: Text[50];
        ShipmentDateTxt: Text[50];
        CustomerOrderNo: Text[50];

        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;

        // VAT summary structures
        VatSummaryDict: Dictionary of [Decimal, Decimal]; // Key: VAT %, Value: summed VAT Base Amount
        VatPctList: List of [Decimal];

        // VATSummary output fields
        VATDisplayTxt: Text[20];
        VATBaseAmount: Decimal;
        VATAmount: Decimal;
}
