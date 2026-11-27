namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>
/// Shared request reading, Manor calls and response building for the Manor read message types.
/// Every Manor call goes through <c>Manor Client ori</c>; a Manor failure becomes a structured Bifrost error
/// that never carries the API key.
/// </summary>
codeunit 10035682 "Manor Read Mgt ori"
{
    Access = Internal;

    var
        NotABooleanErr: Label 'The parameter %1 must be true or false.', Comment = '%1 = parameter name; is-IS=Breytan %1 verður að vera true eða false.';
        NotABooleanNextLbl: Label 'Send true or false.', Comment = 'is-IS=Sendu true eða false.';
        BothErr: Label 'Send either %1 or %2, not both.', Comment = '%1 = first parameter, %2 = second parameter; is-IS=Sendu annaðhvort %1 eða %2, ekki bæði.';
        NeitherErr: Label 'Send %1 or %2.', Comment = '%1 = first parameter, %2 = second parameter; is-IS=Sendu %1 eða %2.';
        OneOfLbl: Label 'exactly one of %1 and %2', Comment = '%1 = first parameter, %2 = second parameter; is-IS=nákvæmlega eitt af %1 og %2';
        BothNextLbl: Label 'Send exactly one of the two identifiers and try again.', Comment = 'is-IS=Sendu nákvæmlega eitt af auðkennunum tveimur og reyndu aftur.';
        NotAValueErr: Label 'The parameter %1 must be a single value.', Comment = '%1 = parameter name; is-IS=Breytan %1 verður að vera eitt gildi.';
        NotAValueNextLbl: Label 'Send the parameter as a plain text or number value.', Comment = 'is-IS=Sendu breytuna sem einfaldan texta eða tölugildi.';
        NotAnIdErr: Label 'The parameter %1 must be a positive whole number.', Comment = '%1 = parameter name; is-IS=Breytan %1 verður að vera jákvæð heiltala.';
        NotAnIdNextLbl: Label 'Send the numeric Manor id, for example from the list message type.', Comment = 'is-IS=Sendu tölulegt auðkenni úr Manor, til dæmis úr listaskilaboðunum.';
        NotANumberErr: Label 'The parameter %1 must be a whole number from %2 to %3.', Comment = '%1 = parameter name, %2 = lowest value, %3 = highest value; is-IS=Breytan %1 verður að vera heiltala frá %2 til %3.';
        NotANumberNextLbl: Label 'Send a whole number inside the allowed range.', Comment = 'is-IS=Sendu heiltölu innan leyfðs bils.';
        NotADateTimeErr: Label 'The parameter %1 must be a date and time such as 2026-11-01T00:00:00Z.', Comment = '%1 = parameter name; is-IS=Breytan %1 verður að vera dagsetning og tími, til dæmis 2026-11-01T00:00:00Z.';
        NotADateTimeNextLbl: Label 'Send an ISO 8601 date and time.', Comment = 'is-IS=Sendu dagsetningu og tíma samkvæmt ISO 8601.';
        RequestProblemsErr: Label 'The request has problems. Fix the listed parameters and send it again.', Comment = 'is-IS=Beiðnin hefur vandamál. Lagaðu tilgreindar breytur og sendu hana aftur.';
        UnexpectedResponseErr: Label 'Manor returned a response that could not be read.', Comment = 'is-IS=Manor skilaði svari sem ekki var hægt að lesa.';
        UnexpectedNextLbl: Label 'Try again later. If it keeps failing, check the Manor setup and the Manor status.', Comment = 'is-IS=Reyndu aftur síðar. Ef það mistekst áfram skaltu athuga uppsetningu Manor og stöðu Manor.';
        RejectedNextLbl: Label 'Check the API key and the Manor permissions of its user in Manor Setup. Activities need the Manor permission manage_activities.', Comment = 'is-IS=Athugaðu API-lykilinn og Manor-heimildir notandans í uppsetningu Manor. Verkþættir krefjast Manor-heimildarinnar manage_activities.';
        ValidationNextLbl: Label 'Correct the request values and send it again.', Comment = 'is-IS=Leiðréttu gildi beiðninnar og sendu hana aftur.';
        TemporaryNextLbl: Label 'Try again later.', Comment = 'is-IS=Reyndu aftur síðar.';

    /// <summary>Reads an optional text parameter. A missing or null value gives an empty text.</summary>
    /// <param name="Argument">The argument that collects problems.</param>
    /// <param name="RequestJson">The request data.</param>
    /// <param name="ParameterName">The parameter to read.</param>
    /// <param name="Value">Receives the trimmed text.</param>
    /// <returns>False when the value is not a single value (an error is collected).</returns>
    procedure ReadText(var Argument: Record "Message Argument ori"; RequestJson: JsonObject; ParameterName: Text; var Value: Text): Boolean
    var
        Token: JsonToken;
    begin
        Value := '';
        if not RequestJson.Get(ParameterName, Token) then
            exit(true);
        if not Token.IsValue() then begin
            Argument.AddError("Bifrost Error Code ori"::InvalidParameterFormat, StrSubstNo(NotAValueErr, ParameterName), ParameterName, '', '', NotAValueNextLbl);
            exit(false);
        end;
        if Token.AsValue().IsNull() then
            exit(true);
        Value := Token.AsValue().AsText().Trim();
        exit(true);
    end;

    /// <summary>Reads an optional Manor id (a positive whole number). The value is returned in its canonical form.</summary>
    /// <param name="Argument">The argument that collects problems.</param>
    /// <param name="RequestJson">The request data.</param>
    /// <param name="ParameterName">The parameter to read.</param>
    /// <param name="Value">Receives the id as text, or empty when absent.</param>
    /// <returns>False when the value is not a valid id (an error is collected).</returns>
    procedure ReadId(var Argument: Record "Message Argument ori"; RequestJson: JsonObject; ParameterName: Text; var Value: Text): Boolean
    var
        Id: BigInteger;
    begin
        if not ReadText(Argument, RequestJson, ParameterName, Value) then
            exit(false);
        if Value = '' then
            exit(true);
        if (DelChr(Value, '=', '0123456789') <> '') or (StrLen(Value) > 18) or not Evaluate(Id, Value) or (Id < 1) then begin
            Argument.AddError("Bifrost Error Code ori"::InvalidParameterFormat, StrSubstNo(NotAnIdErr, ParameterName), ParameterName, CopyStr(Value, 1, 50), '', NotAnIdNextLbl);
            Value := '';
            exit(false);
        end;
        Value := Format(Id, 0, 9);
        exit(true);
    end;

    /// <summary>Reads an optional boolean parameter. A missing or null value gives false.</summary>
    /// <param name="Argument">The argument that collects problems.</param>
    /// <param name="RequestJson">The request data.</param>
    /// <param name="ParameterName">The parameter to read.</param>
    /// <param name="Value">Receives the boolean.</param>
    /// <returns>False when the value is not a boolean (an error is collected).</returns>
    procedure ReadBoolean(var Argument: Record "Message Argument ori"; RequestJson: JsonObject; ParameterName: Text; var Value: Boolean): Boolean
    var
        TextValue: Text;
    begin
        Value := false;
        if not ReadText(Argument, RequestJson, ParameterName, TextValue) then
            exit(false);
        if TextValue = '' then
            exit(true);
        if not Evaluate(Value, TextValue, 9) then begin
            Value := false;
            Argument.AddError("Bifrost Error Code ori"::InvalidParameterFormat, StrSubstNo(NotABooleanErr, ParameterName), ParameterName, CopyStr(TextValue, 1, 50), '', NotABooleanNextLbl);
            exit(false);
        end;
        exit(true);
    end;

    /// <summary>Requires exactly one of two identifiers.</summary>
    /// <param name="Argument">The argument that collects problems.</param>
    /// <param name="FirstValue">The first identifier value.</param>
    /// <param name="FirstName">The first parameter name.</param>
    /// <param name="SecondValue">The second identifier value.</param>
    /// <param name="SecondName">The second parameter name.</param>
    procedure RequireOne(var Argument: Record "Message Argument ori"; FirstValue: Text; FirstName: Text; SecondValue: Text; SecondName: Text)
    begin
        if (FirstValue <> '') and (SecondValue <> '') then
            Argument.AddError("Bifrost Error Code ori"::ConflictingIdentifiers, StrSubstNo(BothErr, FirstName, SecondName), FirstName, '', StrSubstNo(OneOfLbl, FirstName, SecondName), BothNextLbl);
        if (FirstValue = '') and (SecondValue = '') and not Argument.HasCollectedErrors() then
            Argument.AddError("Bifrost Error Code ori"::MissingParameter, StrSubstNo(NeitherErr, FirstName, SecondName), FirstName, '', StrSubstNo(OneOfLbl, FirstName, SecondName), BothNextLbl);
    end;

    /// <summary>Reads an optional whole number inside a range.</summary>
    /// <param name="Argument">The argument that collects problems.</param>
    /// <param name="RequestJson">The request data.</param>
    /// <param name="ParameterName">The parameter to read.</param>
    /// <param name="LowestValue">The lowest allowed value.</param>
    /// <param name="HighestValue">The highest allowed value.</param>
    /// <param name="DefaultValue">The value used when the parameter is absent.</param>
    /// <param name="Value">Receives the number.</param>
    /// <returns>False when the value is not valid (an error is collected).</returns>
    procedure ReadInteger(var Argument: Record "Message Argument ori"; RequestJson: JsonObject; ParameterName: Text; LowestValue: Integer; HighestValue: Integer; DefaultValue: Integer; var Value: Integer): Boolean
    var
        TextValue: Text;
    begin
        Value := DefaultValue;
        if not ReadText(Argument, RequestJson, ParameterName, TextValue) then
            exit(false);
        if TextValue = '' then
            exit(true);
        if not Evaluate(Value, TextValue, 9) or (Value < LowestValue) or (Value > HighestValue) then begin
            Value := DefaultValue;
            Argument.AddError("Bifrost Error Code ori"::InvalidParameter, StrSubstNo(NotANumberErr, ParameterName, LowestValue, HighestValue), ParameterName, CopyStr(TextValue, 1, 50), '', NotANumberNextLbl);
            exit(false);
        end;
        exit(true);
    end;

    /// <summary>Reads page and perPage and adds them to the Manor query.</summary>
    /// <param name="Argument">The argument that collects problems.</param>
    /// <param name="RequestJson">The request data.</param>
    /// <param name="Query">The Manor query being built.</param>
    /// <param name="Page">Receives the page number.</param>
    /// <param name="PerPage">Receives the page size.</param>
    /// <returns>False when a value is not valid.</returns>
    procedure ReadPaging(var Argument: Record "Message Argument ori"; RequestJson: JsonObject; var Query: Codeunit "Manor Query Builder ori"; var Page: Integer; var PerPage: Integer): Boolean
    var
        PageOk: Boolean;
        PerPageOk: Boolean;
    begin
        PageOk := ReadInteger(Argument, RequestJson, 'page', 1, 100000, 1, Page);
        PerPageOk := ReadInteger(Argument, RequestJson, 'perPage', 1, 100, 100, PerPage);
        Query.Add('page', Page);
        Query.Add('per_page', PerPage);
        exit(PageOk and PerPageOk);
    end;

    /// <summary>Reads the optional updatedSince parameter and adds it to the Manor query as updated_since.</summary>
    /// <param name="Argument">The argument that collects problems.</param>
    /// <param name="RequestJson">The request data.</param>
    /// <param name="Query">The Manor query being built.</param>
    /// <returns>False when the value is not a date and time.</returns>
    procedure ReadUpdatedSince(var Argument: Record "Message Argument ori"; RequestJson: JsonObject; var Query: Codeunit "Manor Query Builder ori"): Boolean
    var
        TextValue: Text;
        Moment: DateTime;
    begin
        if not ReadText(Argument, RequestJson, 'updatedSince', TextValue) then
            exit(false);
        if TextValue = '' then
            exit(true);
        if not Evaluate(Moment, TextValue, 9) then begin
            Argument.AddError("Bifrost Error Code ori"::InvalidParameterFormat, StrSubstNo(NotADateTimeErr, 'updatedSince'), 'updatedSince', CopyStr(TextValue, 1, 50), '', NotADateTimeNextLbl);
            exit(false);
        end;
        Query.Add('updated_since', Moment);
        exit(true);
    end;

    /// <summary>Answers with the collected request problems.</summary>
    /// <param name="Argument">The argument that holds the collected errors.</param>
    /// <returns>True when problems were collected and the response is set; the caller must stop.</returns>
    procedure RespondIfInvalid(var Argument: Record "Message Argument ori"): Boolean
    begin
        if not Argument.HasCollectedErrors() then
            exit(false);
        Argument.RespondWithCollectedErrors("Bifrost Error Code ori"::MultipleErrors, RequestProblemsErr);
        exit(true);
    end;

    /// <summary>Reads from Manor through the client. A Manor failure is answered as a structured error.</summary>
    /// <param name="Argument">The argument that receives an error response.</param>
    /// <param name="RelativePath">The Manor path below /external-api/v1.</param>
    /// <param name="Query">The Manor query.</param>
    /// <param name="NotFoundNextStep">The next step for a 404.</param>
    /// <param name="ParameterName">The request parameter a 404 is about.</param>
    /// <param name="Received">The value of that parameter.</param>
    /// <param name="Body">Receives the response body.</param>
    /// <returns>True when Manor answered successfully.</returns>
    procedure Fetch(var Argument: Record "Message Argument ori"; RelativePath: Text; Query: Text; NotFoundNextStep: Text; ParameterName: Text; Received: Text; var Body: Text): Boolean
    begin
        Body := '';
        if TryGet(RelativePath, Query, Body) then
            exit(true);
        RespondFailure(Argument, GetLastErrorText(), NotFoundNextStep, ParameterName, Received);
        exit(false);
    end;

    [TryFunction]
    local procedure TryGet(RelativePath: Text; Query: Text; var Body: Text)
    var
        Client: Codeunit "Manor Client ori";
    begin
        Body := Client.Get(RelativePath, Query);
    end;

    local procedure RespondFailure(var Argument: Record "Message Argument ori"; ErrorText: Text; NotFoundNextStep: Text; ParameterName: Text; Received: Text)
    var
        Mapper: Codeunit "Manor Error Mapper ori";
    begin
        case Mapper.Classify(ErrorText) of
            403:
                Argument.RespondWithError("Bifrost Error Code ori"::PermissionDenied, ErrorText, '', '', '', RejectedNextLbl);
            404:
                Argument.RespondWithError("Bifrost Error Code ori"::RecordNotFound, ErrorText, ParameterName, CopyStr(Received, 1, 50), '', NotFoundNextStep);
            422:
                Argument.RespondWithError("Bifrost Error Code ori"::InvalidParameter, ErrorText, '', '', '', ValidationNextLbl);
            503:
                Argument.RespondWithError("Bifrost Error Code ori"::Retryable, ErrorText, '', '', '', TemporaryNextLbl);
            else
                Argument.RespondWithError("Bifrost Error Code ori"::BusinessCentralError, ErrorText, '', '', '', UnexpectedNextLbl);
        end;
    end;

    /// <summary>Answers a list call: the data items of one Manor page plus its paging facts.</summary>
    /// <param name="Argument">The argument that receives the response.</param>
    /// <param name="Body">The Manor response body.</param>
    /// <param name="ListName">The response property that holds the items.</param>
    /// <param name="Page">The page that was requested.</param>
    /// <param name="PerPage">The page size that was requested.</param>
    procedure RespondList(var Argument: Record "Message Argument ori"; Body: Text; ListName: Text; Page: Integer; PerPage: Integer)
    var
        PageJson: JsonObject;
        MetaJson: JsonObject;
        DataObject: JsonObject;
        DataToken: JsonToken;
        MetaToken: JsonToken;
        Items: JsonArray;
        LastPage: Integer;
        Total: Integer;
    begin
        if not PageJson.ReadFrom(Body) or not PageJson.Get('data', DataToken) or not DataToken.IsArray() then begin
            RespondUnexpected(Argument);
            exit;
        end;
        Items := DataToken.AsArray();
        LastPage := Page;
        Total := Items.Count();
        if PageJson.Get('meta', MetaToken) and MetaToken.IsObject() then begin
            MetaJson := MetaToken.AsObject();
            LastPage := ReadMetaInteger(MetaJson, 'last_page', LastPage);
            Total := ReadMetaInteger(MetaJson, 'total', Total);
        end;
        DataObject.Add(ListName, Items);
        DataObject.Add('page', Page);
        DataObject.Add('perPage', PerPage);
        DataObject.Add('lastPage', LastPage);
        DataObject.Add('total', Total);
        DataObject.Add('count', Items.Count());
        DataObject.Add('hasMore', Page < LastPage);
        RespondSuccess(Argument, DataObject);
    end;

    /// <summary>Answers a get call with one Manor object. Manor may wrap the object in data.</summary>
    /// <param name="Argument">The argument that receives the response.</param>
    /// <param name="Item">The object Manor returned.</param>
    /// <param name="ItemName">The response property that holds the object.</param>
    procedure RespondItem(var Argument: Record "Message Argument ori"; Item: JsonObject; ItemName: Text)
    var
        DataObject: JsonObject;
    begin
        DataObject.Add(ItemName, Item);
        RespondSuccess(Argument, DataObject);
    end;

    /// <summary>Reads one object from a Manor response, unwrapping a data object when present.</summary>
    /// <param name="Body">The Manor response body.</param>
    /// <param name="Item">Receives the object.</param>
    /// <param name="MatchCount">Receives how many objects the response held (a data array can hold several).</param>
    /// <returns>False when the body holds no object.</returns>
    procedure ReadItem(Body: Text; var Item: JsonObject; var MatchCount: Integer): Boolean
    var
        Json: JsonObject;
        DataToken: JsonToken;
        First: JsonToken;
    begin
        MatchCount := 0;
        if not Json.ReadFrom(Body) then
            exit(false);
        if Json.Get('data', DataToken) then begin
            if DataToken.IsObject() then begin
                Item := DataToken.AsObject();
                MatchCount := 1;
                exit(true);
            end;
            if DataToken.IsArray() then begin
                MatchCount := DataToken.AsArray().Count();
                if MatchCount = 0 then
                    exit(false);
                DataToken.AsArray().Get(0, First);
                if not First.IsObject() then
                    exit(false);
                Item := First.AsObject();
                exit(true);
            end;
            exit(false);
        end;
        Item := Json;
        MatchCount := 1;
        exit(Json.Keys().Count() > 0);
    end;

    /// <summary>Answers that Manor returned something that is not the expected shape.</summary>
    /// <param name="Argument">The argument that receives the response.</param>
    procedure RespondUnexpected(var Argument: Record "Message Argument ori")
    begin
        Argument.RespondWithError("Bifrost Error Code ori"::BusinessCentralError, UnexpectedResponseErr, '', '', '', UnexpectedNextLbl);
    end;

    local procedure ReadMetaInteger(MetaJson: JsonObject; PropertyName: Text; DefaultValue: Integer): Integer
    var
        Token: JsonToken;
        Value: Integer;
    begin
        if MetaJson.Get(PropertyName, Token) and Token.IsValue() and not Token.AsValue().IsNull() then
            if Evaluate(Value, Token.AsValue().AsText(), 9) then
                exit(Value);
        exit(DefaultValue);
    end;

    local procedure RespondSuccess(var Argument: Record "Message Argument ori"; DataObject: JsonObject)
    var
        ResponseJson: JsonObject;
    begin
        ResponseJson.Add('status', 'Success');
        ResponseJson.Add('data', DataObject);
        Argument.SetResponseJson(ResponseJson);
        Argument."Content Type" := Argument.GetContentTypeJson();
    end;
}
