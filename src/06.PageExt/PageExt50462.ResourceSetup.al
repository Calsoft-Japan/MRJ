pageextension 50462 "Resource Setup Ext" extends "Resources Setup"
{
    layout
    {
        addafter(Numbering)
        {
            group(MRJCustomization)
            {
                Caption = 'MRJ Customization';
                field("Charge Out Res. Grp. Filter"; Rec."Charge Out Res. Grp. Filter") { ApplicationArea = All; }
                field("Charge Out Credit Account"; Rec."Charge Out Credit Account") { ApplicationArea = All; }
            }
        }
    }
}