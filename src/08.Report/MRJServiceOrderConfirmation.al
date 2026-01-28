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

            column(No_; "No.") { }
            column(Customer_No_; "Customer No.") { }
            column(txtDate; txtDate) { }
            column(PaymentTermText; PaymentTermText) { }
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(SummarizeLines; SummarizeLines) { } // RDLC側の表示制御用

            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(CopyText; CopyText) { }

                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    dataitem(ServiceItemLine; "Service Item Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                        DataItemLinkReference = Header;

                        column(Line_Description; Description) { }

                        // 通常明細 (纏めOFFの時に使用)
                        dataitem(ServiceLine; "Service Line")
                        {
                            DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), "Service Item Line No." = field("Line No.");
                            DataItemLinkReference = ServiceItemLine;
                            DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                            column(LineNo_ServLine; "Line No.") { }
                            column(Description_ServLine; Description) { }
                            column(Quantity_ServLine; Quantity) { }
                            column(UnitPrice_ServLine; "Unit Price") { }
                            column(Amt; "Line Amount") { }

                            trigger OnPreDataItem()
                            begin
                                if SummarizeLines then CurrReport.Break();
                            end;
                        }
                    }

                    // ★集約明細 (纏めONの時に使用)
                    dataitem(SummarizedLine; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(FlatLineNo_ServLine; Number) { }
                        column(FlatLineDescription; FlatDescription) { }
                        column(FlatLineQuantity; FlatQty) { }
                        column(FlatLineUOM; FlatUOM) { }
                        column(FlatUnitPrice; FlatPrice) { }
                        column(FlatLineAmount; FlatAmount) { }

                        trigger OnPreDataItem()
                        begin
                            if not SummarizeLines then
                                CurrReport.Break();

                            SummarizeServiceLines(); // 集約処理呼び出し
                            SetRange(Number, 1, TempServiceLine.Count());
                            if TempServiceLine.FindSet() then;
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            FlatDescription := TempServiceLine.Description;
                            FlatQty := TempServiceLine.Quantity;
                            FlatUOM := TempServiceLine."Unit of Measure Code";
                            FlatPrice := TempServiceLine."Unit Price";
                            FlatAmount := TempServiceLine."Line Amount";

                            if TempServiceLine.Next() = 0 then;
                        end;
                    }

                    dataitem(ServiceCommentLine; "Service Comment Line")
                    {
                        DataItemTableView = where("Table Name" = const("Service Header"));
                        DataItemLink = "No." = field("No.");
                        DataItemLinkReference = Header;

                        column(CommentText; Comment) { }
                    }
                }

                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    SetRange(Number, 1, NoOfLoops);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                txtDate := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');
                // 住所や会社情報の取得ロジックをここに追記
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);
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
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = '部数';
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
        PaymentTermText: Text[100];
        CopyText: Text[50];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        SummarizeLines: Boolean;
        // フラット化用変数
        FlatDescription: Text;
        FlatQty: Decimal;
        FlatUOM: Code[10];
        FlatPrice: Decimal;
        FlatAmount: Decimal;
        Qty: Decimal; // 標準ロジック用
        Amt: Decimal; // 標準ロジック用
        GrossAmt: Decimal; // 標準ロジック用
        TotalAmt: Decimal;
        TotalGrossAmt: Decimal;
        ShowQty: Option Quantity,"Invoiced Quantity"; // RequestPage用

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
        TempServiceLine.Reset();
        TempServiceLine.DeleteAll();
        ServiceMgtSetup.Get();

        ServiceLineRec.SetRange("Document Type", Header."Document Type");
        ServiceLineRec.SetRange("Document No.", Header."No.");

        if ServiceLineRec.FindSet() then
            repeat
                // --- ★ここから標準ロジックの移植 ---
                Clear(Qty);
                Clear(Amt);
                Clear(GrossAmt);

                if ShowQty = ShowQty::Quantity then begin
                    Qty := ServiceLineRec.Quantity;
                    Amt := ServiceLineRec."Line Amount";
                    GrossAmt := ServiceLineRec."Amount Including VAT";
                end else begin
                    if ServiceLineRec."Quantity Invoiced" = 0 then
                        continue; // 標準の CurrReport.Skip() に相当
                    Qty := ServiceLineRec."Quantity Invoiced";

                    // 金額計算
                    Amt := Round((Qty * ServiceLineRec."Unit Price") * (1 - ServiceLineRec."Line Discount %" / 100));
                    GrossAmt := (1 + ServiceLineRec."VAT %" / 100) * Amt;
                end;

                TotalAmt += Amt;
                TotalGrossAmt += GrossAmt;
                // --- ★ここまで ---

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

                // 名寄せ判定
                if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (TargetResGrp <> '') then begin
                    TempServiceLine.Reset();
                    TempServiceLine.SetRange(Type, TempServiceLine.Type::Resource);
                    TempServiceLine.SetRange("Resource Group No.", TargetResGrp);
                    if TempServiceLine.FindFirst() then begin
                        // 標準ロジックで計算された Qty と Amt を集計
                        TempServiceLine.Quantity += Qty;
                        TempServiceLine."Line Amount" += Amt;
                        TempServiceLine."Amount Including VAT" += GrossAmt;
                        TempServiceLine.Modify();
                        continue;
                    end;
                end;

                // 新規行作成
                TempServiceLine.Reset();
                TempServiceLine.Init();
                TempServiceLine.TransferFields(ServiceLineRec);

                // 集約後の値を一時テーブルにセット
                TempServiceLine.Quantity := Qty;
                TempServiceLine."Line Amount" := Amt;
                TempServiceLine."Amount Including VAT" := GrossAmt;

                TempServiceLine."Resource Group No." := TargetResGrp;
                if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and (TargetResGrp <> '') then begin
                    if ResGrp.Get(TargetResGrp) then
                        TempServiceLine.Description := ResGrp.Name;
                end;
                TempServiceLine.Insert();
            until ServiceLineRec.Next() = 0;
    end;

    local procedure InsertIntoBuffer(var FromRec: Record "Service Line"; var ToBuffer: Record "Service Line"; var NextNo: Integer)
    begin
        ToBuffer.Init();
        ToBuffer.TransferFields(FromRec);
        ToBuffer."Line No." := NextNo;
        NextNo += 10000;
        ToBuffer.Insert();
    end;
}