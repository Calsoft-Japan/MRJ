// report 50018 "MRJ Purchase Order Report"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     Caption = 'MRJ Purchase Order (JP)';
//     DefaultLayout = RDLC;
//     RDLCLayout = 'src\07.ReportLayout\MRJPurchaseOrderReport.rdlc';

//     dataset
//     {
//         dataitem(PurchHeader; "Purchase Header")
//         {
//             DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
//             RequestFilterFields = "No.", "Buy-from Vendor No.";

//             // ===== Header fields =====
//             column(DocumentNo; "No.") { }
//             column(PostingDate; "Posting Date") { }
//             column(DocumentDate; "Document Date") { }
//             column(BuyFromVendorNo; "Buy-from Vendor No.") { }
//             column(BuyFromVendorName; "Buy-from Vendor Name") { }
//             column(YourReference; "Your Reference") { }
//             column(PaymentTermsCode; "Payment Terms Code") { }
//             column(CurrencyCode; "Currency Code") { }

//             // ===== Company (JP default from Company Info address formatting if you want in layout) =====
//             column(CompanyNameJP; CompanyInfo.Name) { }
//             column(CompanyAddrJP1; CompanyAddr[1]) { }
//             column(CompanyAddrJP2; CompanyAddr[2]) { }
//             column(CompanyAddrJP3; CompanyAddr[3]) { }
//             column(CompanyAddrJP4; CompanyAddr[4]) { }
//             column(CompanyAddrJP5; CompanyAddr[5]) { }
//             column(CompanyAddrJP6; CompanyAddr[6]) { }
//             column(CompanyAddrJP7; CompanyAddr[7]) { }
//             column(CompanyAddrJP8; CompanyAddr[8]) { }

//             // ===== Company EN (as per screenshot requirement) =====
//             column(CompanyNameEN; CompanyNameEN) { }       // RespCenter."Name 2"
//             column(CompanyAddressEN; CompanyAddressEN) { } // RespCenter."Address 2"

//             // ===== Registration No. (登録番号) =====
//             column(CompanyRegNoCaption; CompanyRegNoCaption) { } // '登録番号:' / 'Registration No.:'
//             column(CompanyRegNoValue; CompanyRegNoValue) { }     // CompanyInfo."VAT Registration No."

//             // ===== VAT summary line like screenshot =====
//             column(VATRateCaption; VATRateCaption) { } // '10%対象' / '10% taxable'
//             column(VATBaseByRate; VATBaseByRate) { AutoFormatType = 1; AutoFormatExpression = "Currency Code"; }
//             column(VATAmtByRate; VATAmtByRate) { AutoFormatType = 1; AutoFormatExpression = "Currency Code"; }

//             // ===== Totals box (税抜/税/税込) =====
//             column(TotalExclVAT; TotalExclVAT) { AutoFormatType = 1; AutoFormatExpression = "Currency Code"; }
//             column(TotalVAT; TotalVAT) { AutoFormatType = 1; AutoFormatExpression = "Currency Code"; }
//             column(TotalInclVAT; TotalInclVAT) { AutoFormatType = 1; AutoFormatExpression = "Currency Code"; }

//             dataitem(PurchLine; "Purchase Line")
//             {
//                 DataItemLink = "Document Type" = field("Document Type"),
//                                "Document No." = field("No.");
//                 DataItemTableView = sorting("Document Type", "Document No.", "Line No.")
//                                     where(Type = filter(<> " ")); // ignore blank lines

//                 column(LineNo; "Line No.") { }
//                 column(Type; Type) { }
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Description2; "Description 2") { }
//                 column(Quantity; Quantity) { }
//                 column(UnitOfMeasure; "Unit of Measure") { }
//                 column(DirectUnitCost; "Direct Unit Cost") { AutoFormatType = 1; AutoFormatExpression = PurchHeader."Currency Code"; }
//                 column(LineAmount; "Line Amount") { AutoFormatType = 1; AutoFormatExpression = PurchHeader."Currency Code"; }
//                 column(VATPercent; "VAT %") { }

//                 // Optional: if you need negative display like screenshot, handle in layout or create calc columns.
//             }

//             trigger OnPreDataItem()
//             begin
//                 CompanyInfo.Get();
//                 CompanyInfo.CalcFields(Picture);

//                 // Simple address fill (JP). If you already have your own formatting, keep it in RDLC.
//                 Clear(CompanyAddr);
//                 CompanyAddr[1] := CompanyInfo.Name;
//                 CompanyAddr[2] := CompanyInfo.Address;
//                 CompanyAddr[3] := CompanyInfo."Address 2";
//                 CompanyAddr[4] := CompanyInfo.City;
//                 CompanyAddr[5] := CompanyInfo."Post Code";
//                 CompanyAddr[6] := CompanyInfo.County;
//                 CompanyAddr[7] := CompanyInfo."Country/Region Code";
//                 CompanyAddr[8] := CompanyInfo."Phone No.";
//             end;

