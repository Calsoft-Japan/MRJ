pageextension 50392 "Phys. Inventory Journal Ext" extends "Phys. Inventory Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("Item No.2"; Rec."Item No.2")
            {
                ApplicationArea = All;
                Caption = '品目番号 2';
            }
            field("Description2"; Rec."Description2")
            {
                ApplicationArea = All;
                Caption = '説明 2';
            }
            field("New Shelf No."; Rec."New Shelf No.")
            {
                ApplicationArea = All;
                Caption = '新棚番';

                ToolTip = 'Shows the new shelf number from Item master.';
                Editable = false;
            }
            field("Shelf No. (Osaka)"; Rec."Shelf No. (Osaka)")
            {
                ApplicationArea = All;
                Caption = '棚番（大阪)';
            }
            field("Shelf No. (Niigata)"; Rec."Shelf No. (Niigata)")
            {
                ApplicationArea = All;
                Caption = ' 棚番（新潟)';
            }
            field("Shelf No. (Sendai)"; Rec."Shelf No. (Sendai)")
            {
                ApplicationArea = All;
                Caption = '棚番（仙台)';
            }
            field("Shelf No. (Fukuoka)"; Rec."Shelf No. (Fukuoka)")
            {
                ApplicationArea = All;
                Caption = 'カテゴリー';
            }
            field("Shelf No. (Nagoya)"; Rec."Shelf No. (Nagoya)")
            {
                ApplicationArea = All;
                Caption = '棚番（名古屋)';
            }
        }
    }
}