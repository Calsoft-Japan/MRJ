pageextension 50313 "GenProdPostGroup Ext" extends "Gen. Product Posting Groups"
{
    layout
    {
        addlast(Control1)
        {
            field("Dimension Code"; Rec."Dimension Code")
            {
                ApplicationArea = All;
                Caption = 'Dimension Code';
            }
            field("Dimension Value Code"; Rec."Dimension Value Code")
            {
                ApplicationArea = All;
                Caption = 'Dimension Value Code';
            }
        }
    }
}