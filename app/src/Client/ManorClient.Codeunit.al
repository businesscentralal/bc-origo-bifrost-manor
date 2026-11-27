namespace Origo.Bifrost.Manor;

/// <summary>
/// The one Manor API client: authenticated (by the transport), JSON, paged, with mapped errors and one retry.
/// There is deliberately no Delete procedure (no delete message types).
/// </summary>
codeunit 10035651 "Manor Client ori"
{
    Access = Public;

    var
        InvalidMaxPagesErr: Label 'MaxPages must be at least 1.', Comment = 'is-IS=Hámarksfjöldi blaðsíðna verður að vera minnst 1.';
        UnexpectedResponseErr: Label 'Manor returned a response that is not a valid list.', Comment = 'is-IS=Manor skilaði svari sem er ekki gild skrá.';

    /// <summary>Reads one resource or one page.</summary>
    /// <param name="RelativePath">The path below /external-api/v1, without host or query.</param>
    /// <param name="Query">The URL query without a leading question mark, built with Manor Query Builder ori.</param>
    /// <returns>The response body.</returns>
    procedure Get(RelativePath: Text; Query: Text): Text
    begin
        exit(Execute('GET', RelativePath, Query, ''));
    end;

    /// <summary>Reads every page of a list and merges the data arrays. Stops at meta.last_page or MaxPages.</summary>
    /// <param name="RelativePath">The list path.</param>
    /// <param name="Query">The URL query; page is replaced and per_page is capped at 100 (default 100).</param>
    /// <param name="MaxPages">The maximum number of pages to read (at least 1).</param>
    /// <returns>All data items of the pages read.</returns>
    procedure GetAll(RelativePath: Text; Query: Text; MaxPages: Integer): JsonArray
    var
        Result: JsonArray;
        PageJson: JsonObject;
        DataToken: JsonToken;
        MetaToken: JsonToken;
        LastToken: JsonToken;
        Item: JsonToken;
        BaseQuery: Text;
        Page: Integer;
        LastPage: Integer;
    begin
        if MaxPages < 1 then
            Error(InvalidMaxPagesErr);
        BaseQuery := NormalizePagingQuery(Query);
        Page := 1;
        repeat
            if not PageJson.ReadFrom(Execute('GET', RelativePath, BaseQuery + '&page=' + Format(Page, 0, 9), '')) then
                Error(UnexpectedResponseErr);
            if not (PageJson.Get('data', DataToken) and DataToken.IsArray()) then
                Error(UnexpectedResponseErr);
            foreach Item in DataToken.AsArray() do
                Result.Add(Item.Clone());
            LastPage := 1;
            if PageJson.Get('meta', MetaToken) and MetaToken.IsObject() then
                if MetaToken.AsObject().Get('last_page', LastToken) and LastToken.IsValue() then
                    LastPage := LastToken.AsValue().AsInteger();
            Page += 1;
        until (Page > LastPage) or (Page > MaxPages);
        exit(Result);
    end;

    /// <summary>Creates data with a JSON body.</summary>
    /// <param name="RelativePath">The path below /external-api/v1.</param>
    /// <param name="Body">The JSON request body.</param>
    /// <returns>The response body.</returns>
    procedure Post(RelativePath: Text; Body: Text): Text
    begin
        exit(Execute('POST', RelativePath, '', Body));
    end;

    /// <summary>Updates data with a JSON body.</summary>
    /// <param name="RelativePath">The path below /external-api/v1.</param>
    /// <param name="Body">The JSON request body.</param>
    /// <returns>The response body.</returns>
    procedure Put(RelativePath: Text; Body: Text): Text
    begin
        exit(Execute('PUT', RelativePath, '', Body));
    end;

    /// <summary>Reads for a message handler without echoing upstream validation details.</summary>
    /// <param name="RelativePath">The approved read endpoint.</param>
    /// <param name="Query">The encoded query.</param>
    /// <returns>The response body.</returns>
    procedure GetRead(RelativePath: Text; Query: Text): Text
    begin
        exit(Execute('GET', RelativePath, Query, '', true));
    end;

    local procedure Execute(Method: Text; RelativePath: Text; Query: Text; Body: Text): Text
    begin
        exit(Execute(Method, RelativePath, Query, Body, false));
    end;

    local procedure Execute(Method: Text; RelativePath: Text; Query: Text; Body: Text; SanitizeReadErrors: Boolean): Text
    var
        Setup: Record "Manor Setup ori";
        Mapper: Codeunit "Manor Error Mapper ori";
        Telemetry: Codeunit "Manor Telemetry ori";
        Response: Codeunit "Manor Response ori";
        Transport: Interface "Manor Transport ori";
        Attempt: Integer;
    begin
        Setup.Get();
        Transport := Setup.Environment;
        for Attempt := 1 to 2 do begin
            if Transport.Send(Method, RelativePath, Query, Body, Response) then;
            Telemetry.LogCall(Method, RelativePath, Response.GetStatusCode());
            if (Response.GetStatusCode() >= 200) and (Response.GetStatusCode() < 300) then
                exit(Response.GetBody());
            if (Attempt = 1) and Mapper.IsRetryable(Response.GetStatusCode()) then
                Sleep(GetBackoff())
            else begin
                if (RelativePath = 'rate') and (Response.GetStatusCode() = 403) then
                    Mapper.RaiseError(403, 'manage_rates');
                // Read errors need no server-supplied validation text, which may echo credentials.
                if SanitizeReadErrors and (Response.GetStatusCode() = 422) then
                    Mapper.RaiseError(422, '{}');
                Mapper.RaiseError(Response.GetStatusCode(), Response.GetBody());
            end;
        end;
    end;

    local procedure GetBackoff(): Integer
    begin
        exit(500);
    end;

    local procedure NormalizePagingQuery(Query: Text): Text
    var
        Part: Text;
        PerPage: Integer;
        Result: Text;
    begin
        PerPage := 100;
        foreach Part in Query.Split('&') do
            case true of
                Part = '':
                    ;
                CopyStr(Part, 1, 5) = 'page=':
                    ;
                CopyStr(Part, 1, 9) = 'per_page=':
                    if Evaluate(PerPage, CopyStr(Part, 10)) then;
                else begin
                    if Result <> '' then
                        Result += '&';
                    Result += Part;
                end;
            end;
        if (PerPage < 1) or (PerPage > 100) then
            PerPage := 100;
        if Result <> '' then
            Result += '&';
        exit(Result + 'per_page=' + Format(PerPage, 0, 9));
    end;
}
