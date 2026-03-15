report 50000 "Inv. Turn Over Report"
{
    Caption = 'Inventory Turn Over Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJInvTurnOverReport.rdlc';

    dataset
    {
        dataitem(HeaderCaptions; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(ItemNoLbl; ItemNoLbl) { }
            column(ItemNameLbl; ItemNameLbl) { }
            column(PrevYear; YearFilter - 1) { }
            column(CurrYear; YearFilter) { }
            column(AvgInvLastYrLbl; AvgInvLastYrLbl) { }
            column(QtyLbl; QtyShipMonthLbl) { }
            column(AvgLbl; InvTurnOverMonthLbl) { }
            column(JanLbl; Format(YearFilter) + JanLbl) { }
            column(FebLbl; Format(YearFilter) + FebLbl) { }
            column(MarLbl; Format(YearFilter) + MarLbl) { }
            column(AprLbl; Format(YearFilter) + AprLbl) { }
            column(MayLbl; Format(YearFilter) + MayLbl) { }
            column(JunLbl; Format(YearFilter) + JunLbl) { }
            column(JulLbl; Format(YearFilter) + JulLbl) { }
            column(AugLbl; Format(YearFilter) + AugLbl) { }
            column(SepLbl; Format(YearFilter) + SepLbl) { }
            column(OctLbl; Format(YearFilter) + OctLbl) { }
            column(NovLbl; Format(YearFilter) + NovLbl) { }
            column(DecLbl; Format(YearFilter) + DecLbl) { }
            column(AvgInvYearlyLbl; AvgInvYearlyLbl) { }
            column(QtyShipYearLbl; QtyShipYearLbl) { }
            column(InvTurnOverYearLbl; InvTurnOverYearLbl) { }
        }
        dataitem(Item; Item)
        {
            DataItemTableView = where(Blocked = const(false));
            column(ItemNo; "No.") { }
            column(ItemName; Description) { }
            column(PrevYearAvgQty; PrevYearAvgQty) { }
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
            column(CurrYearAvgQty; CurrYearAvgQty) { }
            column(CurrYearQty; CurrYearQty) { }
            column(CurrYearTurnOver; CurrYearTurnOver) { }
            trigger OnAfterGetRecord()
            begin
                ClearVariables();
                PrevYearQty := GetPrevYearInventory("No.");
                PrevYearAvgQty := PrevYearQty / 12;

                CurrYearQty := GetCurrYearInventory("No.");
                CurrYearAvgQty := CurrYearQty / 12;

                if CurrYearAvgQty > 0 then
                    CurrYearTurnOver := CurrYearQty / CurrYearAvgQty
                else
                    CurrYearTurnOver := 0;

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

    trigger OnPreReport()
    begin
    end;

    trigger OnPostReport()
    begin
    end;

    local procedure ClearVariables()
    begin
        PrevYearQty := 0;
        PrevYearAvgQty := 0;
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
        CurrYearQty := 0;
        CurrYearAvgQty := 0;
        CurrYearTurnOver := 0;
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

        if PrevYearQty > 0 then
            JanAvgQty := JanQty / PrevYearQty
        else
            JanAvgQty := 0;

        if PrevYearQty > 0 then
            FebAvgQty := FebQty / PrevYearQty
        else
            FebAvgQty := 0;

        if PrevYearQty > 0 then
            MarAvgQty := MarQty / PrevYearQty
        else
            MarAvgQty := 0;

        if PrevYearQty > 0 then
            AprAvgQty := AprQty / PrevYearQty
        else
            AprAvgQty := 0;

        if PrevYearQty > 0 then
            MayAvgQty := MayQty / PrevYearQty
        else
            MayAvgQty := 0;

        if PrevYearQty > 0 then
            JunAvgQty := JunQty / PrevYearQty
        else
            JunAvgQty := 0;

        if PrevYearQty > 0 then
            JulAvgQty := JulQty / PrevYearQty
        else
            JulAvgQty := 0;

        if PrevYearQty > 0 then
            AugAvgQty := AugQty / PrevYearQty
        else
            AugAvgQty := 0;

        if PrevYearQty > 0 then
            SepAvgQty := SepQty / PrevYearQty
        else
            SepAvgQty := 0;

        if PrevYearQty > 0 then
            OctAvgQty := OctQty / PrevYearQty
        else
            OctAvgQty := 0;

        if PrevYearQty > 0 then
            NovAvgQty := NovQty / PrevYearQty
        else
            NovAvgQty := 0;

        if PrevYearQty > 0 then
            DecAvgQty := DecQty / PrevYearQty
        else
            DecAvgQty := 0;
    end;

    procedure GetPrevYearInventory(ItemNo: Code[20]): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        StartDate: Date;
        EndDate: Date;
        Qty: Decimal;
    begin
        // Get last date of previous year
        StartDate := DMY2Date(1, 1, YearFilter - 1);
        EndDate := DMY2Date(31, 12, YearFilter - 1);
        Qty := 0;

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
        ItemLedgerEntry.SetLoadFields(Quantity);
        if ItemLedgerEntry.FindSet() then
            repeat
                Qty += ItemLedgerEntry.Quantity;
            until ItemLedgerEntry.Next() = 0;
        exit(Qty);
    end;

    procedure GetCurrYearInventory(ItemNo: Code[20]): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        StartDate: Date;
        EndDate: Date;
        Qty: Decimal;
    begin
        // Get last date of selected year
        StartDate := DMY2Date(1, 1, YearFilter);
        EndDate := DMY2Date(31, 12, YearFilter);
        Qty := 0;

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetFilter("Posting Date", '%1..%1', StartDate, EndDate);
        ItemLedgerEntry.SetLoadFields(Quantity);
        if ItemLedgerEntry.FindSet() then
            repeat
                Qty += ItemLedgerEntry.Quantity;
            until ItemLedgerEntry.Next() = 0;
        exit(Qty);
    end;

    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempExcelBuffer: Record "Excel Buffer" temporary;
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
        PrevYearAvgQty: Decimal;
        CurrYearQty: Decimal;
        CurrYearAvgQty: Decimal;
        CurrYearTurnOver: Decimal;
        SheetNameLbl: Label 'Inventory Turn Over Report';
        ItemNoLbl: Label 'Item No.';
        ItemNameLbl: Label 'Item Description';
        AvgInvLastYrLbl: Label 'Avg. Inv. (Last Year)';
        QtyShipMonthLbl: Label 'Qty. Shipped (Monthly)';
        InvTurnOverMonthLbl: Label 'Inv. Turn Over (Monthly)';
        AvgInvYearlyLbl: Label 'Avg Inv. (Yearly)';
        QtyShipYearLbl: Label 'Qty. Shipped (Yearly)';
        InvTurnOverYearLbl: Label 'Inv. Turn Over (Yearly)';
        JanLbl: Label '.1';
        FebLbl: Label '.2';
        MarLbl: Label '.3';
        AprLbl: Label '.4';
        MayLbl: Label '.5';
        JunLbl: Label '.6';
        JulLbl: Label '.7';
        AugLbl: Label '.8';
        SepLbl: Label '.9';
        OctLbl: Label '.10';
        NovLbl: Label '.11';
        DecLbl: Label '.12';
}