namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Implements Manor.Rate.List and its bilingual discovery and contract.</summary>
codeunit 10035660 "Manor Rate List Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;

    var
        KeywordsLbl: Label 'list manor rates, time rates, mileage rates', Comment = 'is-IS=sýna Manor taxta, tímataxtar, aksturstextar';
        CountLbl: Label 'Number of rows returned after local filtering.', Comment = 'is-IS=Fjöldi skilaðra færslna eftir staðbundna síun.';
        ResultLbl: Label 'Rates with id, name, type, price and latest_price. Special terms are not exposed by Manor.', Comment = 'is-IS=Taxtar með id, name, type, price og latest_price. Manor birtir ekki sérkjör.';
        MetaLbl: Label 'Source-page metadata for lists; absent for single reads and ping.', Comment = 'is-IS=Lýsigögn upprunalegrar síðu fyrir lista; vantar við stakan lestur og tengipróf.';
        DescriptionLbl: Label 'Lists Manor rates; prices exclude client and project special terms.', Comment = 'is-IS=Sýnir taxta í Manor; verð inniheldur ekki sérkjör viðskiptavina og verkefna.';
        NotesLbl: Label 'Requires manage_rates (Manor administrator role). price is the base price; latest_price is the current price period. Special terms can override both, so neither is necessarily the billed price. Mileage uses the canonical type travel.', Comment = 'is-IS=Krefst manage_rates (Stjórnandi í Manor). price er grunnverð; latest_price er núverandi verðtímabil. Sérkjör geta yfirskrifað bæði og því er hvorugt endilega innheimt verð. Akstur notar staðlaða gerðina travel.';
        pageLbl: Label 'Page number, at least 1. Default 1.', Comment = 'is-IS=Blaðsíðunúmer, minnst 1. Sjálfgefið 1.';
        perPageLbl: Label 'Rows per page, 1 to 100. Default 100.', Comment = 'is-IS=Færslur á blaðsíðu, 1 til 100. Sjálfgefið 100.';
        updatedsinceLbl: Label 'ISO 8601 timestamp for incremental reads, inclusive.', Comment = 'is-IS=ISO 8601 tímastimpill fyrir breytingalestur, að tímanum meðtöldum.';
        typeLbl: Label 'Rate type: time, travel (mileage), product or per_diem. Applied in Business Central.', Comment = 'is-IS=Gerð taxta: time (vinna), travel (akstur), product (söluvara) eða per_diem (dagpeningar). Síað í Business Central.';
        ResponseLbl: Label 'The result array contains canonical Manor fields. noOfRecords counts returned rows; meta describes the source page before local filtering.', Comment = 'is-IS=Fylkið result inniheldur staðlaða Manor-reiti. noOfRecords telur skilaðar færslur; meta lýsir upprunalegri síðu fyrir staðbundna síun.';
        EffectLbl: Label 'Reads Manor only; the connection test also records its successful time in setup.', Comment = 'is-IS=Les aðeins Manor; tengiprófið skráir einnig tíma heppnaðrar prófunar í uppsetningu.';

    /// <summary>Provides IsEnabled for Manor.Rate.List.</summary>
    procedure IsEnabled(): Boolean
    var
        Shared: Codeunit "Manor Connection Test Impl ori";
    begin
        exit(Shared.IsEnabled());
    end;

    /// <summary>Provides GetFilterTableNo for Manor.Rate.List.</summary>
    procedure GetFilterTableNo(): Integer
    begin
        exit(0);
    end;

    /// <summary>Provides GetDescription for Manor.Rate.List.</summary>
    procedure GetDescription(): Text[250]
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Provides GetKeywords for Manor.Rate.List.</summary>
    procedure GetKeywords(): Text
    begin
        exit(KeywordsLbl);
    end;

    /// <summary>Provides GetSelectionDescription for Manor.Rate.List.</summary>
    procedure GetSelectionDescription(): Text
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Provides GetMessageDirection for Manor.Rate.List.</summary>
    procedure GetMessageDirection(): Enum "Msg Direction ori"
    begin
        exit("Msg Direction ori"::Outbound);
    end;

    /// <summary>Provides ExecuteBifrostTask for Manor.Rate.List.</summary>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        Setup: Record "Manor Setup ori";
        Shared: Codeunit "Manor Connection Test Impl ori";
        Client: Codeunit "Manor Client ori";
        QueryBuilder: Codeunit "Manor Query Builder ori";
        Request: JsonObject;
        RateType: Text;
    begin
        Argument.AssertIsLicensed();
        Argument.AssertVersion1();
        Setup.Get();
        Setup.ValidateSetup();
        Request := Argument.GetRequestJson();
        Shared.BuildPagingQuery(Request, QueryBuilder);
        RateType := Shared.ReadText(Request, 'type');
        Shared.ValidateRateType(Request, RateType);
        Shared.Respond(Argument, Client.GetRead('rate', QueryBuilder.Build()), false, false, false, RateType);
    end;

    /// <summary>Provides GetEnvelope for Manor.Rate.List.</summary>
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

    /// <summary>Provides GetTarget for Manor.Rate.List.</summary>
    procedure GetTarget(var Target: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetParameters for Manor.Rate.List.</summary>
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
        Parameters.Add(ContractMgt.Parameter('type', 'string', false, typeLbl));
        SavedLanguage := GlobalLanguage();
        GlobalLanguage(1039);
        Icelandic.Add(ContractMgt.Parameter('page', 'integer', false, pageLbl));
        Icelandic.Add(ContractMgt.Parameter('perPage', 'integer', false, perPageLbl));
        Icelandic.Add(ContractMgt.Parameter('updated_since', 'string', false, updatedsinceLbl));
        Icelandic.Add(ContractMgt.Parameter('type', 'string', false, typeLbl));
        GlobalLanguage(SavedLanguage);
        Shared.MergeIcelandicParameters(Parameters, Icelandic);
        exit(true);
    end;

    /// <summary>Provides GetResponse for Manor.Rate.List.</summary>
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

    /// <summary>Provides GetErrors for Manor.Rate.List.</summary>
    procedure GetErrors(var Errors: JsonArray): Boolean
    var
        Shared: Codeunit "Manor Connection Test Impl ori";
    begin
        Shared.AddReadErrors(Errors);
        exit(true);
    end;

    /// <summary>Provides GetEffect for Manor.Rate.List.</summary>
    procedure GetEffect(var Effect: JsonObject): Boolean
    begin
        Effect.Add('effect', 'read');
        Effect.Add('changes', EffectLbl);
        Effect.Add('idempotent', true);
        Effect.Add('permissionSet', 'BIFROST MnrRead ori');
        exit(true);
    end;

    /// <summary>Provides GetMetering for Manor.Rate.List.</summary>
    procedure GetMetering(var Metering: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetRelated for Manor.Rate.List.</summary>
    procedure GetRelated(var Related: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetWorkflow for Manor.Rate.List.</summary>
    procedure GetWorkflow(var Workflow: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetExamples for Manor.Rate.List.</summary>
    procedure GetExamples(var Examples: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetOverview for Manor.Rate.List.</summary>
    procedure GetOverview(var Overview: Text): Boolean
    begin
        Overview := DescriptionLbl;
        exit(true);
    end;

    /// <summary>Provides GetNotes for Manor.Rate.List.</summary>
    procedure GetNotes(var Notes: Text): Boolean
    begin
        Notes := NotesLbl;
        exit(true);
    end;
}
