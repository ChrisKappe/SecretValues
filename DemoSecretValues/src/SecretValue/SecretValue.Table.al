table 60250 SecretValueAJK
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
            Compressed = true;
        }
        field(3; SecretValue2; Blob)
        {
            Caption = 'Secret Value 2';
            DataClassification = SystemMetadata;
            Compressed = true;
        }
        field(4; SecretValue3; Blob)
        {
            Caption = 'Secret Value 3';
            DataClassification = SystemMetadata;
            Compressed = true;
        }
    }

    [NonDebuggable]
    internal procedure SetSecretTextValue(TextValue: Text)
    begin
        DeleteAll();
        Obfuscate(TextValue);
        Insert();
    end;

    [NonDebuggable]
    internal procedure GetSecretTextValue() TextValue: Text
    begin
        TextValue := Deobfuscate();
    end;

    internal procedure GetSecretValueAsText(Id: Integer) TextValue: Text
    var
        Bytes: List of [Byte];
    begin
        GetSecretBytes(Id, Bytes);
        TextValue := ConvertBytesToText(Bytes);
    end;

    [NonDebuggable]
    procedure GetSecretBytes(Id: Integer; var Bytes: List of [Byte])
    var
        InStr: InStream;
        CurrByte: Byte;
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

        Clear(Bytes);
        while not InStr.EOS() do begin
            InStr.Read(CurrByte);
            Bytes.Add(CurrByte);
        end;
    end;

    [NonDebuggable]
    local procedure SetSecretValue(Id: Integer; Bytes: List of [Byte])
    var
        OutStr: OutStream;
        CurrByte: Byte;
    begin
        case Id of
            1:
                SecretValue1.CreateOutStream(OutStr);
            2:
                SecretValue2.CreateOutStream(OutStr);
            3:
                SecretValue3.CreateOutStream(OutStr);
        end;
        foreach CurrByte in Bytes do
            OutStr.Write(CurrByte);
    end;

    [NonDebuggable]
    local procedure Obfuscate(TextValue: Text)
    var
        RandomTextMgt: Codeunit RandomTextMgtAJK;
        SecretValue1List: List of [Byte];
        SecretValue2List: List of [Byte];
        SecretValue3List: List of [Byte];
    begin
        ConvertTextToBytes(TextValue, SecretValue1List);
        ConvertTextToBytes(RandomTextMgt.GenerateRandomText(StrLen(TextValue)), SecretValue2List);
        Sleep(1000);  // To enforce real random values
        ConvertTextToBytes(RandomTextMgt.GenerateRandomText(StrLen(TextValue)), SecretValue3List);

        SecretValue1List.Reverse();
        XORSecretValues(SecretValue1List, SecretValue2List, SecretValue3List);

        SetSecretValue(1, SecretValue1List);
        SetSecretValue(2, SecretValue2List);
        SetSecretValue(3, SecretValue3List);
    end;

    [NonDebuggable]
    local procedure Deobfuscate() TextValue: Text
    var
        SecretValue1List: List of [Byte];
        SecretValue2List: List of [Byte];
        SecretValue3List: List of [Byte];
    begin
        GetSecretBytes(1, SecretValue1List);
        GetSecretBytes(2, SecretValue2List);
        GetSecretBytes(3, SecretValue3List);

        XORSecretValues(SecretValue1List, SecretValue2List, SecretValue3List);
        SecretValue1List.Reverse();
        TextValue := ConvertBytesToText(SecretValue1List);
    end;

    local procedure XORSecretValues(
        var SecretValue1List: List of [Byte];
        SecretValue2List: List of [Byte];
        SecretValue3List: List of [Byte])
    var
        Index: Integer;
        SecretValueResult: List of [Byte];
        Byte1: Byte;
        Byte2: Byte;
    begin
        foreach Byte1 in SecretValue1List do begin
            Index += 1;
            if Index mod 2 <> 0 then
                SecretValue2List.Get(Index, Byte2)
            else
                SecretValue3List.Get(Index, Byte2);
            SecretValueResult.Add(XORBytes(Byte1, Byte2));
        end;
        Clear(SecretValue1List);
        SecretValue1List := SecretValueResult;
    end;

    [NonDebuggable]
    local procedure ConvertTextToBytes(TextValue: Text; var Bytes: List of [Byte])
    var
        i: Integer;
    begin
        Clear(Bytes);
        for i := 1 to StrLen(TextValue) do
            Bytes.Add(TextValue[i]);
    end;

    [NonDebuggable]
    local procedure ConvertBytesToText(Bytes: List of [Byte]) TextValue: Text
    var
        CurrByte: Byte;
        TextBuilder: TextBuilder;
    begin
        foreach CurrByte in Bytes do
            TextBuilder.Append(Format(CurrByte));
        TextValue := TextBuilder.ToText();
    end;

    local procedure XORBytes(Byte1: Byte; Byte2: Byte) ReturnValue: Byte
    var
        Binary1: Text;
        Binary2: Text;
        Bool1: Boolean;
        Bool2: Boolean;
        i: Integer;
        XORValue: Text;
    begin
        Binary1 := ByteToBinary(Byte1);
        Binary2 := ByteToBinary(Byte2);

        for i := 1 to 8 do begin
            Evaluate(Bool1, Binary1[i]);
            Evaluate(Bool2, Binary2[i]);
            XORValue += Format(Bool1 xor Bool2, 0, 2);
        end;
        ReturnValue := BinaryToByte(XORValue);
    end;

    local procedure ByteToBinary(Value: Byte) ReturnValue: Text;
    begin
        while Value >= 1 do begin
            ReturnValue := Format(Value MOD 2) + ReturnValue;
            Value := Value DIV 2;
        end;
        ReturnValue := ReturnValue.PadLeft(8, '0');
    end;

    local procedure BinaryToByte(Value: Text) ReturnValue: Byte;
    var
        Multiplier: Integer;
        IntValue: Integer;
        i: Integer;
    begin
        Multiplier := 1;
        for i := StrLen(Value) downto 1 do begin
            Evaluate(IntValue, Value.Substring(i, 1));
            ReturnValue += IntValue * Multiplier;
            Multiplier *= 2;
        end;
    end;
}
