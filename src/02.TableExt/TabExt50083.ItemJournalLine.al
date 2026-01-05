tableextension 50083 "Item Jnl. Line Ext" extends "Item Journal Line"
{
    fields
    {
        field(70000; "Aging Year"; Code[4])
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(70010; "Aging Line"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(70020; "Old NAV No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(70030; "Old NAV No. 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(70040; "Positive Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'UPG';
            Editable = false;

        }
        field(70080; "Diff. Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'UPG';
            Editable = false;
        }
    }
}

