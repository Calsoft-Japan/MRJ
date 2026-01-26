pageextension 50006 "Serv Item WorkSheet Ext" extends "Service Item Worksheet Subform"
{
    actions
    {
        addafter("&Catalog Items")
        {
            group(PurchOrder)
            {
                Caption = 'Purchase Order';
                action(Show)
                {
                    ApplicationArea = All;
                    Caption = 'Show';
                    Image = ShowList;
                    RunObject = page "Purchase List";
                    RunPageView = where("Document Type" = const(Order));
                    RunPageLink = "Service Order No." = field("Document No."), "Service Item Line No." = field("Line No.");
                }
                action(CreateParts)
                {
                    ApplicationArea = All;
                    Caption = 'Create (Parts)';
                    Image = CreateDocument;
                    trigger OnAction()
                    var
                        Text007: Label 'Do you want to create Purchase Order?';
                        Text020: Label 'The function is effective on the Service Order only.';
                    begin
                        if Rec."Document Type" <> Rec."Document Type"::Order then
                            Error(Text020);

                        if Dialog.Confirm(Text007, true) then
                            CreatePurchOrder(false);
                    end;
                }
            }
        }
    }
    local procedure CreatePurchOrder(IsOutsource: Boolean)
    var
        ServMgtSetup: Record "Service Mgt. Setup";
        Vendor: Record Vendor;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        ServLine: Record "Service Line";
        VendorNo: Code[20];
        Text009: Label 'Process is cancelled because Vendor No.  is empty.';
        Text011: Label 'Purchase Order ''%1'' was created, do you want to open?';
    begin
        Clear(Vendor);
        VendorNo := '';
        if Page.RunModal(Page::"Vendor List", Vendor) = Action::LookupOK then
            VendorNo := Vendor."No.";
        if not Vendor.Get(VendorNo) then
            Error(Text009);

        Clear(PurchHeader);
        PurchHeader.Validate("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.Insert(true);
        PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
        PurchHeader."Service Order No." := Rec."Document No.";
        PurchHeader."Service Item Line No." := Rec."Line No.";
        PurchHeader."Responsibility Center" := Rec."Responsibility Center";
        PurchHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
        PurchHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        PurchHeader."Dimension Set ID" := Rec."Dimension Set ID";
        PurchHeader.Modify(true);

        //if Rec."Document Type" = Rec."Document Type"::Order then
        //DimLinkMgt.CpySVIDocDim2POPI(PurchHeader);

        if IsOutsource then begin
            ServMgtSetup.Get();
            Clear(PurchLine);
            PurchLine.Validate("Document Type", PurchLine."Document Type"::Order);
            PurchLine.Validate("Document No.", PurchHeader."No.");
            PurchLine."Line No." := 10000;
            PurchLine.Validate(Type, PurchLine.Type::"G/L Account");
            PurchLine.Validate("No.", ServMgtSetup."G/L Account for Repair");
            PurchLine.Validate(Quantity, 1);
            PurchLine.Insert(true);
        end else begin
            ServLine.Reset();
            ServLine.SetRange("Document Type", Rec."Document Type");
            ServLine.SetRange("Document No.", Rec."Document No.");
            ServLine.SetRange("Service Item Line No.", Rec."Line No.");
            ServLine.SetRange(Type, ServLine.Type::Item);
            if ServLine.FindSet() then begin
                Clear(PurchLine);
                PurchLine."Document Type" := PurchLine."Document Type"::Order;
                PurchLine."Document No." := PurchHeader."No.";
                PurchLine."Line No." := 0;
                repeat
                    PurchLine.Init();
                    PurchLine."Line No." += 10000;
                    PurchLine.Validate(Type, PurchLine.Type::Item);
                    PurchLine.Validate("No.", ServLine."No.");
                    PurchLine.Validate(Quantity, ServLine.Quantity);
                    PurchLine.Validate("Unit of Measure Code", ServLine."Unit of Measure Code");
                    PurchLine.Insert(true);
                until (ServLine.Next() = 0);
            end;
        end;

        if Dialog.Confirm(StrSubstNo(Text011, PurchHeader."No."), true) then begin
            Commit();
            Page.RunModal(Page::"Purchase Order", PurchHeader);
        END;
    end;
}