codeunit 50130 "BCSOAP WsPA"
{
    trigger OnRun()
    begin

    end;

    procedure Calc(No: Text): Text
    var
        SalesHeader: Record "Sales Header";
    begin
        //exit('Welcome ' + No + '.');
        SalesHeader.Get(SalesHeader."Document Type"::Order, No);
        SalesHeader.Ship := true;
        SalesHeader.Invoice := true;
        Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
        CreatePayment(SalesHeader);
        exit('Success');
    end;

    local procedure CreatePayment(var SalesHeader: Record "Sales Header")
    var
        GenJournalLine: Record "Gen. Journal Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if FindPostedSalesInvoice(SalesHeader, SalesInvoiceHeader) then begin

            SalesInvoiceHeader.CalcFields("Amount Including VAT");

            GenJournalLine.Init();
            GenJournalLine.Validate("Posting Date", Today());
            GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment);
            GenJournalLine.Validate("Document No.", CopyStr('PAY-' + SalesInvoiceHeader."No.", 1, MaxStrLen(GenJournalLine."Document No.")));
            GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::Customer);
            GenJournalLine.Validate("Account No.", SalesHeader."Sell-to Customer No.");
            GenJournalLine.Validate("Currency Code", SalesInvoiceHeader."Currency Code");
            GenJournalLine.Validate("Payment Method Code", 'CASH'); // TODO - CASH u setup treba
            GenJournalLine.Validate("Credit Amount", SalesInvoiceHeader."Amount Including VAT");
            GenJournalLine.Validate("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::Invoice);
            GenJournalLine.Validate("Applies-to Doc. No.", SalesInvoiceHeader."No.");
            GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
            GenJournalLine.Validate("Gen. Prod. Posting Group", GenJournalLine."Gen. Prod. Posting Group");
            GenJournalLine.Validate("Bal. Account No.", 'WWB-EUR');
            // moze da radi bez Insert-a; ako hocemo Insert moramo da popunimo i PK

            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Line", GenJournalLine); // knjizenje
        end;
    end;

    local procedure FindPostedSalesInvoice(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    begin
        SalesInvoiceHeader.SetRange("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        SalesInvoiceHeader.SetRange("Order No.", SalesHeader."No.");
        SalesInvoiceHeader.SetRange("Posting Date", SalesHeader."Posting Date");
        exit(SalesInvoiceHeader.FindFirst());
    end;

}