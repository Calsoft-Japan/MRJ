tableextension 55965 "Serv. Contract Hdr. Ext" extends "Service Contract Header"
{
    fields
    {
        field(90000; "Contract Period"; Option)
        {
            Caption = 'Contract Period';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            OptionCaption = 'Month,Two Months,Quarter,Half Year,Year,None,Free';
            OptionMembers = Month,"Two Months",Quarter,"Half Year",Year,"None",Free;
        }
        field(90001; "Contract Free Period"; Integer)
        {
            Caption = 'Contract Free Period(No. of Mon)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90002; "Invoice Free Period"; Integer)
        {
            Caption = 'Invoice Free Period(No. of Mon)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90003; "Contract Amount"; Decimal)
        {
            Caption = 'Contract Amount';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90004; "Invoice First"; Boolean)
        {
            Caption = 'Invoice First';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}

