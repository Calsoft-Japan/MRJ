tableextension 50083 "Item Jnl. Line Ext" extends "Item Journal Line"
{
    fields
    {
        //  Start- FDD067
        field(50000; "Item No.2"; Code[20])
        {
            Description = 'UPG';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item"."No." where("No." = field("Item No.")));
        }
        field(50001; "Description2"; Text[100])
        {
            Description = 'UPG';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item"."Description" where("No." = field("Item No.")));
        }
        field(50002; "New Shelf No."; Code[10])
        {
            Description = 'UPG';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."New Shelf No." where("No." = field("Item No.")));
        }
        field(50003; "Shelf No. (Osaka)"; Code[10])
        {
            Description = 'UPG';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item"."Shelf No. (Osaka)" where("No." = field("Item No.")));
        }
        field(50004; "Shelf No. (Niigata)"; Code[10])
        {
            Description = 'UPG';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item"."Shelf No. (Niigata)" where("No." = field("Item No.")));
        }
        field(50005; "Shelf No. (Sendai)"; Code[10])
        {
            Description = 'UPG';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item"."Shelf No. (Sendai)" where("No." = field("Item No.")));
        }
        field(50006; "Shelf No. (Fukuoka)"; Code[10])
        {
            Description = 'UPG';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item"."Shelf No. (Fukuoka)" where("No." = field("Item No.")));
        }
        field(50007; "Shelf No. (Nagoya)"; Code[10])
        {
            Description = 'UPG';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item"."Shelf No. (Nagoya)" where("No." = field("Item No.")));
        }
        //  End- FDD067
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

