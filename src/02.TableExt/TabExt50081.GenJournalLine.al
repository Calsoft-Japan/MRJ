tableextension 50081 "Gen. Jnl. Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50020; "Source Ledger Entry Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
            OptionCaption = ' ,Service Ledger,Resource Ledger';
            OptionMembers = " ","Service Ledger","Resource Ledger";
        }
        field(50025; "Source Ledger Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}

