pageextension 50005 "Service Order Ext" extends "Service Order"
{
    layout
    {
        addbefore("Location Code")
        {
            field("Parts From Location Code"; Rec."Parts From Location Code")
            {
                ApplicationArea = All;
            }
            field("Parts From Bin Code"; Rec."Parts From Bin Code")
            {
                ApplicationArea = All;
            }
        }
        modify("Location Code") //JPN Caption modify
        {
            Caption = 'Parts to Location Code';
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
        addafter(AttachAsPDF_Promoted)
        {
            actionref(PartsRequest_Promoted; PartsRequest) { }
        }
        addafter(AttachAsPDF)
        {
            action(PartsRequest)
            {
                ApplicationArea = All;
                Caption = 'Parts Request';
                Image = Report;
                trigger OnAction()
                var
                    ServHeader: Record "Service Header";
                begin
                    Clear(ServHeader);
                    ServHeader.Get(Rec."Document Type", Rec."No.");
                    ServHeader.SetRange(ServHeader."No.", Rec."No.");
                    Report.RunModal(Report::"Parts Request Form", true, true, ServHeader);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}