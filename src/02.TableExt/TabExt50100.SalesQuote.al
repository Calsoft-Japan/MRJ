tableextension 50100 "SalesQuote Extension" extends "Sales Header"
{
    fields
    {
        // Add a new field to store the sales quote source
        field(50000; "Expiration Date"; Date)
        {

        }
    }

    // You can add additional triggers or methods here if needed
}