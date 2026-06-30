pageextension 55919 "Service Mgt. Setup Ext" extends "Service Mgt. Setup"
{
    layout
    {
        addlast(General)
        {
            //field("Work Exp. Res. Group Filter"; Rec."Work Exp. Res. Group Filter") { ApplicationArea = All; }
            field("Resource Group Filter"; Rec."Resource Group Filter") { ApplicationArea = All; }
            field("Resource Group for Sort"; Rec."Resource Group for Sort") { ApplicationArea = All; }
            field("G/L Account for Repair"; Rec."G/L Account for Repair") { ApplicationArea = All; }
            field("Serv Ord Reservation Location"; Rec."Serv Ord Reservation Location") { ApplicationArea = All; }
            group(Dimensions)
            {
                Caption = 'Dimensions';
                field("Enable Dimension Link"; Rec."Enable Dimension Link") { ApplicationArea = All; }
                field("Sales Order Dim Code"; Rec."Sales Order Dim Code") { ApplicationArea = All; }
                field("Enable SO Dim Code Copy"; Rec."Enable SO Dim Code Copy") { ApplicationArea = All; }
                field("Service Order Dim Code"; Rec."Service Order Dim Code") { ApplicationArea = All; }
                field("Service Order Type Dim Code"; Rec."Service Order Type Dim Code") { ApplicationArea = All; }
                field("Employee Dim Code"; Rec."Employee Dim Code") { ApplicationArea = All; }
                field("Cost Center Dim Code"; Rec."Cost Center Dim Code") { ApplicationArea = All; }
                field("Proserv Dim Code"; Rec."Proserv Dim Code") { ApplicationArea = All; }
                field("Enable Warranty for FRC"; Rec."Enable Warranty for FRC") { ApplicationArea = All; }
                field("Enable Excl Warranty for FRC"; Rec."Enable Excl Warranty for FRC") { ApplicationArea = All; }
                field("Def. Warranty for FRC"; Rec."Def. Warranty for FRC") { ApplicationArea = All; }
                field("Def. Excl Warranty for FRC"; Rec."Def. Excl Warranty for FRC") { ApplicationArea = All; }
            }
        }
    }
}