pageextension 56050 "Service Contract Ext" extends "Service Contract"
{
    layout
    {
        addbefore("Status")
        {
            field("Contract Period"; Rec."Contract Period")
            {
                ApplicationArea = All;
            }

        }

    }
}
