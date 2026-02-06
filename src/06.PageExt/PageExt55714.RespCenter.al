pageextension 55714 "Responsibility Center Ext" extends "Responsibility Center Card"
{
    layout
    {
        addafter("Phone No.")
        {
            field("Phone No. 2"; Rec."Phone No. 2") { ApplicationArea = All; }
        }
        addafter("Fax No.")
        {
            field("Fax No. 2"; Rec."Fax No. 2") { ApplicationArea = All; }
        }
    }
}