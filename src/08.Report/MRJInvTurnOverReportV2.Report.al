report 50001 "Inv. Turn Over Report V2"
{
    Caption = 'Inventory Turn Over Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJInvTurnOverReportV2.rdlc';

    dataset
    {
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
                MakeExcelDataBody();
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
        MakeExcelDataHeader();
    end;

    trigger OnPostReport()
    begin
        CreateExcelBook()
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

    local procedure MakeExcelDataHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(ItemNoLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ItemNameLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvgInvLastYrLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + JanLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + FebLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + MarLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + AprLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + MayLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + JunLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + JulLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + AugLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + SepLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + OctLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + NovLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + DecLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvgInvYearlyLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipYearLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverYearLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Item."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Item.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PrevYearAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(JanQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(JanAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(FebQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(FebAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MarQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MarAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AprQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AprAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MayQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MayAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(JunQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(JunAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(JulQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(JulAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AugQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AugAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SepQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SepAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(OctQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(OctAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(NovQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(NovAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(DecQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(DecAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(CurrYearQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(CurrYearAvgQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(CurrYearTurnOver, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    procedure CreateExcelBook()
    begin
        TempExcelBuffer.CreateNewBook(SheetNameLbl);
        TempExcelBuffer.WriteSheet(SheetNameLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(SheetNameLbl, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
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