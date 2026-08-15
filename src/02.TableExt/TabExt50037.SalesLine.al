tableextension 50037 "Sales Line Ext" extends "Sales Line"
{
    trigger OnAfterInsert()
    var
        GPPG: Record "Gen. Product Posting Group";
    begin

        IF GPPG.GET("Gen. Prod. Posting Group") THEN BEGIN
            UpdateDimension(Rec, GPPG."Dimension Code", GPPG."Dimension Value Code");
        END;
    end;

    /// <summary>
    /// Adds or updates a specific dimension code and value on a Sales Line record.
    /// </summary>
    procedure UpdateDimension(var SalesLine: Record "Sales Line"; DimCode: Code[20]; DimValueCode: Code[20])
    var
        DimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionManagement: Codeunit DimensionManagement;
        NewDimSetID: Integer;
    begin
        if (DimCode = '') or (DimValueCode = '') then
            exit;

        // Extract all existing dimension entries from the Sales Line into a temporary table
        DimensionManagement.GetDimensionSet(DimensionSetEntry, SalesLine."Dimension Set ID");

        // Prepare the new or updated dimension record
        DimensionSetEntry.Reset();
        DimensionSetEntry.SetRange("Dimension Code", DimCode);

        if DimensionSetEntry.FindFirst() then begin
            // Update the value if the dimension already exists on the line
            DimensionSetEntry.Validate("Dimension Value Code", DimValueCode);
            DimensionSetEntry.Modify(true);
        end else begin
            // Insert a new dimension entry if it does not exist
            DimensionSetEntry.Init();
            DimensionSetEntry.Validate("Dimension Set ID", SalesLine."Dimension Set ID");
            DimensionSetEntry.Validate("Dimension Code", DimCode);
            DimensionSetEntry.Validate("Dimension Value Code", DimValueCode);
            DimensionSetEntry.Insert(true);
        end;

        // Clear the filter to get the ID for the full collection of entries
        DimensionSetEntry.Reset();
        NewDimSetID := DimensionManagement.GetDimensionSetID(DimensionSetEntry);

        // Update the Sales Line if the Dimension Set ID has changed
        if SalesLine."Dimension Set ID" <> NewDimSetID then begin
            SalesLine.Validate("Dimension Set ID", NewDimSetID);

            // Sync global/shortcut dimension fields on the record layout
            DimensionManagement.UpdateGlobalDimFromDimSetID(
                SalesLine."Dimension Set ID",
                SalesLine."Shortcut Dimension 1 Code",
                SalesLine."Shortcut Dimension 2 Code"
            );

            SalesLine.Modify(true);
        end;
    end;
}

