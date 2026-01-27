page 50140 "Sales Inquiry Card"
{
    ApplicationArea = All;
    Caption = 'Service Inquiry';
    PageType = Document;
    UsageCategory = Tasks;
    DataCaptionExpression = '';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PostingDateFilter; PostingDateFilter)
                {
                    Caption = 'Posting Date Filter';
                    trigger OnValidate();
                    begin
                        ApplMgt.MakeDateFilter(PostingDateFilter);
                        ServInqLine.SetFilter("Posting Date", PostingDateFilter);
                        PostingDateFilter := ServInqLine.GetFilter("Posting Date");
                    end;
                }
                field(ServicePostedInvoice; ServicePostedInvoice)
                {
                    Caption = 'Service Posted Invoice';
                }
                field(ServicePostedCrMemo; ServicePostedCrMemo)
                {
                    Caption = 'Service Posted Credit Memo';
                }
            }
            part(ServInquiryLines; "Service Inquiry Subform") { }
        }
    }
    var
        ServInqLine: Record "Service Inquiry Line";
        ApplMgt: Codeunit "Filter Tokens";
        PostingDateFilter: Text;
        ServicePostedInvoice: Boolean;
        ServicePostedCrMemo: Boolean;
}