permissionset 50000 "MRJ-PTE"
{
    Assignable = true;
    Caption = 'MRJ Customizations';

    Permissions =
        tabledata "Sales Inquiry Line" = RIMD,
        tabledata "Parts Transfer Buffer" = RIMD,
        tabledata "Service Inquiry Line" = RIMD;
}