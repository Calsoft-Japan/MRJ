pageextension 55907 "ServItem WorkSheet Subform Ext" extends "Service Item Worksheet Subform"
{
    layout
    {
        addbefore("Line Discount %")
        {
            field("Resource Cost"; Rec."Resource Cost")
            {
                ApplicationArea = All;
            }

        }

    }
}