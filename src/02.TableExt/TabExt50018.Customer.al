tableextension 50018 "Customer Ext" extends Customer
{
    fields
    {
        field(50050; "Roland Cust. No."; Code[20])
        {
            Caption = 'Roland Cust. No.';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50051; "Designated Form Y/N"; Boolean)
        {
            Caption = 'Designated Form Y/N';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50052; "Trigger Point for PN"; Decimal)
        {
            BlankZero = true;
            Caption = 'Trigger Point for PN';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'UPG';
        }
        field(50053; "Payment Method Code 2"; Code[10])
        {
            Caption = 'Payment Method Code 2';
            DataClassification = ToBeClassified;
            Description = 'UPG';
            TableRelation = "Payment Method";
        }
        field(50054; "No. of Suspense Month"; Integer)
        {
            BlankZero = true;
            Caption = 'No. of Suspense Month';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50055; "Invoice Collection Method"; Text[50])
        {
            Caption = 'Invoice Collection Method';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(50056; "Travel Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Travel Time';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'UPG';
        }
        field(50057; "Travel Flat Rate"; Decimal)
        {
            BlankZero = true;
            Caption = 'Travel Flat Rate';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'UPG';
        }
        field(90000; "Phone No. (Service)"; Text[30])
        {
            Caption = 'Phone No. (Service)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90001; "Inspection In-Charge (Dept.)"; Text[30])
        {
            Caption = 'Inspection In-Charge (Dept.)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90002; "Inspection In-Charge (Person)"; Text[30])
        {
            Caption = 'Inspection In-Charge (Person)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
        field(90003; "Phone No. (Direct)"; Text[30])
        {
            Caption = 'Phone No. (Direct)';
            DataClassification = ToBeClassified;
            Description = 'UPG';
        }
    }
}

