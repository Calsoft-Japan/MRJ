pageextension 55743 "Pstd Trans Shipment Ext" extends "Posted Transfer Shipment"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Service Order No."; Rec."Service Order No.")
            {
                ApplicationArea = All;
            }
            field("Parts Trans. Archived Ver. No."; Rec."Parts Trans. Archived Ver. No.")
            {
                ApplicationArea = All;
            }
        }
    }
}