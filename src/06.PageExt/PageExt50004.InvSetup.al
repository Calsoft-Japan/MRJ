pageextension 50004 "Inv Setup Ext" extends "Inventory Setup"
{
    layout
    {
        addafter(Location)
        {
            group(MRJCustomization)
            {
                Caption = 'MRJ Customization';
                field("Def. Shipmt Location for Parts"; Rec."Def. Shipmt Location for Parts")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}