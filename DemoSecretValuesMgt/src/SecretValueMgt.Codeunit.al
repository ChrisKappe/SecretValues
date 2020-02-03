codeunit 60260 SecretValueMgtAJK
{
    Access = Internal;

    var
        SecretValue: Codeunit SecretValueAJK;
        NoAccessErr: Label 'This function can only be called from a management session.';

    [NonDebuggable]
    procedure SetSecretValue(TextValue: Text[215])
    begin
        CheckClientType();
        SecretValue.SetSecretValue(TextValue);
    end;

    [NonDebuggable]
    procedure PrepareSecretValueTableForExport()
    begin
        CheckClientType();
        SecretValue.PrepareSecretValueTableForExport();
    end;

    [NonDebuggable]
    procedure RemoveSecretValueTableData()
    begin
        CheckClientType();
        SecretValue.RemoveSecretValueTableData();
    end;

    local procedure CheckClientType()
    begin
        if CurrentClientType() <> ClientType::Management then
            Error(NoAccessErr);
    end;
}