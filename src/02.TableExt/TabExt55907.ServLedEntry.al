tableextension 55907 "Serv. Led. Entry Ext" extends "Service Ledger Entry"
{
    fields
    {
        field(50010; "Charge Out Posted to G/L"; Boolean)
        {
            Caption = 'Charge Out Posted to G/L';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50011; "G/L Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}

