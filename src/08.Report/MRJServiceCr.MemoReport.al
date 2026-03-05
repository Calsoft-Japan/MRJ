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
            column(HasVat8Pct; HasVat8Pct) { }

            column(CustomerNo; "Customer No.") { }
            column(CrMemoNo; "No.") { }

            column(CustName; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CustAddr7; CustAddr[7]) { }
            column(CustAddr8; CustAddr[8]) { }
            column(CustAddrP; "Bill-to Contact") { }

            column(CompanyName; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { } // TEL
            column(CompanyAddr8; CompanyAddr[8]) { } // FAX
            column(CompanyAddr0; CompanyInfo."Post Code") { }

            column(CompanyRegistrationLine; CompanyRegistrationLine) { }
            column(CompanyRegistrationNo; CompanyInfo."VAT Registration No.") { }

            column(PaymentBank1; PaymentBank[1]) { }
            column(PaymentBank2; PaymentBank[2]) { }
            column(PaymentBank3; PaymentBank[3]) { }

            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }

            column(PaymentTermText; PaymentTermText) { }
            column(PaymentMethodText; PaymentMethodText) { }

            // =========================
            // 2) Detail (OFF)
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
                column(Amt; "Line Amount") { }
                column(GrossAmt; "Amount Including VAT") { }
                column(LineUOM; "Unit of Measure") { }

                trigger OnPreDataItem()
                begin
                    if SummarizeLines then
                        CurrReport.Break();
                end;
            }

            // =========================
            // 2b) Summarized (ON)
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

                // keep (RDLC compatibility)
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
                begin
                    if Number = 1 then
                        TempCrMemoLine.FindSet()
                    else
                        TempCrMemoLine.Next();

                    // reset
                    FlatLineType := '';
                    FlatLineDescription := '';
                    FlatQty := 0;
                    FlatUOM := '';
                    FlatPrice := 0;
                    FlatAmount := 0;
                    FlatFaultReasonCode := '';
                    FlatFaultReasonDisplay := '';
                    FlatLineDiscountAmt := 0;

                    // assign base
                    FlatLineDescription := TempCrMemoLine.Description;
                    FlatQty := TempCrMemoLine.Quantity;
                    FlatUOM := TempCrMemoLine."Unit of Measure";
                    FlatPrice := TempCrMemoLine."Unit Price";
                    FlatAmount := TempCrMemoLine."Line Amount";

                    if TempCrMemoLine.Type = TempCrMemoLine.Type::Cost then begin
                        // Discount rows: show text from Description (NAV style)
                        FlatLineType := 'DISCOUNT';
                        FlatFaultReasonCode := TempCrMemoLine.Description;
                        FlatFaultReasonDisplay := TempCrMemoLine.Description;
                        FlatLineDiscountAmt := TempCrMemoLine."Line Amount";
                    end else begin
                        case TempCrMemoLine.Type of
                            TempCrMemoLine.Type::Item:
                                FlatLineType := 'ITEM';
                            TempCrMemoLine.Type::Resource:
                                FlatLineType := 'RESOURCE';
                            else
                                FlatLineType := 'OTHER';
                        end;
                    end;
                end;
            }

            // =========================
            // Comment
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

                    UpdateHeaderInfo();
                    if SummarizeLines then
                        SummarizeCrMemoLinesProc();
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
                if not CompanyInfo.Get() then
                    CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);

                DocumentDateTxt := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                // Address: Resp. Center -> fallback Company
                Clear(CompanyAddr);
                if ("Responsibility Center" <> '') and RespCenter.Get("Responsibility Center") then
                    FormatAddress.RespCenter(CompanyAddr, RespCenter)
                else
                    FormatAddress.Company(CompanyAddr, CompanyInfo);

                // TEL/FAX: Resp. Center -> fallback Company, comma separated
                FillCompanyTelFax(CompanyAddr, "Responsibility Center");

                FillPaymentBankFromCompanyInfo();

                Clear(CustAddr);
                FillServiceCrMemoBillTo(CustAddr, SvcCrMemoHdr);

                CompanyRegistrationLine := BuildRegistrationLine();

                PaymentTermText := '';
                if "Payment Terms Code" <> '' then
                    if PaymentTerms.Get("Payment Terms Code") then
                        PaymentTermText := PaymentTerms.Description;

                PaymentMethodText := '';
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
                        LineBase := CrLine."Line Amount";
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

                HasVat8Pct := VatSummaryDict.ContainsKey(8);
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

        PaymentTermText: Text[250];
        PaymentMethodText: Text[250];
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";

        // Summarize buffer
        TempCrMemoLine: Record "Service Cr.Memo Line" temporary;

        // Flat fields
        FlatLineDescription: Text[100];
        FlatQty: Decimal;
        FlatUOM: Text[50];
        FlatPrice: Decimal;
        FlatAmount: Decimal;
        FlatLineType: Text[20];
        HasVat8Pct: Boolean;

        // keep for RDLC
        FlatFaultReasonCode: Text[100];
        FlatFaultReasonDisplay: Text[120];
        FlatLineDiscountAmt: Decimal;

        Text50020: Label '%1（値引）', Comment = '%1 = Fault Reason Description';

    // ==========================================================
    // Summarize (toggle ON) - NAV style output
    local procedure SummarizeCrMemoLinesProc()
    var
        LineRec: Record "Service Cr.Memo Line";
        Res: Record Resource;
        ResGrp: Record "Resource Group";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        TempSortBuffer: Record "Service Cr.Memo Line" temporary;

        NextLineNo: Integer;
        CurrResGrp: Code[20];
        TargetResGrp: Code[20];

        FaultReasonCodeMst: Record "Fault Reason Code";
        FaultReasonName: Text[50];

        LineBaseAmount: Decimal;
        DiscAmt: Decimal;
        TotalDiscountAmt: Decimal;
        TempLineNo: Integer;
        boolFound: Boolean;

        TotalDiscountCode: Code[20];
    begin
        TempCrMemoLine.Reset();
        TempCrMemoLine.DeleteAll();

        TempLineNo := -1;
        TotalDiscountAmt := 0;
        TotalDiscountCode := 'ZZZZ_TOTAL';

        ServiceMgtSetup.Get();

        LineRec.Reset();
        LineRec.SetRange("Document No.", SvcCrMemoHdr."No.");

        if LineRec.FindSet() then
            repeat
                // ignore existing Cost lines from source (we generate NAV-style rows ourselves)
                if LineRec.Type = LineRec.Type::Cost then
                    continue;

                // ===== Normal line base amount: Quantity * Unit Price (Quotation-style) =====
                LineBaseAmount := Round(LineRec.Quantity * LineRec."Unit Price", 0.00001);

                // fallback if Unit Price is not reliable
                if (LineBaseAmount = 0) and ((LineRec."Line Amount" <> 0) or (LineRec."Line Discount Amount" <> 0)) then
                    LineBaseAmount := LineRec."Line Amount" + LineRec."Line Discount Amount";

                // skip empty
                if (DelChr(LineRec.Description) = '') and (DelChr(LineRec."No.") = '') and (LineBaseAmount = 0) then
                    continue;

                boolFound := false;
                CurrResGrp := '';
                TargetResGrp := '';

                // ---- Resource group summarize (by Resource Group No.) ----
                if LineRec.Type = LineRec.Type::Resource then begin
                    if Res.Get(LineRec."No.") then begin
                        CurrResGrp := Res."Resource Group No.";
                        TargetResGrp := CurrResGrp;

                        if (ServiceMgtSetup."Resource Group Filter" <> '') and
                           IsResGrpInFilter(CurrResGrp, ServiceMgtSetup."Resource Group Filter") and
                           (ServiceMgtSetup."Resource Group for Sort" <> '') then
                            TargetResGrp := ServiceMgtSetup."Resource Group for Sort";
                    end;

                    if TargetResGrp <> '' then begin
                        TempCrMemoLine.Reset();
                        TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Resource);
                        TempCrMemoLine.SetRange("Resource Group No.", TargetResGrp);

                        if TempCrMemoLine.FindFirst() then begin
                            TempCrMemoLine."Line Amount" += LineBaseAmount;
                            TempCrMemoLine.Quantity += LineRec.Quantity;
                            TempCrMemoLine.Modify();
                            boolFound := true;
                        end;
                    end;
                end;

                if not boolFound then begin
                    TempCrMemoLine.Init();
                    TempCrMemoLine.TransferFields(LineRec);

                    TempCrMemoLine."Fault Reason Code" := ''; // normal line: clear
                    TempCrMemoLine."Line Amount" := LineBaseAmount;

                    TempCrMemoLine."Resource Group No." := TargetResGrp;
                    if (LineRec.Type = LineRec.Type::Resource) and (TargetResGrp <> '') then
                        if ResGrp.Get(TargetResGrp) then
                            TempCrMemoLine.Description := ResGrp.Name;

                    TempCrMemoLine.Insert();
                end;

                // ===== Discount category line (Fault Reason) =====
                DiscAmt := Abs(LineRec."Line Discount Amount");
                if DiscAmt <> 0 then begin
                    TotalDiscountAmt += DiscAmt;

                    FaultReasonName := '';
                    if (LineRec."Fault Reason Code" <> '') and FaultReasonCodeMst.Get(LineRec."Fault Reason Code") then
                        FaultReasonName := FaultReasonCodeMst.Description;

                    TempCrMemoLine.Reset();
                    TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Cost);
                    TempCrMemoLine.SetRange("Fault Reason Code", LineRec."Fault Reason Code");
                    TempCrMemoLine.SetFilter("Fault Reason Code", '<>%1', TotalDiscountCode);

                    if TempCrMemoLine.FindFirst() then begin
                        TempCrMemoLine."Line Amount" += DiscAmt; // positive
                        TempCrMemoLine.Modify();
                    end else begin
                        TempCrMemoLine.Init();
                        TempCrMemoLine."Document No." := SvcCrMemoHdr."No.";
                        TempCrMemoLine."Line No." := TempLineNo;
                        TempLineNo -= 1;

                        TempCrMemoLine.Type := TempCrMemoLine.Type::Cost;
                        TempCrMemoLine."Fault Reason Code" := LineRec."Fault Reason Code";

                        if FaultReasonName <> '' then
                            TempCrMemoLine.Description := StrSubstNo(Text50020, FaultReasonName)
                        else
                            TempCrMemoLine.Description := '値引';

                        TempCrMemoLine.Quantity := 0; // NAV shows blank
                        TempCrMemoLine."Unit of Measure" := '';
                        TempCrMemoLine."Unit Price" := 0;
                        TempCrMemoLine."Line Amount" := DiscAmt; // positive
                        TempCrMemoLine.Insert();
                    end;
                end;

            until LineRec.Next() = 0;

        // ===== Total discount line (NAV: 合計値引 / Qty -1 / UOM Set) =====
        if TotalDiscountAmt <> 0 then begin
            TempCrMemoLine.Init();
            TempCrMemoLine."Document No." := SvcCrMemoHdr."No.";
            TempCrMemoLine."Line No." := TempLineNo;
            TempLineNo -= 1;

            TempCrMemoLine.Type := TempCrMemoLine.Type::Cost;
            TempCrMemoLine."Fault Reason Code" := TotalDiscountCode;
            TempCrMemoLine.Description := GetDiscountResGrpName(); // Resource Group 'DISCOUNT'.Name (合計値引)

            TempCrMemoLine.Quantity := -1;
            TempCrMemoLine."Unit of Measure" := 'Set';
            TempCrMemoLine."Unit Price" := 0;
            TempCrMemoLine."Line Amount" := Abs(TotalDiscountAmt); // positive
            TempCrMemoLine.Insert();
        end;

        // ---- Sort: Resource -> Item -> Other -> Cost ----
        TempSortBuffer.Reset();
        TempSortBuffer.DeleteAll();
        NextLineNo := 10000;

        TempCrMemoLine.Reset();
        TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Resource);
        TempCrMemoLine.SetCurrentKey("Resource Group No.");
        if TempCrMemoLine.FindSet() then
            repeat
                InsertIntoCrMemoBuffer(TempCrMemoLine, TempSortBuffer, NextLineNo);
            until TempCrMemoLine.Next() = 0;

        TempCrMemoLine.Reset();
        TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Item);
        if TempCrMemoLine.FindSet() then
            repeat
                InsertIntoCrMemoBuffer(TempCrMemoLine, TempSortBuffer, NextLineNo);
            until TempCrMemoLine.Next() = 0;

        TempCrMemoLine.Reset();
        TempCrMemoLine.SetFilter(Type, '<>%1&<>%2&<>%3',
            TempCrMemoLine.Type::Resource,
            TempCrMemoLine.Type::Item,
            TempCrMemoLine.Type::Cost);
        if TempCrMemoLine.FindSet() then
            repeat
                InsertIntoCrMemoBuffer(TempCrMemoLine, TempSortBuffer, NextLineNo);
            until TempCrMemoLine.Next() = 0;

        TempCrMemoLine.Reset();
        TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Cost);
        TempCrMemoLine.SetCurrentKey("Fault Reason Code");
        if TempCrMemoLine.FindSet() then
            repeat
                InsertIntoCrMemoBuffer(TempCrMemoLine, TempSortBuffer, NextLineNo);
            until TempCrMemoLine.Next() = 0;

        // write back
        TempCrMemoLine.Reset();
        TempCrMemoLine.DeleteAll();
        if TempSortBuffer.FindSet() then
            repeat
                TempCrMemoLine.TransferFields(TempSortBuffer);
                TempCrMemoLine.Insert();
            until TempSortBuffer.Next() = 0;
    end;

    // ==========================================================
    // Company TEL/FAX (Resp Center -> fallback Company), comma separated
    local procedure FillCompanyTelFax(var Addr: array[8] of Text[90]; RespCenterCode: Code[10])
    var
        RespCenter: Record "Responsibility Center";
        Tel1: Text;
        Tel2: Text;
        Fax1: Text;
        Fax2: Text;
        TelLine: Text[120];
        FaxLine: Text[120];
    begin
        // Tel1 := CompanyInfo."Phone No.";
        // Tel2 := CompanyInfo."Phone No. 2";
        // Fax1 := CompanyInfo."Fax No.";
        // Fax2 := CompanyInfo."Fax No. 2";

        if (RespCenterCode <> '') and RespCenter.Get(RespCenterCode) then begin
            Tel1 := RespCenter."Phone No.";
            Tel2 := RespCenter."Phone No. 2";
            Fax1 := RespCenter."Fax No.";
            Fax2 := RespCenter."Fax No. 2";
        end;

        TelLine := JoinWithComma(Tel1, Tel2);
        FaxLine := JoinWithComma(Fax1, Fax2);

        if TelLine <> '' then
            Addr[7] := CopyStr('TEL: ' + TelLine, 1, MaxStrLen(Addr[7]))
        else
            Addr[7] := '';

        if FaxLine <> '' then
            Addr[8] := CopyStr('FAX: ' + FaxLine, 1, MaxStrLen(Addr[8]))
        else
            Addr[8] := '';
    end;

    local procedure JoinWithComma(Part1: Text; Part2: Text): Text
    begin
        Part1 := DelChr(Part1, '<>', ' ');
        Part2 := DelChr(Part2, '<>', ' ');

        if (Part1 <> '') and (Part2 <> '') then
            exit(Part1 + ', ' + Part2);

        if Part1 <> '' then
            exit(Part1);

        exit(Part2);
    end;

    local procedure IsResGrpInFilter(ResGrpNo: Code[20]; FilterTxt: Text): Boolean
    var
        RG: Record "Resource Group";
    begin
        if (ResGrpNo = '') or (FilterTxt = '') then
            exit(false);

        RG.Reset();
        RG.SetFilter("No.", FilterTxt);
        RG.SetRange("No.", ResGrpNo);
        exit(RG.FindFirst());
    end;

    local procedure GetDiscountResGrpName(): Text[100]
    var
        RG: Record "Resource Group";
    begin
        if RG.Get('DISCOUNT') then
            exit(CopyStr(RG.Name, 1, 100));

        exit('合計値引'); // fallback only if master missing
    end;

    // -------------------------
    // Bill-to address + TEL/FAX (Customer)
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

    local procedure InsertIntoCrMemoBuffer(var SourceLine: Record "Service Cr.Memo Line"; var BufferLine: Record "Service Cr.Memo Line" temporary; var LineNo: Integer)
    begin
        BufferLine.Init();
        BufferLine.TransferFields(SourceLine);
        BufferLine."Line No." := LineNo;
        BufferLine.Insert();
        LineNo += 10;
    end;

    // Posted totals helper (fix: use Service Cr.Memo Line)
    local procedure UpdateHeaderInfo()
    var
        CrLine: Record "Service Cr.Memo Line";
        PaymentTermsLoc: Record "Payment Terms";
        PaymentMethodLoc: Record "Payment Method";
        RespCenter: Record "Responsibility Center";
    begin
        if not CompanyInfo.Get() then
            CompanyInfo.Get();
        if CompanyInfo.Picture.HasValue then
            CompanyInfo.CalcFields(Picture);

        DocumentDateTxt := Format(SvcCrMemoHdr."Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

        PaymentTermText := '';
        if (SvcCrMemoHdr."Payment Terms Code" <> '') and PaymentTermsLoc.Get(SvcCrMemoHdr."Payment Terms Code") then
            PaymentTermText := PaymentTermsLoc.Description;

        PaymentMethodText := '';
        if (SvcCrMemoHdr."Payment Method Code" <> '') and PaymentMethodLoc.Get(SvcCrMemoHdr."Payment Method Code") then
            PaymentMethodText := PaymentMethodLoc.Description;

        FillServiceCrMemoBillTo(CustAddr, SvcCrMemoHdr);

        Clear(CompanyAddr);
        if (SvcCrMemoHdr."Responsibility Center" <> '') and RespCenter.Get(SvcCrMemoHdr."Responsibility Center") then
            FormatAddress.RespCenter(CompanyAddr, RespCenter)
        else
            FormatAddress.Company(CompanyAddr, CompanyInfo);

        FillCompanyTelFax(CompanyAddr, SvcCrMemoHdr."Responsibility Center");

        TotalExclVAT := 0;
        TotalInclVAT := 0;

        CrLine.Reset();
        CrLine.SetRange("Document No.", SvcCrMemoHdr."No.");
        if CrLine.FindSet() then
            repeat
                TotalExclVAT += CrLine."Line Amount";
                TotalInclVAT += CrLine."Amount Including VAT";
            until CrLine.Next() = 0;

        TotalVAT := TotalInclVAT - TotalExclVAT;
    end;
}