report 50084 "Pstd. Service Work Report"
{
    Caption = 'Posted Service Work Report';
    UsageCategory = None;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJServiceWorkReportPstd.rdlc';

    dataset
    {
        dataitem("Service Shipment Header"; "Service Shipment Header")
        {
            DataItemTableView = sorting("No.");
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

            dataitem("Service Shipment Item Line"; "Service Shipment Item Line")
            {
                DataItemTableView = sorting("No.", "Line No.") where("Service Item No." = filter(<> ''), "Serial No." = filter(<> ''));
                DataItemLink = "No." = field("No.");
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

                dataitem("Service Shipment Line"; "Service Shipment Line")
                {
                    DataItemLink = "Document No." = field("No."), "Service Item No." = field("Service Item No.");
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
                    column(SrvLineUOM; UOM) { }
                    column(SrvLineCalcQty; ServShptLineQty) { }
                    column(SrvLineCalcAmt; ServShptLineAmt) { }
                    column(SrvLineLotNo; ServShptLineLotNo) { }
                    dataitem(ServShptLines; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(TotalText; TotalText) { }
                        column(TotalLineAmtText; TotalLineAmtText) { }
                        column(DisclaimerText; DisclaimerText) { }
                        column(ILELotNo; ItemLedgerEntry."Lot No.") { }
                        column(ILESerialNo; ItemLedgerEntry."Serial No.") { }
                        trigger OnPreDataItem() //ServShptLinesInteger DataItem
                        begin
                            SetRange(Number, 1, ItemLedgerCnt);
                        end;

                        trigger OnAfterGetRecord() //ServShptLinesInteger DataItem
                        begin
                            LineLoopCnt += 1;

                            if (ItemLedgerCnt > 1) and (PrintOption = PrintOption::All) then
                                ItemLedgerEntry.Next();

                            if LineLoopCnt > 1 then
                                if (LineLoopCnt mod PageBreak) = 1 then begin
                                    TotalText := '';
                                    TotalLineAmtText := '';
                                    UnderLine := '';
                                    DisclaimerText := '';
                                    LineLoopCnt := 1;
                                end;

                            TotalText := TotalLbl;
                            TotalLineAmtText := Format(TotalLineAmt);
                            DisclaimerText := DisclaimerLbl;
                        end;
                    }
                    trigger OnPreDataItem() //ServiceShipmentLines DataItem
                    begin
                        TotalLineAmt := 0;
                    end;

                    trigger OnAfterGetRecord() //ServiceShipmentLines DataItem
                    var
                        UnitofMeasure: Record "Unit of Measure";
                    begin
                        UOM := GetUnitOfMeasureText("Unit of Measure Code", CurrReport.Language.ToText());

                        ServShptLineQty := Quantity;
                        ServShptLineAmt := Amount;

                        // Lot/serial branching via Item Ledger
                        ServShptLineLotNo := '';
                        ItemLedgerCnt := 1;

                        if PrintOption <> PrintOption::ItemOnly then begin
                            ItemLedgerEntry.Reset();
                            ItemLedgerEntry.SetRange("Document No.", "Document No.");
                            ItemLedgerEntry.SetRange("Document Line No.", "Line No.");
                            ItemLedgerEntry.SetRange("Item No.", "No.");
                            if ItemLedgerEntry.FindSet() then begin
                                case PrintOption of
                                    PrintOption::ItemAndLot:
                                        ServShptLineLotNo := ItemLedgerEntry."Lot No.";
                                    PrintOption::All:
                                        begin
                                            ItemLedgerCnt := ItemLedgerEntry.Count();
                                            if ServShptLineQty <> 0 then
                                                ServShptLineAmt := Amount / ServShptLineQty
                                            else
                                                ServShptLineAmt := 0;
                                            ServShptLineQty := 1;
                                        end;
                                end;
                            end;
                        end;

                        ServLineCnt += ItemLedgerCnt;
                        TotalLineAmt += ServShptLineAmt;
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
                        ItemLedgerCnt := 0;
                        LineLoopCnt := 0;
                        ServLineCnt := 0;
                        GridLineCnt := 0;
                    end;
                }
                trigger OnAfterGetRecord() //ServiceShipmentItemLine DataItem
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

            trigger OnAfterGetRecord() //ServiceShipmentHeader DataItem
            var
                LangId: Integer;
            begin
                if CurrReport.Language = 1041 then
                    OutputDate := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日')
                else
                    OutputDate := Format("Document Date", 0, '<Year4>/<Month,2>/<Day,2>');

                CompanyML(CompanyAddr, CompanyInfo, CurrReport.Language);

                ServiceShptSellToML(CustAddr, "Service Shipment Header", CurrReport.Language);
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

    local procedure SetComment(var Comment: array[4] of Text[80]; CType: Enum "Service Comment Line Type")
    var
        LoopCnt: Integer;
    begin
        ServCommentLine.Reset();
        ServCommentLine.SetRange("No.", "Service Shipment Item Line"."No.");
        ServCommentLine.SetRange(Type, CType);
        ServCommentLine.SetRange("Table Line No.", "Service Shipment Item Line"."Line No.");

        if ServCommentLine.FindFirst() then begin
            LoopCnt := 1;
            repeat
                Comment[LoopCnt] := ServCommentLine.Comment;
                LoopCnt += 1;
            until (ServCommentLine.Next() = 0) or (LoopCnt > 4);
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

    procedure ServiceShptSellToML(var AddrArray: array[8] of Text[50]; var ServiceShptHeader: Record "Service Shipment Header"; LanguageID: Integer)
    var
        Customer: Record Customer;
    begin
        if Customer.Get("Service Shipment Header"."Customer No.") then;
        if LanguageID = 1041 then
            FormatAddrJPN(AddrArray,
                ServiceShptHeader.Name, ServiceShptHeader."Name 2", ServiceShptHeader."Contact Name",
                ServiceShptHeader.Address, ServiceShptHeader."Address 2", ServiceShptHeader.City,
                ServiceShptHeader."Post Code", ServiceShptHeader.County, ServiceShptHeader."Country/Region Code",
                ServiceShptHeader."Phone No.", ServiceShptHeader."Fax No.", Customer.NameTitle, Customer.ContactTitle)
        else
            FormatAddrENU(AddrArray,
                ServiceShptHeader.Name, ServiceShptHeader."Name 2", ServiceShptHeader."Contact Name",
                ServiceShptHeader.Address, ServiceShptHeader."Address 2", ServiceShptHeader.City,
                ServiceShptHeader."Post Code", ServiceShptHeader.County, ServiceShptHeader."Country/Region Code",
                ServiceShptHeader."Phone No.", ServiceShptHeader."Fax No.", Customer.NameTitle, Customer.ContactTitle);
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
        CompanyInfo: Record "Company Information";
        ItemLedgerEntry: Record "Item Ledger Entry";
        FaultArea: Record "Fault Area";
        Symptom: Record "Symptom Code";
        Fault: Record "Fault Code";
        Resolution: Record "Resolution Code";
        RepairStatus: Record "Repair Status";
        ServCommentLine: Record "Service Comment Line";
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
        ItemLedgerCnt: Integer;
        ServShptLineQty: Decimal;
        ServShptLineAmt: Decimal;
        ServShptLineLotNo: Code[20];
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
        TotalLbl: Label 'Total', Locked = true;
        DisclaimerLbl: Label '※上記金額に、消費税は含まれておりません。';
}