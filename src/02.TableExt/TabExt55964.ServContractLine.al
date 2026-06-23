tableextension 55964 "Serv. Contract Line Ext" extends "Service Contract Line"
{
    fields
    {
        field(90000; "Contract Line Value"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Contract Line Value';
            trigger OnValidate()
            begin
                GetServContractHeader();
                case ServContractHeader."Contract Period" of
                    ServContractHeader."Contract Period"::Month:
                        Validate("Line Value", "Contract Line Value" * 12);
                    ServContractHeader."Contract Period"::"Two Months":
                        Validate("Line Value", "Contract Line Value" * 6);
                    ServContractHeader."Contract Period"::Quarter:
                        Validate("Line Value", "Contract Line Value" * 4);
                    ServContractHeader."Contract Period"::"Half Year":
                        Validate("Line Value", "Contract Line Value" * 2);
                    ServContractHeader."Contract Period"::Year:
                        Validate("Line Value", "Contract Line Value");
                    ServContractHeader."Contract Period"::None:
                        Validate("Line Value", 0);
                //ServContractHeader."Contract Period"::Free:
                //Validate("Line Value", ("Contract Line Value" / ServContractHeader."Contract Free Period") * 12);
                end;
            end;
        }
    }
    local procedure GetServContractHeader()
    begin
        TestField(Rec."Contract No.");
        if ("Contract Type" <> ServContractHeader."Contract Type") or
           ("Contract No." <> ServContractHeader."Contract No.")
        then begin
            ServContractHeader.Get("Contract Type", "Contract No.");
        end;
    end;

    var
        ServContractHeader: Record "Service Contract Header";
}

