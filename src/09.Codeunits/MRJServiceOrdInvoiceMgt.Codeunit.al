codeunit 50001 MRJServiceOrderInvoiceMgt
{

    [EventSubscriber(ObjectType::Table, Database::"Service Header", OnAfterInsertEvent, '', true, true)]
    procedure SrvHeaderOnAfterInsertEvent(var Rec: Record "Service Header");
    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        NewBin: Record Bin;
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        if Rec."No." = '' then
            exit;

        SrvMgtSetup.Get();
        if SrvMgtSetup."Serv Ord Reservation Location" = '' then
            exit;

        // Create Bin if not exists
        CreateNewBin(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Header", OnAfterValidateEvent, "Customer No.", true, true)]
    procedure CustNoOnAfterValidateEvent(var Rec: Record "Service Header"; var xRec: Record "Service Header");
    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        NewBin: Record Bin;
        MRJDimLinkMgt: Codeunit MRJDimensionLinkMgt;
    begin
        MRJDimLinkMgt.SetSVODocDim(Rec);

        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        SrvMgtSetup.Get();
        if Rec."Customer No." <> '' then
            if SrvMgtSetup."Serv Ord Reservation Location" <> '' then
                if not NewBin.Get(Rec."Location Code", Rec."No.") then
                    CreateNewBin(Rec)
                else
                    ModifyBinInfo(Rec, NewBin);
        Rec.Validate("Bin Code", Rec."No.");
    end;

    local procedure CreateNewBin(var Rec: Record "Service Header")
    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        NewBin: Record Bin;
    begin
        SrvMgtSetup.Get();
        if not NewBin.Get(SrvMgtSetup."Serv Ord Reservation Location", Rec."No.") then begin
            NewBin.Init();
            NewBin.Validate("Location Code", SrvMgtSetup."Serv Ord Reservation Location");
            NewBin.Validate(Code, Rec."No.");
            NewBin.Validate("Customer No.", Rec."Customer No.");
            NewBin.Description := Rec."No.";
            NewBin.Insert(true);
        end;
    end;

    local procedure ModifyBinInfo(var Rec: Record "Service Header"; var NewBin: Record Bin)
    begin
        NewBin.Validate("Customer No.", Rec."Customer No.");
        NewBin.Description := Rec."No.";
        NewBin.Modify(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Header", OnAfterValidateEvent, "Service Order Type", true, true)]
    procedure ServOrdTypeOnAfterValidateEvent(var Rec: Record "Service Header");
    var
        MRJDimLinkMgt: Codeunit MRJDimensionLinkMgt;
    begin
        MRJDimLinkMgt.SetSVODocDim(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Header", OnAfterValidateEvent, "Salesperson Code", true, true)]
    procedure SalesPersonOnAfterValidateEvent(var Rec: Record "Service Header");
    var
        MRJDimLinkMgt: Codeunit MRJDimensionLinkMgt;
    begin
        MRJDimLinkMgt.SetSVODocDim(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Header", OnAfterCopyCustomerFields, '', true, true)]
    procedure OnAfterCopyCustomerFields(var ServiceHeader: Record "Service Header"; Customer: Record Customer);
    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        UserMgt: Codeunit "User Setup Management";
    begin
        SrvMgtSetup.Get();
        if ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order then
            if SrvMgtSetup."Serv Ord Reservation Location" <> '' then
                ServiceHeader.Validate("Location Code", SrvMgtSetup."Serv Ord Reservation Location")
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Item Line", 'OnShowCommentsOnCaseElse', '', true, true)]
    procedure SetVendorDefDim(var ServiceCommentLine: Record "Service Comment Line"; ServiceCommentLineType: Enum "Service Comment Line Type");
    begin
        case ServiceCommentLineType of
            ServiceCommentLineType::"Fault Area":
                ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::"Fault Area");
            ServiceCommentLineType::Symptom:
                ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::Symptom);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Serv-Documents Mgt.", 'OnBeforeServShptLineInsert', '', true, true)]
    procedure OnBeforeServShptLineInsert(var ServiceShipmentLine: Record "Service Shipment Line"; ServiceLine: Record "Service Line");
    var
        ServLine: Record "Service Line";
    begin
        if ServLine.Get(ServiceLine."Document Type", ServiceLine."Document No.", ServiceLine."Line No.") then begin
            ServiceShipmentLine.Amount := ServLine.Amount;
            ServiceShipmentLine."Amount Including VAT" := ServLine."Amount Including VAT";
            ServiceShipmentLine."Shipment Line Discount Amount" := ServLine."Line Discount Amount";
            ServiceShipmentLine."Shipment Amount" := ServLine.Amount;
            ServiceShipmentLine."Shipment Line Amount" := ServLine."Line Amount";
            ServiceShipmentLine."Shipment Inv. Disc. Amount" := ServLine."Inv. Discount Amount";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Line", 'OnBeforeGetDefaultBin', '', true, true)]
    procedure OnBeforeGetDefaultBin(var ServiceLine: Record "Service Line"; var IsHandled: Boolean);
    begin
        ServiceLine."Bin Code" := ServiceLine."Document No.";
        IsHandled := true;
    end;
}