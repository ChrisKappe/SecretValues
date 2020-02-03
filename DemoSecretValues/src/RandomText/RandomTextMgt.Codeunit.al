codeunit 60253 RandomTextMgtAJK
{
    procedure GenerateRandomText(Length: Integer) RandomText: Text
    var
        Chars: List of [Char];
        RandomTextBuilder: TextBuilder;
        RandomChar: Char;
        i: Integer;
    begin
        GetListOfCharacters(Chars);
        Randomize();
        for i := 1 to Length do begin
            Chars.Get(Random(Chars.Count()), RandomChar);
            RandomTextBuilder.Append(RandomChar);
        end;
        RandomText := RandomTextBuilder.ToText();
    end;

    local procedure GetListOfCharacters(var Chars: List of [Char])
    var
        i: Integer;
    begin
        for i := 33 to 126 do
            if i <> 92 then
                Chars.Add(i);
    end;
}