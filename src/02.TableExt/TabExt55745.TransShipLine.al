tableextension 55745 "Trans Ship Line Ext" extends "Transfer Shipment Line"
{
    fields
    {
        field(50000; "Auto Service Order No."; Code[20])
        {
            Caption = 'Auto Service Order No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Transfer Shipment Header"."Service Order No." where("No." = field("Document No.")));
        }
        field(50001; "Manual Service Order No."; Code[20])
        {
            Caption = 'Manual Service Order No.';
        }
        field(50002; Comment; Text[250])
        {
            Caption = 'Comment';
        }
    }
}

