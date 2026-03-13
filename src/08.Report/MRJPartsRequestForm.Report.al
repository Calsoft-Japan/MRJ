report 50071 "Parts Request Form"
{
    Caption = 'Parts Request Form';
    UsageCategory = None;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJPartsRequestForm.rdlc';

    dataset
    {
        dataitem("Service Header"; "Service Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.";

            column(PageLbl; PageLbl) { }
            column(DateLbl; DateLbl) { }
            column(PartsTRNoLbl; PartsTRNoLbl) { }
            column(BinDescLbl; BinDescLbl) { }
            column(BinCodeLbl; BinCodeLbl) { }
            column(ReqShipDateLbl; ReqShipDateLbl) { }
            column(UserIDLbl; UserIDLbl) { }
            column(UserNameLbl; UserNameLbl) { }
            column(ReqDateLbl; ReqDateLbl) { }
            column(ItemNoLbl; ItemNoLbl) { }
            column(ItemDescLbl; ItemDescLbl) { }
            column(ShelfNoLbl; ShelfNoLbl) { }
            column(SerlNoLbl; SerlNoLbl) { }
            column(QtyLbl; QtyLbl) { }
            column(RetQtyLbl; RetQtyLbl) { }
            column(RepCapLbl; RepCapLbl) { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(PageDate; Format(Today, 0, '<Year4>/<Month,2>/<Day,2>')) { }
            column(PartsTransferNo; PartsTransferNo) { }
            column(BinDesc; BinDesc) { }
            column(BinCode; "Bin Code") { }
            column(ReqStartDateTxt; Format(ReqStartDate, 0, '<Year4>/<Month,2>/<Day,2>')) { }
            column(ReqEndDateTxt; Format(ReqEndDate, 0, '<Year4>/<Month,2>/<Day,2>')) { }
            column(UserIDTxt; UserIDTxt) { }
            column(UserName; UserName) { }

            dataitem("Service Line"; "Service Line")
            {
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") order(Ascending) where("Document Type" = const(Order), Type = const(Item), "No." = filter(<> ''));
                DataItemLink = "Document No." = field("No."), "Document Type" = field("Document Type"), "Customer No." = field("Customer No.");

                trigger OnAfterGetRecord() //ServiceLine DataItem
                begin
                    if PartsTransBuf.Get("Service Header"."No.", "Service Line"."No.") then begin
                        PartsTransBuf."Qty. to Use" += "Quantity (Base)";
                        PartsTransBuf.Modify();
                    end else begin
                        PartsTransBuf.Init();
                        PartsTransBuf."Order No." := "Service Header"."No.";
                        PartsTransBuf."Item No." := "Service Line"."No.";
                        if Item.Get("Service Line"."No.") then;
                        PartsTransBuf."Unit of Measure Code" := Item."Base Unit of Measure";
                        PartsTransBuf."Qty. to Use" := "Quantity (Base)";
                        PartsTransBuf."Qty. Received" := 0;
                        PartsTransBuf."To Location Code" := "Location Code";
                        PartsTransBuf."To Bin Code" := "Bin Code";
                        PartsTransBuf.Availability := 0;
                        PartsTransBuf.Insert();
                    end;
                end;
            }
            dataitem("Warehouse Entry"; "Warehouse Entry")
            {
                DataItemTableView = sorting("Bin Code", "Location Code", "Item No.") where("Item No." = filter(<> ''));
                DataItemLink = "Location Code" = field("Location Code"), "Bin Code" = field("Bin Code");

                trigger OnPreDataItem() //WarehouseEntry DataItem
                var
                    TransNoFilter: Text[1024];
                begin
                    TransNoFilter := '';
                    if "Service Header"."Parts Receive TO No. Filter" <> '' then
                        TransNoFilter := "Service Header"."Parts Receive TO No. Filter";
                    if "Service Header"."Parts Return TO No. Filter" <> '' then begin
                        if TransNoFilter <> '' then
                            TransNoFilter += '';
                        TransNoFilter += "Service Header"."Parts Return TO No. Filter";
                    end;
                    if TransNoFilter = '' then
                        SetFilter("Source No.", '>1&<0') // no match
                    else
                        SetFilter("Source No.", TransNoFilter);
                end;

                trigger OnAfterGetRecord() //WarehouseEntry DataItem
                begin
                    if PartsTransBuf.Get("Service Header"."No.", "Warehouse Entry"."Item No.") then begin
                        PartsTransBuf."Qty. Received" += Quantity;
                        PartsTransBuf.Modify();
                    end else begin
                        PartsTransBuf.Init();
                        PartsTransBuf."Order No." := "Service Header"."No.";
                        PartsTransBuf."Item No." := "Warehouse Entry"."Item No.";
                        PartsTransBuf."Unit of Measure Code" := "Unit of Measure Code";
                        PartsTransBuf."Qty. to Use" := 0;
                        PartsTransBuf."Qty. Received" := Quantity;
                        PartsTransBuf."To Location Code" := "Location Code";
                        PartsTransBuf."To Bin Code" := "Bin Code";
                        PartsTransBuf.Availability := 0;
                        PartsTransBuf.Insert();
                    end;
                end;
            }
            dataitem("Parts Transfer Buffer"; "Parts Transfer Buffer")
            {
                DataItemTableView = sorting("Order No.", "Item No.");
                DataItemLink = "Order No." = field("No."), "To Location Code" = field("Location Code"), "To Bin Code" = field("Bin Code");

                column(OrderNo; "Order No.") { }
                column(ItemNo; "Item No.") { }
                column(UnitOfMeasureCode; "Unit of Measure Code") { }
                column(QtyToUse; "Qty. to Use") { }
                column(QtyReceived; "Qty. Received") { }
                dataitem(ShowLine; Integer)
                {
                    DataItemTableView = sorting(Number);

                    column(LineQty; Qty) { DecimalPlaces = 0 : 0; }
                    column(ItemShelfNo; Item."Shelf No.") { }
                    column(ItemDescription; Item.Description) { }
                    column(ItemNumber; Item."No.") { }
                    trigger OnPreDataItem() //ShoLine DataItem
                    begin
                        SetRange(Number, 1, ShowLineCnt);
                    end;
                }

                trigger OnAfterGetRecord()  //PartsTransferBuffer DataItem
                var
                    ItemTrackingCode: Record "Item Tracking Code";
                begin
                    ShowLineCnt := 1;
                    Qty := ("Qty. to Use" - "Qty. Received");
                    if Qty < 1 then begin
                        CurrReport.Skip();
                        exit;
                    end;

                    if Item.Get("Item No.") then begin
                        if ItemTrackingCode.Get(Item."Item Tracking Code") then
                            if ItemTrackingCode."SN Specific Tracking" then begin
                                ShowLineCnt := Qty;
                                Qty := 1;
                            end;
                    end else
                        CurrReport.Skip();
                end;
            }

            trigger OnAfterGetRecord() //ServiceHeader DataItem
            var
                Bin: Record Bin;
            begin
                BinDesc := '';
                if "Bin Code" <> '' then begin
                    if Bin.Get("Location Code", "Bin Code") then
                        BinDesc := Bin.Description;
                end;

                UserIDTxt := UserId();
                if RecUser.Get(UserSecurityId()) then
                    UserName := RecUser."User Name"
                else
                    UserName := UserIDTxt;

                PartsTransferNo := "No.";
                if "Parts Receive TO No. Filter" <> '' then begin
                    TransferHeader.Reset();
                    TransferHeader.SetFilter("No.", "Parts Receive TO No. Filter");
                    if TransferHeader.FindLast() then
                        PartsTransferNo := "No." + '-' + Format(TransferHeader."Parts Trans. Archived Ver. No.")
                    else begin
                        VerNo := 0;
                        TransShptHeader.Reset();
                        TransShptHeader.SetFilter("Transfer Order No.", "Parts Receive TO No. Filter");
                        if TransShptHeader.FindSet() then
                            repeat
                                if VerNo < TransShptHeader."Parts Trans. Archived Ver. No." then
                                    VerNo := TransShptHeader."Parts Trans. Archived Ver. No.";
                            until TransShptHeader.Next() = 0;
                        PartsTransferNo := "No." + '-' + Format(VerNo);
                    end;
                end else
                    PartsTransferNo := "No.";
            end;

            trigger OnPostDataItem() //ServiceHeader DataItem
            begin
                PartsTransBuf.DeleteAll();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Group)
                {
                    field(ReqStartDate; ReqStartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date'; // JPN: 開始日
                    }
                    field(ReqEndDate; ReqEndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date'; // JPN: 終了日
                        trigger OnValidate()
                        begin
                            if ReqEndDate < ReqStartDate then
                                Error(Text001);
                        end;
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            ReqStartDate := WorkDate();
            ReqEndDate := WorkDate();
        end;
    }
    trigger OnPreReport() //Report DataItem
    begin
        if ReqEndDate = 0D then
            Error(Text000);
        if ReqEndDate < ReqStartDate then
            Error(Text001);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        TransferHeader: Record "Transfer Header";
        TransShptHeader: Record "Transfer Shipment Header";
        PartsTransBuf: Record "Parts Transfer Buffer";
        Item: Record Item;
        RecUser: Record User;
        PartsTransferNo: Code[40];
        BinDesc: Text[50];
        ReqStartDate: Date;
        ReqEndDate: Date;
        UserName: Text[50];
        UserIDTxt: Text[50];
        VerNo: Integer;
        Qty: Decimal;
        ShowLineCnt: Integer;
        PageLbl: Label 'Page';
        DateLbl: Label 'Date -';
        PartsTRNoLbl: Label 'Parts Transfer No. -';
        RepCapLbl: Label 'Parts Request Form';
        BinDescLbl: Label 'Bin Description';
        BinCodeLbl: Label 'Bin Code';
        ReqShipDateLbl: Label 'Requested Ship. Date';
        UserIDLbl: Label 'User ID';
        UserNameLbl: Label 'User Name';
        ReqDateLbl: Label 'Requested Date';
        ItemNoLbl: Label 'Item No.';
        ItemDescLbl: Label 'Description';
        ShelfNoLbl: Label 'Shelf No.';
        SerlNoLbl: Label 'Serial No.';
        QtyLbl: Label 'Qty.';
        RetQtyLbl: Label 'Ret. Qty.';
        Text000: Label 'You must fill in Requested Date.'; // JPN: 依頼日を入力してください。
        Text001: Label 'Request Shipping Date is greater than Requested Date.'; // JPN: 出荷要求日が依頼日より後の日付になっています。
}