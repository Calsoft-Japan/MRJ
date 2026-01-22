table 50132 "Parts Transfer Buffer"
{
    Caption = 'Parts Transfer Buffer';

    fields
    {
        field(1; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(3; "Qty. to Use"; Decimal)
        {
            Caption = 'Qty. Consume';
        }
        field(4; "Qty. Received"; Decimal)
        {
            Caption = 'Qty. Received';
        }
        field(5; "Availability"; Decimal)
        {
            Caption = 'Availability';
        }
        field(6; "Receive TO No. Filter"; Text[250])
        {
            Caption = 'Receive TO No. Filter';
        }
        field(7; "Return TO No. Filter"; Text[250])
        {
            Caption = 'Return TO No. Filter';
        }
        field(8; "Qty. to Receive"; Decimal)
        {
            Caption = 'Qty. to Receive';
        }
        field(9; "Qty. to Return"; Decimal)
        {
            Caption = 'Qty. to Return';
        }
        field(10; "From Location Code"; Code[10])
        {
            Caption = 'From Location Code';
        }
        field(11; "From Bin Code"; Code[20])
        {
            Caption = 'From Bin Code';
        }
        field(12; "To Location Code"; Code[10])
        {
            Caption = 'To Location Code';
        }
        field(13; "To Bin Code"; Code[20])
        {
            Caption = 'To Bin Code';
        }
        field(14; "Receive Transfer"; Code[20])
        {
            Caption = 'Receive Transfer';
        }
        field(15; "Return Transfer"; Code[20])
        {
            Caption = 'Return Transfer';
        }
        field(16; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description where("No." = field("Item No.")));
        }
        field(21; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Description 2" where("No." = field("Item No.")));
        }
    }
    keys
    {
        key(PK; "Order No.", "Item No.") { Clustered = true; }
    }
}