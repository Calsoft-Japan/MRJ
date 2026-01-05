tableextension 56504 "Serial No. Info Ext" extends "Serial No. Information"
{
    fields
    {
        field(90000; "FA No."; Code[20])
        {
            Caption = 'FA No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            Editable = false;
            TableRelation = "Fixed Asset";
        }
    }
}

