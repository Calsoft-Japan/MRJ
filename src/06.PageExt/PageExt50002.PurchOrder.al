pageextension 50002 "Purch. Order Ext" extends "Purchase Order"
{
    layout
    {
        addafter("Buy-from Contact No.")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Archive Document_Promoted")
        {
            actionref(ClosePurchOrder_Promoted; ClosePurchOrder) { }
        }
        addafter("Archive Document")
        {
            action(ClosePurchOrder)
            {
                ApplicationArea = All;
                Caption = 'Close Order';
                Image = Close;

                trigger OnAction()
                var
                    ConfirmText: Label 'Do you want to close order "%1" ?';
                begin
                    if Confirm(ConfirmText, true, Rec."No.") then
                        CloseOrder();
                end;
            }
        }
    }
    local procedure CloseOrder()
    var
        PurchHeader2: Record "Purchase Header";
        PurchLine2: Record "Purchase Line";
        Text50001: Label 'You can not close Purchase Order "%1"  because there is a line that be linked Sales Order (%2).';
        Text50002: Label 'Drop Shipment';
        Text50003: Label 'Special Order';
        Text50004: Label 'You can not close Purchase Order "%1"  because there is a line set Prepayment.';
        Text50005: Label 'You can not close Purchase Order "%1"  because Status is Pending Approval.';
    begin
        Rec.TestField("Document Type", Rec."Document Type"::Order);

        PurchLine2.SetRange("Document Type", Rec."Document Type");
        PurchLine2.SetRange("Document No.", Rec."No.");
        PurchLine2.SetFilter("Sales Order No.", '<>''''');
        if not PurchLine2.IsEmpty then
            Error(Text50001, Rec."No.", Text50002);

        Clear(PurchLine2);
        PurchLine2.SetRange("Document Type", Rec."Document Type");
        PurchLine2.SetRange("Document No.", Rec."No.");
        PurchLine2.SetFilter("Special Order Sales No.", '<>''''');
        if not PurchLine2.IsEmpty then
            Error(Text50001, Rec."No.", Text50003);

        Clear(PurchLine2);
        PurchLine2.SetRange("Document Type", Rec."Document Type");
        PurchLine2.SetRange("Document No.", Rec."No.");
        PurchLine2.SetFilter("Prepayment %", '<>0');
        if not PurchLine2.IsEmpty then
            Error(Text50004, Rec."No.");

        IF Rec.Status = Rec.Status::"Pending Approval" then
            Error(Text50005, Rec."No.");

        Rec.TestField("Reason Code");
        CurrPage.PurchLines.Page.CloseOrder(Rec);
        PurchHeader2.TransferFields(Rec);
        PurchHeader2."Document Type" := Rec."Document Type"::"Closed Order";
        PurchHeader2.Insert();
        CopyFromPurchDocDimToHeader(PurchHeader2, Rec);

        Rec.Delete(true);
    end;

    local procedure CopyFromPurchDocDimToHeader(var ToPurchHeader: Record "Purchase Header"; var FromPurchHeader: Record "Purchase Header")
    begin
        ToPurchHeader.Validate("Shortcut Dimension 1 Code", FromPurchHeader."Shortcut Dimension 1 Code");
        ToPurchHeader.Validate("Shortcut Dimension 2 Code", FromPurchHeader."Shortcut Dimension 2 Code");

        ToPurchHeader.Validate("Dimension Set ID", FromPurchHeader."Dimension Set ID");
        ToPurchHeader.Modify(true);
    end;
}