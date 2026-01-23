pageextension 50003 "Purch Lines Ext" extends "Purchase Order Subform"
{
    procedure CloseOrder(PurchHeader: Record "Purchase Header");
    VAR
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        ItemTracking: Record "Reservation Entry";
        ItemTracking2: Record "Reservation Entry" temporary;
        ItemCharge: Record "Item Charge Assignment (Purch)";
        ItemCharge2: Record "Item Charge Assignment (Purch)" temporary;
    BEGIN
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindSet() then
            repeat
                PurchLine2.TransferFields(PurchLine);
                PurchLine2."Document Type" := PurchLine."Document Type"::"Closed Order";
                PurchLine2.Insert();
                CopyFromPurchDocDimToLine(PurchLine2, PurchLine);
                PurchLine.SuspendStatusCheck(true);

                //for Posted Receipt & Not Post Invoice
                PurchLine."Qty. Rcd. Not Invoiced" := 0;
                PurchLine.Modify(true);

                //for Exist Item Tracking Line
                ItemTracking.Reset();
                ItemTracking.SetRange("Source Type", Database::"Purchase Line");
                ItemTracking.SetRange("Source Subtype", PurchLine."Document Type");
                ItemTracking.SetRange("Source ID", PurchLine."Document No.");
                ItemTracking.SetRange("Source Ref. No.", PurchLine."Line No.");
                if ItemTracking.FindSet() then
                    repeat
                        ItemTracking2.TransferFields(ItemTracking);
                        ItemTracking2.Insert();
                        ItemTracking.Delete(true);
                    until ItemTracking.Next() = 0;

                //for Item Charge
                ItemCharge.Reset();
                ItemCharge.SetRange("Document Type", PurchLine."Document Type");
                ItemCharge.SetRange("Document No.", PurchLine."Document No.");
                ItemCharge.SetRange("Document Line No.", PurchLine."Line No.");
                if ItemCharge.FindSet() then
                    repeat
                        ItemCharge2.TransferFields(ItemCharge);
                        ItemCharge2.Insert();
                        ItemCharge.Delete(true);
                    until ItemCharge.Next() = 0;

                PurchLine.Delete(true);

                //for Exist Item Tracking Line
                if ItemTracking2.FindSet() then
                    repeat
                        ItemTracking.TransferFields(ItemTracking2);
                        ItemTracking.Insert();
                        ItemTracking2.Delete(true);
                    until ItemTracking2.Next() = 0;

                //for Item Charge
                if ItemCharge2.FindSet() then
                    repeat
                        ItemCharge.TransferFields(ItemCharge2);
                        ItemCharge.Insert();
                        ItemCharge2.Delete(true);
                    until ItemCharge2.Next() = 0;
                PurchLine.SuspendStatusCheck(FALSE);
            until PurchLine.Next() = 0;
        CurrPage.Update();
    END;

    local procedure CopyFromPurchDocDimToLine(var ToPurchLine: Record "Purchase Line"; var FromPurchLine: Record "Purchase Line")
    begin
        ToPurchLine.Validate("Shortcut Dimension 1 Code", FromPurchLine."Shortcut Dimension 1 Code");
        ToPurchLine.Validate("Shortcut Dimension 2 Code", FromPurchLine."Shortcut Dimension 2 Code");

        ToPurchLine.Validate("Dimension Set ID", FromPurchLine."Dimension Set ID");
        ToPurchLine.Modify(true);
    end;
}