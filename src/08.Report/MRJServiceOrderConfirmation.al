report 50022 "MRJ Service Order Confirmation"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Service Order Confirmation';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJServiceOrderConfirmationReport.rdlc';

    dataset
    {
        dataitem(Header; "Service Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Customer No.";

            // --- Header Columns ---
            column(No_; "No.") { }
            column(Customer_No_; "Customer No.") { }
            column(txtDate; txtDate) { }
            column(SummarizeLines; SummarizeLines) { }
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }
            column(PaymentTermsDesc; PaymentTermsDesc) { }
            column(PaymentMethodDesc; PaymentMethodDesc) { }
            column(CurrencyCode_ServHeader; "Currency Code") { }
            column(CustPostCode; "Post Code") { }

            // --- Customer & Company Address ---
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }

            column(CompanyFaxNo; CompanyInfo."Fax No.") { }
            column(CompanyRegistrationNo; CompanyInfo."Registration No.") { }
            column(CompanyNameJP; CompanyInfo."Ship-to Name") { }


            // --- 1. 通常の明細（Service Item Line 階層） ---
            dataitem(ServiceItemLine; "Service Item Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(LineNo_ServLineType; "Line No.") { }
                column(ItemNo_ServLineType; "Item No.") { }
                column(ServItemNo_ServLineType; "Service Item No.") { }
                column(Description_ServLineType; Description) { }
                column(SerialNo_ServLineType; "Serial No.") { }
                column(SerItmGrCode_ServLineType; "Service Item Group Code") { }
                column(Warranty1_ServLineType; Warranty) { }

                dataitem(ServiceLine; "Service Line")
                {
                    DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), "Service Item Line No." = field("Line No.");
                    DataItemLinkReference = ServiceItemLine;
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                    column(LineNo_ServLine; "Line No.") { }
                    column(Type_ServLine; Type) { }
                    column(Description_ServLine; Description) { }
                    column(Quantity_ServLine; Qty) { }
                    column(Amt; Amt) { }
                    column(LineUOM; "Unit of Measure Code") { }
                    column(UnitPrice_ServLine; "Unit Price") { }

                    trigger OnPreDataItem()
                    begin
                        if SummarizeLines then CurrReport.Break();
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        CalculateAmounts(ServiceLine);
                    end;
                }
            }

            // --- 2. 明細纏め（Integer 階層） ---
            dataitem(SummarizedLine; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(FlatLineDescription; FlatDescription) { }
                column(FlatLineQuantity; FlatQty) { }
                column(FlatLineAmount; FlatAmount) { }
                column(FlatServItemNo; FlatServItemNo) { }
                column(FlatLineUOM; FlatUOM) { }
                column(FlatUnitPrice; FlatPrice) { }
                column(FlatLineType; FlatLineType) { }

                trigger OnPreDataItem()
                begin
                    if not SummarizeLines then CurrReport.Break();
                    SummarizeServiceLines();
                    SetRange(Number, 1, TempServiceLine.Count());
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then TempServiceLine.FindSet() else TempServiceLine.Next();

                    FlatDescription := TempServiceLine.Description;
                    FlatQty := TempServiceLine.Quantity;
                    FlatAmount := TempServiceLine."Line Amount";
                    FlatServItemNo := TempServiceLine."Service Item No.";
                    FlatUOM := TempServiceLine."Unit of Measure Code";
                    FlatPrice := TempServiceLine."Unit Price";

                    if TempServiceLine.Type = TempServiceLine.Type::Item then
                        FlatLineType := 'ITEM' // 常に大文字の 'ITEM' を入れる
                    else
                        FlatLineType := 'RESOURCE';

                end;
            }

            // --- 3. コメント行（Header 直下へ移動） ---
            dataitem(ServiceCommentLine; "Service Comment Line")
            {
                DataItemLinkReference = Header;
                DataItemLink = "Table Subtype" = field("Document Type"), "No." = field("No.");

                DataItemTableView = sorting("Table Name", "Table Subtype", "No.", "Type", "Table Line No.", "Line No.")
                        where("Table Name" = const("Service Header"), "Type" = const(General));

                column(No_SCL; "No.") { }
                column(CommentText; Comment) { }
            }

            trigger OnAfterGetRecord()
            var
                FormatAddr: Codeunit "Format Address";
                PaymentTerms: Record "Payment Terms";
                PaymentMethod: Record "Payment Method";
            begin
                TotalAmt := 0;
                TotalGrossAmt := 0;

                txtDate := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');
                if CompanyInfo.Get() then CompanyInfo.CalcFields(Picture);

                FormatAddr.ServiceOrderSellto(CustAddr, Header);
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                if PaymentTerms.Get("Payment Terms Code") then PaymentTermsDesc := PaymentTerms.Description;
                if PaymentMethod.Get("Payment Method Code") then PaymentMethodDesc := PaymentMethod.Description;

                if SummarizeLines then
                    SummarizeServiceLines()
                else
                    PreCalculateTotals();

                TotalExclVAT := TotalAmt;
                TotalInclVAT := TotalGrossAmt;
                TotalVAT := TotalInclVAT - TotalExclVAT;
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
                    field(ShowQtyField; ShowQty)
                    {
                        ApplicationArea = Service;
                        Caption = '金額基準';
                        OptionCaption = '数量,請求済数量';
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
        TempServiceLine: Record "Service Line" temporary;
        txtDate: Text[50];
        SummarizeLines: Boolean;
        ShowQty: Option Quantity,"Quantity Invoiced";
        Qty, Amt, GrossAmt, TotalAmt, TotalGrossAmt, TotalExclVAT, TotalInclVAT, TotalVAT, FlatQty, FlatAmount, FlatPrice : Decimal;
        FlatDescription: Text;
        FlatServItemNo: Code[20];
        FlatUOM: Code[10];
        FlatLineType: Text[20];
        CustAddr, CompanyAddr : array[8] of Text[100];
        PaymentTermsDesc, PaymentMethodDesc : Text[100];

    local procedure CalculateAmounts(var RecLine: Record "Service Line")
    begin
        if ShowQty = ShowQty::Quantity then begin
            Qty := RecLine.Quantity;
            Amt := RecLine."Line Amount";
            GrossAmt := RecLine."Amount Including VAT";
        end else begin
            Qty := RecLine."Quantity Invoiced";
            Amt := Round((Qty * RecLine."Unit Price") * (1 - RecLine."Line Discount %" / 100));
            GrossAmt := Round((1 + RecLine."VAT %" / 100) * Amt);
        end;
    end;

    local procedure SummarizeServiceLines()
    var
        ServiceLineRec: Record "Service Line";
        Res: Record Resource;
        ResGrp: Record "Resource Group";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        TempSortBuffer: Record "Service Line" temporary;
        NextLineNo: Integer;
        CurrentResGrp: Code[20];
        TargetResGrp: Code[20];
    begin
        // 初期化
        TempServiceLine.Reset();
        TempServiceLine.DeleteAll();
        TotalAmt := 0;
        TotalGrossAmt := 0;
        ServiceMgtSetup.Get();

        // --- 手順1: 名寄せ（集約） ---
        ServiceLineRec.SetRange("Document Type", Header."Document Type");
        ServiceLineRec.SetRange("Document No.", Header."No.");
        if ServiceLineRec.FindSet() then
            repeat
                CalculateAmounts(ServiceLineRec); // 金額計算
                TotalAmt += Amt;
                TotalGrossAmt += GrossAmt;

                CurrentResGrp := '';
                TargetResGrp := '';

                // リソースの場合、集約先のリソースグループを特定
                if ServiceLineRec.Type = ServiceLineRec.Type::Resource then begin
                    if Res.Get(ServiceLineRec."No.") then begin
                        CurrentResGrp := Res."Resource Group No.";
                        TargetResGrp := CurrentResGrp;

                        // セットアップのフィルタに基づきグループを振り替え（ソート用）
                        if (ServiceMgtSetup."Resource Group Filter" <> '') and
                           (StrPos(ServiceMgtSetup."Resource Group Filter", CurrentResGrp) > 0) then
                            TargetResGrp := ServiceMgtSetup."Resource Group for Sort";
                    end;
                end;


                // 名寄せ判定（リソースの場合、サービス品目に関係なく合算）
                if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (TargetResGrp <> '') then begin
                    TempServiceLine.Reset();
                    TempServiceLine.SetRange(Type, TempServiceLine.Type::Resource);
                    TempServiceLine.SetRange("Resource Group No.", TargetResGrp);

                    // Service Item No. の SetRange を行わない
                    // これにより、異なるサービス品目の行も同じリソースグループとして見つかる

                    if TempServiceLine.FindFirst() then begin
                        // すでに同じグループの行があれば、数量と金額を足し算する
                        TempServiceLine.Quantity += Qty;
                        TempServiceLine."Line Amount" += Amt;

                        // サービス品目が混在するため、レポート上の表示を空にする（任意）
                        TempServiceLine."Service Item No." := '';

                        TempServiceLine.Modify();
                        continue; // 次の行の処理へスキップ
                    end;
                end;

                // 新規行として一時テーブルに追加
                TempServiceLine.Reset();
                TempServiceLine.Init();
                TempServiceLine.TransferFields(ServiceLineRec);
                TempServiceLine.Quantity := Qty;
                TempServiceLine."Line Amount" := Amt;
                TempServiceLine."Unit Price" := ServiceLineRec."Unit Price"; // 元の単価をそのまま保持
                TempServiceLine."Resource Group No." := TargetResGrp; // ソート用

                // リソースの場合は説明をリソースグループ名に書き換え
                if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (TargetResGrp <> '') then begin
                    if ResGrp.Get(TargetResGrp) then
                        TempServiceLine.Description := ResGrp.Name;
                end;
                TempServiceLine.Insert();
            until ServiceLineRec.Next() = 0;

        // --- 手順2: 並び替え ---
        TempSortBuffer.Reset();
        TempSortBuffer.DeleteAll();
        NextLineNo := 10000;

        // A. リソースをグループ順にバッファへ
        TempServiceLine.Reset();
        TempServiceLine.SetRange(Type, TempServiceLine.Type::Resource);
        TempServiceLine.SetCurrentKey("Resource Group No."); // 一時テーブルなので動的ソート可
        if TempServiceLine.FindSet() then
            repeat
                InsertIntoBuffer(TempServiceLine, TempSortBuffer, NextLineNo);
            until TempServiceLine.Next() = 0;

        // B. リソース以外をバッファへ
        TempServiceLine.Reset();
        TempServiceLine.SetFilter(Type, '<>%1', TempServiceLine.Type::Resource);
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

    // 並び替え用の補助関数
    local procedure InsertIntoBuffer(var SourceRec: Record "Service Line" temporary; var DestBuffer: Record "Service Line" temporary; var NextLineNo: Integer)
    begin
        DestBuffer.Init();
        DestBuffer.TransferFields(SourceRec);
        DestBuffer."Line No." := NextLineNo;
        DestBuffer.Insert();
        NextLineNo += 10000;
    end;

    local procedure PreCalculateTotals()
    var
        ServiceLineRec: Record "Service Line";
    begin
        ServiceLineRec.SetRange("Document Type", Header."Document Type");
        ServiceLineRec.SetRange("Document No.", Header."No.");
        if ServiceLineRec.FindSet() then
            repeat
                CalculateAmounts(ServiceLineRec);
                if not ((ShowQty = ShowQty::"Quantity Invoiced") and (Qty = 0)) then begin
                    TotalAmt += Amt;
                    TotalGrossAmt += GrossAmt;
                end;
            until ServiceLineRec.Next() = 0;
    end;
}