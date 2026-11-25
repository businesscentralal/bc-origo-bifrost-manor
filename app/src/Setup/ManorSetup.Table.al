namespace Origo.Bifrost.Manor;

/// <summary>Company-specific configuration; credentials are held only in IsolatedStorage.</summary>
table 10035641 "Manor Setup ori"
{
    Caption = 'Manor Setup', Comment = 'is-IS=Uppsetning Manor';
    DataClassification = SystemMetadata;
    LookupPageId = "Manor Setup ori";
    DrillDownPageId = "Manor Setup ori";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key', Comment = 'is-IS=Aðallykill';
        }
        field(2; Environment; Enum "Manor Environment ori")
        {
            Caption = 'Environment', Comment = 'is-IS=Umhverfi';
            ToolTip = 'Specifies whether to use production, a test instance, or mock responses.', Comment = 'is-IS=Tilgreinir hvort nota á raun umhverfi, prófunartilvik eða sýndarsvör.';
            InitValue = Mock;
        }
        field(3; Instance; Text[100])
        {
            Caption = 'Instance', Comment = 'is-IS=Tilvik';
            ToolTip = 'Specifies the Manor instance identifier. Use only letters A-Z, digits, hyphens and underscores.', Comment = 'is-IS=Tilgreinir auðkenni Manor-tilviks. Notið aðeins stafina A-Z, tölustafi, bandstrik og undirstrik.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateInstance(Instance);
            end;
        }
        field(4; Enabled; Boolean)
        {
            Caption = 'Enabled', Comment = 'is-IS=Virkt';
            ToolTip = 'Specifies whether the Manor connection is enabled.', Comment = 'is-IS=Tilgreinir hvort tengingin við Manor sé virk.';
        }
        field(5; "Last Connection Test"; DateTime)
        {
            Caption = 'Last Connection Test', Comment = 'is-IS=Síðasta tengiprófun';
            ToolTip = 'Specifies when the connection was last tested.', Comment = 'is-IS=Tilgreinir hvenær tengingin var síðast prófuð.';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        TestField("Primary Key", '');
        ValidateInstance(Instance);
    end;

    trigger OnModify()
    begin
        ValidateInstance(Instance);
    end;

    trigger OnRename()
    begin
        Error(SingletonErr);
    end;

    trigger OnDelete()
    var
        Secrets: Codeunit "Manor Secrets ori";
    begin
        if IsTemporary() then
            exit;
        if CurrentCompany() <> CompanyName() then
            Error(CompanyErr);
        Secrets.ClearApiKey();
    end;

    var
        RecordHasBeenRead: Boolean;
        CompanyErr: Label 'Open the company before deleting its Manor Setup.', Comment = 'is-IS=Opnaðu fyrirtækið áður en uppsetningu Manor þess er eytt.';
        SingletonErr: Label 'Manor Setup must use a single record per company.', Comment = 'is-IS=Uppsetning Manor verður að nota eina færslu fyrir hvert fyrirtæki.';
        InvalidInstanceErr: Label 'The Manor instance may contain only letters A-Z, digits, hyphens and underscores, up to 100 characters.', Comment = 'is-IS=Manor-tilvikið má aðeins innihalda stafina A-Z, tölustafi, bandstrik og undirstrik, að hámarki 100 stafi.';
        DisabledErr: Label 'Enable the Manor connection in Manor Setup.', Comment = 'is-IS=Virkjaðu tenginguna við Manor í uppsetningu Manor.';
        MissingInstanceErr: Label 'Enter the Manor instance in Manor Setup.', Comment = 'is-IS=Sláðu inn Manor-tilvikið í uppsetningu Manor.';
        MissingKeyErr: Label 'Set the API key in Manor Setup.', Comment = 'is-IS=Stilltu API-lykilinn í uppsetningu Manor.';

    /// <summary>Loads the singleton once, creating the disabled mock configuration if needed.</summary>
    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        if not Get() then begin
            Init();
            Insert(true);
        end;
        RecordHasBeenRead := true;
    end;

    /// <summary>Checks the instance path segment without echoing its contents in errors.</summary>
    procedure ValidateInstance(Value: Text)
    begin
        if (StrLen(Value) > MaxStrLen(Instance)) or
           (DelChr(Value, '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_') <> '')
        then
            Error(InvalidInstanceErr);
    end;

    /// <summary>Checks all configuration needed for the selected environment.</summary>
    procedure ValidateSetup()
    var
        Secrets: Codeunit "Manor Secrets ori";
    begin
        if not Enabled then
            Error(DisabledErr);
        if Environment = Environment::Mock then
            exit;
        if Instance = '' then
            Error(MissingInstanceErr);
        ValidateInstance(Instance);
        if not Secrets.HasApiKey() then
            Error(MissingKeyErr);
    end;
}
