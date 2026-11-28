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
    /// <param name="Query">The URL query without a leading question mark, built with Manor QueryBuilder Builder ori.</param>
    /// <returns>The response body.</returns>
    procedure Get(RelativePath: Text; QueryBuilder: Text): Text
    begin
        exit(Execute('GET', RelativePath, QueryBuilder, ''));
    end;

    /// <summary>Reads every page of a list and merges the data arrays. Stops at meta.last_page or MaxPages.</summary>
    /// <param name="RelativePath">The list path.</param>
    /// <param name="Query">The URL query; page is replaced and per_page is capped at 100 (default 100).</param>
    /// <param name="MaxPages">The maximum number of pages to read (at least 1).</param>
    /// <returns>All data items of the pages read.</returns>
    procedure GetAll(RelativePath: Text; QueryBuilder: Text; MaxPages: Integer): JsonArray
    var
        Result: JsonArray;
        PageJson: JsonObject;
        DataToken: JsonToken;
        MetaToken: JsonToken;
        LastToken: JsonToken;
        Item: JsonToken;
        BaseQuery: Text;
        PageNo: Integer;
        LastPage: Integer;
    begin
        if MaxPages < 1 then
            Error(InvalidMaxPagesErr);
        BaseQuery := NormalizePagingQuery(QueryBuilder);
        PageNo := 1;
        repeat
            if not PageJson.ReadFrom(Execute('GET', RelativePath, BaseQuery + '&page=' + Format(PageNo, 0, 9), '')) then
                Error(UnexpectedResponseErr);
            if not (PageJson.Get('data', DataToken) and DataToken.IsArray()) then
                Error(UnexpectedResponseErr);
            foreach Item in DataToken.AsArray() do
                Result.Add(Item.Clone());
            LastPage := 1;
            if PageJson.Get('meta', MetaToken) and MetaToken.IsObject() then
                if MetaToken.AsObject().Get('last_page', LastToken) and LastToken.IsValue() then
                    LastPage := LastToken.AsValue().AsInteger();
            PageNo += 1;
        until (PageNo > LastPage) or (PageNo > MaxPages);
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

    /// <summary>Creates once, with a safe operation-specific permission hint. A create is never retried automatically.</summary>
    procedure Post(RelativePath: Text; Body: Text; RequiredPermission: Text): Text
    var
        Setup: Record "Manor Setup ori";
        Mapper: Codeunit "Manor Error Mapper ori";
        Telemetry: Codeunit "Manor Telemetry ori";
        Response: Codeunit "Manor Response ori";
        Transport: Interface "Manor Transport ori";
    begin
        Setup.Get();
        Transport := Setup.Environment;
        if Transport.Send('POST', RelativePath, '', Body, Response) then;
        Telemetry.LogCall('POST', RelativePath, Response.GetStatusCode());
        if (Response.GetStatusCode() >= 200) and (Response.GetStatusCode() < 300) then
            exit(Response.GetBody());
        Mapper.RaiseCreateError(Response.GetStatusCode(), RequiredPermission);
    end;

    /// <summary>Updates data with a JSON body.</summary>
    /// <param name="RelativePath">The path below /external-api/v1.</param>
    /// <param name="Body">The JSON request body.</param>
    /// <returns>The response body.</returns>
    procedure Put(RelativePath: Text; Body: Text): Text
    begin
        exit(Execute('PUT', RelativePath, '', Body));
    end;

    local procedure Execute(Method: Text; RelativePath: Text; QueryBuilder: Text; Body: Text): Text
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
            if Transport.Send(Method, RelativePath, QueryBuilder, Body, Response) then;
            Telemetry.LogCall(Method, RelativePath, Response.GetStatusCode());
            if (Response.GetStatusCode() >= 200) and (Response.GetStatusCode() < 300) then
                exit(Response.GetBody());
            if (Attempt = 1) and Mapper.IsRetryable(Response.GetStatusCode()) then
                Sleep(GetBackoff())
            else
                RaiseMappedError(Mapper, RelativePath, Response);
        end;
    end;

    local procedure RaiseMappedError(var Mapper: Codeunit "Manor Error Mapper ori"; Path: Text; var Response: Codeunit "Manor Response ori")
    begin
        if (Response.GetStatusCode() = 401) or (Response.GetStatusCode() = 403) then begin
            if Path.Contains('/product') then
                Mapper.RaiseError(Response.GetStatusCode(), 'manage_products');
            if Path.StartsWith('/inbound-invoice/') then
                Mapper.RaiseError(Response.GetStatusCode(), 'manage_inbound_invoices');
        end;
        if (Path.StartsWith('/invoice')) or (Path.StartsWith('/inbound-invoice/')) or Path.EndsWith('/time') or Path.Contains('/product') then
            Mapper.RaiseError(Response.GetStatusCode(), '');
        Mapper.RaiseError(Response.GetStatusCode(), Response.GetBody());
    end;

    local procedure GetBackoff(): Integer
    begin
        exit(500);
    end;

    local procedure NormalizePagingQuery(QueryBuilder: Text): Text
    var
        Part: Text;
        PerPage: Integer;
        Result: Text;
    begin
        PerPage := 100;
        foreach Part in QueryBuilder.Split('&') do
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
