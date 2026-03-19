pageextension 50021 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(NameTitle; Rec.NameTitle) { ApplicationArea = All; }
        }
        addafter(ContactName)
        {
            field(ContactTitle; Rec.ContactTitle) { ApplicationArea = All; }
        }
    }
}