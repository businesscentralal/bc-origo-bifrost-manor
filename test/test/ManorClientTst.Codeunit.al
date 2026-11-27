namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost.Manor;
using System.TestLibraries.Security.AccessControl;
using System.TestLibraries.Utilities;

/// <summary>Story B: Manor API client over the Mock transport (paging, errors, retry, query building) in both languages.</summary>
codeunit 98220 "Manor Client Tst ori"
{
    Subtype = Test;
    TestPermissions = Restrictive;
    TestHttpRequestPolicy = BlockOutboundRequests;

    var
        Assert: Codeunit "Library Assert";
        LowerPermissions: Codeunit "Library - Lower Permissions";
        PreviousLanguage: Integer;
        HttpCalls: Integer;
        BearerSeen: Boolean;
        JsonSeen: Boolean;

    /// <summary>Checks GetPostPut in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC01_GetPostPutEnglish()
    begin
        VerifyMethods(1033);
    end;

    /// <summary>Checks GetPostPut in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC01_GetPostPutIcelandic()
    begin
        VerifyMethods(1039);
    end;

    /// <summary>Checks BearerAndJson in LCID 1033.</summary>
    [Test]
    [HandlerFunctions('BearerHandler')]
    procedure Scenario_AC01_BearerAndJsonEnglish()
    begin
        VerifyBearer(1033);
    end;

    /// <summary>Checks BearerAndJson in LCID 1039.</summary>
    [Test]
    [HandlerFunctions('BearerHandler')]
    procedure Scenario_AC01_BearerAndJsonIcelandic()
    begin
        VerifyBearer(1039);
    end;

    /// <summary>Checks QueryBuilder in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC01_QueryBuilderEnglish()
    begin
        VerifyQuery(1033);
    end;

    /// <summary>Checks QueryBuilder in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC01_QueryBuilderIcelandic()
    begin
        VerifyQuery(1039);
    end;

    /// <summary>Checks GetAllWalksPages in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_GetAllWalksPagesEnglish()
    begin
        VerifyPaging(1033);
    end;

    /// <summary>Checks GetAllWalksPages in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_GetAllWalksPagesIcelandic()
    begin
        VerifyPaging(1039);
    end;

    /// <summary>Checks GetAllStopsAtMaxPages in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_GetAllStopsAtMaxPagesEnglish()
    begin
        VerifyMaxPages(1033);
    end;

    /// <summary>Checks GetAllStopsAtMaxPages in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_GetAllStopsAtMaxPagesIcelandic()
    begin
        VerifyMaxPages(1039);
    end;

    /// <summary>Checks Unauthorized in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_UnauthorizedEnglish()
    begin
        VerifyUnauthorized(1033);
    end;

    /// <summary>Checks Unauthorized in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_UnauthorizedIcelandic()
    begin
        VerifyUnauthorized(1039);
    end;

    /// <summary>Checks ForbiddenPermission in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_ForbiddenPermissionEnglish()
    begin
        VerifyForbidden(1033);
    end;

    /// <summary>Checks ForbiddenPermission in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_ForbiddenPermissionIcelandic()
    begin
        VerifyForbidden(1039);
    end;

    /// <summary>Checks NotFound in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_NotFoundEnglish()
    begin
        VerifyNotFound(1033);
    end;

    /// <summary>Checks NotFound in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_NotFoundIcelandic()
    begin
        VerifyNotFound(1039);
    end;

    /// <summary>Checks ValidationFields in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_ValidationFieldsEnglish()
    begin
        VerifyValidation(1033);
    end;

    /// <summary>Checks ValidationFields in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_ValidationFieldsIcelandic()
    begin
        VerifyValidation(1039);
    end;

    /// <summary>Checks ServerErrorRetries in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_ServerErrorRetriesEnglish()
    begin
        VerifyServerError(1033);
    end;

    /// <summary>Checks ServerErrorRetries in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_ServerErrorRetriesIcelandic()
    begin
        VerifyServerError(1039);
    end;

    /// <summary>Checks RetryRecovers in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_RetryRecoversEnglish()
    begin
        VerifyRetryRecovers(1033);
    end;

    /// <summary>Checks RetryRecovers in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_RetryRecoversIcelandic()
    begin
        VerifyRetryRecovers(1039);
    end;

    /// <summary>Intercepts the request, checks the secret URI and path, and answers 200 without network access.</summary>
    [HttpClientHandler]
    procedure BearerHandler(Request: TestHttpRequestMessage; var Response: TestHttpResponseMessage): Boolean
    begin
        HttpCalls += 1;
        BearerSeen := Request.HasSecretUri();
        JsonSeen := Request.RequestType = HttpRequestType::Get;
        Response.HttpStatusCode := 200;
        Response.Content.WriteFrom('{"data":[]}');
        Response.IsSuccessfulRequest := true;
        exit(false);
    end;

    local procedure VerifyMethods(LanguageId: Integer)
    var
        Client: Codeunit "Manor Client ori";
        Store: Codeunit "Manor Mock Store ori";
        Requests: JsonArray;
    begin
        // [GIVEN] Mock responses for GET, POST and PUT.
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'projects', 200, '{"data":[1]}');
        Store.RegisterResponse('POST', 'projects', 201, '{"id":7}');
        Store.RegisterResponse('PUT', 'projects/7', 200, '{"id":7,"name":"B"}');
        // [WHEN] The client calls each method.
        Assert.AreEqual('{"data":[1]}', Client.Get('projects', 'status=open'), 'GET body.');
        Assert.AreEqual('{"id":7}', Client.Post('projects', '{"name":"A"}'), 'POST body.');
        Assert.AreEqual('{"id":7,"name":"B"}', Client.Put('projects/7', '{"name":"B"}'), 'PUT body.');
        // [THEN] The transport saw the expected method, path, query and body.
        Requests := Store.GetRequests();
        Assert.AreEqual(3, Requests.Count(), 'Request count.');
        CheckRequest(Requests, 0, 'GET', 'projects', 'status=open', '');
        CheckRequest(Requests, 1, 'POST', 'projects', '', '{"name":"A"}');
        CheckRequest(Requests, 2, 'PUT', 'projects/7', '', '{"name":"B"}');
        Cleanup();
    end;

    local procedure VerifyBearer(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
        Client: Codeunit "Manor Client ori";
        TestKey: SecretText;
    begin
        // [GIVEN] A Test environment with a generated key and an intercepting handler.
        Initialize(LanguageId);
        Setup.Get();
        Setup.Enabled := true;
        Setup.Environment := Setup.Environment::Test;
        Setup.Validate(Instance, 'X');
        Setup.Modify(true);
        TestKey := Format(CreateGuid(), 0, 4);
        Secrets.SetApiKey(TestKey);
        Clear(TestKey);
        HttpCalls := 0;
        BearerSeen := false;
        JsonSeen := false;
        // [WHEN] The client reads.
        Client.Get('projects', '');
        // [THEN] The keyed request reached the transport (headers are added by Manor Secrets ori, whose missing-key error is covered by Story A).
        Assert.AreEqual(1, HttpCalls, 'One intercepted call.');
        Assert.IsTrue(BearerSeen, 'The instance must stay in a secret URI.');
        Assert.IsTrue(JsonSeen, 'The request must be a GET.');
        Cleanup();
    end;

    local procedure VerifyQuery(LanguageId: Integer)
    var
        Builder: Codeunit "Manor Query Builder ori";
        Telemetry: Codeunit "Manor Telemetry ori";
    begin
        // [GIVEN] Values with reserved characters and a date and time formatted by the user language.
        Initialize(LanguageId);
        // [WHEN] They are added.
        Builder.Add('q', 'a b&c=d');
        Builder.Add('n', 1234567);
        Builder.Add('flag', true);
        Builder.Add('d', DMY2Date(5, 11, 2026));
        Builder.Add('updated_since', CreateDateTime(DMY2Date(5, 11, 2026), 130500T));
        Builder.Add('skip', '');
        Builder.Add('skipdate', 0D);
        // [THEN] The query is encoded and ISO 8601, independent of the language.
        Assert.AreEqual('q=a+b%26c%3dd&n=1234567&flag=true&d=2026-11-05&updated_since=2026-11-05T13%3a05%3a00Z', Builder.Build(), 'Query string.');
        Assert.AreEqual('projects/{id}/activities', Telemetry.PathTemplate('projects/12/activities'), 'Telemetry path template hides ids.');
        Cleanup();
    end;

    local procedure VerifyPaging(LanguageId: Integer)
    var
        Client: Codeunit "Manor Client ori";
        Store: Codeunit "Manor Mock Store ori";
        Result: JsonArray;
        Requests: JsonArray;
    begin
        // [GIVEN] Three pages, and a requested per_page above the cap.
        Initialize(LanguageId);
        RegisterPages(Store);
        // [WHEN] GetAll walks the list.
        Result := Client.GetAll('clients', 'per_page=500&status=open', 10);
        // [THEN] All pages are merged, per_page is capped at 100, and it stops at meta.last_page.
        Assert.AreEqual(5, Result.Count(), 'Merged data.');
        Requests := Store.GetRequests();
        Assert.AreEqual(3, Requests.Count(), 'Three page requests.');
        CheckRequest(Requests, 0, 'GET', 'clients', 'status=open&per_page=100&page=1', '');
        CheckRequest(Requests, 2, 'GET', 'clients', 'status=open&per_page=100&page=3', '');
        Cleanup();
    end;

    local procedure VerifyMaxPages(LanguageId: Integer)
    var
        Client: Codeunit "Manor Client ori";
        Store: Codeunit "Manor Mock Store ori";
        Result: JsonArray;
    begin
        // [GIVEN] Three pages.
        Initialize(LanguageId);
        RegisterPages(Store);
        // [WHEN/THEN] MaxPages 2 stops after two pages; MaxPages 0 is rejected.
        Result := Client.GetAll('clients', '', 2);
        Assert.AreEqual(3, Result.Count(), 'Two pages of data.');
        Assert.AreEqual(2, Store.GetRequests().Count(), 'Two requests.');
        asserterror Client.GetAll('clients', '', 0);
        CheckError(LanguageId, 'MaxPages must be at least 1.', 'Hámarksfjöldi blaðsíðna verður að vera minnst 1.');
        Cleanup();
    end;

    local procedure VerifyUnauthorized(LanguageId: Integer)
    var
        Client: Codeunit "Manor Client ori";
        Store: Codeunit "Manor Mock Store ori";
        SecretValue: Text;
    begin
        // [GIVEN] A 401 whose body echoes a synthetic key.
        Initialize(LanguageId);
        SecretValue := Format(CreateGuid(), 0, 4);
        Store.RegisterResponse('GET', 'projects', 401, '{"message":"bad ' + SecretValue + '"}');
        // [WHEN/THEN] The error is the documented text and does not contain the key.
        asserterror Client.Get('projects', 'secret=' + SecretValue);
        CheckError(LanguageId, 'Manor rejected the API key or its permissions.', 'Manor hafnaði API-lyklinum eða heimildum hans.');
        Assert.AreEqual(0, StrPos(GetLastErrorText(), SecretValue), 'The error must not contain the key or query.');
        Cleanup();
    end;

    local procedure VerifyForbidden(LanguageId: Integer)
    var
        Client: Codeunit "Manor Client ori";
        Store: Codeunit "Manor Mock Store ori";
    begin
        // [GIVEN] A 403 that names a Manor permission.
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'rates', 403, '{"message":"Requires manage_rates"}');
        // [WHEN/THEN] The permission name is shown.
        asserterror Client.Get('rates', '');
        CheckError(LanguageId, 'Required Manor permission: manage_rates.', 'Nauðsynleg heimild í Manor: manage_rates.');
        Cleanup();
    end;

    local procedure VerifyNotFound(LanguageId: Integer)
    var
        Client: Codeunit "Manor Client ori";
        Store: Codeunit "Manor Mock Store ori";
    begin
        // [GIVEN] A 404.
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'projects/9', 404, '{"message":"x"}');
        // [WHEN/THEN] The error is the not-found text.
        asserterror Client.Get('projects/9', '');
        CheckError(LanguageId, 'Manor could not find the requested resource.', 'Manor fann ekki umbeðið gagn.');
        Cleanup();
    end;

    local procedure VerifyValidation(LanguageId: Integer)
    var
        Client: Codeunit "Manor Client ori";
        Store: Codeunit "Manor Mock Store ori";
    begin
        // [GIVEN] A 422 with field errors.
        Initialize(LanguageId);
        Store.RegisterResponse('POST', 'clients', 422, '{"message":"invalid","errors":{"name":["The name field is required."],"email":["Invalid e-mail."]}}');
        // [WHEN/THEN] Field-level messages are shown and the request body is not.
        asserterror Client.Post('clients', '{"secretbody":"zzz"}');
        CheckError(LanguageId, 'Manor rejected the data: name: The name field is required. email: Invalid e-mail.', 'Manor hafnaði gögnunum: name: The name field is required. email: Invalid e-mail.');
        Assert.AreEqual(0, StrPos(GetLastErrorText(), 'zzz'), 'The error must not contain the request body.');
        Cleanup();
    end;

    local procedure VerifyServerError(LanguageId: Integer)
    var
        Client: Codeunit "Manor Client ori";
        Store: Codeunit "Manor Mock Store ori";
    begin
        // [GIVEN] A persistent 500.
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'projects', 500, '{}');
        // [WHEN/THEN] One retry is made, then the error is raised.
        asserterror Client.Get('projects', '');
        CheckError(LanguageId, 'Manor is unavailable or busy (HTTP 500). Try again later.', 'Manor er ekki tiltækt eða of upptekið (HTTP 500). Reyndu aftur síðar.');
        Assert.AreEqual(2, Store.GetRequests().Count(), 'Exactly one retry.');
        Cleanup();
    end;

    local procedure VerifyRetryRecovers(LanguageId: Integer)
    var
        Client: Codeunit "Manor Client ori";
        Store: Codeunit "Manor Mock Store ori";
    begin
        // [GIVEN] A 429 followed by a 200.
        Initialize(LanguageId);
        Store.RegisterQueuedResponse('GET', 'projects', '', 429, '{}');
        Store.RegisterQueuedResponse('GET', 'projects', '', 200, '{"data":[]}');
        // [WHEN/THEN] The retry succeeds.
        Assert.AreEqual('{"data":[]}', Client.Get('projects', ''), 'Retry result.');
        Assert.AreEqual(2, Store.GetRequests().Count(), 'Two attempts.');
        Cleanup();
    end;

    local procedure RegisterPages(var Store: Codeunit "Manor Mock Store ori")
    var
        Query: Text;
    begin
        Query := 'status=open&per_page=100&page=';
        Store.RegisterQueuedResponse('GET', 'clients', Query + '1', 200, '{"data":[1,2],"meta":{"current_page":1,"last_page":3}}');
        Store.RegisterQueuedResponse('GET', 'clients', Query + '2', 200, '{"data":[3,4],"meta":{"current_page":2,"last_page":3}}');
        Store.RegisterQueuedResponse('GET', 'clients', Query + '3', 200, '{"data":[5],"meta":{"current_page":3,"last_page":3}}');
        Query := 'per_page=100&page=';
        Store.RegisterQueuedResponse('GET', 'clients', Query + '1', 200, '{"data":[1,2],"meta":{"current_page":1,"last_page":3}}');
        Store.RegisterQueuedResponse('GET', 'clients', Query + '2', 200, '{"data":[3],"meta":{"current_page":2,"last_page":3}}');
    end;

    local procedure CheckRequest(Requests: JsonArray; Index: Integer; Method: Text; Path: Text; Query: Text; Body: Text)
    var
        Token: JsonToken;
        Value: JsonToken;
    begin
        Requests.Get(Index, Token);
        Token.AsObject().Get('method', Value);
        Assert.AreEqual(Method, Value.AsValue().AsText(), 'Method.');
        Token.AsObject().Get('path', Value);
        Assert.AreEqual(Path, Value.AsValue().AsText(), 'Path.');
        Token.AsObject().Get('query', Value);
        Assert.AreEqual(Query, Value.AsValue().AsText(), 'Query.');
        Token.AsObject().Get('body', Value);
        Assert.AreEqual(Body, Value.AsValue().AsText(), 'Body.');
    end;

    local procedure CheckError(LanguageId: Integer; English: Text; Icelandic: Text)
    begin
        if LanguageId = 1039 then
            Assert.ExpectedError(Icelandic)
        else
            Assert.ExpectedError(English);
    end;

    local procedure Initialize(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
        Store: Codeunit "Manor Mock Store ori";
    begin
        LowerPermissions.SetOutsideO365Scope();
        PreviousLanguage := GlobalLanguage();
        GlobalLanguage(LanguageId);
        Store.Reset();
        Secrets.ClearApiKey();
        Setup.DeleteAll(true);
        Setup.GetRecordOnce();
        Commit();
        LowerPermissions.SetExactPermissionSet('Manor Setup Test ori');
        LowerPermissions.AddPermissionSet('BIFROST MnrFull ori');
    end;

    local procedure Cleanup()
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
        Store: Codeunit "Manor Mock Store ori";
    begin
        LowerPermissions.SetOutsideO365Scope();
        Secrets.ClearApiKey();
        Setup.DeleteAll(true);
        Store.Reset();
        GlobalLanguage(PreviousLanguage);
    end;
}
