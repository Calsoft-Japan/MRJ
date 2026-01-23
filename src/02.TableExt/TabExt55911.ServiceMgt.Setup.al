tableextension 55911 "Service Mgt. Setup Ext" extends "Service Mgt. Setup"
{
    fields
    {
        field(50100; "Resource Group Filter"; Text[250])
        {
            Caption = 'Resource Group Filter';
            DataClassification = CustomerContent;
        }
        field(50101; "Resource Group for Sort"; Code[20])
        {
            Caption = 'Resource Group for Sort';
            DataClassification = CustomerContent;
            TableRelation = "Resource Group";
        }
    }
}

