table 50134 "Service Inquiry Line"
{
    Caption = 'Service Line';
    //LookupPageId = 5904;
    //DrillDownPageId = 5904;
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
            if ("Document Type" = const("Posted Invoice")) "Service Invoice Header"."No." where("No." = field("Document No."))
            else if ("Document Type" = const("Posted Credit Memo")) "Service Cr.Memo Header"."No." where("No." = field("Document No."));
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
            else if (Type = const("G/L Account")) "G/L Account"
            else if (Type = const(Item)) Item
            else if (Type = const(Resource)) Resource
            else if (Type = const(Cost)) "Service Cost";
        }

        field(11; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
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
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }

        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            CaptionClass = '1,2,2';
        }
        field(52; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
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
            AutoFormatExpression = "Currency Code";
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
        field(104; "VAT Difference"; Decimal)
        {
            Caption = 'VAT Difference';
            Editable = false;
            AutoFormatType = 1;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID', Locked = true;
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        /* field(5415; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
        } */
        field(5709; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(5902; "Service Item No."; Code[20])
        {
            Caption = 'Service Item No.';
            TableRelation = "Service Item"."No.";
        }
        field(5904; "Service Item Line No."; Integer)
        {
            Caption = 'Service Item Line No.';
        }
        field(5905; "Service Item Serial No."; Code[20])
        {
            Caption = 'Service Item Serial No.';
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
        field(5934; Warranty; Boolean)
        {
            Caption = 'Warranty';
            Editable = false;
        }
        field(5936; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "Service Contract Header"."Contract No." where("Contract Type" = const(Contract));
        }
        field(5939; "Warranty Disc. %"; Decimal)
        {
            Caption = 'Warranty Disc. %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            Editable = false;
        }
        field(5967; "Fault Reason Code"; Code[10])
        {
            Caption = 'Fault Reason Code';
            TableRelation = "Fault Reason Code";
        }
        field(50050; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
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
            Editable = false;
            CaptionClass = '1,2,3';
        }
        field(50314; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            Editable = false;
            CaptionClass = '1,2,4';
        }
        field(50315; "Shortcut Dimension 5 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            Editable = false;
            CaptionClass = '1,2,5';
        }
        field(50316; "Shortcut Dimension 6 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            Editable = false;
            CaptionClass = '1,2,6';
        }
        field(50317; "Shortcut Dimension 7 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 7 Code';
            Editable = false;
            CaptionClass = '1,2,7';
        }
        field(50318; "Shortcut Dimension 8 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 8 Code';
            Editable = false;
            CaptionClass = '1,2,8';
        }
        field(50330; "Service Order Type"; Code[10])
        {
            Caption = 'Service Order Type';
            TableRelation = "Service Order Type";
        }
        field(50340; "Total Unit Cost (LCY)"; Decimal)
        {
            Caption = 'Total Unit Cost (LCY)';
            AutoFormatType = 2;
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