pageextension 50039 "General Journal Ext" extends "General Journal"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("Source Ledger Entry Type"; Rec."Source Ledger Entry Type") { ApplicationArea = All; }
            field("Source Ledger Entry No."; Rec."Source Ledger Entry No.") { ApplicationArea = All; }
        }
    }
}