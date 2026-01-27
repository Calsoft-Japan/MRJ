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
                column(FlatLineDescription; Description) { } // Text型のDescription変数
                column(FlatLineQuantity; FlatQty) { }
                column(FlatLineUOM; FlatUOM) { }
                column(FlatUnitPrice; FlatPrice) { }
                column(FlatLineAmount; FlatAmount) { }

                trigger OnPreDataItem()
                begin
                    if not SummarizeLines then
                        CurrReport.Break();

                    SummarizeServiceLines();
                    SetRange(Number, 1, TempServiceLine.Count());

                    if TempServiceLine.FindSet() then;
                end;

                trigger OnAfterGetRecord()
                begin
                    // 現在のレコードの内容を変数に代入（これでRDLCに確実に値が流れる）
                    Description := TempServiceLine.Description;
                    FlatQty := TempServiceLine.Quantity;
                    FlatUOM := TempServiceLine."Unit of Measure Code";
                    FlatPrice := TempServiceLine."Unit Price";
                    FlatAmount := TempServiceLine."Line Amount";

                    //デバッグ用確認メッセージ
                    //Message('Loop: %1, Exporting: %2', Number, Description);

                    // 次のレコードへ移動
                    if TempServiceLine.Next() = 0 then;
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
        Description: Text;
        FlatQty: Decimal;
        FlatUOM: Code[10];
        FlatPrice: Decimal;
        FlatAmount: Decimal;

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
    /*
        local procedure SummarizeServiceLines()
        var
            ServiceLineRec: Record "Service Line";
            Res: Record Resource;
            ResGrp: Record "Resource Group";
            NextLineNo: Integer;
            CurrentResGrp: Code[20];
        begin
            // 一時テーブルを初期化
            TempServiceLine.Reset();
            TempServiceLine.DeleteAll();
            NextLineNo := 10000;

            // 実際の明細（5件）を取得
            ServiceLineRec.SetRange("Document Type", ServiceHeader."Document Type");
            ServiceLineRec.SetRange("Document No.", ServiceHeader."No.");

            if ServiceLineRec.FindSet() then
                repeat
                    CurrentResGrp := '';

                    // --- 判定：リソースの場合のみマスタからグループ番号を引く ---
                    if ServiceLineRec.Type = ServiceLineRec.Type::Resource then begin
                        if Res.Get(ServiceLineRec."No.") then
                            CurrentResGrp := Res."Resource Group No.";
                    end;

                    // --- 名寄せの実行（リソース且つグループ番号がある場合のみ） ---
                    if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (CurrentResGrp <> '') then begin

                        TempServiceLine.Reset();
                        TempServiceLine.SetRange(Type, TempServiceLine.Type::Resource);
                        TempServiceLine.SetRange("Resource Group No.", CurrentResGrp);

                        if TempServiceLine.FindFirst() then begin
                            // 【発見】同じグループなら既存行の金額と数量を加算
                            TempServiceLine.Quantity += ServiceLineRec.Quantity;
                            TempServiceLine."Line Amount" += ServiceLineRec."Line Amount";
                            TempServiceLine."Amount Including VAT" += ServiceLineRec."Amount Including VAT";
                            TempServiceLine.Modify();
                            continue; // 合算したので次のServiceLineRecへ進む
                        end;
                    end;

                    // --- 新規挿入（アイテム、または新しいリソースグループ） ---
                    TempServiceLine.Reset();
                    TempServiceLine.Init();
                    TempServiceLine.TransferFields(ServiceLineRec);

                    // 主キー(Line No.)を再採番して重複を回避
                    TempServiceLine."Line No." := NextLineNo;
                    NextLineNo += 10000;

                    // 検索用にグループ番号を一時テーブルのフィールドに保持
                    TempServiceLine."Resource Group No." := CurrentResGrp;

                    // リソースの場合は、名称をリソースグループ名（例：外注作業費）に書き換え
                    if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (CurrentResGrp <> '') then begin
                        if ResGrp.Get(CurrentResGrp) then
                            TempServiceLine.Description := ResGrp.Name;
                    end;

                    TempServiceLine.Insert();
                until ServiceLineRec.Next() = 0;

            TempServiceLine.Reset();
        end;

*/
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
    begin
        TempServiceLine.Reset();
        TempServiceLine.DeleteAll();
        ServiceMgtSetup.Get();

        // --- 手順1: データの抽出と「名寄せ（集約）」 ---
        ServiceLineRec.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLineRec.SetRange("Document No.", ServiceHeader."No.");
        if ServiceLineRec.FindSet() then
            repeat
                CurrentResGrp := '';
                TargetResGrp := '';

                if ServiceLineRec.Type = ServiceLineRec.Type::Resource then begin
                    if Res.Get(ServiceLineRec."No.") then begin
                        CurrentResGrp := Res."Resource Group No.";
                        TargetResGrp := CurrentResGrp;
                        // 特定フィルタに該当する場合の振替
                        if (ServiceMgtSetup."Resource Group Filter" <> '') and
                           (StrPos(ServiceMgtSetup."Resource Group Filter", CurrentResGrp) > 0) then
                            TargetResGrp := ServiceMgtSetup."Resource Group for Sort";
                    end;
                end;

                // 名寄せ判定
                if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (TargetResGrp <> '') then begin
                    TempServiceLine.Reset();
                    TempServiceLine.SetRange(Type, TempServiceLine.Type::Resource);
                    TempServiceLine.SetRange("Resource Group No.", TargetResGrp);
                    if TempServiceLine.FindFirst() then begin
                        TempServiceLine.Quantity += ServiceLineRec.Quantity;
                        TempServiceLine."Line Amount" += ServiceLineRec."Line Amount";
                        TempServiceLine."Amount Including VAT" += ServiceLineRec."Amount Including VAT";
                        TempServiceLine.Modify();
                        continue;
                    end;
                end;

                // 新規行として一時テーブルに追加
                TempServiceLine.Reset();
                TempServiceLine.Init();
                TempServiceLine.TransferFields(ServiceLineRec);
                TempServiceLine."Resource Group No." := TargetResGrp;
                if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (TargetResGrp <> '') then begin
                    if ResGrp.Get(TargetResGrp) then
                        TempServiceLine.Description := ResGrp.Name;
                end;
                TempServiceLine.Insert();
            until ServiceLineRec.Next() = 0;

        // --- 手順2: 「並び替え」の実行 ---
        TempSortBuffer.Reset();
        TempSortBuffer.DeleteAll();
        NextLineNo := 10000;

        // A. リソースを「リソースグループ番号」の順序で抽出
        TempServiceLine.Reset();
        TempServiceLine.SetRange(Type, TempServiceLine.Type::Resource);

        // 【重要】Resource Group No. フィールドでソートをかける
        // Service Lineテーブルにこのキーがない場合でも、一時テーブルなら
        // SetCurrentKey で動的にソートが可能です
        TempServiceLine.SetCurrentKey("Resource Group No.");

        if TempServiceLine.FindSet() then
            repeat
                // このループでは 01 -> 02 -> 03 ... の順でレコードが取り出される
                InsertIntoBuffer(TempServiceLine, TempSortBuffer, NextLineNo);
            until TempServiceLine.Next() = 0;

        // B. 次に リソース以外（Item等）を抽出
        TempServiceLine.Reset();
        TempServiceLine.SetFilter(Type, '<>%1', TempServiceLine.Type::Resource);
        // アイテムは元の番号順、または必要に応じて No. 順などでソート
        if TempServiceLine.FindSet() then
            repeat
                InsertIntoBuffer(TempServiceLine, TempSortBuffer, NextLineNo);
            until TempServiceLine.Next() = 0;

        // --- 手順3: 最終的な TempServiceLine に書き戻す ---
        TempServiceLine.Reset();
        TempServiceLine.DeleteAll();
        if TempSortBuffer.FindSet() then
            repeat
                TempServiceLine.TransferFields(TempSortBuffer);
                TempServiceLine.Insert();
            until TempSortBuffer.Next() = 0;
    end;

    local procedure InsertIntoBuffer(var FromRec: Record "Service Line"; var ToBuffer: Record "Service Line"; var NextNo: Integer)
    begin
        ToBuffer.Init();
        ToBuffer.TransferFields(FromRec);
        ToBuffer."Line No." := NextNo; // ここで新しい順序番号を振る
        NextNo += 10000;
        ToBuffer.Insert();
    end;
}