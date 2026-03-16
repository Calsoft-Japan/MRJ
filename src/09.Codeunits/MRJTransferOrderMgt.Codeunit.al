/* codeunit 50002 MRJTransferOrderMgt
{
    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterGetDefaultBin', '', true, true)]
    procedure OnAfterGetDefaultBin(var TransferLine: Record "Transfer Line");
    var
        TransHeader: Record "Transfer Header";
    begin
        TransHeader := TransferLine.GetTransferHeader();
        if TransHeader."Default Bin Code (To)" <> '' then
            TransferLine."Transfer-To Bin Code" := TransHeader."Default Bin Code (To)";
    end; */