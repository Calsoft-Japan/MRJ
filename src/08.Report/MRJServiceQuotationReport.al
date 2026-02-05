report 50021 "MRJ Service Quotation"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Service Quotation (JP)';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJServiceQuotationReport.rdlc';

    dataset
    {
        dataitem(ServiceHeader; "Service Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Quote));
            RequestFilterFields = "No.", "Customer No.";

            column(No_ServHeader; "No.") { }
            column(Description_ServHeader; Description) { }
            column(DocumentType_ServHeader; "Document Type") { }
            column(OutputNo; 1) { }
            column(QuoteNo; "No.") { }
            column(QuoteDateTxt; QuoteDateTxt) { }
            column(CurrencyCode_ServHeader; "Currency Code") { }
            column(TitleTxt; TitleTxt) { }
            column(ShowOrderInfo; ShowOrderInfo) { }
            column(SummarizeLines; SummarizeLines) { }
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }
            column(OrderConfirmationCopyText; '') { }
            column(CompanyName; CompanyInfo.Name) { }
            column(HomePage; CompanyInfo."Home Page") { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(CompanyEMail; CompanyInfo."E-Mail") { }
            column(Email; CompanyInfo."E-Mail") { }
            column(PaymentTermTxt; PaymentTermDesc) { }
            column(PaymentMethodTxt; PaymentMethodDesc) { }
            column(DueDate; "Due Date") { }
            column(EmailCaption; CompanyInfo.FieldCaption("E-Mail")) { }
            column(HomePageCaption; CompanyInfo.FieldCaption("Home Page")) { }
            column(PhoneNoCaption; CompanyInfo.FieldCaption("Phone No.")) { }
            column(FaxNoCaption; CompanyInfo.FieldCaption("Fax No.")) { }
            column(VATRegNoCaption; CompanyInfo.FieldCaption("VAT Registration No.")) { }
            column(GiroNoCaption; CompanyInfo.FieldCaption("Giro No.")) { }
            column(BankNameCaption; CompanyInfo.FieldCaption("Bank Name")) { }
            column(BankAccountNoCaption; CompanyInfo.FieldCaption("Bank Account No.")) { }
            column(SerHdrOrderDateCaption; ServiceHeader.FieldCaption("Order Date")) { }
            column(ServiceItemLinesCaption; 'サービス品目ライン') { }
            column(No1_ServHeaderCaption; ServiceHeader.FieldCaption("No.")) { }
            column(OrderDate_ServHeaderCaption; ServiceHeader.FieldCaption("Order Date")) { }
            column(OrderTime_ServHeaderCaption; ServiceHeader.FieldCaption("Order Time")) { }
            column(Status_ServHeaderCaption; ServiceHeader.FieldCaption(Status)) { }
            column(PageNoCaption; 'ページ番号') { }
            column(PageCaption; 'ページ') { }
            column(DocumentDateCaption; '日付') { }
            column(CompanyInfoPhoneNoCaption; CompanyInfo.FieldCaption("Phone No.")) { }
            column(CompanyInfoFaxNoCaption; CompanyInfo.FieldCaption("Fax No.")) { }
            column(CompanyInfoEmailCaption; CompanyInfo.FieldCaption("E-Mail")) { }
            column(CompanyInfoHomePageCaption; CompanyInfo.FieldCaption("Home Page")) { }
            column(CompanyInfoVATRegNoCaption; CompanyInfo.FieldCaption("VAT Registration No.")) { }
            column(CompanyInfoGiroNoCaption; CompanyInfo.FieldCaption("Giro No.")) { }
            column(CompanyInfoBankNameCaption; CompanyInfo.FieldCaption("Bank Name")) { }
            column(CompanyInfoBankAccNoCaption; CompanyInfo.FieldCaption("Bank Account No.")) { }
            column(No1_ServHeader; "No.") { }
            column(Status_ServHeader; Status) { }
            column(OrderDate_ServHeader; Format("Order Date")) { }
            column(OrderTime_ServHeader; "Order Time") { }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.") { }
            column(VATRegistrationNo_ServHeader; "VAT Registration No.") { }
            column(PhoneNo_ServHeader; "Phone No.") { }
            column(FaxNo_ServHeader; "Fax No.") { }
            column(EMail_ServHeader; "E-Mail") { }
            column(CustNo_ServHeader; "Customer No.") { }
            column(CustName; "Name") { }
            column(InvoicetoCaption; '請求先') { } // 直接テキスト、または見出し変数
            column(AppliestoDocType_ServHeaderCaption; ServiceHeader.FieldCaption("Applies-to Doc. Type")) { }
            column(AppliestoDocNo_ServHeaderCaption; ServiceHeader.FieldCaption("Applies-to Doc. No.")) { }
            column(ServiceOrderNo_ServHeaderCaption; 'サービス注文番号') { }
            column(BilltoCustNo_ServHeader; "Bill-to Customer No.") { }
            column(BilltoName_ServHeader; "Bill-to Name") { }
            column(BilltoName2_ServHeader; "Bill-to Name 2") { }
            column(BilltoAddr1_ServHeader; "Bill-to Address") { }
            column(BilltoAddr2_ServHeader; "Bill-to Address 2") { }
            column(BilltoCity_ServHeader; "Bill-to City") { }
            column(BilltoPostCode_ServHeader; "Bill-to Post Code") { }
            column(BilltoCounty_ServHeader; "Bill-to County") { }
            column(BilltoCountryCode_ServHeader; "Bill-to Country/Region Code") { }
            column(BilltoContact_ServHeader; "Bill-to Contact") { }
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CustAddr7; CustAddr[7]) { }
            column(CustAddr8; CustAddr[8]) { }
            column(CustPostCode; "Post Code") { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyFaxNo; CompanyInfo."Fax No.") { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }
            column(CompanyNameJP; CompanyInfo."Ship-to Name") { }

            dataitem(ServiceItemLine; "Service Item Line")
            {
                DataItemLinkReference = ServiceHeader;
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(LineNo_ServLineType; "Line No.") { }
                column(Description_ServLineType; Description) { }
                column(ItemNo_ServLineType; "Item No.") { }
                column(ServItemNo_ServLineType; "Service Item No.") { }
                column(ServiceItemDesc; Description) { }
                column(SerItmGrCode_ServLineType; "Service Item Group Code") { }
                column(SerialNo_ServLineType; "Serial No.") { }
                column(Warranty1_ServLineType; Warranty) { }

                dataitem(ServiceLine; "Service Line")
                {
                    DataItemLinkReference = ServiceItemLine;
                    DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), "Service Item Line No." = field("Line No.");
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");



                    column(LineNo_ServLine; "Line No.") { }
                    column(Type_ServLine; Type) { } // ★追加
                    column(Description_ServLine; Description) { }
                    column(Quantity_ServLine; Quantity) { }
                    column(UnitPrice_ServLine; "Unit Price") { }
                    column(Amt; "Line Amount") { }
                    column(GrossAmt; "Amount Including VAT") { }
                    column(LineUOM; "Unit of Measure Code") { }
                    column(SerItemSlNo_ServLineCaption; FieldCaption("Service Item Line No.")) { }
                    column(Quantity_ServLineCaption; FieldCaption(Quantity)) { }
                    column(UnitPrice_ServLineCaption; FieldCaption("Unit Price")) { }
                    column(Description_ServLineCaption; FieldCaption(Description)) { }

                    trigger OnPreDataItem()
                    begin
                        if SummarizeLines then CurrReport.Break();
                    end;
                }
            }

            dataitem(SummarizedLine; "Integer")
            {
                DataItemTableView = sorting(Number);

                // レコードフィールドではなく、グローバル変数を参照させる
                column(FlatLineNo_ServLine; Number) { }
                column(FlatLineDescription; FlatLineDescription) { }
                column(FlatLineQuantity; FlatQty) { }
                column(FlatLineUOM; FlatUOM) { }
                column(FlatUnitPrice; FlatPrice) { }
                column(FlatLineAmount; FlatAmount) { }
                column(FlatLineType; FlatLineType) { }
                column(FlatFaultReasonCode; FlatFaultReasonCode) { }
                column(FlatLineDiscountAmt; FlatLineDiscountAmt) { }

                trigger OnPreDataItem()
                begin
                    if not SummarizeLines then
                        CurrReport.Break();

                    SummarizeServiceLines();
                    SetRange(Number, 1, TempServiceLine.Count());

                    if TempServiceLine.FindSet() then;
                end;

                trigger OnAfterGetRecord()
                var
                    FaultReason: Record "Fault Reason Code";
                begin
                    // データの取得
                    if Number = 1 then
                        TempServiceLine.FindSet()
                    else
                        TempServiceLine.Next();

                    // 1. 変数の初期化（前の行のデータが残らないように確実にリセット）
                    FlatFaultReasonCode := '';
                    FlatLineDiscountAmt := 0;

                    // 2. 基本データの代入
                    FlatLineDescription := TempServiceLine.Description;
                    FlatQty := TempServiceLine.Quantity;
                    FlatAmount := TempServiceLine."Line Amount";
                    FlatPrice := TempServiceLine."Unit Price";
                    FlatUOM := TempServiceLine."Unit of Measure Code";

                    // 3. --- Type別の表示制御ロジック ---
                    if TempServiceLine.Type = TempServiceLine.Type::Cost then begin
                        // 【値引き行の場合】
                        FlatLineType := 'DISCOUNT';

                        // 理由コードから名称（Description）を取得。マスタに無ければコードをそのまま表示
                        if FaultReason.Get(TempServiceLine."Fault Reason Code") then
                            FlatFaultReasonCode := FaultReason.Description
                        else
                            FlatFaultReasonCode := TempServiceLine."Fault Reason Code";

                        FlatLineDiscountAmt := TempServiceLine."Line Amount";
                    end else begin
                        // 【通常の名寄せ明細行の場合】
                        case TempServiceLine.Type of
                            TempServiceLine.Type::Item:
                                FlatLineType := 'ITEM';
                            TempServiceLine.Type::Resource:
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

            dataitem(ServiceCommentLine; "Service Comment Line")
            {
                DataItemLinkReference = ServiceHeader;
                DataItemLink = "Table Subtype" = field("Document Type"), "No." = field("No.");
                DataItemTableView = sorting("Table Name", "Table Subtype", "No.", "Type", "Table Line No.", "Line No.")
                                    where("Table Name" = const("Service Header"));

                column(CommentText; Comment) { }
            }

            trigger OnAfterGetRecord()
            begin
                UpdateHeaderInfo();
                if SummarizeLines then SummarizeServiceLines();
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

    var
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        ServiceFormatAddr: Codeunit "Service Format Address";
        TempServiceLine: Record "Service Line" temporary;
        PaymentTermDesc: Text[100];
        PaymentMethodDesc: Text[100];
        QuoteDateTxt: Text[50];
        TitleTxt: Text[50];
        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        TotalExclVAT: Decimal;
        TotalVAT: Decimal;
        TotalInclVAT: Decimal;
        ShowOrderInfo: Boolean;
        SummarizeLines: Boolean;
        FlatLineDescription: Text[100];
        FlatQty: Decimal;
        FlatUOM: Code[10];
        FlatPrice: Decimal;
        FlatAmount: Decimal;
        FlatLineType: Text[20];
        FlatFaultReasonCode: Code[20];
        FlatLineDiscountAmt: Decimal;
        Qty, Amt, GrossAmt, TotalAmt, TotalGrossAmt : Decimal;

    local procedure UpdateHeaderInfo()
    var
        ServiceLineRec: Record "Service Line";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
    begin
        if ShowOrderInfo then
            TitleTxt := 'サービス見積書 兼 注文書'
        else
            TitleTxt := 'サービス見積書';

        QuoteDateTxt := Format(ServiceHeader."Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

        // 支払条件の名称取得
        PaymentTermDesc := '';
        if PaymentTerms.Get(ServiceHeader."Payment Terms Code") then
            PaymentTermDesc := PaymentTerms.Description;

        // 支払方法の名称取得
        PaymentMethodDesc := '';
        if PaymentMethod.Get(ServiceHeader."Payment Method Code") then
            PaymentMethodDesc := PaymentMethod.Description;

        CompanyInfo.Get();
        ServiceFormatAddr.ServiceHeaderSellTo(CustAddr, ServiceHeader);
        FormatAddr.Company(CompanyAddr, CompanyInfo);

        TotalExclVAT := 0;
        TotalInclVAT := 0;
        ServiceLineRec.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLineRec.SetRange("Document No.", ServiceHeader."No.");
        if ServiceLineRec.FindSet() then
            repeat
                TotalExclVAT += ServiceLineRec."Line Amount";
                TotalInclVAT += ServiceLineRec."Amount Including VAT";
            until ServiceLineRec.Next() = 0;
        TotalVAT := TotalInclVAT - TotalExclVAT;
    end;

    local procedure SummarizeServiceLines()
    var
        ServiceLineRec: Record "Service Line";
        Res: Record Resource;
        ResGrp: Record "Resource Group";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        TempSortBuffer: Record "Service Line" temporary; // 並び替え用の一時変数
        NextLineNo: Integer;
        CurrentResGrp: Code[20];
        TargetResGrp: Code[20];
        DiscountAmt: Decimal;
        FaultReasonCodeMst: Record "Fault Reason Code";
        LineBaseAmount: Decimal;
        FaultReasonName: Text[50];
        TempLineNo: Integer;
        boolFound: Boolean;
        Text50020: Label '%1（値引）', Comment = '%1 = Fault Reason Description';
        Qty, Amt, GrossAmt, TotalAmt, TotalGrossAmt, TotalExclVAT, TotalInclVAT, TotalVAT, FlatQty, FlatAmount, FlatPrice : Decimal;


    begin
        // 初期化
        TempServiceLine.Reset();
        TempServiceLine.DeleteAll();
        TempLineNo := -1; // ★マイナスから始める（既存のLine No.と被らないように）
        TotalAmt := 0;
        TotalGrossAmt := 0;
        ServiceMgtSetup.Get();

        ServiceLineRec.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLineRec.SetRange("Document No.", ServiceHeader."No.");
        if ServiceLineRec.FindSet() then
            repeat
                // 金額計算（合計計算用）
                CalculateAmounts(ServiceLineRec);
                TotalAmt += Amt;
                TotalGrossAmt += GrossAmt;

                // --- 1. 通常行の処理（名寄せ） ---
                LineBaseAmount := ServiceLineRec.Quantity * ServiceLineRec."Unit Price";
                boolFound := false;

                // リソースの場合の集約先特定
                CurrentResGrp := '';
                TargetResGrp := '';
                if ServiceLineRec.Type = ServiceLineRec.Type::Resource then begin
                    if Res.Get(ServiceLineRec."No.") then begin
                        CurrentResGrp := Res."Resource Group No.";
                        TargetResGrp := CurrentResGrp;
                        if (ServiceMgtSetup."Resource Group Filter" <> '') and
                           (StrPos(ServiceMgtSetup."Resource Group Filter", CurrentResGrp) > 0) then
                            TargetResGrp := ServiceMgtSetup."Resource Group for Sort";
                    end;
                end;

                // リソースの名寄せ判定
                if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (TargetResGrp <> '') then begin
                    TempServiceLine.Reset();
                    TempServiceLine.SetRange(Type, TempServiceLine.Type::Resource);
                    TempServiceLine.SetRange("Resource Group No.", TargetResGrp);
                    if TempServiceLine.FindFirst() then begin
                        TempServiceLine.Quantity += ServiceLineRec.Quantity;
                        TempServiceLine."Line Amount" += LineBaseAmount;
                        TempServiceLine.Modify();
                        boolFound := true;
                    end;
                end;

                if not boolFound then begin
                    // 新規通常行の挿入
                    TempServiceLine.Reset();
                    TempServiceLine.Init();
                    TempServiceLine.TransferFields(ServiceLineRec);

                    // ★重要：通常行として扱うため、理由コードを一旦クリアする
                    // これにより OnAfterGetRecord で FlatFaultReasonCode が空になり、RDLCで混ざらなくなります
                    TempServiceLine."Fault Reason Code" := '';

                    TempServiceLine.Quantity := ServiceLineRec.Quantity;
                    TempServiceLine."Line Amount" := LineBaseAmount; // 値引前の金額を入れる
                    TempServiceLine."Resource Group No." := TargetResGrp;
                    if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (TargetResGrp <> '') then
                        if ResGrp.Get(TargetResGrp) then TempServiceLine.Description := ResGrp.Name;
                    TempServiceLine.Insert();
                end;

                // ★ ここで「同じループ内」でもう一度、値引用の処理を行います。
                if ServiceLineRec."Line Discount %" > 0 then begin
                    FaultReasonName := '';
                    if FaultReasonCodeMst.Get(ServiceLineRec."Fault Reason Code") then
                        FaultReasonName := FaultReasonCodeMst.Description;

                    // 一時テーブル内で「今回の原因コード」の値引専用行(Cost)が既にあるか探す
                    TempServiceLine.Reset();
                    TempServiceLine.SetRange(Type, TempServiceLine.Type::Cost);
                    TempServiceLine.SetRange("Fault Reason Code", ServiceLineRec."Fault Reason Code");

                    if TempServiceLine.FindFirst() then begin
                        // 既にあれば金額を加算（マイナスを引く）
                        TempServiceLine."Line Amount" -= ServiceLineRec."Line Discount Amount";
                        TempServiceLine.Modify();
                    end else begin
                        // なければ「値引用レコード」として新規作成
                        TempServiceLine.Reset();
                        TempServiceLine.Init();
                        TempServiceLine."Document Type" := ServiceLineRec."Document Type";
                        TempServiceLine."Document No." := ServiceLineRec."Document No.";
                        TempServiceLine."Line No." := TempLineNo; // -1, -2...
                        TempLineNo -= 1;

                        TempServiceLine.Type := TempServiceLine.Type::Cost; // ★ここでCostを付与
                        TempServiceLine."Fault Reason Code" := ServiceLineRec."Fault Reason Code";

                        if FaultReasonName <> '' then
                            TempServiceLine.Description := StrSubstNo(Text50020, FaultReasonName)
                        else
                            TempServiceLine.Description := '値引';

                        TempServiceLine."Line Amount" := -ServiceLineRec."Line Discount Amount";
                        TempServiceLine.Quantity := 1;
                        TempServiceLine.Insert();
                    end;
                end;
            until ServiceLineRec.Next() = 0;

        // --- 手順2: 並び替え（リソース -> アイテム -> 値引） ---
        TempSortBuffer.Reset();
        TempSortBuffer.DeleteAll();
        NextLineNo := 10000;

        // A. リソース
        TempServiceLine.Reset();
        TempServiceLine.SetRange(Type, TempServiceLine.Type::Resource);
        if TempServiceLine.FindSet() then repeat InsertIntoBuffer(TempServiceLine, TempSortBuffer, NextLineNo); until TempServiceLine.Next() = 0;

        // B. アイテム（通常明細）
        TempServiceLine.Reset();
        TempServiceLine.SetRange(Type, TempServiceLine.Type::Item);
        if TempServiceLine.FindSet() then repeat InsertIntoBuffer(TempServiceLine, TempSortBuffer, NextLineNo); until TempServiceLine.Next() = 0;

        // C. その他（値引行など）
        TempServiceLine.Reset();
        TempServiceLine.SetRange(Type, TempServiceLine.Type::Cost);
        TempServiceLine.SetCurrentKey("Fault Reason Code");
        if TempServiceLine.FindSet() then
            repeat
                InsertIntoBuffer(TempServiceLine, TempSortBuffer, NextLineNo);
            until TempServiceLine.Next() = 0;

        // --- 手順3: 最終書き戻し ---
        TempServiceLine.Reset();
        TempServiceLine.DeleteAll();
        if TempSortBuffer.FindSet() then repeat TempServiceLine.TransferFields(TempSortBuffer); TempServiceLine.Insert(); until TempSortBuffer.Next() = 0;

        /*
        begin
            // --- 初期化 ---
            TempServiceLine.Reset();
            TempServiceLine.DeleteAll();
            TempLineNo := -1; // 値引き行（Cost型）用のマイナス採番
            ServiceMgtSetup.Get();

            // --- 手順1: データの抽出と「名寄せ（集約）」 ---
            ServiceLineRec.SetRange("Document Type", ServiceHeader."Document Type");
            ServiceLineRec.SetRange("Document No.", ServiceHeader."No.");
            if ServiceLineRec.FindSet() then
                repeat
                    // 合計計算（見積書全体の合計金額用）
                    TotalExclVAT += ServiceLineRec."Line Amount";
                    TotalInclVAT += ServiceLineRec."Amount Including VAT";

                    // --- 1. 通常行の処理（名寄せ） ---
                    // 名寄せ後の明細には「値引き前」の金額を表示するため、単価×数量を計算
                    LineBaseAmount := ServiceLineRec.Quantity * ServiceLineRec."Unit Price";
                    boolFound := false;

                    // リソースの場合の集約先（リソースグループ）特定
                    CurrentResGrp := '';
                    TargetResGrp := '';
                    if ServiceLineRec.Type = ServiceLineRec.Type::Resource then begin
                        if Res.Get(ServiceLineRec."No.") then begin
                            CurrentResGrp := Res."Resource Group No.";
                            TargetResGrp := CurrentResGrp;
                            if (ServiceMgtSetup."Resource Group Filter" <> '') and
                               (StrPos(ServiceMgtSetup."Resource Group Filter", CurrentResGrp) > 0) then
                                TargetResGrp := ServiceMgtSetup."Resource Group for Sort";
                        end;
                    end;

                    // リソースの名寄せ判定と集計
                    if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (TargetResGrp <> '') then begin
                        TempServiceLine.Reset();
                        TempServiceLine.SetRange(Type, TempServiceLine.Type::Resource);
                        TempServiceLine.SetRange("Resource Group No.", TargetResGrp);
                        if TempServiceLine.FindFirst() then begin
                            TempServiceLine.Quantity += ServiceLineRec.Quantity;
                            TempServiceLine."Line Amount" += LineBaseAmount;
                            TempServiceLine.Modify();
                            boolFound := true;
                        end;
                    end;

                    if not boolFound then begin
                        // 新規通常行の挿入（値引き前金額をセット）
                        TempServiceLine.Reset();
                        TempServiceLine.Init();
                        TempServiceLine.TransferFields(ServiceLineRec);

                        // 通常行として扱うため、理由コードを一旦クリア（RDLC側での「値引き表示」との混同防止）
                        TempServiceLine."Fault Reason Code" := '';
                        TempServiceLine.Quantity := ServiceLineRec.Quantity;
                        TempServiceLine."Line Amount" := LineBaseAmount;
                        TempServiceLine."Resource Group No." := TargetResGrp;

                        if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (TargetResGrp <> '') then begin
                            if ResGrp.Get(TargetResGrp) then
                                TempServiceLine.Description := ResGrp.Name;
                        end;

                        TempServiceLine.Insert();
                    end;

                    // --- 2. 値引き行の処理（同じループ内で独立した Cost 行として生成） ---
                    if ServiceLineRec."Line Discount Amount" <> 0 then begin
                        FaultReasonName := '';
                        if FaultReasonCodeMst.Get(ServiceLineRec."Fault Reason Code") then
                            FaultReasonName := FaultReasonCodeMst.Description;

                        // 既に同一の故障理由コードを持つ値引き行があるか確認
                        TempServiceLine.Reset();
                        TempServiceLine.SetRange(Type, TempServiceLine.Type::Cost);
                        TempServiceLine.SetRange("Fault Reason Code", ServiceLineRec."Fault Reason Code");

                        if TempServiceLine.FindFirst() then begin
                            // 既にあれば金額を加算（マイナス値を累計）
                            TempServiceLine."Line Amount" -= ServiceLineRec."Line Discount Amount";
                            TempServiceLine.Modify();
                        end else begin
                            // なければ「値引き専用行」として新規作成
                            TempServiceLine.Reset();
                            TempServiceLine.Init();
                            TempServiceLine."Document Type" := ServiceLineRec."Document Type";
                            TempServiceLine."Document No." := ServiceLineRec."Document No.";
                            TempServiceLine."Line No." := TempLineNo;
                            TempLineNo -= 1;

                            TempServiceLine.Type := TempServiceLine.Type::Cost;
                            TempServiceLine."Fault Reason Code" := ServiceLineRec."Fault Reason Code";

                            // 値引き額をマイナスとして保持
                            TempServiceLine."Line Amount" := -ServiceLineRec."Line Discount Amount";
                            TempServiceLine.Quantity := 1;
                            TempServiceLine.Insert();
                        end;
                    end;
                until ServiceLineRec.Next() = 0;

            // --- 手順2: 並び替え（リソース -> アイテム -> 値引） ---
            TempSortBuffer.Reset();
            TempSortBuffer.DeleteAll();
            NextLineNo := 10000;

            // A. リソース
            TempServiceLine.Reset();
            TempServiceLine.SetRange(Type, TempServiceLine.Type::Resource);
            if TempServiceLine.FindSet() then repeat InsertIntoBuffer(TempServiceLine, TempSortBuffer, NextLineNo); until TempServiceLine.Next() = 0;

            // B. アイテム（通常明細）
            TempServiceLine.Reset();
            TempServiceLine.SetRange(Type, TempServiceLine.Type::Item);
            if TempServiceLine.FindSet() then repeat InsertIntoBuffer(TempServiceLine, TempSortBuffer, NextLineNo); until TempServiceLine.Next() = 0;

            // C. 値引き行（Type = Cost）
            TempServiceLine.Reset();
            TempServiceLine.SetRange(Type, TempServiceLine.Type::Cost);
            if TempServiceLine.FindSet() then
                repeat InsertIntoBuffer(TempServiceLine, TempSortBuffer, NextLineNo); until TempServiceLine.Next() = 0;

            // --- 手順3: 最終書き戻し ---
            TempServiceLine.Reset();
            TempServiceLine.DeleteAll();
            if TempSortBuffer.FindSet() then repeat TempServiceLine.TransferFields(TempSortBuffer); TempServiceLine.Insert(); until TempSortBuffer.Next() = 0;
            */

    end;

    local procedure CalculateAmounts(var RecLine: Record "Service Line")
    begin
        // オプションの値に関わらず、常に明細の数量・金額を使用する
        Qty := RecLine.Quantity;
        Amt := RecLine."Line Amount";
        GrossAmt := RecLine."Amount Including VAT";
    end;

    // 並び替え用の補助関数
    local procedure InsertIntoBuffer(var SourceRec: Record "Service Line" temporary; var DestBuffer: Record "Service Line" temporary; var NextLineNo: Integer)
    begin
        DestBuffer.Init();
        DestBuffer.TransferFields(SourceRec);
        DestBuffer."Line No." := NextLineNo;
        DestBuffer.Insert();
        NextLineNo += 10000;
    end;
}