namespace Origo.Bifrost.Manor;

using Origo.Bifrost;
using System.Reflection;

/// <summary>Implements Manor.Connection.Test and its bilingual discovery and contract.</summary>
codeunit 10035656 "Manor Connection Test Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;
    Permissions = tabledata "Manor Setup ori" = m;

    var
        KeywordsLbl: Label 'test manor connection, ping manor, manor connectivity', Comment = 'is-IS=prófa Manor tengingu, tengipróf Manor, tenging við Manor';
        CountLbl: Label 'Number of rows returned after local filtering.', Comment = 'is-IS=Fjöldi skilaðra færslna eftir staðbundna síun.';
        ResultLbl: Label 'One row with ok=true and the Manor message, when present.', Comment = 'is-IS=Ein færsla með ok=true og skilaboðum Manor, ef þau eru til staðar.';
        MetaLbl: Label 'Source-page metadata for lists; absent for single reads and ping.', Comment = 'is-IS=Lýsigögn upprunalegrar síðu fyrir lista; vantar við stakan lestur og tengipróf.';
        InvalidParameterErr: Label 'Invalid value for %1.', Comment = '%1 = parameter name; is-IS=Ógilt gildi fyrir %1.';
        InvalidResponseErr: Label 'Manor returned an invalid response.', Comment = 'is-IS=Manor skilaði ógildu svari.';
        InvalidRateTypeErr: Label 'type must be time, travel, product or per_diem.', Comment = 'is-IS=type verður að vera time, travel, product eða per_diem.';
        UserTargetErr: Label 'Send exactly one of userId and email.', Comment = 'is-IS=Sendið annaðhvort userId eða email.';
        InputErrorLbl: Label 'A parameter has the wrong type or value, or the user target is missing or ambiguous.', Comment = 'is-IS=Viðfang hefur ranga gerð eða gildi, eða notandamarkmið vantar eða er tvírætt.';
        InputFixLbl: Label 'Follow the parameters chapter. Rate type must be time, travel, product or per_diem.', Comment = 'is-IS=Fylgið kaflanum um viðföng. Gerð taxta verður að vera time, travel, product eða per_diem.';
        UpstreamErrorLbl: Label 'Manor returns 401/403, 404, 422, an invalid response, or is unavailable after one retry.', Comment = 'is-IS=Manor skilar 401/403, 404, 422, ógildu svari eða er ekki tiltækt eftir eina endurtilraun.';
        UpstreamFixLbl: Label 'Check the key and permissions (manage_rates for rates), the user target and the request; retry temporary failures.', Comment = 'is-IS=Athugið lykil og heimildir (manage_rates fyrir taxta), notandamarkmið og beiðnina; endurtakið tímabundnar bilanir.';
        DescriptionLbl: Label 'Tests the Manor connection; a successful ping does not prove resource permissions.', Comment = 'is-IS=Prófar tengingu við Manor; heppnað tengipróf staðfestir ekki heimildir á gögnum.';
        NotesLbl: Label 'An administrator creates the API key; it acts as that Manor user within its own instance. A successful ping updates Last Connection Test only.', Comment = 'is-IS=Kerfisstjóri stofnar API-lykilinn; hann notar heimildir þess notanda í eigin tilviki. Heppnað tengipróf uppfærir aðeins síðustu tengiprófun.';
        ResponseLbl: Label 'The result array contains canonical Manor fields. noOfRecords counts returned rows; meta describes the source page before local filtering.', Comment = 'is-IS=Fylkið result inniheldur staðlaða Manor-reiti. noOfRecords telur skilaðar færslur; meta lýsir upprunalegri síðu fyrir staðbundna síun.';
        EffectLbl: Label 'Reads Manor only; the connection test also records its successful time in setup.', Comment = 'is-IS=Les aðeins Manor; tengiprófið skráir einnig tíma heppnaðrar prófunar í uppsetningu.';

    /// <summary>Provides IsEnabled for Manor.Connection.Test.</summary>
    procedure IsEnabled(): Boolean
    begin
        exit(CanReadSetup());
    end;

    /// <summary>Provides GetFilterTableNo for Manor.Connection.Test.</summary>
    procedure GetFilterTableNo(): Integer
    begin
        exit(0);
    end;

    /// <summary>Provides GetDescription for Manor.Connection.Test.</summary>
    procedure GetDescription(): Text[250]
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Provides GetKeywords for Manor.Connection.Test.</summary>
    procedure GetKeywords(): Text
    begin
        exit(KeywordsLbl);
    end;

    /// <summary>Provides GetSelectionDescription for Manor.Connection.Test.</summary>
    procedure GetSelectionDescription(): Text
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Provides GetMessageDirection for Manor.Connection.Test.</summary>
    procedure GetMessageDirection(): Enum "Msg Direction ori"
    begin
        exit("Msg Direction ori"::Outbound);
    end;

    /// <summary>Provides ExecuteBifrostTask for Manor.Connection.Test.</summary>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        Setup: Record "Manor Setup ori";
        Shared: Codeunit "Manor Connection Test Impl ori";
        Client: Codeunit "Manor Client ori";
    begin
        Argument.AssertIsLicensed();
        Argument.AssertVersion1();
        Setup.Get();
        Setup.ValidateSetup();
        Shared.Respond(Argument, Client.GetRead('ping', ''), true, true, false, '');
        Setup."Last Connection Test" := CurrentDateTime();
        Setup.Modify(true);
    end;

    /// <summary>Provides GetEnvelope for Manor.Connection.Test.</summary>
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

    /// <summary>Provides GetTarget for Manor.Connection.Test.</summary>
    procedure GetTarget(var Target: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetParameters for Manor.Connection.Test.</summary>
    procedure GetParameters(var Parameters: JsonArray): Boolean
    begin
        exit(true);
    end;

    /// <summary>Provides GetResponse for Manor.Connection.Test.</summary>
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

    /// <summary>Provides GetErrors for Manor.Connection.Test.</summary>
    procedure GetErrors(var Errors: JsonArray): Boolean
    var
        Shared: Codeunit "Manor Connection Test Impl ori";
    begin
        Shared.AddReadErrors(Errors);
        exit(true);
    end;

    /// <summary>Provides GetEffect for Manor.Connection.Test.</summary>
    procedure GetEffect(var Effect: JsonObject): Boolean
    begin
        Effect.Add('effect', 'read');
        Effect.Add('changes', EffectLbl);
        Effect.Add('idempotent', true);
        Effect.Add('permissionSet', 'BIFROST MnrRead ori');
        exit(true);
    end;

    /// <summary>Provides GetMetering for Manor.Connection.Test.</summary>
    procedure GetMetering(var Metering: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetRelated for Manor.Connection.Test.</summary>
    procedure GetRelated(var Related: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetWorkflow for Manor.Connection.Test.</summary>
    procedure GetWorkflow(var Workflow: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetExamples for Manor.Connection.Test.</summary>
    procedure GetExamples(var Examples: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Provides GetOverview for Manor.Connection.Test.</summary>
    procedure GetOverview(var Overview: Text): Boolean
    begin
        Overview := DescriptionLbl;
        exit(true);
    end;

    /// <summary>Provides GetNotes for Manor.Connection.Test.</summary>
    procedure GetNotes(var Notes: Text): Boolean
    begin
        Notes := NotesLbl;
        exit(true);
    end;

    local procedure CanReadSetup(): Boolean
    var
        Setup: Record "Manor Setup ori";
    begin
        exit(Setup.ReadPermission());
    end;

    /// <summary>Builds paging and incremental-read parameters for a list.</summary>
    internal procedure BuildPagingQuery(Request: JsonObject; var QueryBuilder: Codeunit "Manor Query Builder ori")
    var
        UpdatedSince: Text;
        Timestamp: DateTime;
    begin
        QueryBuilder.Add('page', ReadInteger(Request, 'page', 1, 2147483647));
        QueryBuilder.Add('per_page', ReadInteger(Request, 'perPage', 100, 100));
        UpdatedSince := ReadText(Request, 'updated_since');
        if UpdatedSince <> '' then begin
            if not Evaluate(Timestamp, UpdatedSince, 9) then
                Error(InvalidParameterErr, 'updated_since');
            QueryBuilder.Add('updated_since', Timestamp);
        end;
    end;

    /// <summary>Rejects unknown rate types before making any request.</summary>
    internal procedure ValidateRateType(Request: JsonObject; RateType: Text)
    begin
        if Request.Contains('type') and not (RateType in ['time', 'travel', 'product', 'per_diem']) then
            Error(InvalidRateTypeErr);
    end;

    /// <summary>Maps a successful response into the Bifrost envelope and applies local filters.</summary>
    internal procedure Respond(var Argument: Record "Message Argument ori"; Body: Text; Single: Boolean; Ping: Boolean; EnabledOnly: Boolean; RateType: Text)
    var
        Source: JsonObject;
        Reply: JsonObject;
        Result: JsonArray;
        Rows: JsonArray;
        Token: JsonToken;
        Item: JsonToken;
        Meta: JsonToken;
    begin
        if not Source.ReadFrom(Body) then
            Error(InvalidResponseErr);
        if Single then begin
            if Ping then
                if Source.Contains('ok') then
                    Source.Replace('ok', true)
                else
                    Source.Add('ok', true);
            Result.Add(Source);
        end else begin
            if not (Source.Get('data', Token) and Token.IsArray()) then
                Error(InvalidResponseErr);
            Rows := Token.AsArray();
            foreach Item in Rows do begin
                if not Item.IsObject() then
                    Error(InvalidResponseErr);
                if MatchesFilters(Item.AsObject(), EnabledOnly, RateType) then
                    Result.Add(Item.Clone());
            end;
            if Source.Get('meta', Meta) then
                Reply.Add('meta', Meta.Clone());
        end;
        Reply.Add('status', 'Success');
        Reply.Add('noOfRecords', Result.Count());
        Reply.Add('result', Result);
        Argument.SetResponseJson(Reply);
        Argument."Content Type" := Argument.GetContentTypeJson();
    end;

    local procedure MatchesFilters(Row: JsonObject; EnabledOnly: Boolean; RateType: Text): Boolean
    var
        Token: JsonToken;
    begin
        if EnabledOnly then begin
            if not Row.Get('enabled', Token) then
                exit(false);
            if not ReadBoolean(Row, 'enabled') then
                exit(false);
        end;
        if RateType <> '' then
            exit(ReadText(Row, 'type') = RateType);
        exit(true);
    end;

    /// <summary>Validates and reads UserPath without echoing caller values.</summary>
    internal procedure UserPath(Request: JsonObject): Text
    var
        TypeHelper: Codeunit "Type Helper";
        Token: JsonToken;
        UserId: BigInteger;
        Serialized: Text;
        Email: Text;
    begin
        if Request.Contains('userId') = Request.Contains('email') then
            Error(UserTargetErr);
        if Request.Get('userId', Token) then begin
            Token.WriteTo(Serialized);
            if DelChr(Serialized, '=', '0123456789') <> '' then
                Error(InvalidParameterErr, 'userId');
            if not Evaluate(UserId, Serialized, 9) then
                Error(InvalidParameterErr, 'userId');
            if UserId <= 0 then
                Error(InvalidParameterErr, 'userId');
            exit('user/' + Format(UserId, 0, 9));
        end;
        Email := ReadText(Request, 'email');
        if (Email = '') or (StrPos(Email, '@') <= 1) then
            Error(InvalidParameterErr, 'email');
        exit('user/' + TypeHelper.UriEscapeDataString(Email));
    end;

    /// <summary>Validates and reads ReadText without echoing caller values.</summary>
    internal procedure ReadText(Request: JsonObject; Name: Text): Text
    var
        Token: JsonToken;
        Serialized: Text;
    begin
        if not Request.Get(Name, Token) then
            exit('');
        Token.WriteTo(Serialized);
        if not Token.IsValue() or (CopyStr(Serialized, 1, 1) <> '"') then
            Error(InvalidParameterErr, Name);
        exit(Token.AsValue().AsText());
    end;

    /// <summary>Validates and reads ReadBoolean without echoing caller values.</summary>
    internal procedure ReadBoolean(Request: JsonObject; Name: Text): Boolean
    var
        Token: JsonToken;
        Serialized: Text;
    begin
        if not Request.Get(Name, Token) then
            exit(false);
        Token.WriteTo(Serialized);
        if not (Serialized in ['true', 'false']) then
            Error(InvalidParameterErr, Name);
        exit(Token.AsValue().AsBoolean());
    end;

    local procedure ReadInteger(Request: JsonObject; Name: Text; DefaultValue: Integer; Maximum: Integer): Integer
    var
        Token: JsonToken;
        Serialized: Text;
        Value: Integer;
    begin
        if not Request.Get(Name, Token) then
            exit(DefaultValue);
        Token.WriteTo(Serialized);
        if DelChr(Serialized, '=', '0123456789') <> '' then
            Error(InvalidParameterErr, Name);
        if not Evaluate(Value, Serialized, 9) then
            Error(InvalidParameterErr, Name);
        if (Value < 1) or (Value > Maximum) then
            Error(InvalidParameterErr, Name);
        exit(Value);
    end;

    /// <summary>Adds an Icelandic translation alongside the canonical contract chapter.</summary>
    internal procedure AddIcelandic(var Entry: JsonObject; Icelandic: JsonObject)
    var
        Translations: JsonObject;
    begin
        Translations.Add('is-IS', Icelandic);
        Entry.Add('translations', Translations);
    end;

    /// <summary>Adds translated parameter descriptions without changing stable parameter names.</summary>
    internal procedure MergeIcelandicParameters(var Parameters: JsonArray; Icelandic: JsonArray)
    var
        Entry: JsonToken;
        Translated: JsonToken;
        Parameter: JsonObject;
        Index: Integer;
    begin
        for Index := 0 to Parameters.Count() - 1 do begin
            Parameters.Get(Index, Entry);
            Icelandic.Get(Index, Translated);
            Parameter := Entry.AsObject();
            AddIcelandic(Parameter, Translated.AsObject());
        end;
    end;

    /// <summary>Declares localized input and sanitized upstream error paths.</summary>
    internal procedure AddReadErrors(var Errors: JsonArray)
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
        InputError: JsonObject;
        UpstreamError: JsonObject;
        Icelandic: JsonObject;
        SavedLanguage: Integer;
    begin
        InputError := ContractMgt.ErrorEntry("Bifrost Error Code ori"::BusinessCentralError, InputErrorLbl, InputFixLbl);
        UpstreamError := ContractMgt.ErrorEntry("Bifrost Error Code ori"::BusinessCentralError, UpstreamErrorLbl, UpstreamFixLbl);
        SavedLanguage := GlobalLanguage();
        GlobalLanguage(1039);
        Icelandic := ContractMgt.ErrorEntry("Bifrost Error Code ori"::BusinessCentralError, InputErrorLbl, InputFixLbl);
        AddIcelandic(InputError, Icelandic);
        Clear(Icelandic);
        Icelandic := ContractMgt.ErrorEntry("Bifrost Error Code ori"::BusinessCentralError, UpstreamErrorLbl, UpstreamFixLbl);
        AddIcelandic(UpstreamError, Icelandic);
        GlobalLanguage(SavedLanguage);
        Errors.Add(InputError);
        Errors.Add(UpstreamError);
    end;
}
