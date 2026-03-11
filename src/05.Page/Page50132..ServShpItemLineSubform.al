
page 50132 "Serv. Shpt. Item Line Subform"
{
    Caption = 'Service Shipment';
    PageType = ListPart;
    SourceTable = "Service Shipment Item Line";
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        OpenServShipHeader: Record 5990; // Service Shipment Header
                    begin
                        Clear(OpenServShipHeader);
                        OpenServShipHeader.SetRange("No.", Rec."No.");
                        Page.RunModal(Page::"Posted Service Shipment", OpenServShipHeader);
                        exit(true);
                    end;
                }
                field("Service Item No."; Rec."Service Item No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecServItem: Record 5940; // Service Item
                    begin
                        Clear(RecServItem);
                        RecServItem.SetRange("No.", Rec."Service Item No.");
                        if RecServItem.FindFirst() then
                            Page.RunModal(Page::"Service Item Card", RecServItem);
                        exit(true);
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
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecServContractHeader: Record 5965; // Service Contract Header
                    begin
                        Clear(RecServContractHeader);
                        RecServContractHeader.SetRange("Contract Type", RecServContractHeader."Contract Type"::Contract);
                        RecServContractHeader.SetRange("Contract No.", Rec."Contract No.");
                        if RecServContractHeader.FindFirst() then
                            Page.RunModal(Page::"Service Contract", RecServContractHeader);
                        exit(true);
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
                        if Rec."No." = '' then
                            exit(true);
                        Rec.ShowComments(1);
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
                        if Rec."No." = '' then
                            exit(true);
                        Rec.ShowComments(2);
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
                        if Rec."No." = '' then
                            exit(true);
                        Rec.ShowComments(6);
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
                        if Rec."No." = '' then
                            exit(true);
                        Rec.ShowComments(7);
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

    procedure Relink(ServiceItemNo: Code[20]; ContractNoFilter: Text[250]; FaultAreaFilter: Code[10]; SymptomFilter: Code[10]; FaultFilter: Code[10]; ResolutionFilter: Code[10])
    begin
        Rec.SetRange("Service Item No.", ServiceItemNo);
        Rec.SetFilter("Contract No.", ContractNoFilter);
        Rec.SetFilter("Fault Area Code", FaultAreaFilter);
        Rec.SetFilter("Symptom Code", SymptomFilter);
        Rec.SetFilter("Fault Code", FaultFilter);
        Rec.SetFilter("Resolution Code", ResolutionFilter);
        Refresh();
        CurrPage.Update(false);
    end;

    local procedure Refresh()
    begin
        NotEmpty := ((Rec.Count > 0) and (Rec."No." <> ''));
        FaultAreaComment := '';
        SymptomComment := '';
        FaultComment := '';
        ResolutionComment := '';
        if NotEmpty then begin
            for iLoop := 1 to 4 do begin
                ServCommentLine.Reset();
                ServCommentLine.SetRange("Table Name", ServCommentLine."Table Name"::"Service Shipment Header");
                ServCommentLine.SetRange("Table Subtype", 0);
                ServCommentLine.SetRange("No.", Rec."No.");
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
