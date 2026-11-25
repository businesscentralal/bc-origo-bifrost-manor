namespace Origo.Bifrost.Manor;

/// <summary>Manages the current company's Manor connection without displaying credentials.</summary>
page 10035642 "Manor Setup ori"
{
    PageType = Card;
    SourceTable = "Manor Setup ori";
    Caption = 'Manor Setup', Comment = 'is-IS=Uppsetning Manor';
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'is-IS=Almennt';
                field(Environment; Rec.Environment) { ApplicationArea = All; }
                field(Instance; Rec.Instance) { ApplicationArea = All; }
                field(Enabled; Rec.Enabled) { ApplicationArea = All; }
                field(HasApiKey; HasApiKey)
                {
                    ApplicationArea = All;
                    Caption = 'Has API Key', Comment = 'is-IS=API-lykill til staðar';
                    ToolTip = 'Specifies whether an API key is stored for this company.', Comment = 'is-IS=Tilgreinir hvort API-lykill sé vistaður fyrir þetta fyrirtæki.';
                    Editable = false;
                }
                field("Last Connection Test"; Rec."Last Connection Test") { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SetApiKey)
            {
                ApplicationArea = All;
                Caption = 'Set API Key', Comment = 'is-IS=Stilla API-lykil';
                ToolTip = 'Stores a new API key for this company without showing the existing key.', Comment = 'is-IS=Vistar nýjan API-lykil fyrir þetta fyrirtæki án þess að birta eldri lykil.';
                Image = Setup;
                AccessByPermission = tabledata "Manor Setup ori" = M;
                trigger OnAction()
                var
                    KeyDialog: Page "Manor API Key ori";
                begin
                    KeyDialog.RunModal();
                    RefreshKeyStatus();
                end;
            }
            action(ClearApiKey)
            {
                ApplicationArea = All;
                Caption = 'Clear API Key', Comment = 'is-IS=Fjarlægja API-lykil';
                ToolTip = 'Removes the API key stored for this company.', Comment = 'is-IS=Fjarlægir API-lykilinn sem vistaður er fyrir þetta fyrirtæki.';
                Image = Delete;
                AccessByPermission = tabledata "Manor Setup ori" = M;
                trigger OnAction()
                var
                    Secrets: Codeunit "Manor Secrets ori";
                begin
                    Secrets.ClearApiKey();
                    RefreshKeyStatus();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'is-IS=Vinna';
                actionref(SetApiKey_Promoted; SetApiKey) { }
                actionref(ClearApiKey_Promoted; ClearApiKey) { }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.GetRecordOnce();
        CurrPage.Editable(Rec.WritePermission());
    end;
    trigger OnAfterGetCurrRecord()
    begin
        RefreshKeyStatus();
    end;
    var
        HasApiKey: Boolean;

    local procedure RefreshKeyStatus()
    var
        Secrets: Codeunit "Manor Secrets ori";
    begin
        HasApiKey := Secrets.HasApiKey();
    end;
}
