
page 50131 "Service Engine"
{
    PageType = Document;
    SourceTable = "Service Item";
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = true;
    Caption = 'Service Engine';

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field(TheWorkDate; TheWorkDate)
                {
                    ApplicationArea = All;
                    Caption = 'Work Date';
                    Editable = false;
                }
                field(SerialNoFilter; SerialNoFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Serial No. Filter';
                    trigger OnValidate()
                    begin
                        Rec.SetFilter("Serial No.", SerialNoFilter);
                        CurrPage.Update(false);
                        Refresh();
                        //if Rec.IsEmpty() then
                        //FindNothing();
                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                }
                field(Address; Rec.Address) { ApplicationArea = All; }
                field("Address 2"; Rec."Address 2") { ApplicationArea = All; }
                field("Phone No."; Rec."Phone No.") { ApplicationArea = All; }
                field("Phone No. (Service)"; Rec."Phone No. (Service)") { ApplicationArea = All; }
                field("Inspection In-Charge (Dept.)"; Rec."Inspection In-Charge (Dept.)") { ApplicationArea = All; }
                field("Inspection In-Charge (Person)"; Rec."Inspection In-Charge (Person)") { ApplicationArea = All; }
            }

            repeater(List)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Service Item No.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        OpenServItem: Record "Service Item";
                    begin
                        OpenServItem.Reset();
                        OpenServItem.SetRange("No.", Rec."No.");
                        if OpenServItem.FindFirst() then
                            Page.RunModal(Page::"Service Item Card", OpenServItem);
                    end;
                }
                field("Service Item Type"; Rec."Service Item Type")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecItem: Record 27;
                    begin
                        Clear(RecItem);
                        RecItem.SetRange("No.", Rec."Item No.");
                        if RecItem.FindFirst() then
                            Page.RunModal(Page::"Item Card", RecItem);
                    end;
                }
                field("Product Series"; Rec."Product Series")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Warranty Starting Date (Labor)"; Rec."Warranty Starting Date (Labor)")
                {
                    ApplicationArea = All;
                }
                field("Warranty Ending Date (Labor)"; Rec."Warranty Ending Date (Labor)")
                {
                    ApplicationArea = All;
                }
                field("Warranty Starting Date (Parts)"; Rec."Warranty Starting Date (Parts)")
                {
                    ApplicationArea = All;
                }
                field("Warranty Ending Date (Parts)"; Rec."Warranty Ending Date (Parts)")
                {
                    ApplicationArea = All;
                }
            }

            group(Shipment)
            {
                Caption = 'Service Shipment';
                ShowCaption = false;
                part(SbfShptItemLine; "Serv. Shpt. Item Line Subform")
                {
                    SubPageLink = "Service Item No." = field("No.");
                    SubPageView = sorting("No.", "Line No.") order(Descending);
                }
            }

            group(ServiceOrder)
            {
                Caption = 'Service Order';
                ShowCaption = false;
                part(SbfServItemLine; "Serv. Item Line Subform")
                {
                    SubPageLink = "Service Item No." = field("No.");
                    SubPageView = sorting("Document Type", "Document No.", "Line No.") ORDER(Descending) WHERE("Document Type" = const(Order));
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(Processing)
        {
            action(MRJCreateServOrder)
            {
                ApplicationArea = All;
                Caption = 'Create &Order';
                Image = Document;
                Visible = NotEmpty;
                trigger OnAction()
                begin
                    CreateServOrder();
                end;
            }
            action(OpenServiceContracts)
            {
                ApplicationArea = All;
                Caption = 'Service &Contracts';
                Image = Document;
                Visible = NotEmpty;
                RunObject = Page "Service Contract List";
                RunPageLink = "Contract Type" = const(Contract), "Customer No." = field("Customer No.");
            }
        }
    }

    trigger OnOpenPage()
    begin
        SrvMgtSetup.Get();
        TheWorkDate := WorkDate();
        SerialNoFilter := Rec.GetFilter("Serial No.");
        Rec.Reset();
        Rec.SetFilter("No.", GetServItemNoFilter());
        Rec.SetFilter("Serial No.", SerialNoFilter);
        Refresh();
        //if Rec.IsEmpty() then
        //FindNothing();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields(Name, Address, "Address 2", "Phone No.", "Service Contracts");
        Refresh();
    end;

    local procedure Refresh()
    var
        TmpAmount: Decimal;
    begin
        NotEmpty := (not Rec.IsEmpty()) and (Rec."No." <> '');

        // Update subpages
        if NotEmpty then begin
            CurrPage.SbfShptItemLine.Page.Relink(Rec."No.", ContractNoFilter, FaultAreaFilter, SymptomFilter, FaultFilter, ResolutionFilter);
            CurrPage.SbfServItemLine.Page.Relink(Rec."No.", ContractNoFilter);
        end else begin
            CurrPage.SbfShptItemLine.Page.Relink('', ContractNoFilter, FaultAreaFilter, SymptomFilter, FaultFilter, ResolutionFilter);
            CurrPage.SbfServItemLine.Page.Relink('', ContractNoFilter);
        end;

        // Warranty flags
        InWarrantyPeriodParts := false;
        InWarrantyPeriodLabor := false;
        if NotEmpty then begin
            if (TheWorkDate >= Rec."Warranty Starting Date (Parts)") and
               (TheWorkDate <= Rec."Warranty Ending Date (Parts)") then
                InWarrantyPeriodParts := true;
            if (TheWorkDate >= Rec."Warranty Starting Date (Labor)") and
               (TheWorkDate <= Rec."Warranty Ending Date (Labor)") then
                InWarrantyPeriodLabor := true;
        end;

        // Date warning bands
        DateWarning := '';
        ShowDateWarningGreen := false;
        ShowDateWarningYellow := false;
        ShowDateWarningRed := false;
        if NotEmpty then begin
            ServItemLine.Reset();
            ServItemLine.SetRange("Document Type", ServItemLine."Document Type"::Order);
            ServItemLine.SetRange("Service Item No.", Rec."No.");
            if ServItemLine.FindLast() then
                if ServHeader.Get(ServItemLine."Document Type", ServItemLine."Document No.") then begin
                    DateWarning := StrSubstNo(TEST0006, TheWorkDate - ServHeader."Order Date");
                    if TheWorkDate < CalcDate(SrvMgtSetup."Warning Date Range 1", ServHeader."Order Date") then
                        ShowDateWarningGreen := true
                    else
                        if TheWorkDate < CalcDate(SrvMgtSetup."Warning Date Range 2", ServHeader."Order Date") then
                            ShowDateWarningYellow := true
                        else
                            ShowDateWarningRed := true;
                end;
        end;

        // Uncollected receivables
        UncRecCount := 0;
        UncRecAmount := 0;
        ShowUncRec := false;
        if NotEmpty then begin
            CustLedgerEntry.Reset();
            CustLedgerEntry.SetRange("Customer No.", Rec."Customer No.");
            CustLedgerEntry.SetFilter("Due Date", '<%1', TheWorkDate);
            UncRecCount := CustLedgerEntry.Count();
            if CustLedgerEntry.FindSet() then begin
                ShowUncRec := true;
                repeat
                    CustLedgerEntry.CalcFields(Amount);
                    UncRecAmount := UncRecAmount + CustLedgerEntry.Amount;
                until CustLedgerEntry.Next() = 0;
            end;
        end;
        UncRecAmount := Round(UncRecAmount, 1, '=');
        UncRecText := StrSubstNo('%1(%2)', UncRecAmount, UncRecCount);
    end;

    procedure CreateServOrder()
    var
        ServShptItemLine: Record 5989;
        ServHeaderInst: Record 5900;
        ServShptHeader: Record 5990;
        ServItemLineInst: Record 5901;
        ServLineInst: Record 5902;
        ServShptLine: Record 5991;
    begin
        SrvMgtSetup.Get();
        if not Dialog.Confirm(TEST0002, true) then
            exit;
        if NotEmpty then begin
            Clear(ServShptItemLine);
            CurrPage.SbfShptItemLine.Page.GetRecord(ServShptItemLine);
            Clear(ServHeaderInst);
            ServHeaderInst.Init();
            ServHeaderInst.Validate("Document Type", ServHeaderInst."Document Type"::Order);
            ServHeaderInst.Insert(true);
            ServHeaderInst.Validate("Customer No.", Rec."Customer No.");
            if ServShptHeader.Get(ServShptItemLine."No.") then begin
                if SrvMgtSetup."Serv Ord Reservation Location" <> '' then
                    ServHeaderInst.Validate("Location Code", SrvMgtSetup."Serv Ord Reservation Location")
                else begin
                    ServHeaderInst.Validate("Location Code", ServShptHeader."Location Code");
                    ServHeaderInst.Validate("Bin Code", ServShptHeader."Bin Code");
                end;
            end;
            ServHeaderInst.Validate("Shortcut Dimension 1 Code", ServShptHeader."Shortcut Dimension 1 Code");
            ServHeaderInst.Validate("Shortcut Dimension 2 Code", ServShptHeader."Shortcut Dimension 2 Code");
            ServHeaderInst.Modify(true);

            Clear(ServItemLineInst);
            ServItemLineInst.Init();
            ServItemLineInst.Validate("Document Type", ServHeaderInst."Document Type");
            ServItemLineInst.Validate("Document No.", ServHeaderInst."No.");
            ServItemLineInst.Validate("Service Item No.", Rec."No.");
            ServItemLineInst.Validate("Line No.", 10000);
            ServItemLineInst.Insert(true);
            ServItemLineInst.Validate("Fault Area Code", FaultAreaFilter);
            ServItemLineInst.Validate("Symptom Code", SymptomFilter);
            ServItemLineInst.Validate("Fault Code", FaultFilter);
            ServItemLineInst.Validate("Resolution Code", ResolutionFilter);
            ServItemLineInst.Modify(true);

            if ServShptItemLine."No." <> '' then
                if Dialog.Confirm(TEST0007, true) then begin
                    Clear(ServLineInst);
                    Clear(ServShptLine);
                    ServShptLine.SetRange("Document No.", ServShptItemLine."No.");
                    if ServShptLine.FindSet() then
                        repeat
                            ServLineInst.Init();
                            ServLineInst."Document Type" := ServLineInst."Document Type"::Order;
                            ServLineInst."Document No." := ServHeaderInst."No.";
                            ServLineInst."Service Item Line No." := 10000;
                            ServLineInst."Line No." := ServShptLine."Line No.";
                            ServLineInst.Insert(true);
                            ServLineInst.Validate(Type, ServShptLine.Type);
                            ServLineInst.Validate("No.", ServShptLine."No.");
                            ServLineInst.Validate(Description, ServShptLine.Description);
                            if (ServShptLine.Type <> ServShptLine.Type::" ") and (ServShptLine."No." <> '') then begin
                                ServLineInst.Validate("Work Type Code", ServShptLine."Work Type Code");
                                ServLineInst.Validate("Variant Code", ServShptLine."Variant Code");
                                ServLineInst.Validate("Unit of Measure Code", ServShptLine."Unit of Measure Code");
                                ServLineInst.Validate(Quantity, ServShptLine.Quantity);
                                ServLineInst.Validate("Unit Price", ServShptLine."Unit Price");
                            end;
                            ServLineInst.Modify(true);
                        until ServShptLine.Next() = 0;
                end;
        end else begin
            Clear(ServHeaderInst);
            ServHeaderInst.Init();
            ServHeaderInst.Validate("Document Type", ServHeaderInst."Document Type"::Order);
            ServHeaderInst.Insert(true);
        end;
        Commit();
        if not Dialog.Confirm(StrSubstNo(TEST0004, ServHeaderInst."No."), true) then
            exit;
        Page.RunModal(Page::"Service Order", ServHeaderInst);
    end;

    /* local procedure FindNothing()
    var
        ServHeaderInst: Record 5900;
    begin
        if not Dialog.Confirm(TEST0001, true) then
            exit;
        Clear(ServHeaderInst);
        ServHeaderInst.Init();
        ServHeaderInst.Validate("Document Type", ServHeaderInst."Document Type"::Quote);
        ServHeaderInst.Insert(true);
        Commit();
        if not Dialog.Confirm(StrSubstNo(TEST0005, ServHeaderInst."No."), true) then
            exit;
        Page.RunModal(Page::"Service Quote", ServHeaderInst);
    end; */

    local procedure GetServItemNoFilter(): Text
    var
        ServItem: Record 5940;
        ServItemTmp: Record 5940 temporary;
        FilterBuilder: Text;
    begin
        FilterBuilder := '';
        if PhoneNoFilter = '' then
            exit('');

        /*
        Clear(ServPhoneBookTmp);
        ServPhoneBookTmp.DeleteAll();
        ServItem.Reset();
        if ServItem.FindSet() then
            repeat
                // Copy all existing phone book entries for this service item into temp
                ServPhoneBook.Reset();
                ServPhoneBook.SetRange(Type, ServPhoneBook.Type::"Service Item");
                ServPhoneBook.SetRange("No.", ServItem."No.");
                if ServPhoneBook.FindSet() then
                    repeat
                        ServPhoneBookTmp.Init();
                        ServPhoneBookTmp.TransferFields(ServPhoneBook);
                        ServPhoneBookTmp.Insert();
                    until ServPhoneBook.Next() = 0;

                // Add derived phone entries from Service Item itself
                ServPhoneBookTmp.Init();
                ServPhoneBookTmp.Type := ServPhoneBookTmp.Type::"Service Item";
                ServPhoneBookTmp."No." := ServItem."No.";
                ServPhoneBookTmp."Line No." := 1;
                ServItem.CalcFields("Phone No.");
                ServPhoneBookTmp."Phone No." := ServItem."Phone No.";
                ServPhoneBookTmp.Insert();

                ServPhoneBookTmp."Line No." := 2;
                ServPhoneBookTmp."Phone No." := ServItem."Phone No. (Service)";
                ServPhoneBookTmp.Insert();
            until ServItem.Next() = 0;

        ServPhoneBookTmp.Reset();
        ServPhoneBookTmp.SetFilter("Phone No.", PhoneNoFilter);
        if ServPhoneBookTmp.Count() = 0 then begin
            // remove '-' and try again
            if ServPhoneBookTmp.FindSet() then
                repeat
                    ServPhoneBookTmp."Phone No." := DelChr(ServPhoneBookTmp."Phone No.", '=', '-');
                    ServPhoneBookTmp.Modify();
                until ServPhoneBookTmp.Next() = 0;
            ServPhoneBookTmp.Reset();
            ServPhoneBookTmp.SetFilter("Phone No.", PhoneNoFilter);
        end;

        Clear(ServItemTmp);
        ServItemTmp.DeleteAll();
        if ServPhoneBookTmp.FindSet() then
            repeat
                ServItemTmp.Init();
                ServItemTmp."No." := ServPhoneBookTmp."No.";
                if ServItemTmp.Insert() then;
            until ServPhoneBookTmp.Next() = 0;
        */

        if ServItemTmp.FindSet() then
            repeat
                if FilterBuilder = '' then
                    FilterBuilder := ServItemTmp."No."
                else
                    FilterBuilder := FilterBuilder + '|' + ServItemTmp."No."; // use '|' list for AL
            until ServItemTmp.Next() = 0;

        if FilterBuilder = '' then
            exit('>1&<0'); // empty-result filter
        exit(FilterBuilder);
    end;

    var
        SrvMgtSetup: Record "Service Mgt. Setup";
        TheWorkDate: Date;
        PhoneNoFilter: Text[250];
        SerialNoFilter: Text[250];
        ContractNoFilter: Text[250];
        InWarrantyPeriodParts: Boolean;
        InWarrantyPeriodLabor: Boolean;
        DateWarning: Text[80];
        NotEmpty: Boolean;
        ServItemLine: Record 5901;
        ServHeader: Record 5900;
        UncRecCount: Integer;
        UncRecAmount: Decimal;
        CustLedgerEntry: Record 21;
        FaultAreaFilter: Code[10];
        SymptomFilter: Code[10];
        FaultFilter: Code[10];
        ResolutionFilter: Code[10];
        ProductSeriesFilter: Text[250];
        ShowDateWarningGreen: Boolean;
        ShowDateWarningYellow: Boolean;
        ShowDateWarningRed: Boolean;
        ShowUncRec: Boolean;
        UncRecText: Text[100];
        TEST0002: Label 'Do you want to create Service Order?';
        TEST0004: Label 'Service Order ''%1'' created successfully, do you want to open?';
        TEST0006: Label '%1 days after last date.';
        TEST0007: Label 'Do you want to copy Service Line?';
}