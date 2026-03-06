pageextension 55970 "Pstd. Serv. Shipment Lines Ext" extends "Posted Service Shipment Lines"
{
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
                    ServShipHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Pstd. Service Work Report", true, false, ServShipHeader);
                end;
            }
        }
    }
}