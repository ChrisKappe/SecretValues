codeunit 70455527 SecretValueMgtAJK
{
    Access = Internal;

    var
        NoAccessErr: Label 'This function can only be called from a management session.';

    [NonDebuggable]
    procedure SetSecretValue(SecretValue: Text[215])
    begin
        CheckClientType();
        OnSetSecretValue(SecretValue);
    end;

    [NonDebuggable]
    procedure PrepareSecretValueTableForExport()
    begin
        CheckClientType();
        OnPrepareSecretValueTableForExport();
    end;

    [NonDebuggable]
    procedure RemoveSecretValueTableData()
    begin
        CheckClientType();
        OnRemoveSecretValueTableData();
    end;

    local procedure CheckClientType()
    begin
        if CurrentClientType() <> ClientType::Management then
            Error(NoAccessErr);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetSecretValue(SecretValue: Text[215])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPrepareSecretValueTableForExport()
    begin
    end;

    [IntegrationEvent(false,false)]
    local procedure OnRemoveSecretValueTableData()
    begin
    end;
}