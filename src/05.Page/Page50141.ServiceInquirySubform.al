page 50141 "Service Inquiry Subform"
{
    ApplicationArea = All;
    Caption = 'Service Inquiry';
    PageType = ListPart;
    SourceTable = "Service Inquiry Line";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ServHeader: Record "Service Header";
                        ServShipHeader: Record "Service Shipment Header";
                        ServInvHeader: Record "Service Invoice Header";
                        ServCrMemoHeader: Record "Service Cr.Memo Header";
                    begin
                        case Rec."Document Type" of
                            Rec."Document Type"::Quote,
                            Rec."Document Type"::Order,
                            Rec."Document Type"::Invoice,
                            Rec."Document Type"::"Credit Memo":
                                begin
                                    ServHeader.SetRange("Document Type", Rec."Document Type");
                                    ServHeader.SetRange("No.", Rec."Document No.");
                                    if ServHeader.FindFirst() then
                                        Page.RunModal(Page::"Service Order", ServHeader);
                                end;
                            Rec."Document Type"::"Posted Shipment":
                                begin
                                    if ServShipHeader.Get(Rec."Document No.") then
                                        Page.RunModal(Page::"Posted Service Shipment", ServShipHeader);
                                end;
                            Rec."Document Type"::"Posted Invoice":
                                begin
                                    if ServInvHeader.Get(Rec."Document No.") then
                                        Page.RunModal(Page::"Posted Service Invoice", ServInvHeader);
                                end;
                            Rec."Document Type"::"Posted Credit Memo":
                                begin
                                    if ServCrMemoHeader.Get(Rec."Document No.") then
                                        Page.RunModal(Page::"Posted Service Credit Memo", ServCrMemoHeader);
                                end;
                        end;
                        exit(true);
                    end;
                }

                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }
                field("Original Order No."; Rec."Original Order No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Order Date"; Rec."Order Date") { ApplicationArea = All; }
                field("Service Item No."; Rec."Service Item No.") { ApplicationArea = All; }
                field("Service Item Serial No."; Rec."Service Item Serial No.") { ApplicationArea = All; }
                field(Type; Rec.Type) { ApplicationArea = All; }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Unit Price"; Rec."Unit Price") { ApplicationArea = All; }
                field("Amount Including VAT"; Rec."Amount Including VAT") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowData)
            {
                Caption = 'Show Data';
                Image = Refresh;

                trigger OnAction()
                begin
                    RefreshData();
                end;
            }

            action(ClearData)
            {
                Caption = 'Clear Data';
                Image = ClearFilter;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.DeleteAll();

                    ClearFiltersAndTotals();
                end;
            }

            action(CreateServiceCreditMemo)
            {
                Caption = 'Create Service Credit Memo';
                Image = CreditMemo;

                /* trigger OnAction()
                begin
                    CreateServiceCreditMemo();
                end; */
            }
        }
    }

    trigger OnInit()
    begin
        BlnQuote := true;
        BlnOrder := true;
        BlnInvoice := true;
        BlnCrMemo := true;
        BlnPostedShipment := true;
        BlnPostedInvoice := true;
        BlnPostedCrMemo := true;

        BlnItem := true;
        BlnResource := true;
        BlnCost := true;
        BlnGLAccount := true;
    end;

    trigger OnOpenPage()
    begin
        ServItemFilter := Rec.GetFilter("Service Item No.");
        if ServItemFilter = TEXT001 then
            ServItemFilter := '';
    end;

    var
        CustomerFilter: Text[250];
        ServItemFilter: Text[250];
        SerialFilter: Text[250];
        PostingDateFilter: Text[250];
        OrderDateFilter: Text[250];

        BlnQuote: Boolean;
        BlnOrder: Boolean;
        BlnInvoice: Boolean;
        BlnCrMemo: Boolean;
        BlnPostedShipment: Boolean;
        BlnPostedInvoice: Boolean;
        BlnPostedCrMemo: Boolean;

        BlnItem: Boolean;
        BlnResource: Boolean;
        BlnCost: Boolean;
        BlnGLAccount: Boolean;

        DecTotalItemQty: Decimal;
        DecTotalResourceQty: Decimal;
        DecTotalCostQty: Decimal;
        DecTotalGLAccountQty: Decimal;
        DecTotalAmt: Decimal;
        DecTotalAmtVAT: Decimal;

        TEXT001: Label '';

    local procedure RefreshData()
    begin
        // Converted from FORM Refresh()
        // Filtering + Totals logic should be moved here
    end;

    local procedure ClearFiltersAndTotals()
    begin
        CustomerFilter := '';
        ServItemFilter := '';
        SerialFilter := '';
        PostingDateFilter := '';
        OrderDateFilter := '';

        DecTotalItemQty := 0;
        DecTotalResourceQty := 0;
        DecTotalCostQty := 0;
        DecTotalGLAccountQty := 0;
        DecTotalAmt := 0;
        DecTotalAmtVAT := 0;
    end;

    /* local procedure CreateServiceCreditMemo()
    begin
        // Large original logic retained conceptually
        // Should ideally be refactored into a Codeunit in BC
    end; */
}
