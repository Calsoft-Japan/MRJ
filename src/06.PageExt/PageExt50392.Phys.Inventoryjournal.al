pageextension 50392 "Phys. Inventory Journal Ext" extends "Phys. Inventory Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("Item No.2"; Rec."Item No.2")
            {
                ApplicationArea = All;
            }
            field("Description2"; Rec."Description2")
            {
                ApplicationArea = All;
            }
            field("New Shelf No."; Rec."New Shelf No.")
            {
                ApplicationArea = All;
                Caption = 'New Shelf No.';
                ToolTip = 'Shows the new shelf number from Item master.';
                Editable = false;
            }
            field("Shelf No. (Osaka)"; Rec."Shelf No. (Osaka)")
            {
                ApplicationArea = All;
            }
            field("Shelf No. (Niigata)"; Rec."Shelf No. (Niigata)")
            {
                ApplicationArea = All;
            }
            field("Shelf No. (Sendai)"; Rec."Shelf No. (Sendai)")
            {
                ApplicationArea = All;
            }
            field("Shelf No. (Fukuoka)"; Rec."Shelf No. (Fukuoka)")
            {
                ApplicationArea = All;
            }
            field("Shelf No. (Nagoya)"; Rec."Shelf No. (Nagoya)")
            {
                ApplicationArea = All;
            }
        }
    }
}