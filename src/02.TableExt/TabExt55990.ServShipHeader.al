tableextension 55990 "Serv Ship Header Ext" extends "Service Shipment Header"
{
    fields
    {
        field(90000; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}

