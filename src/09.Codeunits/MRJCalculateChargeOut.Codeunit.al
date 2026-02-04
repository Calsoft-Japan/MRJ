codeunit 50000 "Calculate Charge Out"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostGLAccOnBeforeInsertGLEntry', '', true, true)]
    procedure OnPostGLAccOnBeforeInsertGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry");
    var
        ServLedgerEntry: Record "Service Ledger Entry";
        ResLedgerEntry: Record "Res. Ledger Entry";
    begin
        case GenJournalLine."Source Ledger Entry Type" of
            1:
                begin
                    ServLedgerEntry.Get(GenJournalLine."Source Ledger Entry No.");
                    ServLedgerEntry."Charge Out Posted to G/L" := true;
                    IF ServLedgerEntry."G/L Entry No." = 0 then
                        ServLedgerEntry."G/L Entry No." := GLEntry."Entry No.";
                    ServLedgerEntry.Modify(false);
                end;
            2:
                begin
                    ResLedgerEntry.Get(GenJournalLine."Source Ledger Entry No.");
                    ResLedgerEntry."Charge Out Posted to G/L" := true;
                    if ResLedgerEntry."G/L Entry No." = 0 then
                        ResLedgerEntry."G/L Entry No." := GLEntry."Entry No.";
                    ResLedgerEntry.Modify(false);
                end;
            else begin
            end;
        end;
    end;
}