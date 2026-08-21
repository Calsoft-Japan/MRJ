pageextension 55929 "Fault Reason Codes Ext" extends "Fault Reason Codes"
{
    actions
    {
        addafter("Service Item Line List")
        {
            action(Dimensions)
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = const(5917), "No." = field(Code);
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
            }
        }
    }
}