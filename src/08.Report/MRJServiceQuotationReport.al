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

            column(PaymentTermTxt; "Payment Terms Code") { }
            column(PaymentMethodTxt; "Payment Method Code") { }

            // --- Caption（見出し）項目の不足分を追加 ---
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
                column(FlatLineAmount; TempServiceLine."Line Amount") { }
                column(FlatAmt; TempServiceLine."Line Amount") { }

                trigger OnPreDataItem()
                begin
                    if not SummarizeLines then CurrReport.Break();
                    SetRange(Number, 1, TempServiceLine.Count());
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then TempServiceLine.FindSet() else TempServiceLine.Next();
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
    begin
        if ShowOrderInfo then
            TitleTxt := '御見積書 兼 注文書'
        else
            TitleTxt := '御見積書';

        QuoteDateTxt := Format(ServiceHeader."Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');

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
        ServiceLine: Record "Service Line";
        Resource: Record Resource;
        ResGroup: Record "Resource Group";
        GroupKey: Text[100];
    begin
        TempServiceLine.Reset();
        TempServiceLine.DeleteAll();

        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        if ServiceLine.FindSet() then
            repeat
                GroupKey := ServiceLine.Description;
                if ServiceLine.Type = ServiceLine.Type::Resource then begin
                    if Resource.Get(ServiceLine."No.") then begin
                        if ResGroup.Get(Resource."Resource Group No.") then
                            GroupKey := ResGroup.Name;
                    end;
                end;

                TempServiceLine.Reset();
                TempServiceLine.SetRange(Description, GroupKey);
                if TempServiceLine.FindFirst() then begin
                    TempServiceLine.Quantity += ServiceLine.Quantity;
                    TempServiceLine."Line Amount" += ServiceLine."Line Amount";
                    TempServiceLine.Modify();
                end else begin
                    TempServiceLine.Init();
                    TempServiceLine."Line No." := TempServiceLine."Line No." + 10000;
                    TempServiceLine.Description := GroupKey;
                    TempServiceLine.Quantity := ServiceLine.Quantity;
                    TempServiceLine."Line Amount" := ServiceLine."Line Amount";
                    TempServiceLine.Insert();
                end;
            until ServiceLine.Next() = 0;
    end;
}