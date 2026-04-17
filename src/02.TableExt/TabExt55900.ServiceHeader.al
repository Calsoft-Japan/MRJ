tableextension 55900 "Service Header Ext" extends "Service Header"
{
    fields
    {
        field(70000; "Parts From Location Code"; Code[20])
        {
            Caption = 'Parts From Location Code';
            TableRelation = Location.Code;
        }
        field(70010; "Parts From Bin Code"; Code[20])
        {
            Caption = 'Parts From Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("Parts From Location Code"));
        }
        field(90000; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"), "Customer No." = field("Customer No."));
        }
        field(90001; "Parts Receive TO No. Filter"; Text[250])
        {
            Caption = 'Parts Receive TO No. Filter';
        }
        field(90002; "Parts Return TO No. Filter"; Text[250])
        {
            Caption = 'Parts Return TO No. Filter';
        }
        field(90030; "Sales Order Dim Code"; Code[20])
        {
            Caption = 'Sales Order Dimension Code';
            TableRelation = Dimension;
        }
        field(90032; "Service Order Dim Code"; Code[20])
        {
            Caption = 'Service Order Dimension Code';
            TableRelation = Dimension;
        }
        field(90033; "Service Order Type Dim Code"; Code[20])
        {
            Caption = 'Service Order Type Dim Code';
            TableRelation = Dimension;
        }
        field(90034; "Cost Center Dim Code"; Code[20])
        {
            Caption = 'Cost Center Dim Code';
            TableRelation = Dimension;
        }
        field(90041; "Proserv Dim Code"; Code[20])
        {
            Caption = 'Proserv Dim Code';
            TableRelation = Dimension;
        }
        field(90042; "Quote Valid to Date"; Date)
        {
            Caption = 'Quote Valid to Date';
        }
    }
}

