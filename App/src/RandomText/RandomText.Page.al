page 70455526 RandomTextAJK
{
    Caption = 'Random Text';
    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(RandomTextLengthControl; RandomTextLength)
            {
                Caption = 'Length';
                ToolTip = ' ';
                ApplicationArea = All;
                MinValue = 1;
            }
            field(RandomTextControl; RandomText)
            {
                Caption = 'Random Text';
                ToolTip = ' ';
                ApplicationArea = All;
                Editable = false;
                MultiLine = true;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetRandomTextAction)
            {
                Caption = 'Get Random Text';
                ToolTip = ' ';
                ApplicationArea = All;
                Image = NumberSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    RandomTextMgt: Codeunit RandomTextMgtAJK;
                begin
                    RandomText := RandomTextMgt.GenerateRandomText(RandomTextLength);
                end;
            }
        }
    }

    var
        RandomText: Text;
        RandomTextLength: Integer;

    trigger OnOpenPage()
    begin
        RandomTextLength := 25;
    end;

}