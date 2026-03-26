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

            // Header
            column(DocumentDateTxt; DocumentDateTxt) { }
            column(CompanySeal; CompanyInfo.Picture) { }
            column(CurrencyCode_ServHeader; "Currency Code") { }
            column(SummarizeLines; SummarizeLines) { }
            column(HasVat8Pct; HasVat8Pct) { }

            column(CustomerNo; "Customer No.") { }
            column(CrMemoNo; "No.") { }

            column(CustName; CustNameTxt) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CustAddr7; CustAddr[7]) { }
            column(CustAddr8; CustAddr[8]) { }
            column(CustAddrP; BillToContactTxt) { }

            column(CompanyName; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyInfo.Address) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyInfo."Phone No.") { }
            column(CompanyAddr8; CompanyInfo."Fax No.") { }
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

                // RDLC compatibility
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
                    if Number = 1 then
                        TempCrMemoLine.FindSet()
                    else
                        TempCrMemoLine.Next();

                    FlatLineType := '';
                    FlatLineDescription := '';
                    FlatQty := 0;
                    FlatUOM := '';
                    FlatPrice := 0;
                    FlatAmount := 0;
                    FlatFaultReasonCode := '';
                    FlatFaultReasonDisplay := '';
                    FlatLineDiscountAmt := 0;

                    FlatLineDescription := TempCrMemoLine.Description;
                    FlatQty := TempCrMemoLine.Quantity;
                    FlatUOM := TempCrMemoLine."Unit of Measure";
                    FlatPrice := TempCrMemoLine."Unit Price";
                    FlatAmount := TempCrMemoLine."Line Amount";

                    if TempCrMemoLine.Type = TempCrMemoLine.Type::Cost then begin
                        FlatLineType := 'DISCOUNT';

                        if FaultReason.Get(TempCrMemoLine."Fault Reason Code") then
                            FlatFaultReasonCode := FaultReason.Description
                        else
                            FlatFaultReasonCode := TempCrMemoLine."Fault Reason Code";

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
                CrLine: Record "Service Cr.Memo Line";
                LineBase: Decimal;
                LineVAT: Decimal;
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);

                DocumentDateTxt := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                Clear(CompanyAddr);
                FormatAddress.Company(CompanyAddr, CompanyInfo);

                FillPaymentBankFromCompanyInfo();
                FillServiceCrMemoBillTo(CustAddr, SvcCrMemoHdr);

                CustNameTxt := CustAddr[1];
                BillToContactTxt := "Bill-to Contact";

                if CustomerRec.Get("Customer No.") then begin
                    if CustomerRec."NameTitle" <> '' then
                        CustNameTxt := CustNameTxt + '  ' + CustomerRec."NameTitle";

                    if (BillToContactTxt <> '') and (CustomerRec."ContactTitle" <> '') then
                        BillToContactTxt := BillToContactTxt + '  ' + CustomerRec."ContactTitle";
                end;

                CompanyRegistrationLine := BuildRegistrationLine();

                Clear(PaymentTermText);
                if ("Payment Terms Code" <> '') and PaymentTerms.Get("Payment Terms Code") then
                    PaymentTermText := PaymentTerms.Description;

                Clear(PaymentMethodText);
                if ("Payment Method Code" <> '') and PaymentMethod.Get("Payment Method Code") then
                    PaymentMethodText := PaymentMethod.Description;

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
        CompanyInfo.Get();
    end;

    var
        CustomerRec: Record Customer;
        CustNameTxt: Text[100];
        BillToContactTxt: Text[100];
        CompanyInfo: Record "Company Information";
        FormatAddress: Codeunit "Format Address";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";

        SummarizeLines: Boolean;
        HasVat8Pct: Boolean;

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

        TempCrMemoLine: Record "Service Cr.Memo Line" temporary;

        FlatLineDescription: Text[100];
        FlatQty: Decimal;
        FlatUOM: Text[50];
        FlatPrice: Decimal;
        FlatAmount: Decimal;
        FlatLineType: Text[20];

        // RDLC compatibility
        FlatFaultReasonCode: Text[100];
        FlatFaultReasonDisplay: Text[120];
        FlatLineDiscountAmt: Decimal;

        Text50020: Label '%1（値引）', Comment = '%1 = Fault Reason Description';

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
        LineBaseAmount: Decimal;
        FaultReasonName: Text[50];
        TempLineNo: Integer;
        Found: Boolean;
        DiscountResLine: Record "Service Cr.Memo Line" temporary;
        HasDiscountResLine: Boolean;
    begin
        TempCrMemoLine.Reset();
        TempCrMemoLine.DeleteAll();
        TempLineNo := -1;

        DiscountResLine.Reset();
        DiscountResLine.DeleteAll();
        HasDiscountResLine := false;

        ServiceMgtSetup.Get();

        LineRec.Reset();
        LineRec.SetRange("Document No.", SvcCrMemoHdr."No.");

        if LineRec.FindSet() then
            repeat
                if (LineRec.Type = LineRec.Type::Resource) and Res.Get(LineRec."No.") then
                    if Res."Resource Group No." = 'DISCOUNT' then begin
                        DiscountResLine.Init();
                        DiscountResLine.TransferFields(LineRec);

                        if ResGrp.Get('DISCOUNT') then
                            DiscountResLine.Description := ResGrp.Name;

                        DiscountResLine.Insert();
                        HasDiscountResLine := true;
                        continue;
                    end;

                LineBaseAmount := LineRec."Line Amount" + Abs(LineRec."Line Discount Amount");
                Found := false;

                CurrResGrp := '';
                TargetResGrp := '';

                if LineRec.Type = LineRec.Type::Resource then begin
                    if Res.Get(LineRec."No.") then begin
                        CurrResGrp := Res."Resource Group No.";
                        TargetResGrp := CurrResGrp;

                        if (ServiceMgtSetup."Resource Group Filter" <> '') and
                           (StrPos(ServiceMgtSetup."Resource Group Filter", CurrResGrp) > 0) then
                            TargetResGrp := ServiceMgtSetup."Resource Group for Sort";
                    end;
                end;

                if (LineRec.Type = LineRec.Type::Resource) and (TargetResGrp <> '') then begin
                    TempCrMemoLine.Reset();
                    TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Resource);
                    TempCrMemoLine.SetRange("Resource Group No.", TargetResGrp);

                    if TempCrMemoLine.FindFirst() then begin
                        TempCrMemoLine.Quantity += LineRec.Quantity;
                        TempCrMemoLine."Line Amount" += LineBaseAmount;
                        TempCrMemoLine.Modify();
                        Found := true;
                    end;
                end;

                if not Found then begin
                    TempCrMemoLine.Reset();
                    TempCrMemoLine.Init();
                    TempCrMemoLine.TransferFields(LineRec);

                    TempCrMemoLine."Fault Reason Code" := '';
                    TempCrMemoLine.Quantity := LineRec.Quantity;
                    TempCrMemoLine."Line Amount" := LineBaseAmount;
                    TempCrMemoLine."Resource Group No." := TargetResGrp;

                    if (LineRec.Type = LineRec.Type::Resource) and (TargetResGrp <> '') then
                        if ResGrp.Get(TargetResGrp) then
                            TempCrMemoLine.Description := ResGrp.Name;

                    TempCrMemoLine.Insert();
                end;

                if LineRec."Line Discount %" > 0 then begin
                    FaultReasonName := '';
                    if FaultReasonCodeMst.Get(LineRec."Fault Reason Code") then
                        FaultReasonName := FaultReasonCodeMst.Description;

                    TempCrMemoLine.Reset();
                    TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Cost);
                    TempCrMemoLine.SetRange("Fault Reason Code", LineRec."Fault Reason Code");

                    if TempCrMemoLine.FindFirst() then begin
                        TempCrMemoLine."Line Amount" -= LineRec."Line Discount Amount";
                        TempCrMemoLine.Modify();
                    end else begin
                        TempCrMemoLine.Reset();
                        TempCrMemoLine.Init();
                        TempCrMemoLine."Document No." := LineRec."Document No.";
                        TempCrMemoLine."Line No." := TempLineNo;
                        TempLineNo -= 1;

                        TempCrMemoLine.Type := TempCrMemoLine.Type::Cost;
                        TempCrMemoLine."Fault Reason Code" := LineRec."Fault Reason Code";

                        if FaultReasonName <> '' then
                            TempCrMemoLine.Description := StrSubstNo(Text50020, FaultReasonName)
                        else
                            TempCrMemoLine.Description := '値引';

                        TempCrMemoLine."Line Amount" := -LineRec."Line Discount Amount";
                        TempCrMemoLine.Quantity := 1;
                        TempCrMemoLine.Insert();
                    end;
                end;
            until LineRec.Next() = 0;

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
        TempCrMemoLine.SetRange(Type, TempCrMemoLine.Type::Cost);
        TempCrMemoLine.SetCurrentKey("Fault Reason Code");
        if TempCrMemoLine.FindSet() then
            repeat
                InsertIntoCrMemoBuffer(TempCrMemoLine, TempSortBuffer, NextLineNo);
            until TempCrMemoLine.Next() = 0;

        if HasDiscountResLine then
            if DiscountResLine.FindFirst() then begin
                DiscountResLine."Line Amount" := Abs(DiscountResLine."Line Amount");
                InsertIntoCrMemoBuffer(DiscountResLine, TempSortBuffer, NextLineNo);
            end;

        TempCrMemoLine.Reset();
        TempCrMemoLine.DeleteAll();

        if TempSortBuffer.FindSet() then
            repeat
                TempCrMemoLine.TransferFields(TempSortBuffer);
                TempCrMemoLine.Insert();
            until TempSortBuffer.Next() = 0;
    end;

    local procedure FillServiceCrMemoBillTo(var Addr: array[8] of Text[90]; Hdr: Record "Service Cr.Memo Header")
    var
        Customer: Record Customer;
        Tmp: array[8] of Text[100];
        i: Integer;
        TelTxt: Text[80];
        FaxTxt: Text[80];
    begin
        Clear(Addr);

        if (Hdr."Customer No." = '') or (not Customer.Get(Hdr."Customer No.")) then
            exit;

        FormatAddress.Customer(Tmp, Customer);
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

        if Customer."Phone No." <> '' then
            TelTxt := 'TEL: ' + Customer."Phone No.";
        if Customer."Fax No." <> '' then
            FaxTxt := 'FAX: ' + Customer."Fax No.";

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

    local procedure UpdateHeaderInfo()
    var
        CrLine: Record "Service Cr.Memo Line";
        PaymentTermsLoc: Record "Payment Terms";
        PaymentMethodLoc: Record "Payment Method";
    begin
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
        FormatAddress.Company(CompanyAddr, CompanyInfo);

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