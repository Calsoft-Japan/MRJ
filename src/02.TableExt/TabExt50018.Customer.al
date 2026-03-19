tableextension 50018 "Customer Ext" extends Customer
{
    fields
    {
        field(50001; "NameTitle"; Text[50])
        {
            Caption = 'NameTitle';
        }
        field(50002; "ContactTitle"; Text[50])
        {
            Caption = 'ContactTitle';
        }
        field(50050; "Roland Cust. No."; Code[20])
        {
            Caption = 'Roland Cust. No.';
        }
        field(50051; "Designated Form Y/N"; Boolean)
        {
            Caption = 'Designated Form Y/N';
        }
        field(50052; "Trigger Point for PN"; Decimal)
        {
            BlankZero = true;
            Caption = 'Trigger Point for PN';
            DecimalPlaces = 0 : 5;
        }
        field(50053; "Payment Method Code 2"; Code[10])
        {
            Caption = 'Payment Method Code 2';
            TableRelation = "Payment Method";
        }
        field(50054; "No. of Suspense Month"; Integer)
        {
            BlankZero = true;
            Caption = 'No. of Suspense Month';
        }
        field(50055; "Invoice Collection Method"; Text[50])
        {
            Caption = 'Invoice Collection Method';
        }
        field(50056; "Travel Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Travel Time';
            DecimalPlaces = 0 : 5;
        }
        field(50057; "Travel Flat Rate"; Decimal)
        {
            BlankZero = true;
            Caption = 'Travel Flat Rate';
            DecimalPlaces = 0 : 5;
        }
        field(90000; "Phone No. (Service)"; Text[30])
        {
            Caption = 'Phone No. (Service)';
        }
        field(90001; "Inspection In-Charge (Dept.)"; Text[30])
        {
            Caption = 'Inspection In-Charge (Dept.)';
        }
        field(90002; "Inspection In-Charge (Person)"; Text[30])
        {
            Caption = 'Inspection In-Charge (Person)';
        }
        field(90003; "Phone No. (Direct)"; Text[30])
        {
            Caption = 'Phone No. (Direct)';
        }
    }
}

