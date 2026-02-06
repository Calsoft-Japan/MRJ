page 50140 "Service Inquiry Card"
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
    actions
    {
        area(Processing)
        {
            group(HomeTab)
            {
                Caption = 'Home';
                Action(ShowData)
                {
                    ApplicationArea = All;
                    Caption = 'Show Data';
                    Image = ViewPage;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    begin
                        Window.Open(WinUpdTxt);
                        CurrPage.ServInquiryLines.Page.SetIncludeFilter(ServicePostedInvoice, ServicePostedCrMemo);
                        CurrPage.ServInquiryLines.Page.RefreshData(PostingDateFilter);
                        Window.Close();
                        CurrPage.Update(false);
                    end;
                }
                Action(ClearData)
                {
                    ApplicationArea = All;
                    Caption = 'Clear Data';
                    Image = ClearLog;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    begin
                        Window.Open(WinDelTxt);
                        CurrPage.ServInquiryLines.Page.DeleteRecords();
                        Window.Close();
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
    var
        ServInqLine: Record "Service Inquiry Line";
        ApplMgt: Codeunit "Filter Tokens";
        PostingDateFilter: Text;
        Window: Dialog;
        ServicePostedInvoice: Boolean;
        ServicePostedCrMemo: Boolean;
        WinUpdTxt: Label 'Now updating.\Please wait ...';
        WinDelTxt: Label 'Now deleting.\Please wait ...';
}