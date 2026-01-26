tableextension 55911 "Serv. Mgt. Setup Ext" extends "Service Mgt. Setup"
{
    fields
    {
        field(50100; "Resource Group Filter"; Text[250])
        {
            Caption = '作業費リソースグループフィルター';
            DataClassification = CustomerContent;
        }
        field(50101; "Resource Group for Sort"; Code[20])
        {
            Caption = 'ソード優先リソースグループ';
            DataClassification = CustomerContent;
            TableRelation = "Resource Group";
        }
        field(90016; "G/L Account for Repair"; Code[20])
        {
            Caption = 'G/L Account for Repair';
            TableRelation = "G/L Account";
        }
    }
}

