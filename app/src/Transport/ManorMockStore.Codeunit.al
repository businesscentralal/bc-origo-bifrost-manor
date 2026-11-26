namespace Origo.Bifrost.Manor;

/// <summary>Session-local canned responses and request history; reset between tests.</summary>
codeunit 10035649 "Manor Mock Store ori"
{
    SingleInstance = true;
    var
        Responses: JsonObject;
        Requests: JsonArray;

    /// <summary>Registers or replaces the canned response for a method and path.</summary>
    procedure RegisterResponse(Method: Text; RelativePath: Text; StatusCode: Integer; Body: Text)
    var
        Response: JsonObject;
        RouteKey: Text;
    begin
        RouteKey := UpperCase(Method) + ' ' + RelativePath;
        Response.Add('status', StatusCode);
        Response.Add('body', Body);
        if Responses.Contains(RouteKey) then
            Responses.Remove(RouteKey);
        Responses.Add(RouteKey, Response);
    end;

    /// <summary>Records the request and returns a registered response; missing routes return 404.</summary>
    procedure Send(Method: Text; RelativePath: Text; Query: Text; Body: Text; var Response: Codeunit "Manor Response ori"): Boolean
    var
        Request: JsonObject;
        Canned: JsonObject;
        Token: JsonToken;
        Status: JsonToken;
        Content: JsonToken;
    begin
        Request.Add('method', UpperCase(Method));
        Request.Add('path', RelativePath);
        Request.Add('query', Query);
        Request.Add('body', Body);
        Requests.Add(Request);
        if not Responses.Get(UpperCase(Method) + ' ' + RelativePath, Token) then begin
            Response.SetResponse(404, '{}');
            exit(false);
        end;
        Canned := Token.AsObject();
        Canned.Get('status', Status);
        Canned.Get('body', Content);
        Response.SetResponse(Status.AsValue().AsInteger(), Content.AsValue().AsText());
        exit((Response.GetStatusCode() >= 200) and (Response.GetStatusCode() < 300));
    end;

    /// <summary>Returns a copy of the requests recorded in this session.</summary>
    procedure GetRequests(): JsonArray
    begin
        exit(Requests.Clone().AsArray());
    end;

    /// <summary>Clears all canned responses and request history.</summary>
    procedure Reset()
    begin
        Clear(Responses);
        Clear(Requests);
    end;
}
