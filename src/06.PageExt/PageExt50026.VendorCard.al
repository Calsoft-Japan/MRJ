pageextension 50025 "Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        addafter(Name)
        {
            field(NameTitle; Rec.NameTitle) { ApplicationArea = All; }
        }
        addafter(Contact)
        {
            field(ContactTitle; Rec.ContactTitle) { ApplicationArea = All; }
        }
    }
}