pageextension 50020 "Company Information Ext" extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field(Stamp; Rec.Stamp) { ApplicationArea = All; }
        }
    }
}