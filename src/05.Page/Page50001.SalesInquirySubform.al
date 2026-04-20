page 50001 "Sales Inquiry Subform"
{
    ApplicationArea = All;
    Caption = 'Line';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PaGetype = ListPart;
    SourceTable = "Sales Inquiry Line";
    SourceTableTemporary = true;
    Permissions = tabledata "Item Ledger Entry" = D;
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
                field("Line No."; Rec."Line No.") { }
                field("Customer PO No."; Rec."Customer PO No.") { }
                field("Requested Delivery Date"; Rec."Requested Delivery Date") { }
                field("Planned Delivery Date"; Rec."Planned Delivery Date") { }
                field("Planned Shipment Date"; Rec."Planned Shipment Date") { }
                field("Shipment Date"; Rec."Shipment Date") { }
                field("Customer No."; Rec."Customer No.") { }
                field("Customer Name"; Rec."Customer Name") { }
                field("Sales to Countries"; Rec."Sales to Countries") { }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.") { }
                field("Bill-to Name"; Rec."Bill-to Name") { }
                field("Ship-to Code"; Rec."Ship-to Code") { }
                field("Ship-to Name"; Rec."Ship-to Name") { }
                field("Ship-to Address"; Rec."Ship-to Address") { }
                field("Ship-to City"; Rec."Ship-to City") { }
                field("Ship-to Post Code"; Rec."Ship-to Post Code") { }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Order Date"; Rec."Order Date") { }
                field("Document Date"; Rec."Document Date") { }
                field("Transaction Type"; Rec."Transaction Type") { }
                field("Transaction Specification"; Rec."Transaction Specification") { }
                field("Transport Method"; Rec."Transport Method") { }
                field("Exit Point"; Rec."Exit Point") { }
                field(RecArea; Rec.Area) { }
                field(Type; Rec.Type) { }
                field("Item No."; Rec."Item No.") { }
                field("Item Description"; Rec."Item Description") { }
                field(Quantity; Rec.Quantity) { }
                field("Unit of Measure Code"; Rec."Unit of Measure Code") { }
                field("Unit of Measure"; Rec."Unit of Measure") { }
                field("Reserved Quantity"; Rec."Reserved Quantity") { }
                field("Qty. to Ship"; Rec."Qty. to Ship") { }
                field("Qty. to Invoice"; Rec."Qty. to Invoice") { }
                field("Quantity Shipped"; Rec."Quantity Shipped") { }
                field("Quantity Invoiced"; Rec."Quantity Invoiced") { }
                field("Currency Code"; Rec."Currency Code") { }
                field("Location Code"; Rec."Location Code") { }
                field("Unit Cost"; Rec."Unit Cost") { BlankZero = true; }
                field("Total Cost"; Rec."Total Cost") { BlankZero = true; }
                field("Line Amount"; Rec."Line Amount") { BlankZero = true; }
                field("Line Discount Amount"; Rec."Line Discount Amount") { }
                field("Line Discount %"; Rec."Line Discount %") { BlankZero = true; }
                field("Shipment Method Code"; Rec."Shipment Method Code") { }
                field("Shipping Agent Code"; Rec."Shipping Agent Code") { }
                field("Payment Terms Code"; Rec."Payment Terms Code") { }
                field("Payment Method Code"; Rec."Payment Method Code") { }
                field("Due Date"; Rec."Due Date") { }
                field("Compress Prepayment"; Rec."Compress Prepayment") { }
                field("Payment Discount %"; Rec."Payment Discount %") { BlankZero = true; }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date") { }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group") { }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group") { }
                field("Customer Posting Group"; Rec."Customer Posting Group") { }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group") { }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group") { }
                field("Salesperson Code"; Rec."Salesperson Code") { }
                field("Responsibility Center"; Rec."Responsibility Center") { }
                field("Prepayment %"; Rec."Prepayment %") { }
                field("Prepmt. Payment Terms Code"; Rec."Prepmt. Payment Terms Code") { }
                field("Prepayment Due Date"; Rec."Prepayment Due Date") { }
                field("Prepmt. Payment Discount %"; Rec."Prepmt. Payment Discount %") { }
                field("Prepmt. Pmt. Discount Date"; Rec."Prepmt. Pmt. Discount Date") { }
                field("Net Weight"; Rec."Net Weight") { }
                field("Gross Weight"; Rec."Gross Weight") { }
                field("Reason Code"; Rec."Reason Code") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code") { }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code") { }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code") { }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code") { }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code") { }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code") { }
                field("Promised Delivery Date"; Rec."Promised Delivery Date") { }
            }
        }
    }
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
                            SalesLine.CalcFields("Reserved Quantity");
                            Rec."Reserved Quantity" := SalesLine."Reserved Quantity";
                            Rec."Promised Delivery Date" := SalesLine."Promised Delivery Date";
                            Rec."Original Order No." := SalesHdr."No.";
                            Rec.TotalQty := Rec.Quantity;
                            Rec.TotalAmount := Rec."Line Amount";
                            Rec.TotalAmountInclVAT := Rec."Line Amount" * (1 + SalesLine."VAT %" / 100);
                            if Rec."Currency Code" <> '' then begin
                                Rec.TotalAmount :=
                                  Round(
                                    CurrExchRate.ExchangeAmtFCYToLCY(
                                      GetDate(Rec."Posting Date"), Rec."Currency Code", Rec.TotalAmount,
                                      SalesHdr."Currency Factor"),
                                    GLSetup."Amount Rounding Precision");
                                Rec.TotalAmountInclVAT :=
                                  Round(
                                    CurrExchRate.ExchangeAmtFCYToLCY(
                                      GetDate(Rec."Posting Date"), Rec."Currency Code", Rec.TotalAmountInclVAT,
                                      SalesHdr."Currency Factor"),
                                    GLSetup."Amount Rounding Precision");
                            end;
                            decTotalQty += Rec.TotalQty;
                            decTotalAmount += Rec.TotalAmount;
                            decTotalAmountInclVAT += Rec.TotalAmountInclVAT;
                            Rec.Insert();
                        until SalesLine.Next() = 0;
                until SalesHdr.Next() = 0;
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
                                    Round(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                          Rec."Currency Code", Rec.TotalAmount, SalesInvHdr."Currency Factor"),
                                          GLSetup."Amount Rounding Precision");
                                Rec.TotalAmountInclVAT :=
                                    Round(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                          Rec."Currency Code", Rec.TotalAmountInclVAT, SalesInvHdr."Currency Factor"),
                                          GLSetup."Amount Rounding Precision");
                            end;
                            decTotalQty += Rec.TotalQty;
                            decTotalAmount += Rec.TotalAmount;
                            decTotalAmountInclVAT += Rec.TotalAmountInclVAT;
                            Rec.Insert();
                        until SalesInvLine.Next() = 0;
                until SalesInvHdr.Next() = 0;
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
                                    Round(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                          Rec."Currency Code", Rec.TotalAmount, SalesCrMemoHdr."Currency Factor"),
                                          GLSetup."Amount Rounding Precision");
                                Rec.TotalAmountInclVAT :=
                                    Round(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                          Rec."Currency Code", Rec.TotalAmountInclVAT, SalesCrMemoHdr."Currency Factor"),
                                          GLSetup."Amount Rounding Precision");
                            end;
                            decTotalQty += Rec.TotalQty;
                            decTotalAmount += Rec.TotalAmount;
                            decTotalAmountInclVAT += Rec.TotalAmountInclVAT;
                            Rec.Insert();
                        until SalesCrMemoLine.Next() = 0;
                until SalesCrMemoHdr.Next() = 0;
        end;
    end;

    local procedure GetDate(RecDate: Date): Date;
    begin
        if RecDate <> 0D then
            exit(RecDate)
        ELSE
            exit(WorkDate());
    end;

    procedure ExportDataToExcel(ShowTrackingInfo: Boolean);
    var
        RowNo: Integer;
        SalesLine: Record "Sales Line";
        ShipmentLine: Record "Sales Shipment Line";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        ReservEntry: Record "Reservation Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveSalesOrderLine: Codeunit "Sales Line-Reserve";
        ItemTrackingMgmt: Codeunit "Item Tracking Management";
        decRemainingQty: Decimal;
    begin
        TempExcelBuffer.DeleteAll();
        Clear(TempExcelBuffer);

        RowNo := 1;
        TempExcelBuffer.CreateNewBook('Sales Inquiry');
        EnterCell(RowNo, 1, Rec.FieldCaption("Document Type"), true, false, false, '@');
        EnterCell(RowNo, 2, Rec.FieldCaption("Document No."), true, false, false, '@');
        EnterCell(RowNo, 3, Rec.FieldCaption("Line No."), true, false, false, '@');
        EnterCell(RowNo, 4, Rec.FieldCaption("Customer PO No."), true, false, false, '@');
        EnterCell(RowNo, 5, Rec.FieldCaption("Requested Delivery Date"), true, false, false, '@');
        EnterCell(RowNo, 6, Rec.FieldCaption("Planned Delivery Date"), true, false, false, '@');
        EnterCell(RowNo, 7, Rec.FieldCaption("Planned Shipment Date"), true, false, false, '@');
        EnterCell(RowNo, 8, Rec.FieldCaption("Shipment Date"), true, false, false, '@');
        EnterCell(RowNo, 9, Rec.FieldCaption("Customer No."), true, false, false, '@');
        EnterCell(RowNo, 10, Rec.FieldCaption("Customer Name"), true, false, false, '@');
        EnterCell(RowNo, 11, Rec.FieldCaption("Sales to Countries"), true, false, false, '@');
        EnterCell(RowNo, 12, Rec.FieldCaption("Bill-to Customer No."), true, false, false, '@');
        EnterCell(RowNo, 13, Rec.FieldCaption("Bill-to Name"), true, false, false, '@');
        EnterCell(RowNo, 14, Rec.FieldCaption("Ship-to Code"), true, false, false, '@');
        EnterCell(RowNo, 15, Rec.FieldCaption("Ship-to Name"), true, false, false, '@');
        EnterCell(RowNo, 16, Rec.FieldCaption("Ship-to Address"), true, false, false, '@');
        EnterCell(RowNo, 17, Rec.FieldCaption("Ship-to City"), true, false, false, '@');
        EnterCell(RowNo, 18, Rec.FieldCaption("Ship-to Post Code"), true, false, false, '@');
        EnterCell(RowNo, 19, Rec.FieldCaption("Ship-to Country/Region Code"), true, false, false, '@');
        EnterCell(RowNo, 20, Rec.FieldCaption("Posting Date"), true, false, false, '@');
        EnterCell(RowNo, 21, Rec.FieldCaption("Order Date"), true, false, false, '@');
        EnterCell(RowNo, 22, Rec.FieldCaption("Document Date"), true, false, false, '@');
        EnterCell(RowNo, 23, Rec.FieldCaption("Transaction Type"), true, false, false, '@');
        EnterCell(RowNo, 24, Rec.FieldCaption("Transaction Specification"), true, false, false, '@');
        EnterCell(RowNo, 25, Rec.FieldCaption("Transport Method"), true, false, false, '@');
        EnterCell(RowNo, 26, Rec.FieldCaption("Exit Point"), true, false, false, '@');
        EnterCell(RowNo, 27, Rec.FieldCaption(Area), true, false, false, '@');
        EnterCell(RowNo, 28, Rec.FieldCaption(Type), true, false, false, '@');
        EnterCell(RowNo, 29, Rec.FieldCaption("Item No."), true, false, false, '@');
        EnterCell(RowNo, 30, Rec.FieldCaption("Item Description"), true, false, false, '@');
        EnterCell(RowNo, 31, Rec.FieldCaption(Quantity), true, false, false, '@');
        EnterCell(RowNo, 32, Rec.FieldCaption("Unit of Measure Code"), true, false, false, '@');
        EnterCell(RowNo, 33, Rec.FieldCaption("Unit of Measure"), true, false, false, '@');
        EnterCell(RowNo, 34, Rec.FieldCaption("Reserved Quantity"), true, false, false, '@');
        EnterCell(RowNo, 35, Rec.FieldCaption("Qty. to Ship"), true, false, false, '@');
        EnterCell(RowNo, 36, Rec.FieldCaption("Qty. to Invoice"), true, false, false, '@');
        EnterCell(RowNo, 37, Rec.FieldCaption("Quantity Shipped"), true, false, false, '@');
        EnterCell(RowNo, 38, Rec.FieldCaption("Quantity Invoiced"), true, false, false, '@');
        EnterCell(RowNo, 39, Rec.FieldCaption("Currency Code"), true, false, false, '@');
        EnterCell(RowNo, 40, Rec.FieldCaption("Location Code"), true, false, false, '@');
        EnterCell(RowNo, 41, Rec.FieldCaption("Unit Cost"), true, false, false, '@');
        EnterCell(RowNo, 42, Rec.FieldCaption("Total Cost"), true, false, false, '@');
        EnterCell(RowNo, 43, Rec.FieldCaption("Line Amount"), true, false, false, '@');
        EnterCell(RowNo, 44, Rec.FieldCaption("Line Discount Amount"), true, false, false, '@');
        EnterCell(RowNo, 45, Rec.FieldCaption("Line Discount %"), true, false, false, '@');
        EnterCell(RowNo, 46, Rec.FieldCaption("Shipment Method Code"), true, false, false, '@');
        EnterCell(RowNo, 47, Rec.FieldCaption("Shipping Agent Code"), true, false, false, '@');
        EnterCell(RowNo, 48, Rec.FieldCaption("Payment Terms Code"), true, false, false, '@');
        EnterCell(RowNo, 49, Rec.FieldCaption("Payment Method Code"), true, false, false, '@');
        EnterCell(RowNo, 50, Rec.FieldCaption("Due Date"), true, false, false, '@');
        EnterCell(RowNo, 51, Rec.FieldCaption("Payment Discount %"), true, false, false, '@');
        EnterCell(RowNo, 52, Rec.FieldCaption("Pmt. Discount Date"), true, false, false, '@');
        EnterCell(RowNo, 53, Rec.FieldCaption("Gen. Bus. Posting Group"), true, false, false, '@');
        EnterCell(RowNo, 54, Rec.FieldCaption("Gen. Prod. Posting Group"), true, false, false, '@');
        EnterCell(RowNo, 55, Rec.FieldCaption("Customer Posting Group"), true, false, false, '@');
        EnterCell(RowNo, 56, Rec.FieldCaption("VAT Bus. Posting Group"), true, false, false, '@');
        EnterCell(RowNo, 57, Rec.FieldCaption("VAT Prod. Posting Group"), true, false, false, '@');
        EnterCell(RowNo, 58, Rec.FieldCaption("Salesperson Code"), true, false, false, '@');
        EnterCell(RowNo, 59, Rec.FieldCaption("Responsibility Center"), true, false, false, '@');
        EnterCell(RowNo, 60, Rec.FieldCaption("Prepayment %"), true, false, false, '@');
        EnterCell(RowNo, 61, Rec.FieldCaption("Compress Prepayment"), true, false, false, '@');
        EnterCell(RowNo, 62, Rec.FieldCaption("Prepmt. Payment Terms Code"), true, false, false, '@');
        EnterCell(RowNo, 63, Rec.FieldCaption("Prepayment Due Date"), true, false, false, '@');
        EnterCell(RowNo, 64, Rec.FieldCaption("Prepmt. Payment Discount %"), true, false, false, '@');
        EnterCell(RowNo, 65, Rec.FieldCaption("Prepmt. Pmt. Discount Date"), true, false, false, '@');
        EnterCell(RowNo, 66, Rec.FieldCaption("Net Weight"), true, false, false, '@');
        EnterCell(RowNo, 67, Rec.FieldCaption("Gross Weight"), true, false, false, '@');
        EnterCell(RowNo, 68, Rec.FieldCaption("Reason Code"), true, false, false, '@');
        EnterCell(RowNo, 69, Rec.FieldCaption("Global Dimension 1 Code"), true, false, false, '@');
        EnterCell(RowNo, 70, Rec.FieldCaption("Global Dimension 2 Code"), true, false, false, '@');
        EnterCell(RowNo, 71, Rec.FieldCaption("Shortcut Dimension 3 Code"), true, false, false, '@');
        EnterCell(RowNo, 72, Rec.FieldCaption("Shortcut Dimension 4 Code"), true, false, false, '@');
        EnterCell(RowNo, 73, Rec.FieldCaption("Shortcut Dimension 5 Code"), true, false, false, '@');
        EnterCell(RowNo, 74, Rec.FieldCaption("Shortcut Dimension 6 Code"), true, false, false, '@');
        EnterCell(RowNo, 75, Rec.FieldCaption("Shortcut Dimension 7 Code"), true, false, false, '@');
        EnterCell(RowNo, 76, Rec.FieldCaption("Shortcut Dimension 8 Code"), true, false, false, '@');
        EnterCell(RowNo, 77, Rec.FieldCaption("Promised Delivery Date"), true, false, false, '@');
        EnterCell(RowNo, 78, Rec.FieldCaption("Original Order No."), true, false, false, '@');
        EnterCell(RowNo, 79, Rec.FieldCaption("Order Status"), true, false, false, '@');
        if ShowTrackingInfo then begin
            EnterCell(RowNo, 80, ReservEntry.FieldCaption("Serial No."), true, false, false, '@');
            EnterCell(RowNo, 81, ReservEntry.FieldCaption("Lot No."), true, false, false, '@');
            EnterCell(RowNo, 82, ReservEntry.FieldCaption("Expiration Date"), true, false, false, '@');
            EnterCell(RowNo, 83, ReservEntry.FieldCaption(Quantity), true, false, false, '@');
        end;

        if Rec.FindSet() then
            repeat
                RowNo += 1;
                EnterCell(RowNo, 1, Format(Rec."Document Type"), false, false, false, '@');
                EnterCell(RowNo, 2, Format(Rec."Document No."), false, false, false, '@');
                EnterCell(RowNo, 3, Format(Rec."Line No."), false, false, false, '');
                if Rec."Customer PO No." <> '' then
                    EnterCell(RowNo, 4, Format(Rec."Customer PO No."), false, false, false, '@');
                if Rec."Requested Delivery Date" <> 0D then
                    EnterCell(RowNo, 5, Format(Rec."Requested Delivery Date"), false, false, false, '');
                if Rec."Planned Delivery Date" <> 0D then
                    EnterCell(RowNo, 6, Format(Rec."Planned Delivery Date"), false, false, false, '');
                if Rec."Planned Shipment Date" <> 0D then
                    EnterCell(RowNo, 7, Format(Rec."Planned Shipment Date"), false, false, false, '');
                if Rec."Shipment Date" <> 0D then
                    EnterCell(RowNo, 8, Format(Rec."Shipment Date"), false, false, false, '');
                EnterCell(RowNo, 9, Format(Rec."Customer No."), false, false, false, '@');
                EnterCell(RowNo, 10, Format(Rec."Customer Name"), false, false, false, '@');
                EnterCell(RowNo, 11, Format(Rec."Sales to Countries"), false, false, false, '@');
                EnterCell(RowNo, 12, Format(Rec."Bill-to Customer No."), false, false, false, '@');
                EnterCell(RowNo, 13, Format(Rec."Bill-to Name"), false, false, false, '@');
                EnterCell(RowNo, 14, Format(Rec."Ship-to Code"), false, false, false, '@');
                EnterCell(RowNo, 15, Format(Rec."Ship-to Name"), false, false, false, '@');
                EnterCell(RowNo, 16, Format(Rec."Ship-to Address"), false, false, false, '@');
                EnterCell(RowNo, 17, Format(Rec."Ship-to City"), false, false, false, '@');
                EnterCell(RowNo, 18, Format(Rec."Ship-to Post Code"), false, false, false, '@');
                EnterCell(RowNo, 19, Format(Rec."Ship-to Country/Region Code"), false, false, false, '@');
                EnterCell(RowNo, 20, Format(Rec."Posting Date"), false, false, false, '');
                EnterCell(RowNo, 21, Format(Rec."Order Date"), false, false, false, '');
                EnterCell(RowNo, 22, Format(Rec."Document Date"), false, false, false, '');
                EnterCell(RowNo, 23, Format(Rec."Transaction Type"), false, false, false, '@');
                EnterCell(RowNo, 24, Format(Rec."Transaction Specification"), false, false, false, '@');
                EnterCell(RowNo, 25, Format(Rec."Transport Method"), false, false, false, '@');
                EnterCell(RowNo, 26, Format(Rec."Exit Point"), false, false, false, '@');
                EnterCell(RowNo, 27, Format(Rec.Area), false, false, false, '@');
                EnterCell(RowNo, 28, Format(Rec.Type), false, false, false, '@');
                EnterCell(RowNo, 29, Format(Rec."Item No."), false, false, false, '@');
                EnterCell(RowNo, 30, Format(Rec."Item Description"), false, false, false, '');
                EnterCell(RowNo, 31, Format(Rec.Quantity), false, false, false, '');
                EnterCell(RowNo, 32, Format(Rec."Unit of Measure Code"), false, false, false, '@');
                EnterCell(RowNo, 33, Format(Rec."Unit of Measure"), false, false, false, '@');
                EnterCell(RowNo, 34, Format(Rec."Reserved Quantity"), false, false, false, '');
                EnterCell(RowNo, 35, Format(Rec."Qty. to Ship"), false, false, false, '');
                EnterCell(RowNo, 36, Format(Rec."Qty. to Invoice"), false, false, false, '');
                EnterCell(RowNo, 37, Format(Rec."Quantity Shipped"), false, false, false, '');
                EnterCell(RowNo, 38, Format(Rec."Quantity Invoiced"), false, false, false, '');
                EnterCell(RowNo, 39, Format(Rec."Currency Code"), false, false, false, '@');
                EnterCell(RowNo, 40, Format(Rec."Location Code"), false, false, false, '@');
                EnterCell(RowNo, 41, Format(Rec."Unit Cost"), false, false, false, '');
                EnterCell(RowNo, 42, Format(Rec."Total Cost"), false, false, false, '');
                EnterCell(RowNo, 43, Format(Rec."Line Amount"), false, false, false, '');
                EnterCell(RowNo, 44, Format(Rec."Line Discount Amount"), false, false, false, '');
                EnterCell(RowNo, 45, Format(Rec."Line Discount %"), false, false, false, '');
                EnterCell(RowNo, 46, Format(Rec."Shipment Method Code"), false, false, false, '@');
                EnterCell(RowNo, 47, Format(Rec."Shipping Agent Code"), false, false, false, '@');
                EnterCell(RowNo, 48, Format(Rec."Payment Terms Code"), false, false, false, '@');
                EnterCell(RowNo, 49, Format(Rec."Payment Method Code"), false, false, false, '@');
                EnterCell(RowNo, 50, Format(Rec."Due Date"), false, false, false, '');
                EnterCell(RowNo, 51, Format(Rec."Payment Discount %"), false, false, false, '');
                EnterCell(RowNo, 52, Format(Rec."Pmt. Discount Date"), false, false, false, '');
                EnterCell(RowNo, 53, Format(Rec."Gen. Bus. Posting Group"), false, false, false, '@');
                EnterCell(RowNo, 54, Format(Rec."Gen. Prod. Posting Group"), false, false, false, '@');
                EnterCell(RowNo, 55, Format(Rec."Customer Posting Group"), false, false, false, '@');
                EnterCell(RowNo, 56, Format(Rec."VAT Bus. Posting Group"), false, false, false, '@');
                EnterCell(RowNo, 57, Format(Rec."VAT Prod. Posting Group"), false, false, false, '@');
                EnterCell(RowNo, 58, Format(Rec."Salesperson Code"), false, false, false, '@');
                EnterCell(RowNo, 59, Format(Rec."Responsibility Center"), false, false, false, '@');
                EnterCell(RowNo, 60, Format(Rec."Prepayment %"), false, false, false, '');
                EnterCell(RowNo, 61, Format(Rec."Compress Prepayment"), false, false, false, '');
                EnterCell(RowNo, 62, Format(Rec."Prepmt. Payment Terms Code"), false, false, false, '@');
                EnterCell(RowNo, 63, Format(Rec."Prepayment Due Date"), false, false, false, '');
                EnterCell(RowNo, 64, Format(Rec."Prepmt. Payment Discount %"), false, false, false, '');
                EnterCell(RowNo, 65, Format(Rec."Prepmt. Pmt. Discount Date"), false, false, false, '');
                EnterCell(RowNo, 66, Format(Rec."Net Weight"), false, false, false, '');
                EnterCell(RowNo, 67, Format(Rec."Gross Weight"), false, false, false, '');
                if Rec."Reason Code" <> '' then
                    EnterCell(RowNo, 68, Format(Rec."Reason Code"), false, false, false, '@');
                if Rec."Global Dimension 1 Code" <> '' then
                    EnterCell(RowNo, 69, Format(Rec."Global Dimension 1 Code"), false, false, false, '@');
                if Rec."Global Dimension 2 Code" <> '' then
                    EnterCell(RowNo, 70, Format(Rec."Global Dimension 2 Code"), false, false, false, '@');
                if Rec."Shortcut Dimension 3 Code" <> '' then
                    EnterCell(RowNo, 71, Format(Rec."Shortcut Dimension 3 Code"), false, false, false, '@');
                if Rec."Shortcut Dimension 4 Code" <> '' then
                    EnterCell(RowNo, 72, Format(Rec."Shortcut Dimension 4 Code"), false, false, false, '@');
                if Rec."Shortcut Dimension 5 Code" <> '' then
                    EnterCell(RowNo, 73, Format(Rec."Shortcut Dimension 5 Code"), false, false, false, '@');
                if Rec."Shortcut Dimension 6 Code" <> '' then
                    EnterCell(RowNo, 74, Format(Rec."Shortcut Dimension 6 Code"), false, false, false, '@');
                if Rec."Shortcut Dimension 7 Code" <> '' then
                    EnterCell(RowNo, 75, Format(Rec."Shortcut Dimension 7 Code"), false, false, false, '@');
                if Rec."Shortcut Dimension 8 Code" <> '' then
                    EnterCell(RowNo, 76, Format(Rec."Shortcut Dimension 8 Code"), false, false, false, '@');
                EnterCell(RowNo, 77, Format(Rec."Promised Delivery Date"), true, false, false, '');
                EnterCell(RowNo, 78, Format(Rec."Original Order No."), true, false, false, '');
                EnterCell(RowNo, 79, Format(Rec."Order Status"), true, false, false, '');
                if ShowTrackingInfo then begin
                    case Rec."Document Type" of
                        Rec."Document Type"::Quote,
                        Rec."Document Type"::Order,
                        Rec."Document Type"::Invoice,
                        Rec."Document Type"::"Credit Memo",
                        Rec."Document Type"::"Closed Order":
                            begin
                                if SalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.") then begin
                                    if SalesLine.ReservEntryExist() then begin
                                        ReservEntry.Reset();
                                        ReservEntry.SetCurrentKey("Source Type", "Source Subtype", "Source ID", "Source Ref. No.");
                                        ReservEntry.SetRange("Source Type", Database::"Sales Line");
                                        ReservEntry.SetRange("Source Subtype", SalesLine."Document Type".AsInteger());
                                        ReservEntry.SetRange("Source ID", SalesLine."Document No.");
                                        ReservEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
                                        if ReservEntry.FindSet() then
                                            repeat
                                                if (ReservEntry."Serial No." <> '') OR (ReservEntry."Lot No." <> '') then begin
                                                    RowNo += 1;
                                                    if ReservEntry."Serial No." <> '' then
                                                        EnterCell(RowNo, 80, Format(ReservEntry."Serial No."), false, false, false, '@');
                                                    if ReservEntry."Lot No." <> '' then
                                                        EnterCell(RowNo, 81, Format(ReservEntry."Lot No."), false, false, false, '@');
                                                    if ReservEntry."Expiration Date" <> 0D then
                                                        EnterCell(RowNo, 82, Format(ReservEntry."Expiration Date"), false, false, false, '')
                                                    ELSE begin
                                                        ItemLedgerEntry.Reset();
                                                        ItemLedgerEntry.SetRange("Item No.", ReservEntry."Item No.");
                                                        ItemLedgerEntry.SetRange("Variant Code", ReservEntry."Variant Code");
                                                        ItemLedgerEntry.SetRange("Lot No.", ReservEntry."Lot No.");
                                                        ItemLedgerEntry.SetRange("Serial No.", ReservEntry."Serial No.");
                                                        if ItemLedgerEntry.FindFirst() then begin
                                                            if ItemLedgerEntry."Expiration Date" <> 0D then
                                                                EnterCell(RowNo, 82, Format(ItemLedgerEntry."Expiration Date"), false, false, false, '')
                                                        end;
                                                    end;
                                                    EnterCell(RowNo, 83, Format(-ReservEntry.Quantity), false, false, false, '');
                                                end;
                                            until ReservEntry.Next() = 0;
                                    end;
                                    ShipmentLine.Reset();
                                    ShipmentLine.SetCurrentKey("Order No.", "Order Line No.");
                                    ShipmentLine.SetRange("Order No.", Rec."Document No.");
                                    ShipmentLine.SetRange("Order Line No.", Rec."Line No.");
                                    if ShipmentLine.FindSet() then
                                        repeat
                                            Clear(TempItemLedgEntry);
                                            TempItemLedgEntry.DeleteAll();
                                            Clear(ItemTrackingMgmt);
                                            RetrieveILEFromShptRcpt(TempItemLedgEntry,
                                           DATABASE::"Sales Shipment Line", 0, ShipmentLine."Document No.", '', 0, ShipmentLine."Line No.");
                                            if TempItemLedgEntry.FindSet() then
                                                repeat
                                                    if (TempItemLedgEntry."Serial No." <> '') OR (TempItemLedgEntry."Lot No." <> '') then begin
                                                        RowNo += 1;
                                                        if TempItemLedgEntry."Serial No." <> '' then
                                                            EnterCell(RowNo, 80, Format(TempItemLedgEntry."Serial No."), false, false, false, '@');
                                                        if TempItemLedgEntry."Lot No." <> '' then
                                                            EnterCell(RowNo, 81, Format(TempItemLedgEntry."Lot No."), false, false, false, '@');
                                                        if TempItemLedgEntry."Expiration Date" <> 0D then
                                                            EnterCell(RowNo, 82, Format(TempItemLedgEntry."Expiration Date"), false, false, false, '')
                                                        ELSE begin
                                                            ItemLedgerEntry.Reset();
                                                            ItemLedgerEntry.SetRange("Item No.", TempItemLedgEntry."Item No.");
                                                            ItemLedgerEntry.SetRange("Variant Code", TempItemLedgEntry."Variant Code");
                                                            ItemLedgerEntry.SetRange("Lot No.", TempItemLedgEntry."Lot No.");
                                                            ItemLedgerEntry.SetRange("Serial No.", TempItemLedgEntry."Serial No.");
                                                            if ItemLedgerEntry.FindFirst() then begin
                                                                if ItemLedgerEntry."Expiration Date" <> 0D then
                                                                    EnterCell(RowNo, 82, Format(ItemLedgerEntry."Expiration Date"), false, false, false, '')
                                                            end;
                                                        end;
                                                        EnterCell(RowNo, 83, Format(TempItemLedgEntry.Quantity), false, false, false, '');
                                                    end;
                                                until TempItemLedgEntry.Next() = 0;
                                        until ShipmentLine.Next() = 0;
                                end;
                            end;
                        Rec."Document Type"::"Posted Invoice":
                            begin
                                if SalesInvLine.Get(Rec."Document No.", Rec."Line No.") then begin
                                    Clear(TempItemLedgEntry);
                                    TempItemLedgEntry.DeleteAll();
                                    Clear(ItemTrackingMgmt);
                                    RetrieveILEFromPostedInv(TempItemLedgEntry, SalesInvLine.RowID1);
                                    if TempItemLedgEntry.FindSet() then
                                        repeat
                                            if (TempItemLedgEntry."Serial No." <> '') OR (TempItemLedgEntry."Lot No." <> '') then begin
                                                RowNo += 1;
                                                if TempItemLedgEntry."Serial No." <> '' then
                                                    EnterCell(RowNo, 80, Format(TempItemLedgEntry."Serial No."), false, false, false, '@');
                                                if TempItemLedgEntry."Lot No." <> '' then
                                                    EnterCell(RowNo, 81, Format(TempItemLedgEntry."Lot No."), false, false, false, '@');
                                                if TempItemLedgEntry."Expiration Date" <> 0D then
                                                    EnterCell(RowNo, 82, Format(TempItemLedgEntry."Expiration Date"), false, false, false, '')
                                                ELSE begin
                                                    ItemLedgerEntry.Reset();
                                                    ItemLedgerEntry.SetRange("Item No.", TempItemLedgEntry."Item No.");
                                                    ItemLedgerEntry.SetRange("Variant Code", TempItemLedgEntry."Variant Code");
                                                    ItemLedgerEntry.SetRange("Lot No.", TempItemLedgEntry."Lot No.");
                                                    ItemLedgerEntry.SetRange("Serial No.", TempItemLedgEntry."Serial No.");
                                                    if ItemLedgerEntry.FindFirst() then begin
                                                        if ItemLedgerEntry."Expiration Date" <> 0D then
                                                            EnterCell(RowNo, 82, Format(ItemLedgerEntry."Expiration Date"), false, false, false, '')
                                                    end;
                                                end;
                                                EnterCell(RowNo, 83, Format(TempItemLedgEntry.Quantity), false, false, false, '');
                                            end;
                                        until TempItemLedgEntry.Next() = 0;
                                end;
                            end;
                        Rec."Document Type"::"Posted Credit Memo":
                            begin
                                if SalesCrMemoLine.Get(Rec."Document No.", Rec."Line No.") then begin
                                    Clear(TempItemLedgEntry);
                                    TempItemLedgEntry.DeleteAll();
                                    Clear(ItemTrackingMgmt);
                                    RetrieveILEFromPostedInv(TempItemLedgEntry, SalesCrMemoLine.RowID1);
                                    if TempItemLedgEntry.FindSet() then
                                        repeat
                                            if (TempItemLedgEntry."Serial No." <> '') OR (TempItemLedgEntry."Lot No." <> '') then begin
                                                RowNo += 1;
                                                if TempItemLedgEntry."Serial No." <> '' then
                                                    EnterCell(RowNo, 80, Format(TempItemLedgEntry."Serial No."), false, false, false, '@');
                                                if TempItemLedgEntry."Lot No." <> '' then
                                                    EnterCell(RowNo, 81, Format(TempItemLedgEntry."Lot No."), false, false, false, '@');
                                                if TempItemLedgEntry."Expiration Date" <> 0D then
                                                    EnterCell(RowNo, 82, Format(TempItemLedgEntry."Expiration Date"), false, false, false, '')
                                                ELSE begin
                                                    ItemLedgerEntry.Reset();
                                                    ItemLedgerEntry.SetRange("Item No.", TempItemLedgEntry."Item No.");
                                                    ItemLedgerEntry.SetRange("Variant Code", TempItemLedgEntry."Variant Code");
                                                    ItemLedgerEntry.SetRange("Lot No.", TempItemLedgEntry."Lot No.");
                                                    ItemLedgerEntry.SetRange("Serial No.", TempItemLedgEntry."Serial No.");
                                                    if ItemLedgerEntry.FindFirst() then begin
                                                        if ItemLedgerEntry."Expiration Date" <> 0D then
                                                            EnterCell(RowNo, 82, Format(ItemLedgerEntry."Expiration Date"), false, false, false, '')
                                                    end;
                                                end;
                                                EnterCell(RowNo, 83, Format(TempItemLedgEntry.Quantity), false, false, false, '');
                                            end;
                                        until TempItemLedgEntry.Next() = 0;
                                end;
                            end;
                    end;
                end;
            until Rec.Next() = 0;

        this.TempExcelBuffer.WriteSheet('Sales Inquiry', CompanyName, UserId);
        this.TempExcelBuffer.CloseBook();
        this.TempExcelBuffer.SetFriendlyFilename(StrSubstNo('Sales Inquiry', CurrentDateTime, UserId));
        this.TempExcelBuffer.OpenExcel();
    end;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean; NumberFormat: Text[50]);
    begin
        TempExcelBuffer.Init();
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.NumberFormat := NumberFormat;
        TempExcelBuffer.Insert();
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
        if TableNo in [
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