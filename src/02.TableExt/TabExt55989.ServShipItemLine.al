tableextension 55989 "Serv. Ship Item Line Ext" extends "Service Shipment Item Line"
{
    fields
    {
        field(50050; "Product Series"; Code[20])
        {
            Caption = 'Product Series';
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
        field(90005; "Repair Status Code"; Code[10])
        {
            Caption = 'Repair Status Code';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = "Repair Status";
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
        field(90012; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Description = 'UPG';
        }
    }
}