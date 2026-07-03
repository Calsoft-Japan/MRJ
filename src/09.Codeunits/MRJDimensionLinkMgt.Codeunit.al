codeunit 50015 MRJDimensionLinkMgt
{
    // This event created to all Fault Reason Code table as default dimenion
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnBeforeValidateTableID', '', false, false)]
    local procedure OnBeforeValidateTableID(var RecDefaultDimension: Record "Default Dimension"; var IsHandled: Boolean)
    begin
        if RecDefaultDimension."Table ID" = Database::"Fault Reason Code" then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Line", 'OnAfterValidateEvent', "Fault Reason Code", false, false)]
    local procedure UpdateFaultReasonDimensions(var Rec: Record "Service Line")
    var
        GLSetup: Record "General Ledger Setup";
        DefDim: Record "Default Dimension";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, Rec."Dimension Set ID");
        DefDim.SetRange("Table ID", Database::"Fault Reason Code");
        DefDim.SetRange("No.", Rec."Fault Reason Code");
        if DefDim.FindSet() then
            repeat
                ReplaceDim(TempDimSetEntry, DefDim."Dimension Code", DefDim."Dimension Value Code");
            until DefDim.Next() = 0;

        Rec.Validate("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor", 'OnAfterInsertEvent', '', true, true)]
    procedure SetVendorDefDim(var Rec: Record Vendor);
    var
        PurchSetup: Record "Purchases & Payables Setup";
        DimensionValue: Record "Dimension Value";
        DefDimension: Record "Default Dimension";
    begin
        if Rec."No." = '' then
            exit;

        PurchSetup.Get();
        if not PurchSetup."Enable Vend. Dimension Link" then
            exit;

        PurchSetup.TestField("Vendor Dimension");
        if not DimensionValue.Get(PurchSetup."Vendor Dimension", Rec."No.") then begin
            DimensionValue.Init();
            DimensionValue."Dimension Code" := PurchSetup."Vendor Dimension";
            DimensionValue.Code := Rec."No.";
            DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
            DimensionValue.Insert(true);
        end;

        if not DefDimension.Get(Database::Vendor, Rec."No.", PurchSetup."Vendor Dimension") then begin
            DefDimension.Init;
            DefDimension.Validate("Table ID", Database::Vendor);
            DefDimension."No." := Rec."No.";

            DefDimension."Dimension Code" := PurchSetup."Vendor Dimension";
            DefDimension."Dimension Value Code" := Rec."No.";
            DefDimension."Value Posting" := DefDimension."Value Posting"::"Same Code";
            DefDimension.Insert(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer", 'OnAfterInsertEvent', '', true, true)]
    procedure SetCustomerDefDim(var Rec: Record Customer);
    var
        SalesSetup: Record "Sales & Receivables Setup";
        DimensionValue: Record "Dimension Value";
        DefDimension: Record "Default Dimension";
    begin
        if Rec."No." = '' then
            exit;

        SalesSetup.Get();
        if not SalesSetup."Enable Cust. Dimension Link" then
            exit;
        SalesSetup.TestField("Customer Dimension");
        if not DimensionValue.Get(SalesSetup."Customer Dimension", Rec."No.") then begin
            DimensionValue.Init();
            DimensionValue."Dimension Code" := SalesSetup."Customer Dimension";
            DimensionValue.Code := Rec."No.";
            DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
            DimensionValue.Insert(true);
        end;

        if not DefDimension.Get(Database::Customer, Rec."No.", SalesSetup."Customer Dimension") then begin
            DefDimension.Init;
            DefDimension.Validate("Table ID", Database::Customer);
            DefDimension."No." := Rec."No.";

            DefDimension."Dimension Code" := SalesSetup."Customer Dimension";
            DefDimension."Dimension Value Code" := Rec."No.";
            DefDimension."Value Posting" := DefDimension."Value Posting"::"Same Code";
            DefDimension.Insert(true);
        end;
    end;

    procedure SetSVOSrvOrdTypeDim(var ServHeader: Record "Service Header"; PrevDimSet: Integer)
    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        DimMgt: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimValue: Record "Dimension Value";
        ServItemLine: Record "Service Item Line";
        DimCode: Code[20];
        DimValueCode: Code[20];
        DimSetID: Integer;
        iLoop: Integer;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, PrevDimSet);

        SrvMgtSetup.Get();
        SrvMgtSetup.TestField("Service Order Type Dim Code");

        DimCode := SrvMgtSetup."Service Order Type Dim Code";
        DimValueCode := ServHeader."Service Order Type";

        if DimValueCode <> '' then
            ReplaceDim(TempDimSetEntry, DimCode, DimValueCode)
        else
            DeleteDim(TempDimSetEntry, DimCode);

        DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);

        ServHeader.Validate("Dimension Set ID", DimSetID);
        ServHeader.Modify(true);

        UpdSrvItemLineDim(ServHeader);
        UpdServiceLineDim(ServHeader);
    end;

    procedure SetSVOSalesPerDim(var ServHeader: Record "Service Header"; PrevDimSet: Integer)
    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        DimMgt: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        ServItemLine: Record "Service Item Line";
        DimCode: Code[20];
        DimValueCode: Code[20];
        DimSetID: Integer;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, PrevDimSet);

        SrvMgtSetup.Get();
        SrvMgtSetup.TestField("Employee Dim Code");

        DimCode := SrvMgtSetup."Employee Dim Code";
        DimValueCode := ServHeader."Salesperson Code";

        if DimValueCode <> '' then
            ReplaceDim(TempDimSetEntry, DimCode, DimValueCode)
        else
            DeleteDim(TempDimSetEntry, DimCode);

        DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);

        ServHeader.Validate("Dimension Set ID", DimSetID);
        ServHeader.Modify(true);

        UpdSrvItemLineDim(ServHeader);
        UpdServiceLineDim(ServHeader);
    end;

    local procedure UpdSrvItemLineDim(ServHeader: Record "Service Header")
    var
        ServItemLine: Record "Service Item Line";
    begin
        ServItemLine.SetRange("Document Type", ServHeader."Document Type");
        ServItemLine.SetRange("Document No.", ServHeader."No.");
        if ServItemLine.FindSet(true) then
            repeat
                if ServItemLine."Dimension Set ID" <> ServHeader."Dimension Set ID" then begin
                    ServItemLine.Validate("Dimension Set ID", ServHeader."Dimension Set ID");
                    ServItemLine.Modify(true);
                end;
            until ServItemLine.Next() = 0;
    end;

    local procedure UpdServiceLineDim(ServHeader: Record "Service Header")
    var
        ServiceLine: Record "Service Line";
        HdrDimSetEntry: Record "Dimension Set Entry" temporary;
        LineDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        NewDimSetID: Integer;
    begin
        ServiceLine.SetRange("Document Type", ServHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServHeader."No.");
        if ServiceLine.FindSet(true) then
            repeat
                HdrDimSetEntry.DeleteAll();
                LineDimSetEntry.DeleteAll();
                DimMgt.GetDimensionSet(HdrDimSetEntry, ServHeader."Dimension Set ID");
                DimMgt.GetDimensionSet(LineDimSetEntry, ServiceLine."Dimension Set ID");
                if HdrDimSetEntry.FindSet() then
                    repeat
                        ReplaceDim(LineDimSetEntry, HdrDimSetEntry."Dimension Code", HdrDimSetEntry."Dimension Value Code");
                    until HdrDimSetEntry.Next() = 0;
                NewDimSetID := DimMgt.GetDimensionSetID(LineDimSetEntry);
                if NewDimSetID <> ServiceLine."Dimension Set ID" then begin
                    ServiceLine.Validate("Dimension Set ID", NewDimSetID);
                    ServiceLine.Modify(true);
                end;
            until ServiceLine.Next() = 0;
    end;

    procedure SetSrvOrdTypeSalesPerDim(var ServHeader: Record "Service Header"; PrevDimSet: Integer)
    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        DimMgt: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimValue: Record "Dimension Value";
        ServItemLine: Record "Service Item Line";
        DimCode: Code[20];
        DimValueCode: Code[20];
        DimSetID: Integer;
        iLoop: Integer;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, PrevDimSet);

        SrvMgtSetup.Get();
        SrvMgtSetup.TestField("Service Order Type Dim Code");
        SrvMgtSetup.TestField("Employee Dim Code");
        for iLoop := 1 to 2 do begin
            case iLoop of
                1:
                    begin
                        DimCode := SrvMgtSetup."Service Order Type Dim Code";
                        DimValueCode := ServHeader."Service Order Type";
                    end;
                2:
                    begin
                        DimCode := SrvMgtSetup."Employee Dim Code";
                        DimValueCode := ServHeader."Salesperson Code";
                    end;
            end;

            if DimValueCode <> '' then
                ReplaceDim(TempDimSetEntry, DimCode, DimValueCode)
            else
                DeleteDim(TempDimSetEntry, DimCode);
        end;

        DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);

        ServHeader."Dimension Set ID" := DimSetID;
        ServHeader.Modify(true);
    end;

    procedure SetSVODocDim(var ServHeader: Record "Service Header")
    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        DimMgt: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimValue: Record "Dimension Value";
        ServItemLine: Record "Service Item Line";
        DimCode: Code[20];
        DimValueCode: Code[20];
        DimSetID: Integer;
        iLoop: Integer;
    begin
        if (ServHeader."Document Type" <> ServHeader."Document Type"::Order) and
           (ServHeader."Document Type" <> ServHeader."Document Type"::"Credit Memo") and
           (ServHeader."Document Type" <> ServHeader."Document Type"::Quote) then
            exit;

        if ServHeader."No." = '' then
            exit;

        SrvMgtSetup.Get();
        if not SrvMgtSetup."Enable Dimension Link" then
            exit;

        SrvMgtSetup.TestField("Sales Order Dim Code");
        SrvMgtSetup.TestField("Service Order Dim Code");
        SrvMgtSetup.TestField("Service Order Type Dim Code");
        SrvMgtSetup.TestField("Cost Center Dim Code");

        //Ensure Dimension Value exists (same as NAV logic)
        if ServHeader."Document Type" = ServHeader."Document Type"::Order then begin
            if not DimValue.Get(SrvMgtSetup."Service Order Dim Code", ServHeader."No.") then begin
                DimValue.Init();
                DimValue."Dimension Code" := SrvMgtSetup."Service Order Dim Code";
                DimValue.Code := ServHeader."No.";
                DimValue."Dimension Value Type" := DimValue."Dimension Value Type"::Standard;
                DimValue.Insert(true);
            end;
        end;

        DimMgt.GetDimensionSet(TempDimSetEntry, ServHeader."Dimension Set ID");

        for iLoop := 1 to 5 do begin
            case iLoop of
                1:
                    begin
                        DimCode := SrvMgtSetup."Sales Order Dim Code";
                        DimValueCode := ServHeader."Sales Order Dim Code";
                    end;
                2:
                    begin
                        DimCode := SrvMgtSetup."Service Order Dim Code";
                        if ServHeader."Document Type" = ServHeader."Document Type"::Order then
                            DimValueCode := ServHeader."No."
                        else
                            DimValueCode := ServHeader."Service Order Dim Code";
                    end;
                3:
                    begin
                        DimCode := SrvMgtSetup."Service Order Type Dim Code";
                        DimValueCode := ServHeader."Service Order Type Dim Code";
                    end;
                4:
                    begin
                        DimCode := SrvMgtSetup."Cost Center Dim Code";
                        DimValueCode := ServHeader."Cost Center Dim Code";
                    end;
                5:
                    begin
                        DimCode := SrvMgtSetup."Proserv Dim Code";
                        DimValueCode := ServHeader."Proserv Dim Code";
                    end;
            end;

            if DimValueCode <> '' then
                ReplaceDim(TempDimSetEntry, DimCode, DimValueCode);
        end;

        DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);

        ServHeader."Dimension Set ID" := DimSetID;
        ServHeader.Modify(true);

        ServItemLine.Reset();
        ServItemLine.SetRange("Document Type", ServHeader."Document Type");
        ServItemLine.SetRange("Document No.", ServHeader."No.");
        if ServItemLine.FindSet() then
            repeat
                DimMgt.GetDimensionSet(TempDimSetEntry, ServItemLine."Dimension Set ID");

                for iLoop := 1 to 2 do begin
                    case iLoop of
                        1:
                            begin
                                DimCode := SrvMgtSetup."Sales Order Dim Code";
                                DimValueCode := ServItemLine."Sales Order Dim Code";
                            end;
                        2:
                            begin
                                DimCode := SrvMgtSetup."Service Order Dim Code";
                                if ServItemLine."Document Type" = ServItemLine."Document Type"::Order then
                                    DimValueCode := ServHeader."No."
                                else
                                    DimValueCode := ServItemLine."Service Order Dim Code";
                            end;
                    end;

                    if DimValueCode <> '' then
                        ReplaceDim(TempDimSetEntry, DimCode, DimValueCode);
                end;

                DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);

                ServItemLine."Dimension Set ID" := DimSetID;
                ServItemLine.Modify(true);

            until ServItemLine.Next() = 0;
    end;

    local procedure ReplaceDim(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimCode: Code[20]; DimValue: Code[20])
    var
        Existing: Boolean;
    begin
        Existing := false;
        TempDimSetEntry.Reset();
        TempDimSetEntry.SetRange("Dimension Code", DimCode);
        if TempDimSetEntry.FindFirst() then begin
            Existing := true;
            if TempDimSetEntry."Dimension Value Code" <> DimValue then begin
                TempDimSetEntry.Validate("Dimension Value Code", DimValue);
                TempDimSetEntry.Modify(true);
            end;
        end;

        if not Existing then begin
            TempDimSetEntry.Reset();
            TempDimSetEntry.Init();
            TempDimSetEntry."Dimension Code" := DimCode;
            TempDimSetEntry."Dimension Value Code" := DimValue;
            TempDimSetEntry.Insert(true);
        end;
    end;

    local procedure DeleteDim(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimCode: Code[20])
    begin
        TempDimSetEntry.Reset();
        TempDimSetEntry.SetRange("Dimension Code", DimCode);
        TempDimSetEntry.DeleteAll();
        TempDimSetEntry.Reset();
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
        DimErr: Label 'Dimension %1 not found.';
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
                        Error(DimErr, DimCode);
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

    procedure BakPOPIDocDim(var PurchHeader: Record "Purchase Header")
    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        DimSetEntry: Record "Dimension Set Entry";
        DimCode: Code[20];
    begin
        if (PurchHeader."Document Type" <> PurchHeader."Document Type"::Order) and
           (PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice) and
           (PurchHeader."Document Type" <> PurchHeader."Document Type"::"Credit Memo") then
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

    /* [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInsertEvent', '', true, true)]
    procedure SetPOPIDocDim(var Rec: Record "Purchase Header")
    var
        ServMgtSetup: Record "Service Mgt. Setup";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        DimCode: Code[20];
        DimValueCode: Code[20];
        iLoop: Integer;
    begin
        if (Rec."Document Type" <> Rec."Document Type"::Order) and
           (Rec."Document Type" <> Rec."Document Type"::Invoice) and
           (Rec."Document Type" <> Rec."Document Type"::"Credit Memo") then
            exit;

        if Rec."No." = '' then
            exit;

        ServMgtSetup.Get();
        if not ServMgtSetup."Enable Dimension Link" then
            exit;

        ServMgtSetup.TestField("Sales Order Dim Code");
        ServMgtSetup.TestField("Service Order Dim Code");
        ServMgtSetup.TestField("Service Order Type Dim Code");
        ServMgtSetup.TestField("Cost Center Dim Code");

        // Load existing Dimension Set into temp
        DimMgt.GetDimensionSet(TempDimSetEntry, Rec."Dimension Set ID");

        for iLoop := 1 to 5 do begin
            case iLoop of
                1:
                    begin
                        DimCode := ServMgtSetup."Sales Order Dim Code";
                        DimValueCode := Rec."Sales Order Dim Code";
                    end;
                2:
                    begin
                        DimCode := ServMgtSetup."Service Order Dim Code";
                        DimValueCode := Rec."Service Order Dim Code";
                    end;
                3:
                    begin
                        DimCode := ServMgtSetup."Service Order Type Dim Code";
                        DimValueCode := Rec."Service Order Type Dim Code";
                    end;
                4:
                    begin
                        DimCode := ServMgtSetup."Cost Center Dim Code";
                        DimValueCode := Rec."Cost Center Dim Code";
                    end;
                5:
                    begin
                        DimCode := ServMgtSetup."Proserv Dim Code";
                        DimValueCode := Rec."Proserv Dim Code";
                    end;
            end;

            if DimValueCode <> '' then begin
                // Remove existing dimension (if exists)
                TempDimSetEntry.SetRange("Dimension Code", DimCode);
                if TempDimSetEntry.FindFirst() then
                    TempDimSetEntry.DeleteAll();

                TempDimSetEntry.Reset();

                // Add new dimension value
                TempDimSetEntry.Init();
                TempDimSetEntry."Dimension Code" := DimCode;
                TempDimSetEntry."Dimension Value Code" := DimValueCode;
                TempDimSetEntry.Insert();
            end;
        end;

        // Create new Dimension Set ID
        Rec."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end; */
}