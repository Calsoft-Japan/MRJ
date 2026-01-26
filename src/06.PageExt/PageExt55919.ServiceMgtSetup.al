pageextension 55919 "Service Mgt. Setup Ext" extends "Service Mgt. Setup"
{
    layout
    {
        addlast(General)
        {
            field("Resource Group Filter"; Rec."Resource Group Filter")
            {
                ApplicationArea = All;
            }
            field("Resource Group for Sort"; Rec."Resource Group for Sort")
            {
                ApplicationArea = All;
            }
        }
    }
}