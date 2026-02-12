report 50083 "MRJ Transfer Shipment (JP)"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Transfer Shipment (JP)';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJTransferShipment.rdlc';

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";

            // ===== Header =====
            column(TransferShipmentNo; "No.") { }
            column(PostingDate; "Posting Date") { }
            column(ShipmentDate; "Shipment Date") { }
            column(InTransitCode; "In-Transit Code") { }
            column(ShippingAgentCode; "Shipping Agent Code") { }
            column(Shipment_Date; "Shipment Date") { }
            column(Receipt_Date; "Receipt Date") { }

            // ===== From / To (Location Name from variable) =====
            column(TransferFromLocName; TransferFromName) { }
            column(TransferToLocName; TransferToName) { }

            // ===== 摘要 (Inventory Comment Line) =====
            dataitem(InvComment; "Inventory Comment Line")
            {
                DataItemLinkReference = "Transfer Shipment Header";
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("No.", "Line No.");

                column(CommentDate; Date) { }
                column(CommentText; Comment) { }
            }

            // ===== Lines =====
            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLinkReference = "Transfer Shipment Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(ItemNo; "Item No.") { }
                column(LineDescription; Description) { }
                column(LineQuantity; Quantity) { }
                column(LineUOM; "Unit of Measure Code") { }
            }

            trigger OnAfterGetRecord()
            var
                FromLoc: Record Location;
                ToLoc: Record Location;
            begin
                TransferFromName := '';
                TransferToName := '';

                if ("Transfer-from Code" <> '') and FromLoc.Get("Transfer-from Code") then
                    TransferFromName := FromLoc.Name;

                if ("Transfer-to Code" <> '') and ToLoc.Get("Transfer-to Code") then
                    TransferToName := ToLoc.Name;
            end;
        }
    }

    trigger OnPreReport()
    begin
        ReportTitle := '移動納品書';
    end;

    var
        TransferFromName: Text[100];
        TransferToName: Text[100];
        ReportTitle: Text[30];
}
