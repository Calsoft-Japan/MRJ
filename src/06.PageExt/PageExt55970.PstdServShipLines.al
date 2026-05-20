pageextension 55970 "Pstd. Serv. Shipment Lines Ext" extends "Posted Service Shipment Lines"
{
    layout
    {
        addbefore("Quantity")
        {
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = All;
            }
            field("Amount"; Rec."Amount")
            {
                ApplicationArea = All;
            }



        }

    }
    actions
    {
        addafter("&Navigate_Promoted")
        {
            actionref(ServiceWorkRep_Promoted; ServiceWorkRep) { }
        }
        addafter("&Navigate")
        {
            action(ServiceWorkRep)
            {
                ApplicationArea = Service;
                Caption = 'Service Report';
                Image = Report;
                trigger OnAction()
                var
                    ServShipHeader: Record "Service Shipment Header";
                begin
                    Clear(ServShipHeader);
                    ServShipHeader.SetRange("No.", Rec."Document No.");
                    Report.Run(Report::"Pstd. Service Work Report", true, false, ServShipHeader);
                end;
            }
        }
    }
}