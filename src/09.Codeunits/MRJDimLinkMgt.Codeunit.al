codeunit 50015 MRJDimLinkMgt
{
    [EventSubscriber(ObjectType::Table, Database::"Vendor", 'OnAfterInsertEvent', '', true, true)]
    procedure SetVendorDefDim(var Rec: Record Vendor);
    var
        PurchSetup: Record "Purchases & Payables Setup";
        DimensionValue: Record "Dimension Value";
        DefDimension: Record "Default Dimension";
    begin
        if Rec."No." = '' then
            exit;

        PurchSetup.Get();
        if not PurchSetup."Enable Vend. Dimension Link" then
            exit;

        PurchSetup.TestField("Vendor Dimension");

        DefDimension.Init();

        if not DimensionValue.Get(PurchSetup."Vendor Dimension", Rec."No.") then begin
            DimensionValue.Init();
            DimensionValue."Dimension Code" := PurchSetup."Vendor Dimension";
            DimensionValue.Code := Rec."No.";
            DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
            DimensionValue.Insert(true);
        end;

        if not DefDimension.Get(Database::Vendor, Rec."No.", DimensionValue.Code) then begin
            DefDimension.Init;
            DefDimension.Validate("Table ID", Database::Vendor);
            DefDimension."No." := Rec."No.";

            DefDimension."Dimension Code" := PurchSetup."Vendor Dimension";
            DefDimension."Dimension Value Code" := Rec."No.";
            DefDimension."Value Posting" := DefDimension."Value Posting"::"Same Code";
            DefDimension.Insert(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer", 'OnAfterInsertEvent', '', true, true)]
    procedure SetCustomerDefDim(var Rec: Record Customer);
    var
        SalesSetup: Record "Sales & Receivables Setup";
        DimensionValue: Record "Dimension Value";
        DefDimension: Record "Default Dimension";
    begin
        if Rec."No." = '' then
            exit;

        SalesSetup.Get();
        if not SalesSetup."Enable Cust. Dimension Link" then
            exit;

        SalesSetup.TestField("Customer Dimension");

        DefDimension.Init();

        if not DimensionValue.Get(SalesSetup."Customer Dimension", Rec."No.") then begin
            DimensionValue.Init();
            DimensionValue."Dimension Code" := SalesSetup."Customer Dimension";
            DimensionValue.Code := Rec."No.";
            DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
            DimensionValue.Insert(true);
        end;

        if not DefDimension.Get(Database::Vendor, Rec."No.", DimensionValue.Code) then begin
            DefDimension.Init;
            DefDimension.Validate("Table ID", Database::Vendor);
            DefDimension."No." := Rec."No.";

            DefDimension."Dimension Code" := SalesSetup."Customer Dimension";
            DefDimension."Dimension Value Code" := Rec."No.";
            DefDimension."Value Posting" := DefDimension."Value Posting"::"Same Code";
            DefDimension.Insert(true);
        end;
    end;
}