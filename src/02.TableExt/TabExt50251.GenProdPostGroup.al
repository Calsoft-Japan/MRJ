tableextension 50251 "GenProdPostGroup Ext" extends "Gen. Product Posting Group"
{
    fields
    {
        field(50000; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension.Code where(Blocked = const(false));
        }
        field(50001; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code"),
                                                        Blocked = const(false));
        }
    }
}

