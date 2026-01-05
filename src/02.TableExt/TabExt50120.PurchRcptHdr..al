tableextension 50120 "PurchRcpt Hdr. Ext" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50030; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50031; "Service Item Line No."; Integer)
        {
            Caption = 'Service Item Line No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}

