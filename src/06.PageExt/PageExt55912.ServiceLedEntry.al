pageextension 55912 "Service Led. Entry Ext" extends "Service Ledger Entries"
{
    layout
    {
        addbefore("Posting Date")
        {
            field("Charge Out Posted to G/L"; Rec."Charge Out Posted to G/L") { ApplicationArea = All; }
            field("G/L Entry No."; Rec."G/L Entry No.") { ApplicationArea = All; }
        }
    }
}