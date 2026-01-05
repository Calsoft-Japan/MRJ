tableextension 55995 "Serv. CrMemo Line Ext" extends "Service Cr.Memo Line"
{
    fields
    {
        field(90007; "Resource Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Resource Cost';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90008; "Resource Group No."; Code[20])
        {
            Caption = 'Resource Group No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = "Resource Group";
        }
        field(90009; "Resource Group Name"; Text[50])
        {
            Caption = 'Resource Group Name';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}

