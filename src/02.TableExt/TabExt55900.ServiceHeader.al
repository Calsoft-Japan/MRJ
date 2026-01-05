tableextension 55900 "Service Header Ext" extends "Service Header"
{
    fields
    {
        field(70000; "Parts From Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = Location.Code;
        }
        field(70010; "Parts From Bin Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90000; "Bin Code"; Code[20])
        {
            Caption = 'Def. Bin Code';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90001; "Parts Receive TO No. Filter"; Text[250])
        {
            Caption = 'Parts Receive TO No. Filter';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90002; "Parts Return TO No. Filter"; Text[250])
        {
            Caption = 'Parts Return TO No. Filter';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90030; "Sales Order Dim Code"; Code[20])
        {
            Caption = 'Sales Order Dimension Code';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = Dimension;
        }
        field(90032; "Service Order Dim Code"; Code[20])
        {
            Caption = 'Service Order Dimension Code';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = Dimension;
        }
        field(90033; "Service Order Type Dim Code"; Code[20])
        {
            Caption = 'Service Order Type Dim Code';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = Dimension;
        }
        field(90034; "Cost Center Dim Code"; Code[20])
        {
            Caption = 'Cost Center Dim Code';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = Dimension;
        }
        field(90041; "Proserv Dim Code"; Code[20])
        {
            Caption = 'Proserv Dim Code';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = Dimension;
        }
    }
}

