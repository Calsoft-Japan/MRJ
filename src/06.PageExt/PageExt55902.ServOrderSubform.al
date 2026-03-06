pageextension 55902 "Serv. Order Subform Ext" extends "Service Order Subform"
{
    actions
    {
        addbefore(Faults)
        {
            action(FaultArea)
            {
                ApplicationArea = All;
                Caption = 'Fault Area';
                Image = Error;
                trigger OnAction()
                begin
                    Rec.ShowComments("Service Comment Line Type"::"Fault Area");
                end;
            }
            action(Symtom)
            {
                ApplicationArea = All;
                Caption = 'Symptom';
                Image = Error;
                trigger OnAction()
                begin
                    Rec.ShowComments("Service Comment Line Type"::Symptom);
                end;
            }
        }
    }
}