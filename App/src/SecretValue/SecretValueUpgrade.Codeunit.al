codeunit 70455528 SecretValueUpgradeAJK
{
    Subtype = Upgrade;

    trigger OnUpgradePerDatabase()
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