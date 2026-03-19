codeunit 50002 MRJTransferOrderMgt
{
    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Header", 'OnAfterCopyFromTransferHeader', '', true, true)]
    procedure OnAfterGetDefaultBin(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header");
    begin
        TransferShipmentHeader."Service Order No." := TransferHeader."Service Order No.";
        TransferShipmentHeader."Parts Trans. Archived Ver. No." := TransferHeader."Parts Trans. Archived Ver. No.";
    end;
}