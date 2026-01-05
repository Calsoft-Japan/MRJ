tableextension 55901 "Serv. Item Line Ext" extends "Service Item Line"
{
    fields
    {
        field(50050; "Product Series"; Code[20])
        {
            Caption = 'Product Series';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90001; "Transfer Order No."; Code[10])
        {
            Caption = 'Transfer Order No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90002; "Transfer Order Line No."; Integer)
        {
            Caption = 'Transfer Order Line No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90003; "Fault Area Comment"; Boolean)
        {
            Caption = 'Fault Area Comment';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            Editable = false;
        }
        field(90004; "Symptom Comment"; Boolean)
        {
            Caption = 'Symptom Comment';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            Editable = false;
        }
        field(90010; "Item Description"; Text[50])
        {
            Caption = 'Item Description';
            Description = 'UPG';
            Editable = false;
        }
        field(90011; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
            Description = 'UPG';
            Editable = false;
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
    }
}

