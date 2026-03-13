report 50000 "Inv. Turn Over Report"
{
    Caption = 'Inventory Turn Over Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJInvTurnOverReport.rdlc';

    dataset
    {
<<<<<<< HEAD
        dataitem(HeaderCaptions; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
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
        }
=======
>>>>>>> 37382552322db8ddb148a6f721ccba8d20d96a9c
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
                PrevYearAvgQty := PrevYearQty / 12;

                CurrYearQty := GetCurrYearInventory("No.");
                CurrYearAvgQty := CurrYearQty / 12;

                if CurrYearAvgQty > 0 then
                    CurrYearTurnOver := CurrYearQty / CurrYearAvgQty
                else
                    CurrYearTurnOver := 0;

                CalcMonthlyInventory("No.");
<<<<<<< HEAD
                //ExportDataToExcel();
=======
>>>>>>> 37382552322db8ddb148a6f721ccba8d20d96a9c
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

<<<<<<< HEAD
    local procedure MakeExcelDataHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AvgInvLastYrLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(JanLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(FebLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MarLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AprLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MayLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(JunLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(JulLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AugLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SepLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(OctLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(NovLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DecLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
=======
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
        TempExcelBuffer.AddColumn(Format(YearFilter) + FebLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + MarLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + AprLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + MayLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + JunLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + JulLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + AugLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + SepLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + OctLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + NovLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(YearFilter) + DecLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
>>>>>>> 37382552322db8ddb148a6f721ccba8d20d96a9c
        TempExcelBuffer.AddColumn(AvgInvYearlyLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(QtyShipYearLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(InvTurnOverYearLbl, false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelDataBody()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Item."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Item.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
<<<<<<< HEAD
        TempExcelBuffer.AddColumn(AvgPrevYearQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(JanQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(FebQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MarQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AprQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(MayQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(JunQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(JulQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(AugQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SepQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(OctQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(NovQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(DecQty, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        //TempExcelBuffer.AddColumn(, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        //TempExcelBuffer.AddColumn(, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        //TempExcelBuffer.AddColumn(, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
=======
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
>>>>>>> 37382552322db8ddb148a6f721ccba8d20d96a9c
    end;

    procedure CreateExcelBook()
    begin
        TempExcelBuffer.CreateNewBook(SheetNameLbl);
        TempExcelBuffer.WriteSheet(SheetNameLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(SheetNameLbl, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
    end;

<<<<<<< HEAD
    local procedure ExportDataToExcel()
    var
        RowNo: Integer;
    begin
        TempExcelBuffer.DeleteAll();
        Clear(TempExcelBuffer);

        RowNo := 1;
        TempExcelBuffer.CreateNewBook(SheetNameLbl);
        EnterCell(RowNo, 1, '', true, false, false, '@');
        EnterCell(RowNo, 2, '', true, false, false, '@');
        EnterCell(RowNo, 3, AvgInvLastYrLbl, true, false, false, '@');
        EnterCell(RowNo, 4, JanLbl, true, false, false, '@');
        EnterCell(RowNo, 5, FebLbl, true, false, false, '@');
        EnterCell(RowNo, 6, MarLbl, true, false, false, '@');
        EnterCell(RowNo, 7, AprLbl, true, false, false, '@');
        EnterCell(RowNo, 8, MayLbl, true, false, false, '@');
        EnterCell(RowNo, 9, JunLbl, true, false, false, '@');
        EnterCell(RowNo, 10, JulLbl, true, false, false, '@');
        EnterCell(RowNo, 11, AugLbl, true, false, false, '@');
        EnterCell(RowNo, 12, SepLbl, true, false, false, '@');
        EnterCell(RowNo, 13, OctLbl, true, false, false, '@');
        EnterCell(RowNo, 14, NovLbl, true, false, false, '@');
        EnterCell(RowNo, 15, DecLbl, true, false, false, '@');
        EnterCell(RowNo, 16, AvgInvYearlyLbl, true, false, false, '@');
        EnterCell(RowNo, 17, QtyShipYearLbl, true, false, false, '@');
        EnterCell(RowNo, 18, InvTurnOverYearLbl, true, false, false, '@');

        RowNo += 1;
        EnterCell(RowNo, 1, Format(Item."No."), false, false, false, '@');
        EnterCell(RowNo, 2, Format(Item.Description), false, false, false, '@');
        EnterCell(RowNo, 3, Format(AvgPrevYearQty), false, false, false, '');
        EnterCell(RowNo, 4, Format(JanQty), false, false, false, '');
        EnterCell(RowNo, 5, Format(FebQty), false, false, false, '');
        EnterCell(RowNo, 6, Format(MarQty), false, false, false, '');
        EnterCell(RowNo, 7, Format(AprQty), false, false, false, '');
        EnterCell(RowNo, 8, Format(MayQty), false, false, false, '');
        EnterCell(RowNo, 9, Format(JunQty), false, false, false, '');
        EnterCell(RowNo, 10, Format(JulQty), false, false, false, '');
        EnterCell(RowNo, 11, Format(AugQty), false, false, false, '');
        EnterCell(RowNo, 12, Format(SepQty), false, false, false, '');
        EnterCell(RowNo, 13, Format(OctQty), false, false, false, '');
        EnterCell(RowNo, 14, Format(NovQty), false, false, false, '');
        EnterCell(RowNo, 15, Format(DecQty), false, false, false, '');

        TempExcelBuffer.WriteSheet(SheetNameLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(SheetNameLbl, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
    end;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean; NumberFormat: Text[50]);
    begin
        TempExcelBuffer.Init();
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.NumberFormat := NumberFormat;
        TempExcelBuffer.Insert();
    end;

=======
>>>>>>> 37382552322db8ddb148a6f721ccba8d20d96a9c
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
<<<<<<< HEAD
        AvgPrevYearQty: Decimal;
        ItemNoLbl: Label 'Item No.';
        ItemNameLbl: Label 'Item Description';
        AvgInvLastYrLbl: Label 'Average Inventory (Last Year)';
        QtyShipMonthLbl: Label 'Qty. Shipped (Monthly)';
        InvTurnOverMonthLbl: Label 'Inventory Turn Over (Monthly)';
        AvgInvYearlyLbl: Label 'Average Inventory (Yearly)';
        QtyShipYearLbl: Label 'Qty. Shipped (Yearly)';
        InvTurnOverYearLbl: Label 'Inventory Turn Over (Yearly)';
=======
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
>>>>>>> 37382552322db8ddb148a6f721ccba8d20d96a9c
        JanLbl: Label '.1';
        FebLbl: Label '.2';
        MarLbl: Label '.3';
        AprLbl: Label '.4';
        MayLbl: Label '.5';
        JunLbl: Label '.6';
        JulLbl: Label '.7';
        AugLbl: Label '.8';
        SepLbl: Label '.9';
<<<<<<< HEAD
        OctLbl: Label '10';
        NovLbl: Label '11';
        DecLbl: Label '12';
        SheetNameLbl: Label 'Inventory Turn Over Report';
=======
        OctLbl: Label '.10';
        NovLbl: Label '.11';
        DecLbl: Label '.12';
>>>>>>> 37382552322db8ddb148a6f721ccba8d20d96a9c
}