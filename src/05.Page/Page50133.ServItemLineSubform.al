
page 50133 "Serv. Item Line Subform"
{
    PageType = ListPart;
    SourceTable = 5901; // Table5901 from C/AL (Service Item Line)
    ApplicationArea = All;
    Editable = false;

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
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        OpenServHeader: Record 5900; // Service Header
                    begin
                        Clear(OpenServHeader);
                        OpenServHeader.SetRange("Document Type", Rec."Document Type");
                        OpenServHeader.SetRange("No.", Rec."Document No.");
                        Page.RunModal(Page::"Service Order", OpenServHeader);
                        exit(true);
                    end;
                }
                field("Service Item No."; Rec."Service Item No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecServItem: Record 5940;
                    begin
                        Clear(RecServItem);
                        RecServItem.SetRange("No.", Rec."Service Item No.");
                        if RecServItem.FindFirst() then
                            Page.RunModal(Page::"Service Item Card", RecServItem);
                        exit(true);
                    end;
                }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Visible = false;
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
                field(Warranty; Rec.Warranty)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecServContractHeader: Record 5965;
                    begin
                        Clear(RecServContractHeader);
                        RecServContractHeader.SetRange("Contract Type", RecServContractHeader."Contract Type"::Contract);
                        RecServContractHeader.SetRange("Contract No.", Rec."Contract No.");
                        if RecServContractHeader.FindFirst() then
                            Page.RunModal(Page::"Service Contract", RecServContractHeader);
                        exit(true);
                    end;
                }
                field("Fault Area Code"; Rec."Fault Area Code") { ApplicationArea = All; }
                field("Symptom Code"; Rec."Symptom Code") { ApplicationArea = All; }
                field("Fault Code"; Rec."Fault Code") { ApplicationArea = All; }
                field("Resolution Code"; Rec."Resolution Code") { ApplicationArea = All; }
            }

            group(Comments)
            {
                Caption = 'Comments';
                field(FaultComment; FaultComment)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Fault Comment';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if Rec."Document No." = '' then
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
                        if Rec."Document No." = '' then
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
                        if Rec."Document No." = '' then
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
                        if Rec."Document No." = '' then
                            exit(true);
                        Rec.ShowComments(7);
                        Refresh();
                        exit(true);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(BtnOpenIWS)
            {
                Caption = 'Item Worksheet';
                ApplicationArea = All;
                Image = Worksheet;
                trigger OnAction()
                var
                    OpenServiceItemLine: Record 5901;
                begin
                    if Rec."Document No." = '' then
                        exit;
                    Clear(OpenServiceItemLine);
                    OpenServiceItemLine.SetRange("Document Type", Rec."Document Type");
                    OpenServiceItemLine.SetRange("Document No.", Rec."Document No.");
                    OpenServiceItemLine.SetRange("Line No.", Rec."Line No.");
                    Page.RunModal(Page::"Service Item Worksheet", OpenServiceItemLine);
                end;
            }
            action(BtnOpenSWR)
            {
                Caption = 'Work Report';
                ApplicationArea = All;
                Image = Report;
                trigger OnAction()
                var
                    ServHeader: Record 5900;
                begin
                    if Rec."Document No." = '' then
                        exit;
                    Clear(ServHeader);
                    ServHeader.SetRange("Document Type", Rec."Document Type");
                    ServHeader.SetRange("No.", Rec."Document No.");
                    //Report.Run(Report::"Service Work Report", true, false, ServHeader);
                end;
            }
            action(BtnOpenCPT)
            {
                Caption = 'Parts Transfer';
                ApplicationArea = All;
                Image = TransferOrder;
                trigger OnAction()
                var
                    ServHeader: Record 5900;
                begin
                    Clear(ServHeader);
                    ServHeader.Get(Rec."Document Type", Rec."Document No.");
                    // The following calls assume page 50138 was converted to a page with methods SetDefaultFilter/SetDefaultFilter2
                    Page.Run(50138, ServHeader); // TODO: Replace with proper page and method calls if needed
                end;
            }
            action(ServiceTasks)
            {
                Caption = 'Service Tasks';
                ApplicationArea = All;
                Image = Task;
                trigger OnAction()
                var
                    OpenServiceItemLine: Record 5901;
                begin
                    Clear(OpenServiceItemLine);
                    if Rec."Document No." <> '' then begin
                        OpenServiceItemLine.SetRange("Document Type", Rec."Document Type");
                        OpenServiceItemLine.SetRange("Document No.", Rec."Document No.");
                        OpenServiceItemLine.SetRange("Line No.", Rec."Line No.");
                    end;
                    Page.RunModal(Page::"Service Tasks", OpenServiceItemLine);
                end;
            }
            action(DispatchBoard)
            {
                Caption = 'Dispatch Board';
                ApplicationArea = All;
                Image = Timeline;
                RunObject = Page 6000; // Converted from Form 6000
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

    procedure Relink(ServiceItemNo: Code[20]; ContractNoFilter: Text[250])
    begin
        Rec.SetRange("Service Item No.", ServiceItemNo);
        Rec.SetFilter("Contract No.", ContractNoFilter);
        Refresh();
        CurrPage.Update(false);
    end;

    local procedure Refresh()
    begin
        NotEmpty := ((Rec.Count > 0) and (Rec."Document No." <> ''));
        //CurrPage.BtnOpenIWS.Visible := NotEmpty;
        //CurrPage.BtnOpenSWR.Visible := NotEmpty;
        //CurrPage.BtnOpenCPT.Visible := NotEmpty;
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
