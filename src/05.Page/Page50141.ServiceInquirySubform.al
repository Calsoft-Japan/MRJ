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
                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ServInvoice: Record "Service Invoice Header";
                        ServCrMemo: Record "Service Cr.Memo Header";
                    begin
                        case Rec."Document Type" of
                            Rec."Document Type"::"Posted Invoice":
                                begin
                                    if ServInvoice.Get(Rec."Document No.") then
                                        Page.RunModal(Page::"Posted Service Invoice", ServInvoice);
                                end;
                            Rec."Document Type"::"Posted Credit Memo":
                                begin
                                    if ServCrMemo.Get(Rec."Document No.") then
                                        Page.RunModal(Page::"Posted Service Credit Memo", ServCrMemo);
                                end;
                        end;
                        exit(true);
                    end;
                }
                field(Type; Rec.Type) { ApplicationArea = All; }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Unit Price"; Rec."Unit Price") { ApplicationArea = All; }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Amount Including VAT"; Rec."Amount Including VAT") { ApplicationArea = All; }
                field("Work Type Code"; Rec."Work Type Code") { ApplicationArea = All; }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Inv. Discount Amount"; Rec."Inv. Discount Amount") { ApplicationArea = All; }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group") { ApplicationArea = All; }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group") { ApplicationArea = All; }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group") { ApplicationArea = All; }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group") { ApplicationArea = All; }
                field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; }
                field("VAT Difference"; Rec."VAT Difference") { ApplicationArea = All; }
                field("Unit of Measure Code"; Rec."Unit of Measure Code") { ApplicationArea = All; }
                field("Item Category Code"; Rec."Item Category Code") { ApplicationArea = All; }
                field("Service Order Type"; Rec."Service Order Type") { ApplicationArea = All; }
                field("Service Item No."; Rec."Service Item No.") { ApplicationArea = All; }
                field("Service Item Serial No."; Rec."Service Item Serial No.") { ApplicationArea = All; }
                field("Original Order No."; Rec."Original Order No.") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Order Date"; Rec."Order Date") { ApplicationArea = All; }
                field(Warranty; Rec.Warranty) { ApplicationArea = All; }
                field("Contract No."; Rec."Contract No.") { ApplicationArea = All; }
                field("Warranty Disc. %"; Rec."Warranty Disc. %") { ApplicationArea = All; }
                field("Fault Reason Code"; Rec."Fault Reason Code") { ApplicationArea = All; }
            }
        }
    }

    trigger OnInit()
    begin
        PostedInvoice := true;
        PostedCrMemo := true;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ServInvHdr: Record "Service Invoice Header";
        ServInvLine: Record "Service Invoice Line";
        ServCrMemoHdr: Record "Service Cr.Memo Header";
        ServCrMemoLine: Record "Service Cr.Memo Line";
        CurrExchRate: Record "Currency Exchange Rate";
        ServItemFilter: Text[250];
        SerialFilter: Text[250];
        PostingDateFilter: Text[250];
        RecFilter: Text[250];
        TypeFilter: Text[250];
        PostedInvoice: Boolean;
        PostedCrMemo: Boolean;
        TotalAmt: Decimal;
        TotalAmtVAT: Decimal;
        DecTotalAmt: Decimal;
        DecTotalAmtVAT: Decimal;

    procedure SetIncludeFilter(pPSInv: Boolean; pPCrMemo: Boolean);
    begin
        PostedInvoice := pPSInv;
        PostedCrMemo := pPCrMemo;
    end;

    procedure RefreshData(pPostDateFilter: Text)
    begin
        GLSetup.Get();
        RecFilter := Rec.GetView();
        Rec.Reset();
        Rec.DeleteAll();
        Rec.SetView(RecFilter);

        if PostedInvoice then begin
            Clear(ServInvHdr);
            ServInvHdr.SetCurrentKey("No.");
            if pPostDateFilter <> '' then
                ServInvHdr.SetFilter("Posting Date", pPostDateFilter);
            if ServInvHdr.FindSet() then
                repeat
                    Clear(ServInvLine);
                    ServInvLine.SetRange("Document No.", ServInvHdr."No.");
                    ServInvLine.SetFilter(Type, '<>%1', ServInvLine.Type::" ");
                    if ServInvLine.FindSet() then
                        repeat
                            Rec.Init();
                            Rec.TransferFields(ServInvLine);
                            Rec."Customer No." := ServInvHdr."Customer No.";
                            Rec."Document Type" := Rec."Document Type"::"Posted Invoice";
                            Rec."Original Order No." := ServInvHdr."Order No.";
                            TotalAmt := Rec.Amount;
                            TotalAmtVAT := Rec."Amount Including VAT";
                            if Rec."Currency Code" <> '' then begin
                                TotalAmt := Round(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                                  Rec."Currency Code", TotalAmt, ServInvHdr."Currency Factor"),
                                                  GLSetup."Amount Rounding Precision");
                                TotalAmtVAT := Round(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                               Rec."Currency Code", TotalAmtVAT, ServInvHdr."Currency Factor"),
                                               GLSetup."Amount Rounding Precision");
                            end;
                            DecTotalAmt += TotalAmt;
                            DecTotalAmtVAT += TotalAmtVAT;
                            Rec."Service Order Type" := ServInvHdr."Service Order Type";
                            Rec."Customer Name" := ServInvHdr.Name;
                            Rec."Posting Date" := ServInvHdr."Posting Date";
                            Rec.Insert();
                        until (ServInvLine.Next() = 0);
                until (ServInvHdr.Next() = 0);
        end;

        if PostedCrMemo then begin
            Clear(ServCrMemoHdr);
            ServCrMemoHdr.SetCurrentKey("No.");
            if pPostDateFilter <> '' then
                ServCrMemoHdr.SetFilter("Posting Date", pPostDateFilter);
            if ServCrMemoHdr.FindSet() then
                repeat
                    Clear(ServCrMemoLine);
                    ServCrMemoLine.SetRange("Document No.", ServCrMemoHdr."No.");
                    ServCrMemoLine.SetFilter(Type, '<>%1', ServCrMemoLine.Type::" ");
                    if ServCrMemoLine.FindSet() then
                        repeat
                            Rec.Init();
                            Rec.TransferFields(ServCrMemoLine);
                            Rec."Customer No." := ServCrMemoHdr."Customer No.";
                            Rec."Document Type" := Rec."Document Type"::"Posted Credit Memo";
                            Rec."Original Order No." := ServCrMemoHdr."Pre-Assigned No.";
                            TotalAmt := Rec.Amount;
                            TotalAmtVAT := Rec."Amount Including VAT";
                            if Rec."Currency Code" <> '' then begin
                                TotalAmt := Round(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                                  Rec."Currency Code", TotalAmt, ServCrMemoHdr."Currency Factor"),
                                                  GLSetup."Amount Rounding Precision");
                                TotalAmtVAT := Round(CurrExchRate.ExchangeAmtFCYToLCY(GetDate(Rec."Posting Date"),
                                               Rec."Currency Code", TotalAmtVAT, ServCrMemoHdr."Currency Factor"),
                                               GLSetup."Amount Rounding Precision");
                            end;
                            DecTotalAmt += TotalAmt;
                            DecTotalAmtVAT += TotalAmtVAT;
                            Rec."Service Order Type" := ServCrMemoHdr."Service Order Type";
                            Rec."Customer Name" := ServCrMemoHdr.Name;
                            Rec."Posting Date" := ServCrMemoHdr."Posting Date";
                            Rec.Insert();
                        until (ServCrMemoLine.Next() = 0);
                until (ServCrMemoHdr.Next() = 0);
        end;

        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    local procedure GetDate(RecDate: Date): Date
    begin
        if RecDate <> 0D then
            exit(RecDate)
        ELSE
            exit(WorkDate());
    end;

    procedure DeleteRecords()
    begin
        Rec.Reset();
        Rec.DeleteAll();
        PostingDateFilter := '';
    end;
}
