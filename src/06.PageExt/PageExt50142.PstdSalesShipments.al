pageextension 50142 "Pstd. Sales Shipments Ext" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}