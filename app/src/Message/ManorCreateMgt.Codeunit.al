namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Validates one Manor create, prepares defaults and returns its canonical payload or result.</summary>
codeunit 10035650 "Manor Create Mgt ori"
{
    Access = Internal;

    var
        InvalidErr: Label 'Invalid or missing parameter %1.', Comment = '%1 = parameter name; is-IS=Ógild færibreyta eða færibreytu vantar: %1.';
        CountErr: Label 'expectedCount must be 1. No Manor request was sent.', Comment = 'is-IS=expectedCount verður að vera 1. Engin beiðni var send til Manor.';
        HoursErr: Label 'hours must be greater than zero and no more than 24.', Comment = 'is-IS=hours verður að vera stærra en núll og ekki meira en 24.';
        BillableErr: Label 'billable_hours cannot exceed hours or be negative.', Comment = 'is-IS=billable_hours má ekki vera meira en hours eða neikvætt.';
        MidnightErr: Label 'The time entry cannot cross midnight UTC.', Comment = 'is-IS=Tímafærslan má ekki ná yfir miðnætti UTC.';
        RateErr: Label 'The selected rate must exist and have type time.', Comment = 'is-IS=Valinn taxti verður að vera til og hafa tegundina time.';
        VatErr: Label 'The firm has no default VAT rate. Supply vat_rate_id.', Comment = 'is-IS=Fyrirtækið hefur engan sjálfgefinn VSK-taxta. Tilgreindu vat_rate_id.';
        FirmErr: Label 'Supply firm_id to select the firm whose default VAT rate should be used.', Comment = 'is-IS=Tilgreindu firm_id til að velja fyrirtækið sem sjálfgefinn VSK-taxti er sóttur frá.';
        ResponseErr: Label 'Manor returned an unexpected response. Check Manor before retrying a create.', Comment = 'is-IS=Manor skilaði óvæntu svari. Athugaðu Manor áður en stofnun er reynd aftur.';
        DisabledErr: Label 'Enable the Manor connection in Manor Setup.', Comment = 'is-IS=Virkjaðu tenginguna við Manor í uppsetningu Manor.';
        PermissionErr: Label 'The BIFROST MnrFull ori permission set is required.', Comment = 'is-IS=Heimildasamstæðan BIFROST MnrFull ori er nauðsynleg.';

    /// <summary>Checks the caller's write role before any request.</summary>
    procedure CanWrite(): Boolean
    var
        Setup: Record "Manor Setup ori";
    begin
        exit(Setup.WritePermission());
    end;

    /// <summary>Executes a single create after validating every input and resolving permitted defaults.</summary>
    procedure Execute(var Argument: Record "Message Argument ori"; Entity: Text; RequiredPermission: Text; Payload: JsonObject)
    var
        Setup: Record "Manor Setup ori";
        Client: Codeunit "Manor Client ori";
        Request: JsonObject;
        Response: JsonObject;
        Result: JsonArray;
        Created: JsonObject;
        Token: JsonToken;
        Path: Text;
        Body: Text;
        DryRun: Boolean;
    begin
        Argument.AssertIsLicensed();
        Argument.AssertVersion1();
        if not CanWrite() then
            Error(PermissionErr);
        Request := Argument.GetRequestJson();
        ValidateScalar(Request, 'expectedCount', 'integer', true);
        if Request.GetInteger('expectedCount') <> 1 then
            Error(CountErr);
        ValidateScalar(Request, 'projectId', 'integer', true);
        if Request.GetBigInteger('projectId') <= 0 then
            Error(InvalidErr, 'projectId');
        ValidateScalar(Request, 'dryRun', 'boolean', false);
        if Request.Get('dryRun', Token) then
            DryRun := Token.AsValue().AsBoolean();
        ValidatePayload(Payload, Entity);
        if not Setup.Get() then
            Error(DisabledErr);
        if not Setup.Enabled then
            Error(DisabledErr);
        case Entity of
            'time':
                ValidateTime(Payload);
            'expense':
                DefaultVat(Payload);
        end;
        Path := '/project/' + Format(Request.GetBigInteger('projectId'), 0, 9) + '/' + Entity;
        Payload.WriteTo(Body);
        Response.Add('status', 'Success');
        Response.Add('dryRun', DryRun);
        if DryRun then begin
            Response.Add('noOfRecords', 0);
            Response.Add('method', 'POST');
            Response.Add('path', Path);
            Response.Add('payload', Payload);
        end else begin
            if not Created.ReadFrom(Client.Post(Path, Body, RequiredPermission)) then
                Error(ResponseErr);
            // A time create may wrap its resource in data; product and expense are bare resources.
            if Created.Get('data', Token) then begin
                if not Token.IsObject() then
                    Error(ResponseErr);
                Created := Token.AsObject();
            end;
            if not Created.Get('id', Token) then
                Error(ResponseErr);
            if not Token.IsValue() then
                Error(ResponseErr);
            if Token.AsValue().IsNull() then
                Error(ResponseErr);
            Result.Add(Created);
            Response.Add('noOfRecords', 1);
        end;
        Response.Add('result', Result);
        Argument.SetResponseJson(Response);
    end;

    /// <summary>Checks controls and refuses undeclared fields before copying the canonical payload.</summary>
    procedure CheckCommonRequest(AllowedFields: Text; Request: JsonObject)
    var
        FieldName: Text;
    begin
        ValidateScalar(Request, 'expectedCount', 'integer', true);
        if Request.GetInteger('expectedCount') <> 1 then
            Error(CountErr);
        ValidateScalar(Request, 'projectId', 'integer', true);
        if Request.GetBigInteger('projectId') <= 0 then
            Error(InvalidErr, 'projectId');
        ValidateScalar(Request, 'dryRun', 'boolean', false);
        foreach FieldName in Request.Keys() do
            if not HasKey('projectId,expectedCount,dryRun,' + AllowedFields, FieldName) then
                Error(InvalidErr, FieldName);
    end;

    local procedure ValidatePayload(Payload: JsonObject; Entity: Text)
    var
        FieldName: Text;
        Integers: Text;
        Token: JsonToken;
        ParsedDate: Date;
        ParsedDateTime: DateTime;
        DateText: Text;
    begin
        Integers := 'activity_id,user_id,rate_id';
        if Entity = 'expense' then
            Integers := 'activity_id,user_id,firm_id,vat_rate_id';
        foreach FieldName in Integers.Split(',') do
            if Payload.Get(FieldName, Token) then
                if Token.AsValue().AsBigInteger() <= 0 then
                    Error(InvalidErr, FieldName);
        if Entity = 'product' then begin
            DateText := Payload.GetText('date');
            if not Evaluate(ParsedDate, DateText, 9) then
                Error(InvalidErr, 'date');
            if (ParsedDate = 0D) or (Format(ParsedDate, 0, 9) <> DateText) then
                Error(InvalidErr, 'date');
            if Payload.Get('custom_discount', Token) then
                if (Token.AsValue().AsDecimal() < 0) or (Token.AsValue().AsDecimal() > 100) then
                    Error(InvalidErr, 'custom_discount');
        end;
        if Entity = 'expense' then begin
            DateText := Payload.GetText('paid_at');
            if not HasTimeZone(DateText) then
                Error(InvalidErr, 'paid_at');
            if not Evaluate(ParsedDateTime, DateText, 9) then
                Error(InvalidErr, 'paid_at');
            if StrLen(Payload.GetText('paid_in_currency_code')) <> 3 then
                Error(InvalidErr, 'paid_in_currency_code');
        end;
    end;

    local procedure HasKey(Keys: Text; KeyName: Text): Boolean
    begin
        exit(StrPos(',' + Keys + ',', ',' + KeyName + ',') > 0);
    end;

    local procedure HasTimeZone(Value: Text): Boolean
    begin
        if StrLen(Value) < 20 then
            exit(false);
        exit((CopyStr(Value, StrLen(Value), 1) = 'Z') or
            (StrPos(CopyStr(Value, 20), '+') > 0) or (StrPos(CopyStr(Value, 20), '-') > 0));
    end;

    /// <summary>Validates and copies one declared payload field, omitting optional nulls.</summary>
    procedure CopyField(Request: JsonObject; KeyName: Text; var Payload: JsonObject; Kind: Text; Required: Boolean)
    var
        Token: JsonToken;
    begin
        ValidateScalar(Request, KeyName, Kind, Required);
        if Request.Get(KeyName, Token) then
            if not Token.AsValue().IsNull() then
                Payload.Add(KeyName, Token.Clone());
    end;

    local procedure ValidateScalar(Request: JsonObject; KeyName: Text; Kind: Text; Required: Boolean)
    var
        Token: JsonToken;
        Encoded: Text;
        DecimalValue: Decimal;
        IntegerValue: BigInteger;
    begin
        if not Request.Get(KeyName, Token) then begin
            if Required then
                Error(InvalidErr, KeyName);
            exit;
        end;
        if not Token.IsValue() then
            Error(InvalidErr, KeyName);
        if Token.AsValue().IsNull() then begin
            if Required or (KeyName = 'dryRun') then
                Error(InvalidErr, KeyName);
            exit;
        end;
        Token.WriteTo(Encoded);
        case Kind of
            'string': begin
                if CopyStr(Encoded, 1, 1) <> '"' then
                    Error(InvalidErr, KeyName);
                if Required and (Token.AsValue().AsText().Trim() = '') then
                    Error(InvalidErr, KeyName);
            end;
            'boolean':
                if not (Encoded in ['true', 'false']) then
                    Error(InvalidErr, KeyName);
            'number', 'integer': begin
                if CopyStr(Encoded, 1, 1) = '"' then
                    Error(InvalidErr, KeyName);
                if not Evaluate(DecimalValue, Encoded, 9) then
                    Error(InvalidErr, KeyName);
                if Kind = 'integer' then
                    if not Evaluate(IntegerValue, Encoded, 9) then
                        Error(InvalidErr, KeyName);
            end;
        end;
    end;

    local procedure ValidateTime(var Payload: JsonObject)
    var
        Token: JsonToken;
        StartsAt: DateTime;
        EndsAt: DateTime;
        Hours: Decimal;
        TextValue: Text;
    begin
        Hours := Payload.GetDecimal('hours');
        if (Hours <= 0) or (Hours > 24) then
            Error(HoursErr);
        if Payload.Get('billable_hours', Token) then
            if (Token.AsValue().AsDecimal() > Hours) or (Token.AsValue().AsDecimal() < 0) then
                Error(BillableErr);
        TextValue := Payload.GetText('begins_at');
        if not HasTimeZone(TextValue) then
            Error(InvalidErr, 'begins_at');
        if not Evaluate(StartsAt, TextValue, 9) then
            Error(InvalidErr, 'begins_at');
        Payload.Replace('begins_at', Format(StartsAt, 0, 9));
        // Compare UTC dates, independently of the BC session time zone. Ending at midnight is allowed.
        EndsAt := StartsAt + Round(Hours * 3600000, 1);
        if CopyStr(Format(StartsAt, 0, 9), 1, 10) <> CopyStr(Format(EndsAt - 1, 0, 9), 1, 10) then
            Error(MidnightErr);
        if Payload.Get('rate_id', Token) then
            CheckRate(Token.AsValue().AsBigInteger());
    end;

    local procedure CheckRate(RateId: BigInteger)
    var
        Client: Codeunit "Manor Client ori";
        PageJson: JsonObject;
        Token: JsonToken;
        Item: JsonToken;
        PageNo: Integer;
        LastPage: Integer;
    begin
        // Manor exposes no GET /rate/{id}; find this ID in the paginated catalogue.
        PageNo := 1;
        repeat
            ReadPage(Client.Get('/rate', 'per_page=100&page=' + Format(PageNo, 0, 9)), PageJson, LastPage);
            PageJson.Get('data', Token);
            foreach Item in Token.AsArray() do
                if Item.AsObject().GetBigInteger('id') = RateId then begin
                    if Item.AsObject().GetText('type') <> 'time' then
                        Error(RateErr);
                    exit;
                end;
            PageNo += 1;
        until (PageNo > LastPage) or (PageNo > 100);
        Error(RateErr);
    end;

    local procedure DefaultVat(var Payload: JsonObject)
    var
        Client: Codeunit "Manor Client ori";
        PageJson: JsonObject;
        Firm: JsonObject;
        Token: JsonToken;
        Item: JsonToken;
        FirmId: BigInteger;
        PageNo: Integer;
        LastPage: Integer;
        Matches: Integer;
    begin
        if Payload.Contains('vat_rate_id') then
            exit;
        if Payload.Get('firm_id', Token) then
            FirmId := Token.AsValue().AsBigInteger();
        PageNo := 1;
        repeat
            ReadPage(Client.Get('/firm', 'per_page=100&page=' + Format(PageNo, 0, 9)), PageJson, LastPage);
            PageJson.Get('data', Token);
            foreach Item in Token.AsArray() do
                if (FirmId = 0) or (Item.AsObject().GetBigInteger('id') = FirmId) then begin
                    Firm := Item.AsObject();
                    Matches += 1;
                    if (Matches > 1) and (FirmId = 0) then
                        Error(FirmErr);
                end;
            PageNo += 1;
        until (PageNo > LastPage) or (PageNo > 100) or ((FirmId <> 0) and (Matches = 1));
        if (FirmId = 0) and (PageNo <= LastPage) then
            Error(FirmErr);
        if Matches <> 1 then
            Error(VatErr);
        if not Firm.Get('default_vat_rate_id', Token) then
            Error(VatErr);
        if not Token.IsValue() then
            Error(VatErr);
        if Token.AsValue().IsNull() then
            Error(VatErr);
        if Token.AsValue().AsBigInteger() <= 0 then
            Error(VatErr);
        Payload.Add('vat_rate_id', Token);
    end;

    local procedure ReadPage(Body: Text; var PageJson: JsonObject; var LastPage: Integer)
    var
        Token: JsonToken;
        Meta: JsonToken;
    begin
        Clear(PageJson);
        if not PageJson.ReadFrom(Body) then
            Error(ResponseErr);
        if not PageJson.Get('data', Token) then
            Error(ResponseErr);
        if not Token.IsArray() then
            Error(ResponseErr);
        LastPage := 1;
        if PageJson.Get('meta', Meta) then
            if Meta.IsObject() then
                if Meta.AsObject().Get('last_page', Token) then
                    if not Token.AsValue().IsNull() then
                        LastPage := Token.AsValue().AsInteger();
    end;
}
