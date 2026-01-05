tableextension 57354 "Bin Ext" extends Bin
{
    fields
    {
        field(90000; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = Customer;
        }
    }
}

