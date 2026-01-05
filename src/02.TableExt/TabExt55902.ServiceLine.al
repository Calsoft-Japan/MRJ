tableextension 55902 "Service Line Ext" extends "Service Line"
{
    fields
    {
        field(90000; "Parts Position Code"; Code[10])
        {
            Caption = 'Parts Position Code';
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
        field(90003; "Req.Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Description = 'UPG';
            Editable = false;
        }
        field(90004; TORequest; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
            Editable = false;
        }
        field(90005; "Original Qty"; Decimal)
        {
            Caption = 'Original Qty';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Description = 'UPG';
            Editable = false;
        }
        field(90006; "Remaining Qty"; Decimal)
        {
            Caption = 'Remaining Qty';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
            Description = 'UPG';
            Editable = false;
        }
        field(90007; "Resource Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Resource Cost';
            DataClassification = ToBeClassified;
            Description = 'UPG';
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
    }
}

