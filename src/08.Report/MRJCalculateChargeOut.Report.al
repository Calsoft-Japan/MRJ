report 50030 "Calculate Charge Outs"
{
    Caption = 'Calculate Charge Outs';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Resource Group"; "Resource Group")
        {
            DataItemTableView = sorting("No.") order(Ascending);

            dataitem(Resource; Resource)
            {
                DataItemLink = "Resource Group No." = field("No.");
                DataItemTableView = sorting("No.") order(Ascending);
                dataitem("Service Ledger Entry"; "Service Ledger Entry")
                {
                    DataItemLink = "No." = field("No.");
                    DataItemTableView = sorting("Charge Out Posted to G/L", "Document Type", "Posting Date", Type, "No.") order(Ascending)
                                        where("Document Type" = filter(Invoice .. "Credit Memo"), Type = filter(Resource));
                    trigger OnPreDataItem() //ServLedEntry
                    begin
                        "Service Ledger Entry".SetRange("Service Ledger Entry"."Posting Date", DateFrom, DateTo);

                        intProgress2 := 0;
                        ProgressDialog.Open(ServReadLbl + '\' + '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\', intProgress);
                        ProgressTotal := "Service Ledger Entry".Count;
                    end;

                    trigger OnAfterGetRecord() //ServLedEntry
                    begin
                        if "Service Ledger Entry"."Charge Out Posted to G/L" then
                            CurrReport.Skip();

                        NextLineNo += 10;

                        GeneralPostingSetup.Get("Service Ledger Entry"."Gen. Bus. Posting Group",
                                                "Service Ledger Entry"."Gen. Prod. Posting Group");

                        if PostingDate <> 0D then
                            TmpDate := PostingDate
                        else
                            TmpDate := "Service Ledger Entry"."Posting Date";

                        GenJnlLine2.Reset();
                        GenJnlLine2.SetRange("Source Ledger Entry Type", GenJnlLine2."Source Ledger Entry Type"::"Service Ledger");
                        GenJnlLine2.SetRange("Source Ledger Entry No.", "Service Ledger Entry"."Entry No.");
                        if GenJnlLine2.FindSet() then begin
                            Error(ServEntryErr, GenJnlLine2."Journal Template Name", GenJnlLine2."Journal Batch Name",
                                  GenJnlLine2."Line No.", "Service Ledger Entry"."Entry No.");
                        end;

                        GenJnlLine.Init();
                        GenJnlLine."Journal Template Name" := JnlTemplateName;
                        GenJnlLine."Journal Batch Name" := JnlBatchName;
                        GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
                        GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                        GenJnlLine."Line No." := nextLineNo;
                        GenJnlLine.Insert();
                        GenJnlLine.Validate("Posting Date", TmpDate);
                        GenJnlLine.Validate("Document Date", TmpDate);
                        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::" ");
                        GenJnlLine.Validate("Document No.", JnlDocumentNo);
                        GenJnlLine.Validate("External Document No.", "Service Ledger Entry"."Document No.");
                        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        GenJnlLine.Validate("Account No.", GeneralPostingSetup."COGS Account");
                        GenJnlLine.Validate(Description, CopyStr(("Service Ledger Entry"."Document No." + ' ' + "Service Ledger Entry".Description), 1, 50));
                        GenJnlLine."Currency Code" := '';
                        GenJnlLine."Gen. Bus. Posting Group" := '';
                        GenJnlLine."Gen. Prod. Posting Group" := '';
                        if IgnoreVATSetup then begin
                            GenJnlLine.Validate("Gen. Posting Type", GenJnlLine."Gen. Posting Type"::" ");
                            GenJnlLine.Validate("VAT Bus. Posting Group", '');
                            GenJnlLine.Validate("VAT Prod. Posting Group", '');
                        end;
                        GenJnlLine.Validate(Amount, -"Service Ledger Entry"."Cost Amount");
                        GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                        GenJnlLine.Validate("Bal. Account No.", ResourcesSetup."Charge Out Credit Account");
                        GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
                        GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
                        if IgnoreVATSetup then begin
                            GenJnlLine.Validate("Bal. Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
                            GenJnlLine.Validate("Bal. VAT Bus. Posting Group", '');
                            GenJnlLine.Validate("Bal. VAT Prod. Posting Group", '');
                        end;
                        GenJnlLine.Validate("Shortcut Dimension 1 Code", "Service Ledger Entry"."Global Dimension 1 Code");
                        GenJnlLine.Validate("Shortcut Dimension 2 Code", "Service Ledger Entry"."Global Dimension 2 Code");
                        GenJnlLine."Dimension Set ID" := "Service Ledger Entry"."Dimension Set ID";
                        GenJnlLine."Source Ledger Entry Type" := GenJnlLine."Source Ledger Entry Type"::"Service Ledger";
                        GenJnlLine."Source Ledger Entry No." := "Service Ledger Entry"."Entry No.";
                        GenJnlLine.Modify();

                        intProgress2 := intProgress2 + 1;
                        intProgress := Round(intProgress2 / ProgressTotal * 10000, 1);
                        ProgressDialog.Update();

                        TempService.TransferFields("Service Ledger Entry");
                        TempService.Insert();
                    end;

                    trigger OnPostDataItem() //ServLedEntry
                    begin
                        ProgressDialog.Close();
                    end;
                }
                dataitem("Res. Ledger Entry"; "Res. Ledger Entry")
                {
                    DataItemTableView = sorting("Charge Out Posted to G/L", "Source No.", "Source Type", "Entry Type", "Posting Date") order(Ascending) where("Entry Type" = filter(Sale));
                    DataItemLink = "Resource No." = field("No.");
                    trigger OnPreDataItem() //ResLedEntry
                    begin
                        "Res. Ledger Entry".SetRange("Res. Ledger Entry"."Source Code", 'SALES');
                        "Res. Ledger Entry".SetRange("Res. Ledger Entry"."Posting Date", DateFrom, DateTo);

                        intProgress2 := 0;
                        ProgressDialog.Open(ResReadLbl + '\' + '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\', intProgress);
                        ProgressTotal := "Res. Ledger Entry".Count;
                    end;

                    trigger OnAfterGetRecord() //ResLedEntry
                    begin
                        if "Res. Ledger Entry"."Charge Out Posted to G/L" then
                            CurrReport.Skip();

                        NextLineNo += 10;

                        GeneralPostingSetup.Get("Res. Ledger Entry"."Gen. Bus. Posting Group", "Res. Ledger Entry"."Gen. Prod. Posting Group");

                        if PostingDate <> 0D then
                            TmpDate := PostingDate
                        else
                            TmpDate := "Res. Ledger Entry"."Posting Date";

                        GenJnlLine2.Reset();
                        GenJnlLine2.SetRange("Source Ledger Entry Type", GenJnlLine2."Source Ledger Entry Type"::"Resource Ledger");
                        GenJnlLine2.SetRange("Source Ledger Entry No.", "Res. Ledger Entry"."Entry No.");
                        if GenJnlLine2.FindSet() then begin
                            Error(ResEntryErr, GenJnlLine2."Journal Template Name", GenJnlLine2."Journal Batch Name",
                                  GenJnlLine2."Line No.", "Res. Ledger Entry"."Entry No.");
                        end;

                        GenJnlLine.Init();
                        GenJnlLine."Journal Template Name" := JnlTemplateName;
                        GenJnlLine."Journal Batch Name" := JnlBatchName;
                        GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
                        GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                        GenJnlLine."Line No." := nextLineNo;
                        GenJnlLine.Insert();
                        GenJnlLine.Validate("Posting Date", TmpDate);
                        GenJnlLine.Validate("Document Date", TmpDate);
                        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::" ");
                        GenJnlLine.Validate("Document No.", JnlDocumentNo);
                        GenJnlLine.Validate("External Document No.", "Res. Ledger Entry"."Document No.");
                        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        GenJnlLine.Validate("Account No.", GeneralPostingSetup."COGS Account");
                        GenJnlLine.Validate(Description, CopyStr(("Res. Ledger Entry"."Document No." + ' ' + "Res. Ledger Entry".Description), 1, 50));
                        GenJnlLine."Currency Code" := '';
                        GenJnlLine."Gen. Bus. Posting Group" := '';
                        GenJnlLine."Gen. Prod. Posting Group" := '';
                        if IgnoreVATSetup then begin
                            GenJnlLine.Validate("Gen. Posting Type", GenJnlLine."Gen. Posting Type"::" ");
                            GenJnlLine.Validate("VAT Bus. Posting Group", '');
                            GenJnlLine.Validate("VAT Prod. Posting Group", '');
                        end;
                        GenJnlLine.Validate(Amount, -"Res. Ledger Entry"."Total Cost");
                        GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                        GenJnlLine.Validate("Bal. Account No.", ResourcesSetup."Charge Out Credit Account");
                        GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
                        GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
                        if IgnoreVATSetup then begin
                            GenJnlLine.Validate("Bal. Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
                            GenJnlLine.Validate("Bal. VAT Bus. Posting Group", '');
                            GenJnlLine.Validate("Bal. VAT Prod. Posting Group", '');
                        end;
                        GenJnlLine.Validate("Shortcut Dimension 1 Code", "Res. Ledger Entry"."Global Dimension 1 Code");
                        GenJnlLine.Validate("Shortcut Dimension 2 Code", "Res. Ledger Entry"."Global Dimension 2 Code");
                        GenJnlLine."Dimension Set ID" := "Res. Ledger Entry"."Dimension Set ID";
                        GenJnlLine."Source Ledger Entry Type" := GenJnlLine."Source Ledger Entry Type"::"Resource Ledger";
                        GenJnlLine."Source Ledger Entry No." := "Res. Ledger Entry"."Entry No.";
                        GenJnlLine.Modify();

                        intProgress2 := intProgress2 + 1;
                        intProgress := Round(intProgress2 / ProgressTotal * 10000, 1);
                        ProgressDialog.Update();

                        TempResourse.TransferFields("Res. Ledger Entry");
                        TempResourse.Insert();
                    end;

                    trigger OnPostDataItem() //ResLedEntry
                    begin
                        ProgressDialog.Close();
                    end;
                }
            }
            trigger OnPreDataItem()  //ResourceGroup
            begin
                GenJnlLine.Reset();
                GenJnlLine.SetRange("Journal Template Name", JnlTemplateName);
                GenJnlLine.SetRange("Journal Batch Name", JnlBatchName);

                if GenJnlLine.FindLast() then
                    NextLineNo := GenJnlLine."Line No."
                else
                    NextLineNo := 10;

                "Resource Group".SetFilter("No.", ResourcesSetup."Charge Out Res. Grp. Filter");
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
                    field(DateFrom; DateFrom)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                    }
                    field(DateTo; DateTo)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                    }
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                    }
                    field(JnlTemplateName; JnlTemplateName)
                    {
                        ApplicationArea = All;
                        Caption = 'Journal Template Name';
                        trigger OnValidate()
                        begin
                            if JnlTemplateName <> '' then begin
                                GenJnlTemplate.Get(JnlTemplateName);
                                if (JnlBatchName <> '') and
                                   not GenJnlBatch.Get(JnlTemplateName, JnlBatchName) then
                                    JnlBatchName := '';
                            end;
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RUNMODAL(Page::"General Journal Template List", GenJnlTemplate) = ACTION::LookupOK then begin
                                Text := GenJnlTemplate.Name;
                                EXIT(TRUE);
                            end;
                            EXIT(FALSE);
                        end;
                    }
                    field(JnlBatchName; JnlBatchName)
                    {
                        ApplicationArea = All;
                        Caption = 'Journal Batch Name';
                        trigger OnValidate()
                        begin
                            GenJnlBatch.Get(JnlTemplateName, JnlBatchName);
                            if GenJnlBatch."No. Series" <> '' then
                                JnlDocumentNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WorkDate(), true);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            CLEAR(GenJnlBatchList);
                            GenJnlBatch.SetRange("Journal Template Name", JnlTemplateName);
                            GenJnlBatch.SetRange("Template Type", GenJnlTemplate.Type);
                            GenJnlBatchList.SETTABLEVIEW(GenJnlBatch);
                            GenJnlBatchList.LOOKUPMODE := TRUE;
                            if GenJnlBatchList.RUNMODAL = ACTION::LookupOK then begin
                                GenJnlBatchList.GETRECORD(GenJnlBatch);
                                Text := GenJnlBatch.Name;
                                EXIT(TRUE);
                            end;
                            EXIT(FALSE);
                        end;
                    }
                    field(JnlDocumentNo; JnlDocumentNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Document No.';
                    }
                    field(IgnoreVATSetup; IgnoreVATSetup)
                    {
                        ApplicationArea = All;
                        Caption = 'Ignore VAT Setup';
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            IgnoreVATSetup := TRUE;
            DateFrom := CALCDATE('-1M-CM', TODAY);
            DateTo := CALCDATE('-1M+CM', TODAY);
            PostingDate := CALCDATE('-1M+CM', TODAY);
        end;
    }
    trigger OnPreReport() //Report Trigger
    begin
        ResourcesSetup.Get();
        ResourcesSetup.TestField(ResourcesSetup."Charge Out Res. Grp. Filter");
        ResourcesSetup.TestField(ResourcesSetup."Charge Out Credit Account");

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JnlTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JnlBatchName);
        GenJnlLine.SetFilter("Source Ledger Entry Type", '%1|%2',
                             GenJnlLine."Source Ledger Entry Type"::"Service Ledger",
                             GenJnlLine."Source Ledger Entry Type"::"Resource Ledger");
        GenJnlLine.DeleteAll();
        GenJnlLine.Reset();
    end;

    local procedure CreateGenJnlFromServiceEntry()
    var
        TmpDate: Date;
    begin
        NextLineNo += 10;

        GeneralPostingSetup.Get("Service Ledger Entry"."Gen. Bus. Posting Group", "Service Ledger Entry"."Gen. Prod. Posting Group");

        if PostingDate <> 0D then
            TmpDate := PostingDate
        else
            TmpDate := "Service Ledger Entry"."Posting Date";

        GenJnlLine.Init();
        GenJnlLine.Validate("Journal Template Name", JnlTemplateName);
        GenJnlLine.Validate("Journal Batch Name", JnlBatchName);
        GenJnlLine.Validate("Line No.", NextLineNo);
        GenJnlLine.Insert(true);

        GenJnlLine.Validate("Posting Date", TmpDate);
        GenJnlLine.Validate("Document No.", JnlDocumentNo);
        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.Validate("Account No.", GeneralPostingSetup."COGS Account");
        GenJnlLine.Validate(Amount, -"Service Ledger Entry"."Cost Amount");
        GenJnlLine.Validate("Bal. Account No.", ResourcesSetup."Charge Out Credit Account");

        GenJnlLine."Source Ledger Entry Type" := GenJnlLine."Source Ledger Entry Type"::"Service Ledger";
        GenJnlLine."Source Ledger Entry No." := "Service Ledger Entry"."Entry No.";
        GenJnlLine.Modify(true);

        ProgressIndex += 1;
        ProgressValue := Round(ProgressIndex / ProgressTotal * 10000, 1);
        ProgressDialog.Update();
    end;

    var
        ResourcesSetup: Record "Resources Setup";
        GenJnlTemplate: Record "Gen. Journal Template";

        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        TempService: Record "Service Ledger Entry" temporary;
        TempResourse: Record "Res. Ledger Entry" temporary;
        GeneralPostingSetup: Record "General Posting Setup";
        GenJnlBatchList: Page "General Journal Batches";
        NoSeriesMgt: Codeunit "No. Series";
        JnlTemplateName: Code[10];
        JnlBatchName: Code[10];
        JnlDocumentNo: Code[20];
        DateFrom: Date;
        DateTo: Date;
        PostingDate: Date;
        IgnoreVATSetup: Boolean;
        TmpDate: Date;
        NextLineNo: Integer;
        intProgress: Integer;
        intProgress2: Integer;
        ProgressDialog: Dialog;
        ProgressValue: Integer;
        ProgressIndex: Integer;
        ProgressTotal: Integer;
        ServReadLbl: Label 'Reading Service Ledger Entries ...';
        ResReadLbl: Label 'Reading Service Ledger Entries ...';
        ServEntryErr: Label 'Gen. Journal Line has been created by Service Ledger Entry %4  in the Templete %1 , Batch %2, Line No. %3.';
        ResEntryErr: Label 'Gen. Journal Line has been created by Res. Ledger Entry %4  in the Templete %1 , Batch %2, Line No. %3.';
}
