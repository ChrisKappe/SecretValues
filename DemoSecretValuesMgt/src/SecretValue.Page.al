page 60260 SecretValueAJK
{
    Caption = 'Secret Values';
    PageType = Card;
    SourceTable = SecretValueAJK;
    UsageCategory = Tasks;
    ApplicationArea = All;

    Editable = false;

    layout
    {
        area(Content)
        {
            field(SecretValue1Control; GetSecretValueAsText(1))
            {
                Caption = 'Secret Value 1';
                ApplicationArea = All;
                MultiLine = true;
            }
            field(SecretValue2Control; GetSecretValueAsText(2))
            {
                Caption = 'Secret Value 2';
                ApplicationArea = All;
                MultiLine = true;
            }
            field(SecretValue3Control; GetSecretValueAsText(3))
            {
                Caption = 'Secret Value 3';
                ApplicationArea = All;
                MultiLine = true;
            }
            field(SecretValueInIsolatedStorage; StoredSecret)
            {
                Caption = 'Secret in Isolated Storage';
                ApplicationArea = All;
                MultiLine = true;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(PrepareForTableExport)
            {
                Caption = 'Prepare for Table Export';
                ApplicationArea = All;
                Image = Action;

                trigger OnAction()
                var
                    SecretValue: Codeunit SecretValueAJK;
                begin
                    SecretValue.PrepareSecretValueTableForExport();
                end;
            }
            action(GetSecretValueFromTable)
            {
                Caption = 'Get Value fom Table';
                ApplicationArea = All;
                Image = Action;

                trigger OnAction()
                begin
                    Message(GetSecretTextValue());
                end;
            }
        }
    }

    var
        StoredSecret: Text;

    trigger OnOpenPage()
    var
        SecretValue: Codeunit SecretValueAJK;
    begin
        if not FindFirst() then
            Insert();
        StoredSecret := SecretValue.GetSecretValueFromIsolatedStorage();
    end;
}