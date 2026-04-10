pageextension 50452 ItemListExt extends "Item List"
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
        }
    }
}
