page 50138 "Service Parts Transfer"
{
    Caption = 'Service Parts Transfer';
    PageType = List;
    SourceTable = "Parts Transfer Buffer";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Filter)
            {
                Caption = 'Filters';

                field(LocationCode; LocationCode)
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                    TableRelation = Location;

                    trigger OnValidate()
                    begin
                        Refresh();
                    end;
                }

                field(BinCode; BinCode)
                {
                    Caption = 'Bin Code';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if BinCode <> '' then
                            if not RecBin.Get(LocationCode, BinCode) then
                                Error(TEXT0001, BinCode);

                        Refresh();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RecBin.Reset();
                        RecBin.SetRange("Location Code", LocationCode);

                        if Page.RunModal(Page::"Bin List", RecBin) = Action::LookupOK then begin
                            BinCode := RecBin.Code;
                            Text := BinCode;
                            exit(true);
                        end;

                        exit(false);
                    end;
                }

                field(OrderNoFilter; OrderNoFilter)
                {
                    Caption = 'Order No. Filter';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if not RecBin.Get(LocationCode, BinCode) then begin
                            RecServiceHeader.Reset();
                            RecServiceHeader.SetFilter("No.", OrderNoFilter);
                            if RecServiceHeader.FindFirst() then begin
                                LocationCodeTmp := RecServiceHeader."Location Code";
                                BinCodeTmp := RecServiceHeader."Bin Code";

                                RecServiceHeader.SetFilter("Location Code", '<>%1', LocationCodeTmp);
                                RecServiceHeader.SetFilter("Bin Code", '<>%1', BinCodeTmp);

                                if RecServiceHeader.Count = 0 then begin
                                    LocationCode := LocationCodeTmp;
                                    BinCode := BinCodeTmp;
                                end;
                            end;
                        end;

                        Refresh();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RecServiceHeader.Reset();
                        RecServiceHeader.SetRange("Document Type", RecServiceHeader."Document Type"::Order);

                        if BinCode <> '' then begin
                            RecServiceHeader.SetRange("Location Code", LocationCode);
                            RecServiceHeader.SetRange("Bin Code", BinCode);
                        end;

                        if Page.RunModal(Page::"Service Orders", RecServiceHeader) = Action::LookupOK then begin
                            // In BC there is no "GetSelectionFilter" like old Forms
                            // User can select one record, we take its No.
                            OrderNoFilter := RecServiceHeader."No.";
                            Text := OrderNoFilter;
                            exit(true);
                        end;

                        exit(false);
                    end;
                }

                field(FromLocationCode; FromLocationCode)
                {
                    Caption = 'From Location Code';
                    ApplicationArea = All;
                    Editable = false;
                    TableRelation = Location.Code;
                }

                field(FromBinCode; FromBinCode)
                {
                    Caption = 'From Bin Code';
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LocBin.Reset();
                        LocBin.SetRange("Location Code", FromLocationCode);

                        if Page.RunModal(Page::"Bin List", LocBin) = Action::LookupOK then begin
                            FromBinCode := LocBin.Code;
                            Text := FromBinCode;
                            exit(true);
                        end;

                        exit(false);
                    end;
                }
            }

            repeater(Lines)
            {
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RecServiceHeader.Reset();
                        RecServiceHeader.SetRange("Document Type", RecServiceHeader."Document Type"::Order);
                        RecServiceHeader.SetRange("No.", Rec."Order No.");

                        if RecServiceHeader.FindFirst() then begin
                            Page.RunModal(Page::"Service Order", RecServiceHeader);
                            Refresh();
                        end;

                        exit(true);
                    end;
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RecItem.Reset();
                        RecItem.SetRange("No.", Rec."Item No.");
                        if RecItem.FindFirst() then
                            Page.RunModal(Page::"Item Card", RecItem);

                        exit(true);
                    end;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Qty. to Use"; Rec."Qty. to Use")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        RecServiceLine.Reset();
                        RecServiceLine.SetRange("Document Type", RecServiceLine."Document Type"::Order);
                        RecServiceLine.SetRange("Document No.", Rec."Order No.");
                        RecServiceLine.SetRange(Type, RecServiceLine.Type::Item);
                        RecServiceLine.SetRange("No.", Rec."Item No.");

                        if RecServiceLine.Count > 0 then
                            Page.RunModal(Page::"Service Line List", RecServiceLine);
                    end;
                }

                field("Qty. Received"; Rec."Qty. Received")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        TransNoFilter := '';

                        if Rec."Receive TO No. Filter" <> '' then
                            TransNoFilter := Rec."Receive TO No. Filter";

                        if Rec."Return TO No. Filter" <> '' then begin
                            if TransNoFilter <> '' then
                                TransNoFilter += '|';
                            TransNoFilter += Rec."Return TO No. Filter";
                        end;

                        if TransNoFilter = '' then
                            exit;

                        RecWarehouseEntry.Reset();
                        RecWarehouseEntry.SetRange("Location Code", LocationCode);
                        RecWarehouseEntry.SetRange("Bin Code", BinCode);
                        RecWarehouseEntry.SetFilter("Source No.", TransNoFilter);
                        RecWarehouseEntry.SetRange("Item No.", Rec."Item No.");

                        if RecWarehouseEntry.Count > 0 then
                            Page.RunModal(Page::"Warehouse Entries", RecWarehouseEntry);
                    end;
                }

                field(Availability; Rec.Availability)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        AvailabilityDetail(Rec."Item No.");
                    end;
                }

                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Caption = 'UOM';
                    ApplicationArea = All;
                }

                field("Receive Transfer"; Rec."Receive Transfer")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RecTransferHeader.Reset();
                        RecTransferHeader.SetRange("No.", Rec."Receive Transfer");

                        if RecTransferHeader.FindFirst() then begin
                            Page.RunModal(Page::"Transfer Order", RecTransferHeader);
                            Refresh();
                        end;

                        exit(true);
                    end;
                }

                field("Return Transfer"; Rec."Return Transfer")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RecTransferHeader.Reset();
                        RecTransferHeader.SetRange("No.", Rec."Return Transfer");

                        if RecTransferHeader.FindFirst() then begin
                            Page.RunModal(Page::"Transfer Order", RecTransferHeader);
                            Refresh();
                        end;

                        exit(true);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RefreshAction)
            {
                Caption = 'Refresh';
                ApplicationArea = All;
                Image = Refresh;

                trigger OnAction()
                begin
                    Refresh();
                end;
            }

            action(CreateReceiveTOAction)
            {
                Caption = 'Create Receive Transfer Order';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec.Count = 0 then
                        exit;

                    if not Confirm(TEXT0012, false) then
                        exit;

                    RecServiceHeader.Reset();
                    RecServiceHeader.SetRange("Document Type", RecServiceHeader."Document Type"::Order);
                    RecServiceHeader.SetRange("Location Code", LocationCode);
                    RecServiceHeader.SetRange("Bin Code", BinCode);
                    RecServiceHeader.SetFilter("No.", OrderNoFilter);

                    if RecServiceHeader.FindSet() then
                        repeat
                            CreateReceiveTO(RecServiceHeader);
                        until RecServiceHeader.Next() = 0;

                    Refresh();
                end;
            }

            action(CreateReturnTOAction)
            {
                Caption = 'Create Return Transfer Order';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec.Count = 0 then
                        exit;

                    if not Confirm(TEXT0013, false) then
                        exit;

                    RecServiceHeader.Reset();
                    RecServiceHeader.SetRange("Document Type", RecServiceHeader."Document Type"::Order);
                    RecServiceHeader.SetRange("Location Code", LocationCode);
                    RecServiceHeader.SetRange("Bin Code", BinCode);
                    RecServiceHeader.SetFilter("No.", OrderNoFilter);

                    if RecServiceHeader.FindSet() then
                        repeat
                            CreateReturnTO(RecServiceHeader);
                        until RecServiceHeader.Next() = 0;

                    Refresh();
                end;
            }
        }

        area(reporting)
        {
            /* action(PrintServiceReport)
            {
                Caption = 'Service Report';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if ServiceOrderNoFilter = '' then
                        exit;

                    RecServiceHeader.Reset();
                    RecServiceHeader.SetRange("Document Type", RecServiceHeader."Document Type"::Order);
                    RecServiceHeader.SetFilter("No.", ServiceOrderNoFilter);

                    Report.Run(Report::"Service Work Report", true, false, RecServiceHeader);
                end;
            }

            action(PrintPartsRequest)
            {
                Caption = 'Parts Request';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if ServiceOrderNoFilter = '' then
                        exit;

                    RecServiceHeader.Reset();
                    RecServiceHeader.SetRange("Document Type", RecServiceHeader."Document Type"::Order);
                    RecServiceHeader.SetFilter("No.", ServiceOrderNoFilter);

                    Report.Run(Report::"Parts Request Form", true, false, RecServiceHeader);
                end;
            } */
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        Rec.DeleteAll();
        Clear(Rec);

        FromLocationCode := '';
        FromBinCode := '';

        if GFromLocationCode <> '' then begin
            FromLocationCode := GFromLocationCode;
            FromBinCode := GFromBinCode;
        end;

        if OrderNoFilter <> '' then
            Refresh();
    end;

    var
        InvSetup: Record "Inventory Setup";
        RecBin: Record Bin;
        RecServiceHeader: Record "Service Header";
        RecServItemLine: Record 5901;
        RecServiceLine: Record 5902;
        RecWarehouseEntry: Record 7312;
        RecItem: Record 27;
        RecTransferHeader: Record 5740;
        RecTransferLine: Record 5741;
        LocBin: Record 7354;
        LocationCode: Code[10];
        BinCode: Code[20];
        OrderNoFilter: Text[250];
        LocationCodeTmp: Code[10];
        BinCodeTmp: Code[20];
        FromLocationCode: Code[10];
        FromBinCode: Code[20];
        TransNoFilter: Text[1024];
        ServiceOrderNoFilter: Text[1024];
        GFromLocationCode: Code[10];
        GFromBinCode: Code[20];
        QtyTmp: Decimal;
        LineNoTmp: Integer;
        TEXT0001: Label 'Bin Code ''%1'' does not exists.';
        TEXT0012: Label 'Do you want to create Receive Parts Transfer Order?';
        TEXT0013: Label 'Do you want to create Return Parts Transfer Order?';

    local procedure Refresh()
    begin
        Rec.Reset();
        Rec.DeleteAll();
        Clear(Rec);

        if not RecBin.Get(LocationCode, BinCode) then
            exit;

        RecServiceHeader.Reset();
        RecServiceHeader.SetRange("Document Type", RecServiceHeader."Document Type"::Order);
        RecServiceHeader.SetRange("Location Code", LocationCode);
        RecServiceHeader.SetRange("Bin Code", BinCode);
        RecServiceHeader.SetFilter("No.", OrderNoFilter);
        if RecServiceHeader.FindSet() then
            repeat
                Rec.Init();
                Rec."Order No." := RecServiceHeader."No.";
                Rec."Receive TO No. Filter" := RecServiceHeader."Parts Receive TO No. Filter";
                Rec."Return TO No. Filter" := RecServiceHeader."Parts Return TO No. Filter";
                Rec."From Location Code" := FromLocationCode;
                Rec."From Bin Code" := FromBinCode;
                Rec."To Location Code" := LocationCode;
                Rec."To Bin Code" := BinCode;

                // USE
                RecServiceLine.Reset();
                RecServiceLine.SetRange("Document Type", RecServiceLine."Document Type"::Order);
                RecServiceLine.SetRange("Document No.", RecServiceHeader."No.");
                RecServiceLine.SetRange(Type, RecServiceLine.Type::Item);
                RecServiceLine.SetFilter("No.", '<>%1', '');
                if RecServiceLine.FindSet() then
                    repeat
                        if Rec.Get(RecServiceHeader."No.", RecServiceLine."No.") then begin
                            Rec."Qty. to Use" += RecServiceLine."Quantity (Base)";
                            Rec.Modify();
                        end else begin
                            Rec."Item No." := RecServiceLine."No.";
                            RecItem.Get(RecServiceLine."No.");
                            Rec."Unit of Measure Code" := RecItem."Base Unit of Measure";
                            Rec."Qty. to Use" := RecServiceLine."Quantity (Base)";
                            Rec."Qty. Received" := 0;
                            Rec.Availability := 0;
                            Rec.Insert();
                        end;
                    until RecServiceLine.Next() = 0;

                // RECEIVED
                TransNoFilter := '';
                if RecServiceHeader."Parts Receive TO No. Filter" <> '' then
                    TransNoFilter := RecServiceHeader."Parts Receive TO No. Filter";
                if RecServiceHeader."Parts Return TO No. Filter" <> '' then begin
                    if TransNoFilter <> '' then
                        TransNoFilter += '|';
                    TransNoFilter += RecServiceHeader."Parts Return TO No. Filter";
                end;

                if TransNoFilter <> '' then begin
                    RecWarehouseEntry.Reset();
                    RecWarehouseEntry.SetRange("Location Code", LocationCode);
                    RecWarehouseEntry.SetRange("Bin Code", BinCode);
                    RecWarehouseEntry.SetFilter("Source No.", TransNoFilter);

                    if RecWarehouseEntry.FindSet() then
                        repeat
                            if Rec.Get(RecServiceHeader."No.", RecWarehouseEntry."Item No.") then begin
                                Rec."Qty. Received" += RecWarehouseEntry.Quantity;
                                Rec.Modify();
                            end else begin
                                Rec."Item No." := RecWarehouseEntry."Item No.";
                                Rec."Unit of Measure Code" := RecWarehouseEntry."Unit of Measure Code";
                                Rec."Qty. to Use" := 0;
                                Rec."Qty. Received" := RecWarehouseEntry.Quantity;
                                Rec.Availability := 0;
                                Rec.Insert();
                            end;
                        until RecWarehouseEntry.Next() = 0;
                end;
            until RecServiceHeader.Next() = 0;

        // AVAILABILITY
        Rec.Reset();
        if Rec.FindSet() then
            repeat
                Rec.Availability := GetAvailability(Rec."Item No.");
                Rec."Qty. to Receive" := (Rec."Qty. to Use" - Rec."Qty. Received");

                if Rec."Qty. to Receive" < 0 then begin
                    Rec."Qty. to Return" := -Rec."Qty. to Receive";
                    Rec."Qty. to Receive" := 0;
                end;

                if (Rec."Qty. to Receive" > 0) and (Rec."Receive TO No. Filter" <> '') then begin
                    RecTransferHeader.Reset();
                    RecTransferHeader.SetFilter("No.", Rec."Receive TO No. Filter");
                    if RecTransferHeader.FindLast() then
                        Rec."Receive Transfer" := RecTransferHeader."No.";
                end;

                if (Rec."Qty. to Return" > 0) and (Rec."Return TO No. Filter" <> '') then begin
                    RecTransferHeader.Reset();
                    RecTransferHeader.SetFilter("No.", Rec."Return TO No. Filter");
                    if RecTransferHeader.FindLast() then
                        Rec."Return Transfer" := RecTransferHeader."No.";
                end;

                Rec.Modify();
            until Rec.Next() = 0;

        // ServiceOrderNoFilter
        ServiceOrderNoFilter := '';
        RecServiceHeader.Reset();
        RecServiceHeader.SetRange("Document Type", RecServiceHeader."Document Type"::Order);
        RecServiceHeader.SetRange("Location Code", LocationCode);
        RecServiceHeader.SetRange("Bin Code", BinCode);
        RecServiceHeader.SetFilter("No.", OrderNoFilter);

        if RecServiceHeader.FindSet() then
            repeat
                if ServiceOrderNoFilter = '' then
                    ServiceOrderNoFilter := RecServiceHeader."No."
                else
                    ServiceOrderNoFilter := ServiceOrderNoFilter + '|' + RecServiceHeader."No.";
            until RecServiceHeader.Next() = 0;

        CurrPage.Update(false);
    end;

    local procedure CreateReceiveTO(var InServiceHeader: Record 5900)
    begin
        Rec.Reset();
        Rec.SetRange("Order No.", InServiceHeader."No.");
        Rec.SetFilter("Qty. to Receive", '>0');
        if not Rec.FindFirst() then
            exit;

        RecTransferHeader.Reset();
        if RecTransferHeader.Get(Rec."Receive Transfer") then begin
            RecTransferLine.Reset();
            RecTransferLine.SetRange("Document No.", RecTransferHeader."No.");
            RecTransferLine.DeleteAll(true);
        end else begin
            RecTransferHeader."Service Order No." := Rec."Order No.";
            RecTransferHeader."Parts Trans. Archived Ver. No." := RecTransferHeader.GetPartsTransArchVerNo();
            RecTransferHeader.Insert(true);

            RecTransferHeader.Validate("Transfer-from Code", FromLocationCode);
            RecTransferHeader.Validate("Transfer-to Code", LocationCode);
            RecTransferHeader.Modify(true);
            if InServiceHeader."Parts Receive TO No. Filter" = '' then
                InServiceHeader."Parts Receive TO No. Filter" := RecTransferHeader."No."
            else
                InServiceHeader."Parts Receive TO No. Filter" :=
                    InServiceHeader."Parts Receive TO No. Filter" + '|' + RecTransferHeader."No.";
            InServiceHeader.Modify(true);
        end;

        LineNoTmp := 0;
        if Rec.FindSet() then
            repeat
                RecTransferLine.Init();
                RecTransferLine."Document No." := RecTransferHeader."No.";
                LineNoTmp += 10000;
                RecTransferLine."Line No." := LineNoTmp;
                RecTransferLine.Insert(true);

                RecTransferLine.Validate("Item No.", Rec."Item No.");
                RecTransferLine.Validate("Unit of Measure Code", Rec."Unit of Measure Code");
                RecTransferLine.Validate(Quantity, Rec."Qty. to Receive");
                RecTransferLine.Validate("Qty. to Ship", Rec."Qty. to Receive");
                RecTransferLine.Modify(true);
            until Rec.Next() = 0;
    end;

    local procedure CreateReturnTO(var InServiceHeader: Record 5900)
    begin
        Rec.Reset();
        Rec.SetRange("Order No.", InServiceHeader."No.");
        Rec.SetFilter("Qty. to Return", '>0');
        if not Rec.FindFirst() then
            exit;

        RecTransferHeader.Reset();
        if RecTransferHeader.Get(Rec."Return Transfer") then begin
            RecTransferLine.Reset();
            RecTransferLine.SetRange("Document No.", RecTransferHeader."No.");
            RecTransferLine.DeleteAll(true);
        end else begin
            RecTransferHeader.Insert(true);

            RecTransferHeader.Validate("Transfer-from Code", LocationCode);
            RecTransferHeader.Validate("Transfer-to Code", FromLocationCode);
            RecTransferHeader.Modify(true);

            if InServiceHeader."Parts Return TO No. Filter" = '' then
                InServiceHeader."Parts Return TO No. Filter" := RecTransferHeader."No."
            else
                InServiceHeader."Parts Return TO No. Filter" :=
                    InServiceHeader."Parts Return TO No. Filter" + '|' + RecTransferHeader."No.";

            InServiceHeader.Modify(true);
        end;

        LineNoTmp := 0;
        if Rec.FindSet() then
            repeat
                RecTransferLine.Init();
                RecTransferLine."Document No." := RecTransferHeader."No.";
                LineNoTmp += 10000;
                RecTransferLine."Line No." := LineNoTmp;
                RecTransferLine.Insert(true);

                RecTransferLine.Validate("Item No.", Rec."Item No.");
                RecTransferLine.Validate("Unit of Measure Code", Rec."Unit of Measure Code");
                RecTransferLine.Validate(Quantity, Rec."Qty. to Return");
                RecTransferLine.Validate("Qty. to Ship", Rec."Qty. to Return");
                RecTransferLine.Modify(true);
            until Rec.Next() = 0;
    end;

    local procedure GetAvailability(ItemNo: Code[20]): Decimal
    var
        AvailableToPromise: Codeunit "Available to Promise";
        PeriodType: Enum "Analysis Period Type";
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        AvailabilityDate: Date;
        LookaheadDateformula: DateFormula;
        Item: Record 27;
    begin
        if Item.Get(ItemNo) then begin
            InvSetup.Get();
            Item.SetRange("Date Filter", 0D, WorkDate);
            Item.SetRange("Location Filter", InvSetup."Def. Shipmt Location for Parts");
            Item.SetRange("Drop Shipment Filter", false);
            exit(AvailableToPromise.CalcQtyAvailableToPromise(
                Item,
                GrossRequirement,
                ScheduledReceipt,
                AvailabilityDate,
                PeriodType,
                LookaheadDateformula));
        end;
    end;

    local procedure AvailabilityDetail(ItemNo: Code[20])
    var
        Item: Record Item;
        ItemAvailByDate: Page "Item Availability by Periods";
    begin
        if Item.Get(ItemNo) then begin
            InvSetup.Get();
            Item.Reset();
            Item.SetRange("No.", Item."No.");
            Item.SetRange("Date Filter", 0D, WorkDate);
            Item.SetRange("Location Filter", InvSetup."Def. Shipmt Location for Parts");

            ItemAvailByDate.SetRecord(Item);
            ItemAvailByDate.SetTableView(Item);
            ItemAvailByDate.RunModal();
        end;
    end;

    procedure SetDefaultFilter(InLocationCode: Code[10]; InBinCode: Code[20]; InOrderNoFilter: Text[250])
    begin
        LocationCode := InLocationCode;
        BinCode := InBinCode;
        OrderNoFilter := InOrderNoFilter;
    end;

    procedure SetDefaultFilter2(LFromLocationCode: Code[10]; LFromBinCode: Code[20])
    begin
        GFromLocationCode := LFromLocationCode;
        GFromBinCode := LFromBinCode;
    end;
}
