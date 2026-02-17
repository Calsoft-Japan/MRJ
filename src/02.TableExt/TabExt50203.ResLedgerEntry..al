tableextension 50203 "Res. Led Entry Ext" extends "Res. Ledger Entry"
{
    fields
    {
        field(50010; "Charge Out Posted to G/L"; Boolean)
        {
            Caption = 'Charge Out Posted to G/L';
        }
        field(50011; "G/L Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(MRJKey; "Charge Out Posted to G/L") { }
    }
}

