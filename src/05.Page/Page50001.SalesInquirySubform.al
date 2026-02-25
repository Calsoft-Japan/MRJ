page 50001 "Sales Inquiry Subform"
{
    ApplicationArea = All;
    Caption = 'Line';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Pagetype = ListPart;
    SourceTable = "Sales Inquiry Line";
    SourceTableTemporary = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Document Type"; Rec."Document Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Document No."; Rec."Document No.")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Original Order No."; Rec."Original Order No.")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Order Status"; Rec."Order Status")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Customer PO No."; Rec."Customer PO No.")
                {
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                }
                field("Planned Shipment Date"; Rec."Planned Shipment Date")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Sales to Countries"; Rec."Sales to Countries")
                {
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Order Date"; Rec."Order Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                }
                field("Transport Method"; Rec."Transport Method")
                {
                }
                field("Exit Point"; Rec."Exit Point")
                {
                }
                field(RecArea; Rec.Area)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                }
                field("Total Cost"; Rec."Total Cost")
                {
                }
                field("Line Amount"; Rec."Line Amount")
                {
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Compress Prepayment"; Rec."Compress Prepayment")
                {
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Prepayment %"; Rec."Prepayment %")
                {
                }
                field("Prepmt. Payment Terms Code"; Rec."Prepmt. Payment Terms Code")
                {
                }
                field("Prepayment Due Date"; Rec."Prepayment Due Date")
                {
                }
                field("Prepmt. Payment Discount %"; Rec."Prepmt. Payment Discount %")
                {
                }
                field("Prepmt. Pmt. Discount Date"; Rec."Prepmt. Pmt. Discount Date")
                {
                }
                field("Net Weight"; Rec."Net Weight")
                {
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                }
                field("Reason Code"; Rec."Reason Code")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                }
            }
        }
    }
    trigger OnInit();
    begin
        ShowHeader := true;
        ShowLine := true;
    end;

    trigger OnOpenPage();
    begin
        GLSetup.Get;
    end;

    var
        GLSetup: Record 98;
        SalesHdr: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CurrExchRate: Record "Currency Exchange Rate";
        DimMgt: Codeunit "DimensionManagement";
        SelltoCustomerFilter: Text;
        BilltoCustomerFilter: Text;
        PostingDateFilter: Text;
        OrderDateFilter: Text;
        ItemFilter: Text;
        decTotalQty: Decimal;
        decTotalAmount: Decimal;
        decTotalAmountInclVAT: Decimal;
        ShowHeader: Boolean;
        ShowLine: Boolean;
        ShowZeroAmtLine: Boolean;
        SalesQuote: Boolean;
        SalesOrder: Boolean;
        SalesInvoice: Boolean;
        SalesCreditMemo: Boolean;
        SalesReturnOrder: Boolean;
        CloesdOrder: Boolean;
        PostedSalesInvoice: Boolean;
        PostedSalesCrMemo: Boolean;
        ShortcutDimCode: array[8] of Code[20];

    procedure SetIncludeTable(pSQ: Boolean; pSO: Boolean; pSInv: Boolean; pSCrMemo: Boolean; pSRO: Boolean; pPSInv: Boolean; pPCrMemo: Boolean);
    begin
        SalesQuote := pSQ;
        SalesOrder := pSO;
        SalesInvoice := pSInv;
        SalesCreditMemo := pSCrMemo;
        SalesReturnOrder := pSRO;
        PostedSalesInvoice := pPSInv;
        PostedSalesCrMemo := pPCrMemo;
    end;

    procedure SetHeaderFilter(pSellToCust: Text; pBillToCust: Text; pPostDate: Text; pOrdDate: Text);
    begin
        SelltoCustomerFilter := pSellToCust;
        BilltoCustomerFilter := pBillToCust;
        PostingDateFilter := pPostDate;
        OrderDateFilter := pOrdDate;
    end;

    procedure SetLineFilter(pItemTxt: Text; pShowZeroAmtLine: Boolean);
    begin
        ItemFilter := pItemTxt;
        ShowZeroAmtLine := pShowZeroAmtLine;
    end;

    /* procedure ControlShowMode(ShowMode: Option "Header + Line");
    begin
        case ShowMode of
            ShowMode::"Header + Line":
                begin
                    ShowHeader := true;
                    ShowLine := true;
                end;
        end;
        CurrPage.Update(false);
    end; */

    procedure ClearInquiryData(CurrGUID: Guid);
    begin
        Rec.Reset();
        Rec.SetRange(GUID, CurrGUID);
        if not Rec.IsEmpty then begin
            if Rec.Count = 1 then begin
                Rec."Line No." += 10000;
                Rec.Insert();
            end;
            Rec.DeleteAll();
        end;
        CurrPage.Update(false);
    end;

    procedure GetTotalValue(var SetTotalQty: Decimal; var SetTotalAmount: Decimal; var SetTotAmtInclVAT: Decimal);
    begin
        SetTotalQty := decTotalQty;
        SetTotalAmount := decTotalAmount;
        SetTotAmtInclVAT := decTotalAmountInclVAT;
    end;

    procedure SetFixedFields(CurrGUID: Guid);
    begin
        Rec.GUID := CurrGUID;
        Rec."Creation Date" := Today();
    end;

    procedure FindRecords(CurrGUID: Guid);
    begin
        Rec.Reset();
        Rec.SetRange(GUID, CurrGUID);
        Rec.DeleteAll();

        decTotalQty := 0;
        decTotalAmount := 0;
        decTotalAmountInclVAT := 0;

        FindSalesRecord(CurrGUID);
        FindPostedSalesInvoice(CurrGUID);
        FindPostedSalesCrMemo(CurrGUID);

        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    procedure FindSalesRecord(CurrGUID: Guid);
    var
        DocFilter: Text;
    begin
        DocFilter := '';
        if SalesQuote then
            DocFilter := '0';

        if SalesOrder and (DocFilter <> '') then
            DocFilter := DocFilter + '|1';
        if SalesOrder and (DocFilter = '') then
            DocFilter := '1';

        if SalesInvoice and (DocFilter <> '') then
            DocFilter := DocFilter + '|2';
        if SalesInvoice and (DocFilter = '') then
            DocFilter := '2';

        if SalesCreditMemo and (DocFilter <> '') then
            DocFilter := DocFilter + '|3';
        if SalesCreditMemo and (DocFilter = '') then
            DocFilter := '3';

        if SalesReturnOrder and (DocFilter <> '') then
            DocFilter := DocFilter + '|5';
        if SalesReturnOrder and (DocFilter = '') then
            DocFilter := '5';

        /* if CloesdOrder and (DocFilter <> '') then
            DocFilter := DocFilter + '|10';
        if CloesdOrder and (DocFilter = '') then
            DocFilter := '10'; */

        if DocFilter <> '' then begin
            SalesHdr.Reset();
            SalesLine.Reset();
            if DocFilter <> '' then
                SalesHdr.SetFilter("Document Type", DocFilter);
            if SelltoCustomerFilter <> '' then
                SalesHdr.SetFilter("Sell-to Customer No.", SelltoCustomerFilter);
            if BilltoCustomerFilter <> '' then
                SalesHdr.SetFilter("Bill-to Customer No.", BilltoCustomerFilter);
            if PostingDateFilter <> '' then
                SalesHdr.SetFilter("Posting Date", PostingDateFilter);
            if OrderDateFilter <> '' then
                SalesHdr.SetFilter("Order Date", OrderDateFilter);
            if SalesHdr.FindSet() then
                repeat
                    SalesLine.SetRange("Document Type", SalesHdr."Document Type");
                    SalesLine.SetRange("Document No.", SalesHdr."No.");
                    SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
                    if not ShowZeroAmtLine then
                        SalesLine.SetFilter(Amount, '<>0');
                    if ItemFilter <> '' then
                        SalesLine.SetFilter("No.", ItemFilter);
                    if SalesLine.FindSet() then
                        repeat
                            Rec.Init();
                            case SalesLine."Document Type" of
                                SalesLine."Document Type"::Quote:
                                    Rec."Document Type" := Rec."Document Type"::Quote;
                                SalesLine."Document Type"::Order:
                                    Rec."Document Type" := Rec."Document Type"::Order;
                                SalesLine."Document Type"::Invoice:
                                    Rec."Document Type" := Rec."Document Type"::Invoice;
                                SalesLine."Document Type"::"Credit Memo":
                                    Rec."Document Type" := Rec."Document Type"::"Credit Memo";
                                SalesLine."Document Type"::"Return Order":
                                    Rec."Document Type" := Rec."Document Type"::"Return Order";
                            //SalesLine."Document Type"::"Closed Order":
                            //Rec."Document Type" := Rec."Document Type"::"Closed Order";
                            end;
                            SetFixedFields(CurrGUID);
                            Rec."Document No." := SalesLine."Document No.";
                            Rec."Order Status" := SalesHdr.Status;
                            Rec."Line No." := SalesLine."Line No.";
                            Rec."Customer PO No." := SalesHdr."External Document No.";
                            Rec."Requested Delivery Date" := SalesLine."Requested Delivery Date";
                            Rec."Planned Delivery Date" := SalesLine."Planned Delivery Date";
                            Rec."Planned Shipment Date" := SalesLine."Planned Shipment Date";
                            Rec."Shipment Date" := SalesLine."Shipment Date";
                            Rec."Customer No." := SalesLine."Sell-to Customer No.";
                            Rec."Customer Name" := SalesHdr."Sell-to Customer Name";
                            Rec."Sales to Countries" := SalesHdr."Sell-to Country/Region Code";
                            Rec."Bill-to Customer No." := SalesHdr."Bill-to Customer No.";
                            Rec."Bill-to Name" := SalesHdr."Bill-to Name";
                            Rec."Ship-to Code" := SalesHdr."Ship-to Code";
                            Rec."Ship-to Name" := SalesHdr."Ship-to Name";
                            Rec."Ship-to Address" := SalesHdr."Ship-to Address";
                            Rec."Ship-to City" := SalesHdr."Ship-to City";
                            Rec."Ship-to Post Code" := SalesHdr."Ship-to Post Code";
                            Rec."Ship-to Country/Region Code" := SalesHdr."Ship-to Country/Region Code";
                            Rec."Posting Date" := SalesHdr."Posting Date";
                            Rec."Order Date" := SalesHdr."Order Date";
                            Rec."Document Date" := SalesHdr."Document Date";
                            Rec."Transaction Type" := SalesLine."Transaction Type";
                            Rec."Transaction Specification" := SalesLine."Transaction Specification";
                            Rec."Transport Method" := SalesLine."Transport Method";
                            Rec."Exit Point" := SalesLine."Exit Point";
                            Rec.Area := SalesLine.Area;
                            Rec.Type := SalesLine.Type;
                            Rec."Item No." := SalesLine."No.";
                            Rec."Item Description" := SalesLine.Description;
                            Rec.Quantity := SalesLine.Quantity;
                            Rec."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                            Rec."Unit of Measure" := SalesLine."Unit of Measure";
                            Rec."Qty. to Ship" := SalesLine."Qty. to Ship";
                            Rec."Qty. to Invoice" := SalesLine."Qty. to Invoice";
                            Rec."Quantity Shipped" := SalesLine."Quantity Shipped";
                            Rec."Quantity Invoiced" := SalesLine."Quantity Invoiced";
                            Rec."Currency Code" := SalesLine."Currency Code";
                            Rec."Location Code" := SalesLine."Location Code";
                            Rec."Unit Cost" := SalesLine."Unit Cost";
                            Rec."Total Cost" := Rec.Quantity * Rec."Unit Cost";
                            Rec."Line Amount" := SalesLine."Line Amount";
                            Rec."Line Discount Amount" := SalesLine."Line Discount Amount";
                            Rec."Line Discount %" := SalesLine."Line Discount %";
                            Rec."Shipment Method Code" := SalesHdr."Shipment Method Code";
                            Rec."Shipping Agent Code" := SalesLine."Shipping Agent Code";
                            Rec."Payment Terms Code" := SalesHdr."Payment Terms Code";
                            Rec."Payment Method Code" := SalesHdr."Payment Method Code";
                            Rec."Due Date" := SalesHdr."Due Date";
                            Rec."Payment Discount %" := SalesHdr."Payment Discount %";
                            Rec."Pmt. Discount Date" := SalesHdr."Pmt. Discount Date";
                            Rec."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
                            Rec."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
                            Rec."Customer Posting Group" := SalesHdr."Customer Posting Group";
                            Rec."VAT Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
                            Rec."VAT Prod. Posting Group" := SalesLine."VAT Prod. Posting Group";
                            Rec."Salesperson Code" := SalesHdr."Salesperson Code";
                            Rec."Responsibility Center" := SalesLine."Responsibility Center";
                            Rec."Prepayment %" := SalesLine."Prepayment %";
                            Rec."Compress Prepayment" := SalesHdr."Compress Prepayment";
                            Rec."Prepmt. Payment Terms Code" := SalesHdr."Prepmt. Payment Terms Code";
                            Rec."Prepayment Due Date" := SalesHdr."Prepayment Due Date";
                            Rec."Prepmt. Payment Discount %" := SalesHdr."Prepmt. Payment Discount %";
                            Rec."Prepmt. Pmt. Discount Date" := SalesHdr."Prepmt. Pmt. Discount Date";
                            Rec."Net Weight" := SalesLine."Net Weight";
                            Rec."Gross Weight" := SalesLine."Gross Weight";
                            Rec."Reason Code" := SalesHdr."Reason Code";
                            Rec."Global Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
                            Rec."Global Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
                            Rec."Dimension Set ID" := SalesLine."Dimension Set ID";
                            DimMgt.GetShortcutDimensions(SalesLine."Dimension Set ID", ShortcutDimCode);
                            Rec."Shortcut Dimension 3 Code" := ShortcutDimCode[3];
                            Rec."Shortcut Dimension 4 Code" := ShortcutDimCode[4];
                            Rec."Shortcut Dimension 5 Code" := ShortcutDimCode[5];
                            Rec."Shortcut Dimension 6 Code" := ShortcutDimCode[6];
                            Rec."Shortcut Dimension 7 Code" := ShortcutDimCode[7];
                            Rec."Shortcut Dimension 8 Code" := ShortcutDimCode[8];
                            SalesLine.CALCFIELDS("Reserved Quantity");
                            Rec."Reserved Quantity" := SalesLine."Reserved Quantity";
                            Rec."Promised Delivery Date" := SalesLine."Promised Delivery Date";
                            Rec."Original Order No." := SalesHdr."No.";

                            Rec.TotalQty := Rec.Quantity;
                            Rec.TotalAmount := Rec."Line Amount";
                            Rec.TotalAmountInclVAT := Rec."Line Amount" * (1 + SalesLine."VAT %" / 100);
                            if Rec."Currency Code" <> '' then begin
                                Rec.TotalAmount :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToLCY(
                                      GetDate(Rec."Posting Date"), Rec."Currency Code", decTotalAmount,
                                      SalesHdr."Currency Factor"),
                                    GLSetup."Amount Rounding Precision");
                                Rec.TotalAmountInclVAT :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToLCY(
                                      GetDate(Rec."Posting Date"), Rec."Currency Code", decTotalAmountInclVAT,
                                      SalesHdr."Currency Factor"),
                                    GLSetup."Amount Rounding Precision");
                            end;
                            decTotalQty += Rec.TotalQty;
                            decTotalAmount += Rec.TotalAmount;
                            decTotalAmountInclVAT += Rec.TotalAmountInclVAT;
                            Rec.INSERT;
                        UNTIL SalesLine.NEXT = 0;
                UNTIL SalesHdr.NEXT = 0;
        end;
    end;

    procedure FindPostedSalesInvoice(CurrGUID: Guid);
    var
    begin
        if PostedSalesInvoice then begin
            SalesInvHdr.Reset();
            SalesInvLine.Reset();
            if SelltoCustomerFilter <> '' then
                SalesInvHdr.SetFilter("Sell-to Customer No.", SelltoCustomerFilter);
            if BilltoCustomerFilter <> '' then
                SalesInvHdr.SetFilter("Bill-to Customer No.", BilltoCustomerFilter);
            if PostingDateFilter <> '' then
                SalesInvHdr.SetFilter("Posting Date", PostingDateFilter);
            if OrderDateFilter <> '' then
                SalesInvHdr.SetFilter("Order Date", OrderDateFilter);
            if SalesInvHdr.FindSet() then
                repeat
                    SalesInvHdr.CalcFields(Comment, Amount, "Amount Including VAT");
                    SalesInvLine.SetRange("Document No.", SalesInvHdr."No.");
                    SalesInvLine.SetFilter(Type, '<>%1', SalesInvLine.Type::" ");
                    if not ShowZeroAmtLine then
                        SalesInvLine.SetFilter(Amount, '<>0');
                    if ItemFilter <> '' then
                        SalesInvLine.SetFilter("No.", ItemFilter);
                    if SalesInvLine.FindSet() then
                        repeat
                            Rec.Init();
                            SetFixedFields(CurrGUID);
                            Rec."Document Type" := Rec."Document Type"::"Posted Invoice";
                            Rec."Document No." := SalesInvLine."Document No.";
                            Rec."Order Status" := Rec."Order Status"::Released;
                            Rec."Line No." := SalesInvLine."Line No.";
                            Rec."Customer PO No." := SalesInvHdr."External Document No.";
                            Rec."Shipment Date" := SalesInvLine."Shipment Date";
                            Rec."Customer No." := SalesInvLine."Sell-to Customer No.";
                            Rec."Customer Name" := SalesInvHdr."Sell-to Customer Name";
                            Rec."Sales to Countries" := SalesInvHdr."Sell-to Country/Region Code";
                            Rec."Bill-to Customer No." := SalesInvHdr."Bill-to Customer No.";
                            Rec."Bill-to Name" := SalesInvHdr."Bill-to Name";
                            Rec."Ship-to Code" := SalesInvHdr."Ship-to Code";
                            Rec."Ship-to Name" := SalesInvHdr."Ship-to Name";
                            Rec."Ship-to Address" := SalesInvHdr."Ship-to Address";
                            Rec."Ship-to City" := SalesInvHdr."Ship-to City";
                            Rec."Ship-to Post Code" := SalesInvHdr."Ship-to Post Code";
                            Rec."Ship-to Country/Region Code" := SalesInvHdr."Ship-to Country/Region Code";
                            Rec."Posting Date" := SalesInvHdr."Posting Date";
                            Rec."Order Date" := SalesInvHdr."Order Date";
                            Rec."Document Date" := SalesInvHdr."Document Date";
                            Rec."Transaction Type" := SalesInvLine."Transaction Type";
                            Rec."Transaction Specification" := SalesInvLine."Transaction Specification";
                            Rec."Transport Method" := SalesInvLine."Transport Method";
                            Rec."Exit Point" := SalesInvLine."Exit Point";
                            Rec.Area := SalesInvLine.Area;
                            Rec.Type := SalesInvLine.Type;
                            Rec."Item No." := SalesInvLine."No.";
                            Rec."Item Description" := SalesInvLine.Description;
                            Rec.Quantity := SalesInvLine.Quantity;
                            Rec."Unit of Measure Code" := SalesInvLine."Unit of Measure Code";
                            Rec."Unit of Measure" := SalesInvLine."Unit of Measure";
                            Rec."Quantity Shipped" := SalesInvLine.Quantity;
                            Rec."Quantity Invoiced" := SalesInvLine.Quantity;
                            Rec."Currency Code" := SalesInvHdr."Currency Code";
                            Rec."Location Code" := SalesInvLine."Location Code";
                            Rec."Unit Cost" := SalesInvLine."Unit Cost";
                            Rec."Total Cost" := Rec.Quantity * Rec."Unit Cost";
                            Rec."Line Amount" := SalesInvLine."Line Amount";
                            Rec."Line Discount Amount" := SalesInvLine."Line Discount Amount";
                            Rec."Line Discount %" := SalesInvLine."Line Discount %";
                            Rec."Shipment Method Code" := SalesInvHdr."Shipment Method Code";
                            Rec."Shipping Agent Code" := SalesInvHdr."Shipping Agent Code";
                            Rec."Payment Terms Code" := SalesInvHdr."Payment Terms Code";
                            Rec."Payment Method Code" := SalesInvHdr."Payment Method Code";
                            Rec."Due Date" := SalesInvHdr."Due Date";
                            Rec."Payment Discount %" := SalesInvHdr."Payment Discount %";
                            Rec."Pmt. Discount Date" := SalesInvHdr."Pmt. Discount Date";
                            Rec."Gen. Bus. Posting Group" := SalesInvLine."Gen. Bus. Posting Group";
                            Rec."Gen. Prod. Posting Group" := SalesInvLine."Gen. Prod. Posting Group";
                            Rec."Customer Posting Group" := SalesInvHdr."Customer Posting Group";
                            Rec."VAT Bus. Posting Group" := SalesInvLine."VAT Bus. Posting Group";
                            Rec."VAT Prod. Posting Group" := SalesInvLine."VAT Prod. Posting Group";
                            Rec."Salesperson Code" := SalesInvHdr."Salesperson Code";
                            Rec."Responsibility Center" := SalesInvLine."Responsibility Center";
                            Rec."Net Weight" := SalesInvLine."Net Weight";
                            Rec."Gross Weight" := SalesInvLine."Gross Weight";
                            Rec."Reason Code" := SalesInvHdr."Reason Code";
                            Rec."Global Dimension 1 Code" := SalesInvLine."Shortcut Dimension 1 Code";
                            Rec."Global Dimension 2 Code" := SalesInvLine."Shortcut Dimension 2 Code";
                            Rec."Dimension Set ID" := SalesLine."Dimension Set ID";
                            DimMgt.GetShortcutDimensions(SalesInvLine."Dimension Set ID", ShortcutDimCode);
                            Rec."Shortcut Dimension 3 Code" := ShortcutDimCode[3];
                            Rec."Shortcut Dimension 4 Code" := ShortcutDimCode[4];
                            Rec."Shortcut Dimension 5 Code" := ShortcutDimCode[5];
                            Rec."Shortcut Dimension 6 Code" := ShortcutDimCode[6];
                            Rec."Shortcut Dimension 7 Code" := ShortcutDimCode[7];
                            Rec."Shortcut Dimension 8 Code" := ShortcutDimCode[8];
                            Rec."Original Order No." := SalesInvHdr."Order No.";
                            Rec.TotalQty := Rec.Quantity;
                            Rec.TotalAmount := Rec."Line Amount";
                            Rec.TotalAmountInclVAT := Rec."Line Amount" * (1 + SalesInvLine."VAT %" / 100);
                            if Rec."Currency Code" <> '' then begin
                                Rec.TotalAmount :=
                                    ROUND(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                          Rec."Currency Code", Rec.TotalAmount, SalesInvHdr."Currency Factor"),
                                          GLSetup."Amount Rounding Precision");
                                Rec.TotalAmountInclVAT :=
                                    ROUND(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                          Rec."Currency Code", Rec.TotalAmountInclVAT, SalesInvHdr."Currency Factor"),
                                          GLSetup."Amount Rounding Precision");
                            end;
                            decTotalQty += Rec.TotalQty;
                            decTotalAmount += Rec.TotalAmount;
                            decTotalAmountInclVAT += Rec.TotalAmountInclVAT;
                            Rec.INSERT;
                        UNTIL SalesInvLine.NEXT = 0;
                UNTIL SalesInvHdr.NEXT = 0;
        end;
    end;

    procedure FindPostedSalesCrMemo(CurrGUID: Guid);
    begin
        if PostedSalesCrMemo then begin
            SalesCrMemoHdr.Reset();
            SalesCrMemoLine.Reset();
            if SelltoCustomerFilter <> '' then
                SalesCrMemoHdr.SetFilter("Sell-to Customer No.", SelltoCustomerFilter);
            if BilltoCustomerFilter <> '' then
                SalesCrMemoHdr.SetFilter("Bill-to Customer No.", BilltoCustomerFilter);
            if PostingDateFilter <> '' then
                SalesCrMemoHdr.SetFilter("Posting Date", PostingDateFilter);
            if OrderDateFilter <> '' then
                SalesCrMemoHdr.SetFilter("Document Date", OrderDateFilter);
            if SalesCrMemoHdr.FindSet() then
                repeat
                    SalesCrMemoHdr.CalcFields(Comment, Amount, "Amount Including VAT");
                    SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHdr."No.");
                    SalesCrMemoLine.SetFilter(Type, '<>%1', SalesCrMemoLine.Type::" ");
                    if not ShowZeroAmtLine then
                        SalesCrMemoLine.SetFilter(Amount, '<>0');
                    if ItemFilter <> '' then
                        SalesCrMemoLine.SetFilter("No.", ItemFilter);
                    if SalesCrMemoLine.FindSet() then
                        repeat
                            Rec.Init();
                            SetFixedFields(CurrGUID);
                            Rec."Document Type" := Rec."Document Type"::"Posted Credit Memo";
                            Rec."Document No." := SalesCrMemoLine."Document No.";
                            Rec."Order Status" := Rec."Order Status"::Released;
                            Rec."Line No." := SalesCrMemoLine."Line No.";
                            Rec."Customer PO No." := SalesCrMemoHdr."External Document No.";
                            Rec."Shipment Date" := SalesCrMemoLine."Shipment Date";
                            Rec."Customer No." := SalesCrMemoLine."Sell-to Customer No.";
                            Rec."Customer Name" := SalesCrMemoHdr."Sell-to Customer Name";
                            Rec."Sales to Countries" := SalesCrMemoHdr."Sell-to Country/Region Code";
                            Rec."Bill-to Customer No." := SalesCrMemoHdr."Bill-to Customer No.";
                            Rec."Bill-to Name" := SalesCrMemoHdr."Bill-to Name";
                            Rec."Ship-to Code" := SalesCrMemoHdr."Ship-to Code";
                            Rec."Ship-to Name" := SalesCrMemoHdr."Ship-to Name";
                            Rec."Ship-to Address" := SalesCrMemoHdr."Ship-to Address";
                            Rec."Ship-to City" := SalesCrMemoHdr."Ship-to City";
                            Rec."Ship-to Post Code" := SalesCrMemoHdr."Ship-to Post Code";
                            Rec."Ship-to Country/Region Code" := SalesCrMemoHdr."Ship-to Country/Region Code";
                            Rec."Posting Date" := SalesCrMemoHdr."Posting Date";
                            Rec."Document Date" := SalesCrMemoHdr."Document Date";
                            Rec."Transaction Type" := SalesCrMemoLine."Transaction Type";
                            Rec."Transaction Specification" := SalesCrMemoLine."Transaction Specification";
                            Rec."Transport Method" := SalesCrMemoLine."Transport Method";
                            Rec."Exit Point" := SalesCrMemoLine."Exit Point";
                            Rec.Area := SalesCrMemoLine.Area;
                            Rec.Type := SalesCrMemoLine.Type;
                            Rec."Item No." := SalesCrMemoLine."No.";
                            Rec."Item Description" := SalesCrMemoLine.Description;
                            Rec.Quantity := SalesCrMemoLine.Quantity;
                            Rec."Unit of Measure Code" := SalesCrMemoLine."Unit of Measure Code";
                            Rec."Unit of Measure" := SalesCrMemoLine."Unit of Measure";
                            Rec."Quantity Shipped" := SalesCrMemoLine.Quantity;
                            Rec."Quantity Invoiced" := SalesCrMemoLine.Quantity;
                            Rec."Currency Code" := SalesCrMemoHdr."Currency Code";
                            Rec."Location Code" := SalesCrMemoLine."Location Code";
                            Rec."Unit Cost" := SalesCrMemoLine."Unit Cost";
                            Rec."Total Cost" := Rec.Quantity * Rec."Unit Cost";
                            Rec."Line Amount" := SalesCrMemoLine."Line Amount";
                            Rec."Line Discount Amount" := SalesCrMemoLine."Line Discount Amount";
                            Rec."Line Discount %" := SalesCrMemoLine."Line Discount %";
                            Rec."Shipment Method Code" := SalesCrMemoHdr."Shipment Method Code";
                            Rec."Payment Terms Code" := SalesCrMemoHdr."Payment Terms Code";
                            Rec."Payment Method Code" := SalesCrMemoHdr."Payment Method Code";
                            Rec."Due Date" := SalesCrMemoHdr."Due Date";
                            Rec."Payment Discount %" := SalesCrMemoHdr."Payment Discount %";
                            Rec."Pmt. Discount Date" := SalesCrMemoHdr."Pmt. Discount Date";
                            Rec."Gen. Bus. Posting Group" := SalesCrMemoLine."Gen. Bus. Posting Group";
                            Rec."Gen. Prod. Posting Group" := SalesCrMemoLine."Gen. Prod. Posting Group";
                            Rec."Customer Posting Group" := SalesCrMemoHdr."Customer Posting Group";
                            Rec."VAT Bus. Posting Group" := SalesCrMemoLine."VAT Bus. Posting Group";
                            Rec."VAT Prod. Posting Group" := SalesCrMemoLine."VAT Prod. Posting Group";
                            Rec."Salesperson Code" := SalesCrMemoHdr."Salesperson Code";
                            Rec."Responsibility Center" := SalesCrMemoLine."Responsibility Center";
                            Rec."Net Weight" := SalesCrMemoLine."Net Weight";
                            Rec."Gross Weight" := SalesCrMemoLine."Gross Weight";
                            Rec."Reason Code" := SalesCrMemoHdr."Reason Code";
                            Rec."Global Dimension 1 Code" := SalesCrMemoLine."Shortcut Dimension 1 Code";
                            Rec."Global Dimension 2 Code" := SalesCrMemoLine."Shortcut Dimension 2 Code";
                            Rec."Dimension Set ID" := SalesLine."Dimension Set ID";
                            DimMgt.GetShortcutDimensions(SalesCrMemoLine."Dimension Set ID", ShortcutDimCode);
                            Rec."Shortcut Dimension 3 Code" := ShortcutDimCode[3];
                            Rec."Shortcut Dimension 4 Code" := ShortcutDimCode[4];
                            Rec."Shortcut Dimension 5 Code" := ShortcutDimCode[5];
                            Rec."Shortcut Dimension 6 Code" := ShortcutDimCode[6];
                            Rec."Shortcut Dimension 7 Code" := ShortcutDimCode[7];
                            Rec."Shortcut Dimension 8 Code" := ShortcutDimCode[8];
                            Rec."Original Order No." := '';
                            Rec.TotalQty := Rec.Quantity;
                            Rec.TotalAmount := Rec."Line Amount";
                            Rec.TotalAmountInclVAT := Rec."Line Amount" * (1 + SalesCrMemoLine."VAT %" / 100);
                            if Rec."Currency Code" <> '' then begin
                                Rec.TotalAmount :=
                                    ROUND(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                          Rec."Currency Code", Rec.TotalAmount, SalesCrMemoHdr."Currency Factor"),
                                          GLSetup."Amount Rounding Precision");
                                Rec.TotalAmountInclVAT :=
                                    ROUND(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                          Rec."Currency Code", Rec.TotalAmountInclVAT, SalesCrMemoHdr."Currency Factor"),
                                          GLSetup."Amount Rounding Precision");
                            end;
                            decTotalQty += Rec.TotalQty;
                            decTotalAmount += Rec.TotalAmount;
                            decTotalAmountInclVAT += Rec.TotalAmountInclVAT;
                            Rec.INSERT;
                        UNTIL SalesCrMemoLine.NEXT = 0;
                UNTIL SalesCrMemoHdr.NEXT = 0;
        end;
    end;

    local procedure GetDate(RecDate: Date): Date;
    begin
        if RecDate <> 0D then
            EXIT(RecDate)
        ELSE
            EXIT(WORKDATE);
    end;

    procedure ExportDataToExcel(ShowTrackingInfo: Boolean);
    var
        RowNo: Integer;
        SalesLine: Record 37;
        ReservEngineMgt: Codeunit 99000831;
        ReserveSalesOrderLine: Codeunit 99000832;
        lrReservEntry: Record 337;
        SalesInvLine: Record 113;
        ItemTrackingMgmt: Codeunit 6500;
        TempItemLedgEntry: Record 32;
        lrecSalesCrMemoLine: Record 115;
        decRemainingQty: Decimal;
        lrecItemLedgerEntry: Record 32;
        lresShipmentLine: Record 111;
    begin
        TempExcelBuffer.DELETEALL;
        CLEAR(TempExcelBuffer);

        RowNo := 1;
        TempExcelBuffer.CreateNewBook('Sales Inquiry');
        EnterCell(RowNo, 1, Rec.FIELDCAPTION("Document Type"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 2, Rec.FIELDCAPTION("Document No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 3, Rec.FIELDCAPTION("Line No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 4, Rec.FIELDCAPTION("Customer PO No."), TRUE, FALSE, FALSE, '@');
        //EnterCell(RowNo, 5, Rec.FIELDCAPTION("Posted Sales Invoice No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 5, Rec.FIELDCAPTION("Requested Delivery Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 6, Rec.FIELDCAPTION("Planned Delivery Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 7, Rec.FIELDCAPTION("Planned Shipment Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 8, Rec.FIELDCAPTION("Shipment Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 9, Rec.FIELDCAPTION("Customer No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 10, Rec.FIELDCAPTION("Customer Name"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 11, Rec.FIELDCAPTION("Sales to Countries"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 12, Rec.FIELDCAPTION("Bill-to Customer No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 13, Rec.FIELDCAPTION("Bill-to Name"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 14, Rec.FIELDCAPTION("Ship-to Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 15, Rec.FIELDCAPTION("Ship-to Name"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 16, Rec.FIELDCAPTION("Ship-to Address"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 17, Rec.FIELDCAPTION("Ship-to City"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 18, Rec.FIELDCAPTION("Ship-to Post Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 19, Rec.FIELDCAPTION("Ship-to Country/Region Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 20, Rec.FIELDCAPTION("Posting Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 21, Rec.FIELDCAPTION("Order Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 22, Rec.FIELDCAPTION("Document Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 23, Rec.FIELDCAPTION("Transaction Type"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 24, Rec.FIELDCAPTION("Transaction Specification"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 25, Rec.FIELDCAPTION("Transport Method"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 26, Rec.FIELDCAPTION("Exit Point"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 27, Rec.FIELDCAPTION(Area), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 28, Rec.FIELDCAPTION(Type), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 29, Rec.FIELDCAPTION("Item No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 30, Rec.FIELDCAPTION("Item Description"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 31, Rec.FIELDCAPTION(Quantity), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 32, Rec.FIELDCAPTION("Unit of Measure Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 33, Rec.FIELDCAPTION("Unit of Measure"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 34, Rec.FIELDCAPTION("Reserved Quantity"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 35, Rec.FIELDCAPTION("Qty. to Ship"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 36, Rec.FIELDCAPTION("Qty. to Invoice"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 37, Rec.FIELDCAPTION("Quantity Shipped"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 38, Rec.FIELDCAPTION("Quantity Invoiced"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 39, Rec.FIELDCAPTION("Currency Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 40, Rec.FIELDCAPTION("Location Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 41, Rec.FIELDCAPTION("Unit Cost"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 42, Rec.FIELDCAPTION("Total Cost"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 43, Rec.FIELDCAPTION("Line Amount"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 44, Rec.FIELDCAPTION("Line Discount Amount"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 45, Rec.FIELDCAPTION("Line Discount %"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 46, Rec.FIELDCAPTION("Shipment Method Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 47, Rec.FIELDCAPTION("Shipping Agent Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 48, Rec.FIELDCAPTION("Payment Terms Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 49, Rec.FIELDCAPTION("Payment Method Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 50, Rec.FIELDCAPTION("Pre-paid/Collect"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 51, Rec.FIELDCAPTION("Due Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 52, Rec.FIELDCAPTION("Payment Discount %"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 53, Rec.FIELDCAPTION("Pmt. Discount Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 54, Rec.FIELDCAPTION("Gen. Bus. Posting Group"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 55, Rec.FIELDCAPTION("Gen. Prod. Posting Group"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 56, Rec.FIELDCAPTION("Customer Posting Group"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 57, Rec.FIELDCAPTION("VAT Bus. Posting Group"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 58, Rec.FIELDCAPTION("VAT Prod. Posting Group"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 59, Rec.FIELDCAPTION("Salesperson Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 60, Rec.FIELDCAPTION("Responsibility Center"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 61, Rec.FIELDCAPTION("Prepayment %"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 62, Rec.FIELDCAPTION("Compress Prepayment"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 63, Rec.FIELDCAPTION("Prepmt. Payment Terms Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 64, Rec.FIELDCAPTION("Prepayment Due Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 65, Rec.FIELDCAPTION("Prepmt. Payment Discount %"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 66, Rec.FIELDCAPTION("Prepmt. Pmt. Discount Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 67, Rec.FIELDCAPTION("Net Weight"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 68, Rec.FIELDCAPTION("Gross Weight"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 69, Rec.FIELDCAPTION("Reason Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 70, Rec.FIELDCAPTION("Global Dimension 1 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 71, Rec.FIELDCAPTION("Global Dimension 2 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 72, Rec.FIELDCAPTION("Shortcut Dimension 3 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 73, Rec.FIELDCAPTION("Shortcut Dimension 4 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 74, Rec.FIELDCAPTION("Shortcut Dimension 5 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 75, Rec.FIELDCAPTION("Shortcut Dimension 6 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 76, Rec.FIELDCAPTION("Shortcut Dimension 7 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 77, Rec.FIELDCAPTION("Shortcut Dimension 8 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 78, Rec.FIELDCAPTION("Expected Delivery Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 79, Rec.FIELDCAPTION("Promised Delivery Date"), TRUE, FALSE, FALSE, '@');
        if ShowTrackingInfo then begin
            EnterCell(RowNo, 80, lrReservEntry.FIELDCAPTION("Serial No."), TRUE, FALSE, FALSE, '@');
            EnterCell(RowNo, 81, lrReservEntry.FIELDCAPTION("Lot No."), TRUE, FALSE, FALSE, '@');
            EnterCell(RowNo, 82, lrReservEntry.FIELDCAPTION("Expiration Date"), TRUE, FALSE, FALSE, '@');
            EnterCell(RowNo, 83, lrReservEntry.FIELDCAPTION(Quantity), TRUE, FALSE, FALSE, '@');
        end;

        if Rec.FindSet() then
            repeat
                RowNo += 1;
                EnterCell(RowNo, 1, FORMAT(Rec."Document Type"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 2, FORMAT(Rec."Document No."), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 3, FORMAT(Rec."Line No."), FALSE, FALSE, FALSE, '');
                if Rec."Customer PO No." <> '' then
                    EnterCell(RowNo, 4, FORMAT(Rec."Customer PO No."), FALSE, FALSE, FALSE, '@');
                if Rec."Requested Delivery Date" <> 0D then
                    EnterCell(RowNo, 5, FORMAT(Rec."Requested Delivery Date"), FALSE, FALSE, FALSE, '');
                if Rec."Planned Delivery Date" <> 0D then
                    EnterCell(RowNo, 6, FORMAT(Rec."Planned Delivery Date"), FALSE, FALSE, FALSE, '');
                if Rec."Planned Shipment Date" <> 0D then
                    EnterCell(RowNo, 7, FORMAT(Rec."Planned Shipment Date"), FALSE, FALSE, FALSE, '');
                if Rec."Shipment Date" <> 0D then
                    EnterCell(RowNo, 8, FORMAT(Rec."Shipment Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 9, FORMAT(Rec."Customer No."), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 10, FORMAT(Rec."Customer Name"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 11, FORMAT(Rec."Sales to Countries"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 12, FORMAT(Rec."Bill-to Customer No."), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 13, FORMAT(Rec."Bill-to Name"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 14, FORMAT(Rec."Ship-to Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 15, FORMAT(Rec."Ship-to Name"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 16, FORMAT(Rec."Ship-to Address"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 17, FORMAT(Rec."Ship-to City"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 18, FORMAT(Rec."Ship-to Post Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 19, FORMAT(Rec."Ship-to Country/Region Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 20, FORMAT(Rec."Posting Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 21, FORMAT(Rec."Order Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 22, FORMAT(Rec."Document Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 23, FORMAT(Rec."Transaction Type"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 24, FORMAT(Rec."Transaction Specification"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 25, FORMAT(Rec."Transport Method"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 26, FORMAT(Rec."Exit Point"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 27, FORMAT(Rec.Area), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 28, FORMAT(Rec.Type), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 29, FORMAT(Rec."Item No."), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 30, FORMAT(Rec."Item Description"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 31, FORMAT(Rec.Quantity), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 32, FORMAT(Rec."Unit of Measure Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 33, FORMAT(Rec."Unit of Measure"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 34, FORMAT(Rec."Reserved Quantity"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 35, FORMAT(Rec."Qty. to Ship"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 36, FORMAT(Rec."Qty. to Invoice"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 37, FORMAT(Rec."Quantity Shipped"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 38, FORMAT(Rec."Quantity Invoiced"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 39, FORMAT(Rec."Currency Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 40, FORMAT(Rec."Location Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 41, FORMAT(Rec."Unit Cost"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 42, FORMAT(Rec."Total Cost"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 43, FORMAT(Rec."Line Amount"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 44, FORMAT(Rec."Line Discount Amount"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 45, FORMAT(Rec."Line Discount %"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 46, FORMAT(Rec."Shipment Method Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 47, FORMAT(Rec."Shipping Agent Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 48, FORMAT(Rec."Payment Terms Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 49, FORMAT(Rec."Payment Method Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 50, FORMAT(Rec."Pre-paid/Collect"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 51, FORMAT(Rec."Due Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 52, FORMAT(Rec."Payment Discount %"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 53, FORMAT(Rec."Pmt. Discount Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 54, FORMAT(Rec."Gen. Bus. Posting Group"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 55, FORMAT(Rec."Gen. Prod. Posting Group"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 56, FORMAT(Rec."Customer Posting Group"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 57, FORMAT(Rec."VAT Bus. Posting Group"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 58, FORMAT(Rec."VAT Prod. Posting Group"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 59, FORMAT(Rec."Salesperson Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 60, FORMAT(Rec."Responsibility Center"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 61, FORMAT(Rec."Prepayment %"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 62, FORMAT(Rec."Compress Prepayment"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 63, FORMAT(Rec."Prepmt. Payment Terms Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 64, FORMAT(Rec."Prepayment Due Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 65, FORMAT(Rec."Prepmt. Payment Discount %"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 66, FORMAT(Rec."Prepmt. Pmt. Discount Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 67, FORMAT(Rec."Net Weight"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 68, FORMAT(Rec."Gross Weight"), FALSE, FALSE, FALSE, '');
                if Rec."Reason Code" <> '' then
                    EnterCell(RowNo, 69, FORMAT(Rec."Reason Code"), FALSE, FALSE, FALSE, '@');
                if Rec."Global Dimension 1 Code" <> '' then
                    EnterCell(RowNo, 70, FORMAT(Rec."Global Dimension 1 Code"), FALSE, FALSE, FALSE, '@');
                if Rec."Global Dimension 2 Code" <> '' then
                    EnterCell(RowNo, 71, FORMAT(Rec."Global Dimension 2 Code"), FALSE, FALSE, FALSE, '@');
                if Rec."Shortcut Dimension 3 Code" <> '' then
                    EnterCell(RowNo, 72, FORMAT(Rec."Shortcut Dimension 3 Code"), FALSE, FALSE, FALSE, '@');
                if Rec."Shortcut Dimension 4 Code" <> '' then
                    EnterCell(RowNo, 73, FORMAT(Rec."Shortcut Dimension 4 Code"), FALSE, FALSE, FALSE, '@');
                if Rec."Shortcut Dimension 5 Code" <> '' then
                    EnterCell(RowNo, 74, FORMAT(Rec."Shortcut Dimension 5 Code"), FALSE, FALSE, FALSE, '@');
                if Rec."Shortcut Dimension 6 Code" <> '' then
                    EnterCell(RowNo, 75, FORMAT(Rec."Shortcut Dimension 6 Code"), FALSE, FALSE, FALSE, '@');
                if Rec."Shortcut Dimension 7 Code" <> '' then
                    EnterCell(RowNo, 76, FORMAT(Rec."Shortcut Dimension 7 Code"), FALSE, FALSE, FALSE, '@');
                if Rec."Shortcut Dimension 8 Code" <> '' then
                    EnterCell(RowNo, 77, FORMAT(Rec."Shortcut Dimension 8 Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 78, FORMAT(Rec."Expected Delivery Date"), TRUE, FALSE, FALSE, '');
                EnterCell(RowNo, 79, FORMAT(Rec."Promised Delivery Date"), TRUE, FALSE, FALSE, '');
                if ShowTrackingInfo then begin
                    case Rec."Document Type" of
                        Rec."Document Type"::Quote,
                        Rec."Document Type"::Order,
                        Rec."Document Type"::Invoice,
                        Rec."Document Type"::"Credit Memo",
                        Rec."Document Type"::"Closed Order":
                            begin
                                if SalesLine.GET(Rec."Document Type", Rec."Document No.", Rec."Line No.") then begin
                                    if SalesLine.ReservEntryExist() then begin
                                        lrReservEntry.Reset();
                                        lrReservEntry.SetCurrentKey("Source Type", "Source Subtype", "Source ID", "Source Ref. No.");
                                        lrReservEntry.SetRange("Source Type", Database::"Sales Line");
                                        lrReservEntry.SetRange("Source Subtype", SalesLine."Document Type".AsInteger());
                                        lrReservEntry.SetRange("Source ID", SalesLine."Document No.");
                                        lrReservEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
                                        if lrReservEntry.FindSet() then
                                            repeat
                                                if (lrReservEntry."Serial No." <> '') OR (lrReservEntry."Lot No." <> '') then begin
                                                    RowNo += 1;
                                                    if lrReservEntry."Serial No." <> '' then
                                                        EnterCell(RowNo, 80, FORMAT(lrReservEntry."Serial No."), FALSE, FALSE, FALSE, '@');
                                                    if lrReservEntry."Lot No." <> '' then
                                                        EnterCell(RowNo, 81, FORMAT(lrReservEntry."Lot No."), FALSE, FALSE, FALSE, '@');
                                                    if lrReservEntry."Expiration Date" <> 0D then
                                                        EnterCell(RowNo, 82, FORMAT(lrReservEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                    ELSE begin
                                                        lrecItemLedgerEntry.RESET;
                                                        lrecItemLedgerEntry.SetRange("Item No.", lrReservEntry."Item No.");
                                                        lrecItemLedgerEntry.SetRange("Variant Code", lrReservEntry."Variant Code");
                                                        lrecItemLedgerEntry.SetRange("Lot No.", lrReservEntry."Lot No.");
                                                        lrecItemLedgerEntry.SetRange("Serial No.", lrReservEntry."Serial No.");
                                                        if lrecItemLedgerEntry.FINDFIRST then begin
                                                            if lrecItemLedgerEntry."Expiration Date" <> 0D then
                                                                EnterCell(RowNo, 82, FORMAT(lrecItemLedgerEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                        end;
                                                    end;
                                                    EnterCell(RowNo, 83, FORMAT(-lrReservEntry.Quantity), FALSE, FALSE, FALSE, '');
                                                end;
                                            UNTIL lrReservEntry.NEXT = 0;
                                    end;
                                    lresShipmentLine.RESET;
                                    lresShipmentLine.SETCURRENTKEY("Order No.", "Order Line No.");
                                    lresShipmentLine.SetRange("Order No.", Rec."Document No.");
                                    lresShipmentLine.SetRange("Order Line No.", Rec."Line No.");
                                    if lresShipmentLine.FindSet() then
                                        repeat
                                            CLEAR(TempItemLedgEntry);
                                            TempItemLedgEntry.DELETEALL;
                                            CLEAR(ItemTrackingMgmt);
                                            RetrieveILEFromShptRcpt(TempItemLedgEntry,
                                           DATABASE::"Sales Shipment Line", 0, lresShipmentLine."Document No.", '', 0, lresShipmentLine."Line No.");
                                            if TempItemLedgEntry.FindSet() then
                                                repeat
                                                    if (TempItemLedgEntry."Serial No." <> '') OR (TempItemLedgEntry."Lot No." <> '') then begin
                                                        RowNo += 1;
                                                        if TempItemLedgEntry."Serial No." <> '' then
                                                            EnterCell(RowNo, 80, FORMAT(TempItemLedgEntry."Serial No."), FALSE, FALSE, FALSE, '@');
                                                        if TempItemLedgEntry."Lot No." <> '' then
                                                            EnterCell(RowNo, 81, FORMAT(TempItemLedgEntry."Lot No."), FALSE, FALSE, FALSE, '@');
                                                        if TempItemLedgEntry."Expiration Date" <> 0D then
                                                            EnterCell(RowNo, 82, FORMAT(TempItemLedgEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                        ELSE begin
                                                            lrecItemLedgerEntry.RESET;
                                                            lrecItemLedgerEntry.SetRange("Item No.", TempItemLedgEntry."Item No.");
                                                            lrecItemLedgerEntry.SetRange("Variant Code", TempItemLedgEntry."Variant Code");
                                                            lrecItemLedgerEntry.SetRange("Lot No.", TempItemLedgEntry."Lot No.");
                                                            lrecItemLedgerEntry.SetRange("Serial No.", TempItemLedgEntry."Serial No.");
                                                            if lrecItemLedgerEntry.FINDFIRST then begin
                                                                if lrecItemLedgerEntry."Expiration Date" <> 0D then
                                                                    EnterCell(RowNo, 82, FORMAT(lrecItemLedgerEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                            end;
                                                        end;
                                                        EnterCell(RowNo, 83, FORMAT(TempItemLedgEntry.Quantity), FALSE, FALSE, FALSE, '');
                                                    end;
                                                UNTIL TempItemLedgEntry.NEXT = 0;
                                        UNTIL lresShipmentLine.NEXT = 0;
                                end;
                            end;
                        Rec."Document Type"::"Posted Invoice":
                            begin
                                if SalesInvLine.GET(Rec."Document No.", Rec."Line No.") then begin
                                    CLEAR(TempItemLedgEntry);
                                    TempItemLedgEntry.DELETEALL;
                                    CLEAR(ItemTrackingMgmt);
                                    RetrieveILEFromPostedInv(TempItemLedgEntry, SalesInvLine.RowID1);
                                    if TempItemLedgEntry.FindSet() then
                                        repeat
                                            if (TempItemLedgEntry."Serial No." <> '') OR (TempItemLedgEntry."Lot No." <> '') then begin
                                                RowNo += 1;
                                                if TempItemLedgEntry."Serial No." <> '' then
                                                    EnterCell(RowNo, 80, FORMAT(TempItemLedgEntry."Serial No."), FALSE, FALSE, FALSE, '@');
                                                if TempItemLedgEntry."Lot No." <> '' then
                                                    EnterCell(RowNo, 81, FORMAT(TempItemLedgEntry."Lot No."), FALSE, FALSE, FALSE, '@');
                                                if TempItemLedgEntry."Expiration Date" <> 0D then
                                                    EnterCell(RowNo, 82, FORMAT(TempItemLedgEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                ELSE begin
                                                    lrecItemLedgerEntry.RESET;
                                                    lrecItemLedgerEntry.SetRange("Item No.", TempItemLedgEntry."Item No.");
                                                    lrecItemLedgerEntry.SetRange("Variant Code", TempItemLedgEntry."Variant Code");
                                                    lrecItemLedgerEntry.SetRange("Lot No.", TempItemLedgEntry."Lot No.");
                                                    lrecItemLedgerEntry.SetRange("Serial No.", TempItemLedgEntry."Serial No.");
                                                    if lrecItemLedgerEntry.FINDFIRST then begin
                                                        if lrecItemLedgerEntry."Expiration Date" <> 0D then
                                                            EnterCell(RowNo, 82, FORMAT(lrecItemLedgerEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                    end;
                                                end;
                                                EnterCell(RowNo, 83, FORMAT(TempItemLedgEntry.Quantity), FALSE, FALSE, FALSE, '');
                                            end;
                                        UNTIL TempItemLedgEntry.NEXT = 0;
                                end;
                            end;
                        Rec."Document Type"::"Posted Credit Memo":
                            begin
                                if lrecSalesCrMemoLine.GET(Rec."Document No.", Rec."Line No.") then begin
                                    CLEAR(TempItemLedgEntry);
                                    TempItemLedgEntry.DELETEALL;
                                    CLEAR(ItemTrackingMgmt);
                                    RetrieveILEFromPostedInv(TempItemLedgEntry, lrecSalesCrMemoLine.RowID1);
                                    if TempItemLedgEntry.FindSet() then
                                        repeat
                                            if (TempItemLedgEntry."Serial No." <> '') OR (TempItemLedgEntry."Lot No." <> '') then begin
                                                RowNo += 1;
                                                if TempItemLedgEntry."Serial No." <> '' then
                                                    EnterCell(RowNo, 80, FORMAT(TempItemLedgEntry."Serial No."), FALSE, FALSE, FALSE, '@');
                                                if TempItemLedgEntry."Lot No." <> '' then
                                                    EnterCell(RowNo, 81, FORMAT(TempItemLedgEntry."Lot No."), FALSE, FALSE, FALSE, '@');
                                                if TempItemLedgEntry."Expiration Date" <> 0D then
                                                    EnterCell(RowNo, 82, FORMAT(TempItemLedgEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                ELSE begin
                                                    lrecItemLedgerEntry.RESET;
                                                    lrecItemLedgerEntry.SetRange("Item No.", TempItemLedgEntry."Item No.");
                                                    lrecItemLedgerEntry.SetRange("Variant Code", TempItemLedgEntry."Variant Code");
                                                    lrecItemLedgerEntry.SetRange("Lot No.", TempItemLedgEntry."Lot No.");
                                                    lrecItemLedgerEntry.SetRange("Serial No.", TempItemLedgEntry."Serial No.");
                                                    if lrecItemLedgerEntry.FINDFIRST then begin
                                                        if lrecItemLedgerEntry."Expiration Date" <> 0D then
                                                            EnterCell(RowNo, 82, FORMAT(lrecItemLedgerEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                    end;
                                                end;
                                                EnterCell(RowNo, 83, FORMAT(TempItemLedgEntry.Quantity), FALSE, FALSE, FALSE, '');
                                            end;
                                        UNTIL TempItemLedgEntry.NEXT = 0;
                                end;
                            end;
                    end;
                end;
            UNTIL Rec.NEXT = 0;

        this.TempExcelBuffer.WriteSheet('Sales Inquiry', CompanyName, UserId);
        this.TempExcelBuffer.CloseBook();
        this.TempExcelBuffer.SetFriendlyFilename(StrSubstNo('Sales Inquiry', CurrentDateTime, UserId));
        this.TempExcelBuffer.OpenExcel();
    end;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean; NumberFormat: Text[50]);
    begin
        TempExcelBuffer.Init();
        TempExcelBuffer.VALIDATE("Row No.", RowNo);
        TempExcelBuffer.VALIDATE("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.NumberFormat := NumberFormat;  //PBCJP-TRD-002-011
        TempExcelBuffer.INSERT;
    end;

    procedure RetrieveILEFromShptRcpt(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; Type: Integer; Subtype: Integer; ID: Code[20]; BatchName: Code[10]; ProdOrderLine: Integer; RefNo: Integer);
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ItemLedgEntry: Record "Item Ledger Entry";
        SignFactor: Integer;
    begin
        // retrieves a data set of Item Ledger Entries (Posted Shipments/Receipts)
        ItemEntryRelation.SetCurrentKey("Source ID", "Source Type");
        ItemEntryRelation.SetRange("Source Type", Type);
        ItemEntryRelation.SetRange("Source Subtype", Subtype);
        ItemEntryRelation.SetRange("Source ID", ID);
        ItemEntryRelation.SetRange("Source Batch Name", BatchName);
        ItemEntryRelation.SetRange("Source Prod. Order Line", ProdOrderLine);
        ItemEntryRelation.SetRange("Source Ref. No.", RefNo);
        if ItemEntryRelation.FindSet() then begin
            SignFactor := TableSignFactor(Type);
            Repeat
                ItemLedgEntry.Get(ItemEntryRelation."Item Entry No.");
                TempItemLedgEntry := ItemLedgEntry;
                AddTempRecordToSet(TempItemLedgEntry, SignFactor);
            until ItemEntryRelation.Next() = 0;
        end;
    end;

    procedure RetrieveILEFromPostedInv(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; InvoiceRowID: Text[250]);
    var
        ValueEntryRelation: Record "Value Entry Relation";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        SignFactor: Integer;
    begin
        // retrieves a data set of Item Ledger Entries (Posted Invoices)
        ValueEntryRelation.SetCurrentKey("Source RowId");
        ValueEntryRelation.SetRange("Source RowId", InvoiceRowID);
        if ValueEntryRelation.FindFirst() then begin
            SignFactor := TableSignFactor2(InvoiceRowID);
            Repeat
                ValueEntry.Get(ValueEntryRelation."Value Entry No.");
                ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.");
                TempItemLedgEntry := ItemLedgEntry;
                TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
                if TempItemLedgEntry.Quantity <> 0 then
                    AddTempRecordToSet(TempItemLedgEntry, SignFactor);
            until ValueEntryRelation.Next() = 0;
        end;
    end;

    local procedure TableSignFactor(TableNo: Integer): Integer;
    begin
        if TableNo IN [
                       Database::"Sales Line",
                       Database::"Sales Shipment Line",
                       Database::"Sales Invoice Line",
                       Database::"Purch. Cr. Memo Line",
                       Database::"Prod. Order Component",
                       Database::"Transfer Shipment Line",
                       Database::"Return Shipment Line",
                       Database::"Planning Component",
                       Database::"Service Line",
                       Database::"Service Shipment Line",
                       Database::"Service Invoice Line"]
        then
            exit(-1);
        exit(1);
    end;

    local procedure TableSignFactor2(RowID: Text[250]): Integer;
    var
        TableNo: Integer;
    begin
        RowID := DelChr(RowID, '<', '"');
        RowID := CopyStr(RowID, 1, StrPos(RowID, '"') - 1);
        if Evaluate(TableNo, RowID) then
            exit(TableSignFactor(TableNo));
        exit(1);
    end;

    local procedure AddTempRecordToSet(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; SignFactor: Integer);
    var
        TempItemLedgEntry2: Record "Item Ledger Entry" temporary;
    begin
        if SignFactor <> 1 then begin
            TempItemLedgEntry.Quantity *= SignFactor;
            TempItemLedgEntry."Remaining Quantity" *= SignFactor;
            TempItemLedgEntry."Invoiced Quantity" *= SignFactor;
        end;
        RetrieveAppliedExpDate(TempItemLedgEntry);
        TempItemLedgEntry2 := TempItemLedgEntry;
        TempItemLedgEntry.Reset();
        TempItemLedgEntry.SetRange("Serial No.", TempItemLedgEntry2."Serial No.");
        TempItemLedgEntry.SetRange("Lot No.", TempItemLedgEntry2."Lot No.");
        TempItemLedgEntry.SetRange("Warranty Date", TempItemLedgEntry2."Warranty Date");
        TempItemLedgEntry.SetRange("Expiration Date", TempItemLedgEntry2."Expiration Date");
        if TempItemLedgEntry.FindFirst() then begin
            TempItemLedgEntry.Quantity += TempItemLedgEntry2.Quantity;
            TempItemLedgEntry."Remaining Quantity" += TempItemLedgEntry2."Remaining Quantity";
            TempItemLedgEntry."Invoiced Quantity" += TempItemLedgEntry2."Invoiced Quantity";
            TempItemLedgEntry.Modify();
        end else begin
            TempItemLedgEntry.Insert();
        end;
        TempItemLedgEntry.Reset();
    end;

    procedure RetrieveAppliedExpDate(var TempItemLedgEntry: Record "Item Ledger Entry" temporary);
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemApplEntry: Record "Item Application Entry";
    begin
        if TempItemLedgEntry.Positive then
            exit;
        ItemApplEntry.Reset();
        ItemApplEntry.SetCurrentKey("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
        ItemApplEntry.SetRange("Outbound Item Entry No.", TempItemLedgEntry."Entry No.");
        ItemApplEntry.SetRange("Item Ledger Entry No.", TempItemLedgEntry."Entry No.");
        if ItemApplEntry.FindFirst() then begin
            ItemLedgEntry.Get(ItemApplEntry."Inbound Item Entry No.");
            TempItemLedgEntry."Expiration Date" := ItemLedgEntry."Expiration Date";
        end;
    end;
}