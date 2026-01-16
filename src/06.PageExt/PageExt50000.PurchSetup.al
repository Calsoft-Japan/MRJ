pageextension 50000 "PurchSetup Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Default Accounts")
        {
            group(MRJCustomization)
            {
                Caption = 'MRJ Customization';
                field("Enable Vend. Dimension Link"; Rec."Enable Vend. Dimension Link")
                {
                    ApplicationArea = All;
                }
                field("Vendor Dimension"; Rec."Vendor Dimension")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}