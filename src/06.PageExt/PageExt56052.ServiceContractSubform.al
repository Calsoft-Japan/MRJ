pageextension 56052 "Service Contract Subform Ext" extends "Service Contract Subform"
{
    layout
    {
        addbefore("Line Cost")
        {
            field("Contract Line Value"; Rec."Contract Line Value")
            {
                ApplicationArea = All;
            }

        }

    }
}
