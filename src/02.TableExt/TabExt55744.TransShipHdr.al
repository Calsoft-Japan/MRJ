tableextension 55744 "Trans Ship Hdr. Ext" extends "Transfer Shipment Header"
{
    fields
    {
        field(90000; "For Loan Shipment"; Boolean)
        {
            Caption = 'For Loan Shipment';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90001; "Auto Post Receipt"; Boolean)
        {
            Caption = 'Auto Post Receipt';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90002; "Default Bin Code (From)"; Code[20])
        {
            Caption = 'Default Bin Code (From)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90003; "Default Bin Code (To)"; Code[20])
        {
            Caption = 'Default Bin Code (To)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90004; "For Sales Shipment"; Boolean)
        {
            Caption = 'Sales Shipment';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90005; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90006; "Parts Trans. Archived Ver. No."; Integer)
        {
            Caption = 'Parts Trans. Archived Ver. No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}

