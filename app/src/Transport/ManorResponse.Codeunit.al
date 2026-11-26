namespace Origo.Bifrost.Manor;

/// <summary>Holds the status and body of one transport response.</summary>
codeunit 10035646 "Manor Response ori"
{
    var
        StatusCode: Integer;
        ResponseBody: Text;

    /// <summary>Replaces response state for the current request.</summary>
    procedure SetResponse(NewStatusCode: Integer; NewBody: Text)
    begin
        StatusCode := NewStatusCode;
        ResponseBody := NewBody;
    end;

    /// <summary>Returns the HTTP status, or zero when no response was received.</summary>
    procedure GetStatusCode(): Integer
    begin
        exit(StatusCode);
    end;

    /// <summary>Returns the response body.</summary>
    procedure GetBody(): Text
    begin
        exit(ResponseBody);
    end;
}
