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
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(SummarizeLines; SummarizeLines) { }
            column(TotalAmt; TotalAmt) { }
            column(TotalGrossAmt; TotalGrossAmt) { }

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

                        // 1. 通常明細 (纏めOFFの時に使用)
                        dataitem(ServiceLine; "Service Line")
                        {
                            DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), "Service Item Line No." = field("Line No.");
                            DataItemLinkReference = ServiceItemLine;
                            DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                            column(LineNo_ServLine; "Line No.") { }
                            column(Description_ServLine; Description) { }
                            column(Quantity_ServLine; Qty) { } // 計算後のQtyを出力
                            column(UnitPrice_ServLine; "Unit Price") { }
                            column(Amt; Amt) { } // 計算後のAmtを出力

                            trigger OnPreDataItem()
                            begin
                                if SummarizeLines then CurrReport.Break();
                            end;

                            trigger OnAfterGetRecord()
                            begin
                                // 標準ロジックによる計算
                                CalculateAmounts(ServiceLine);
                                if (ShowQty = ShowQty::"Quantity Invoiced") and (Qty = 0) then
                                    CurrReport.Skip();
                            end;
                        }
                    }

                    // 2. 集約明細 (纏めONの時に使用)
                    dataitem(SummarizedLine; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(FlatLineDescription; FlatDescription) { }
                        column(FlatLineQuantity; FlatQty) { }
                        column(FlatLineAmount; FlatAmount) { }

                        trigger OnPreDataItem()
                        begin
                            if not SummarizeLines then CurrReport.Break();

                            SummarizeServiceLines();
                            SetRange(Number, 1, TempServiceLine.Count());
                            if TempServiceLine.FindSet() then;
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            FlatDescription := TempServiceLine.Description;
                            FlatQty := TempServiceLine.Quantity;
                            FlatAmount := TempServiceLine."Line Amount";
                            if TempServiceLine.Next() = 0 then;
                        end;
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
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);

                // 各注文（Header）ごとに合計金額をリセットして事前計算
                TotalAmt := 0;
                TotalGrossAmt := 0;
                if SummarizeLines then
                    SummarizeServiceLines() // 纏め時はこの中でTotalを計算
                else begin
                    // 非纏め時は全行スキャンしてTotalを計算
                    PreCalculateTotals();
                end;
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
                    field(ShowQty; ShowQty)
                    {
                        ApplicationArea = Service;
                        Caption = '金額の基準';
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
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[50];
        SummarizeLines: Boolean;
        ShowQty: Option Quantity,"Quantity Invoiced";
        Qty, Amt, GrossAmt, TotalAmt, TotalGrossAmt : Decimal;
        FlatDescription: Text;
        FlatQty, FlatAmount : Decimal;

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

    local procedure SummarizeServiceLines()
    var
        ServiceLineRec: Record "Service Line";
        Res: Record Resource;
        ResGrp: Record "Resource Group";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        TargetResGrp: Code[20];
    begin
        TempServiceLine.Reset();
        TempServiceLine.DeleteAll();
        ServiceMgtSetup.Get();
        TotalAmt := 0; // 重複を避けるため初期化
        TotalGrossAmt := 0;

        ServiceLineRec.SetRange("Document Type", Header."Document Type");
        ServiceLineRec.SetRange("Document No.", Header."No.");
        if ServiceLineRec.FindSet() then
            repeat
                CalculateAmounts(ServiceLineRec);
                if (ShowQty = ShowQty::"Quantity Invoiced") and (Qty = 0) then
                    continue;

                TotalAmt += Amt;
                TotalGrossAmt += GrossAmt;

                TargetResGrp := '';
                if (ServiceLineRec.Type = ServiceLineRec.Type::Resource) and Res.Get(ServiceLineRec."No.") then begin
                    TargetResGrp := Res."Resource Group No.";
                    if (ServiceMgtSetup."Resource Group Filter" <> '') and (StrPos(ServiceMgtSetup."Resource Group Filter", TargetResGrp) > 0) then
                        TargetResGrp := ServiceMgtSetup."Resource Group for Sort";
                end;

                TempServiceLine.Reset();
                TempServiceLine.SetRange(Type, ServiceLineRec.Type::Resource);
                TempServiceLine.SetRange("Resource Group No.", TargetResGrp);
                if (TargetResGrp <> '') and TempServiceLine.FindFirst() then begin
                    TempServiceLine.Quantity += Qty;
                    TempServiceLine."Line Amount" += Amt;
                    TempServiceLine.Modify();
                end else begin
                    TempServiceLine.Init();
                    TempServiceLine.TransferFields(ServiceLineRec);
                    TempServiceLine.Quantity := Qty;
                    TempServiceLine."Line Amount" := Amt;
                    TempServiceLine."Resource Group No." := TargetResGrp;
                    if (TargetResGrp <> '') and ResGrp.Get(TargetResGrp) then
                        TempServiceLine.Description := ResGrp.Name;
                    TempServiceLine.Insert();
                end;
            until ServiceLineRec.Next() = 0;
    end;
}