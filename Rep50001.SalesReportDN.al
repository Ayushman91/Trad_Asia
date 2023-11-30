report 50001 "Debit Note(No GST)"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Layouts\SalesReportTradAsia.rdl';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            column(No; "No.") { }
            column(CompanyInfoCity; CompanyInfo.City) { }
            column(CompanyInfoBankName; CompanyInfo."Bank Name") { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            //column(CompanyInfo; CompanyInfo."Brand Color Code") { }
            column(CompanyInfoSwiftCode; CompanyInfo."SWIFT Code") { }
            column(Currency_Code; "Currency Code") { }
            column(CompanyNameCaption; CompanyNameCaption) { }
            column(CompanyInfoBankAcc; CompanyInfo."Bank Account No.") { }
            column(Posting_Date; Format("Posting Date", 0, '<Closing><Day> <Month Text> <Year4>')) { }
            column(RegistrationNoCaption; RegistrationNoCaption) { }
            column(remittanceCaption; Strsubstno(remittanceCaption, currencycode)) { }
            column(PaytoCaption; PaytoCaption) { }
            column(swiftaddrCaption; swiftaddrCaption) { }
            column(bankaddrCaption; bankaddrCaption) { }
            column(favouringCaption; favouringCaption) { }
            column(BeneficiaryCaption; BeneficiaryCaption) { }
            column(AddrCaption; AddrCaption) { }
            column(amountCaption; amountCaption) { }
            column(cloud9caption; cloud9caption) { }
            column(totalCaption; totalCaption) { }
            column(dateCaption; dateCaption) { }
            column(debitnoteCaption; debitnoteCaption) { }
            column(managementCaption; managementCaption) { }
            column(TelephoneCaption; TelephoneCaption) { }
            column(IntercoCaption; IntercoCaption) { }
            column(currencysymbol; currencysymbol) { }
            column(currencycode; currencycode) { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }
            column(CompanyAddr9; CompanyAddr[9]) { }
            column(CompanyAddr10; CompanyAddr[10]) { }
            column(BillToAddr1; BillToAddr[1]) { }
            column(BillToAddr2; BillToAddr[2]) { }
            column(BillToAddr3; BillToAddr[3]) { }
            column(BillToAddr4; BillToAddr[4]) { }
            //column(BillToAddr5; BillToAddr[5]) { }
            column(BillToAddr5; BillToAddr[5]) { }
            column(BillToAddr6; BillToAddr[6]) { }
            column(BillToAddr7; BillToAddr[7]) { }
            column(BillToAddr8; BillToAddr[8]) { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Invoice Header";
                column(Description; Description) { }
                column(Document_No_; "Document No.") { }
                column(Order_No_; "Order No.") { }
                column(Line_No_; "Line No.") { }
                column(No_; "No.") { }
                column(Line_Amount; "Line Amount") { }
                column(Amount; Amount) { }
                column(Amount_Including_VAT; "Amount Including VAT") { }
                column(Total; Total) { }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin
                    Clear(Total);
                    SIL.Reset();
                    SIL.SetRange("Document No.", SIH."No.");
                    SIL.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                    if SIL.FindSet() then begin
                        SIL.CalcSums("Line Amount", "Amount Including VAT");
                    end;
                    Total := SIL."Amount Including VAT";
                end;

                trigger OnPostDataItem()
                begin

                end;
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                Clear(CompanyAddr);
                CompanyAddr[1] := CompanyInfo.Name;
                CompanyAddr[2] := CompanyInfo.Address;
                CompanyAddr[3] := CompanyInfo."Phone No.";
                CompanyAddr[4] := CompanyInfo."Fax No.";
                CompanyAddr[5] := CompanyInfo."E-Mail";
                CompanyAddr[6] := CompanyInfo."Home Page";
                CompanyAddr[7] := RegistrationNoCaption;
                CompanyAddr[8] := CompanyInfo."Registration No.";
                CompanyAddr[9] := CompanyInfo.City + ' ' + CompanyInfo."Post Code";
                CompanyAddr[10] := CompanyInfo."Address 2";
                Clear(BillToAddr);
                formataddr.SalesInvBillTo(BillToAddr, "Sales Invoice Header");
                CompressArray(BillToAddr);
                Clear(currencycode);
                if "Currency Code" = '' then begin
                    currencycode := GLsetup."LCY Code";
                    currencysymbol := GLsetup."Local Currency Symbol";
                end
                else begin
                    currencycode := "Currency Code";
                    currencyrecord.get(currencycode);
                    currencysymbol := currencyrecord.GetCurrencySymbol();
                end;
            end;

            trigger OnPostDataItem()
            begin

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        GLsetup.Get();
    end;

    trigger OnInitReport()
    begin

    end;

    trigger OnPostReport()
    begin

    end;

    var
        myInt: Integer;
        Total: Decimal;
        CompanyInfo: Record "Company Information";
        SIH: Record "Sales Invoice Header";
        SIL: Record "Sales Invoice Line";
        BillToAddr: array[8] of Text;
        DeliverToAddr: array[8] of Text;
        CompanyAddr: array[10] of Text;
        RegistrationNoCaption: Label 'GST registration number';
        formataddr: Codeunit "Format Address";
        currencycode: Code[20];
        currencyrecord: Record Currency;
        currencysymbol: Text;
        GLsetup: Record "General Ledger Setup";
        remittanceCaption: Label '%1 Remittance Details:';
        PaytoCaption: Label 'Pay To:';
        swiftaddrCaption: Label 'SWIFT ADDRESS:';
        bankaddrCaption: Label 'Bank Address:';
        favouringCaption: Label 'Favouring:Account Number';
        BeneficiaryCaption: Label 'Beneficiary Name:';
        AddrCaption: Label 'Address:';
        cloud9caption: Label 'Cloud 9 (Nov 2022 - July 2023)';
        amountCaption: Label 'Amount';
        totalCaption: Label 'Total';
        dateCaption: Label 'Date:';
        debitnoteCaption: Label 'Debit Note No.';
        managementCaption: Label 'Management';
        TelephoneCaption: Label 'Tel:';
        IntercoCaption: Label 'Interco:';
        CompanyNameCaption: Label 'TRADITION ASIA PACIFIC (PTE.) LTD.';
}