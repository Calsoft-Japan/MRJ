report 50000 "Inv. Turn Over Report"
{
    Caption = 'Inventory Turn Over Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    //ProcessingOnly = true;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJInvTurnOverReport.rdlc';

    dataset
    {
        dataitem(HeaderCaptions; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(JanLbl; Format(YearFilter) + Month1Lbl) { }
            column(FebLbl; Format(YearFilter) + Month2Lbl) { }
            column(MarLbl; Format(YearFilter) + Month3Lbl) { }
            column(AprLbl; Format(YearFilter) + Month4Lbl) { }
            column(MayLbl; Format(YearFilter) + Month5Lbl) { }
            column(JunLbl; Format(YearFilter) + Month6Lbl) { }
            column(JulLbl; Format(YearFilter) + Month7Lbl) { }
            column(AugLbl; Format(YearFilter) + Month8Lbl) { }
            column(SepLbl; Format(YearFilter) + Month9Lbl) { }
            column(OctLbl; Format(YearFilter) + Month10Lbl) { }
            column(Nov1Lbl; Format(YearFilter) + Month11Lbl) { }
            column(DecLbl; Format(YearFilter) + Month12Lbl) { }
        }
        dataitem(Item; Item)
        {
            DataItemTableView = where(Blocked = const(false));
            column(ItemNo; "No.") { }
            column(ItemName; Description) { }
            column(PrevYearQty; PrevYearQty / 12) { }
            column(JanQty; JanQty) { }
            column(JanAvgQty; JanAvgQty) { }
            column(FebQty; FebQty) { }
            column(FebAvgQty; FebAvgQty) { }
            column(MarQty; MarQty) { }
            column(MarAvgQty; MarAvgQty) { }
            column(AprQty; AprQty) { }
            column(AprAvgQty; AprAvgQty) { }
            column(MayQty; MayQty) { }
            column(MayAvgQty; MayAvgQty) { }
            column(JunQty; JunQty) { }
            column(JunAvgQty; JunAvgQty) { }
            column(JulQty; JulQty) { }
            column(JulAvgQty; JulAvgQty) { }
            column(AugQty; AugQty) { }
            column(AugAvgQty; AugAvgQty) { }
            column(SepQty; SepQty) { }
            column(SepAvgQty; SepAvgQty) { }
            column(OctQty; OctQty) { }
            column(OctAvgQty; OctAvgQty) { }
            column(NovQty; NovQty) { }
            column(NovAvgQty; NovAvgQty) { }
            column(DecQty; DecQty) { }
            column(DecAvgQty; DecAvgQty) { }

            trigger OnAfterGetRecord()
            begin
                ClearVariables();
                PrevYearQty := GetPrevYearInventory("No.");
                if PrevYearQty <> 0 then
                    AvgPrevYearQty := PrevYearQty / 12
                else
                    AvgPrevYearQty := 0;
                CalcMonthlyInventory("No.");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field(FiscalYear; YearFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Fiscal Year';
                    }
                }
            }
        }
    }

    var
        ItemLedgEntry: Record "Item Ledger Entry";
        YearFilter: Integer;
        JanQty: Decimal;
        FebQty: Decimal;
        MarQty: Decimal;
        AprQty: Decimal;
        MayQty: Decimal;
        JunQty: Decimal;
        JulQty: Decimal;
        AugQty: Decimal;
        SepQty: Decimal;
        OctQty: Decimal;
        NovQty: Decimal;
        DecQty: Decimal;
        JanAvgQty: Decimal;
        FebAvgQty: Decimal;
        MarAvgQty: Decimal;
        AprAvgQty: Decimal;
        MayAvgQty: Decimal;
        JunAvgQty: Decimal;
        JulAvgQty: Decimal;
        AugAvgQty: Decimal;
        SepAvgQty: Decimal;
        OctAvgQty: Decimal;
        NovAvgQty: Decimal;
        DecAvgQty: Decimal;
        PrevYearQty: Decimal;
        AvgPrevYearQty: Decimal;
        Month1Lbl: Label '.1';
        Month2Lbl: Label '.2';
        Month3Lbl: Label '.3';
        Month4Lbl: Label '.4';
        Month5Lbl: Label '.5';
        Month6Lbl: Label '.6';
        Month7Lbl: Label '.7';
        Month8Lbl: Label '.8';
        Month9Lbl: Label '.9';
        Month10Lbl: Label '10';
        Month11Lbl: Label '11';
        Month12Lbl: Label '12';

    local procedure ClearVariables()
    begin
        PrevYearQty := 0;
        AvgPrevYearQty := 0;
        JanQty := 0;
        FebQty := 0;
        MarQty := 0;
        AprQty := 0;
        MayQty := 0;
        JunQty := 0;
        JulQty := 0;
        AugQty := 0;
        SepQty := 0;
        OctQty := 0;
        NovQty := 0;
        DecQty := 0;
        JanAvgQty := 0;
        FebAvgQty := 0;
        MarAvgQty := 0;
        AprAvgQty := 0;
        MayAvgQty := 0;
        JunAvgQty := 0;
        JulAvgQty := 0;
        AugAvgQty := 0;
        SepAvgQty := 0;
        OctAvgQty := 0;
        NovAvgQty := 0;
        DecAvgQty := 0;
    end;

    local procedure CalcMonthlyInventory(ItemNo: Code[20])
    begin
        ItemLedgEntry.Reset();
        ItemLedgEntry.SetRange("Item No.", ItemNo);
        ItemLedgEntry.SetRange("Posting Date", DMY2Date(1, 1, YearFilter), DMY2Date(31, 12, YearFilter));
        ItemLedgEntry.SetLoadFields(Quantity);
        if ItemLedgEntry.FindSet() then
            repeat
                case Date2DMY(ItemLedgEntry."Posting Date", 2) of
                    1:
                        JanQty += ItemLedgEntry.Quantity;
                    2:
                        FebQty += ItemLedgEntry.Quantity;
                    3:
                        MarQty += ItemLedgEntry.Quantity;
                    4:
                        AprQty += ItemLedgEntry.Quantity;
                    5:
                        MayQty += ItemLedgEntry.Quantity;
                    6:
                        JunQty += ItemLedgEntry.Quantity;
                    7:
                        JulQty += ItemLedgEntry.Quantity;
                    8:
                        AugQty += ItemLedgEntry.Quantity;
                    9:
                        SepQty += ItemLedgEntry.Quantity;
                    10:
                        OctQty += ItemLedgEntry.Quantity;
                    11:
                        NovQty += ItemLedgEntry.Quantity;
                    12:
                        DecQty += ItemLedgEntry.Quantity;
                end;
            until ItemLedgEntry.Next() = 0;

        if JanQty > 0 then
            JanAvgQty := JanQty / PrevYearQty
        else
            JanAvgQty := 0;

        if FebQty > 0 then
            FebAvgQty := FebQty / PrevYearQty
        else
            FebAvgQty := 0;

        if MarQty > 0 then
            MarAvgQty := MarQty / PrevYearQty
        else
            MarAvgQty := 0;

        if AprQty > 0 then
            AprAvgQty := AprQty / PrevYearQty
        else
            AprAvgQty := 0;

        if MarQty > 0 then
            MayAvgQty := MayQty / PrevYearQty
        else
            MayAvgQty := 0;

        if JunQty > 0 then
            JunAvgQty := JunQty / PrevYearQty
        else
            JunAvgQty := 0;

        if JulQty > 0 then
            JulAvgQty := JulQty / PrevYearQty
        else
            JulAvgQty := 0;

        if AugQty > 0 then
            AugAvgQty := AugQty / PrevYearQty
        else
            AugAvgQty := 0;

        if SepQty > 0 then
            SepAvgQty := SepQty / PrevYearQty
        else
            SepAvgQty := 0;

        if OctQty > 0 then
            OctAvgQty := OctQty / PrevYearQty
        else
            OctAvgQty := 0;

        if NovQty > 0 then
            NovAvgQty := NovQty / PrevYearQty
        else
            NovAvgQty := 0;

        if DecQty > 0 then
            DecAvgQty := DecQty / PrevYearQty
        else
            DecAvgQty := 0;
    end;

    procedure GetPrevYearInventory(ItemNo: Code[20]): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        PrevYearEndDate: Date;
        Qty: Decimal;
    begin
        // Get last date of previous year
        PrevYearEndDate := DMY2Date(31, 12, YearFilter - 1);
        Qty := 0;

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetFilter("Posting Date", '..%1', PrevYearEndDate);
        ItemLedgerEntry.SetLoadFields(Quantity);
        if ItemLedgerEntry.FindSet() then
            repeat
                Qty += ItemLedgerEntry.Quantity;
            until ItemLedgerEntry.Next() = 0;
        exit(Qty);
    end;
}