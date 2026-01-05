tableextension 55940 "Service Item Ext" extends "Service Item"
{
    fields
    {
        field(50050; "Product Series"; Code[20])
        {
            Caption = 'Product Series';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50051; "Warranty Starting Date (Maker)"; Date)
        {
            Caption = 'Warranty Starting Date (Maker)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50052; "Warranty Ending Date (Maker)"; Date)
        {
            Caption = 'Warranty Ending Date (Maker)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50053; "Production Counter (Page)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Production Counter (Page)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'UPG';
        }
        field(50054; "Production Counter (Hours)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Production Counter (Hours)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'UPG';
        }
        field(90000; "Service Item Type"; Option)
        {
            Caption = 'Service Item Type';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            OptionCaption = 'Sales,Loan';
            OptionMembers = Sales,Loan;
        }
        field(90001; "Repair Status"; Code[20])
        {
            Caption = 'Repair Status';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90002; "Phone No. (Service)"; Text[30])
        {
            Caption = 'Phone No. (Service)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90003; "Inspection In-Charge (Dept.)"; Text[30])
        {
            Caption = 'Inspection In-Charge (Dept.)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90004; "Inspection In-Charge (Person)"; Text[30])
        {
            Caption = 'Inspection In-Charge (Person)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90005; "Repair Status Name"; Text[80])
        {
            Caption = 'Repair Status Name';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            Editable = false;
        }
        field(90006; "Repair Is Finished"; Boolean)
        {
            Caption = 'Repair Is Finished';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90007; "Repair Location Code"; Code[10])
        {
            Caption = 'Location Code (Repair)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = Location;
            ValidateTableRelation = false;
        }
        field(90008; "Repair Bin Code"; Code[20])
        {
            Caption = 'Bin Code (Repair)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(90009; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90010; "Repair Ledger Entry No."; Integer)
        {
            Caption = 'Repair Ledger Entry No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90011; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
            Description = 'UPG';
            Editable = false;
        }
    }
}

