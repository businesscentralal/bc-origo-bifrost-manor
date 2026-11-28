namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Implements Manor.Firm.List and its bilingual discovery and contract.</summary>
codeunit 10035657 "Manor Firm List Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;

    var
        KeywordsLbl: Label 'list manor firms, issuing firms, manor currency', Comment = 'is-IS=sýna Manor fyrirtæki, útgáfufyrirtæki, gjaldmiðill Manor';
        CountLbl: Label 'Number of rows returned after local filtering.', Comment = 'is-IS=Fjöldi skilaðra færslna eftir staðbundna síun.';
        ResultLbl: Label 'Issuing firms with id, name, currency_code, default_vat_rate_id and peppol_identifier.', Comment = 'is-IS=Útgáfufyrirtæki með id, name, currency_code, default_vat_rate_id og peppol_identifier.';
        MetaLbl: Label 'Source-page metadata for lists; absent for single reads and ping.', Comment = 'is-IS=Lýsigögn upprunalegrar síðu fyrir lista; vantar við stakan lestur og tengipróf.';
        DescriptionLbl: Label 'Lists issuing firms and their default currency, VAT rate and Peppol identifier.', Comment = 'is-IS=Sýnir útgáfufyrirtæki og sjálfgefinn gjaldmiðil þeirra, VSK-hlutfall og Peppol-auðkenni.';
        NotesLbl: Label 'default_vat_rate_id is the only VAT rate ID exposed by the Manor API.', Comment = 'is-IS=default_vat_rate_id er eina auðkenni VSK-hlutfalls sem Manor API birtir.';
        pageLbl: Label 'Page number, at least 1. Default 1.', Comment = 'is-IS=Blaðsíðunúmer, minnst 1. Sjálfgefið 1.';
        perPageLbl: Label 'Rows per page, 1 to 100. Default 100.', Comment = 'is-IS=Færslur á blaðsíðu, 1 til 100. Sjálfgefið 100.';
        updatedsinceLbl: Label 'ISO 8601 timestamp for incremental reads, inclusive.', Comment = 'is-IS=ISO 8601 tímastimpill fyrir breytingalestur, að tímanum meðtöldum.';
        ResponseLbl: Label 'The result array contains canonical Manor fields. noOfRecords counts returned rows; meta describes the source page before local filtering.', Comment = 'is-IS=Fylkið result inniheldur staðlaða Manor-reiti. noOfRecords telur skilaðar færslur; meta lýsir upprunalegri síðu fyrir staðbundna síun.';
        EffectLbl: Label 'Reads Manor only; the connection test also records its successful time in setup.', Comment = 'is-IS=Les aðeins Manor; tengiprófið skráir einnig tíma heppnaðrar prófunar í uppsetningu.';

    /// <summary>Provides IsEnabled for Manor.Firm.List.</summary>
    procedure IsEnabled(): Boolean
    var
        Shared: Codeunit "Manor Connection Test Impl ori";
    begin
        exit(Shared.IsEnabled());
    end;

    /// <summary>Provides GetFilterTableNo for Manor.Firm.List.</summary>
    procedure GetFilterTableNo(): Integer
    begin
        exit(0);
    end;

    /// <summary>Provides GetDescription for Manor.Firm.List.</summary>
    procedure GetDescription(): Text[250]
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Provides GetKeywords for Manor.Firm.List.</summary>
    procedure GetKeywords(): Text
    begin
        exit(KeywordsLbl);
    end;

    /// <summary>Provides GetSelectionDescription for Manor.Firm.List.</summary>
    procedure GetSelectionDescription(): Text
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Provides GetMessageDirection for Manor.Firm.List.</summary>
    procedure GetMessageDirection(): Enum "Msg Direction ori"
    begin
        exit("Msg Direction ori"::Outbound);
    end;

    /// <summary>Provides ExecuteBifrostTask for Manor.Firm.List.</summary>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        Setup: Record "Manor Setup ori";
        Shared: Codeunit "Manor Connection Test Impl ori";
        Client: Codeunit "Manor Client ori";
        QueryBuilder: Codeunit "Manor Query Builder ori";
        Request: JsonObject;
    begin
        Argument.AssertIsLicensed();
        Argument.AssertVersion1();
        Setup.Get();
        Setup.ValidateSetup();
        Request := Argument.GetRequestJson();
        Shared.BuildPagingQuery(Request, QueryBuilder);
        Shared.Respond(Argument, Client.GetRead('firm', QueryBuilder.Build()), false, false, false, '');
    end;

    /// <summary>Provides GetEnvelope for Manor.Firm.List.</summary>
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

    /// <summary>Provides GetTarget for Manor.Firm.List.</summary>
    procedure GetTarget(var Target: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetParameters for Manor.Firm.List.</summary>
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
        SavedLanguage := GlobalLanguage();
        GlobalLanguage(1039);
        Icelandic.Add(ContractMgt.Parameter('page', 'integer', false, pageLbl));
        Icelandic.Add(ContractMgt.Parameter('perPage', 'integer', false, perPageLbl));
        Icelandic.Add(ContractMgt.Parameter('updated_since', 'string', false, updatedsinceLbl));
        GlobalLanguage(SavedLanguage);
        Shared.MergeIcelandicParameters(Parameters, Icelandic);
        exit(true);
    end;

    /// <summary>Provides GetResponse for Manor.Firm.List.</summary>
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

    /// <summary>Provides GetErrors for Manor.Firm.List.</summary>
    procedure GetErrors(var Errors: JsonArray): Boolean
    var
        Shared: Codeunit "Manor Connection Test Impl ori";
    begin
        Shared.AddReadErrors(Errors);
        exit(true);
    end;

    /// <summary>Provides GetEffect for Manor.Firm.List.</summary>
    procedure GetEffect(var Effect: JsonObject): Boolean
    begin
        Effect.Add('effect', 'read');
        Effect.Add('changes', EffectLbl);
        Effect.Add('idempotent', true);
        Effect.Add('permissionSet', 'BIFROST MnrRead ori');
        exit(true);
    end;

    /// <summary>Provides GetMetering for Manor.Firm.List.</summary>
    procedure GetMetering(var Metering: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetRelated for Manor.Firm.List.</summary>
    procedure GetRelated(var Related: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetWorkflow for Manor.Firm.List.</summary>
    procedure GetWorkflow(var Workflow: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetExamples for Manor.Firm.List.</summary>
    procedure GetExamples(var Examples: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetOverview for Manor.Firm.List.</summary>
    procedure GetOverview(var Overview: Text): Boolean
    begin
        Overview := DescriptionLbl;
        exit(true);
    end;

    /// <summary>Provides GetNotes for Manor.Firm.List.</summary>
    procedure GetNotes(var Notes: Text): Boolean
    begin
        Notes := NotesLbl;
        exit(true);
    end;
}
