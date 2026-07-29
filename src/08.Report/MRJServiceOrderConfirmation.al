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
            column(ContactName; ContactName) { }
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
                column(FlatLineDescription; FlatLineDescription) { }
                column(FlatLineQuantity; FlatQty) { }
                column(FlatLineAmount; FlatAmount) { }
                column(FlatServItemNo; FlatServItemNo) { }
                column(FlatLineUOM; FlatUOM) { }
                column(FlatUnitPrice; FlatPrice) { }
                column(FlatLineType; FlatLineType) { }
                column(FlatFaultReasonCode; FlatFaultReasonCode) { }
                column(FlatLineDiscountAmt; FlatLineDiscountAmt) { }

                trigger OnPreDataItem()
                begin
                    if not SummarizeLines then CurrReport.Break();
                    SummarizeServiceLines();
                    SetRange(Number, 1, TempServiceLine.Count());
                end;

                trigger OnAfterGetRecord()
                var
                    FaultReason: Record "Fault Reason Code"; // 名称取得用のレコード変数
                begin
                    if Number = 1 then TempServiceLine.FindSet() else TempServiceLine.Next();

                    // 変数の初期化（前の行のデータが残らないように）
                    FlatFaultReasonCode := '';
                    FlatLineDiscountAmt := 0;

                    // 基本データの代入
                    FlatLineDescription := TempServiceLine.Description;
                    FlatQty := TempServiceLine.Quantity;
                    FlatAmount := TempServiceLine."Line Amount";
                    FlatPrice := TempServiceLine."Unit Price";
                    FlatUOM := TempServiceLine."Unit of Measure Code";

                    // --- Type別の特殊処理 ---
                    if TempServiceLine.Type = TempServiceLine.Type::Cost then begin
                        // 【値引き行の場合】
                        FlatLineType := 'DISCOUNT';

                        // 【修正ポイント】コードから名称（Description）を引いて代入する
                        if FaultReason.Get(TempServiceLine."Fault Reason Code") then
                            FlatFaultReasonCode := FaultReason.Description
                        else
                            FlatFaultReasonCode := TempServiceLine."Fault Reason Code"; // 取れなければコード

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
                        // 通常行なので理由コードはクリア（RDLCで混ざるのを防ぐ）
                        FlatFaultReasonCode := '';
                    end;
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
                PaymentTerms: Record "Payment Terms";
                PaymentMethod: Record "Payment Method";
                FormatAddr: Codeunit "Format Address";
                SrvFormatAddr: Codeunit "Service Format Address";
            begin
                TotalAmt := 0;
                TotalGrossAmt := 0;

                txtDate := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');
                if CompanyInfo.Get() then CompanyInfo.CalcFields(Picture);

                // 1. Customer情報の取得
                Clear(NameTitle);
                Clear(ContactTitle);
                if Cust.Get(Header."Customer No.") then begin
                    NameTitle := Cust.NameTitle;
                    ContactTitle := Cust.ContactTitle;
                end;

                // 2. 住所配列を生成
                SrvFormatAddr.ServiceOrderSellto(CustAddr, Header);

                // 3. 担当者名の取得と加工
                ContactName := '';
                if Header."Contact Name" <> '' then begin
                    // 担当者名 + ContactTitle
                    ContactName := Header."Contact Name";
                    if ContactTitle <> '' then
                        ContactName := ContactName + ' ' + ContactTitle;

                    CleanUpContactInAddress(CustAddr, Header."Contact Name");
                end;

                // 4. 客先名（CustAddr[1]）に NameTitle を付与
                if (CustAddr[1] <> '') and (NameTitle <> '') then begin
                    if StrPos(CustAddr[1], NameTitle) = 0 then
                        CustAddr[1] := CustAddr[1] + ' ' + NameTitle;
                end;

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
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowQtyField; ShowQty)
                    {
                        ApplicationArea = Service;
                        Caption = 'Amounts Based on';
                        OptionCaption = 'Quantity,Quantity Invoiced';
                    }
                    field(SummarizeLinesField; SummarizeLines)
                    {
                        ApplicationArea = All;
                        Caption = 'Line Combine';
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
        FlatLineDescription: Text[100];
        FlatFaultReasonCode: Code[20];
        FlatLineDiscountAmt: Decimal;
        CustAddr, CompanyAddr : array[8] of Text[100];
        PaymentTermsDesc, PaymentMethodDesc : Text[100];
        ContactName: Text[150];
        Cust: Record Customer;
        NameTitle: Text[30];
        ContactTitle: Text[30];

    local procedure CalculateAmounts(var RecLine: Record "Service Line")
    begin
        // オプションの値に関わらず、常に明細の数量・金額を使用する
        Qty := RecLine.Quantity;
        Amt := RecLine."Line Amount";
        GrossAmt := RecLine."Amount Including VAT";
    end;

    local procedure SummarizeServiceLines()
    var
        ServiceLineRec: Record "Service Line";
        Res: Record Resource;
        ResGrp: Record "Resource Group";
        FaultReasonCodeMst: Record "Fault Reason Code";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        TempSortBuffer: Record "Service Line" temporary;
        NextLineNo: Integer;
        CurrentResGrp: Code[20];
        TargetResGrp: Code[20];
        FaultReasonName: Text[50];
        boolFound: Boolean; // ★追加
        LineBaseAmount: Decimal; // 値引前の行金額用
        Text50020: Label '%1（値引）', Comment = '%1 = Fault Reason Description';
        TempLineNo: Integer; // ★追加：一時的な行番号用
        PreResGrp: Code[20];
    begin
        // 初期化
        TempServiceLine.Reset();
        TempServiceLine.DeleteAll();
        TempLineNo := -1; // ★マイナスから始める（既存のLine No.と被らないように）
        TotalAmt := 0;
        TotalGrossAmt := 0;
        ServiceMgtSetup.Get();

        ServiceLineRec.SetRange("Document Type", Header."Document Type");
        ServiceLineRec.SetRange("Document No.", Header."No.");
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

        // When both "02 SERVICE" and "03 OUTSOURCE-L" line items are included
        PreResGrp := '';
        ServiceLineRec.Reset();
        ServiceLineRec.SetRange("Document Type", Header."Document Type"); // link by Document Type
        ServiceLineRec.SetRange("Document No.", Header."No."); // link by Document No.
        if ServiceLineRec.FindSet() then
            repeat
                // DEV NOTE:
                // Use actual posted values from Service Line.
                Amt := ServiceLineRec.Amount;
                GrossAmt := ServiceLineRec."Amount Including VAT";

                LineBaseAmount := Amt;
                if LineBaseAmount = 0 then
                    continue;

                // Resource group logic
                CurrentResGrp := '';

                if ServiceLineRec.Type = ServiceLineRec.Type::Resource then begin
                    if Res.Get(ServiceLineRec."No.") then begin
                        CurrentResGrp := Res."Resource Group No.";

                        if (ServiceMgtSetup."Resource Group Filter" <> '') and
                           (StrPos(ServiceMgtSetup."Resource Group Filter", CurrentResGrp) > 0) then begin
                            // Compare with the Previous value
                            if (PreResGrp <> '') and (CurrentResGrp <> PreResGrp) then begin

                                TempServiceLine.Reset();
                                TempServiceLine.SetRange("Resource Group No.", ServiceMgtSetup."Resource Group for Sort");
                                if TempServiceLine.FindFirst() then begin
                                    TempServiceLine."Unit of Measure Code" := 'SET';
                                    TempServiceLine.Quantity := 1;
                                    TempServiceLine.Modify();
                                end;
                            end;
                            PreResGrp := CurrentResGrp;
                        end;
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
        TempServiceLine.SetCurrentKey("Resource Group No.");
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

    local procedure CleanUpContactInAddress(var AddrArray: array[8] of Text[100]; ContactName: Text)
    var
        i: Integer;
        j: Integer;
        TempArray: array[8] of Text[100];
    begin
        // 1. 一時配列をクリア
        Clear(TempArray);
        j := 1;

        // 2. 該当しない行だけを抽出して TempArray に詰める
        for i := 1 to 8 do begin
            if (AddrArray[i] <> '') and (AddrArray[i] <> ContactName) then begin
                TempArray[j] := AddrArray[i];
                j += 1;
            end;
        end;

        // 3. 【修正ポイント】1要素ずつ元の配列に書き戻す
        for i := 1 to 8 do begin
            AddrArray[i] := TempArray[i];
        end;
    end;
}