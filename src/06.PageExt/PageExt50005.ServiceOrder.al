pageextension 50005 "Service Order Ext" extends "Service Order"
{
    layout
    {
        modify("Location Code") //JPN Caption modify
        {
            Caption = 'Location Code';
        }
        addafter("Location Code")
        {
            field("Bin Code"; Rec."Bin Code")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Create Whse Shipment_Promoted")
        {
            actionref(CreatePartTransfer_Promoted; CreatePartTransfer) { }
        }
        addafter("Create Whse Shipment")
        {
            action(CreatePartTransfer)
            {
                ApplicationArea = All;
                Caption = 'Create Parts Transfer';
                Image = CreateDocument;
                trigger OnAction()
                var
                    ServHeader: Record "Service Header";
                    PgServPartsTransfer: Page "Service Parts Transfer";
                begin
                    Clear(ServHeader);
                    ServHeader.Get(Rec."Document Type", Rec."No.");
                    Clear(PgServPartsTransfer);
                    PgServPartsTransfer.SetDefaultFilter(ServHeader."Location Code", ServHeader."Bin Code", Rec."No.");
                    PgServPartsTransfer.SetDefaultFilter2(ServHeader."Parts From Location Code", ServHeader."Parts From Bin Code");
                    PgServPartsTransfer.Run;
                end;
            }
        }
    }
}