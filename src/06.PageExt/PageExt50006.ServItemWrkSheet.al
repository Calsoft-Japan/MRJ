pageextension 50006 "Serv Item WorkSheet Ext" extends "Service Item Worksheet"
{
    actions
    {
        addafter("&Troubleshooting")
        {
            group(PurchOrder)
            {
                Caption = 'Purchase Order';
                action(Show)
                {
                    ApplicationArea = All;
                    Caption = 'Show';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    //PromotedCategory = Category4;
                    Image = ShowList;
                    RunObject = page "Purchase List";
                    RunPageView = where("Document Type" = const(Order));
                    RunPageLink = "Service Order No." = field("Document No."), "Service Item Line No." = field("Line No.");
                }
                action(CreateParts)
                {
                    ApplicationArea = All;
                    Caption = 'Create (Parts)';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    //PromotedCategory = Category4;
                    Image = CreateDocument;
                    trigger OnAction()
                    begin
                        if Rec."Document Type" <> Rec."Document Type"::Order then
                            Error(Text020);

                        if Dialog.Confirm(Text007, true) then
                            CreatePurchOrder(false);
                    end;
                }
                action(CreateOutsource)
                {
                    ApplicationArea = All;
                    Caption = 'Create (Outsource)';
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    //PromotedCategory = Category4;
                    Image = CreateDocument;
                    trigger OnAction()
                    var

                    begin
                        if Rec."Document Type" <> Rec."Document Type"::Order then
                            Error(Text020);

                        if Dialog.Confirm(Text007, true) then
                            CreatePurchOrder(true);
                    end;
                }
            }
        }
        addafter("&Print")
        {
            action(ServiceReport)
            {
                ApplicationArea = Service;
                Caption = 'Service Report';
                Image = Report;
                Promoted = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    ServHeader: Record "Service Header";
                begin
                    Clear(ServHeader);
                    ServHeader.SetRange("Document Type", Rec."Document Type");
                    ServHeader.SetRange("No.", Rec."Document No.");
                    Report.Run(Report::"Service Work Report", true, false, ServHeader);
                end;
            }
        }
    }
    local procedure CreatePurchOrder(IsOutsource: Boolean)
    var
        ServMgtSetup: Record "Service Mgt. Setup";
        Vendor: Record Vendor;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        ServLine: Record "Service Line";
        VendorNo: Code[20];
    begin
        Clear(Vendor);
        VendorNo := '';
        if Page.RunModal(Page::"Vendor List", Vendor) = Action::LookupOK then
            VendorNo := Vendor."No.";
        if not Vendor.Get(VendorNo) then
            Error(Text009);

        Clear(PurchHeader);
        PurchHeader.Validate("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.Insert(true);
        PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
        PurchHeader."Service Order No." := Rec."Document No.";
        PurchHeader."Service Item Line No." := Rec."Line No.";
        PurchHeader."Responsibility Center" := Rec."Responsibility Center";
        PurchHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
        PurchHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        //PurchHeader."Dimension Set ID" := Rec."Dimension Set ID";
        PurchHeader.Modify(true);

        if Rec."Document Type" = Rec."Document Type"::Order then
            CpySVIDocDim2POPI(PurchHeader);

        if IsOutsource then begin
            ServMgtSetup.Get();
            Clear(PurchLine);
            PurchLine.Validate("Document Type", PurchLine."Document Type"::Order);
            PurchLine.Validate("Document No.", PurchHeader."No.");
            PurchLine."Line No." := 10000;
            PurchLine.Validate(Type, PurchLine.Type::"G/L Account");
            PurchLine.Validate("No.", ServMgtSetup."G/L Account for Repair");
            PurchLine.Validate(Quantity, 1);
            PurchLine.Insert(true);
        end else begin
            ServLine.Reset();
            ServLine.SetRange("Document Type", Rec."Document Type");
            ServLine.SetRange("Document No.", Rec."Document No.");
            ServLine.SetRange("Service Item Line No.", Rec."Line No.");
            ServLine.SetRange(Type, ServLine.Type::Item);
            if ServLine.FindSet() then begin
                Clear(PurchLine);
                PurchLine."Document Type" := PurchLine."Document Type"::Order;
                PurchLine."Document No." := PurchHeader."No.";
                PurchLine."Line No." := 0;
                repeat
                    PurchLine.Init();
                    PurchLine."Line No." += 10000;
                    PurchLine.Validate(Type, PurchLine.Type::Item);
                    PurchLine.Validate("No.", ServLine."No.");
                    PurchLine.Validate(Quantity, ServLine.Quantity);
                    PurchLine.Validate("Unit of Measure Code", ServLine."Unit of Measure Code");
                    PurchLine.Insert(true);
                until ServLine.Next() = 0;
            end;
        end;

        if Dialog.Confirm(StrSubstNo(Text011, PurchHeader."No."), true) then begin
            Commit();
            Page.RunModal(Page::"Purchase Order", PurchHeader);
        end;
    end;

    procedure CpySVIDocDim2POPI(var PurchHeader: Record "Purchase Header")
    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        FromDimSetEntry: Record "Dimension Set Entry";
        ServHeader: Record "Service Header";
        ServItemLine: Record "Service Item Line";
        DimMgt: Codeunit DimensionManagement;
        DimSetID: Integer;
        DimCode: Code[20];
        iLoop: Integer;
        Found: Boolean;
    begin
        if (PurchHeader."Document Type" <> PurchHeader."Document Type"::Order) and
           (PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice)
        then
            exit;

        if PurchHeader."No." = '' then
            exit;

        SrvMgtSetup.Get();

        if not SrvMgtSetup."Enable Dimension Link" then
            exit;
        SrvMgtSetup.TestField("Sales Order Dim Code");
        SrvMgtSetup.TestField("Service Order Dim Code");
        SrvMgtSetup.TestField("Service Order Type Dim Code");
        SrvMgtSetup.TestField("Cost Center Dim Code");

        DimMgt.GetDimensionSet(TempDimSetEntry, PurchHeader."Dimension Set ID");

        for iLoop := 1 to 5 do begin
            case iLoop of
                1:
                    DimCode := SrvMgtSetup."Sales Order Dim Code";
                2:
                    DimCode := SrvMgtSetup."Service Order Dim Code";
                3:
                    DimCode := SrvMgtSetup."Service Order Type Dim Code";
                4:
                    DimCode := SrvMgtSetup."Cost Center Dim Code";
                5:
                    DimCode := SrvMgtSetup."Proserv Dim Code";
            end;

            if (iLoop <> 1) or SrvMgtSetup."Enable SO Dim Code Copy" then begin
                Found := false;
                // From Service Header
                if ServHeader.Get(ServHeader."Document Type"::Order, PurchHeader."Service Order No.") then begin
                    FromDimSetEntry.SetRange("Dimension Set ID", ServHeader."Dimension Set ID");
                    FromDimSetEntry.SetRange("Dimension Code", DimCode);
                    if FromDimSetEntry.FindFirst() then begin
                        ReplaceDim(TempDimSetEntry, DimCode, FromDimSetEntry."Dimension Value Code");
                        Found := true;
                    end;
                end;

                //From Service Item Line (override)
                if ServItemLine.Get(ServItemLine."Document Type"::Order, PurchHeader."Service Order No.",
                                    PurchHeader."Service Item Line No.") then begin
                    FromDimSetEntry.Reset();
                    FromDimSetEntry.SetRange("Dimension Set ID", ServItemLine."Dimension Set ID");
                    FromDimSetEntry.SetRange("Dimension Code", DimCode);
                    if FromDimSetEntry.FindFirst() then begin
                        ReplaceDim(TempDimSetEntry, DimCode, FromDimSetEntry."Dimension Value Code");
                        Found := true;
                    end;
                end;

                if not Found then begin
                    if iLoop <> 5 then
                        Error('Dimension %1 not found.', DimCode);
                end;
            end;
        end;

        //Create new Dimension Set ID
        DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);

        PurchHeader."Dimension Set ID" := DimSetID;
        PurchHeader.Modify(true);

        // Optional backup logic
        BakPOPIDocDim(PurchHeader);
    end;

    local procedure ReplaceDim(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimCode: Code[20]; DimValue: Code[20])
    begin
        TempDimSetEntry.SetRange("Dimension Code", DimCode);
        if TempDimSetEntry.FindFirst() then
            TempDimSetEntry.DeleteAll();

        TempDimSetEntry.Reset();

        TempDimSetEntry.Init();
        TempDimSetEntry."Dimension Code" := DimCode;
        TempDimSetEntry."Dimension Value Code" := DimValue;
        TempDimSetEntry.Insert(true);
    end;

    local procedure InsertTempDim(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimCode: Code[20]; DimValue: Code[20])
    begin
        TempDimSetEntry.Init();
        TempDimSetEntry."Dimension Code" := DimCode;
        TempDimSetEntry."Dimension Value Code" := DimValue;
        if not TempDimSetEntry.Insert(true) then
            TempDimSetEntry.Modify();
    end;

    procedure BakPOPIDocDim(var PurchHeader: Record "Purchase Header")
    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        DimSetEntry: Record "Dimension Set Entry";
        DimCode: Code[20];
    begin
        if (PurchHeader."Document Type" <> PurchHeader."Document Type"::Order) and
           (PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice) and
           (PurchHeader."Document Type" <> PurchHeader."Document Type"::"Credit Memo")
        then
            exit;

        if PurchHeader."No." = '' then
            exit;

        SrvMgtSetup.Get();

        if not SrvMgtSetup."Enable Dimension Link" then
            exit;

        //Clear custom fields
        PurchHeader."Sales Order Dim Code" := '';
        PurchHeader."Service Order Dim Code" := '';
        PurchHeader."Service Order Type Dim Code" := '';
        PurchHeader."Cost Center Dim Code" := '';
        PurchHeader."Proserv Dim Code" := '';

        //Sales Order Dimension
        DimCode := SrvMgtSetup."Sales Order Dim Code";
        PurchHeader."Sales Order Dim Code" := GetDimValue(PurchHeader."Dimension Set ID", DimCode);

        //Service Order Dimension
        DimCode := SrvMgtSetup."Service Order Dim Code";
        PurchHeader."Service Order Dim Code" := GetDimValue(PurchHeader."Dimension Set ID", DimCode);

        //Service Order Type Dimension
        DimCode := SrvMgtSetup."Service Order Type Dim Code";
        PurchHeader."Service Order Type Dim Code" := GetDimValue(PurchHeader."Dimension Set ID", DimCode);

        //Cost Center Dimension
        DimCode := SrvMgtSetup."Cost Center Dim Code";
        PurchHeader."Cost Center Dim Code" := GetDimValue(PurchHeader."Dimension Set ID", DimCode);

        //Proserv Dimension
        DimCode := SrvMgtSetup."Proserv Dim Code";
        PurchHeader."Proserv Dim Code" := GetDimValue(PurchHeader."Dimension Set ID", DimCode);

        PurchHeader.Modify();
    end;

    local procedure GetDimValue(DimSetID: Integer; DimCode: Code[20]): Code[20]
    var
        DimSetEntry: Record "Dimension Set Entry";
    begin
        if DimSetID = 0 then
            exit('');

        DimSetEntry.SetRange("Dimension Set ID", DimSetID);
        DimSetEntry.SetRange("Dimension Code", DimCode);

        if DimSetEntry.FindFirst() then
            exit(DimSetEntry."Dimension Value Code");

        exit('');
    end;

    var
        Text007: Label 'Do you want to create Purchase Order?';
        Text009: Label 'Process is cancelled because Vendor No.  is empty.';
        Text011: Label 'Purchase Order ''%1'' was created, do you want to open?';
        Text020: Label 'The function is effective on the Service Order only.';
}