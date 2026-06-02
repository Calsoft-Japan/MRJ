pageextension 50451 ItemCardExt extends "Item Card"
{

    layout
    {
        addafter("Shelf No.")
        {
            field("Shelf No. Osaka"; Rec."Shelf No. (Osaka)") { ApplicationArea = All; }
            field("Shelf No. Niigata"; Rec."Shelf No. (Niigata)") { ApplicationArea = All; }
            field("Shelf No. Sendai"; Rec."Shelf No. (Sendai)") { ApplicationArea = All; }
            field("Shelf No. Fukuoka"; Rec."Shelf No. (Fukuoka)") { ApplicationArea = All; }
            field("Shelf No. Nagoya"; Rec."Shelf No. (Nagoya)") { ApplicationArea = All; }
            field("New Shelf No."; Rec."New Shelf No.") { ApplicationArea = All; }
            field("Overseas_Domestic"; Rec."Overseas/Domestic") { ApplicationArea = All; }
        }
        addafter("No.")
        {
            field("No. 2 "; Rec."No. 2") { ApplicationArea = All; }
        }
        modify(Inventory)
        {
            Visible = false;
        }
        addafter("Search Description")
        {
            field(InventoryMRJ; Rec.Inventory)
            {
                ApplicationArea = All;
                Caption = 'Inventory';
                ToolTip = 'If you are using the “Storage Location” filter, this does not represent the total stock across all warehouses.';
            }
        }
        addafter(InventoryMRJ)
        {
            field("Inventory 01TOKYO"; Rec."Inventory 01TOKYO")
            {
                ApplicationArea = All;
                Caption = 'Inventory (01TOKYO)';
            }
        }
    }
}
