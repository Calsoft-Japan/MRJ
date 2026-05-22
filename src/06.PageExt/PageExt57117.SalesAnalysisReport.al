pageextension 57117 "SalesAnalysisReport Ext" extends "Sales Analysis Report"
{
    layout
    {
        addlast("Filters")
        {
            field("Date Filter"; Rec."Date Filter")
            {
                ApplicationArea = All;
            }

        }
    }
}