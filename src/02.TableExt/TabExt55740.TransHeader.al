tableextension 55740 "Trans Header Ext" extends "Transfer Header"
{
    fields
    {
        field(90005; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = ToBeClassified;
        }
        field(90006; "Parts Trans. Archived Ver. No."; Integer)
        {
            Caption = 'Parts Trans. Archived Ver. No.';
            DataClassification = ToBeClassified;
        }
    }
    procedure GetPartsTransArchVerNo(): Integer
    var
        TempTransShptHeader: Record "Transfer Shipment Header";
        VersionNo: Integer;
    begin
        if "Service Order No." <> '' then begin
            TempTransShptHeader.Reset();
            TempTransShptHeader.SetRange("Service Order No.", "Service Order No.");
            IF TempTransShptHeader.FindSet() then
                repeat
                    if TempTransShptHeader."Parts Trans. Archived Ver. No." > VersionNo then
                        VersionNo := TempTransShptHeader."Parts Trans. Archived Ver. No.";
                until TempTransShptHeader.Next() = 0;
            exit(VersionNo + 1);
        end;
        exit(1);
    end;
}