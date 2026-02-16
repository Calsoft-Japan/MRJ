page 50000 "Sales Inquiry"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Sales Inquiry';
    SourceTable = 50000;
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field(CustomerFilter; CustomerFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Filter';
                }
                field(ItemFilter; ItemFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Item Filter';
                }
                field(PostingDateFilter; PostingDateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date Filter';
                    trigger OnValidate()
                    var
                        SalesInq: Record 50000;
                    begin
                        SalesInq.SetFilter("Posting Date", PostingDateFilter);
                        PostingDateFilter := SalesInq.GetFilter("Posting Date");
                    end;
                }
                field(OrderDateFilter; OrderDateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Order Date Filter';
                    trigger OnValidate()
                    var
                        SalesInq: Record 50000;
                    begin
                        SalesInq.SetFilter("Order Date", OrderDateFilter);
                        OrderDateFilter := SalesInq.GetFilter("Order Date");
                    end;
                }
                field(GeneralFilter; GetFiltersText())
                {
                    ApplicationArea = All;
                    Caption = 'General Filter';
                    Editable = false;
                }
            }
            group(Include)
            {
                Caption = 'Include';
                field(blnSalesQuote; blnSalesQuote)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Quote';
                }
                field(blnSalesOrder; blnSalesOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order';
                }
                field(blnSalesInvoice; blnSalesInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Invoice';
                }
                field(blnSalesCreditMemo; blnSalesCreditMemo)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Credit Memo';
                }
                field(blnSalesReturnOrder; blnSalesReturnOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Return Order';
                }
                field(blnPostedSalesInvoice; blnPostedSalesInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Invoice';
                }
                field(blnPostedSalesCrMemo; blnPostedSalesCrMemo)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Credit Memo';
                }
                field(blnCloesdOrder; blnCloesdOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Closed Sales Order';
                }
            }
            part(SalesInquirySubform; "Sales Inquiry Subform") { }
            group(Totals)
            {
                Caption = 'Total';
                field(decTotalQty; decTotalQty)
                {
                    ApplicationArea = All;
                    Caption = 'Total Quantity';
                    Editable = false;
                }
                field(decTotalAmount; decTotalAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount (LCY)';
                    Editable = false;
                }
                field(decTotalAmountInclVAT; decTotalAmountInclVAT)
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount Incl. VAT (LCY)';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowData)
            {
                Caption = 'Show Data';
                ApplicationArea = All;
                Image = View;
                trigger OnAction()
                begin
                    //FindRecords();
                end;
            }
            action(ClearData)
            {
                Caption = 'Clear Data';
                ApplicationArea = All;
                Image = Delete;
                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.DeleteAll();
                    CustomerFilter := '';
                    ItemFilter := '';
                    PostingDateFilter := '';
                    OrderDateFilter := '';
                    decTotalQty := 0;
                    decTotalAmount := 0;
                    decTotalAmountInclVAT := 0;
                end;
            }
            action(ExportNoTracking)
            {
                Caption = 'Export Data without LN/SN';
                ApplicationArea = All;
                Image = Export;
                trigger OnAction()
                begin
                    //ExportDataToExcel(false);
                end;
            }
            action(ExportWithTracking)
            {
                Caption = 'Export Data with LN/SN/Expiration Date';
                ApplicationArea = All;
                Image = Export;
                trigger OnAction()
                begin
                    //ExportDataToExcel(true);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        blnSalesQuote := true;
        blnSalesOrder := true;
        blnSalesInvoice := true;
        blnSalesCreditMemo := true;
        blnSalesReturnOrder := true;
        blnPostedSalesInvoice := true;
        blnPostedSalesCrMemo := true;
        blnCloesdOrder := true;
    end;

    var
        CustomerFilter: Text[250];
        ItemFilter: Text[250];
        PostingDateFilter: Text[250];
        OrderDateFilter: Text[250];
        decTotalQty: Decimal;
        decTotalAmount: Decimal;
        decTotalAmountInclVAT: Decimal;
        blnSalesQuote: Boolean;
        blnSalesOrder: Boolean;
        blnSalesInvoice: Boolean;
        blnSalesCreditMemo: Boolean;
        blnSalesReturnOrder: Boolean;
        blnPostedSalesInvoice: Boolean;
        blnPostedSalesCrMemo: Boolean;
        blnCloesdOrder: Boolean;
        TempExcelBuffer: Record 370 temporary;
        DimMgt: Codeunit 408;
        ShortcutDimCode: ARRAY[8] OF Code[20];

    local procedure GetFiltersText(): Text[250]
    begin
        exit(Rec.GetFilters);
    end;
}