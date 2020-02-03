page 60261 TestSecretValueAJK
{
    Caption = 'Test Secret Value';
    PageType = NavigatePage;
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(StandardBannerGroup)
            {
                Editable = false;
                Visible = TopBannerVisible AND (CurrentStep = 1);
                field(MediaResourcesStandardControl; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = ' ';
                }
            }
            group(InfoBannerGroup)
            {
                Editable = false;
                Visible = TopBannerVisible AND (CurrentStep = 2);
                field(MediaResourcesInfoControl; MediaResourcesInfo."Media Reference")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = ' ';
                }
            }
            group(FinishedBannerGroup)
            {
                Editable = false;
                Visible = TopBannerVisible AND (CurrentStep = 3);
                field(MediaResourcesDoneControl; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = ' ';
                }
            }

            group(Step1)
            {
                Visible = CurrentStep = 1;
                ShowCaption = false;
                group(SecretValueGroup)
                {
                    Caption = 'Secret Value';
                    InstructionalText = 'Please enter the secret value and click Next to test it.';
                    field(SecretValueControl; SecretValueInput)
                    {
                        ApplicationArea = All;
                        Caption = 'Secret Value';
                        ToolTip = 'Secret value';
                    }
                }
            }

            group(Step2)
            {
                Visible = CurrentStep = 2;
                ShowCaption = false;
                group(IncorrectSecretValueGroup)
                {
                    Caption = 'Incorrect Value';
                    InstructionalText = 'Unfortunately you have not entered the correct secret value. Try again!';
                    field(SecretValueControl2; SecretValueInput)
                    {
                        ApplicationArea = All;
                        Caption = 'Secret Value';
                        ToolTip = 'Secret value';
                        Editable = false;
                    }
                }
            }
            group(Step3)
            {
                Visible = CurrentStep = 3;
                ShowCaption = false;
                group(CorrectSecretValueGroup)
                {
                    Caption = 'Correct Value';
                    InstructionalText = 'Congratulations! You have entered the correct secret value!';
                    field(SecretValueControl3; SecretValueInput)
                    {
                        ApplicationArea = All;
                        Caption = 'Secret Value';
                        ToolTip = 'Secret value';
                        Editable = false;
                    }
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                ToolTip = ' ';
                Enabled = ActionBackAllowed;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    if CurrentStep = 2 then
                        TakeStep(-1)
                    else
                        TakeStep(-2);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                ToolTip = ' ';
                Enabled = ActionNextAllowed;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    TakeStep(1);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                ToolTip = ' ';
                Enabled = ActionFinishAllowed;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        MediaRepository: Record "Media Repository";
        MediaResourcesStandard: Record "Media Resources";
        MediaResourcesInfo: Record "Media Resources";
        MediaResourcesDone: Record "Media Resources";
        SecretValueInput: Text;
        CurrentStep: Integer;
        ActionBackAllowed: Boolean;
        ActionNextAllowed: Boolean;
        ActionFinishAllowed: Boolean;
        TopBannerVisible: Boolean;

    trigger OnInit()
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage()
    begin
        CurrentStep := 1;
        SetControls();
    end;

    local procedure SetControls()
    begin
        ActionNextAllowed := CurrentStep = 1;
        ActionBackAllowed := CurrentStep > 1;
        ActionFinishAllowed := CurrentStep = 3;
    end;

    local procedure TakeStep(Step: Integer)
    begin
        if CurrentStep = 1 then
            CurrentStep += TestSecretValueInput()
        else
            CurrentStep += Step;
        SetControls();
    end;

    [NonDebuggable]
    local procedure TestSecretValueInput(): Integer
    var
        SecretValue: Codeunit SecretValueAJK;
    begin
        if SecretValueInput = '' then
            exit(0);
        if SecretValueInput = SecretValue.GetSecretValueFromIsolatedStorage() then
            exit(2)
        else
            exit(1);
    end;

    local procedure LoadTopBanners()
    begin

        if MediaRepository.GET('AssistedSetup-NoText-400px.png', Format(CurrentClientType())) then
            if MediaResourcesStandard.Get(MediaRepository."Media Resources Ref") then;

        if MediaRepository.Get('AssistedSetupInfo-NoText.png', Format(CurrentClientType())) then
            if MediaResourcesInfo.Get(MediaRepository."Media Resources Ref") then;

        if MediaRepository.Get('AssistedSetupDone-NoText-400px.png', Format(CurrentClientType())) then
            if MediaResourcesDone.Get(MediaRepository."Media Resources Ref") then;

        TopBannerVisible := MediaResourcesStandard."Media Reference".HasValue() or
                            MediaResourcesInfo."Media Reference".HasValue() or
                            MediaResourcesDone."Media Reference".HasValue();
    end;
}