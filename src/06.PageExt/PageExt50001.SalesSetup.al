pageextension 50001 "SalesSetup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(Dimensions)
        {
            group(MRJCustomization)
            {
                Caption = 'MRJ Customization';
                field("Enable Cust. Dimension Link"; Rec."Enable Cust. Dimension Link")
                {
                    ApplicationArea = All;
                }
                field("Customer Dimension"; Rec."Customer Dimension")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}