table 50134 "Service Inquiry Line"
{
    Caption = 'Service Line';
    LookupPageId = 5904;
    DrillDownPageId = 5904;
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; Enum "Service Document Type")
        {
            Caption = 'Document Type';
        }

        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            Editable = false;
        }

        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation =
                if ("Document Type" = filter(Quote | Order | Invoice | "Credit Memo")) "Service Header"."No." where("Document Type" = field("Document Type"))
            else
            if ("Document Type" = const("Posted Shipment")) "Service Shipment Header"."No." where("No." = field("Document No."))
            else
            if ("Document Type" = const("Posted Invoice")) "Service Invoice Header"."No." where("No." = field("Document No."))
            else
            if ("Document Type" = const("Posted Credit Memo")) "Service Cr.Memo Header"."No." where("No." = field("Document No."));
        }

        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(5; Type; Enum "Service Line Type")
        {
            Caption = 'Type';
        }

        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation =
                if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const(Cost)) "Service Cost";
        }

        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }

        field(8; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            TableRelation = if (Type = const(Item)) "Inventory Posting Group";
            Editable = false;
        }

        field(11; Description; Text[50])
        {
            Caption = 'Description';
        }

        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }

        field(13; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }

        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }

        field(16; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(17; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice';
            DecimalPlaces = 0 : 5;
        }

        field(18; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';
            DecimalPlaces = 0 : 5;
        }

        field(22; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            AutoFormatType = 2;
            //AutoFormatExpression = "Currency Code";
        }

        field(23; "Unit Cost (LCY)"; Decimal)
        {
            Caption = 'Unit Cost (LCY)';
            AutoFormatType = 2;
        }

        field(25; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
        }

        field(28; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            AutoFormatType = 1;
            //AutoFormatExpression = "Currency Code";
        }

        field(29; Amount; Decimal)
        {
            Caption = 'Amount';
            Editable = false;
            AutoFormatType = 1;
            //AutoFormatExpression = "Currency Code";
        }

        field(30; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            Editable = false;
            AutoFormatType = 1;
            //AutoFormatExpression = "Currency Code";
        }

        field(32; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }

        field(34; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
        }

        field(35; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
        }

        field(36; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0 : 5;
        }

        field(37; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0 : 5;
        }

        field(38; "Appl.-to Item Entry"; Integer)
        {
            Caption = 'Appl.-to Item Entry';
        }

        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }

        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }

        field(42; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
            Editable = false;
        }

        field(45; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job."No." where("Bill-to Customer No." = field("Bill-to Customer No."));
        }

        field(46; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }

        field(47; "Job Line Type"; Option)
        {
            Caption = 'Job Line Type';
            OptionMembers = " ",Schedule,Contract,"Both Schedule and Contract";
            OptionCaption = ' ,Schedule,Contract,Both Schedule and Contract';
        }

        field(52; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
        }

        field(57; "Outstanding Amount"; Decimal)
        {
            Caption = 'Outstanding Amount';
            Editable = false;
            AutoFormatType = 1;
            //AutoFormatExpression = "Currency Code";
        }

        field(58; "Qty. Shipped Not Invoiced"; Decimal)
        {
            Caption = 'Qty. Shipped Not Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(59; "Shipped Not Invoiced"; Decimal)
        {
            Caption = 'Shipped Not Invoiced';
            Editable = false;
            AutoFormatType = 1;
            //AutoFormatExpression = "Currency Code";
        }

        field(60; "Quantity Shipped"; Decimal)
        {
            Caption = 'Quantity Shipped';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(61; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(63; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
        }

        field(64; "Shipment Line No."; Integer)
        {
            Caption = 'Shipment Line No.';
            Editable = false;
        }

        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
            Editable = false;
        }

        field(69; "Inv. Discount Amount"; Decimal)
        {
            Caption = 'Inv. Discount Amount';
            Editable = false;
            AutoFormatType = 1;
            //AutoFormatExpression = "Currency Code";
        }

        field(74; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }

        field(75; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }

        field(77; "VAT Calculation Type"; Enum "Tax Calculation Type")
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
        }

        field(78; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }

        field(79; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }

        field(80; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            Editable = false;
            TableRelation = "Service Line"."Line No." where("Document Type" = field("Document Type"),
                                                            "Document No." = field("Document No."));
        }

        field(81; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }

        field(82; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }

        field(83; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }

        field(85; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }

        field(86; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }

        field(87; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }

        field(89; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }

        field(90; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }

        field(91; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            Editable = false;
        }

        field(92; "Outstanding Amount (LCY)"; Decimal)
        {
            Caption = 'Outstanding Amount (LCY)';
            Editable = false;
            AutoFormatType = 1;
        }

        field(93; "Shipped Not Invoiced (LCY)"; Decimal)
        {
            Caption = 'Shipped Not Invoiced (LCY)';
            Editable = false;
            AutoFormatType = 1;
        }

        field(95; "Reserved Quantity"; Decimal)
        {
            Caption = 'Reserved Quantity';
            /* FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 5;
            CalcFormula = - Sum("Reservation Entry".Quantity
                                where("Source ID" = field("Document No."),
                                      "Source Ref. No." = field("Line No."),
                                      "Source Type" = const(5902),
                                      "Source Subtype" = field("Document Type"),
                                      "Reservation Status" = const(Reservation))); */
        }

        field(96; Reserve; Option)
        {
            Caption = 'Reserve';
            OptionMembers = Never,Optional,Always;
            OptionCaption = 'Never,Optional,Always';
        }

        field(99; "VAT Base Amount"; Decimal)
        {
            Caption = 'VAT Base Amount';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
        }

        field(100; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";
        }

        field(101; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }

        field(103; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
        }

        field(104; "VAT Difference"; Decimal)
        {
            Caption = 'VAT Difference';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
        }

        field(105; "Inv. Disc. Amount to Invoice"; Decimal)
        {
            Caption = 'Inv. Disc. Amount to Invoice';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
        }

        field(106; "VAT Identifier"; Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }

        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("No."));
        }

        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
        }

        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            InitValue = 1;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation =
                if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            if (Type = const(Resource)) "Resource Unit of Measure".Code where("Resource No." = field("No."))
            else
            "Unit of Measure";

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
            end;
        }

        field(5415; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }

        field(5416; "Outstanding Qty. (Base)"; Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(5417; "Qty. to Invoice (Base)"; Decimal)
        {
            Caption = 'Qty. to Invoice (Base)';
            DecimalPlaces = 0 : 5;
        }

        field(5418; "Qty. to Ship (Base)"; Decimal)
        {
            Caption = 'Qty. to Ship (Base)';
            DecimalPlaces = 0 : 5;
        }

        field(5458; "Qty. Shipped Not Invd. (Base)"; Decimal)
        {
            Caption = 'Qty. Shipped Not Invd. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(5460; "Qty. Shipped (Base)"; Decimal)
        {
            Caption = 'Qty. Shipped (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(5461; "Qty. Invoiced (Base)"; Decimal)
        {
            Caption = 'Qty. Invoiced (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(5495; "Reserved Qty. (Base)"; Decimal)
        {
            Caption = 'Reserved Qty. (Base)';
            /* FieldClass = FlowField;
            Editable = false;
            DecimalPlaces = 0 : 5;
            CalcFormula = - Sum("Reservation Entry"."Quantity (Base)"
                                where("Source ID" = field("Document No."),
                                      "Source Ref. No." = field("Line No."),
                                      "Source Type" = const(5902),
                                      "Source Subtype" = field("Document Type"),
                                      "Reservation Status" = const(Reservation))); */
        }

        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
            Editable = false;
        }

        field(5702; "Substitution Available"; Boolean)
        {
            Caption = 'Substitution Available';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = exist("Item Substitution"
                                where(Type = const(Item),
                                      "No." = field("No."),
                                      "Substitute Type" = const(Item)));
        }

        field(5709; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }

        field(5710; Nonstock; Boolean)
        {
            Caption = 'Nonstock';
            Editable = false;
        }

        field(5712; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            //TableRelation = "Product Group".Code where("Item Category Code" = field("Item Category Code"));
        }

        field(5752; "Completely Shipped"; Boolean)
        {
            Caption = 'Completely Shipped';
            Editable = false;
        }

        field(5811; "Appl.-from Item Entry"; Integer)
        {
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
            end;
        }

        field(5902; "Service Item No."; Code[20])
        {
            Caption = 'Service Item No.';
            TableRelation = "Service Item"."No.";
        }

        field(5903; "Appl.-to Service Entry"; Integer)
        {
            Caption = 'Appl.-to Service Entry';
            Editable = false;
        }

        field(5904; "Service Item Line No."; Integer)
        {
            Caption = 'Service Item Line No.';
            TableRelation = "Service Item Line"."Line No." where("Document Type" = field("Document Type"),
                                                                 "Document No." = field("Document No."));
        }

        field(5905; "Service Item Serial No."; Code[20])
        {
            Caption = 'Service Item Serial No.';
        }

        field(5906; "Service Item Line Description"; Text[100])
        {
            Caption = 'Service Item Line Description';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Service Item Line".Description
                                 where("Document Type" = field("Document Type"),
                                       "Document No." = field("Document No."),
                                       "Line No." = field("Service Item Line No.")));
        }

        field(5907; "Serv. Price Adjmt. Gr. Code"; Code[10])
        {
            Caption = 'Serv. Price Adjmt. Gr. Code';
            TableRelation = "Service Price Adjustment Group";
            Editable = false;
        }

        field(5908; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }

        field(5909; "Order Date"; Date)
        {
            Caption = 'Order Date';
            Editable = false;
        }

        field(5916; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
            Editable = false;
        }

        field(5917; "Qty. to Consume"; Decimal)
        {
            Caption = 'Qty. to Consume';
            DecimalPlaces = 0 : 5;
            BlankZero = true;
        }

        field(5918; "Quantity Consumed"; Decimal)
        {
            Caption = 'Quantity Consumed';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(5919; "Qty. to Consume (Base)"; Decimal)
        {
            Caption = 'Qty. to Consume (Base)';
            DecimalPlaces = 0 : 5;
            BlankZero = true;
        }

        field(5920; "Qty. Consumed (Base)"; Decimal)
        {
            Caption = 'Qty. Consumed (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(5928; "Service Price Group Code"; Code[10])
        {
            Caption = 'Service Price Group Code';
            TableRelation = "Service Price Group";
        }

        field(5929; "Fault Area Code"; Code[10])
        {
            Caption = 'Fault Area Code';
            TableRelation = "Fault Area";
        }

        field(5930; "Symptom Code"; Code[10])
        {
            Caption = 'Symptom Code';
            TableRelation = "Symptom Code";
        }

        field(5931; "Fault Code"; Code[10])
        {
            Caption = 'Fault Code';
            TableRelation = "Fault Code".Code where("Fault Area Code" = field("Fault Area Code"),
                                                    "Symptom Code" = field("Symptom Code"));
        }

        field(5932; "Resolution Code"; Code[10])
        {
            Caption = 'Resolution Code';
            TableRelation = "Resolution Code";
        }

        field(5933; "Exclude Warranty"; Boolean)
        {
            Caption = 'Exclude Warranty';
        }

        field(5934; Warranty; Boolean)
        {
            Caption = 'Warranty';
            Editable = false;
        }

        field(5936; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "Service Contract Header"."Contract No." where("Contract Type" = const(Contract));

            trigger OnValidate()
            var
                DestDocType: Text;
            begin
            end;
        }

        field(5938; "Contract Disc. %"; Decimal)
        {
            Caption = 'Contract Disc. %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            Editable = false;
        }

        field(5939; "Warranty Disc. %"; Decimal)
        {
            Caption = 'Warranty Disc. %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            Editable = false;
        }

        field(5965; "Component Line No."; Integer)
        {
            Caption = 'Component Line No.';
        }

        field(5966; "Spare Part Action"; Option)
        {
            Caption = 'Spare Part Action';
            OptionMembers = " ",Permanent,Temporary,"Component Replaced","Component Installed";
            OptionCaption = ' ,Permanent,Temporary,Component Replaced,Component Installed';
        }

        field(5967; "Fault Reason Code"; Code[10])
        {
            Caption = 'Fault Reason Code';
            TableRelation = "Fault Reason Code";

            trigger OnValidate()
            var
                NewWarranty: Boolean;
                OldExcludeContractDiscount: Boolean;
            begin
            end;
        }

        field(5968; "Replaced Item No."; Code[20])
        {
            Caption = 'Replaced Item No.';
            TableRelation =
                if ("Replaced Item Type" = const(Item)) Item
            else
            if ("Replaced Item Type" = const("Service Item")) "Service Item";
        }

        field(5969; "Exclude Contract Discount"; Boolean)
        {
            Caption = 'Exclude Contract Discount';
        }

        field(5970; "Replaced Item Type"; Option)
        {
            Caption = 'Replaced Item Type';
            OptionMembers = " ","Service Item",Item;
            OptionCaption = ' ,Service Item,Item';
        }

        field(5994; "Price Adjmt. Status"; Option)
        {
            Caption = 'Price Adjmt. Status';
            OptionMembers = " ",Adjusted,Modified;
            OptionCaption = ' ,Adjusted,Modified';
            Editable = false;
        }

        field(5997; "Line Discount Type"; Option)
        {
            Caption = 'Line Discount Type';
            OptionMembers = " ","Warranty Disc.","Contract Disc.","Line Disc.",Manual;
            OptionCaption = ' ,Warranty Disc.,Contract Disc.,Line Disc.,Manual';
            Editable = false;
        }

        field(5999; "Copy Components From"; Option)
        {
            Caption = 'Copy Components From';
            OptionMembers = None,"Item BOM","Old Service Item","Old Serv.Item w/o Serial No.";
            OptionCaption = 'None,Item BOM,Old Service Item,Old Serv.Item w/o Serial No.';
        }

        field(6608; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";

            trigger OnValidate()
            var
                ReturnReason: Record "Return Reason";
            begin
            end;
        }

        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }

        field(7002; "Customer Disc. Group"; Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }

        field(50050; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
        }

        field(50051; "Product Series"; Code[20])
        {
            Caption = 'Product Series';
        }

        field(50297; TotalItemQty; Decimal)
        {
            Caption = 'Total Quantity (Item)';
        }

        field(50298; TotalResourceQty; Decimal)
        {
            Caption = 'Total Quantity (Resource)';
        }

        field(50299; TotalCostQty; Decimal)
        {
            Caption = 'Total Quantity (Cost)';
        }

        field(50300; TotalGLAccountQty; Decimal)
        {
            Caption = 'Total Quantity (G/L Account)';
        }

        field(50301; TotalAmt; Decimal)
        {
            Caption = 'Total Amount';
        }

        field(50302; TotalAmtVAT; Decimal)
        {
            Caption = 'Total Amount Include VAT';
        }

        field(50303; "Original Order No."; Code[20])
        {
            Caption = 'Original Order No.';
            TableRelation =
                if ("Document Type" = filter("Posted Shipment" | "Posted Invoice" | "Posted Credit Memo"))
                    "Service Header"."No." where("Document Type" = const(Order), "No." = field("Document No."))
            else
            if ("Document Type" = filter(Quote | Order | Invoice | "Credit Memo"))
                    "Service Header"."No." where("Document Type" = field("Document Type"), "No." = field("Document No."));
        }

        field(50313; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
        }

        field(50314; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
        }

        field(50315; "Shortcut Dimension 5 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            CaptionClass = '1,2,5';
        }

        field(50316; "Shortcut Dimension 6 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            CaptionClass = '1,2,6';
        }

        field(50317; "Shortcut Dimension 7 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            CaptionClass = '1,2,7';
        }

        field(50318; "Shortcut Dimension 8 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            CaptionClass = '1,2,8';
        }

        field(50321; "Fault Area Description"; Text[100])
        {
            Caption = 'Fault Area';
            FieldClass = FlowField;
            CalcFormula = lookup("Fault Area".Description where(Code = field("Fault Area Code")));
        }

        field(50322; "Symptom Description"; Text[100])
        {
            Caption = 'Symptom';
            FieldClass = FlowField;
            CalcFormula = lookup("Symptom Code".Description where(Code = field("Symptom Code")));
        }

        field(50323; "Fault Description"; Text[80])
        {
            Caption = 'Fault';
            FieldClass = FlowField;
            CalcFormula = lookup("Fault Code".Description
                                 where("Fault Area Code" = field("Fault Area Code"),
                                       "Symptom Code" = field("Symptom Code"),
                                       Code = field("Fault Code")));
        }

        field(50324; "Resolution Description"; Text[80])
        {
            Caption = 'Resolutionςure';
            FieldClass = FlowField;
            CalcFormula = lookup("Resolution Code".Description where(Code = field("Resolution Code")));
        }

        field(50330; "Service Order Type"; Code[10])
        {
            Caption = 'Service Order Type';
            TableRelation = "Service Order Type";
        }

        field(50331; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Pending,"In Process",Finished,"On Hold";
            OptionCaption = 'Pending,In Process,Finished,On Hold';
        }

        field(50332; "Actual Response Time (Hours)"; Decimal)
        {
            Caption = 'Actual Response Time (Hours)';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            Editable = false;
        }

        field(50333; "Service Time (Hours)"; Decimal)
        {
            Caption = 'Service Time (Hours)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }

        field(50334; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }

        field(50335; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
        }

        field(50336; "Finishing Date"; Date)
        {
            Caption = 'Finishing Date';
        }

        field(50337; "Finishing Time"; Time)
        {
            Caption = 'Finishing Time';
        }

        field(50340; "Total Cost"; Decimal)
        {
            Caption = 'Total Unit Cost (LCY)';
            AutoFormatType = 2;
        }

        field(50341; "Repair Status Code"; Code[10])
        {
            Caption = 'Repair Status Code';
            TableRelation = "Repair Status";
        }
    }

    keys
    {
        key(PK; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}