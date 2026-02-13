/* 
page 50131 "Service Engine"
{
    PageType = List;
    SourceTable = "Service Item"; // Service Item
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
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
                field(PhoneNoFilter; PhoneNoFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Phone No. Filter';
                    trigger OnValidate()
                    begin
                        Rec.SetFilter("No.", GetServItemNoFilter());
                        CurrPage.Update(false);
                        Refresh();
                        if Rec.IsEmpty() then
                            FindNothing();
                    end;
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
                        if Rec.IsEmpty() then
                            FindNothing();
                    end;
                }
                field(ProductSeriesFilter; ProductSeriesFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Product Series Filter';
                    trigger OnValidate()
                    begin
                        Rec.SetFilter("Product Series", ProductSeriesFilter);
                        CurrPage.Update(false);
                        Refresh();
                        if Rec.IsEmpty() then
                            FindNothing();
                    end;
                }
                field(ContractNoFilter; ContractNoFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Contract No. Filter';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecServContractHeader: Record 5965; // Service Contract Header
                    begin
                        Clear(RecServContractHeader);
                        RecServContractHeader.SetRange("Customer No.", Rec."Customer No.");
                        if Page.RunModal(0, RecServContractHeader) = Action::LookupOK then begin
                            Text := RecServContractHeader."Contract No.";
                            exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        Refresh();
                    end;
                }

                // Date warning visuals (approximation of classic color-coded labels)
                field(DateWarning1; DateWarning)
                {
                    ApplicationArea = All;
                    Caption = '';
                    Editable = false;
                    Visible = ShowDateWarningGreen;
                    Style = Favorable;
                    StyleExpr = ShowDateWarningGreen;
                }
                field(DateWarning2; DateWarning)
                {
                    ApplicationArea = All;
                    Caption = '';
                    Editable = false;
                    Visible = ShowDateWarningYellow;
                    Style = Ambiguous;
                    StyleExpr = ShowDateWarningYellow;
                }
                field(DateWarning3; DateWarning)
                {
                    ApplicationArea = All;
                    Caption = '';
                    Editable = false;
                    Visible = ShowDateWarningRed;
                    Style = Attention;
                    StyleExpr = ShowDateWarningRed;
                }

                field(HaveContractual; Rec."Service Contracts")
                {
                    ApplicationArea = All;
                    Caption = 'Have Contractual';
                    Editable = false;
                }
                field(InWarrantyPeriodLabor; InWarrantyPeriodLabor)
                {
                    ApplicationArea = All;
                    Caption = 'Labor Warranty';
                    Editable = false;
                }
                field(InWarrantyPeriodParts; InWarrantyPeriodParts)
                {
                    ApplicationArea = All;
                    Caption = 'Parts Warranty';
                    Editable = false;
                }
                field(UncRec; UncRecText)
                {
                    ApplicationArea = All;
                    Caption = 'Uncollected';
                    Editable = false;
                    Visible = ShowUncRec;
                    Style = Attention;
                    StyleExpr = ShowUncRec;
                    trigger OnDrillDown()
                    var
                        CustLedgerEntryL: Record 21;
                    begin
                        if UncRecCount = 0 then
                            exit;
                        CustLedgerEntryL.Reset();
                        CustLedgerEntryL.SetRange("Customer No.", Rec."Customer No.");
                        Page.RunModal(Page::"Customer Ledger Entries", CustLedgerEntryL);
                    end;
                }
            }

            repeater(List)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        OpenServItem: Record 5940;
                    begin
                        // Classic FORM.RUNMODAL(Form::"Service Item Card", Rec) -> PAGE.RunModal(Page::"Service Item Card")
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
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Item Description 2"; Rec."Item Description 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Product Series"; Rec."Product Series")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Visible = false;
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
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                }
            }

            // Service Shipment part and filters
            group(Shipment)
            {
                Caption = 'Service Shipment';
                field(FaultAreaFilter; FaultAreaFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Fault Area Filter';
                    TableRelation = "Fault Area";
                    trigger OnValidate()
                    begin
                        FaultFilter := '';
                        CurrPage.SbfShptItemLine.Page.Relink(Rec."No.", ContractNoFilter, FaultAreaFilter, SymptomFilter, FaultFilter, ResolutionFilter);
                    end;
                }
                field(SymptomFilter; SymptomFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Symptom Filter';
                    TableRelation = "Symptom Code";
                    trigger OnValidate()
                    begin
                        FaultFilter := '';
                        CurrPage.SbfShptItemLine.Page.Relink(Rec."No.", ContractNoFilter, FaultAreaFilter, SymptomFilter, FaultFilter, ResolutionFilter);
                    end;
                }
                field(FaultFilter; FaultFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Fault Filter';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FaultCodeSrch: Record 5918;
                        FaultCodeList: Page 5927; // "Fault Codes" list page
                    begin
                        FaultCodeSrch.Reset();
                        FaultCodeSrch.SetFilter("Fault Area Code", FaultAreaFilter);
                        FaultCodeSrch.SetFilter("Symptom Code", SymptomFilter);
                        FaultCodeList.SetTableView(FaultCodeSrch);
                        FaultCodeList.LookupMode(true);
                        if FaultCodeList.RunModal() = Action::LookupOK then begin
                            FaultCodeList.GetRecord(FaultCodeSrch);
                            Text := FaultCodeSrch.Code;
                            exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.SbfShptItemLine.Page.Relink(Rec."No.", ContractNoFilter, FaultAreaFilter, SymptomFilter, FaultFilter, ResolutionFilter);
                    end;
                }
                field(ResolutionFilter; ResolutionFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Resolution Filter';
                    TableRelation = "Resolution Code";
                    trigger OnValidate()
                    begin
                        CurrPage.SbfShptItemLine.Page.Relink(Rec."No.", ContractNoFilter, FaultAreaFilter, SymptomFilter, FaultFilter, ResolutionFilter);
                    end;
                }
                part(SbfShptItemLine; 50132)
                {
                    SubPageLink = "Service Item No." = field("No.");
                    // Original SubFormView: SORTING(No.,"Line No.") ORDER(Descending)
                }
            }

            group(ServiceOrder)
            {
                Caption = 'Service Order';
                part(SbfServItemLine; 50133)
                {
                    SubPageLink = "Service Item No." = field("No.");
                    SubPageView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Descending) WHERE("Document Type" = const(Order));
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
            action(CreateServQuote)
            {
                ApplicationArea = All;
                Caption = 'Create &Quote';
                Image = Quote;
                Visible = NotEmpty;
                trigger OnAction()
                begin
                    CreateServQuote();
                end;
            }
            action(CreateServOrder)
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
        }
        area(Navigation)
        {
            action(OpenServiceContracts)
            {
                ApplicationArea = All;
                Caption = 'Service &Contracts';
                Image = Document;
                Visible = NotEmpty;
                trigger OnAction()
                begin
                    // Original: RunObject=Form 6051 with link Contract Type=CONST(Contract), Customer No.=FIELD(Customer No.)
                    Page.RunModal(6051); // TODO: Replace with correct Page ID/Name and set filters
                end;
            }
            action(OpenRepairItemCard)
            {
                ApplicationArea = All;
                Caption = '&Repair Item Card';
                Image = Card;
                Visible = NotEmpty;
                trigger OnAction()
                begin
                    Page.RunModal(50107, Rec); // TODO: ensure target page exists
                end;
            }
            action(OpenServiceMemo)
            {
                ApplicationArea = All;
                Caption = 'Service &Memo';
                Image = Note;
                Visible = NotEmpty;
                trigger OnAction()
                begin
                    Page.RunModal(50137, Rec); // TODO: ensure target page exists
                end;
            }
            group(ServiceInquiries)
            {
                Caption = 'Service &Inquiries';
                action(OpenServiceInquiry)
                {
                    ApplicationArea = All;
                    Caption = '&Service Inquiry';
                    trigger OnAction()
                    begin
                        Page.RunModal(50140); // TODO: ensure target page exists
                    end;
                }
                action(OpenRepairInquiry)
                {
                    ApplicationArea = All;
                    Caption = 'Service &Repair Inquiry';
                    trigger OnAction()
                    begin
                        Page.RunModal(50108); // TODO
                    end;
                }
                action(OpenContractsInquiry)
                {
                    ApplicationArea = All;
                    Caption = 'Service &Contracts Inquiry';
                    trigger OnAction()
                    begin
                        Page.RunModal(50103); // TODO
                    end;
                }
                action(OpenLendingList)
                {
                    ApplicationArea = All;
                    Caption = '&Lending List';
                    trigger OnAction()
                    begin
                        Page.RunModal(50104); // TODO
                    end;
                }
                action(OpenMemoSearch)
                {
                    ApplicationArea = All;
                    Caption = 'Service &Memo Search';
                    trigger OnAction()
                    begin
                        Page.RunModal(50129); // TODO
                    end;
                }
                action(OpenGrossProfit)
                {
                    ApplicationArea = All;
                    Caption = 'Service &Gross Profit Inquiry';
                    trigger OnAction()
                    begin
                        Page.RunModal(50128); // TODO
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        PBCJPSetup.Get();
        TheWorkDate := WorkDate();
        PhoneNoFilter := Rec.GetFilter("Phone No. (Service)");
        SerialNoFilter := Rec.GetFilter("Serial No.");
        ProductSeriesFilter := Rec.GetFilter("Product Series");
        Rec.Reset();
        Rec.SetFilter("No.", GetServItemNoFilter());
        Rec.SetFilter("Serial No.", SerialNoFilter);
        Rec.SetFilter("Product Series", ProductSeriesFilter);
        Refresh();
        if Rec.IsEmpty() then
            FindNothing();
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
                    if TheWorkDate < CalcDate(PBCJPSetup."Warning Date Range 1", ServHeader."Order Date") then
                        ShowDateWarningGreen := true
                    else
                        if TheWorkDate < CalcDate(PBCJPSetup."Warning Date Range 2", ServHeader."Order Date") then
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

    procedure CreateServQuote()
    var
        ServShptItemLine: Record 5989;
        ServHeaderInst: Record 5900;
        ServShptHeader: Record 5990;
        ServItemLineInst: Record 5901;
        ServLineInst: Record 5902;
        ServShptLine: Record 5991;
    begin
        if not Dialog.Confirm(TEST0003, true) then
            exit;
        if NotEmpty then begin
            Clear(ServShptItemLine);
            CurrPage.SbfShptItemLine.Page.GetRecord(ServShptItemLine);
            Clear(ServHeaderInst);
            ServHeaderInst.Init();
            ServHeaderInst.Validate("Document Type", ServHeaderInst."Document Type"::Quote);
            ServHeaderInst.Insert(true);
            ServHeaderInst.Validate("Customer No.", Rec."Customer No.");
            if ServShptHeader.Get(ServShptItemLine."No.") then begin
                if PBCJPSetup."Serv Ord Reservation Location" <> '' then
                    ServHeaderInst.Validate("Location Code", PBCJPSetup."Serv Ord Reservation Location")
                else begin
                    ServHeaderInst.Validate("Location Code", ServShptHeader."Location Code");
                    ServHeaderInst.Validate("Bin Code", ServShptHeader."Bin Code");
                end;
            end;
            ServHeaderInst.Validate("Shortcut Dimension 1 Code", ServShptHeader."Shortcut Dimension 1 Code");
            ServHeaderInst.Validate("Shortcut Dimension 2 Code", ServShptHeader."Shortcut Dimension 2 Code");
            ServHeaderInst.Modify(true);
            Commit();

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
            Commit();

            if ServShptItemLine."No." <> '' then
                if Dialog.Confirm(TEST0007, true) then begin
                    Clear(ServLineInst);
                    Clear(ServShptLine);
                    ServShptLine.SetRange("Document No.", ServShptItemLine."No.");
                    if ServShptLine.FindSet() then
                        repeat
                            ServLineInst.Init();
                            ServLineInst."Document Type" := ServLineInst."Document Type"::Quote;
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
            Commit();
        end else begin
            Clear(ServHeaderInst);
            ServHeaderInst.Init();
            ServHeaderInst.Validate("Document Type", ServHeaderInst."Document Type"::Quote);
            ServHeaderInst.Insert(true);
            Commit();
        end;
        if not Dialog.Confirm(StrSubstNo(TEST0005, ServHeaderInst."No."), true) then
            exit;
        Page.RunModal(Page::"Service Quote", ServHeaderInst);
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
        PBCJPSetup.Get();
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
                if PBCJPSetup."Serv Ord Reservation Location" <> '' then
                    ServHeaderInst.Validate("Location Code", PBCJPSetup."Serv Ord Reservation Location")
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

    local procedure FindNothing()
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
    end;

    local procedure GetServItemNoFilter(): Text
    var
        ServItem: Record 5940;
        ServItemTmp: Record 5940 temporary;
        ServPhoneBook: Record 50130;
        ServPhoneBookTmp: Record 50130 temporary;
        FilterBuilder: Text;
    begin
        FilterBuilder := '';
        if PhoneNoFilter = '' then
            exit('');

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
        PBCJPSetup: Record 50005;
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
        TEST0001: Label 'Can not find any Service Item, do you want to create Service Quote?';
        TEST0002: Label 'Do you want to create Service Order?';
        TEST0003: Label 'Do you want to create Service Quote?';
        TEST0004: Label 'Service Order ''%1'' created successfully, do you want to open?';
        TEST0005: Label 'Service Quote ''%1'' created successfully, do you want to open?';
        TEST0006: Label '%1 days after last date.';
        TEST0007: Label 'Do you want to copy Service Line?';
        UncRecCount: Integer;
        UncRecAmount: Decimal;
        CustLedgerEntry: Record 21;
        FaultAreaFilter: Code[10];
        SymptomFilter: Code[10];
        FaultFilter: Code[10];
        ResolutionFilter: Code[10];
        ProductSeriesFilter: Text[250];
        // UI helpers
        ShowDateWarningGreen: Boolean;
        ShowDateWarningYellow: Boolean;
        ShowDateWarningRed: Boolean;
        ShowUncRec: Boolean;
        UncRecText: Text[100];
}
 */