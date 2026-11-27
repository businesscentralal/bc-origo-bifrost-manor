namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Implements Manor.User.Get and its bilingual discovery and contract.</summary>
codeunit 10035659 "Manor User Get Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;

    var
        KeywordsLbl: Label 'get manor user, find employee, user by email', Comment = 'is-IS=sækja Manor notanda, finna starfsmann, notandi eftir netfangi';
        CountLbl: Label 'Number of rows returned after local filtering.', Comment = 'is-IS=Fjöldi skilaðra færslna eftir staðbundna síun.';
        ResultLbl: Label 'Employees with id, name, email, enabled, owns_projects and approves_invoices.', Comment = 'is-IS=Starfsmenn með id, name, email, enabled, owns_projects og approves_invoices.';
        MetaLbl: Label 'Source-page metadata for lists; absent for single reads and ping.', Comment = 'is-IS=Lýsigögn upprunalegrar síðu fyrir lista; vantar við stakan lestur og tengipróf.';
        DescriptionLbl: Label 'Reads one Manor employee by user ID or email address.', Comment = 'is-IS=Les einn starfsmann í Manor eftir notandaauðkenni eða netfangi.';
        NotesLbl: Label 'Only enabled users can receive time entries. Project owners need owns_projects=true.', Comment = 'is-IS=Aðeins virkir notendur geta fengið tímafærslur. Verkefnaeigendur þurfa owns_projects=true.';
        userIdLbl: Label 'Positive Manor user ID. Send exactly one of userId and email.', Comment = 'is-IS=Jákvætt notandaauðkenni í Manor. Sendið annaðhvort userId eða email.';
        emailLbl: Label 'User email. Send exactly one of userId and email.', Comment = 'is-IS=Netfang notanda. Sendið annaðhvort userId eða email.';
        ResponseLbl: Label 'The result array contains canonical Manor fields. noOfRecords counts returned rows; meta describes the source page before local filtering.', Comment = 'is-IS=Fylkið result inniheldur staðlaða Manor-reiti. noOfRecords telur skilaðar færslur; meta lýsir upprunalegri síðu fyrir staðbundna síun.';
        EffectLbl: Label 'Reads Manor only; the connection test also records its successful time in setup.', Comment = 'is-IS=Les aðeins Manor; tengiprófið skráir einnig tíma heppnaðrar prófunar í uppsetningu.';

    /// <summary>Provides IsEnabled for Manor.User.Get.</summary>
    procedure IsEnabled(): Boolean
    var
        Shared: Codeunit "Manor Connection Test Impl ori";
    begin
        exit(Shared.IsEnabled());
    end;

    /// <summary>Provides GetFilterTableNo for Manor.User.Get.</summary>
    procedure GetFilterTableNo(): Integer
    begin
        exit(0);
    end;

    /// <summary>Provides GetDescription for Manor.User.Get.</summary>
    procedure GetDescription(): Text[250]
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Provides GetKeywords for Manor.User.Get.</summary>
    procedure GetKeywords(): Text
    begin
        exit(KeywordsLbl);
    end;

    /// <summary>Provides GetSelectionDescription for Manor.User.Get.</summary>
    procedure GetSelectionDescription(): Text
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Provides GetMessageDirection for Manor.User.Get.</summary>
    procedure GetMessageDirection(): Enum "Msg Direction ori"
    begin
        exit("Msg Direction ori"::Outbound);
    end;

    /// <summary>Provides ExecuteBifrostTask for Manor.User.Get.</summary>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        Setup: Record "Manor Setup ori";
        Shared: Codeunit "Manor Connection Test Impl ori";
        Client: Codeunit "Manor Client ori";
        Request: JsonObject;
    begin
        Argument.AssertIsLicensed();
        Argument.AssertVersion1();
        Setup.Get();
        Setup.ValidateSetup();
        Request := Argument.GetRequestJson();
        Shared.Respond(Argument, Client.GetRead(Shared.UserPath(Request), ''), true, false, false, '');
    end;

    /// <summary>Provides GetEnvelope for Manor.User.Get.</summary>
    procedure GetEnvelope(var Envelope: JsonObject): Boolean
    var
        Shared: Codeunit "Manor Connection Test Impl ori";
        Subject: JsonObject;
        Icelandic: JsonObject;
        SavedLanguage: Integer;
    begin
        Subject.Add('use', 'notUsed');
        Envelope.Add('subject', Subject);
        Envelope.Add('dataRequired', true);
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

    /// <summary>Provides GetTarget for Manor.User.Get.</summary>
    procedure GetTarget(var Target: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetParameters for Manor.User.Get.</summary>
    procedure GetParameters(var Parameters: JsonArray): Boolean
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
        Shared: Codeunit "Manor Connection Test Impl ori";
        Icelandic: JsonArray;
        SavedLanguage: Integer;
    begin
        Parameters.Add(ContractMgt.Parameter('userId', 'integer', false, userIdLbl));
        Parameters.Add(ContractMgt.Parameter('email', 'string', false, emailLbl));
        SavedLanguage := GlobalLanguage();
        GlobalLanguage(1039);
        Icelandic.Add(ContractMgt.Parameter('userId', 'integer', false, userIdLbl));
        Icelandic.Add(ContractMgt.Parameter('email', 'string', false, emailLbl));
        GlobalLanguage(SavedLanguage);
        Shared.MergeIcelandicParameters(Parameters, Icelandic);
        exit(true);
    end;

    /// <summary>Provides GetResponse for Manor.User.Get.</summary>
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

    /// <summary>Provides GetErrors for Manor.User.Get.</summary>
    procedure GetErrors(var Errors: JsonArray): Boolean
    var
        Shared: Codeunit "Manor Connection Test Impl ori";
    begin
        Shared.AddReadErrors(Errors);
        exit(true);
    end;

    /// <summary>Provides GetEffect for Manor.User.Get.</summary>
    procedure GetEffect(var Effect: JsonObject): Boolean
    begin
        Effect.Add('effect', 'read');
        Effect.Add('changes', EffectLbl);
        Effect.Add('idempotent', true);
        Effect.Add('permissionSet', 'BIFROST MnrRead ori');
        exit(true);
    end;

    /// <summary>Provides GetMetering for Manor.User.Get.</summary>
    procedure GetMetering(var Metering: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetRelated for Manor.User.Get.</summary>
    procedure GetRelated(var Related: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetWorkflow for Manor.User.Get.</summary>
    procedure GetWorkflow(var Workflow: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetExamples for Manor.User.Get.</summary>
    procedure GetExamples(var Examples: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetOverview for Manor.User.Get.</summary>
    procedure GetOverview(var Overview: Text): Boolean
    begin
        Overview := DescriptionLbl;
        exit(true);
    end;

    /// <summary>Provides GetNotes for Manor.User.Get.</summary>
    procedure GetNotes(var Notes: Text): Boolean
    begin
        Notes := NotesLbl;
        exit(true);
    end;
}
