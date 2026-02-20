report 50089 "MRJ Service Delivery Note"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Service Delivery Note';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJServiceDeliveryNoteReport.rdlc';

    dataset
    {
        dataitem(SvcShipHdr; "Service Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Customer No.";

            // =========================
            // Header
            // =========================
            column(PostingDateTxt; PostingDateTxt) { }   // 日付
            column(ShowSeal; ShowSeal) { }
            column(CompanySeal; CompanyInfo.Picture) { }
            column(CurrencyCode_ServHeader; "Currency Code") { }
            column(TitleTxt; TitleTxt) { }
            column(ShowOrderInfo; ShowOrderInfo) { }
            column(SummarizeLines; SummarizeLines) { }

            // ---- Identifiers ----
            column(CustomerNo; "Customer No.") { }    // 請求先コード
            column(ShipNo; "No.") { }                    // 納品書番号
            column(OrderNo; "Order No.") { }             // 受注番号 
            column(DocumentDateTxt; DocumentDateTxt) { }   // 伝票日付

            // ---- Customer (Left header block) ----
            column(CustName; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CustAddr7; CustAddr[7]) { } // TEL
            column(CustAddr8; CustAddr[8]) { } // FAX
            column(CompanyAddr0; CompanyInfo."Post Code") { }

            // ---- Company (Right header block) ----
            column(CompanyName; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }

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

            //Payment terms, Payment method
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

                // Warranty shown as Yes/No in RDLC
                column(Warranty; WarrantyTxt) { }

                trigger OnAfterGetRecord()
                begin
                    // If "Warranty" exists (your build didn't complain), this works.
                    WarrantyTxt := GetYesNo(Warranty);
                end;
            }

            // =========================
            // 2) サービスライン
            // =========================
            dataitem(SvcShipLine; "Service Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = SvcShipHdr;
                DataItemTableView = sorting("Document No.", "Line No.");
                column(LineNo_ServLine; "Line No.") { }
                column(Type_ServLine; Type) { } // ★追加
                column(Description_ServLine; Description) { }
                column(Quantity_ServLine; Quantity) { }
                column(UnitPrice_ServLine; "Unit Price") { }
                column(Amt; LineAmount) { }
                column(GrossAmt; "Amount Including VAT") { }
                column(LineUOM; "Unit of Measure") { }
                column(SerItemSlNo_ServLineCaption; FieldCaption("Service Item Line No.")) { }
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
                        LineAmount := Round("Unit Price" * Quantity, 1)
                    else
                        LineAmount := Round("Unit Price", 1);  // for lump-sum / discount style lines
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
            // VAT Summary (same approach as you had)
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
                    TitleTxt := 'サービス見積書 兼 注文書'
                else
                    TitleTxt := 'サービス見積書';

                CompanyInfo.CalcFields(Picture);

                // Date (use Posting Date only; your header has no "Shipment Date")
                PostingDateTxt := Format("Posting Date", 0, '<Year4>年<Month,2>月<Day,2>日');
                DocumentDateTxt := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

                // Company address
                Clear(CompanyAddr);
                if ("Responsibility Center" <> '') and RespCenter.Get("Responsibility Center") then
                    FormatAddress.RespCenter(CompanyAddr, RespCenter)
                else
                    FormatAddress.Company(CompanyAddr, CompanyInfo);

                // Bank from company
                FillPaymentBankFromCompanyInfo();

                // Customer ship-to + TEL/FAX
                Clear(CustAddr);
                FillServiceShipTo(CustAddr, SvcShipHdr);

                // Registration line
                CompanyRegistrationLine := BuildRegistrationLine();

                // Payment Terms
                Clear(PaymentTermText);
                if "Payment Terms Code" <> '' then
                    if PaymentTerms.Get("Payment Terms Code") then
                        PaymentTermText := PaymentTerms.Description;

                // Payment Method
                Clear(PaymentMethodText);
                if "Payment Method Code" <> '' then
                    if PaymentMethod.Get("Payment Method Code") then
                        PaymentMethodText := PaymentMethod.Description;

                // Totals + VAT summary from posted shipment lines
                TotalExclVAT := 0;
                TotalVAT := 0;
                TotalInclVAT := 0;
                Clear(VatSummaryDict);
                Clear(VatPctList);

                ShipLineTmp.Reset();
                ShipLineTmp.SetRange("Document No.", "No.");

                if ShipLineTmp.FindSet() then
                    repeat
                        // "Line Amount" doesn't exist -> compute
                        LineBase := ShipLineTmp."Unit Price" * ShipLineTmp.Quantity;
                        if LineBase = 0 then
                            continue;

                        TotalExclVAT += LineBase;

                        // VAT % should exist on the posted shipment line in your environment (no compile error)
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
                    Caption = 'オプション';
                    field(ShowOrderInfoField; ShowOrderInfo)
                    {
                        ApplicationArea = All;
                        Caption = '注文書表示';
                    }
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

        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;

        VatSummaryDict: Dictionary of [Decimal, Decimal];
        VatPctList: List of [Decimal];

        VATDisplayTxt: Text[20];
        VATBaseAmount: Decimal;
        VATAmount: Decimal;

        WarrantyTxt: Text[3];
        LineAmount: Decimal;
        PaymentTermText: Text[250];
        PaymentMethodText: Text[250];
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";

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

        // Base customer formatting
        FormatAddress.Customer(Tmp, C);
        for i := 1 to 6 do
            Addr[i] := CopyStr(Tmp[i], 1, MaxStrLen(Addr[i]));

        // Override with Ship-to on header when present
        if Hdr."Ship-to Name" <> '' then begin
            Addr[1] := Hdr."Ship-to Name";
            Addr[2] := Hdr."Ship-to Address";
            Addr[3] := Hdr."Ship-to Address 2";
            // Keep simple: City/County/Post Code (adjust if you use JP formatting differently)
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

    // -------------------------
    // Bank (Company Info only)
    // -------------------------
    local procedure FillPaymentBankFromCompanyInfo()
    begin
        Clear(PaymentBank);
        PaymentBank[1] := CompanyInfo."Bank Name";
        PaymentBank[2] := CompanyInfo."Bank Branch No.";
        PaymentBank[3] := CompanyInfo."Bank Account No.";
    end;

    // -------------------------
    // VAT summary helpers
    // -------------------------
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
}