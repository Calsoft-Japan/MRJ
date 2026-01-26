tableextension 55911 "Serv. Mgt. Setup Ext" extends "Service Mgt. Setup"
{
    fields
    {
        field(90016; "G/L Account for Repair"; Code[20])
        {
            Caption = 'G/L Account for Repair';
            TableRelation = "G/L Account";
        }
    }
}

