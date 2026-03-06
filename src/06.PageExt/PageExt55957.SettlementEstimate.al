pageextension 55975 "MRJ Posted Service Shipment" extends "Posted Service Shipment"
{
    actions
    {
        addlast(Processing)
        {
            action(SettleMentEstimate)
            {
                Caption = 'Settlement Estimate';
                ApplicationArea = All;
                Image = Print;

                Promoted = true;
                PromotedIsBig = false;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ServShptHdr: Record "Service Shipment Header";
                begin
                    ServShptHdr.Reset();
                    ServShptHdr.SetRange("No.", Rec."No.");
                    ServShptHdr.FindFirst();

                    Report.RunModal(Report::"MRJ Settlement Estimate", true, true, ServShptHdr);
                end;
            }
        }
    }
}