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
        dataitem(Item; Item)
        {
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
            column(ItemNo; "No.") { }
            column(ItemName; Description) { }
            column(JanQty; JanQty) { }
            column(FebQty; FebQty) { }
            column(MarQty; MarQty) { }
            column(AprQty; AprQty) { }
            column(MayQty; MayQty) { }
            column(JunQty; JunQty) { }
            column(JulQty; JulQty) { }
            column(AugQty; AugQty) { }
            column(SepQty; SepQty) { }
            column(OctQty; OctQty) { }
            column(NovQty; NovQty) { }
            column(DecQty; DecQty) { }

            trigger OnAfterGetRecord()
            begin
                ClearVariables();
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
    end;

    local procedure CalcMonthlyInventory(ItemNo: Code[20])
    begin
        ItemLedgEntry.Reset();
        ItemLedgEntry.SetRange("Item No.", ItemNo);
        ItemLedgEntry.SetRange("Posting Date", DMY2Date(1, 1, YearFilter), DMY2Date(31, 12, YearFilter));
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
    end;
}