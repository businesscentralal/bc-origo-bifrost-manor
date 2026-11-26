namespace Origo.Bifrost.Manor;

/// <summary>Accepts a new masked credential and stores it only when the user confirms.</summary>
page 10035647 "Manor API Key ori"
{
    PageType = StandardDialog;
    Caption = 'Set API Key', Comment = 'is-IS=Stilla API-lykil';
    Extensible = false;
    layout
    {
        area(Content)
        {
            field(ApiKeyInput; ApiKeyInput)
            {
                ApplicationArea = All;
                Caption = 'API Key', Comment = 'is-IS=API-lykill';
                ToolTip = 'Specifies the new API key. The stored key is never displayed.', Comment = 'is-IS=Tilgreinir nýja API-lykilinn. Vistaði lykillinn er aldrei birtur.';
                ExtendedDatatype = Masked;
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Secrets: Codeunit "Manor Secrets ori";
        ApiKey: SecretText;
    begin
        if CloseAction = Action::OK then begin
            ApiKey := ApiKeyInput;
            Clear(ApiKeyInput);
            Secrets.SetApiKey(ApiKey);
            Clear(ApiKey);
        end;
        Clear(ApiKeyInput);
        exit(true);
    end;
    var
        ApiKeyInput: Text;
}
