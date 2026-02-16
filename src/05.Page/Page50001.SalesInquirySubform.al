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
                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("Original Order No."; Rec."Original Order No.") { ApplicationArea = All; }
                field("Order Status"; Rec."Order Status") { ApplicationArea = All; }
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field("Customer PO No."; Rec."Customer PO No.") { ApplicationArea = All; }
                field("Requested Delivery Date"; Rec."Requested Delivery Date") { ApplicationArea = All; }
                field("Planned Delivery Date"; Rec."Planned Delivery Date") { ApplicationArea = All; }
                field("Planned Shipment Date"; Rec."Planned Shipment Date") { ApplicationArea = All; }
                field("Shipment Date"; Rec."Shipment Date") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Sales to Countries"; Rec."Sales to Countries") { ApplicationArea = All; }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.") { ApplicationArea = All; }
                field("Bill-to Name"; Rec."Bill-to Name") { ApplicationArea = All; }
                field("Ship-to Code"; Rec."Ship-to Code") { ApplicationArea = All; }
                field("Ship-to Name"; Rec."Ship-to Name") { ApplicationArea = All; }
                field("Ship-to Address"; Rec."Ship-to Address") { ApplicationArea = All; }
                field("Ship-to City"; Rec."Ship-to City") { ApplicationArea = All; }
                field("Ship-to Post Code"; Rec."Ship-to Post Code") { ApplicationArea = All; }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Order Date"; Rec."Order Date") { ApplicationArea = All; }
                field("Document Date"; Rec."Document Date") { ApplicationArea = All; }
                field("Transaction Type"; Rec."Transaction Type") { ApplicationArea = All; }
                field("Transaction Specification"; Rec."Transaction Specification") { ApplicationArea = All; }
                field("Transport Method"; Rec."Transport Method") { ApplicationArea = All; }
                field("Exit Point"; Rec."Exit Point") { ApplicationArea = All; }
                field(RecArea; Rec.Area) { ApplicationArea = All; }
                field(Type; Rec.Type) { ApplicationArea = All; }
                field("Item No."; Rec."Item No.") { ApplicationArea = All; }
                field("Item Description"; Rec."Item Description") { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Unit of Measure Code"; Rec."Unit of Measure Code") { ApplicationArea = All; }
                field("Unit of Measure"; Rec."Unit of Measure") { ApplicationArea = All; }
                field("Reserved Quantity"; Rec."Reserved Quantity") { ApplicationArea = All; }
                field("Qty. to Ship"; Rec."Qty. to Ship") { ApplicationArea = All; }
                field("Qty. to Invoice"; Rec."Qty. to Invoice") { ApplicationArea = All; }
                field("Quantity Shipped"; Rec."Quantity Shipped") { ApplicationArea = All; }
                field("Quantity Invoiced"; Rec."Quantity Invoiced") { ApplicationArea = All; }
                field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field("Unit Cost"; Rec."Unit Cost") { ApplicationArea = All; }
                field("Total Cost"; Rec."Total Cost") { ApplicationArea = All; }
                field("Line Amount"; Rec."Line Amount") { ApplicationArea = All; }
                field("Line Discount Amount"; Rec."Line Discount Amount") { ApplicationArea = All; }
                field("Line Discount %"; Rec."Line Discount %") { ApplicationArea = All; }
                field("Shipment Method Code"; Rec."Shipment Method Code") { ApplicationArea = All; }
                field("Shipping Agent Code"; Rec."Shipping Agent Code") { ApplicationArea = All; }
                field("Payment Terms Code"; Rec."Payment Terms Code") { ApplicationArea = All; }
                field("Payment Method Code"; Rec."Payment Method Code") { ApplicationArea = All; }
                field("Due Date"; Rec."Due Date") { ApplicationArea = All; }
                field("Payment Discount %"; Rec."Payment Discount %") { ApplicationArea = All; }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date") { ApplicationArea = All; }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group") { ApplicationArea = All; }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group") { ApplicationArea = All; }
                field("Customer Posting Group"; Rec."Customer Posting Group") { ApplicationArea = All; }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group") { ApplicationArea = All; }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group") { ApplicationArea = All; }
                field("Salesperson Code"; Rec."Salesperson Code") { ApplicationArea = All; }
                field("Responsibility Center"; Rec."Responsibility Center") { ApplicationArea = All; }
                field("Prepayment %"; Rec."Prepayment %") { ApplicationArea = All; }
                field("Prepmt. Payment Terms Code"; Rec."Prepmt. Payment Terms Code") { ApplicationArea = All; }
                field("Prepayment Due Date"; Rec."Prepayment Due Date") { ApplicationArea = All; }
                field("Prepmt. Payment Discount %"; Rec."Prepmt. Payment Discount %") { ApplicationArea = All; }
                field("Prepmt. Pmt. Discount Date"; Rec."Prepmt. Pmt. Discount Date") { ApplicationArea = All; }
                field("Net Weight"; Rec."Net Weight") { ApplicationArea = All; }
                field("Gross Weight"; Rec."Gross Weight") { ApplicationArea = All; }
                field("Reason Code"; Rec."Reason Code") { ApplicationArea = All; }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { ApplicationArea = All; }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { ApplicationArea = All; }
                field("Promised Delivery Date"; Rec."Promised Delivery Date") { ApplicationArea = All; }
            }
        }
    }
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        blnSalesQuote: Boolean;
        blnSalesOrder: Boolean;
        blnSalesInvoice: Boolean;
        blnSalesCreditMemo: Boolean;
        blnSalesReturnOrder: Boolean;
        blnCloesdOrder: Boolean;
        blnPostedSalesInvoice: Boolean;
        blnPostedSalesCrMemo: Boolean;

    procedure SetIncludeTable(pSQ: Boolean; pSO: Boolean; pSInv: Boolean; pSCrMemo: Boolean; pSRO: Boolean; pSCO: Boolean; pPSInv: Boolean; pPCrMemo: Boolean);
    begin
        blnSalesQuote := pSQ;
        blnSalesOrder := pSO;
        blnSalesInvoice := pSInv;
        blnSalesCreditMemo := pSCrMemo;
        blnSalesReturnOrder := pSRO;
        blnCloesdOrder := pSCO;
        blnPostedSalesInvoice := pPSInv;
        blnPostedSalesCrMemo := pPCrMemo;
    end;

    /* procedure FindRecords();
    var
        SalesInq: Record 50000;
        lrecSalesHeader: Record 36;
        lrecSalesLine: Record 37;
        DocFilter: Text[250];
        lrecSalesInvHeader: Record 112;
        lrecSalesInvLine: Record 113;
        lrecSalesCrMemoHeader: Record 114;
        lrecSalesCrMemoline: Record 115;
        lrecInvSetup: Record 313;
        lrecGLSetup: Record 98;
        lrecItemUOM: Record 5404;
        lrecDocDim: Record 357;
        lrecPostedDocDim: Record 359;
        lrecItem: Record 27;
        CurrExchRate: Record 330;
        RecFilter: Text[250];
    BEGIN
        lrecInvSetup.GET();
        lrecGLSetup.GET();

        RecFilter := GETVIEW;
        RESET;
        DELETEALL;
        SETVIEW(RecFilter);

        decTotalQty := 0;
        decTotalAmount := 0;
        decTotalAmountInclVAT := 0;

        //
        // Sales Quote, Sales Order, Sales Invoice, Sales Credit Memo, Sales Return Order
        //

        DocFilter := '';
        IF blnSalesQuote
          THEN
            DocFilter := '0';

        IF blnSalesOrder AND (DocFilter <> '') THEN
            DocFilter := DocFilter + '|1';
        IF blnSalesOrder AND (DocFilter = '') THEN
            DocFilter := '1';

        IF blnSalesInvoice AND (DocFilter <> '') THEN
            DocFilter := DocFilter + '|2';
        IF blnSalesInvoice AND (DocFilter = '') THEN
            DocFilter := '2';

        IF blnSalesCreditMemo AND (DocFilter <> '') THEN
            DocFilter := DocFilter + '|3';
        IF blnSalesCreditMemo AND (DocFilter = '') THEN
            DocFilter := '3';

        IF blnSalesReturnOrder AND (DocFilter <> '') THEN
            DocFilter := DocFilter + '|5';
        IF blnSalesReturnOrder AND (DocFilter = '') THEN
            DocFilter := '5';

        //PBCJP-TRD-002-003: BEGIN
        IF blnCloesdOrder AND (DocFilter <> '') THEN
            DocFilter := DocFilter + '|10';
        IF blnCloesdOrder AND (DocFilter = '') THEN
            DocFilter := '10';
        //PBCJP-TRD-002-003: END

        IF DocFilter <> '' THEN BEGIN
            lrecSalesHeader.SETFILTER("Document Type", DocFilter);
            IF CustomerFilter <> '' THEN
                lrecSalesHeader.SETFILTER("Sell-to Customer No.", CustomerFilter);
            IF PostingDateFilter <> '' THEN
                lrecSalesHeader.SETFILTER("Posting Date", PostingDateFilter);
            IF OrderDateFilter <> '' THEN
                lrecSalesHeader.SETFILTER("Order Date", OrderDateFilter);

            IF lrecSalesHeader.FINDSET THEN
                REPEAT
                    lrecSalesLine.SETRANGE("Document Type", lrecSalesHeader."Document Type");
                    lrecSalesLine.SETRANGE("Document No.", lrecSalesHeader."No.");
                    //lrecSalesLine.SETRANGE(Type,lrecSalesLine.Type::Item);       //PBCS10.01
                    lrecSalesLine.SETFILTER(Type, '<>%1', lrecSalesLine.Type::" ");  //PBCS10.01

                    IF ItemFilter <> ''
                      THEN
                        lrecSalesLine.SETFILTER("No.", ItemFilter);
                    IF lrecSalesLine.FINDSET THEN
                        REPEAT
                            INIT;
                            CASE lrecSalesLine."Document Type" OF
                                lrecSalesLine."Document Type"::Quote:
                                    "Document Type" := "Document Type"::Quote;
                                lrecSalesLine."Document Type"::Order:
                                    "Document Type" := "Document Type"::Order;
                                lrecSalesLine."Document Type"::Invoice:
                                    "Document Type" := "Document Type"::Invoice;
                                lrecSalesLine."Document Type"::"Credit Memo":
                                    "Document Type" := "Document Type"::"Credit Memo";
                                lrecSalesLine."Document Type"::"Return Order":
                                    "Document Type" := "Document Type"::"Return Order";

                                //PBCJP-TRD-002-003: BEGIN
                                lrecSalesLine."Document Type"::"Closed Order":
                                    "Document Type" := "Document Type"::"Closed Order";
                            //PBCJP-TRD-002-003: END

                            END;
                            "Document No." := lrecSalesLine."Document No.";
                            "Order Status" := lrecSalesHeader.Status;
                            "Line No." := lrecSalesLine."Line No.";
                            "Customer PO No." := lrecSalesHeader."External Document No.";
                            "Requested Delivery Date" := lrecSalesLine."Requested Delivery Date";
                            "Planned Delivery Date" := lrecSalesLine."Planned Delivery Date";
                            "Planned Shipment Date" := lrecSalesLine."Planned Shipment Date";
                            "Shipment Date" := lrecSalesLine."Shipment Date";
                            "Customer No." := lrecSalesLine."Sell-to Customer No.";
                            "Customer Name" := lrecSalesHeader."Sell-to Customer Name";
                            "Sales to Countries" := lrecSalesHeader."Sell-to Country/Region Code";
                            "Bill-to Customer No." := lrecSalesHeader."Bill-to Customer No.";
                            "Bill-to Name" := lrecSalesHeader."Bill-to Name";
                            "Ship-to Code" := lrecSalesHeader."Ship-to Code";
                            "Ship-to Name" := lrecSalesHeader."Ship-to Name";
                            "Ship-to Address" := lrecSalesHeader."Ship-to Address";
                            "Ship-to City" := lrecSalesHeader."Ship-to City";
                            "Ship-to Post Code" := lrecSalesHeader."Ship-to Post Code";
                            "Ship-to Country/Region Code" := lrecSalesHeader."Ship-to Country/Region Code";
                            "Posting Date" := lrecSalesHeader."Posting Date";
                            "Order Date" := lrecSalesHeader."Order Date";
                            "Document Date" := lrecSalesHeader."Document Date";
                            //PBCJP-TRD-002-002: BEGIN
                            "Transaction Type" := lrecSalesLine."Transaction Type";
                            "Transaction Specification" := lrecSalesLine."Transaction Specification";
                            "Transport Method" := lrecSalesLine."Transport Method";
                            "Exit Point" := lrecSalesLine."Exit Point";
                            Area := lrecSalesLine.Area;

                            //  "Transaction Type" := lrecSalesHeader."Transaction Type";
                            //  "Transaction Specification" := lrecSalesHeader."Transaction Specification";
                            //  "Transport Method" := lrecSalesHeader."Transport Method";
                            //  "Exit Point" := lrecSalesHeader."Exit Point";
                            //  Area := lrecSalesHeader.Area;
                            //PBCJP-TRD-002-002: END
                            Type := lrecSalesLine.Type;   //PBCS10.01
                            "Item No." := lrecSalesLine."No.";
                            "Item Description" := lrecSalesLine.Description;
                            Quantity := lrecSalesLine.Quantity;
                            "Unit of Measure Code" := lrecSalesLine."Unit of Measure Code";
                            "Unit of Measure" := lrecSalesLine."Unit of Measure";
                            "Qty. to Ship" := lrecSalesLine."Qty. to Ship";
                            "Qty. to Invoice" := lrecSalesLine."Qty. to Invoice";
                            "Quantity Shipped" := lrecSalesLine."Quantity Shipped";
                            "Quantity Invoiced" := lrecSalesLine."Quantity Invoiced";
                            "Currency Code" := lrecSalesLine."Currency Code";
                            "Location Code" := lrecSalesLine."Location Code";
                            "Unit Cost" := lrecSalesLine."Unit Cost";
                            "Total Cost" := Quantity * "Unit Cost";          //PBCS10.01
                            "Line Amount" := lrecSalesLine."Line Amount";
                            "Line Discount Amount" := lrecSalesLine."Line Discount Amount";
                            "Line Discount %" := lrecSalesLine."Line Discount %";
                            "Shipment Method Code" := lrecSalesHeader."Shipment Method Code";
                            //PBCJP-TRD-002-002: BEGIN
                            "Shipping Agent Code" := lrecSalesLine."Shipping Agent Code";
                            //  "Shipping Agent Code" := lrecSalesHeader."Shipping Agent Code";
                            //PBCJP-TRD-002-002: END
                            "Payment Terms Code" := lrecSalesHeader."Payment Terms Code";
                            "Payment Method Code" := lrecSalesHeader."Payment Method Code";
                            "Due Date" := lrecSalesHeader."Due Date";
                            "Payment Discount %" := lrecSalesHeader."Payment Discount %";
                            "Pmt. Discount Date" := lrecSalesHeader."Pmt. Discount Date";
                            "Gen. Bus. Posting Group" := lrecSalesLine."Gen. Bus. Posting Group";
                            "Gen. Prod. Posting Group" := lrecSalesLine."Gen. Prod. Posting Group";
                            "Customer Posting Group" := lrecSalesHeader."Customer Posting Group";
                            "VAT Bus. Posting Group" := lrecSalesLine."VAT Bus. Posting Group";
                            "VAT Prod. Posting Group" := lrecSalesLine."VAT Prod. Posting Group";
                            "Salesperson Code" := lrecSalesHeader."Salesperson Code";
                            //PBCJP-TRD-002-002: BEGIN
                            "Responsibility Center" := lrecSalesLine."Responsibility Center";
                            //  "Responsibility Center" := lrecSalesHeader."Responsibility Center";
                            //PBCJP-TRD-002-002: END
                            "Prepayment %" := lrecSalesLine."Prepayment %";
                            "Compress Prepayment" := lrecSalesHeader."Compress Prepayment";
                            "Prepmt. Payment Terms Code" := lrecSalesHeader."Prepmt. Payment Terms Code";
                            "Prepayment Due Date" := lrecSalesHeader."Prepayment Due Date";
                            "Prepmt. Payment Discount %" := lrecSalesHeader."Prepmt. Payment Discount %";
                            "Prepmt. Pmt. Discount Date" := lrecSalesHeader."Prepmt. Pmt. Discount Date";
                            "Net Weight" := lrecSalesLine."Net Weight";
                            "Gross Weight" := lrecSalesLine."Gross Weight";
                            "Reason Code" := lrecSalesHeader."Reason Code";
                            "Global Dimension 1 Code" := lrecSalesLine."Shortcut Dimension 1 Code";
                            "Global Dimension 2 Code" := lrecSalesLine."Shortcut Dimension 2 Code";
                            lrecDocDim.RESET;
                            lrecDocDim.SETRANGE("Table ID", DATABASE::"Sales Line");
                            lrecDocDim.SETRANGE("Document Type", lrecSalesLine."Document Type");
                            lrecDocDim.SETRANGE("Document No.", lrecSalesLine."Document No.");
                            lrecDocDim.SETRANGE("Line No.", lrecSalesLine."Line No.");
                            lrecDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 3 Code");
                            IF lrecDocDim.FINDFIRST THEN
                                "Shortcut Dimension 3 Code" := lrecDocDim."Dimension Value Code";
                            lrecDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 4 Code");
                            IF lrecDocDim.FINDFIRST THEN
                                "Shortcut Dimension 4 Code" := lrecDocDim."Dimension Value Code";
                            lrecDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 5 Code");
                            IF lrecDocDim.FINDFIRST THEN
                                "Shortcut Dimension 5 Code" := lrecDocDim."Dimension Value Code";
                            lrecDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 6 Code");
                            IF lrecDocDim.FINDFIRST THEN
                                "Shortcut Dimension 6 Code" := lrecDocDim."Dimension Value Code";
                            lrecDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 7 Code");
                            IF lrecDocDim.FINDFIRST THEN
                                "Shortcut Dimension 7 Code" := lrecDocDim."Dimension Value Code";
                            lrecDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 8 Code");
                            IF lrecDocDim.FINDFIRST THEN
                                "Shortcut Dimension 8 Code" := lrecDocDim."Dimension Value Code";
                            lrecSalesLine.CALCFIELDS("Reserved Quantity");
                            "Reserved Quantity" := lrecSalesLine."Reserved Quantity";
                            //PBCJP-TRD-002-002: BEGIN
                            "Promised Delivery Date" := lrecSalesLine."Promised Delivery Date";
                            //  "Promised Delivery Date" := lrecSalesHeader."Promised Delivery Date";
                            //PBCJP-TRD-002-002: END
                            "Original Order No." := lrecSalesHeader."No.";

                            TotalQty := Quantity;
                            TotalAmount := "Line Amount";
                            TotalAmountInclVAT := "Line Amount" * (1 + lrecSalesLine."VAT %" / 100);
                            IF "Currency Code" <> '' THEN BEGIN
                                TotalAmount :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToLCY(
                                      GetDate("Posting Date"), "Currency Code", TotalAmount,
                                      lrecSalesHeader."Currency Factor"),
                                    lrecGLSetup."Amount Rounding Precision");
                                TotalAmountInclVAT :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToLCY(
                                      GetDate("Posting Date"), "Currency Code", TotalAmountInclVAT,
                                      lrecSalesHeader."Currency Factor"),
                                    lrecGLSetup."Amount Rounding Precision");
                            END;
                            decTotalQty += TotalQty;
                            decTotalAmount += TotalAmount;
                            decTotalAmountInclVAT += TotalAmountInclVAT;

                            INSERT;
                        UNTIL lrecSalesLine.NEXT = 0;
                UNTIL lrecSalesHeader.NEXT = 0;
        END;

        //
        // Posted Sales Invoice
        //

        IF blnPostedSalesInvoice THEN BEGIN
            IF CustomerFilter <> '' THEN
                lrecSalesInvHeader.SETFILTER("Sell-to Customer No.", CustomerFilter);
            IF PostingDateFilter <> '' THEN
                lrecSalesInvHeader.SETFILTER("Posting Date", PostingDateFilter);
            IF OrderDateFilter <> '' THEN
                lrecSalesInvHeader.SETFILTER("Order Date", OrderDateFilter);
            IF lrecSalesInvHeader.FINDSET THEN
                REPEAT
                    lrecSalesInvLine.SETRANGE("Document No.", lrecSalesInvHeader."No.");
                    //lrecSalesInvLine.SETRANGE(Type,lrecSalesInvLine.Type::Item);       //PBCS10.01
                    lrecSalesInvLine.SETFILTER(Type, '<>%1', lrecSalesInvLine.Type::" ");  //PBCS10.01
                    IF ItemFilter <> '' THEN
                        lrecSalesInvLine.SETFILTER("No.", ItemFilter);
                    IF lrecSalesInvLine.FINDSET THEN
                        REPEAT
                            INIT;
                            "Document Type" := "Document Type"::"Posted Invoice";
                            "Document No." := lrecSalesInvLine."Document No.";
                            "Order Status" := "Order Status"::Released;
                            "Line No." := lrecSalesInvLine."Line No.";
                            "Customer PO No." := lrecSalesInvHeader."External Document No.";
                            "Posted Sales Invoice No." := lrecSalesInvLine."Document No.";
                            "Shipment Date" := lrecSalesInvLine."Shipment Date";
                            "Customer No." := lrecSalesInvLine."Sell-to Customer No.";
                            "Customer Name" := lrecSalesInvHeader."Sell-to Customer Name";
                            "Sales to Countries" := lrecSalesInvHeader."Sell-to Country/Region Code";
                            "Bill-to Customer No." := lrecSalesInvHeader."Bill-to Customer No.";
                            "Bill-to Name" := lrecSalesInvHeader."Bill-to Name";
                            "Ship-to Code" := lrecSalesInvHeader."Ship-to Code";
                            "Ship-to Name" := lrecSalesInvHeader."Ship-to Name";
                            "Ship-to Address" := lrecSalesInvHeader."Ship-to Address";
                            "Ship-to City" := lrecSalesInvHeader."Ship-to City";
                            "Ship-to Post Code" := lrecSalesInvHeader."Ship-to Post Code";
                            "Ship-to Country/Region Code" := lrecSalesInvHeader."Ship-to Country/Region Code";
                            "Posting Date" := lrecSalesInvHeader."Posting Date";
                            "Order Date" := lrecSalesInvHeader."Order Date";
                            "Document Date" := lrecSalesInvHeader."Document Date";
                            //PBCJP-TRD-002-002: BEGIN
                            "Transaction Type" := lrecSalesInvLine."Transaction Type";
                            "Transaction Specification" := lrecSalesInvLine."Transaction Specification";
                            "Transport Method" := lrecSalesInvLine."Transport Method";
                            "Exit Point" := lrecSalesInvLine."Exit Point";
                            Area := lrecSalesInvLine.Area;

                            //  "Transaction Type" := lrecSalesInvHeader."Transaction Type";
                            //  "Transaction Specification" := lrecSalesInvHeader."Transaction Specification";
                            //  "Transport Method" := lrecSalesInvHeader."Transport Method";
                            //  "Exit Point" := lrecSalesInvHeader."Exit Point";
                            //  Area := lrecSalesInvHeader.Area;
                            //PBCJP-TRD-002-002: END
                            Type := lrecSalesInvLine.Type;    //PBCS10.01
                            "Item No." := lrecSalesInvLine."No.";
                            "Item Description" := lrecSalesInvLine.Description;
                            Quantity := lrecSalesInvLine.Quantity;
                            "Unit of Measure Code" := lrecSalesInvLine."Unit of Measure Code";
                            "Unit of Measure" := lrecSalesInvLine."Unit of Measure";
                            "Quantity Shipped" := lrecSalesInvLine.Quantity;
                            "Quantity Invoiced" := lrecSalesInvLine.Quantity;
                            "Currency Code" := lrecSalesInvHeader."Currency Code";
                            "Location Code" := lrecSalesInvLine."Location Code";
                            "Unit Cost" := lrecSalesInvLine."Unit Cost";
                            "Total Cost" := Quantity * "Unit Cost";          //PBCS10.01
                            "Line Amount" := lrecSalesInvLine."Line Amount";
                            "Line Discount Amount" := lrecSalesInvLine."Line Discount Amount";
                            "Line Discount %" := lrecSalesInvLine."Line Discount %";
                            "Shipment Method Code" := lrecSalesInvHeader."Shipment Method Code";
                            "Shipping Agent Code" := lrecSalesInvHeader."Shipping Agent Code";
                            "Payment Terms Code" := lrecSalesInvHeader."Payment Terms Code";
                            "Payment Method Code" := lrecSalesInvHeader."Payment Method Code";
                            "Pre-paid/Collect" := "Pre-paid/Collect"::" ";
                            "Due Date" := lrecSalesInvHeader."Due Date";
                            "Payment Discount %" := lrecSalesInvHeader."Payment Discount %";
                            "Pmt. Discount Date" := lrecSalesInvHeader."Pmt. Discount Date";
                            "Gen. Bus. Posting Group" := lrecSalesInvLine."Gen. Bus. Posting Group";
                            "Gen. Prod. Posting Group" := lrecSalesInvLine."Gen. Prod. Posting Group";
                            "Customer Posting Group" := lrecSalesInvHeader."Customer Posting Group";
                            "VAT Bus. Posting Group" := lrecSalesInvLine."VAT Bus. Posting Group";
                            "VAT Prod. Posting Group" := lrecSalesInvLine."VAT Prod. Posting Group";
                            "Salesperson Code" := lrecSalesInvHeader."Salesperson Code";
                            //PBCJP-TRD-002-002: BEGIN
                            "Responsibility Center" := lrecSalesInvLine."Responsibility Center";
                            //  "Responsibility Center" := lrecSalesInvHeader."Responsibility Center";
                            //PBCJP-TRD-002-002: END
                            "Net Weight" := lrecSalesInvLine."Net Weight";
                            "Gross Weight" := lrecSalesInvLine."Gross Weight";
                            "Reason Code" := lrecSalesInvHeader."Reason Code";
                            "Global Dimension 1 Code" := lrecSalesInvLine."Shortcut Dimension 1 Code";
                            "Global Dimension 2 Code" := lrecSalesInvLine."Shortcut Dimension 2 Code";

                            lrecPostedDocDim.RESET;
                            lrecPostedDocDim.SETRANGE("Table ID", DATABASE::"Sales Invoice Line");
                            lrecPostedDocDim.SETRANGE("Document No.", lrecSalesInvLine."Document No.");
                            lrecPostedDocDim.SETRANGE("Line No.", lrecSalesInvLine."Line No.");
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 3 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 3 Code" := lrecPostedDocDim."Dimension Value Code";
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 4 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 4 Code" := lrecPostedDocDim."Dimension Value Code";
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 5 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 5 Code" := lrecPostedDocDim."Dimension Value Code";
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 6 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 6 Code" := lrecPostedDocDim."Dimension Value Code";
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 7 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 7 Code" := lrecPostedDocDim."Dimension Value Code";
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 8 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 8 Code" := lrecPostedDocDim."Dimension Value Code";
                            "Original Order No." := lrecSalesInvHeader."Order No.";

                            TotalQty := Quantity;
                            TotalAmount := "Line Amount";
                            TotalAmountInclVAT := "Line Amount" * (1 + lrecSalesInvLine."VAT %" / 100);
                            IF "Currency Code" <> '' THEN BEGIN
                                TotalAmount :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToLCY(
                                      GetDate("Posting Date"), "Currency Code", TotalAmount,
                                      lrecSalesInvHeader."Currency Factor"),
                                    lrecGLSetup."Amount Rounding Precision");
                                TotalAmountInclVAT :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToLCY(
                                      GetDate("Posting Date"), "Currency Code", TotalAmountInclVAT,
                                      lrecSalesInvHeader."Currency Factor"),
                                    lrecGLSetup."Amount Rounding Precision");
                            END;
                            decTotalQty += TotalQty;
                            decTotalAmount += TotalAmount;
                            decTotalAmountInclVAT += TotalAmountInclVAT;

                            INSERT;
                        UNTIL lrecSalesInvLine.NEXT = 0;
                UNTIL lrecSalesInvHeader.NEXT = 0;
        END;

        //
        // Posted Sales Credit Memo
        //

        IF blnPostedSalesCrMemo THEN BEGIN
            IF CustomerFilter <> '' THEN
                lrecSalesCrMemoHeader.SETFILTER("Sell-to Customer No.", CustomerFilter);
            IF PostingDateFilter <> '' THEN
                lrecSalesCrMemoHeader.SETFILTER("Posting Date", PostingDateFilter);
            IF OrderDateFilter <> '' THEN
                lrecSalesCrMemoHeader.SETFILTER("Document Date", OrderDateFilter);
            IF lrecSalesCrMemoHeader.FINDSET THEN
                REPEAT
                    lrecSalesCrMemoline.SETRANGE("Document No.", lrecSalesCrMemoHeader."No.");
                    //lrecSalesCrMemoline.SETRANGE(Type,lrecSalesCrMemoline.Type::Item);       //PBCS10.01
                    lrecSalesCrMemoline.SETFILTER(Type, '<>%1', lrecSalesCrMemoline.Type::" ");  //PBCS10.01
                    IF ItemFilter <> '' THEN
                        lrecSalesCrMemoline.SETFILTER("No.", ItemFilter);
                    IF lrecSalesCrMemoline.FINDSET THEN
                        REPEAT
                            INIT;
                            "Document Type" := "Document Type"::"Posted Credit Memo";
                            "Document No." := lrecSalesCrMemoline."Document No.";
                            "Order Status" := "Order Status"::Released;
                            "Line No." := lrecSalesCrMemoline."Line No.";
                            "Customer PO No." := lrecSalesCrMemoHeader."External Document No.";
                            "Shipment Date" := lrecSalesCrMemoline."Shipment Date";
                            "Customer No." := lrecSalesCrMemoline."Sell-to Customer No.";
                            "Customer Name" := lrecSalesCrMemoHeader."Sell-to Customer Name";
                            "Sales to Countries" := lrecSalesCrMemoHeader."Sell-to Country/Region Code";
                            "Bill-to Customer No." := lrecSalesCrMemoHeader."Bill-to Customer No.";
                            "Bill-to Name" := lrecSalesCrMemoHeader."Bill-to Name";
                            "Ship-to Code" := lrecSalesCrMemoHeader."Ship-to Code";
                            "Ship-to Name" := lrecSalesCrMemoHeader."Ship-to Name";
                            "Ship-to Address" := lrecSalesCrMemoHeader."Ship-to Address";
                            "Ship-to City" := lrecSalesCrMemoHeader."Ship-to City";
                            "Ship-to Post Code" := lrecSalesCrMemoHeader."Ship-to Post Code";
                            "Ship-to Country/Region Code" := lrecSalesCrMemoHeader."Ship-to Country/Region Code";
                            "Posting Date" := lrecSalesCrMemoHeader."Posting Date";
                            "Document Date" := lrecSalesCrMemoHeader."Document Date";
                            //PBCJP-TRD-002-002: BEGIN
                            "Transaction Type" := lrecSalesCrMemoline."Transaction Type";
                            "Transaction Specification" := lrecSalesCrMemoline."Transaction Specification";
                            "Transport Method" := lrecSalesCrMemoline."Transport Method";
                            "Exit Point" := lrecSalesCrMemoline."Exit Point";
                            Area := lrecSalesCrMemoline.Area;

                            //  "Transaction Type" := lrecSalesCrMemoHeader."Transaction Type";
                            //  "Transaction Specification" := lrecSalesCrMemoHeader."Transaction Specification";
                            //  "Transport Method" := lrecSalesCrMemoHeader."Transport Method";
                            //  "Exit Point" := lrecSalesCrMemoHeader."Exit Point";
                            //  Area := lrecSalesCrMemoHeader.Area;
                            //PBCJP-TRD-002-002: END
                            Type := lrecSalesCrMemoline.Type;  //PBCS10.01
                            "Item No." := lrecSalesCrMemoline."No.";
                            "Item Description" := lrecSalesCrMemoline.Description;
                            Quantity := lrecSalesCrMemoline.Quantity;
                            "Unit of Measure Code" := lrecSalesCrMemoline."Unit of Measure Code";
                            "Unit of Measure" := lrecSalesCrMemoline."Unit of Measure";
                            "Quantity Shipped" := lrecSalesCrMemoline.Quantity;
                            "Quantity Invoiced" := lrecSalesCrMemoline.Quantity;
                            "Currency Code" := lrecSalesCrMemoHeader."Currency Code";
                            "Location Code" := lrecSalesCrMemoline."Location Code";
                            "Unit Cost" := lrecSalesCrMemoline."Unit Cost";
                            "Total Cost" := Quantity * "Unit Cost";          //PBCS10.01
                            "Line Amount" := lrecSalesCrMemoline."Line Amount";
                            "Line Discount Amount" := lrecSalesCrMemoline."Line Discount Amount";
                            "Line Discount %" := lrecSalesCrMemoline."Line Discount %";
                            "Shipment Method Code" := lrecSalesCrMemoHeader."Shipment Method Code";
                            "Payment Terms Code" := lrecSalesCrMemoHeader."Payment Terms Code";
                            "Payment Method Code" := lrecSalesCrMemoHeader."Payment Method Code";
                            "Pre-paid/Collect" := "Pre-paid/Collect"::" ";
                            "Due Date" := lrecSalesCrMemoHeader."Due Date";
                            "Payment Discount %" := lrecSalesCrMemoHeader."Payment Discount %";
                            "Pmt. Discount Date" := lrecSalesCrMemoHeader."Pmt. Discount Date";
                            "Gen. Bus. Posting Group" := lrecSalesCrMemoline."Gen. Bus. Posting Group";
                            "Gen. Prod. Posting Group" := lrecSalesCrMemoline."Gen. Prod. Posting Group";
                            "Customer Posting Group" := lrecSalesCrMemoHeader."Customer Posting Group";
                            "VAT Bus. Posting Group" := lrecSalesCrMemoline."VAT Bus. Posting Group";
                            "VAT Prod. Posting Group" := lrecSalesCrMemoline."VAT Prod. Posting Group";
                            "Salesperson Code" := lrecSalesCrMemoHeader."Salesperson Code";
                            //PBCJP-TRD-002-002: BEGIN
                            "Responsibility Center" := lrecSalesCrMemoline."Responsibility Center";
                            //  "Responsibility Center" := lrecSalesCrMemoHeader."Responsibility Center";
                            //PBCJP-TRD-002-002: BEGIN
                            "Net Weight" := lrecSalesCrMemoline."Net Weight";
                            "Gross Weight" := lrecSalesCrMemoline."Gross Weight";
                            "Reason Code" := lrecSalesCrMemoHeader."Reason Code";
                            "Global Dimension 1 Code" := lrecSalesCrMemoline."Shortcut Dimension 1 Code";
                            "Global Dimension 2 Code" := lrecSalesCrMemoline."Shortcut Dimension 2 Code";

                            lrecPostedDocDim.RESET;
                            lrecPostedDocDim.SETRANGE("Table ID", DATABASE::"Sales Cr.Memo Line");
                            lrecPostedDocDim.SETRANGE("Document No.", lrecSalesCrMemoline."Document No.");
                            lrecPostedDocDim.SETRANGE("Line No.", lrecSalesCrMemoline."Line No.");
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 3 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 3 Code" := lrecPostedDocDim."Dimension Value Code";
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 4 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 4 Code" := lrecPostedDocDim."Dimension Value Code";
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 5 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 5 Code" := lrecPostedDocDim."Dimension Value Code";
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 6 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 6 Code" := lrecPostedDocDim."Dimension Value Code";
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 7 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 7 Code" := lrecPostedDocDim."Dimension Value Code";
                            lrecPostedDocDim.SETRANGE("Dimension Code", lrecGLSetup."Shortcut Dimension 8 Code");
                            IF lrecPostedDocDim.FINDFIRST THEN
                                "Shortcut Dimension 8 Code" := lrecPostedDocDim."Dimension Value Code";
                            "Original Order No." := '';

                            TotalQty := Quantity;
                            TotalAmount := "Line Amount";
                            TotalAmountInclVAT := "Line Amount" * (1 + lrecSalesCrMemoline."VAT %" / 100);
                            IF "Currency Code" <> '' THEN BEGIN
                                TotalAmount :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToLCY(
                                      GetDate("Posting Date"), "Currency Code", TotalAmount,
                                      lrecSalesCrMemoHeader."Currency Factor"),
                                    lrecGLSetup."Amount Rounding Precision");
                                TotalAmountInclVAT :=
                                  ROUND(
                                    CurrExchRate.ExchangeAmtFCYToLCY(
                                      GetDate("Posting Date"), "Currency Code", TotalAmountInclVAT,
                                      lrecSalesCrMemoHeader."Currency Factor"),
                                    lrecGLSetup."Amount Rounding Precision");
                            END;
                            decTotalQty += TotalQty;
                            decTotalAmount += TotalAmount;
                            decTotalAmountInclVAT += TotalAmountInclVAT;

                            INSERT;
                        UNTIL lrecSalesCrMemoline.NEXT = 0;
                UNTIL lrecSalesCrMemoHeader.NEXT = 0;
        END;

        IF GETFILTERS <> '' THEN BEGIN
            decTotalQty := 0;
            decTotalAmount := 0;
            decTotalAmountInclVAT := 0;
            IF FINDSET THEN
                REPEAT
                    decTotalQty += TotalQty;
                    decTotalAmount += TotalAmount;
                    decTotalAmountInclVAT += TotalAmountInclVAT;
                UNTIL NEXT = 0;
        END;
        IF FINDFIRST THEN;
    END; */

    local procedure GetDate(RecDate: Date): Date;
    BEGIN
        IF RecDate <> 0D THEN
            EXIT(RecDate)
        ELSE
            EXIT(WORKDATE);
    END;

    procedure ExportDataToExcel(ShowTrackingInfo: Boolean);
    var
        RowNo: Integer;
        lrecSalesLine: Record 37;
        ReservEngineMgt: Codeunit 99000831;
        ReserveSalesOrderLine: Codeunit 99000832;
        lrReservEntry: Record 337;
        lrecSalesInvLine: Record 113;
        ItemTrackingMgmt: Codeunit 6500;
        TempItemLedgEntry: Record 32;
        lrecSalesCrMemoLine: Record 115;
        decRemainingQty: Decimal;
        lrecItemLedgerEntry: Record 32;
        lresShipmentLine: Record 111;
    BEGIN
        TempExcelBuffer.DELETEALL;
        CLEAR(TempExcelBuffer);

        RowNo := 1;

        EnterCell(RowNo, 1, Rec.FIELDCAPTION("Document Type"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 2, Rec.FIELDCAPTION("Document No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 3, Rec.FIELDCAPTION("Line No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 4, Rec.FIELDCAPTION("Customer PO No."), TRUE, FALSE, FALSE, '@');
        //EnterCell(RowNo, 5, Rec.FIELDCAPTION("Posted Sales Invoice No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 6, Rec.FIELDCAPTION("Requested Delivery Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 7, Rec.FIELDCAPTION("Planned Delivery Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 8, Rec.FIELDCAPTION("Planned Shipment Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 9, Rec.FIELDCAPTION("Shipment Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 10, Rec.FIELDCAPTION("Customer No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 11, Rec.FIELDCAPTION("Customer Name"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 12, Rec.FIELDCAPTION("Sales to Countries"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 13, Rec.FIELDCAPTION("Bill-to Customer No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 14, Rec.FIELDCAPTION("Bill-to Name"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 15, Rec.FIELDCAPTION("Ship-to Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 16, Rec.FIELDCAPTION("Ship-to Name"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 17, Rec.FIELDCAPTION("Ship-to Address"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 18, Rec.FIELDCAPTION("Ship-to City"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 19, Rec.FIELDCAPTION("Ship-to Post Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 20, Rec.FIELDCAPTION("Ship-to Country/Region Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 21, Rec.FIELDCAPTION("Posting Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 22, Rec.FIELDCAPTION("Order Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 23, Rec.FIELDCAPTION("Document Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 24, Rec.FIELDCAPTION("Transaction Type"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 25, Rec.FIELDCAPTION("Transaction Specification"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 26, Rec.FIELDCAPTION("Transport Method"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 27, Rec.FIELDCAPTION("Exit Point"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 28, Rec.FIELDCAPTION(Area), TRUE, FALSE, FALSE, '@');

        EnterCell(RowNo, 29, Rec.FIELDCAPTION(Type), TRUE, FALSE, FALSE, '@');        //PBCS10.01

        EnterCell(RowNo, 30, Rec.FIELDCAPTION("Item No."), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 31, Rec.FIELDCAPTION("Item Description"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 32, Rec.FIELDCAPTION(Quantity), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 33, Rec.FIELDCAPTION("Unit of Measure Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 34, Rec.FIELDCAPTION("Unit of Measure"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 35, Rec.FIELDCAPTION("Reserved Quantity"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 36, Rec.FIELDCAPTION("Qty. to Ship"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 37, Rec.FIELDCAPTION("Qty. to Invoice"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 38, Rec.FIELDCAPTION("Quantity Shipped"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 39, Rec.FIELDCAPTION("Quantity Invoiced"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 40, Rec.FIELDCAPTION("Currency Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 41, Rec.FIELDCAPTION("Location Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 42, Rec.FIELDCAPTION("Unit Cost"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 43, Rec.FIELDCAPTION("Total Cost"), TRUE, FALSE, FALSE, '@');  //PBCS10.01
        EnterCell(RowNo, 44, Rec.FIELDCAPTION("Line Amount"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 45, Rec.FIELDCAPTION("Line Discount Amount"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 46, Rec.FIELDCAPTION("Line Discount %"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 47, Rec.FIELDCAPTION("Shipment Method Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 48, Rec.FIELDCAPTION("Shipping Agent Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 49, Rec.FIELDCAPTION("Payment Terms Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 50, Rec.FIELDCAPTION("Payment Method Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 51, Rec.FIELDCAPTION("Pre-paid/Collect"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 52, Rec.FIELDCAPTION("Due Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 53, Rec.FIELDCAPTION("Payment Discount %"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 54, Rec.FIELDCAPTION("Pmt. Discount Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 55, Rec.FIELDCAPTION("Gen. Bus. Posting Group"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 56, Rec.FIELDCAPTION("Gen. Prod. Posting Group"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 57, Rec.FIELDCAPTION("Customer Posting Group"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 58, Rec.FIELDCAPTION("VAT Bus. Posting Group"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 59, Rec.FIELDCAPTION("VAT Prod. Posting Group"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 60, Rec.FIELDCAPTION("Salesperson Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 61, Rec.FIELDCAPTION("Responsibility Center"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 62, Rec.FIELDCAPTION("Prepayment %"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 63, Rec.FIELDCAPTION("Compress Prepayment"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 64, Rec.FIELDCAPTION("Prepmt. Payment Terms Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 65, Rec.FIELDCAPTION("Prepayment Due Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 66, Rec.FIELDCAPTION("Prepmt. Payment Discount %"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 67, Rec.FIELDCAPTION("Prepmt. Pmt. Discount Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 68, Rec.FIELDCAPTION("Net Weight"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 69, Rec.FIELDCAPTION("Gross Weight"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 70, Rec.FIELDCAPTION("Reason Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 71, Rec.FIELDCAPTION("Global Dimension 1 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 72, Rec.FIELDCAPTION("Global Dimension 2 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 73, Rec.FIELDCAPTION("Shortcut Dimension 3 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 74, Rec.FIELDCAPTION("Shortcut Dimension 4 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 75, Rec.FIELDCAPTION("Shortcut Dimension 5 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 76, Rec.FIELDCAPTION("Shortcut Dimension 6 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 77, Rec.FIELDCAPTION("Shortcut Dimension 7 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 78, Rec.FIELDCAPTION("Shortcut Dimension 8 Code"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 79, Rec.FIELDCAPTION("Expected Delivery Date"), TRUE, FALSE, FALSE, '@');
        EnterCell(RowNo, 80, Rec.FIELDCAPTION("Promised Delivery Date"), TRUE, FALSE, FALSE, '@');
        IF ShowTrackingInfo THEN BEGIN
            EnterCell(RowNo, 81, lrReservEntry.FIELDCAPTION("Serial No."), TRUE, FALSE, FALSE, '@');
            EnterCell(RowNo, 82, lrReservEntry.FIELDCAPTION("Lot No."), TRUE, FALSE, FALSE, '@');
            EnterCell(RowNo, 83, lrReservEntry.FIELDCAPTION("Expiration Date"), TRUE, FALSE, FALSE, '@');
            EnterCell(RowNo, 84, lrReservEntry.FIELDCAPTION(Quantity), TRUE, FALSE, FALSE, '@');
        END;

        IF Rec.FINDSET THEN
            REPEAT
                RowNo += 1;

                EnterCell(RowNo, 1, FORMAT(Rec."Document Type"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 2, FORMAT(Rec."Document No."), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 3, FORMAT(Rec."Line No."), FALSE, FALSE, FALSE, '');
                IF Rec."Customer PO No." <> '' THEN
                    EnterCell(RowNo, 4, FORMAT(Rec."Customer PO No."), FALSE, FALSE, FALSE, '@');
                //IF Rec."Posted Sales Invoice No." <> '' THEN
                //EnterCell(RowNo, 5, FORMAT(Rec."Posted Sales Invoice No."), FALSE, FALSE, FALSE, '@');
                IF Rec."Requested Delivery Date" <> 0D THEN
                    EnterCell(RowNo, 6, FORMAT(Rec."Requested Delivery Date"), FALSE, FALSE, FALSE, '');
                IF Rec."Planned Delivery Date" <> 0D THEN
                    EnterCell(RowNo, 7, FORMAT(Rec."Planned Delivery Date"), FALSE, FALSE, FALSE, '');
                IF Rec."Planned Shipment Date" <> 0D THEN
                    EnterCell(RowNo, 8, FORMAT(Rec."Planned Shipment Date"), FALSE, FALSE, FALSE, '');
                IF Rec."Shipment Date" <> 0D THEN
                    EnterCell(RowNo, 9, FORMAT(Rec."Shipment Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 10, FORMAT(Rec."Customer No."), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 11, FORMAT(Rec."Customer Name"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 12, FORMAT(Rec."Sales to Countries"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 13, FORMAT(Rec."Bill-to Customer No."), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 14, FORMAT(Rec."Bill-to Name"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 15, FORMAT(Rec."Ship-to Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 16, FORMAT(Rec."Ship-to Name"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 17, FORMAT(Rec."Ship-to Address"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 18, FORMAT(Rec."Ship-to City"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 19, FORMAT(Rec."Ship-to Post Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 20, FORMAT(Rec."Ship-to Country/Region Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 21, FORMAT(Rec."Posting Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 22, FORMAT(Rec."Order Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 23, FORMAT(Rec."Document Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 24, FORMAT(Rec."Transaction Type"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 25, FORMAT(Rec."Transaction Specification"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 26, FORMAT(Rec."Transport Method"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 27, FORMAT(Rec."Exit Point"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 28, FORMAT(Rec.Area), FALSE, FALSE, FALSE, '@');

                EnterCell(RowNo, 29, FORMAT(Rec.Type), FALSE, FALSE, FALSE, '@');  //PBCS10.01

                EnterCell(RowNo, 30, FORMAT(Rec."Item No."), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 31, FORMAT(Rec."Item Description"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 32, FORMAT(Rec.Quantity), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 33, FORMAT(Rec."Unit of Measure Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 34, FORMAT(Rec."Unit of Measure"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 35, FORMAT(Rec."Reserved Quantity"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 36, FORMAT(Rec."Qty. to Ship"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 37, FORMAT(Rec."Qty. to Invoice"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 38, FORMAT(Rec."Quantity Shipped"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 39, FORMAT(Rec."Quantity Invoiced"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 40, FORMAT(Rec."Currency Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 41, FORMAT(Rec."Location Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 42, FORMAT(Rec."Unit Cost"), FALSE, FALSE, FALSE, '');

                EnterCell(RowNo, 43, FORMAT(Rec."Total Cost"), FALSE, FALSE, FALSE, '');   //PBCS10.01

                EnterCell(RowNo, 44, FORMAT(Rec."Line Amount"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 45, FORMAT(Rec."Line Discount Amount"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 46, FORMAT(Rec."Line Discount %"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 47, FORMAT(Rec."Shipment Method Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 48, FORMAT(Rec."Shipping Agent Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 49, FORMAT(Rec."Payment Terms Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 50, FORMAT(Rec."Payment Method Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 51, FORMAT(Rec."Pre-paid/Collect"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 52, FORMAT(Rec."Due Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 53, FORMAT(Rec."Payment Discount %"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 54, FORMAT(Rec."Pmt. Discount Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 55, FORMAT(Rec."Gen. Bus. Posting Group"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 56, FORMAT(Rec."Gen. Prod. Posting Group"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 57, FORMAT(Rec."Customer Posting Group"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 58, FORMAT(Rec."VAT Bus. Posting Group"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 59, FORMAT(Rec."VAT Prod. Posting Group"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 60, FORMAT(Rec."Salesperson Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 61, FORMAT(Rec."Responsibility Center"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 62, FORMAT(Rec."Prepayment %"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 63, FORMAT(Rec."Compress Prepayment"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 64, FORMAT(Rec."Prepmt. Payment Terms Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 65, FORMAT(Rec."Prepayment Due Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 66, FORMAT(Rec."Prepmt. Payment Discount %"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 67, FORMAT(Rec."Prepmt. Pmt. Discount Date"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 68, FORMAT(Rec."Net Weight"), FALSE, FALSE, FALSE, '');
                EnterCell(RowNo, 69, FORMAT(Rec."Gross Weight"), FALSE, FALSE, FALSE, '');
                IF Rec."Reason Code" <> '' THEN
                    EnterCell(RowNo, 70, FORMAT(Rec."Reason Code"), FALSE, FALSE, FALSE, '@');
                IF Rec."Global Dimension 1 Code" <> '' THEN
                    EnterCell(RowNo, 71, FORMAT(Rec."Global Dimension 1 Code"), FALSE, FALSE, FALSE, '@');
                IF Rec."Global Dimension 2 Code" <> '' THEN
                    EnterCell(RowNo, 72, FORMAT(Rec."Global Dimension 2 Code"), FALSE, FALSE, FALSE, '@');
                IF Rec."Shortcut Dimension 3 Code" <> '' THEN
                    EnterCell(RowNo, 73, FORMAT(Rec."Shortcut Dimension 3 Code"), FALSE, FALSE, FALSE, '@');
                IF Rec."Shortcut Dimension 4 Code" <> '' THEN
                    EnterCell(RowNo, 74, FORMAT(Rec."Shortcut Dimension 4 Code"), FALSE, FALSE, FALSE, '@');
                IF Rec."Shortcut Dimension 5 Code" <> '' THEN
                    EnterCell(RowNo, 75, FORMAT(Rec."Shortcut Dimension 5 Code"), FALSE, FALSE, FALSE, '@');
                IF Rec."Shortcut Dimension 6 Code" <> '' THEN
                    EnterCell(RowNo, 76, FORMAT(Rec."Shortcut Dimension 6 Code"), FALSE, FALSE, FALSE, '@');
                IF Rec."Shortcut Dimension 7 Code" <> '' THEN
                    EnterCell(RowNo, 77, FORMAT(Rec."Shortcut Dimension 7 Code"), FALSE, FALSE, FALSE, '@');
                IF Rec."Shortcut Dimension 8 Code" <> '' THEN
                    EnterCell(RowNo, 78, FORMAT(Rec."Shortcut Dimension 8 Code"), FALSE, FALSE, FALSE, '@');
                EnterCell(RowNo, 79, FORMAT(Rec."Expected Delivery Date"), TRUE, FALSE, FALSE, '');
                EnterCell(RowNo, 80, FORMAT(Rec."Promised Delivery Date"), TRUE, FALSE, FALSE, '');

                IF ShowTrackingInfo THEN BEGIN
                    CASE Rec."Document Type" OF
                        Rec."Document Type"::Quote,
                        Rec."Document Type"::Order,
                        Rec."Document Type"::Invoice,
                        Rec."Document Type"::"Credit Memo",
                        Rec."Document Type"::"Closed Order":
                            BEGIN
                                //PBCJP-TRD-002-003: END
                                IF lrecSalesLine.GET(Rec."Document Type", Rec."Document No.", Rec."Line No.") THEN BEGIN
                                    if lrecSalesLine.ReservEntryExist() then begin
                                        lrReservEntry.Reset();
                                        lrReservEntry.SetCurrentKey("Source Type", "Source Subtype", "Source ID", "Source Ref. No.");
                                        lrReservEntry.SetRange("Source Type", Database::"Sales Line");
                                        lrReservEntry.SetRange("Source Subtype", lrecSalesLine."Document Type".AsInteger());
                                        lrReservEntry.SetRange("Source ID", lrecSalesLine."Document No.");
                                        lrReservEntry.SetRange("Source Ref. No.", lrecSalesLine."Line No.");
                                        if lrReservEntry.FindSet() then
                                            REPEAT
                                                IF (lrReservEntry."Serial No." <> '') OR (lrReservEntry."Lot No." <> '') THEN BEGIN
                                                    RowNo += 1;
                                                    IF lrReservEntry."Serial No." <> '' THEN
                                                        EnterCell(RowNo, 81, FORMAT(lrReservEntry."Serial No."), FALSE, FALSE, FALSE, '@');
                                                    IF lrReservEntry."Lot No." <> '' THEN
                                                        EnterCell(RowNo, 82, FORMAT(lrReservEntry."Lot No."), FALSE, FALSE, FALSE, '@');
                                                    IF lrReservEntry."Expiration Date" <> 0D THEN
                                                        EnterCell(RowNo, 83, FORMAT(lrReservEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                    ELSE BEGIN
                                                        lrecItemLedgerEntry.RESET;
                                                        lrecItemLedgerEntry.SETRANGE("Item No.", lrReservEntry."Item No.");
                                                        lrecItemLedgerEntry.SETRANGE("Variant Code", lrReservEntry."Variant Code");
                                                        lrecItemLedgerEntry.SETRANGE("Lot No.", lrReservEntry."Lot No.");
                                                        lrecItemLedgerEntry.SETRANGE("Serial No.", lrReservEntry."Serial No.");
                                                        IF lrecItemLedgerEntry.FINDFIRST THEN BEGIN
                                                            IF lrecItemLedgerEntry."Expiration Date" <> 0D THEN
                                                                EnterCell(RowNo, 83, FORMAT(lrecItemLedgerEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                        END;
                                                    END;
                                                    EnterCell(RowNo, 84, FORMAT(-lrReservEntry.Quantity), FALSE, FALSE, FALSE, '');
                                                END;
                                            UNTIL lrReservEntry.NEXT = 0;
                                    end;
                                    lresShipmentLine.RESET;
                                    lresShipmentLine.SETCURRENTKEY("Order No.", "Order Line No.");
                                    lresShipmentLine.SETRANGE("Order No.", Rec."Document No.");
                                    lresShipmentLine.SETRANGE("Order Line No.", Rec."Line No.");
                                    IF lresShipmentLine.FINDSET THEN
                                        REPEAT
                                            CLEAR(TempItemLedgEntry);
                                            TempItemLedgEntry.DELETEALL;
                                            CLEAR(ItemTrackingMgmt);
                                            RetrieveILEFromShptRcpt(TempItemLedgEntry,
                                           DATABASE::"Sales Shipment Line", 0, lresShipmentLine."Document No.", '', 0, lresShipmentLine."Line No.");
                                            IF TempItemLedgEntry.FINDSET THEN
                                                REPEAT
                                                    IF (TempItemLedgEntry."Serial No." <> '') OR (TempItemLedgEntry."Lot No." <> '') THEN BEGIN
                                                        RowNo += 1;
                                                        IF TempItemLedgEntry."Serial No." <> '' THEN
                                                            EnterCell(RowNo, 81, FORMAT(TempItemLedgEntry."Serial No."), FALSE, FALSE, FALSE, '@');
                                                        IF TempItemLedgEntry."Lot No." <> '' THEN
                                                            EnterCell(RowNo, 82, FORMAT(TempItemLedgEntry."Lot No."), FALSE, FALSE, FALSE, '@');
                                                        IF TempItemLedgEntry."Expiration Date" <> 0D THEN
                                                            EnterCell(RowNo, 83, FORMAT(TempItemLedgEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                        ELSE BEGIN
                                                            lrecItemLedgerEntry.RESET;
                                                            lrecItemLedgerEntry.SETRANGE("Item No.", TempItemLedgEntry."Item No.");
                                                            lrecItemLedgerEntry.SETRANGE("Variant Code", TempItemLedgEntry."Variant Code");
                                                            lrecItemLedgerEntry.SETRANGE("Lot No.", TempItemLedgEntry."Lot No.");
                                                            lrecItemLedgerEntry.SETRANGE("Serial No.", TempItemLedgEntry."Serial No.");
                                                            IF lrecItemLedgerEntry.FINDFIRST THEN BEGIN
                                                                IF lrecItemLedgerEntry."Expiration Date" <> 0D THEN
                                                                    EnterCell(RowNo, 83, FORMAT(lrecItemLedgerEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                            END;
                                                        END;
                                                        EnterCell(RowNo, 84, FORMAT(TempItemLedgEntry.Quantity), FALSE, FALSE, FALSE, '');
                                                    END;
                                                UNTIL TempItemLedgEntry.NEXT = 0;
                                        UNTIL lresShipmentLine.NEXT = 0;
                                END;
                            END;
                        Rec."Document Type"::"Posted Invoice":
                            BEGIN
                                IF lrecSalesInvLine.GET(Rec."Document No.", Rec."Line No.") THEN BEGIN
                                    CLEAR(TempItemLedgEntry);
                                    TempItemLedgEntry.DELETEALL;
                                    CLEAR(ItemTrackingMgmt);
                                    RetrieveILEFromPostedInv(TempItemLedgEntry, lrecSalesInvLine.RowID1);
                                    IF TempItemLedgEntry.FINDSET THEN
                                        REPEAT
                                            IF (TempItemLedgEntry."Serial No." <> '') OR (TempItemLedgEntry."Lot No." <> '') THEN BEGIN
                                                RowNo += 1;
                                                IF TempItemLedgEntry."Serial No." <> '' THEN
                                                    EnterCell(RowNo, 81, FORMAT(TempItemLedgEntry."Serial No."), FALSE, FALSE, FALSE, '@');
                                                IF TempItemLedgEntry."Lot No." <> '' THEN
                                                    EnterCell(RowNo, 82, FORMAT(TempItemLedgEntry."Lot No."), FALSE, FALSE, FALSE, '@');
                                                IF TempItemLedgEntry."Expiration Date" <> 0D THEN
                                                    EnterCell(RowNo, 83, FORMAT(TempItemLedgEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                ELSE BEGIN
                                                    lrecItemLedgerEntry.RESET;
                                                    lrecItemLedgerEntry.SETRANGE("Item No.", TempItemLedgEntry."Item No.");
                                                    lrecItemLedgerEntry.SETRANGE("Variant Code", TempItemLedgEntry."Variant Code");
                                                    lrecItemLedgerEntry.SETRANGE("Lot No.", TempItemLedgEntry."Lot No.");
                                                    lrecItemLedgerEntry.SETRANGE("Serial No.", TempItemLedgEntry."Serial No.");
                                                    IF lrecItemLedgerEntry.FINDFIRST THEN BEGIN
                                                        IF lrecItemLedgerEntry."Expiration Date" <> 0D THEN
                                                            EnterCell(RowNo, 83, FORMAT(lrecItemLedgerEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                    END;
                                                END;
                                                EnterCell(RowNo, 84, FORMAT(TempItemLedgEntry.Quantity), FALSE, FALSE, FALSE, '');
                                            END;
                                        UNTIL TempItemLedgEntry.NEXT = 0;
                                END;
                            END;
                        Rec."Document Type"::"Posted Credit Memo":
                            BEGIN
                                IF lrecSalesCrMemoLine.GET(Rec."Document No.", Rec."Line No.") THEN BEGIN
                                    CLEAR(TempItemLedgEntry);
                                    TempItemLedgEntry.DELETEALL;
                                    CLEAR(ItemTrackingMgmt);
                                    RetrieveILEFromPostedInv(TempItemLedgEntry, lrecSalesCrMemoLine.RowID1);
                                    IF TempItemLedgEntry.FINDSET THEN
                                        REPEAT
                                            IF (TempItemLedgEntry."Serial No." <> '') OR (TempItemLedgEntry."Lot No." <> '') THEN BEGIN
                                                RowNo += 1;
                                                IF TempItemLedgEntry."Serial No." <> '' THEN
                                                    EnterCell(RowNo, 81, FORMAT(TempItemLedgEntry."Serial No."), FALSE, FALSE, FALSE, '@');
                                                IF TempItemLedgEntry."Lot No." <> '' THEN
                                                    EnterCell(RowNo, 82, FORMAT(TempItemLedgEntry."Lot No."), FALSE, FALSE, FALSE, '@');
                                                IF TempItemLedgEntry."Expiration Date" <> 0D THEN
                                                    EnterCell(RowNo, 83, FORMAT(TempItemLedgEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                ELSE BEGIN
                                                    lrecItemLedgerEntry.RESET;
                                                    lrecItemLedgerEntry.SETRANGE("Item No.", TempItemLedgEntry."Item No.");
                                                    lrecItemLedgerEntry.SETRANGE("Variant Code", TempItemLedgEntry."Variant Code");
                                                    lrecItemLedgerEntry.SETRANGE("Lot No.", TempItemLedgEntry."Lot No.");
                                                    lrecItemLedgerEntry.SETRANGE("Serial No.", TempItemLedgEntry."Serial No.");
                                                    IF lrecItemLedgerEntry.FINDFIRST THEN BEGIN
                                                        IF lrecItemLedgerEntry."Expiration Date" <> 0D THEN
                                                            EnterCell(RowNo, 83, FORMAT(lrecItemLedgerEntry."Expiration Date"), FALSE, FALSE, FALSE, '')
                                                    END;
                                                END;
                                                EnterCell(RowNo, 84, FORMAT(TempItemLedgEntry.Quantity), FALSE, FALSE, FALSE, '');
                                            END;
                                        UNTIL TempItemLedgEntry.NEXT = 0;
                                END;
                            END;
                    END;
                END;
            UNTIL Rec.NEXT = 0;

        this.TempExcelBuffer.WriteSheet('Sales Inquiry', CompanyName, UserId);
        this.TempExcelBuffer.CloseBook();
        this.TempExcelBuffer.SetFriendlyFilename(StrSubstNo('Sales Inquiry', CurrentDateTime, UserId));
        this.TempExcelBuffer.OpenExcel();
    END;

    local procedure EnterCell(RowNo: Integer;
ColumnNo: Integer;
CellValue: Text[250];
Bold: Boolean;
Italic: Boolean;
UnderLine: Boolean;
NumberFormat: Text[50]);
    BEGIN
        TempExcelBuffer.INIT;
        TempExcelBuffer.VALIDATE("Row No.", RowNo);
        TempExcelBuffer.VALIDATE("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.NumberFormat := NumberFormat;  //PBCJP-TRD-002-011
        TempExcelBuffer.INSERT;
    END;

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

    /* local procedure LookupShortcutDimCode(FieldNumber : Integer; VAR ShortcutDimCode : Code[20]);
    BEGIN
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
    END; */
}