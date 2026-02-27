report 50024 "MRJ Service Cr Memo"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Service Credit Memo';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJServiceCreditMemoReport.rdlc';

    dataset
    {
        dataitem(SvcCrMemoHdr; "Service Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Customer No.";

            // =========================
            // Header
            // =========================
            column(DocumentDateTxt; DocumentDateTxt) { }
            column(CompanySeal; CompanyInfo.Picture) { }
            column(CurrencyCode_ServHeader; "Currency Code") { }
            column(SummarizeLines; SummarizeLines) { }

            // ---- Identifiers ----
            column(CustomerNo; "Customer No.") { }
            column(CrMemoNo; "No.") { }

            // ---- Customer (Left header block) ----
            column(CustName; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
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
            column(CompanyAddr0; CompanyInfo."Post Code") { }

            // ---- Registration No. ----
            column(CompanyRegistrationLine; CompanyRegistrationLine) { }
            column(CompanyRegistrationNo; CompanyInfo."VAT Registration No.") { }

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
            // 1) サービス品目情報（互換）
            // =========================
            dataitem(SvcCrMemoItemLine; "Service Cr.Memo Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = SvcCrMemoHdr;
                DataItemTableView = sorting("Document No.", "Line No.");

                column(ServiceItemNo; "Service Item No.") { }
                column(LineType; Type) { }
                column(NoOnLine; "No.") { }
                column(ServiceItemDescription; Description) { }
                column(Warranty; WarrantyTxt) { }

                trigger OnPreDataItem()
                begin
                    SetFilter("Service Item No.", '<>%1', '');
                end;

                trigger OnAfterGetRecord()
                begin
                    WarrantyTxt := GetYesNo(Warranty);
                end;
            }

            // =========================
            // 2) 明細（OFF）
            // =========================
            dataitem(SvcCrMemoLine; "Service Cr.Memo Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = SvcCrMemoHdr;
                DataItemTableView = sorting("Document No.", "Line No.");

                column(LineNo_ServLine; "Line No.") { }
                column(Type_ServLine; Type) { }
                column(Description_ServLine; Description) { }
                column(Quantity_ServLine; Quantity) { }
                column(UnitPrice_ServLine; "Unit Price") { }
                column(Amt; LineAmountCalc) { }
                column(GrossAmt; "Amount Including VAT") { }
                column(LineUOM; "Unit of Measure") { }

                trigger OnPreDataItem()
                begin
                    if SummarizeLines then
                        CurrReport.Break();
                end;

                trigger OnAfterGetRecord()
                begin
                    // Always keep sign from posted line amount if available
                    if "Line Amount" <> 0 then
                        LineAmountCalc := Round("Line Amount", 1)
                    else
                        LineAmountCalc := Round("Unit Price" * Quantity, 1);
                end;
            }

            // =========================
            // 2b) 明細纏め（ON）
            // =========================
            dataitem(SummarizedCrMemoLine; Integer)
            {
                DataItemTableView = sorting(Number);

                column(FlatLineNo; Number) { }
                column(FlatLineType; FlatLineType) { }
                column(FlatLineDescription; FlatLineDescription) { }
                column(FlatLineQuantity; FlatQty) { }
                column(FlatLineUOM; FlatUOM) { }
                column(FlatUnitPrice; FlatPrice) { }
                column(FlatLineAmount; FlatAmount) { }

                // Keep columns (RDLC compatibility)
                column(FlatFaultReasonCode; FlatFaultReasonCode) { }
                column(FlatFaultReasonDisplay; FlatFaultReasonDisplay) { }
                column(FlatLineDiscountAmt; FlatLineDiscountAmt) { }

                trigger OnPreDataItem()
                begin
                    if not SummarizeLines then
                        CurrReport.Break();

                    SummarizeCrMemoLinesProc();

                    if TempCrMemoLine.IsEmpty() then
                        CurrReport.Break();

                    SetRange(Number, 1, TempCrMemoLine.Count());
                    TempCrMemoLine.FindSet();
                end;

                trigger OnAfterGetRecord()
                var
                    FaultReason: Record "Fault Reason Code";
                begin
                    // データの取得
                    if Number = 1 then
                        TempCrMemoLine.FindSet()
                    else
                        TempCrMemoLine.Next();

                    // 1. 変数の初期化（前の行のデータが残らないように確実にリセット）
                    FlatFaultReasonCode := '';
                    FlatLineDiscountAmt := 0;

                    // 2. 基本データの代入
                    FlatLineDescription := TempCrMemoLine.Description;
                    FlatQty := TempCrMemoLine.Quantity;
                    FlatAmount := TempCrMemoLine."Line Amount";
                    FlatPrice := TempCrMemoLine."Unit Price";
                    FlatUOM := TempCrMemoLine."Unit of Measure Code";

                    // 3. --- Type別の表示制御ロジック ---
                    if TempCrMemoLine.Type = TempCrMemoLine.Type::Cost then begin
                        // 【値引き行の場合】
                        FlatLineType := 'DISCOUNT';

                        // 理由コードから名称（Description）を取得。マスタに無ければコードをそのまま表示
                        if FaultReason.Get(TempCrMemoLine."Fault Reason Code") then
                            FlatFaultReasonCode := FaultReason.Description
                        else
                            FlatFaultReasonCode := TempCrMemoLine."Fault Reason Code";

                        FlatLineDiscountAmt := TempCrMemoLine."Line Amount";
                    end else begin
                        // 【通常の名寄せ明細行の場合】
                        case TempCrMemoLine.Type of
                            TempCrMemoLine.Type::Item:
                                FlatLineType := 'ITEM';
                            TempCrMemoLine.Type::Resource:
                                FlatLineType := 'RESOURCE';
                            else
                                FlatLineType := 'OTHER';
                        end;
                        // 通常行なので理由コードと値引き額は必ずクリア
                        FlatFaultReasonCode := '';
                        FlatLineDiscountAmt := 0;
                    end;
                end;
            }

            // =========================
            // コメント
            // =========================
            dataitem(SvcCrMemoComment; "Service Comment Line")
            {
                DataItemLinkReference = SvcCrMemoHdr;
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
                CrLine: Record "Service Cr.Memo Line";
                LineBase: Decimal;
                LineVAT: Decimal;
            begin
                CompanyInfo.CalcFields(Picture);
                DocumentDateTxt := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                Clear(CompanyAddr);
                if ("Responsibility Center" <> '') and RespCenter.Get("Responsibility Center") then
                    FormatAddress.RespCenter(CompanyAddr, RespCenter)
                else
                    FormatAddress.Company(CompanyAddr, CompanyInfo);

                FillPaymentBankFromCompanyInfo();

                Clear(CustAddr);
                FillServiceCrMemoBillTo(CustAddr, SvcCrMemoHdr);

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

                CrLine.Reset();
                CrLine.SetRange("Document No.", "No.");

                if CrLine.FindSet() then
                    repeat
                        // Base uses posted line amount sign as-is
                        if CrLine."Line Amount" <> 0 then
                            LineBase := CrLine."Line Amount"
                        else
                            LineBase := CrLine."Unit Price" * CrLine.Quantity;

                        if LineBase = 0 then
                            continue;

                        TotalExclVAT += LineBase;

                        if CrLine."Amount Including VAT" <> 0 then
                            LineVAT := Round(CrLine."Amount Including VAT" - LineBase, 0.1)
                        else
                            LineVAT := Round(LineBase * CrLine."VAT %" / 100, 0.1);

                        TotalVAT += LineVAT;
                        TotalInclVAT += LineBase + LineVAT;

                        AddOrUpdateVatSummary(CrLine."VAT %", LineBase);
                    until CrLine.Next() = 0;
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
                    Caption = 'オプション';
                    field(SummarizeLinesField; SummarizeLines)
                    {
                        ApplicationArea = All;
                        Caption = '明細纏め';
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

        SummarizeLines: Boolean;

        PaymentBank: array[3] of Text[50];
        CustAddr: array[8] of Text[90];
        CompanyAddr: array[8] of Text[90];

        CompanyRegistrationLine: Text[100];
        DocumentDateTxt: Text[50];

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

        // Summarize buffer
        TempCrMemoLine: Record "Service Cr.Memo Line" temporary;

        // Flat fields
        FlatLineDescription: Text[100];
        FlatQty: Decimal;
        FlatUOM: Code[20];
        FlatPrice: Decimal;
        FlatAmount: Decimal;
        FlatLineType: Text[20];

        // Keep for RDLC
        FlatFaultReasonCode: Text[100];
        FlatFaultReasonDisplay: Text[120];
        FlatLineDiscountAmt: Decimal;

    // ==========================================================
    // Summarize logic (NAV-like for credit memo)
    // - Keep original sign from posted "Line Amount"
    // - Resource: lump-sum Qty = -1, UOM=SET
    // - Discount: ONE row "通常修理（値引）" with positive amount
    // ==========================================================
    local procedure SummarizeCrMemoLinesProc()
    var
        LineRec: Record "Service Cr.Memo Line";
        Res: Record Resource;
        ResGrp: Record "Resource Group";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        TempSortBuffer: Record "Service Cr.Memo Line" temporary;
        NextLineNo: Integer;
        TargetResGrp: Code[20];
        CurrResGrp: Code[20];
        boolFound: Boolean;
        LineAmtToUse: Decimal;
        DiscountTotal: Decimal;
        DiscountLineNo: Integer;
    begin
        TempCrMemoLine.Reset();
        TempCrMemoLine.DeleteAll();

        DiscountTotal := 0;
        ServiceMgtSetup.Get();

        LineRec.Reset();
        LineRec.SetRange("Document No.", SvcCrMemoHdr."No.");

        if LineRec.FindSet() then
            repeat
                // Keep discount total from posted lines (like quote logic)
                // Credit memo: we want discount row as POSITIVE value
                if (LineRec."Line Discount %" > 0) and (LineRec."Line Discount Amount" <> 0) then
                    DiscountTotal += LineRec."Line Discount Amount";

                // Skip truly empty lines
                if (LineRec.Description = '') and (LineRec."No." = '') then
                    continue;

                // Amount to summarize: prefer posted Line Amount (keeps sign)
                if LineRec."Line Amount" <> 0 then
                    LineAmtToUse := LineRec."Line Amount"
                else
                    LineAmtToUse := LineRec."Unit Price" * LineRec.Quantity;

                boolFound := false;
                CurrResGrp := '';
                TargetResGrp := '';

                // --------------------------
                // Resource group summarize
                // --------------------------
                if LineRec.Type = LineRec.Type::Resource then begin
                    if Res.Get(LineRec."No.") then begin
                        CurrResGrp := Res."Resource Group No.";
                        TargetResGrp := CurrResGrp;

                        if (ServiceMgtSetup."Resource Group Filter" <> '') and
                           (StrPos(ServiceMgtSetup."Resource Group Filter", CurrResGrp) > 0) then
                            TargetResGrp := ServiceMgtSetup."Resource Group for Sort";
                    end;

                    if TargetResGrp <> '' then begin
                        TempCrMemoLine.Reset();
                        TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Resource);
                        TempCrMemoLine.SetRange("Resource Group No.", TargetResGrp);

                        if TempCrMemoLine.FindFirst() then begin
                            // Sum amount only
                            TempCrMemoLine."Line Amount" += LineAmtToUse;

                            // Lump-sum qty/uom (NAV sample style)
                            TempCrMemoLine.Quantity := -1;
                            TempCrMemoLine."Unit of Measure" := 'SET';
                            TempCrMemoLine."Unit Price" := 0;

                            TempCrMemoLine.Modify();
                            boolFound := true;
                        end;
                    end;
                end;

                // --------------------------
                // Item summarize (No+UOM+UnitPrice)
                // --------------------------
                if (not boolFound) and (LineRec.Type = LineRec.Type::Item) then begin
                    TempCrMemoLine.Reset();
                    TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Item);
                    TempCrMemoLine.SetRange("No.", LineRec."No.");
                    TempCrMemoLine.SetRange("Unit of Measure", LineRec."Unit of Measure");
                    TempCrMemoLine.SetRange("Unit Price", LineRec."Unit Price");

                    if TempCrMemoLine.FindFirst() then begin
                        TempCrMemoLine.Quantity += LineRec.Quantity;
                        TempCrMemoLine."Line Amount" += LineAmtToUse; // keeps sign
                        TempCrMemoLine.Modify();
                        boolFound := true;
                    end;
                end;

                // --------------------------
                // Other summarize (keep as-is)
                // --------------------------
                if not boolFound then begin
                    TempCrMemoLine.Init();
                    TempCrMemoLine.TransferFields(LineRec);

                    TempCrMemoLine."Line Amount" := LineAmtToUse; // keep sign

                    if LineRec.Type = LineRec.Type::Resource then begin
                        // Lump-sum style for resource even if not grouped
                        TempCrMemoLine.Quantity := -1;
                        TempCrMemoLine."Unit of Measure" := 'SET';
                        TempCrMemoLine."Unit Price" := 0;

                        TempCrMemoLine."Resource Group No." := TargetResGrp;
                        if (TargetResGrp <> '') and ResGrp.Get(TargetResGrp) then
                            TempCrMemoLine.Description := ResGrp.Name;
                    end;

                    TempCrMemoLine.Insert();
                end;

            until LineRec.Next() = 0;

        // --------------------------
        // Add ONE discount row at bottom (NAV sample):
        // Description: 通常修理（値引）
        // Amount: positive
        // --------------------------
        if DiscountTotal <> 0 then begin
            TempCrMemoLine.Reset();
            if TempCrMemoLine.FindLast() then
                DiscountLineNo := TempCrMemoLine."Line No." + 10
            else
                DiscountLineNo := 10000;

            TempCrMemoLine.Init();
            TempCrMemoLine."Document No." := SvcCrMemoHdr."No.";
            TempCrMemoLine."Line No." := DiscountLineNo;
            TempCrMemoLine.Type := TempCrMemoLine.Type::Cost;
            TempCrMemoLine.Description := '通常修理（値引）';

            TempCrMemoLine.Quantity := 0;
            TempCrMemoLine."Unit of Measure" := '';
            TempCrMemoLine."Unit Price" := 0;

            TempCrMemoLine."Line Amount" := Abs(DiscountTotal); // NAV shows positive
            TempCrMemoLine.Insert();
        end;

        // --------------------------
        // Sort: Resource -> Item -> Other -> Cost
        // --------------------------
        TempSortBuffer.Reset();
        TempSortBuffer.DeleteAll();
        NextLineNo := 10000;

        // A) Resource (by Resource Group No.)
        TempCrMemoLine.Reset();
        TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Resource);
        TempCrMemoLine.SetCurrentKey("Resource Group No.");
        if TempCrMemoLine.FindSet() then
            repeat
                InsertIntoCrMemoBuffer(TempCrMemoLine, TempSortBuffer, NextLineNo);
            until TempCrMemoLine.Next() = 0;

        // B) Item
        TempCrMemoLine.Reset();
        TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Item);
        if TempCrMemoLine.FindSet() then
            repeat
                InsertIntoCrMemoBuffer(TempCrMemoLine, TempSortBuffer, NextLineNo);
            until TempCrMemoLine.Next() = 0;

        // C) Others (exclude Resource/Item/Cost)
        TempCrMemoLine.Reset();
        TempCrMemoLine.SetFilter(Type, '<>%1&<>%2&<>%3',
            TempCrMemoLine.Type::Resource,
            TempCrMemoLine.Type::Item,
            TempCrMemoLine.Type::Cost);
        if TempCrMemoLine.FindSet() then
            repeat
                InsertIntoCrMemoBuffer(TempCrMemoLine, TempSortBuffer, NextLineNo);
            until TempCrMemoLine.Next() = 0;

        // D) Cost (discount row)
        TempCrMemoLine.Reset();
        TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Cost);
        if TempCrMemoLine.FindSet() then
            repeat
                InsertIntoCrMemoBuffer(TempCrMemoLine, TempSortBuffer, NextLineNo);
            until TempCrMemoLine.Next() = 0;

        // Write back ordered list
        TempCrMemoLine.Reset();
        TempCrMemoLine.DeleteAll();

        if TempSortBuffer.FindSet() then
            repeat
                TempCrMemoLine.TransferFields(TempSortBuffer);
                TempCrMemoLine.Insert();
            until TempSortBuffer.Next() = 0;
    end;

    // -------------------------
    // Bill-to address + TEL/FAX
    // -------------------------
    local procedure FillServiceCrMemoBillTo(var Addr: array[8] of Text[90]; Hdr: Record "Service Cr.Memo Header")
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

        if Hdr."Bill-to Name" <> '' then begin
            Addr[1] := Hdr."Bill-to Name";
            Addr[2] := Hdr."Bill-to Address";
            Addr[3] := Hdr."Bill-to Address 2";
            Addr[4] := Hdr."Bill-to City";
            Addr[5] := Hdr."Bill-to County";
            Addr[6] := Hdr."Bill-to Post Code";
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

        exit('登録番号：' + RegNo);
    end;

    local procedure GetYesNo(ValueBool: Boolean): Text[3]
    begin
        if ValueBool then
            exit('Yes')
        else
            exit('No');
    end;

    local procedure InsertIntoCrMemoBuffer(var SourceLine: Record "Service Cr.Memo Line"; var BufferLine: Record "Service Cr.Memo Line" temporary; var LineNo: Integer)
    begin
        BufferLine.Init();
        BufferLine.TransferFields(SourceLine);
        BufferLine."Line No." := LineNo;
        BufferLine.Insert();
        LineNo += 10;
    end;
}