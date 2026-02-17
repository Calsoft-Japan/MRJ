page 50100 "Pstd. Transfer Ship Lines"
{
    ApplicationArea = All;
    Caption = 'Posted Transfer Shipment Lines';
    LinksAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Transfer Shipment Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transfer-from Bin Code"; Rec."Transfer-from Bin Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Auto Service Order No."; Rec."Auto Service Order No.")
                {
                    ApplicationArea = All;
                }
                field("Manual Service Order No."; Rec."Manual Service Order No.")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}