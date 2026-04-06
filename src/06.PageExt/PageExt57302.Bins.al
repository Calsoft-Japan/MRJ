pageextension 57302 "Bins Ext" extends Bins
{
    layout
    {
        addafter(Description)
        {
            field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
        }
    }
}