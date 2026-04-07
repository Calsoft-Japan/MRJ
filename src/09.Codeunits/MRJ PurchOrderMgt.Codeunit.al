codeunit 50003 "MRJ Purch. Order Mgt."
{
    procedure SetPOPIDocDim(var PurchHeader: Record "Purchase Header")
    var
        ServMgtSetup: Record "Service Mgt. Setup";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        DimCode: Code[20];
        DimValueCode: Code[20];
        iLoop: Integer;
    begin
        if (PurchHeader."Document Type" <> PurchHeader."Document Type"::Order) and
           (PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice) and
           (PurchHeader."Document Type" <> PurchHeader."Document Type"::"Credit Memo") then
            exit;

        if PurchHeader."No." = '' then
            exit;

        ServMgtSetup.Get();
        if not ServMgtSetup."Enable Dimension Link" then
            exit;

        ServMgtSetup.TestField("Sales Order Dim Code");
        ServMgtSetup.TestField("Service Order Dim Code");
        ServMgtSetup.TestField("Service Order Type Dim Code");
        ServMgtSetup.TestField("Cost Center Dim Code");

        // Load existing Dimension Set into temp
        DimMgt.GetDimensionSet(TempDimSetEntry, PurchHeader."Dimension Set ID");

        for iLoop := 1 to 5 do begin
            case iLoop of
                1:
                    begin
                        DimCode := ServMgtSetup."Sales Order Dim Code";
                        DimValueCode := PurchHeader."Sales Order Dim Code";
                    end;
                2:
                    begin
                        DimCode := ServMgtSetup."Service Order Dim Code";
                        DimValueCode := PurchHeader."Service Order Dim Code";
                    end;
                3:
                    begin
                        DimCode := ServMgtSetup."Service Order Type Dim Code";
                        DimValueCode := PurchHeader."Service Order Type Dim Code";
                    end;
                4:
                    begin
                        DimCode := ServMgtSetup."Cost Center Dim Code";
                        DimValueCode := PurchHeader."Cost Center Dim Code";
                    end;
                5:
                    begin
                        DimCode := ServMgtSetup."Proserv Dim Code";
                        DimValueCode := PurchHeader."Proserv Dim Code";
                    end;
            end;

            if DimValueCode <> '' then begin
                // Remove existing dimension (if exists)
                TempDimSetEntry.SetRange("Dimension Code", DimCode);
                if TempDimSetEntry.FindFirst() then
                    TempDimSetEntry.DeleteAll();

                TempDimSetEntry.Reset();

                // Add new dimension value
                TempDimSetEntry.Init();
                TempDimSetEntry."Dimension Code" := DimCode;
                TempDimSetEntry."Dimension Value Code" := DimValueCode;
                TempDimSetEntry.Insert();
            end;
        end;

        // Create new Dimension Set ID
        PurchHeader."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;
}