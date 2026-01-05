tableextension 50015 "GLAccount Ext" extends "G/L Account"
{
    fields
    {
        field(50000; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50001; "Block Drill Down"; Boolean)
        {
            Caption = 'Block Drill Down';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50002; "Access Level"; Option)
        {
            Caption = 'Access Level';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            OptionCaption = 'Common,Protected,Special';
            OptionMembers = Common,Protected,Special;
        }
    }
}

