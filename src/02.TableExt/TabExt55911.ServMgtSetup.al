tableextension 55911 "Serv. Mgt. Setup Ext" extends "Service Mgt. Setup"
{
    fields
    {
        /* field(50000; "Work Exp. Res. Group Filter"; Text[250])
        {
            Caption = 'Work Exp. Res. Group Filter';
            DataClassification = CustomerContent;
        }*/
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
        field(90017; "Def. Warranty for FRC"; Code[10])
        {
            Caption = 'Def. Warranty for FRC';
        }

        field(90018; "Def. Excl Warranty for FRC"; Code[10])
        {
            Caption = 'Def. Excl Warranty for FRC';
        }
        field(90019; "Warning Date Range 1"; DateFormula)
        {
            Caption = 'Warning Date Range 1';
        }
        field(90020; "Warning Date Range 2"; DateFormula)
        {
            Caption = 'Warning Date Range 2';
        }
        field(90027; "Enable Warranty for FRC"; Boolean)
        {
            Caption = 'Enable Warranty for FRC';
        }

        field(90028; "Enable Excl Warranty for FRC"; Boolean)
        {
            Caption = 'Enable Excl Warranty for FRC';
        }
        field(90029; "Enable Dimension Link"; Boolean)
        {
            Caption = 'Enable Dimension Link';
        }
        field(90030; "Sales Order Dim Code"; Code[20])
        {
            Caption = 'Sales Order Dim Code';
            TableRelation = Dimension.Code;
        }
        field(90031; "Enable SO Dim Code Copy"; Boolean)
        {
            Caption = 'Enable SO Dim Code Copy';
        }
        field(90032; "Service Order Dim Code"; Code[20])
        {
            Caption = 'Service Order Dim Code';
            TableRelation = Dimension.Code;
        }
        field(90033; "Service Order Type Dim Code"; Code[20])
        {
            Caption = 'Service Order Type Dim Code';
            TableRelation = Dimension.Code;
        }
        field(90034; "Cost Center Dim Code"; Code[20])
        {
            Caption = 'Cost Center Dim Code';
            TableRelation = Dimension.Code;
        }
        field(90041; "Proserv Dim Code"; Code[20])
        {
            Caption = 'Proserv Dim Code';
            TableRelation = Dimension.Code;
        }
        field(90042; "Employee Dim Code"; Code[20])
        {
            Caption = 'Employee Dim Code';
            TableRelation = Dimension.Code;
        }
    }
}

