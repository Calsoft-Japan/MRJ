tableextension 55917 "Fault Reason Code Ext" extends "Fault Reason Code"
{
    fields
    {
        field(90000; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = "Gen. Product Posting Group";
        }
        field(90001; Warranty; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90002; COSC; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
            Enabled = false;
        }
        field(90003; GoodWill; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
            Enabled = false;
        }
    }
}

