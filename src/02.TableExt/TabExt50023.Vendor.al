tableextension 50023 "Vendor Ext" extends Vendor
{
    fields
    {
        field(50001; "NameTitle"; Text[50])
        {
            Caption = 'NameTitle';
        }
        field(50002; "ContactTitle"; Text[50])
        {
            Caption = 'ContactTitle';
        }
    }
}