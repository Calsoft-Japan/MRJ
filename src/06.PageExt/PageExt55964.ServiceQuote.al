pageextension 55964 "Service Quote Ext" extends "Service Quote"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Quote Valid to Date"; Rec."Quote Valid to Date") { ApplicationArea = All; }
        }
    }
}