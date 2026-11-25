namespace Origo.Bifrost.Manor;

/// <summary>Connection-free implementation; it contains no HTTP client or credential access.</summary>
codeunit 10035645 "Manor Mock Impl ori" implements "Manor Transport ori"
{
    Access = Internal;

    /// <summary>Returns an empty URL because the mock never opens a connection.</summary>
    procedure BuildBaseUrl(Instance: Text): Text
    begin
        exit('');
    end;

    /// <summary>Resolves a response solely through the session-local mock store.</summary>
    procedure Send(Method: Text; RelativePath: Text; Query: Text; Body: Text; var Response: Codeunit "Manor Response ori"): Boolean
    var
        Store: Codeunit "Manor Mock Store ori";
    begin
        exit(Store.Send(Method, RelativePath, Query, Body, Response));
    end;
}
