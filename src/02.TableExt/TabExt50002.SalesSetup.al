tableextension 50001 "SalesSetup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Enable Cust. Dimension Link"; Boolean)
        {
            Caption = 'Enable Customer Dimension Link';
            ToolTip = 'TBD';
        }
        field(50001; "Customer Dimension"; Code[20])
        {
            Caption = 'Customer Dimension';
            ToolTip = 'TBD';
            TableRelation = Dimension;
        }
    }
}