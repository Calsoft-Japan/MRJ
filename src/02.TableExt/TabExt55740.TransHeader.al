tableextension 55740 "Trans Header Ext" extends "Transfer Header"
{
    fields
    {
        field(90005; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            TableRelation = "Service Header"."No." where("Document Type" = const(Order));

            trigger OnValidate()
            begin
                if "Service Order No." <> xRec."Service Order No." then begin
                    if "Service Order No." <> '' then begin
                        "Parts Trans. Archived Ver. No." := GetPartsTransArchVerNo;
                        SetTransNoToServHerder("Service Order No.");
                    end else begin
                        "Parts Trans. Archived Ver. No." := 0;
                        DelTransNoFromServHeader(xRec."Service Order No.");
                    end;
                end;
            end;
        }
        field(90006; "Parts Trans. Archived Ver. No."; Integer)
        {
            Caption = 'Parts Trans. Archived Ver. No.';
            DataClassification = ToBeClassified;
        }
    }
    procedure SetTransNoToServHerder(ServOrderNo: Code[20])
    var
        ServHeader: Record "Service Header";
    begin
        ServHeader.Reset();
        ServHeader.SetRange("Document Type", ServHeader."Document Type"::Order);
        ServHeader.SetRange("No.", ServOrderNo);
        if ServHeader.FindFirst() then begin
            if ServHeader."Parts Receive TO No. Filter" <> '' then begin
                if StrPos(ServHeader."Parts Receive TO No. Filter", "No.") = 0 then begin
                    ServHeader."Parts Receive TO No. Filter" += ('|' + "No.");
                    ServHeader.Modify();
                end;
            end else begin
                ServHeader."Parts Receive TO No. Filter" := "No.";
                ServHeader.Modify();
            end;
        end;
    end;

    procedure DelTransNoFromServHeader(ServOrderNo: Code[20])
    var
        ServHeader: Record "Service Header";
    begin
        ServHeader.Reset();
        ServHeader.SetRange("Document Type", ServHeader."Document Type"::Order);
        ServHeader.SetRange("No.", ServOrderNo);
        if ServHeader.FindFirst() then begin
            if ServHeader."Parts Receive TO No. Filter" <> '' then begin
                if StrPos(ServHeader."Parts Receive TO No. Filter", "No.") <> 0 then begin
                    if StrLen(ServHeader."Parts Receive TO No. Filter") > StrLen("No.") THEN
                        ServHeader."Parts Receive TO No. Filter" :=
                          DelStr(ServHeader."Parts Receive TO No. Filter",
                          StrPos(ServHeader."Parts Receive TO No. Filter", "No.") - 1,
                          StrLen("No.") + 1)
                    else
                        ServHeader."Parts Receive TO No. Filter" := '';
                    ServHeader.Modify();
                end;
            end;
        end;
    end;

    procedure GetPartsTransArchVerNo(): Integer
    var
        TempTransShptHeader: Record "Transfer Shipment Header";
        VersionNo: Integer;
    begin
        if "Service Order No." <> '' then begin
            TempTransShptHeader.Reset();
            TempTransShptHeader.SetRange("Service Order No.", "Service Order No.");
            if TempTransShptHeader.FindSet() then
                repeat
                    if TempTransShptHeader."Parts Trans. Archived Ver. No." > VersionNo then
                        VersionNo := TempTransShptHeader."Parts Trans. Archived Ver. No.";
                until TempTransShptHeader.Next() = 0;
            exit(VersionNo + 1);
        end;
        exit(1);
    end;
}