table 70455525 SecretValueAJK
{
    Access = Internal;
    DataPerCompany = false;

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; SecretValue1; Blob)
        {
            Caption = 'Secret Value 1';
            DataClassification = SystemMetadata;
            // Compressed = true;
        }
        field(3; SecretValue2; Blob)
        {
            Caption = 'Secret Value 2';
            DataClassification = SystemMetadata;
            // Compressed = true;
        }
        field(4; SecretValue3; Blob)
        {
            Caption = 'Secret Value 3';
            DataClassification = SystemMetadata;
            // Compressed = true;
        }
    }

    [NonDebuggable]
    procedure SetSecretTextValue(Id: Integer; TextValue: Text)
    var
        OutStr: OutStream;
    begin
        case Id of
            1:
                SecretValue1.CreateOutStream(OutStr);
            2:
                SecretValue2.CreateOutStream(OutStr);
            3:
                SecretValue3.CreateOutStream(OutStr);
        end;
        OutStr.WriteText(TextValue);
    end;

    [NonDebuggable]
    procedure GetSecretTextValue(Id: Integer) TextValue: Text
    var
        InStr: InStream;
    begin
        case Id of
            1:
                begin
                    if not SecretValue1.HasValue() then
                        exit;
                    CalcFields(SecretValue1);
                    SecretValue1.CreateInStream(InStr);
                end;
            2:
                begin
                    if not SecretValue2.HasValue() then
                        exit;
                    CalcFields(SecretValue2);
                    SecretValue2.CreateInStream(InStr);
                end;
            3:
                begin
                    if not SecretValue3.HasValue() then
                        exit;
                    CalcFields(SecretValue3);
                    SecretValue3.CreateInStream(InStr);
                end;
        end;
        InStr.ReadText(TextValue);
    end;
}
