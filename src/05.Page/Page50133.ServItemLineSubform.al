
page 50133 "Serv. Item Line Subform"
{
    Caption = 'Service Order';
    PageType = ListPart;
    SourceTable = "Service Item Line";
    ApplicationArea = All;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        ServHeader: Record "Service Header";
                    begin
                        ServHeader.Reset();
                        ServHeader.SetRange("Document Type", Rec."Document Type");
                        ServHeader.SetRange("No.", Rec."Document No.");
                        if ServHeader.FindFirst() then
                            Page.RunModal(Page::"Service Order", ServHeader);
                    end;
                }
                field("Service Item No."; Rec."Service Item No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        ServItem: Record "Service Item";
                    begin
                        ServItem.Get(Rec."Service Item No.");
                        Page.RunModal(Page::"Service Item Card", ServItem);
                    end;
                }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Warranty; Rec.Warranty)
                {
                    ApplicationArea = All;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        ServContractHdr: Record "Service Contract Header";
                    begin
                        ServContractHdr.Reset();
                        ServContractHdr.SetRange("Contract Type", ServContractHdr."Contract Type"::Contract);
                        ServContractHdr.SetRange("Contract No.", Rec."Contract No.");
                        if ServContractHdr.FindFirst() then
                            Page.RunModal(Page::"Service Contract", ServContractHdr);
                    end;
                }
                field("Fault Area Code"; Rec."Fault Area Code")
                {
                    ApplicationArea = All;
                    Caption = 'Fault Area Code';
                }
                field("Symptom Code"; Rec."Symptom Code") { ApplicationArea = All; }
                field("Fault Code"; Rec."Fault Code") { ApplicationArea = All; }
                field("Resolution Code"; Rec."Resolution Code")
                {
                    ApplicationArea = All;
                    Caption = 'Resolution Code';
                }
            }

            group(Comments)
            {
                ShowCaption = false;
                field(FaultComment; FaultComment)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Fault Comment';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if Rec."Document No." = '' then
                            exit(true);
                        Rec.ShowComments(SrvCmtLineType::Fault);
                        Refresh();
                        exit(true);
                    end;
                }
                field(ResolutionComment; ResolutionComment)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Resolution Comment';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if Rec."Document No." = '' then
                            exit(true);
                        Rec.ShowComments(SrvCmtLineType::Resolution);
                        Refresh();
                        exit(true);
                    end;
                }
                field(FaultAreaComment; FaultAreaComment)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Fault Area Comment';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if Rec."Document No." = '' then
                            exit(true);
                        Rec.ShowComments(SrvCmtLineType::"Fault Area");
                        Refresh();
                        exit(true);
                    end;
                }
                field(SymptomComment; SymptomComment)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Symptom Comment';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if Rec."Document No." = '' then
                            exit(true);
                        Rec.ShowComments(SrvCmtLineType::Symptom);
                        Refresh();
                        exit(true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Refresh();
    end;

    var
        FaultAreaComment: Text[250];
        SymptomComment: Text[250];
        FaultComment: Text[250];
        ResolutionComment: Text[250];
        ServCommentLine: Record 5906;
        iLoop: Integer;
        NotEmpty: Boolean;
        SrvCmtLineType: Enum "Service Comment Line Type";

    procedure Relink(ServiceItemNo: Code[20])
    begin
        Rec.SetRange("Service Item No.", ServiceItemNo);
        Refresh();
        CurrPage.Update(false);
    end;

    local procedure Refresh()
    begin
        NotEmpty := ((Rec.Count > 0) and (Rec."Document No." <> ''));
        FaultAreaComment := '';
        SymptomComment := '';
        FaultComment := '';
        ResolutionComment := '';
        if NotEmpty then begin
            for iLoop := 1 to 4 do begin
                ServCommentLine.Reset();
                ServCommentLine.SetRange("Table Name", ServCommentLine."Table Name"::"Service Header");
                ServCommentLine.SetRange("Table Subtype", Rec."Document Type");
                ServCommentLine.SetRange("No.", Rec."Document No.");
                ServCommentLine.SetRange("Table Line No.", Rec."Line No.");
                case iLoop of
                    1:
                        ServCommentLine.SetRange(Type, ServCommentLine.Type::"Fault Area");
                    2:
                        ServCommentLine.SetRange(Type, ServCommentLine.Type::Symptom);
                    3:
                        ServCommentLine.SetRange(Type, ServCommentLine.Type::Fault);
                    4:
                        ServCommentLine.SetRange(Type, ServCommentLine.Type::Resolution);
                end;
                if ServCommentLine.FindFirst() then begin
                    case iLoop of
                        1:
                            FaultAreaComment := ServCommentLine.Comment;
                        2:
                            SymptomComment := ServCommentLine.Comment;
                        3:
                            FaultComment := ServCommentLine.Comment;
                        4:
                            ResolutionComment := ServCommentLine.Comment;
                    end;
                end;
            end;
        end;
    end;
}
