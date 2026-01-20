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

            // ==== ヘッダー項目 ====
            column(QuoteNo; "No.") { }
            column(QuoteDateTxt; QuoteDateTxt) { }
            column(TitleTxt; TitleTxt) { }
            column(ShowOrderInfo; ShowOrderInfo) { }
            column(SummarizeLines; SummarizeLines) { }

            // 住所・会社情報
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustPostCode; "Post Code") { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyFaxNo; CompanyInfo."Fax No.") { }

            // 合計金額
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }

            // ------------------------------------------------------------
            // パターンA: 明細纏め=OFF（通常：修理対象品目ごとに表示）
            // ------------------------------------------------------------
            dataitem(ServiceItemLine; "Service Item Line")
            {
                DataItemLinkReference = ServiceHeader;
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(ServiceItemNo; "Service Item No.") { }
                column(ServiceItemDesc; Description) { }

                dataitem(ServiceLine; "Service Line")
                {
                    DataItemLinkReference = ServiceItemLine;
                    DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), "Service Item Line No." = field("Line No.");
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                    column(LineDescription; Description) { }
                    column(LineQuantity; Quantity) { }
                    column(LineUOM; "Unit of Measure Code") { }
                    column(LineUnitPrice; "Unit Price") { }
                    column(LineAmount; "Line Amount") { }

                    trigger OnPreDataItem()
                    begin
                        if SummarizeLines then CurrReport.Break();
                    end;
                }
            }

            // ------------------------------------------------------------
            // パターンB: 明細纏め=ON（リソースグループ名で集約して表示）
            // ------------------------------------------------------------
            dataitem(SummarizedLine; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(FlatLineDescription; TempServiceLine.Description) { }
                column(FlatLineQuantity; TempServiceLine.Quantity) { }
                column(FlatLineAmount; TempServiceLine."Line Amount") { }

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

            // 共通: 摘要
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

                if SummarizeLines then
                    SummarizeServiceLines();
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
        ServiceFormatAddr: Codeunit "Service Format Address"; // 新しく追加
        TempServiceLine: Record "Service Line" temporary;
        QuoteDateTxt: Text[50];
        TitleTxt: Text[50];
        ExpirationDateTxt: Text[50];
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

        // 修正箇所: FormatAddr から ServiceFormatAddr に変更
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
                    TempServiceLine."Line No." += 10000;
                    TempServiceLine.Description := GroupKey;
                    TempServiceLine.Quantity := ServiceLine.Quantity;
                    TempServiceLine."Line Amount" := ServiceLine."Line Amount";
                    TempServiceLine.Insert();
                end;
            until ServiceLine.Next() = 0;
    end;
}