pageextension 55740 "Transfer Order Ext" extends "Transfer Order"
{
    layout
    {
        addafter(Status)
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