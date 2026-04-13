codeunit 50001 MRJServiceOrderInvoiceMgt
{
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
    var
        ServiceHeader: Record "Service Header";
    begin
        ServiceLine."Bin Code" := ServiceLine."Document No.";
        IsHandled := true;
    end;
}