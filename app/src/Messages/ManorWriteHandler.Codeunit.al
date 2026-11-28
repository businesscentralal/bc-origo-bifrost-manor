namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Validates Manor write requests, enforces expectedCount, then calls Manor through the Manor client.</summary>
codeunit 10035678 "Manor Write Handler ori"
{
    Access = Internal;

    var
        RequestMissingLbl: Label 'The request contains no records.', Comment = 'is-IS=Beiðnin inniheldur engar færslur.';
        ExpectedCountMissingLbl: Label 'Send expectedCount as a whole number of 1 or more.', Comment = 'is-IS=Sendu expectedCount sem heila tölu, 1 eða hærri.';
        ExpectedCountMismatchLbl: Label 'expectedCount is %1 but the request contains %2 record(s). Nothing was sent to Manor.', Comment = '%1 = expected; %2 = actual; is-IS=expectedCount er %1 en beiðnin inniheldur %2 færslur. Ekkert var sent til Manor.';
        ReadContractLbl: Label 'Read the message contract with get_message_type_help and correct the request.', Comment = 'is-IS=Lestu skilgreiningu skilaboðagerðarinnar með get_message_type_help og leiðréttu beiðnina.';
        MissingFieldLbl: Label 'The field %1 is required.', Comment = '%1 = field name; is-IS=Reiturinn %1 er nauðsynlegur.';
        UnknownFieldLbl: Label 'The field %1 is not accepted by this message type.', Comment = '%1 = field name; is-IS=Þessi skilaboðagerð tekur ekki við reitnum %1.';
        BooleanFieldLbl: Label 'The field %1 must be true or false.', Comment = '%1 = field name; is-IS=Reiturinn %1 verður að vera true eða false.';
        TextFieldLbl: Label 'The field %1 must be text.', Comment = '%1 = field name; is-IS=Reiturinn %1 verður að vera texti.';
        BillingLbl: Label 'billing must be one of: enabled, internal, sensitive.', Comment = 'is-IS=billing verður að vera eitt af: enabled, internal, sensitive.';
        CurrencyFlagLbl: Label 'Changing currency_code needs confirmCurrencyChange=true. The currency applies to all the client''s projects and invoices. Nothing was updated.', Comment = 'is-IS=Til að breyta currency_code þarf confirmCurrencyChange=true. Gjaldmiðillinn gildir um öll verkefni og reikninga viðskiptavinarins. Engu var breytt.';
        DuplicateLbl: Label 'A Manor client with national_id %1 already exists (client id %2). Nothing was created.', Comment = '%1 = national id; %2 = client id; is-IS=Viðskiptavinur í Manor með national_id %1 er þegar til (auðkenni %2). Engu var stofnað.';
        ConfirmFieldTxt: Label 'confirmCurrencyChange', Locked = true;
        UnknownClientIdLbl: Label 'unknown', Locked = true;

    /// <summary>Executes one of the six Manor write message types after Foundation licence validation.</summary>
    /// <param name="MessageType">The Manor write type.</param>
    /// <param name="Argument">Request and response envelope.</param>
    procedure Execute(MessageType: Enum "Message Type ori"; var Argument: Record "Message Argument ori")
    var
        Request: JsonObject;
        Records: JsonArray;
        Results: JsonArray;
        Response: JsonObject;
        Item: JsonToken;
        Expected: Integer;
        Index: Integer;
        Failed: Integer;
        Succeeded: Integer;
        Parameter: Text;
        Problem: Text;
    begin
        Request := Argument.GetRequestJson();
        if not ReadExpectedCount(Request, Expected, Problem) then begin
            Argument.RespondWithError(Enum::"Bifrost Error Code ori"::InvalidParameter, Problem, 'expectedCount', '', '', ReadContractLbl);
            exit;
        end;
        CollectRecords(Request, Records);
        if Records.Count() = 0 then begin
            Argument.RespondWithError(Enum::"Bifrost Error Code ori"::MissingParameter, RequestMissingLbl, 'records', '', '', ReadContractLbl);
            exit;
        end;
        if Records.Count() <> Expected then begin
            Argument.RespondWithError(Enum::"Bifrost Error Code ori"::InvalidParameter, StrSubstNo(ExpectedCountMismatchLbl, Expected, Records.Count()), 'expectedCount', '', '', ReadContractLbl);
            exit;
        end;
        foreach Item in Records do
            if not Validate(MessageType, Item, Parameter, Problem) then begin
                Argument.RespondWithError(Enum::"Bifrost Error Code ori"::InvalidParameter, Problem, Parameter, '', '', ReadContractLbl);
                exit;
            end;
        foreach Item in Records do begin
            Index += 1;
            Results.Add(ProcessRecord(MessageType, Index, Item.AsObject()));
        end;
        foreach Item in Results do
            if Item.AsObject().GetText('status') = 'Failed' then
                Failed += 1
            else
                Succeeded += 1;
        if Failed = 0 then
            Response.Add('status', 'Success')
        else
            Response.Add('status', 'Failed');
        Response.Add('succeeded', Succeeded);
        Response.Add('failed', Failed);
        Response.Add('results', Results);
        Argument.SetResponseJson(Response);
        Argument."Content Type" := Argument.GetContentTypeJson();
    end;

    local procedure ReadExpectedCount(Request: JsonObject; var Expected: Integer; var Problem: Text): Boolean
    var
        Token: JsonToken;
        Serialized: Text;
    begin
        Problem := ExpectedCountMissingLbl;
        if not Request.Get('expectedCount', Token) then
            exit(false);
        if not Token.IsValue() then
            exit(false);
        Token.WriteTo(Serialized);
        if not Evaluate(Expected, Serialized) then
            exit(false);
        exit(Expected >= 1);
    end;

    local procedure CollectRecords(Request: JsonObject; var Records: JsonArray)
    var
        Token: JsonToken;
        Single: JsonObject;
        Name: Text;
    begin
        if Request.Get('records', Token) then begin
            if Token.IsArray() then
                Records := Token.AsArray();
            exit;
        end;
        foreach Name in Request.Keys() do
            if (Name <> 'expectedCount') and (Name <> 'confirmCurrencyChange') then begin
                Request.Get(Name, Token);
                Single.Add(Name, Token.Clone());
            end;
        if Request.Get(ConfirmFieldTxt, Token) then
            Single.Add(ConfirmFieldTxt, Token.Clone());
        if Single.Keys().Count() > 0 then
            Records.Add(Single);
    end;

    local procedure Validate(MessageType: Enum "Message Type ori"; Item: JsonToken; var Parameter: Text; var Problem: Text): Boolean
    var
        Entry: JsonObject;
        Token: JsonToken;
        Name: Text;
        Allowed: List of [Text];
        Billing: Text;
        Serialized: Text;
    begin
        if not Item.IsObject() then begin
            Parameter := 'records';
            Problem := RequestMissingLbl;
            exit(false);
        end;
        Entry := Item.AsObject();
        Allowed := AllowedFields(MessageType);
        foreach Name in Entry.Keys() do
            if not Allowed.Contains(Name) then begin
                Parameter := Name;
                Problem := StrSubstNo(UnknownFieldLbl, Name);
                exit(false);
            end;
        foreach Name in RequiredFields(MessageType) do
            if not Entry.Get(Name, Token) then begin
                Parameter := Name;
                Problem := StrSubstNo(MissingFieldLbl, Name);
                exit(false);
            end;
        foreach Name in Entry.Keys() do begin
            Entry.Get(Name, Token);
            Token.WriteTo(Serialized);
            if (Name in ['open', 'subject_to_vat', 'add_transaction_fee', 'internal', 'confirmCurrencyChange']) and (Serialized <> 'true') and (Serialized <> 'false') then begin
                Parameter := Name;
                Problem := StrSubstNo(BooleanFieldLbl, Name);
                exit(false);
            end;
            if (Name in ['name', 'national_id', 'billing', 'currency_code']) and (CopyStr(Serialized, 1, 1) <> '"') then begin
                Parameter := Name;
                Problem := StrSubstNo(TextFieldLbl, Name);
                exit(false);
            end;
            if (Name in ['id', 'projectId']) and not Token.IsValue() then begin
                Parameter := Name;
                Problem := StrSubstNo(TextFieldLbl, Name);
                exit(false);
            end;
        end;
        if Entry.Get('billing', Token) then begin
            Billing := Token.AsValue().AsText();
            if not (Billing in ['enabled', 'internal', 'sensitive']) then begin
                Parameter := 'billing';
                Problem := BillingLbl;
                exit(false);
            end;
        end;
        if (MessageType = MessageType::"Manor.Client.Update") and Entry.Contains('currency_code') then
            if not IsConfirmed(Entry) then begin
                Parameter := 'confirmCurrencyChange';
                Problem := CurrencyFlagLbl;
                exit(false);
            end;
        exit(true);
    end;

    local procedure IsConfirmed(Entry: JsonObject): Boolean
    var
        Token: JsonToken;
    begin
        if not Entry.Get(ConfirmFieldTxt, Token) then
            exit(false);
        exit(Token.AsValue().AsBoolean());
    end;

    local procedure ProcessRecord(MessageType: Enum "Message Type ori"; Index: Integer; Entry: JsonObject) Result: JsonObject
    var
        Mapper: Codeunit "Manor Error Mapper ori";
        ResponseBody: Text;
        Existing: Text;
        Outcome: Text;
        NationalId: Text;
        NationalToken: JsonToken;
    begin
        Result.Add('index', Index);
        if MessageType = MessageType::"Manor.Client.Create" then begin
            Entry.Get('national_id', NationalToken);
            NationalId := NationalToken.AsValue().AsText();
            if TryReadClientByNationalId(NationalId, Existing) then begin
                Result.Add('status', 'Failed');
                Result.Add('error', StrSubstNo(DuplicateLbl, NationalId, ReadId(Existing)));
                exit;
            end;
            if not Mapper.IsNotFoundMessage(GetLastErrorText()) then begin
                Result.Add('status', 'Failed');
                Result.Add('error', GetLastErrorText());
                exit;
            end;
            ClearLastError();
        end;
        if TrySend(MessageType, Entry, ResponseBody) then begin
            Outcome := 'Created';
            if MessageType in [MessageType::"Manor.Client.Update", MessageType::"Manor.Project.Update", MessageType::"Manor.Activity.Update"] then
                Outcome := 'Updated';
            Result.Add('status', Outcome);
            Result.Add('id', ReadId(ResponseBody));
            AddRecord(Result, ResponseBody);
        end else begin
            Result.Add('status', 'Failed');
            Result.Add('error', GetLastErrorText());
            ClearLastError();
        end;
    end;

    [TryFunction]
    local procedure TryReadClientByNationalId(NationalId: Text; var Body: Text)
    var
        Client: Codeunit "Manor Client ori";
    begin
        Body := Client.Get('/client-by-national-id/' + Escape(NationalId), '');
    end;

    [TryFunction]
    local procedure TrySend(MessageType: Enum "Message Type ori"; Entry: JsonObject; var ResponseBody: Text)
    var
        Client: Codeunit "Manor Client ori";
        Body: JsonObject;
        BodyText: Text;
        Token: JsonToken;
        Name: Text;
        Path: Text;
    begin
        foreach Name in Entry.Keys() do
            if not (Name in ['id', 'projectId', 'confirmCurrencyChange']) then begin
                Entry.Get(Name, Token);
                Body.Add(Name, Token.Clone());
            end;
        Body.WriteTo(BodyText);
        Path := BuildPath(MessageType, Entry);
        if MessageType in [MessageType::"Manor.Client.Create", MessageType::"Manor.Project.Create", MessageType::"Manor.Activity.Create"] then
            ResponseBody := Client.Post(Path, BodyText)
        else
            ResponseBody := Client.Put(Path, BodyText);
    end;

    local procedure BuildPath(MessageType: Enum "Message Type ori"; Entry: JsonObject): Text
    begin
        case MessageType of
            MessageType::"Manor.Client.Create":
                exit('/client');
            MessageType::"Manor.Client.Update":
                exit('/client/' + Escape(ReadScalar(Entry, 'id')));
            MessageType::"Manor.Project.Create":
                exit('/project');
            MessageType::"Manor.Project.Update":
                exit('/project/' + Escape(ReadScalar(Entry, 'id')));
            MessageType::"Manor.Activity.Create":
                exit('/project/' + Escape(ReadScalar(Entry, 'projectId')) + '/activity');
            MessageType::"Manor.Activity.Update":
                exit('/project/' + Escape(ReadScalar(Entry, 'projectId')) + '/activity/' + Escape(ReadScalar(Entry, 'id')));
        end;
    end;

    local procedure Escape(Value: Text): Text
    var
        Result: TextBuilder;
        Position: Integer;
        Character: Char;
        Code: Integer;
        HexDigits: Text;
    begin
        HexDigits := '0123456789ABCDEF';
        for Position := 1 to StrLen(Value) do begin
            Character := Value[Position];
            Code := Character;
            if ((Code >= 48) and (Code <= 57)) or ((Code >= 65) and (Code <= 90)) or ((Code >= 97) and (Code <= 122)) or (Code in [45, 46, 95, 126]) then
                Result.Append(Format(Character))
            else
                if Code < 256 then
                    Result.Append('%' + CopyStr(HexDigits, (Code div 16) + 1, 1) + CopyStr(HexDigits, (Code mod 16) + 1, 1))
                else
                    Result.Append('_');
        end;
        exit(Result.ToText());
    end;

    local procedure ReadScalar(Entry: JsonObject; Name: Text): Text
    var
        Token: JsonToken;
        Serialized: Text;
    begin
        Entry.Get(Name, Token);
        Token.WriteTo(Serialized);
        exit(DelChr(Serialized, '=', '"'));
    end;

    local procedure ReadId(ResponseBody: Text): Text
    var
        Json: JsonObject;
        Data: JsonToken;
        IdToken: JsonToken;
    begin
        if not Json.ReadFrom(ResponseBody) then
            exit(UnknownClientIdLbl);
        if Json.Get('data', Data) and Data.IsObject() then
            Json := Data.AsObject();
        if Json.Get('id', IdToken) and IdToken.IsValue() then
            exit(Format(IdToken.AsValue().AsText()));
        exit(UnknownClientIdLbl);
    end;

    local procedure AddRecord(var Result: JsonObject; ResponseBody: Text)
    var
        Json: JsonObject;
        Data: JsonToken;
    begin
        if not Json.ReadFrom(ResponseBody) then
            exit;
        if Json.Get('data', Data) and Data.IsObject() then
            Result.Add('record', Data.AsObject())
        else
            Result.Add('record', Json);
    end;

    /// <summary>Returns the record field names accepted by a message type.</summary>
    /// <param name="MessageType">The Manor write type.</param>
    /// <returns>Field names, including path identifiers and flags.</returns>
    procedure AllowedFields(MessageType: Enum "Message Type ori") Fields: List of [Text]
    var
        Names: Text;
        Name: Text;
    begin
        case MessageType of
            MessageType::"Manor.Client.Create":
                Names := 'name,national_id,address,billing_address,email,phone,currency_code,special_attention,add_transaction_fee';
            MessageType::"Manor.Client.Update":
                Names := 'id,name,national_id,address,billing_address,email,phone,currency_code,special_attention,add_transaction_fee,confirmCurrencyChange';
            MessageType::"Manor.Project.Create":
                Names := 'name,owner,client,billing_owner,department,open,subject_to_vat,billing,budget,time_budget,estimate,buyer_reference_number,labels';
            MessageType::"Manor.Project.Update":
                Names := 'id,name,owner,client,billing_owner,department,open,closing_comment,subject_to_vat,billing,budget,time_budget,estimate,buyer_reference_number,labels';
            MessageType::"Manor.Activity.Create":
                Names := 'projectId,name,parent,begins_at,ends_at,budget,time_budget,internal,closed_at';
            MessageType::"Manor.Activity.Update":
                Names := 'projectId,id,name,parent,begins_at,ends_at,budget,time_budget,internal,closed_at';
        end;
        foreach Name in Names.Split(',') do
            Fields.Add(Name);
    end;

    /// <summary>Returns the record field names a message type requires.</summary>
    /// <param name="MessageType">The Manor write type.</param>
    /// <returns>Required field names.</returns>
    procedure RequiredFields(MessageType: Enum "Message Type ori") Fields: List of [Text]
    begin
        case MessageType of
            MessageType::"Manor.Client.Create":
                begin
                    Fields.Add('name');
                    Fields.Add('national_id');
                    Fields.Add('currency_code');
                end;
            MessageType::"Manor.Client.Update", MessageType::"Manor.Project.Update":
                Fields.Add('id');
            MessageType::"Manor.Project.Create":
                begin
                    Fields.Add('name');
                    Fields.Add('owner');
                end;
            MessageType::"Manor.Activity.Create":
                begin
                    Fields.Add('projectId');
                    Fields.Add('name');
                end;
            MessageType::"Manor.Activity.Update":
                begin
                    Fields.Add('projectId');
                    Fields.Add('id');
                end;
        end;
    end;
}
