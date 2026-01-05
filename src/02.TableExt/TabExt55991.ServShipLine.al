tableextension 55991 "Serv. Ship. Line Ext" extends "Service Shipment Line"
{
    fields
    {
        field(50500; "Shipment Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50510; "Shipment Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            Editable = false;
        }
        field(50520; "Shipment Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50530; "Shipment Inv. Disc. Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            Editable = false;
        }
        field(90008; "Resource Group No."; Code[20])
        {
            Caption = 'Resource Group No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = "Resource Group";
        }
        field(90009; "Resource Group Name"; Text[50])
        {
            Caption = 'Resource Group Name';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90050; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            Editable = false;
        }
        field(90051; "Amount Including VAT"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            Editable = false;
        }
    }
}

