codeunit 50003 "MRJ Service Contract Mgt."
{
    [EventSubscriber(ObjectType::Table, Database::"Service Contract Line", 'OnValidateServiceItemNoOnBeforeModify', '', true, true)]
    procedure OnValidateServiceItemNoOnBeforeModify(sender: Record "Service Contract Line"; ServContractHeader: Record "Service Contract Header");
    begin
        sender."Starting Date" := ServContractHeader."Starting Date";
        sender."Contract Expiration Date" := ServContractHeader."Expiration Date";
        sender."Credit Memo Date" := ServContractHeader."Expiration Date";
    end;
}