//             trigger OnAfterGetRecord()
//             begin
//                 BuildCompanyENAndRegNo();
//                 CalcTotalsAndVATSummary();
//             end;
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';
//                     field(ShowENCompanyBlock; ShowENCompanyBlock)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Show EN company block';
//                     }
//                 }
//             }
//         }
//     }

//     var
//         CompanyInfo: Record "Company Information";
//         RespCenter: Record "Responsibility Center";

//         CompanyAddr: array[8] of Text[100];

//         CompanyNameEN: Text[100];
//         CompanyAddressEN: Text[100];

//         CompanyRegNoCaption: Text[30];
//         CompanyRegNoValue: Text[30];

//         VATRateCaption: Text[30];
//         VATBaseByRate: Decimal;
//         VATAmtByRate: Decimal;

//         TotalExclVAT: Decimal;
//         TotalVAT: Decimal;
//         TotalInclVAT: Decimal;

//         ShowENCompanyBlock: Boolean;

//     local procedure BuildCompanyENAndRegNo()
//     begin
//         Clear(CompanyNameEN);
//         Clear(CompanyAddressEN);

//         if ShowENCompanyBlock then begin
//             if (PurchHeader."Responsibility Center" <> '') and RespCenter.Get(PurchHeader."Responsibility Center") then begin
//                 // As you requested:
//                 // Name 2 = Company Name in EN
//                 // Address 2 = Company Address in EN
//                 CompanyNameEN := RespCenter."Name 2";
//                 CompanyAddressEN := RespCenter."Address 2";
//             end else begin
//                 // fallback to Company Information
//                 CompanyNameEN := CompanyInfo."Name 2";
//                 CompanyAddressEN := CompanyInfo."Address 2";
//             end;
//         end;

//         // Registration No. -> display as 登録番号
//         CompanyRegNoCaption := '登録番号:';
//         CompanyRegNoValue := CompanyInfo."VAT Registration No.";
//     end;

//     local procedure CalcTotalsAndVATSummary()
//     var
//         VATAmountLine: Record "VAT Amount Line";
//         VATMainRate: Decimal;
//     begin
//         // reset
//         TotalExclVAT := 0;
//         TotalVAT := 0;
//         TotalInclVAT := 0;
//         VATBaseByRate := 0;
//         VATAmtByRate := 0;
//         VATRateCaption := '';

//         // Build VAT lines from Purchase Header (standard helper table)
//         VATAmountLine.DeleteAll(); // temp-like use is common, but in AL this is a real table.
//                                    // If you prefer a safer approach, use VATAmountLine as temporary via Temp table in extension.
//                                    // For "simple version", we recalc from posted amounts below instead.

//         // === Simple totals from lines (works for most cases) ===
//         CalcLineTotalsFromPurchLines(TotalExclVAT, TotalInclVAT, TotalVAT);

//         // === VAT by main rate (typically 10%) ===
//         // We approximate by using the most common VAT% on lines (prefer 10%).
//         VATMainRate := 10;
//         CalcVATByRateFromLines(VATMainRate, VATBaseByRate, VATAmtByRate);

//         VATRateCaption := Format(VATMainRate, 0, '<Integer>') + '%対象';
//     end;

//     local procedure CalcLineTotalsFromPurchLines(var ExclVAT: Decimal; var InclVAT: Decimal; var VAT: Decimal)
//     var
//         Line: Record "Purchase Line";
//         LineAmountExcl: Decimal;
//         LineVAT: Decimal;
//     begin
//         ExclVAT := 0;
//         VAT := 0;

//         Line.SetRange("Document Type", PurchHeader."Document Type");
//         Line.SetRange("Document No.", PurchHeader."No.");
//         Line.SetFilter(Type, '<>%1', Line.Type::" ");

//         if Line.FindSet() then
//             repeat
//                 // Excl VAT
//                 LineAmountExcl := Line."Line Amount";
//                 ExclVAT += LineAmountExcl;

//                 // VAT approximation from line VAT %
//                 if Line."VAT %" <> 0 then
//                     LineVAT := Round(LineAmountExcl * Line."VAT %" / 100, 1, '=')
//                 else
//                     LineVAT := 0;

//                 VAT += LineVAT;
//             until Line.Next() = 0;

//         InclVAT := ExclVAT + VAT;
//     end;

//     local procedure CalcVATByRateFromLines(VATRate: Decimal; var Base: Decimal; var Amt: Decimal)
//     var
//         Line: Record "Purchase Line";
//         LineAmountExcl: Decimal;
//         LineVAT: Decimal;
//     begin
//         Base := 0;
//         Amt := 0;

//         Line.SetRange("Document Type", PurchHeader."Document Type");
//         Line.SetRange("Document No.", PurchHeader."No.");
//         Line.SetRange("VAT %", VATRate);
//         Line.SetFilter(Type, '<>%1', Line.Type::" ");

//         if Line.FindSet() then
//             repeat
//                 LineAmountExcl := Line."Line Amount";
//                 Base += LineAmountExcl;

//                 LineVAT := Round(LineAmountExcl * VATRate / 100, 1, '=');
//                 Amt += LineVAT;
//             until Line.Next() = 0;
//     end;
// }
