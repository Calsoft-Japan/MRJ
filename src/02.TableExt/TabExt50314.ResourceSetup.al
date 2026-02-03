tableextension 50314 "Resource Setup Ext" extends "Resources Setup"
{
    fields
    {
        field(50000; "Charge Out Res. Grp. Filter"; Code[250])
        {
            Caption = 'Charge Out Res. Grp. Filter';
        }
        field(50001; "Charge Out Credit Account"; Code[20])
        {
            Caption = 'Charge Out Credit Account';
            TableRelation = "G/L Account";
        }
    }
}