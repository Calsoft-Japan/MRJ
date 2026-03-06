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
}