page 50018 "Sales Inquiry Card"
{
    ApplicationArea = All;
    Caption = 'Sales Inquiry';
    PageType = Document;
    UsageCategory = Tasks;
    DataCaptionExpression = '';

    layout
    {
        area(content)
        {
            group(Include)
            {
                Caption = 'Include';
                field(SalesQuote; SalesQuote)
                {
                    Caption = 'Sales Quote';
                }
                field(SalesOrder; SalesOrder)
                {
                    Caption = 'Sales Order';
                }
                field(SalesInvoice; SalesInvoice)
                {
                    Caption = 'Sales Invoice';
                }
                field(SalesCreditMemo; SalesCreditMemo)
                {
                    Caption = 'Sales Credit Memo';
                }
                field(SalesReturnOrder; SalesReturnOrder)
                {
                    Caption = 'Sales Return Order';
                }
                field(PostedSalesInvoice; PostedSalesInvoice)
                {
                    Caption = 'Posted Sales Invoice';
                }
                field(PostedSalesCrMemo; PostedSalesCrMemo)
                {
                    Caption = 'Posted Sales Credit Memo';
                }
                field(ShowMode; ShowMode)
                {
                    Caption = 'Show Mode';
                    Importance = Promoted;
                    OptionCaption = 'Header + Line,Header Only,Line Only';

                    trigger OnValidate();
                    begin
                        CurrPage.SalesInquirySubform.Page.ControlShowMode(ShowMode);
                        CurrPage.Update(false);
                    end;
                }
            }
            group(Group)
            {
                Caption = 'Header Field Filter';
                field(SelltoCustomerFilter; SelltoCustomerFilter)
                {
                    Caption = 'Sell-to Customer Filter';
                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        CustomerList: Page "Customer List";
                    begin
                        Clear(CustomerList);
                        CustomerList.LookupMode(true);
                        if CustomerList.RunModal() = Action::LookupOK then begin
                            Text += CustomerList.GetSelectionFilter;
                            exit(true);
                        end else
                            exit(false);
                        CurrPage.Update;
                    end;
                }
                field(BilltoCustomerFilter; BilltoCustomerFilter)
                {
                    Caption = 'Bill-to Customer Filter';

                    trigger OnLookup(var Text: Text): Boolean;

                    var
                        CustomerList: Page "Customer List";
                    begin
                        Clear(CustomerList);
                        CustomerList.LookupMode(true);
                        if CustomerList.RunModal() = Action::LookupOK then begin
                            Text += CustomerList.GetSelectionFilter;
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field(PostingDateFilter; PostingDateFilter)
                {
                    Caption = 'Posting Date Filter';
                    trigger OnValidate();
                    begin
                        ApplMgt.MakeDateFilter(PostingDateFilter);
                        SalesInqLine.SetFilter("Posting Date", PostingDateFilter);
                        PostingDateFilter := SalesInqLine.GetFilter("Posting Date");
                    end;
                }
                field(OrderDateFilter; OrderDateFilter)
                {
                    Caption = 'Order Date Filter';
                    trigger OnValidate();
                    begin
                        ApplMgt.MakeDateFilter(OrderDateFilter);
                        SalesInqLine.SetFilter("Order Date", OrderDateFilter);
                        OrderDateFilter := SalesInqLine.GetFilter("Order Date");
                    end;
                }
            }
            group("Line Field Filter")
            {
                Caption = 'Line Field Filter';
                field(ItemFilter; ItemFilter)
                {
                    Caption = 'Item Filter';

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        ItemList: Page "Item List";
                    begin
                        Clear(ItemList);
                        ItemList.LookupMode(true);
                        if ItemList.RunModal() = Action::LookupOK then begin
                            Text += ItemList.GetSelectionFilter;
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field(ShowDummyLine; ShowDummyLine)
                {
                    ApplicationArea = All;
                    Caption = 'Show Zero Amount Line';
                }
            }
            part(SalesInquirySubform; "Sales Inquiry Subform") { }
            group(Total)
            {
                Caption = 'Total';
                field(TotalQty; TotalQty)
                {
                    BlankZero = true;
                    Caption = 'Total Quantity (Base)';
                    DecimalPlaces = 0 : 2;
                    Editable = false;
                    Importance = Promoted;
                }
                field(TotalAmount; TotalAmount)
                {
                    AutoFormatType = 1;
                    BlankZero = true;
                    Caption = 'Total Amount (LCY)';
                    Editable = false;
                    Importance = Promoted;
                }
                field(TotalAmountInclVAT; TotalAmountInclVAT)
                {
                    AutoFormatType = 1;
                    BlankZero = true;
                    Caption = 'Total Amount Incl. VAT (LCY)';
                    Editable = false;
                    Importance = Promoted;
                }
            }
        }
    }

    Actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                Action(ShowData)
                {
                    Caption = 'Show Data';
                    Image = ViewPage;
                    Promoted = true;
                    PromotedIsBig = true;
                    trigger OnAction();
                    begin
                        Window.Open(Text000);
                        CurrPage.SalesInquirySubform.Page.SetIncludeTable(
                          SalesQuote, SalesOrder, SalesInvoice, SalesCreditMemo, SalesReturnOrder, PostedSalesInvoice, PostedSalesCrMemo);
                        CurrPage.SalesInquirySubform.Page.SetHeaderFilter(SelltoCustomerFilter, BilltoCustomerFilter, PostingDateFilter, OrderDateFilter);
                        CurrPage.SalesInquirySubform.Page.SetLineFilter(ItemFilter, ShowDummyLine);
                        CurrPage.SalesInquirySubform.Page.FindRecords(CurrGUID);
                        CurrPage.SalesInquirySubform.Page.GetTotalValue(TotalQty, TotalAmount, TotalAmountInclVAT);
                        Window.Close();
                        CurrPage.Update(false);
                    end;
                }
                Action(ExportDatawithLot)
                {
                    Caption = 'Export Data with LN/SN/Expiration Date';
                    Image = ExportToExcel;
                    Promoted = true;
                    PromotedIsBig = true;
                    trigger OnAction();
                    begin
                        CurrPage.SalesInquirySubform.Page.ExportDataToExcel(true);
                    end;
                }
            }
        }
    }

    trigger OnClosePage();
    begin
        SalesInqLine.Reset();
        SalesInqLine.SetRange(Guid, CurrGUID);
        SalesInqLine.DeleteAll();
    end;

    trigger OnInit();
    begin
        PostedSalesInvoice := true;
        PostedSalesCrMemo := true;
        ShowDummyLine := true;
        CurrPage.SalesInquirySubform.Page.ControlShowMode(ShowMode);
    end;

    trigger OnOpenPage();
    begin
        CurrGUID := CreateGuid();
        SalesInqLine.Reset();
        SalesInqLine.SetCurrentKey("Creation Date");
        SalesInqLine.SetRange("Creation Date", Today() - 3);
        if not SalesInqLine.IsEmpty then
            SalesInqLine.DeleteAll();
        SalesInqLine.Reset();
    end;

    var
        SalesInqLine: Record "Sales Inquiry Line" temporary;
        ApplMgt: Codeunit "Filter Tokens";
        ShowMode: Option "Header + Line","Header Only","Line Only";
        SelltoCustomerFilter: Text;
        BilltoCustomerFilter: Text;
        PostingDateFilter: Text;
        OrderDateFilter: Text;
        ItemFilter: Text;
        CurrGUID: Guid;
        TotalQty: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        ShowDummyLine: Boolean;
        SalesQuote: Boolean;
        SalesOrder: Boolean;
        SalesInvoice: Boolean;
        SalesCreditMemo: Boolean;
        SalesReturnOrder: Boolean;
        PostedSalesInvoice: Boolean;
        PostedSalesCrMemo: Boolean;
        Window: Dialog;
        Text000: Label 'Now searching.\Please wait ...';
}