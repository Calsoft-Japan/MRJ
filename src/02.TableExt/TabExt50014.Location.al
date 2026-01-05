tableextension 50014 "Location Ext" extends Location
{
    fields
    {
        field(50001; "Inventory Not Empty"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90000; "For Loan Shipment"; Boolean)
        {
            Caption = 'For Loan Shipment';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90001; "Auto Post Receipt"; Boolean)
        {
            Caption = 'Auto Post ';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90002; "Is FA Location"; Boolean)
        {
            Caption = 'Is FA Location';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90003; "For Sales Shipment"; Boolean)
        {
            Caption = 'For Sales Shipment';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}

