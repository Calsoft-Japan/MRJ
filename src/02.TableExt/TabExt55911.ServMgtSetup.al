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
        field(50053; "Serv Ord Reservation Location"; Code[10])
        {
            Caption = 'Serv Ord Reservation Location';
            TableRelation = Location;
        }
        field(90019; "Warning Date Range 1"; DateFormula)
        {
            Caption = 'Warning Date Range 1';
        }
        field(90020; "Warning Date Range 2"; DateFormula)
        {
            Caption = 'Warning Date Range 2';
        }
    }
}

