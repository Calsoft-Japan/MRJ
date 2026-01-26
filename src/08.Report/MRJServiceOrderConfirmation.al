report 50022 "MRJ Service Order Confirmation"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'MRJ Service Order Confirmation';
    DefaultLayout = RDLC;
    RDLCLayout = 'src\07.ReportLayout\MRJServiceOrderConfirmationReport.rdlc';

    dataset
    {
        // 1. Service Header (メインデータ)
        dataitem(Header; "Service Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Customer No.";

            column(No_; "No.") { }
            column(Customer_No_; "Customer No.") { }
            column(txtDate; txtDate) { }
            column(PaymentTermText; PaymentTermText) { }
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }

            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(CopyText; CopyText) { }
                // 3. Page Loop
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    dataitem(ServiceItemLine; "Service Item Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                        DataItemLinkReference = Header;

                        column(Line_Description; Description) { }
                    }
                    dataitem(ServiceCommentLine; "Service Comment Line")
                    {
                        // 1. Table Name の固定値判定はこちらに記述（Enumの書き方を簡略化できる）
                        DataItemTableView = where("Table Name" = const("Service Header"));

                        // 2. DataItemLink は "No." の紐付けだけに絞る
                        DataItemLink = "No." = field("No.");
                        DataItemLinkReference = Header;

                        column(CommentText; Comment) { }
                    }
                }
                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    SetRange(Number, 1, NoOfLoops);
                end;
            }
            trigger OnAfterGetRecord()
            begin

                txtDate := Format("Document Date", 0, '<Year4>年<Month,2>月<Day,2>日');
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        FormatAddr: Codeunit "Format Address";
        txtDate: Text[50];
        PaymentTermText: Text[100];
        CopyText: Text[50];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CustAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];


}