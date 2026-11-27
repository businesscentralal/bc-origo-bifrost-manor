namespace Origo.Bifrost.Manor;

/// <summary>Session-local canned responses and request history; reset between tests.</summary>
codeunit 10035649 "Manor Mock Store ori"
{
    SingleInstance = true;
    var
        Responses: JsonObject;
        Queued: JsonObject;
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
    /// <summary>Registers a response for an exact method, path and query. Several registrations for the same key are served in order; the last one repeats.</summary>
    procedure RegisterQueuedResponse(Method: Text; RelativePath: Text; Query: Text; StatusCode: Integer; Body: Text)
    var
        Response: JsonObject;
        Queue: JsonArray;
        Token: JsonToken;
        RouteKey: Text;
    begin
        RouteKey := UpperCase(Method) + ' ' + RelativePath + '?' + Query;
        Response.Add('status', StatusCode);
        Response.Add('body', Body);
        if Queued.Get(RouteKey, Token) then
            Token.AsArray().Add(Response)
        else begin
            Queue.Add(Response);
            Queued.Add(RouteKey, Queue);
        end;
    end;

    /// <summary>Records a mock request and resolves session fixtures before test-extension fixtures.</summary>
    procedure Send(Method: Text; RelativePath: Text; Query: Text; Body: Text; var Response: Codeunit "Manor Response ori"): Boolean
    var
        Request: JsonObject;
        Canned: JsonObject;
        Token: JsonToken;
        Status: JsonToken;
        Content: JsonToken;
        Entry: JsonToken;
        Handled: Boolean;
    begin
        Request.Add('method', UpperCase(Method));
        Request.Add('path', RelativePath);
        Request.Add('query', Query);
        Request.Add('body', Body);
        Requests.Add(Request);
        if Queued.Get(UpperCase(Method) + ' ' + RelativePath + '?' + Query, Token) then begin
            Token.AsArray().Get(0, Entry);
            Canned := Entry.AsObject();
            if Token.AsArray().Count() > 1 then
                Token.AsArray().RemoveAt(0);
            Canned.Get('status', Status);
            Canned.Get('body', Content);
            Response.SetResponse(Status.AsValue().AsInteger(), Content.AsValue().AsText());
            exit((Response.GetStatusCode() >= 200) and (Response.GetStatusCode() < 300));
        end;
        if not Responses.Get(UpperCase(Method) + ' ' + RelativePath, Token) then begin
            OnBeforeResolve(Method, RelativePath, Query, Response, Handled);
            if Handled then
                exit((Response.GetStatusCode() >= 200) and (Response.GetStatusCode() < 300));
            Response.SetResponse(404, '{}');
            exit(false);
        end;
        Canned := Token.AsObject();
        Canned.Get('status', Status);
        Canned.Get('body', Content);
        Response.SetResponse(Status.AsValue().AsInteger(), Content.AsValue().AsText());
        exit((Response.GetStatusCode() >= 200) and (Response.GetStatusCode() < 300));
    end;

    /// <summary>Allows test extensions to supply company-scoped mock fixtures without network access.</summary>
    [IntegrationEvent(false, false)]
    local procedure OnBeforeResolve(Method: Text; RelativePath: Text; Query: Text; var Response: Codeunit "Manor Response ori"; var Handled: Boolean)
    begin
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
        Clear(Queued);
        Clear(Requests);
    end;
}
