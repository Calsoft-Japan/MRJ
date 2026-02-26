table 50000 "Sales Inquiry Line"
{
    Caption = 'Sales Inquiry Line';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Return Order","Posted Invoice","Posted Credit Memo","Closed Order";
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Return Order,Posted Invoice,Posted Credit Memo,Closed Order';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            //TableRelation = IF ("Document Type" = FILTER(Quote | Order | Invoice | "Credit Memo")) "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type")) ELSE IF ("Document Type" = CONST("Posted Invoice")) "Sales Invoice Header"."No." ELSE IF ("Document Type" = CONST("Posted Credit Memo")) "Sales Cr.Memo Header"."No.";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Customer PO No."; Code[20])
        {
            Caption = 'Customer PO No.';
        }
        field(5; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
        }
        field(6; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';
        }
        field(7; "Planned Shipment Date"; Date)
        {
            Caption = 'Planned Shipment Date';
        }
        field(8; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(9; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(10; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
        }
        field(11; "Sales to Countries"; Code[10])
        {
            Caption = 'Sales to Countries';
        }
        field(12; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(13; "Bill-to Name"; Text[50])
        {
            Caption = 'Bill-to Name';
        }
        field(14; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
        }
        field(15; "Ship-to Name"; Text[50])
        {
            Caption = 'Ship-to Name';
        }
        field(16; "Ship-to Address"; Text[50])
        {
            Caption = 'Ship-to Address';
        }
        field(17; "Ship-to City"; Text[50])
        {
            Caption = 'Ship-to City';
        }
        field(18; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(19; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(22; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(23; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(24; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(25; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(26; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(27; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(28; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            //TableRelation = IF (Type = CONST(" ")) "Standard Text" ELSE IF (Type = CONST(G/L Account)) "G/L Account" ELSE IF (Type=CONST(Item)) Item ELSE IF (Type=CONST(Resource)) Resource ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
        }
        field(29; "Item Description"; Text[50])
        {
            Caption = 'Item Description';
        }
        field(30; "Filter Effective Surface Area"; Decimal)
        {
            Caption = 'Filter Effective Surface Area (m)';
        }
        field(31; "AGP Volume"; Decimal)
        {
            Caption = 'AGP Volume (Liter)';
        }
        field(32; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
        }
        field(33; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(34; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(35; "Reserved Quantity"; Decimal)
        {
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';
            DecimalPlaces = 0 : 5;
        }
        field(37; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice';
            DecimalPlaces = 0 : 5;
        }
        field(38; "Quantity Shipped"; Decimal)
        {
            Caption = 'Quantity Shipped';
            DecimalPlaces = 0 : 5;
        }
        field(39; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0 : 5;
        }
        field(40; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(41; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            //TableRelation = Location WHERE (Use As In-Transit=CONST(No));
        }
        field(42; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            Editable = false;
            AutoFormatType = 2;
        }
        field(43; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
        }
        field(44; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
        }
        field(45; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(46; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(47; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(48; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(49; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(50; "Pre-paid/Collect"; Option)
        {
            Caption = 'Pre-paid/Collect';
            OptionMembers = Value,Prepaid,Collect;
            OptionCaption = '" ,Prepaid,Collect"';
        }
        field(51; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(52; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
        }
        field(53; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(54; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(55; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(56; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(57; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(58; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(59; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
        }
        field(60; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(61; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(62; "Compress Prepayment"; Boolean)
        {
            Caption = 'Compress Prepayment';
            InitValue = true;
        }
        field(63; "Prepmt. Payment Terms Code"; Code[10])
        {
            Caption = 'Prepmt. Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(64; "Prepayment Due Date"; Date)
        {
            Caption = 'Prepayment Due Date';
        }
        field(65; "Prepmt. Payment Discount %"; Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';
        }
        field(66; "Prepmt. Pmt. Discount Date"; Date)
        {
            Caption = 'Prepmt. Pmt. Discount Date';
        }
        field(67; "Header Remark"; Code[10])
        {
            Caption = 'Header Remark';
        }
        field(68; "Line Remark"; Text[150])
        {
            Caption = 'Line Remark';
        }
        field(69; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
        }
        field(70; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
        }
        field(71; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(72; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
        }
        field(73; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
        }
        field(74; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
        }
        field(75; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
        }
        field(76; "Shortcut Dimension 5 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
        }
        field(77; "Shortcut Dimension 6 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
        }
        field(78; "Shortcut Dimension 7 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
        }
        field(79; "Shortcut Dimension 8 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
        }
        field(80; "Expected Delivery Date"; Date)
        {
            Caption = 'Expected Delivery Date';
        }
        field(81; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(82; "Ship From"; Text[50])
        {
            Caption = 'Ship From';
        }
        field(83; "Shipping Instruction Memo 1"; Text[50])
        {
            Caption = 'Shipping Instruction Memo 1';
        }
        field(84; "Shipping Instruction Memo 2"; Text[50])
        {
            Caption = 'Shipping Instruction Memo 2';
        }
        field(85; "Shipping Instruction Memo 3"; Text[50])
        {
            Caption = 'Shipping Instruction Memo 3';
        }
        field(86; "Shipping Instruction Memo 4"; Text[50])
        {
            Caption = 'Shipping Instruction Memo 4';
        }
        field(87; "Shipping Instruction Memo 5"; Text[50])
        {
            Caption = 'Shipping Instruction Memo 5';
        }
        field(88; "Shipping Instruction Memo 6"; Text[50])
        {
            Caption = 'Shipping Instruction Memo 6';
        }
        field(89; "Shipping Instruction Memo 7"; Text[50])
        {
            Caption = 'Shipping Instruction Memo 7';
        }
        field(90; "Shipping Instruction Memo 8"; Text[50])
        {
            Caption = 'Shipping Instruction Memo 8';
        }
        field(91; "Shipping Instruction Memo 9"; Text[50])
        {
            Caption = 'Shipping Instruction Memo 9';
        }
        field(92; "Shipping Instruction Memo 10"; Text[50])
        {
            Caption = 'Shipping Instruction Memo 10';
        }
        field(93; "Order Confirmation Memo 1"; Text[80])
        {
            Caption = 'Order Confirmation Memo 1';
        }
        field(94; "Order Confirmation Memo 2"; Text[80])
        {
            Caption = 'Order Confirmation Memo 2';
        }
        field(95; "Proforma Invoice Memo 1"; Text[80])
        {
            Caption = 'Proforma Invoice Memo 1';
        }
        field(96; "Proforma Invoice Memo 2"; Text[80])
        {
            Caption = 'Proforma Invoice Memo 2';
        }
        field(97; "Invoice Memo 1"; Text[80])
        {
            Caption = 'Invoice Memo 1';
        }
        field(98; "Invoice Memo 2"; Text[80])
        {
            Caption = 'Invoice Memo 2';
        }
        field(99; "Credit Memo Remark 1"; Text[80])
        {
            Caption = 'Credit Memo Remark 1';
        }
        field(100; "Credit Memo Remark 2"; Text[80])
        {
            Caption = 'Credit Memo Remark 2';
        }
        field(101; "Credit Memo Remark 3"; Text[80])
        {
            Caption = 'Credit Memo Remark 3';
        }
        field(102; "Credit Memo Remark 4"; Text[80])
        {
            Caption = 'Credit Memo Remark 4';
        }
        field(103; "Order Status"; Enum "Sales Document Status")
        {
            Caption = 'Status';
            //OptionMembers = Open,Released,Pending_Approval,Pending_Prepayment;
            //OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
        }
        field(104; "B/L Date"; Date)
        {
            Caption = 'B/L Date';
        }
        field(105; "B/L No."; Code[20])
        {
            Caption = 'B/L No.';
        }
        field(106; "Name of Vessels"; Text[50])
        {
            Caption = 'Name of Vessels';
        }
        field(107; "Original Order No."; Code[20])
        {
            Caption = 'Original Order No.';
        }
        field(108; "TotalQty"; Decimal)
        {
            Caption = 'TotalQty';
            DecimalPlaces = 0 : 5;
        }
        field(109; "TotalAmount"; Decimal)
        {
            Caption = 'TotalAmount';
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
        }
        field(110; "TotalAmountInclVAT"; Decimal)
        {
            Caption = 'TotalAmountInclVAT';
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
        }
        field(111; "Type"; Enum "Sales Line Type")
        {
            Caption = 'Type';
        }
        field(112; "Total Cost"; Decimal)
        {
            Caption = 'Total Unit Cost';
            Description = 'PBCS10.01';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(200; GUID; GUID) //For Internal Logic
        {
            Caption = 'GUID', Locked = true;
        }
        field(201; "Creation Date"; Date) //For Internal Logic
        {
            Caption = 'Creation Date', Locked = true;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}