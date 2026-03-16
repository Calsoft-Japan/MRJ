report 50075 "Service Work Report"
{
    Caption = 'Service Work Report';
    UsageCategory = None;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJServiceWorkReport.rdlc';

    dataset
    {
        dataitem("Service Header"; "Service Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.";
            column(RepTitleLbl; RepTitleLbl) { }
            column(PageLbl; PageLbl) { }
            column(DateLbl; DateLbl) { }
            column(OrderNoLbl; OrderNoLbl) { }
            column(CustLbl; CustLbl) { }
            column(ContactLbl; ContactLbl) { }
            column(EquipmentLbl; EquipmentLbl) { }
            column(WrkConditionLbl; WrkConditionLbl) { }
            column(SrvOrdTypeLbl; SrvOrdTypeLbl) { }
            column(ProdNoLbl; ProdNoLbl) { }
            column(WorkDateLbl; WorkDateLbl) { }
            column(TelLbl; TelLbl) { }
            column(SerialNoLbl; SerialNoLbl) { }
            column(WarrantyLbl; WarrantyLbl) { }
            column(SeriesNoLbl; SeriesNoLbl) { }
            column(ProdTimeLbl; ProdTimeLbl) { }
            column(WorkerLbl; WorkerLbl) { }
            column(ServItemStatusLbl; ServItemStatusLbl) { }
            column(FaultAreaLbl; FaultAreaLbl) { }
            column(SymptomLbl; SymptomLbl) { }
            column(FaultLbl; FaultLbl) { }
            column(ResolutionLbl; ResolutionLbl) { }
            column(InternalLbl; InternalLbl) { }
            column(TotalAmtLbl; TotalAmtLbl) { }
            column(StartingLbl; StartingLbl) { }
            column(StartEndTimeLbl; StartEndTimeLbl) { }
            column(HrsLbl; HrsLbl) { }
            column(CostOfRLbl; CostOfRLbl) { }
            column(AuthorizedLbl; AuthorizedLbl) { }
            column(ConfirmLbl; ConfirmLbl) { }
            column(CreatedLbl; CreatedLbl) { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(OutputDate; OutputDate) { }
            column(SrvHdrNo; "No.") { }
            column(SrvHdrDocDate; "Document Date") { }
            column(SrvHdrPhoneNo; "Phone No.") { }
            column(SrvHdrCustNo; "Customer No.") { }
            column(SrvHdrSrvOrdType; "Service Order Type") { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CustAddr7; CustAddr[7]) { }
            column(CustAddr8; CustAddr[8]) { }

            dataitem("Service Item Line"; "Service Item Line")
            {
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.")
                                    where("Service Item No." = filter(<> ''), "Serial No." = filter(<> ''));
                DataItemLink = "Document No." = field("No.");
                column(FaultAreaCode; FaultArea.Code) { }
                column(FaultAreaDesc; FaultArea.Description) { }
                column(SymptomCode; Symptom.Code) { }
                column(SymptomDesc; Symptom.Description) { }
                column(FaultCode; Fault.Code) { }
                column(FaultDesc; Fault.Description) { }
                column(ResolutionCode; Resolution.Code) { }
                column(ResolutionDesc; Resolution.Description) { }
                column(FaultAreaComment1; FaultAreaComment[1]) { }
                column(FaultAreaComment2; FaultAreaComment[2]) { }
                column(FaultAreaComment3; FaultAreaComment[3]) { }
                column(FaultAreaComment4; FaultAreaComment[4]) { }
                column(SymptomComment1; SymptomComment[1]) { }
                column(SymptomComment2; SymptomComment[2]) { }
                column(SymptomComment3; SymptomComment[3]) { }
                column(SymptomComment4; SymptomComment[4]) { }
                column(FaultComment1; FaultComment[1]) { }
                column(FaultComment2; FaultComment[2]) { }
                column(FaultComment3; FaultComment[3]) { }
                column(FaultComment4; FaultComment[4]) { }
                column(ResolutionComment1; ResolutionComment[1]) { }
                column(ResolutionComment2; ResolutionComment[2]) { }
                column(ResolutionComment3; ResolutionComment[3]) { }
                column(ResolutionComment4; ResolutionComment[4]) { }
                column(InternalComment1; InternalComment[1]) { }
                column(InternalComment2; InternalComment[2]) { }
                column(InternalComment3; InternalComment[3]) { }
                column(InternalComment4; InternalComment[4]) { }
                column(SrvItemLineDesc; Description) { }
                column(SrvItemLineSerialNo; "Serial No.") { }
                column(SrvItemLineWarranty; WarantyTxt) { }
                column(SrvItemLinePrdSeries; "Product Series") { }
                column(RepairStatusDesc; RepairStatus.Description) { }

                dataitem("Service Line"; "Service Line")
                {
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.")
                                        where(Type = filter(<> ' '), "Outstanding Quantity" = filter(> 0));
                    DataItemLink = "Document No." = field("Document No."), "Document Type" = field("Document Type"),
                                   "Service Item No." = field("Service Item No."), "Service Item Line No." = field("Line No."),
                                   "Service Item Serial No." = field("Serial No.");
                    column(TypeLbl; TypeLbl) { }
                    column(NoLbl; NoLbl) { }
                    column(LotNoLbl; LotNoLbl) { }
                    column(SrlNoLbl; SrlNoLbl) { }
                    column(DescLbl; DescLbl) { }
                    column(QtyLbl; QtyLbl) { }
                    column(UOMLbl; UOMLbl) { }
                    column(UnitPriceLbl; UnitPriceLbl) { }
                    column(AmountLbl; AmountLbl) { }
                    column(PrintOption; PrintOption) { }
                    column(SrvLineType; Type) { }
                    column(SrvLineNo; "No.") { }
                    column(SrvLineDesc; Description) { }
                    column(SrvLineUnitPrice; "Unit Price") { }
                    column(SrvLineOutStdgQty; "Outstanding Quantity") { }
                    column(SrvLineUOM; UOM) { }
                    column(SrvLineCalcQty; ServLineQty) { }
                    column(SrvLineCalcAmt; ServLineAmt) { }
                    column(SrvLineLotNo; ServLineLotNo) { }
                    dataitem(ServLines; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(Number; Number) { }
                        column(TotalText; TotalText) { }
                        column(TotalLineAmtText; TotalLineAmtText) { }
                        column(DisclaimerText; DisclaimerText) { }
                        column(ResvLotNo; ReservEntry."Lot No.") { }
                        column(ResvSerialNo; ReservEntry."Serial No.") { }
                        trigger OnPreDataItem() //ServLines DataItem
                        begin
                            SetRange(Number, 1, ReservCnt);
                        end;

                        trigger OnAfterGetRecord() //ServLines DataItem
                        begin
                            LineLoopCnt += 1;
                            if (ReservCnt > 1) and (PrintOption = PrintOption::All) then
                                ReservEntry.Next();

                            if LineLoopCnt > 1 then
                                if (LineLoopCnt mod PageBreak) = 1 then begin
                                    TotalText := '';
                                    TotalLineAmtText := '';
                                    UnderLine := '';
                                    DisclaimerText := '';
                                    LineLoopCnt := 1;
                                    //CurrReport.NewPage();
                                end;

                            TotalText := TotalLbl;
                            TotalLineAmtText := Format(TotalLineAmt);
                            DisclaimerText := DisclaimerLbl;
                        end;
                    }
                    trigger OnPreDataItem() //SrvLine DataItem
                    begin
                        TotalLineAmt := 0;
                    end;

                    trigger OnAfterGetRecord() //SrvLine DataItem
                    var
                        UnitofMeasure: Record "Unit of Measure";
                    begin
                        UOM := GetUnitOfMeasureText("Unit of Measure Code", CurrReport.Language.ToText());
                        ServLineQty := "Outstanding Quantity";
                        if "Quantity" <> 0 then
                            ServLineAmt := Amount * (ServLineQty / "Quantity")
                        else
                            ServLineAmt := 0;

                        ServLineLotNo := '';
                        ReservCnt := 1;

                        if PrintOption <> PrintOption::ItemOnly then begin
                            ReservEntry.Reset();
                            ReservEntry.SetCurrentKey("Item No.");
                            ReservEntry.SetRange("Item No.", "No.");
                            ReservEntry.SetRange("Source Type", Database::"Service Line");
                            ReservEntry.SetRange("Source Subtype", 1);
                            ReservEntry.SetRange("Source ID", "Document No.");
                            ReservEntry.SetRange("Source Ref. No.", "Line No.");
                            if ReservEntry.FindFirst() then begin
                                case PrintOption of
                                    PrintOption::ItemAndLot:
                                        ServLineLotNo := ReservEntry."Lot No.";
                                    PrintOption::All:
                                        begin
                                            ReservCnt := ReservEntry.Count();
                                            ServLineAmt := Amount / "Quantity";
                                            ServLineQty := 1;
                                        end;
                                end;
                            end;
                        end;

                        ServLineCnt += ReservCnt;
                        TotalLineAmt += ServLineAmt;
                    end;
                }
                dataitem(GridLines; Integer)
                {
                    DataItemTableView = sorting(Number);

                    trigger OnPreDataItem() //GridLines DataItem
                    begin
                        ServLineCnt := ServLineCnt mod PageBreak;
                        if ServLineCnt <> 0 then
                            GridLineCnt := (PageBreak - ServLineCnt);
                        SetRange(Number, 1, GridLineCnt);
                    end;

                    trigger OnPostDataItem() //GridLines DataItem
                    begin
                        ReservCnt := 0;
                        ServLineCnt := 0;
                        GridLineCnt := 0;
                        LineLoopCnt := 0;
                    end;
                }
                trigger OnAfterGetRecord() //ServiceItemLine DataItem
                begin
                    Clear(FaultArea);
                    Clear(Symptom);
                    Clear(Fault);
                    Clear(Resolution);
                    Clear(RepairStatus);

                    if "Fault Area Code" <> '' then
                        FaultArea.Get("Fault Area Code");
                    if "Symptom Code" <> '' then
                        Symptom.Get("Symptom Code");
                    if ("Fault Area Code" <> '') and ("Symptom Code" <> '') and ("Fault Code" <> '') then
                        Fault.Get("Fault Area Code", "Symptom Code", "Fault Code");
                    if "Resolution Code" <> '' then
                        Resolution.Get("Resolution Code");
                    if "Repair Status Code" <> '' then
                        RepairStatus.Get("Repair Status Code");

                    Clear(WarantyTxt);
                    WarantyTxt := 'No';
                    if Warranty then
                        WarantyTxt := 'Yes';

                    Clear(FaultAreaComment);
                    Clear(SymptomComment);
                    Clear(FaultComment);
                    Clear(ResolutionComment);
                    Clear(InternalComment);

                    SetComment(FaultAreaComment, CommentType::"Fault Area");
                    SetComment(SymptomComment, CommentType::Symptom);
                    SetComment(FaultComment, CommentType::Fault);
                    SetComment(ResolutionComment, CommentType::Resolution);
                    SetComment(InternalComment, CommentType::Internal);

                end;
            }

            trigger OnAfterGetRecord() //ServiceHeader DataItem
            var
                LangId: Integer;
            begin
                if CurrReport.Language = 1041 then
                    OutputDate := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日')
                else
                    OutputDate := Format("Document Date", 0, '<Year4>/<Month,2>/<Day,2>');

                CompanyML(CompanyAddr, CompanyInfo, CurrReport.Language);

                ServiceHeaderSellToML(CustAddr, "Service Header", CurrReport.Language);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOption; PrintOption)
                    {
                        ApplicationArea = All;
                        Caption = 'Print Option';
                        OptionCaption = 'Item No.,Item No./Lot.No.,Item No./Lot No./Serial No.';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        PageBreak := 10;
    end;

    var

        CompanyInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        FaultArea: Record "Fault Area";
        Symptom: Record "Symptom Code";
        Fault: Record "Fault Code";
        Resolution: Record "Resolution Code";
        RepairStatus: Record "Repair Status";
        ServCommentLine: Record "Service Comment Line";
        ReservEntry: Record "Reservation Entry";
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        LanguageRec: Codeunit Language;
        PrintOption: Option ItemOnly,ItemAndLot,All;
        OutputDate: Text[50];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[100];
        FaultAreaComment: array[4] of Text[80];
        SymptomComment: array[4] of Text[80];
        FaultComment: array[4] of Text[80];
        ResolutionComment: array[4] of Text[80];
        InternalComment: array[4] of Text[80];
        WarantyTxt: Text[10];
        UOM: Text[50];
        ServLineAmt: Decimal;
        ServLineQty: Decimal;
        ServLineLotNo: Code[20];
        ReservCnt: Integer;
        LineLoopCnt: Integer;
        ServLineCnt: Integer;
        GridLineCnt: Integer;
        TotalText: Text[50];
        TotalLineAmt: Decimal;
        TotalLineAmtText: Text[50];
        UnderLine: Text[100];
        DisclaimerText: Text[50];
        PageBreak: Integer;
        CommentType: Enum "Service Comment Line Type";
        TotalLbl: Label 'Total', Locked = true;
        SubtotalLbl: Label 'Sub Total', Locked = true;
        DisclaimerLbl: Label '※上記金額に、消費税は含まれておりません。';

    local procedure SetComment(var Comment: array[4] of Text[80]; CType: Enum "Service Comment Line Type")
    var
        i: Integer;
    begin
        Clear(Comment);
        ServCommentLine.Reset();
        ServCommentLine.SetRange("No.", "Service Item Line"."Document No.");
        ServCommentLine.SetRange(Type, CType);
        ServCommentLine.SetRange("Table Line No.", "Service Item Line"."Line No.");
        if ServCommentLine.FindFirst() then begin
            i := 1;
            repeat
                Comment[i] := ServCommentLine.Comment;
                i += 1;
            until (ServCommentLine.Next() = 0) or (i > 4);
        end;
    end;

    procedure CompanyML(var AddrArray: array[8] of Text[50]; var CompanyInfo: Record "Company Information"; LanguageID: Integer)
    begin
        FormatAddrJPN(AddrArray,
                      CompanyInfo.Name, CompanyInfo."Name 2", '',
                      CompanyInfo.Address, CompanyInfo."Address 2",
                      CompanyInfo.City, CompanyInfo."Post Code", CompanyInfo.County, '',
                      CompanyInfo."Phone No.", CompanyInfo."Fax No.", '', '')
    end;

    procedure ServiceHeaderSellToML(var AddrArray: array[8] of Text[50]; var ServiceHeader: Record "Service Header"; LanguageID: Integer)
    begin
        if LanguageID = 1041 then
            FormatAddrJPN(AddrArray,
                          ServiceHeader.Name, ServiceHeader."Name 2", ServiceHeader."Contact Name",
                          ServiceHeader.Address, ServiceHeader."Address 2",
                          ServiceHeader.City, ServiceHeader."Post Code", ServiceHeader.County, ServiceHeader."Country/Region Code",
                          ServiceHeader."Phone No.", ServiceHeader."Fax No.", '', '')
        else
            FormatAddrENU(AddrArray,
                          ServiceHeader.Name, ServiceHeader."Name 2", ServiceHeader."Contact Name",
                          ServiceHeader.Address, ServiceHeader."Address 2",
                          ServiceHeader.City, ServiceHeader."Post Code", ServiceHeader.County, ServiceHeader."Country/Region Code",
                          ServiceHeader."Phone No.", ServiceHeader."Fax No.", '', '');
    end;

    procedure GetLanguageCode(var LanguageID: Integer) Code: Code[10]
    var
        LanguageRec: Record Language;
    begin
        LanguageRec.SetRange("Windows Language ID", LanguageID);
        if LanguageRec.FindLast() then
            exit(LanguageRec.Code)
        else
            exit('');
    end;

    procedure FormatAddrJPN(var AddrArray: array[8] of Text[90];
                                Name: Text[90]; Name2: Text[90]; Contact: Text[90];
                                Addr: Text[50]; Addr2: Text[50];
                                City: Text[50]; PostCode: Code[20];
                                County: Text[50]; CountryCode: Code[10];
                                Phone: Text[50]; Fax: Text[50];
                                NameTitle: Text[50]; ContactTitle: Text[50])
    begin
        Clear(AddrArray);

        if PostCode <> '' then
            AddrArray[3] := '〒' + PostCode;

        AddrArray[4] := Addr;
        AddrArray[5] := Addr2;
        AddrArray[1] := Name + ' ' + NameTitle;

        AddrArray[2] := '';
        if Phone <> '' then
            AddrArray[6] := 'Tel. ' + Phone
        else
            AddrArray[6] := '';

        if Fax <> '' then
            AddrArray[7] := 'Fax. ' + Fax
        else
            AddrArray[7] := '';

        if Contact <> '' then
            AddrArray[8] := Contact + ' ' + ContactTitle
        else
            AddrArray[8] := '';
    end;

    procedure FormatAddrENU(var AddrArray: array[8] of Text[90];
                            Name: Text[90]; Name2: Text[90]; Contact: Text[90];
                            Addr: Text[50]; Addr2: Text[50];
                            City: Text[50]; PostCode: Code[20];
                            County: Text[50]; CountryCode: Code[10];
                            Phone: Text[50]; Fax: Text[50];
                            NameTitle: Text[50]; ContactTitle: Text[50])
    begin
        Clear(AddrArray);

        if PostCode <> '' then
            AddrArray[5] := PostCode;

        AddrArray[3] := Addr;
        AddrArray[4] := Addr2;
        AddrArray[1] := Name + ' ' + NameTitle;

        AddrArray[2] := '';

        if Phone <> '' then
            AddrArray[6] := 'Tel. ' + Phone
        else
            AddrArray[6] := '';

        if Fax <> '' then
            AddrArray[7] := 'Fax ' + Fax
        else
            AddrArray[7] := '';

        AddrArray[8] := '';
    end;

    procedure GetUnitOfMeasureText(UoMCode: Code[50]; LanguageCode: Code[10]): Text[50]
    var
        UnitofMeasure: Record "Unit of Measure";
        UnitOfMeasureTranslation: Record "Unit of Measure Translation";
        Language: Codeunit Language;
    begin
        if UoMCode = '' then
            exit;
        UnitofMeasure.Get(UoMCode);
        if Language.GetLanguageIdOrDefault(LanguageCode) = 1041 then
            exit(UnitofMeasure.Description)
        else begin
            if UnitOfMeasureTranslation.Get(UnitofMeasure.Code, LanguageCode) then
                exit(UnitOfMeasureTranslation.Description);
            exit(UoMCode);
        end;
    end;

    var
        LanguageCode: Code[10];
        RepTitleLbl: Label 'Service Report';
        PageLbl: Label 'Page';
        DateLbl: Label 'Date -';
        OrderNoLbl: Label 'Order No. -';
        CustLbl: Label 'Customer';
        ContactLbl: Label 'Contact';
        EquipmentLbl: Label 'Equipment';
        WrkConditionLbl: Label 'Work Condition';
        SrvOrdTypeLbl: Label 'Serv. Ord. Type';
        ProdNoLbl: Label 'Prod. No.';
        WorkDateLbl: Label 'Work Date';
        TelLbl: Label 'Tel #';
        SerialNoLbl: Label 'Serial No.';
        WarrantyLbl: Label 'Warranty';
        SeriesNoLbl: Label 'Series No.';
        ProdTimeLbl: Label 'Production Time';
        WorkerLbl: Label 'Worker';
        ServItemStatusLbl: Label 'Service Item Status';
        FaultAreaLbl: Label 'Fault Area';
        SymptomLbl: Label 'Symptom';
        FaultLbl: Label 'Fault';
        ResolutionLbl: Label 'Resolution';
        InternalLbl: Label 'Internal';
        TypeLbl: Label 'Type';
        NoLbl: Label 'No.';
        LotNoLbl: Label 'Lot No.';
        SrlNoLbl: Label 'Serial No.';
        DescLbl: Label 'Description';
        QtyLbl: Label 'Qty.';
        UOMLbl: Label 'UOM';
        UnitPriceLbl: Label 'Unit Price';
        AmountLbl: Label 'Amount';
        TotalAmtLbl: Label 'Total';
        StartingLbl: Label 'Starting';
        StartEndTimeLbl: Label 'Start & End Time';
        HrsLbl: Label 'h';
        CostOfRLbl: Label 'Cost of R';
        AuthorizedLbl: Label 'Authorized';
        ConfirmLbl: Label 'Confirmed';
        CreatedLbl: Label 'Created';
}