report 50001 "Inv. Turn Over Report"
{
    Caption = 'Inventory Turn Over Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = where(Blocked = const(false));
            column(ItemNo; "No.") { }
            column(ItemName; Description) { }
            trigger OnAfterGetRecord()
            begin
                ClearVariables();

                PrevYearQty := GetPrevYearInventory("No.");
                PrevYearAvgQty := PrevYearQty / 12;

                CurrYearQty := GetCurrYearInventory("No.");
                CurrYearAvgQty := CurrYearQty / 12;

                if CurrYearAvgQty <> 0 then
                    CurrYearTurnOver := CurrYearQty / CurrYearAvgQty;

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
        // Get last date of previous year from selecte year
        PrevYrStartDate := DMY2Date(1, 1, YearFilter - 1);
        PrevYrEndDate := DMY2Date(31, 12, YearFilter - 1);

        // Get last date of selected year
        CurrYrStartDate := DMY2Date(1, 1, YearFilter);
        CurrYrEndDate := DMY2Date(31, 12, YearFilter);

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

    procedure GetCurrYearInventory(ItemNo: Code[20]): Decimal
    var
        ItemLedEntry: Record "Item Ledger Entry";
        Qty: Decimal;
    begin
        ItemLedEntry.Reset();
        ItemLedEntry.SetCurrentKey("Item No.", "Posting Date");
        ItemLedEntry.SetRange("Item No.", ItemNo);
        ItemLedEntry.SetRange("Posting Date", CurrYrStartDate, CurrYrEndDate);
        ItemLedEntry.SetLoadFields(Quantity);
        if ItemLedEntry.FindSet() then
            repeat
                Qty += ItemLedEntry.Quantity;
            until ItemLedEntry.Next() = 0;
        exit(Qty);
    end;

    procedure GetPrevYearInventory(ItemNo: Code[20]): Decimal
    var
        ItemLedEntry: Record "Item Ledger Entry";
        Qty: Decimal;
    begin
        ItemLedEntry.Reset();
        ItemLedEntry.SetCurrentKey("Item No.", "Posting Date");
        ItemLedEntry.SetRange("Item No.", ItemNo);
        ItemLedEntry.SetRange("Posting Date", PrevYrStartDate, PrevYrEndDate);
        ItemLedEntry.SetLoadFields(Quantity);
        if ItemLedEntry.FindSet() then
            repeat
                Qty += ItemLedEntry.Quantity;
            until ItemLedEntry.Next() = 0;
        exit(Qty);
    end;

    local procedure CalcMonthlyInventory(ItemNo: Code[20])
    var
        ItemLedEntry: Record "Item Ledger Entry";
    begin
        ItemLedEntry.Reset();
        ItemLedEntry.SetRange("Item No.", ItemNo);
        ItemLedEntry.SetCurrentKey("Item No.", "Posting Date");
        ItemLedEntry.SetRange("Posting Date", CurrYrStartDate, CurrYrEndDate);
        ItemLedEntry.SetLoadFields(Quantity);
        if ItemLedEntry.FindSet() then
            repeat
                case Date2DMY(ItemLedEntry."Posting Date", 2) of
                    1:
                        JanQty += ItemLedEntry.Quantity;
                    2:
                        FebQty += ItemLedEntry.Quantity;
                    3:
                        MarQty += ItemLedEntry.Quantity;
                    4:
                        AprQty += ItemLedEntry.Quantity;
                    5:
                        MayQty += ItemLedEntry.Quantity;
                    6:
                        JunQty += ItemLedEntry.Quantity;
                    7:
                        JulQty += ItemLedEntry.Quantity;
                    8:
                        AugQty += ItemLedEntry.Quantity;
                    9:
                        SepQty += ItemLedEntry.Quantity;
                    10:
                        OctQty += ItemLedEntry.Quantity;
                    11:
                        NovQty += ItemLedEntry.Quantity;
                    12:
                        DecQty += ItemLedEntry.Quantity;
                end;
            until ItemLedEntry.Next() = 0;

        if PrevYearQty <> 0 then begin
            JanAvgQty := JanQty / PrevYearQty;
            FebAvgQty := FebQty / PrevYearQty;
            MarAvgQty := MarQty / PrevYearQty;
            AprAvgQty := AprQty / PrevYearQty;
            MayAvgQty := MayQty / PrevYearQty;
            JunAvgQty := JunQty / PrevYearQty;
            JulAvgQty := JulQty / PrevYearQty;
            AugAvgQty := AugQty / PrevYearQty;
            SepAvgQty := SepQty / PrevYearQty;
            OctAvgQty := OctQty / PrevYearQty;
            NovAvgQty := NovQty / PrevYearQty;
            DecAvgQty := DecQty / PrevYearQty;
        end;

        /* if PrevYearQty > 0 then
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
            DecAvgQty := 0; */
    end;

    local procedure MakeExcelDataHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn((YearFilter - 1), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
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
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(ItemNoLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ItemNameLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvgInvLastYrLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverMonthLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvgInvYearlyLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipYearLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverYearLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Item."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Item.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Round(PrevYearAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(JanQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(JanAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(FebQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(FebAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(MarQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(MarAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(AprQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(AprAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(MayQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(MayAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(JunQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(JunAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(JulQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(JulAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(AugQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(AugAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(SepQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(SepAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(OctQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(OctAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(NovQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(NovAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(DecQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(DecAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(CurrYearAvgQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(CurrYearQty, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Round(CurrYearTurnOver, 0.01), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
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
        PrevYrStartDate: Date;
        PrevYrEndDate: Date;
        CurrYrStartDate: Date;
        CurrYrEndDate: Date;
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