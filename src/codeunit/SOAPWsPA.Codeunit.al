codeunit 50130 "SOAP WsPA"
{
    trigger OnRun()
    begin

    end;

    procedure Calc(Name: Text): Text

    begin
        exit('Welcome' + Name + '.');

    end;


}