tableextension 55964 "Serv. Contract Line Ext" extends "Service Contract Line"
{
    fields
    {
        field(90000; "Contract Line Value"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Contract Line Value';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}

