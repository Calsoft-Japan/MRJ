
tableextension 50000 "PurchSetup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Enable Vend. Dimension Link"; Boolean)
        {
            Caption = 'Enable Vendor Dimension Link';
        }
        field(50001; "Vendor Dimension"; Code[20])
        {
            Caption = 'Vendor Dimension';
            TableRelation = Dimension;
        }
    }
}