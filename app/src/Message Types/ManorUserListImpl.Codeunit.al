namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Implements Manor.User.List and its bilingual discovery and contract.</summary>
codeunit 10035658 "Manor User List Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;

    var
        KeywordsLbl: Label 'list manor users, enabled employees, project owners', Comment = 'is-IS=sýna Manor notendur, virkir starfsmenn, eigendur verkefna';
        CountLbl: Label 'Number of rows returned after local filtering.', Comment = 'is-IS=Fjöldi skilaðra færslna eftir staðbundna síun.';
        ResultLbl: Label 'Employees with id, name, email, enabled, owns_projects and approves_invoices.', Comment = 'is-IS=Starfsmenn með id, name, email, enabled, owns_projects og approves_invoices.';
        MetaLbl: Label 'Source-page metadata for lists; absent for single reads and ping.', Comment = 'is-IS=Lýsigögn upprunalegrar síðu fyrir lista; vantar við stakan lestur og tengipróf.';
        DescriptionLbl: Label 'Lists Manor employees, optionally filtered by permissions and enabled status.', Comment = 'is-IS=Sýnir starfsmenn í Manor, valfrjálst síaða eftir heimildum og virkni.';
        NotesLbl: Label 'Only enabled users can receive time entries. Project owners need owns_projects=true. Omitted filters do not filter; enabledOnly=false also leaves all users.', Comment = 'is-IS=Aðeins virkir notendur geta fengið tímafærslur. Verkefnaeigendur þurfa owns_projects=true. Ótilgreindar síur sía ekki; enabledOnly=false sýnir einnig alla notendur.';
        pageLbl: Label 'Page number, at least 1. Default 1.', Comment = 'is-IS=Blaðsíðunúmer, minnst 1. Sjálfgefið 1.';
        perPageLbl: Label 'Rows per page, 1 to 100. Default 100.', Comment = 'is-IS=Færslur á blaðsíðu, 1 til 100. Sjálfgefið 100.';
        updatedsinceLbl: Label 'ISO 8601 timestamp for incremental reads, inclusive.', Comment = 'is-IS=ISO 8601 tímastimpill fyrir breytingalestur, að tímanum meðtöldum.';
        ownsprojectsLbl: Label 'Filter by permission to own projects; omitted means all.', Comment = 'is-IS=Sía eftir heimild til að eiga verkefni; ótilgreint sýnir alla.';
        approvesinvoicesLbl: Label 'Filter by permission to approve inbound invoices; omitted means all.', Comment = 'is-IS=Sía eftir heimild til að samþykkja móttekna reikninga; ótilgreint sýnir alla.';
        enabledOnlyLbl: Label 'True keeps only enabled users in Business Central; default false.', Comment = 'is-IS=True heldur aðeins virkum notendum í Business Central; sjálfgefið false.';
        ResponseLbl: Label 'The result array contains canonical Manor fields. noOfRecords counts returned rows; meta describes the source page before local filtering.', Comment = 'is-IS=Fylkið result inniheldur staðlaða Manor-reiti. noOfRecords telur skilaðar færslur; meta lýsir upprunalegri síðu fyrir staðbundna síun.';
        EffectLbl: Label 'Reads Manor only; the connection test also records its successful time in setup.', Comment = 'is-IS=Les aðeins Manor; tengiprófið skráir einnig tíma heppnaðrar prófunar í uppsetningu.';

    /// <summary>Provides IsEnabled for Manor.User.List.</summary>
    procedure IsEnabled(): Boolean
    var
        Shared: Codeunit "Manor Connection Test Impl ori";
    begin
        exit(Shared.IsEnabled());
    end;

    /// <summary>Provides GetFilterTableNo for Manor.User.List.</summary>
    procedure GetFilterTableNo(): Integer
    begin
        exit(0);
    end;

    /// <summary>Provides GetDescription for Manor.User.List.</summary>
    procedure GetDescription(): Text[250]
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Provides GetKeywords for Manor.User.List.</summary>
    procedure GetKeywords(): Text
    begin
        exit(KeywordsLbl);
    end;

    /// <summary>Provides GetSelectionDescription for Manor.User.List.</summary>
    procedure GetSelectionDescription(): Text
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Provides GetMessageDirection for Manor.User.List.</summary>
    procedure GetMessageDirection(): Enum "Msg Direction ori"
    begin
        exit("Msg Direction ori"::Outbound);
    end;

    /// <summary>Provides ExecuteBifrostTask for Manor.User.List.</summary>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        Setup: Record "Manor Setup ori";
        Shared: Codeunit "Manor Connection Test Impl ori";
        Client: Codeunit "Manor Client ori";
        QueryBuilder: Codeunit "Manor Query Builder ori";
        Request: JsonObject;
        EnabledOnly: Boolean;
    begin
        Argument.AssertIsLicensed();
        Argument.AssertVersion1();
        Setup.Get();
        Setup.ValidateSetup();
        Request := Argument.GetRequestJson();
        Shared.BuildPagingQuery(Request, QueryBuilder);
        if Request.Contains('owns_projects') then
            QueryBuilder.Add('owns_projects', Shared.ReadBoolean(Request, 'owns_projects'));
        if Request.Contains('approves_invoices') then
            QueryBuilder.Add('approves_invoices', Shared.ReadBoolean(Request, 'approves_invoices'));
        EnabledOnly := Shared.ReadBoolean(Request, 'enabledOnly');
        Shared.Respond(Argument, Client.GetRead('user', QueryBuilder.Build()), false, false, EnabledOnly, '');
    end;

    /// <summary>Provides GetEnvelope for Manor.User.List.</summary>
    procedure GetEnvelope(var Envelope: JsonObject): Boolean
    var
        Shared: Codeunit "Manor Connection Test Impl ori";
        Subject: JsonObject;
        Icelandic: JsonObject;
        SavedLanguage: Integer;
    begin
        Subject.Add('use', 'notUsed');
        Envelope.Add('subject', Subject);
        Envelope.Add('dataRequired', false);
        Envelope.Add('version', '1.0');
        Envelope.Add('contentType', 'text/json');
        SavedLanguage := GlobalLanguage();
        GlobalLanguage(1039);
        Icelandic.Add('overview', DescriptionLbl);
        Icelandic.Add('notes', NotesLbl);
        GlobalLanguage(SavedLanguage);
        Shared.AddIcelandic(Envelope, Icelandic);
        exit(true);
    end;

    /// <summary>Provides GetTarget for Manor.User.List.</summary>
    procedure GetTarget(var Target: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetParameters for Manor.User.List.</summary>
    procedure GetParameters(var Parameters: JsonArray): Boolean
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
        Shared: Codeunit "Manor Connection Test Impl ori";
        Icelandic: JsonArray;
        SavedLanguage: Integer;
    begin
        Parameters.Add(ContractMgt.Parameter('page', 'integer', false, pageLbl));
        Parameters.Add(ContractMgt.Parameter('perPage', 'integer', false, perPageLbl));
        Parameters.Add(ContractMgt.Parameter('updated_since', 'string', false, updatedsinceLbl));
        Parameters.Add(ContractMgt.Parameter('owns_projects', 'boolean', false, ownsprojectsLbl));
        Parameters.Add(ContractMgt.Parameter('approves_invoices', 'boolean', false, approvesinvoicesLbl));
        Parameters.Add(ContractMgt.Parameter('enabledOnly', 'boolean', false, enabledOnlyLbl));
        SavedLanguage := GlobalLanguage();
        GlobalLanguage(1039);
        Icelandic.Add(ContractMgt.Parameter('page', 'integer', false, pageLbl));
        Icelandic.Add(ContractMgt.Parameter('perPage', 'integer', false, perPageLbl));
        Icelandic.Add(ContractMgt.Parameter('updated_since', 'string', false, updatedsinceLbl));
        Icelandic.Add(ContractMgt.Parameter('owns_projects', 'boolean', false, ownsprojectsLbl));
        Icelandic.Add(ContractMgt.Parameter('approves_invoices', 'boolean', false, approvesinvoicesLbl));
        Icelandic.Add(ContractMgt.Parameter('enabledOnly', 'boolean', false, enabledOnlyLbl));
        GlobalLanguage(SavedLanguage);
        Shared.MergeIcelandicParameters(Parameters, Icelandic);
        exit(true);
    end;

    /// <summary>Provides GetResponse for Manor.User.List.</summary>
    procedure GetResponse(var Response: JsonObject): Boolean
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
        Shared: Codeunit "Manor Connection Test Impl ori";
        Fields: JsonArray;
        Icelandic: JsonObject;
        IcelandicFields: JsonArray;
        SavedLanguage: Integer;
    begin
        Response.Add('shape', '{"status":"Success","noOfRecords":N,"result":[{}],"meta":{}}');
        Response.Add('description', ResponseLbl);
        Fields.Add(ContractMgt.ResponseField('noOfRecords', 'integer', CountLbl));
        Fields.Add(ContractMgt.ResponseField('result', 'array', ResultLbl));
        Fields.Add(ContractMgt.ResponseField('meta', 'object', MetaLbl));
        Response.Add('fields', Fields);
        SavedLanguage := GlobalLanguage();
        GlobalLanguage(1039);
        Icelandic.Add('description', ResponseLbl);
        IcelandicFields.Add(ContractMgt.ResponseField('noOfRecords', 'integer', CountLbl));
        IcelandicFields.Add(ContractMgt.ResponseField('result', 'array', ResultLbl));
        IcelandicFields.Add(ContractMgt.ResponseField('meta', 'object', MetaLbl));
        Icelandic.Add('fields', IcelandicFields);
        GlobalLanguage(SavedLanguage);
        Shared.AddIcelandic(Response, Icelandic);
        exit(true);
    end;

    /// <summary>Provides GetErrors for Manor.User.List.</summary>
    procedure GetErrors(var Errors: JsonArray): Boolean
    var
        Shared: Codeunit "Manor Connection Test Impl ori";
    begin
        Shared.AddReadErrors(Errors);
        exit(true);
    end;

    /// <summary>Provides GetEffect for Manor.User.List.</summary>
    procedure GetEffect(var Effect: JsonObject): Boolean
    begin
        Effect.Add('effect', 'read');
        Effect.Add('changes', EffectLbl);
        Effect.Add('idempotent', true);
        Effect.Add('permissionSet', 'BIFROST MnrRead ori');
        exit(true);
    end;

    /// <summary>Provides GetMetering for Manor.User.List.</summary>
    procedure GetMetering(var Metering: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetRelated for Manor.User.List.</summary>
    procedure GetRelated(var Related: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetWorkflow for Manor.User.List.</summary>
    procedure GetWorkflow(var Workflow: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetExamples for Manor.User.List.</summary>
    procedure GetExamples(var Examples: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetOverview for Manor.User.List.</summary>
    procedure GetOverview(var Overview: Text): Boolean
    begin
        Overview := DescriptionLbl;
        exit(true);
    end;

    /// <summary>Provides GetNotes for Manor.User.List.</summary>
    procedure GetNotes(var Notes: Text): Boolean
    begin
        Notes := NotesLbl;
        exit(true);
    end;
}
