tableextension 55714 "Resp. Center Ext" extends "Responsibility Center"
{
    fields
    {
        field(50500; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = "Bank Account";
        }
        field(50510; "Phone No. 2"; Text[50])
        {
            Caption = 'Phone No. 2';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            ExtendedDatatype = PhoneNo;
        }
        field(50520; "Fax No. 2"; Text[50])
        {
            Caption = 'Fax No. 2';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}

