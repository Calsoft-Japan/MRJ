tableextension 50038 "Purch. Headder Ext" extends "Purchase Header"
{
    fields
    {
        field(50030; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50031; "Service Item Line No."; Integer)
        {
            Caption = 'Service Item Line No.';
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

