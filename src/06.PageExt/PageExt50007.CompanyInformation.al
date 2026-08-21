pageextension 50007 "Item Ledger Entries Ext" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Item No.")
        {
            field("Item Inv. Posting Group"; ItemInvPostingGroup)
            {
                ApplicationArea = All;
                Caption = 'Item Inventory Posting Group';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        Clear(ItemInvPostingGroup);
        if Item.Get(Rec."Item No.") then
            ItemInvPostingGroup := Item."Inventory Posting Group";
    end;

    var
        ItemInvPostingGroup: Code[20];
}