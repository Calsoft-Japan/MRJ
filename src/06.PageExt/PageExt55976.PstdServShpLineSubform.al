pageextension 55976 "Pstd Serv Ship Subform Ext" extends "Posted Service Shpt. Subform"
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
                    Rec.ShowComments(6);
                end;
            }
            action(Symtom)
            {
                ApplicationArea = All;
                Caption = 'Symptom';
                Image = Error;
                trigger OnAction()
                begin
                    Rec.ShowComments(7);
                end;
            }
        }
    }

}