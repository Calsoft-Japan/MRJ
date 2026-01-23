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

            // --- Caption
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


            // --- 番号・日付・ページ等の見出し不足分を一挙追加 ---
            column(No1_ServHeaderCaption; ServiceHeader.FieldCaption("No.")) { }
            column(OrderDate_ServHeaderCaption; ServiceHeader.FieldCaption("Order Date")) { }
            column(OrderTime_ServHeaderCaption; ServiceHeader.FieldCaption("Order Time")) { }
            column(Status_ServHeaderCaption; ServiceHeader.FieldCaption(Status)) { }
            column(PageNoCaption; 'ページ番号') { }
            column(PageCaption; 'ページ') { }

            column(DocumentDateCaption; '日付') { }
            // --- CompanyInfo系のCaption（見出し）不足分を追加 ---
            column(CompanyInfoPhoneNoCaption; CompanyInfo.FieldCaption("Phone No.")) { }
            column(CompanyInfoFaxNoCaption; CompanyInfo.FieldCaption("Fax No.")) { }
            column(CompanyInfoEmailCaption; CompanyInfo.FieldCaption("E-Mail")) { }
            column(CompanyInfoHomePageCaption; CompanyInfo.FieldCaption("Home Page")) { }
            column(CompanyInfoVATRegNoCaption; CompanyInfo.FieldCaption("VAT Registration No.")) { }
            column(CompanyInfoGiroNoCaption; CompanyInfo.FieldCaption("Giro No.")) { }
            column(CompanyInfoBankNameCaption; CompanyInfo.FieldCaption("Bank Name")) { }
            column(CompanyInfoBankAccNoCaption; CompanyInfo.FieldCaption("Bank Account No.")) { }


            // ==== ★追加項目 (RDLCのHidden式や住所計算エラーの解消用) ====
            column(No1_ServHeader; "No.") { }
            column(Status_ServHeader; Status) { }
            column(OrderDate_ServHeader; Format("Order Date")) { }
            column(OrderTime_ServHeader; "Order Time") { }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.") { }
            column(VATRegistrationNo_ServHeader; "VAT Registration No.") { }

            // 顧客・請求先連絡先
            column(PhoneNo_ServHeader; "Phone No.") { }
            column(FaxNo_ServHeader; "Fax No.") { }
            column(EMail_ServHeader; "E-Mail") { }
            column(CustNo_ServHeader; "Customer No.") { }
            // --- 宛先・見出し系の不足項目をまとめて追加 ---
            column(CustName; "Name") { }
            column(InvoicetoCaption; '請求先') { } // 直接テキスト、または見出し変数
            column(AppliestoDocType_ServHeaderCaption; ServiceHeader.FieldCaption("Applies-to Doc. Type")) { }
            column(AppliestoDocNo_ServHeaderCaption; ServiceHeader.FieldCaption("Applies-to Doc. No.")) { }
            column(ServiceOrderNo_ServHeaderCaption; 'サービス注文番号') { }

            // Bill-to Customer 関連
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

            // 顧客住所 (配列)
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CustAddr7; CustAddr[7]) { }
            column(CustAddr8; CustAddr[8]) { }
            column(CustPostCode; "Post Code") { }

            // 自社住所 (配列)
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
                column(FlatLineNo_ServLine; Number) { }
                column(FlatLineDescription; TempServiceLine.Description) { }
                column(FlatLineQuantity; TempServiceLine.Quantity) { }
                column(FlatLineUOM; TempServiceLine."Unit of Measure Code") { }
                column(FlatUnitPrice; TempServiceLine."Unit Price") { } // 単価
                column(FlatLineAmount; TempServiceLine."Line Amount") { } // 金額(税抜)
                column(FlatGrossAmt; TempServiceLine."Amount Including VAT") { } // 金額(税込)

                trigger OnPreDataItem()
                begin

                    if not SummarizeLines then
                        CurrReport.Break();

                    SummarizeServiceLines();

                    SetRange(Number, 1, TempServiceLine.Count());
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempServiceLine.FindSet()
                    else
                        TempServiceLine.Next();
                    // デバッグ用メッセージ
                    Message('Loop: %1, Desc: %2, Total Count: %3', Number, TempServiceLine.Description, TempServiceLine.Count());

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

    local procedure UpdateHeaderInfo()
    var
        ServiceLineRec: Record "Service Line";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
    begin
        if ShowOrderInfo then
            TitleTxt := 'サービス見積書 兼 注文書'
        else
            TitleTxt := '御見積書';

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
        ServiceMgtSetup: Record "Service Mgt. Setup";
        ResourceGroup: Record "Resource Group";
        TargetGroupCode: Code[20];
        TargetGroupName: Text[100];
    begin
        ServiceMgtSetup.Get();
        TempServiceLine.DeleteAll(); // 一時テーブルのクリア

        if ServiceLine.FindSet() then
            repeat
                // 1. デフォルトの集計キーをセット
                TargetGroupCode := ServiceLine."Resource Group No.";
                TargetGroupName := '';

                // 2. フィルター設定がある場合、読み替え判定を行う
                if (ServiceMgtSetup."Resource Group Filter" <> '') and (TargetGroupCode <> '') then begin
                    // ダミーのRecord変数にフィルターを適用して、現在の行が含まれるか判定
                    ResourceGroup.Reset();
                    ResourceGroup.SetFilter("No.", ServiceMgtSetup."Resource Group Filter");
                    ResourceGroup.SetRange("No.", TargetGroupCode);

                    if not ResourceGroup.IsEmpty then begin
                        // フィルターに合致した場合は、集約用のグループコードに読み替える
                        TargetGroupCode := ServiceMgtSetup."Resource Group for Sort";

                        // 集約後の名称を取得（任意で説明文を書き換える場合）
                        if ResourceGroup.Get(TargetGroupCode) then
                            TargetGroupName := ResourceGroup.Name;
                    end;
                end;

                // 3. 一時テーブル（TempServiceLine）への集計処理
                TempServiceLine.Reset();
                TempServiceLine.SetRange("Resource Group No.", TargetGroupCode);

                if TempServiceLine.FindFirst() then begin
                    // すでに対象グループの行があれば金額・数量を加算
                    TempServiceLine.Quantity += ServiceLine.Quantity;
                    TempServiceLine."Line Amount" += ServiceLine."Line Amount";
                    TempServiceLine."Amount Including VAT" += ServiceLine."Amount Including VAT";
                    TempServiceLine.Modify();
                end else begin
                    // 新規グループとして一行作成
                    TempServiceLine := ServiceLine;
                    TempServiceLine."Resource Group No." := TargetGroupCode;
                    if TargetGroupName <> '' then
                        TempServiceLine.Description := TargetGroupName; // 名称を読み替え後のものに
                    TempServiceLine.Insert();
                end;
            until ServiceLine.Next() = 0;
    end;
}