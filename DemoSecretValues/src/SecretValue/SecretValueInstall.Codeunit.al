codeunit 60251 SecretValueInstallAJK
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    begin
        ImportSecretValues();
    end;
    local procedure ImportSecretValues()
    var
        SecretValue: Codeunit SecretValueAJK;
    begin
        SecretValue.ImportSecretValue();
    end;
}