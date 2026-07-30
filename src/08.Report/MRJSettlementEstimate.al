report 50100 "MRJ Settlement Estimate"
{
    Caption = 'Settlement Estimate';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Description = 'Report to estimate settlement amounts for MRJ.';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJSettlementEstimateReport.rdlc';

    dataset
    {
        dataitem(SvcShipHdr; "Service Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Customer No.";

            // =========================
            // Header
            // =========================
            column(PostingDateTxt; PostingDateTxt) { }
            column(ShowSeal; ShowSeal) { }
            column(CompanySeal; CompanyInfo.Picture) { }
            column(CurrencyCode_ServHeader; "Currency Code") { }
            column(TitleTxt; TitleTxt) { }
            column(ShowOrderInfo; ShowOrderInfo) { }
            column(SummarizeLines; SummarizeLines) { }

            // ---- Identifiers ----
            column(CustomerNo; "Customer No.") { }
            column(ShipNo; "No.") { }
            column(OrderNo; "Order No.") { }
            column(DocumentDateTxt; DocumentDateTxt) { }
            column(DeliveryNoteNo; "No.") { }  // 納品書番号

            // ---- Customer (Left header block) ----
            column(CustName; CustAddr[1]) { }
            column(CustAddr2; "Ship-to Contact") { }
            column(CustAddr3; "Ship-to Address") { }
            column(CustAddr4; "Ship-to Address 2") { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { } // Post Code
            column(CustAddr7; CustAddr[7]) { } // TEL
            column(CustAddr8; CustAddr[8]) { } // FAX

            // ---- Company (Right header block) ----
            column(CompanyName; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyInfo."Phone No.") { }
            column(CompanyAddr7; CompanyInfo."Fax No.") { }
            column(CompanyAddr0; CompanyInfo."Post Code") { }

            // ---- Registration No. ----
            column(CompanyRegistrationLine; CompanyRegistrationLine) { }
            column(CompanyRegistrationNo; CompanyInfo."Registration No.") { }

            // ---- Bank (Company Info only) ----
            column(PaymentBank1; PaymentBank[1]) { }
            column(PaymentBank2; PaymentBank[2]) { }
            column(PaymentBank3; PaymentBank[3]) { }

            // ---- Totals ----
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }

            // Payment terms, Payment method
            column(PaymentTermText; PaymentTermText) { }
            column(PaymentMethodText; PaymentMethodText) { }

            // =========================
            // 1) サービス品目ライン
            // =========================
            dataitem(SvcShipItemLine; "Service Shipment Item Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemLinkReference = SvcShipHdr;
                DataItemTableView = sorting("No.", "Line No.");

                column(ServiceItemNo; "Service Item No.") { }
                column(ServiceItemGroupCode; "Service Item Group Code") { }
                column(ItemNo; "Item No.") { }
                column(SerialNo; "Serial No.") { }
                column(ServiceItemDescription; Description) { }
                column(Warranty; WarrantyTxt) { }

                trigger OnPreDataItem()
                begin
                    // Extra safety: enforce same header no.
                    SetRange("No.", SvcShipHdr."No.");
                end;

                trigger OnAfterGetRecord()
                begin
                    WarrantyTxt := GetYesNo(Warranty);
                end;
            }

            // =========================
            // 2) サービスライン（明細） OFF
            // =========================
            dataitem(SvcShipLine; "Service Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = SvcShipHdr;
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo_ServLine; "Line No.") { }
                column(Type_ServLine; Type) { }
                column(Description_ServLine; Description) { }
                column(Quantity_ServLine; Quantity) { }
                column(UnitPrice_ServLine; "Unit Price") { }
                column(Amt; LineAmountCalc) { }
                column(GrossAmt; "Amount Including VAT") { }
                column(LineUOM; "Unit of Measure") { }

                column(Quantity_ServLineCaption; FieldCaption(Quantity)) { }
                column(UnitPrice_ServLineCaption; FieldCaption("Unit Price")) { }
                column(Description_ServLineCaption; FieldCaption(Description)) { }

                trigger OnPreDataItem()
                begin
                    if SummarizeLines then
                        CurrReport.Break();
                end;

                trigger OnAfterGetRecord()
                begin
                    if Quantity <> 0 then
                        LineAmountCalc := Round("Unit Price" * Quantity, 1)
                    else
                        LineAmountCalc := Round("Unit Price", 1);
                end;
            }

            // =========================
            // 2b) 明細纏め（Integer） ON
            // =========================
            dataitem(SummarizedShipLine; Integer)
            {
                DataItemTableView = sorting(Number);

                column(FlatLineNo; Number) { }
                column(FlatLineType; FlatLineType) { }
                column(FlatLineDescription; FlatLineDescription) { }
                column(FlatLineQuantity; FlatQty) { }
                column(FlatLineUOM; FlatUOM) { }
                column(FlatUnitPrice; FlatPrice) { }
                column(FlatLineAmount; FlatAmount) { }

                column(FlatFaultReasonCode; FlatFaultReasonCode) { }
                column(FlatFaultReasonDisplay; FlatFaultReasonDisplay) { }
                column(FlatLineDiscountAmt; FlatLineDiscountAmt) { }

                trigger OnPreDataItem()
                begin
                    if not SummarizeLines then
                        CurrReport.Break();

                    SummarizeShipmentLinesProc();

                    if TempShipLine.Count() = 0 then
                        CurrReport.Break();

                    SetRange(Number, 1, TempShipLine.Count());

                    TempShipLine.FindSet();
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempShipLine.FindSet()
                    else
                        TempShipLine.Next();

                    FlatFaultReasonCode := '';
                    FlatFaultReasonDisplay := '';
                    FlatLineDiscountAmt := 0;

                    FlatLineDescription := TempShipLine.Description;
                    FlatQty := TempShipLine.Quantity;
                    FlatUOM := TempShipLine."Unit of Measure";
                    FlatPrice := TempShipLine."Unit Price";
                    FlatAmount := TempShipLine.Amount + TempShipLine."Shipment Line Discount Amount";

                    case TempShipLine.Type of
                        TempShipLine.Type::Item:
                            FlatLineType := 'ITEM';
                        TempShipLine.Type::Resource:
                            FlatLineType := 'RESOURCE';
                        TempShipLine.Type::Cost:
                            FlatLineType := 'COST';
                        else
                            FlatLineType := 'OTHER';
                    end;
                end;
            }

            // =========================
            // 摘要 / コメント
            // =========================
            dataitem(SvcShipComment; "Service Comment Line")
            {
                DataItemLinkReference = SvcShipHdr;
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("No.", "Line No.");

                column(CommentDate; Date) { }
                column(CommentText; Comment) { }

                trigger OnPreDataItem()
                begin
                    SetRange("Table Line No.", 0);
                    SetFilter(Comment, '<>%1', '');
                end;
            }

            // =========================
            // VAT Summary
            // =========================
            dataitem(VATSummary; Integer)
            {
                DataItemTableView = sorting(Number);

                column(VATDisplayTxt; VATDisplayTxt) { }
                column(VATBaseAmount; VATBaseAmount) { }
                column(VATLabelTxt; '消費税') { }
                column(VATAmount; VATAmount) { }

                trigger OnPreDataItem()
                begin
                    if VatPctList.Count() = 0 then
                        CurrReport.Break();
                    SetRange(Number, 1, VatPctList.Count());
                end;

                trigger OnAfterGetRecord()
                var
                    VatPct: Decimal;
                    BaseDec: Decimal;
                begin
                    VatPctList.Get(Number, VatPct);
                    VatSummaryDict.Get(VatPct, BaseDec);

                    if VatPct = 0 then
                        VATDisplayTxt := '非課税'
                    else
                        VATDisplayTxt := Format(VatPct, 0, '<Integer>') + '%対象';

                    VATBaseAmount := BaseDec;
                    VATAmount := Round(VATBaseAmount * VatPct / 100, 0.1);
                end;
            }

            trigger OnAfterGetRecord()
            var
                RespCenter: Record "Responsibility Center";
                ShipLineTmp: Record "Service Shipment Line";
                LineBase: Decimal;
                LineVAT: Decimal;
            begin
                if ShowOrderInfo then
                    TitleTxt := 'Settlement Estimate';

                CompanyInfo.CalcFields(Picture);

                PostingDateTxt := Format("Posting Date", 0, '<Year4>年<Month,2>月<Day,2>日');
                DocumentDateTxt := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                Clear(CompanyAddr);
                if ("Responsibility Center" <> '') and RespCenter.Get("Responsibility Center") then
                    FormatAddress.RespCenter(CompanyAddr, RespCenter)
                else
                    FormatAddress.Company(CompanyAddr, CompanyInfo);

                FillPaymentBankFromCompanyInfo();

                Clear(CustAddr);
                FillServiceShipTo(CustAddr, SvcShipHdr);

                CompanyRegistrationLine := BuildRegistrationLine();

                Clear(PaymentTermText);
                if "Payment Terms Code" <> '' then
                    if PaymentTerms.Get("Payment Terms Code") then
                        PaymentTermText := PaymentTerms.Description;

                Clear(PaymentMethodText);
                if "Payment Method Code" <> '' then
                    if PaymentMethod.Get("Payment Method Code") then
                        PaymentMethodText := PaymentMethod.Description;

                // Totals + VAT
                TotalExclVAT := 0;
                TotalVAT := 0;
                TotalInclVAT := 0;
                Clear(VatSummaryDict);
                Clear(VatPctList);

                ShipLineTmp.Reset();
                ShipLineTmp.SetRange("Document No.", "No.");

                if ShipLineTmp.FindSet() then
                    repeat
                        LineBase := ShipLineTmp.Amount;
                        if LineBase = 0 then
                            continue;

                        TotalExclVAT += LineBase;

                        LineVAT := Round(LineBase * ShipLineTmp."VAT %" / 100, 0.1);
                        TotalVAT += LineVAT;
                        TotalInclVAT += LineBase + LineVAT;

                        AddOrUpdateVatSummary(ShipLineTmp."VAT %", LineBase);
                    until ShipLineTmp.Next() = 0;
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
                    field(SummarizeLinesField; SummarizeLines)
                    {
                        ApplicationArea = All;
                        Caption = 'Summarize Lines';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        if not CompanyInfo.Get() then
            CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
        FormatAddress: Codeunit "Format Address";

        ShowSeal: Boolean;
        ShowOrderInfo: Boolean;
        SummarizeLines: Boolean;

        PaymentBank: array[3] of Text[50];
        CustAddr: array[8] of Text[90];
        CompanyAddr: array[8] of Text[90];

        CompanyRegistrationLine: Text[100];
        PostingDateTxt: Text[50];
        DocumentDateTxt: Text[50];
        TitleTxt: Text[100];
        ServiceItemNo: Code[20];

        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;

        VatSummaryDict: Dictionary of [Decimal, Decimal];
        VatPctList: List of [Decimal];

        VATDisplayTxt: Text[20];
        VATBaseAmount: Decimal;
        VATAmount: Decimal;

        WarrantyTxt: Text[3];
        PaymentTermText: Text[250];
        PaymentMethodText: Text[250];
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";

        LineAmountCalc: Decimal;

        TempShipLine: Record "Service Shipment Line" temporary;
        TempServiceLine: Record "Service Line" temporary;

        FlatLineDescription: Text[100];
        FlatQty: Decimal;
        FlatUOM: Text[50];
        FlatPrice: Decimal;
        FlatAmount: Decimal;
        FlatLineType: Text[20];

        FlatFaultReasonCode: Text[100];
        FlatFaultReasonDisplay: Text[120];
        FlatLineDiscountAmt: Decimal;

        TotalAmt: Decimal;
        TotalGrossAmt: Decimal;
        Amt: Decimal;
        GrossAmt: Decimal;

    // -------------------------
    // 明細纏めロジック（Integer dataitem）
    // -------------------------
    local procedure SummarizeShipmentLinesProc()
    var
        ShipLineRec: Record "Service Shipment Line";
        Res: Record Resource;
        ResGrp: Record "Resource Group";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        TempSortBuffer: Record "Service Shipment Line" temporary;
        NextLineNo: Integer;
        CurrentResGrp: Code[20];
        TargetResGrp: Code[20];
        LineBaseAmount: Decimal;
        boolFound: Boolean;
        PreResGrp: Code[20];
        FaultReasonName: Text[50];
        FaultReasonCodeMst: Record "Fault Reason Code";
        Text50020: Label '%1（値引）', Comment = '%1 = Fault Reason Description';
        TempLineNo: Integer; // ★追加：一時的な行番号用
    begin
        TempShipLine.Reset();
        TempShipLine.DeleteAll();

        TotalAmt := 0;
        TotalGrossAmt := 0;

        ServiceMgtSetup.Get();

        ShipLineRec.Reset();
        ShipLineRec.SetRange("Document No.", SvcShipHdr."No.");
        if ShipLineRec.FindSet() then
            repeat
                Amt := ShipLineRec.Quantity * ShipLineRec."Unit Price";
                GrossAmt := Amt + Round(Amt * ShipLineRec."VAT %" / 100, 0.1);
                TotalAmt += Amt;
                TotalGrossAmt += GrossAmt;

                LineBaseAmount := Amt;
                if LineBaseAmount = 0 then
                    continue;

                boolFound := false;
                CurrentResGrp := '';
                TargetResGrp := '';

                if ShipLineRec.Type = ShipLineRec.Type::Resource then begin
                    if Res.Get(ShipLineRec."No.") then begin
                        CurrentResGrp := Res."Resource Group No.";
                        TargetResGrp := CurrentResGrp;

                        if (ServiceMgtSetup."Resource Group Filter" <> '') and
                           (StrPos(ServiceMgtSetup."Resource Group Filter", CurrentResGrp) > 0) then
                            TargetResGrp := ServiceMgtSetup."Resource Group for Sort";
                    end;

                    if TargetResGrp <> '' then begin
                        TempShipLine.Reset();
                        TempShipLine.SetRange(Type, TempShipLine.Type::Resource);
                        TempShipLine.SetRange("Resource Group No.", TargetResGrp);

                        if TempShipLine.FindFirst() then begin
                            TempShipLine.Quantity += ShipLineRec.Quantity;
                            TempShipLine.Amount += ShipLineRec.Amount;
                            TempShipLine."Amount Including VAT" += ShipLineRec."Amount Including VAT";
                            TempShipLine."Shipment Line Discount Amount" += ShipLineRec."Shipment Line Discount Amount";
                            TempShipLine.Modify();
                            boolFound := true;
                        end;
                    end;
                end;

                if not boolFound then begin
                    TempShipLine.Init();
                    TempShipLine.TransferFields(ShipLineRec);

                    TempShipLine."Resource Group No." := TargetResGrp;
                    if (ShipLineRec.Type = ShipLineRec.Type::Resource) and (TargetResGrp <> '') then
                        if ResGrp.Get(TargetResGrp) then
                            TempShipLine.Description := ResGrp.Name;

                    TempShipLine.Insert();
                end;

                // ★ ここで「同じループ内」でもう一度、値引用の処理を行います。
                if ShipLineRec."Line Discount %" > 0 then begin
                    FaultReasonName := '';
                    if FaultReasonCodeMst.Get(ShipLineRec."Fault Reason Code") then
                        FaultReasonName := FaultReasonCodeMst.Description;

                    // 一時テーブル内で「今回の原因コード」の値引専用行(Cost)が既にあるか探す
                    TempShipLine.Reset();
                    TempShipLine.SetRange(Type, TempServiceLine.Type::Cost);
                    TempShipLine.SetRange("Fault Reason Code", ShipLineRec."Fault Reason Code");

                    if TempShipLine.FindFirst() then begin
                        // 既にあれば金額を加算（マイナスを引く）
                        TempShipLine.Amount -= ShipLineRec."Shipment Line Discount Amount";
                        TempShipLine.Modify();
                    end else begin
                        // なければ「値引用レコード」として新規作成
                        TempShipLine.Reset();
                        TempShipLine.Init();
                        //TempShipLine."Document Type" := Enum::" Service Document Type "::Order;
                        TempShipLine."Document No." := ShipLineRec."Document No.";
                        TempShipLine."Line No." := TempLineNo; // -1, -2...
                        TempLineNo -= 1;

                        TempShipLine.Type := TempServiceLine.Type::Cost; // ★ここでCostを付与
                        TempShipLine."Fault Reason Code" := ShipLineRec."Fault Reason Code";

                        if FaultReasonName <> '' then
                            TempShipLine.Description := StrSubstNo(Text50020, FaultReasonName)
                        else
                            TempShipLine.Description := '値引';

                        TempShipLine.Amount := -ShipLineRec."Shipment Line Discount Amount";
                        TempShipLine.Quantity := 1;
                        TempShipLine.Insert();
                    end;
                end;

            until ShipLineRec.Next() = 0;

        // When both "02 SERVICE" and "03 OUTSOURCE-L" line items are included
        PreResGrp := '';
        ShipLineRec.Reset();
        ShipLineRec.SetRange("Document No.", SvcShipHdr."No."); // Posted shipment lines link by Document No.
        if ShipLineRec.FindSet() then
            repeat
                // DEV NOTE:
                // Use actual posted values from Service Shipment Line.
                Amt := ShipLineRec.Amount;
                GrossAmt := ShipLineRec."Amount Including VAT";

                LineBaseAmount := Amt;
                if LineBaseAmount = 0 then
                    continue;

                // Resource group logic (if shipment line type supports Resource)
                CurrentResGrp := '';

                if ShipLineRec.Type = ShipLineRec.Type::Resource then begin
                    if Res.Get(ShipLineRec."No.") then begin
                        CurrentResGrp := Res."Resource Group No.";

                        if (ServiceMgtSetup."Resource Group Filter" <> '') and
                           (StrPos(ServiceMgtSetup."Resource Group Filter", CurrentResGrp) > 0) then begin
                            // Compare with the Previous value
                            if (PreResGrp <> '') and (CurrentResGrp <> PreResGrp) then begin

                                TempShipLine.Reset();
                                TempShipLine.SetRange("Resource Group No.", ServiceMgtSetup."Resource Group for Sort");
                                if TempShipLine.FindFirst() then begin
                                    TempShipLine."Unit of Measure" := 'SET';
                                    TempShipLine.Quantity := 1;
                                    TempShipLine.Modify();
                                end;
                            end;
                            PreResGrp := CurrentResGrp;
                        end;
                    end;
                end;

            until ShipLineRec.Next() = 0;

        // ---- Sort: Resource -> Item -> Other ----
        TempSortBuffer.Reset();
        TempSortBuffer.DeleteAll();
        NextLineNo := 10000;

        TempShipLine.Reset();
        TempShipLine.SetRange(Type, TempShipLine.Type::Resource);
        TempShipLine.SetCurrentKey("Resource Group No.");
        if TempShipLine.FindSet() then
            repeat
                InsertIntoShipBuffer(TempShipLine, TempSortBuffer, NextLineNo);
            until TempShipLine.Next() = 0;

        TempShipLine.Reset();
        TempShipLine.SetRange(Type, TempShipLine.Type::Item);
        if TempShipLine.FindSet() then
            repeat
                InsertIntoShipBuffer(TempShipLine, TempSortBuffer, NextLineNo);
            until TempShipLine.Next() = 0;

        TempShipLine.Reset();
        TempShipLine.SetFilter(Type, '<>%1&<>%2', TempShipLine.Type::Resource, TempShipLine.Type::Item);
        TempShipLine.SetCurrentKey("Fault Reason Code");
        if TempShipLine.FindSet() then
            repeat
                InsertIntoShipBuffer(TempShipLine, TempSortBuffer, NextLineNo);
            until TempShipLine.Next() = 0;

        TempShipLine.Reset();
        TempShipLine.DeleteAll();
        if TempSortBuffer.FindSet() then
            repeat
                TempShipLine.TransferFields(TempSortBuffer);
                TempShipLine.Insert();
            until TempSortBuffer.Next() = 0;
    end;

    // -------------------------
    // Ship-to address + TEL/FAX
    // -------------------------
    local procedure FillServiceShipTo(var Addr: array[8] of Text[90]; Hdr: Record "Service Shipment Header")
    var
        C: Record Customer;
        Tmp: array[8] of Text[100];
        i: Integer;
        TelTxt: Text[80];
        FaxTxt: Text[80];
    begin
        Clear(Addr);

        if (Hdr."Customer No." = '') then
            exit;

        if not C.Get(Hdr."Customer No.") then
            exit;

        FormatAddress.Customer(Tmp, C);
        for i := 1 to 6 do
            Addr[i] := CopyStr(Tmp[i], 1, MaxStrLen(Addr[i]));

        if Hdr."Ship-to Name" <> '' then begin
            Addr[1] := Hdr."Ship-to Name";
            Addr[2] := Hdr."Ship-to Address";
            Addr[3] := Hdr."Ship-to Address 2";
            Addr[4] := Hdr."Ship-to City";
            Addr[5] := Hdr."Ship-to County";
            Addr[6] := Hdr."Ship-to Post Code";
        end;

        TelTxt := '';
        FaxTxt := '';

        if C."Phone No." <> '' then
            TelTxt := 'TEL: ' + C."Phone No.";
        if C."Fax No." <> '' then
            FaxTxt := 'FAX: ' + C."Fax No.";

        Addr[7] := CopyStr(TelTxt, 1, MaxStrLen(Addr[7]));
        Addr[8] := CopyStr(FaxTxt, 1, MaxStrLen(Addr[8]));
    end;

    local procedure FillPaymentBankFromCompanyInfo()
    begin
        Clear(PaymentBank);
        PaymentBank[1] := CompanyInfo."Bank Name";
        PaymentBank[2] := CompanyInfo."Bank Branch No.";
        PaymentBank[3] := CompanyInfo."Bank Account No.";
    end;

    local procedure AddOrUpdateVatSummary(VatPct: Decimal; VatBase: Decimal)
    var
        CurrBase: Decimal;
    begin
        if VatBase = 0 then
            exit;

        if VatSummaryDict.ContainsKey(VatPct) then begin
            VatSummaryDict.Get(VatPct, CurrBase);
            CurrBase += VatBase;
            VatSummaryDict.Set(VatPct, CurrBase);
        end else begin
            VatSummaryDict.Add(VatPct, VatBase);
            InsertSortedVatPct(VatPct);
        end;
    end;

    local procedure InsertSortedVatPct(VatPct: Decimal)
    var
        i: Integer;
        Curr: Decimal;
    begin
        for i := 1 to VatPctList.Count() do begin
            VatPctList.Get(i, Curr);
            if VatPct < Curr then begin
                VatPctList.Insert(i, VatPct);
                exit;
            end;
            if VatPct = Curr then
                exit;
        end;
        VatPctList.Add(VatPct);
    end;

    local procedure BuildRegistrationLine(): Text[100]
    var
        RegNo: Text[50];
    begin
        RegNo := CompanyInfo."Registration No.";
        if RegNo = '' then
            RegNo := CompanyInfo."VAT Registration No.";

        if RegNo = '' then
            exit('');

        exit('登録番号: ' + RegNo);
    end;

    local procedure GetYesNo(ValueBool: Boolean): Text[3]
    begin
        if ValueBool then
            exit('Yes')
        else
            exit('No');
    end;

    local procedure InsertIntoShipBuffer(var SourceLine: Record "Service Shipment Line"; var BufferLine: Record "Service Shipment Line" temporary; var LineNo: Integer)
    begin
        BufferLine.Init();
        BufferLine.TransferFields(SourceLine);
        BufferLine."Line No." := LineNo;
        BufferLine.Insert();
        LineNo += 10;
    end;
}