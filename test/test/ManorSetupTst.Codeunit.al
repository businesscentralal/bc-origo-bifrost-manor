namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost.Manor;
using System.TestLibraries.Security.AccessControl;
using System.TestLibraries.Utilities;

/// <summary>Story A: setup, secret lifecycle, validation, transport and restrictive roles in both languages.</summary>
codeunit 98202 "Manor Setup Tst ori"
{
    Subtype = Test;
    TestPermissions = Restrictive;
    TestHttpRequestPolicy = BlockOutboundRequests;

    var
        Assert: Codeunit "Library Assert";
        LowerPermissions: Codeunit "Library - Lower Permissions";
        PermissionsMock: Codeunit "Permissions Mock";
        PreviousLanguage: Integer;
        CancelKeyDialog: Boolean;
        HttpCalls: Integer;

    /// <summary>Checks DefaultsAndPage in LCID 1033.</summary>
    [Test]
    [HandlerFunctions('KeyDialogHandler')]
    procedure Scenario_AC01_DefaultsAndPageEnglish()
    begin
        VerifyPage(1033);
    end;

    /// <summary>Checks DefaultsAndPage in LCID 1039.</summary>
    [Test]
    [HandlerFunctions('KeyDialogHandler')]
    procedure Scenario_AC01_DefaultsAndPageIcelandic()
    begin
        VerifyPage(1039);
    end;

    /// <summary>Checks SecretCleanup in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_SecretCleanupEnglish()
    begin
        VerifySecretCleanup(1033);
    end;

    /// <summary>Checks SecretCleanup in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_SecretCleanupIcelandic()
    begin
        VerifySecretCleanup(1039);
    end;

    /// <summary>Checks CancelKeyDialog in LCID 1033.</summary>
    [Test]
    [HandlerFunctions('KeyDialogHandler')]
    procedure Scenario_AC02_CancelKeyDialogEnglish()
    begin
        VerifyCancel(1033);
    end;

    /// <summary>Checks CancelKeyDialog in LCID 1039.</summary>
    [Test]
    [HandlerFunctions('KeyDialogHandler')]
    procedure Scenario_AC02_CancelKeyDialogIcelandic()
    begin
        VerifyCancel(1039);
    end;

    /// <summary>Checks UrlsAndInvalidInstances in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_UrlsAndInvalidInstancesEnglish()
    begin
        VerifyUrls(1033);
    end;

    /// <summary>Checks UrlsAndInvalidInstances in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_UrlsAndInvalidInstancesIcelandic()
    begin
        VerifyUrls(1039);
    end;

    /// <summary>Checks MockResponsesNoNetwork in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC04_MockResponsesNoNetworkEnglish()
    begin
        VerifyMock(1033);
    end;

    /// <summary>Checks MockResponsesNoNetwork in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC04_MockResponsesNoNetworkIcelandic()
    begin
        VerifyMock(1039);
    end;

    /// <summary>Checks MissingConfiguration in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC05_MissingConfigurationEnglish()
    begin
        VerifyValidation(1033);
    end;

    /// <summary>Checks MissingConfiguration in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC05_MissingConfigurationIcelandic()
    begin
        VerifyValidation(1039);
    end;

    /// <summary>Checks ReadAndFullPermissions in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_ReadAndFullPermissionsEnglish()
    begin
        VerifyPermissions(1033);
    end;

    /// <summary>Checks ReadAndFullPermissions in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_ReadAndFullPermissionsIcelandic()
    begin
        VerifyPermissions(1039);
    end;

    /// <summary>Exercises HTTP results using an intercepting handler in LCID 1033; no request is released.</summary>
    [Test]
    [HandlerFunctions('HttpResponseHandler')]
    procedure Scenario_AC03_HttpResultsEnglish()
    begin
        VerifyHttp(1033);
    end;

    /// <summary>Rejects invalid HTTP targets before opening a connection in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_InvalidHttpTargetsEnglish()
    begin
        VerifyHttpTargets(1033);
    end;

    /// <summary>Exercises HTTP results using an intercepting handler in LCID 1039; no request is released.</summary>
    [Test]
    [HandlerFunctions('HttpResponseHandler')]
    procedure Scenario_AC03_HttpResultsIcelandic()
    begin
        VerifyHttp(1039);
    end;

    /// <summary>Rejects invalid HTTP targets before opening a connection in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_InvalidHttpTargetsIcelandic()
    begin
        VerifyHttpTargets(1039);
    end;

    local procedure VerifyHttp(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
        Response: Codeunit "Manor Response ori";
        Transport: Interface "Manor Transport ori";
        TestKey: SecretText;
    begin
        // [GIVEN] A generated key and an HTTP handler that never releases an outbound request.
        Initialize(LanguageId);
        Setup.Get();
        Setup.Enabled := true;
        Setup.Environment := Setup.Environment::Test;
        Setup.Validate(Instance, 'X');
        Setup.Modify(true);
        TestKey := Format(CreateGuid(), 0, 4);
        Secrets.SetApiKey(TestKey);
        Clear(TestKey);
        Transport := Setup.Environment;
        HttpCalls := 0;
        // [WHEN/THEN] Success, HTTP failure, and a transport failure replace response state.
        Assert.IsTrue(Transport.Send('GET', 'projects', 'page=1', '', Response), 'A mocked 200 must succeed.');
        Assert.AreEqual(200, Response.GetStatusCode(), 'Successful HTTP status.');
        Assert.AreEqual('{"data":[]}', Response.GetBody(), 'Successful HTTP body.');
        Assert.IsFalse(Transport.Send('POST', 'projects', '', '{}', Response), 'A mocked 503 must fail.');
        Assert.AreEqual(503, Response.GetStatusCode(), 'Failed HTTP status.');
        Assert.IsFalse(Transport.Send('GET', 'projects', '', '', Response), 'A mocked transport failure must return false.');
        Assert.AreEqual(0, Response.GetStatusCode(), 'Transport failure must not retain the earlier status.');
        Assert.AreEqual('', Response.GetBody(), 'Transport failure must not retain the earlier body.');
        Assert.AreEqual(3, HttpCalls, 'Every HTTP attempt must have been intercepted.');
        Cleanup();
    end;

    local procedure VerifyHttpTargets(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
        Response: Codeunit "Manor Response ori";
        Environment: Enum "Manor Environment ori";
        Transport: Interface "Manor Transport ori";
        TestKey: SecretText;
        Paths: List of [Text];
        InvalidPath: Text;
    begin
        // [GIVEN] Valid non-Mock setup, with HTTP blocked by the test policy.
        Initialize(LanguageId);
        Setup.Get();
        Setup.Enabled := true;
        Setup.Environment := Setup.Environment::Production;
        Setup.Validate(Instance, 'X');
        Setup.Modify(true);
        TestKey := Format(CreateGuid(), 0, 4);
        Secrets.SetApiKey(TestKey);
        Clear(TestKey);
        // Preserve valid configuration across the expected path-validation errors.
        Commit();
        Transport := Environment::Production;
        Paths.Add('');
        Paths.Add('/projects');
        Paths.Add('../projects');
        Paths.Add('https://example.invalid');
        Paths.Add('%2e%2e/projects');
        Paths.Add('projects?x=1');
        Paths.Add('projects#X');
        // [WHEN/THEN] Every invalid target fails with the path-validation error before HTTP.
        foreach InvalidPath in Paths do begin
            asserterror Transport.Send('GET', InvalidPath, '', '', Response);
            CheckError(LanguageId, 'Use a relative Manor API path', 'Notaðu afstæða Manor API-slóð');
        end;
        asserterror Transport.Send('GET', 'projects', 'x=1#X', '', Response);
        CheckError(LanguageId, 'Use a relative Manor API path', 'Notaðu afstæða Manor API-slóð');
        Setup.Environment := Setup.Environment::Mock;
        Setup.Modify(true);
        asserterror Transport.Send('GET', 'projects', '', '', Response);
        CheckError(LanguageId, 'Select Production or Test', 'Veldu raunumhverfi eða prófunarumhverfi');
        Cleanup();
    end;

    /// <summary>Intercepts all requests, verifies secret URI use, and simulates responses without network access.</summary>
    [HttpClientHandler]
    procedure HttpResponseHandler(Request: TestHttpRequestMessage; var Response: TestHttpResponseMessage): Boolean
    begin
        HttpCalls += 1;
        Assert.IsTrue(Request.HasSecretUri(), 'The configured instance must not be exposed in request telemetry.');
        Response.HttpStatusCode := 200;
        Response.Content.WriteFrom('{"data":[]}');
        if HttpCalls = 2 then
            Response.HttpStatusCode := 503;
        Response.IsSuccessfulRequest := HttpCalls < 3;
        exit(false);
    end;

    local procedure VerifyPage(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
        SetupPage: TestPage "Manor Setup ori";
    begin
        // [GIVEN] No connection configured and the full setup role.
        Initialize(LanguageId);
        SetupPage.OpenEdit();
        Setup.Get();
        Assert.AreEqual(Setup.Environment::Mock, Setup.Environment, 'The safe default must be Mock.');
        Assert.IsFalse(Setup.Enabled, 'The connection must start disabled.');
        Assert.IsFalse(SetupPage.HasApiKey.Editable(), 'The key indicator is read-only.');
        // [WHEN] An administrator configures the page and stores a generated test-only value.
        SetupPage.Environment.SetValue(Setup.Environment::Production);
        SetupPage.Environment.SetValue(Setup.Environment::Test);
        SetupPage.Instance.SetValue('X-Test_1');
        SetupPage.Enabled.SetValue(true);
        SetupPage.SetApiKey.Invoke();
        // [THEN] The page reports only presence; clear removes the stored value.
        Assert.IsTrue(Secrets.HasApiKey(), 'Setting the key must create company-scoped storage.');
        SetupPage.HasApiKey.AssertEquals(true);
        SetupPage.ClearApiKey.Invoke();
        SetupPage.HasApiKey.AssertEquals(false);
        Assert.IsFalse(Secrets.HasApiKey(), 'Clear must remove storage.');
        SetupPage.Close();
        Setup.Get();
        Assert.AreEqual('X-Test_1', Setup.Instance, 'The page must save the instance.');
        Assert.AreEqual(Setup.Environment::Test, Setup.Environment, 'The page must save the environment.');
        Assert.IsTrue(Setup.Enabled, 'The page must save enabled.');
        Cleanup();
    end;

    local procedure VerifySecretCleanup(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
        EmptyKey: SecretText;
        TestKey: SecretText;
    begin
        // [GIVEN] An empty company-scoped secret store.
        Initialize(LanguageId);
        // [WHEN] An empty value is rejected, then a synthetic value is set and replaced.
        asserterror Secrets.SetApiKey(EmptyKey);
        Assert.IsFalse(Secrets.HasApiKey(), 'Rejected empty input must not create a secret.');
        TestKey := Format(CreateGuid(), 0, 4);
        Secrets.SetApiKey(TestKey);
        TestKey := Format(CreateGuid(), 0, 4);
        Secrets.SetApiKey(TestKey);
        Clear(TestKey);
        Assert.IsTrue(Secrets.HasApiKey(), 'Replacing a key must preserve presence.');
        Setup.Get();
        Setup.Delete(true);
        // [THEN] Deleting the setup removes the key and clearing again is harmless.
        Assert.IsFalse(Secrets.HasApiKey(), 'Deleting setup must remove its secret.');
        Secrets.ClearApiKey();
        Cleanup();
    end;

    local procedure VerifyCancel(LanguageId: Integer)
    var
        Secrets: Codeunit "Manor Secrets ori";
        SetupPage: TestPage "Manor Setup ori";
    begin
        // [GIVEN] An empty store and a dialog cancelled after data entry.
        Initialize(LanguageId);
        CancelKeyDialog := true;
        SetupPage.OpenEdit();
        // [WHEN] The action is cancelled.
        SetupPage.SetApiKey.Invoke();
        // [THEN] No credential is retained.
        Assert.IsFalse(Secrets.HasApiKey(), 'Cancelling must not persist input.');
        SetupPage.Close();
        Cleanup();
    end;

    local procedure VerifyUrls(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
        Environment: Enum "Manor Environment ori";
        Transport: Interface "Manor Transport ori";
        Invalid: Text;
        Values: List of [Text];
    begin
        // [GIVEN] Production and Test use the same fixed host, with synthetic path segments.
        Initialize(LanguageId);
        Transport := Environment::Production;
        Assert.AreEqual('https://secure.manor.is/X-Test_1/external-api/v1', Transport.BuildBaseUrl('X-Test_1'), 'Production base URL.');
        Transport := Environment::Test;
        Assert.AreEqual('https://secure.manor.is/X-Test_1/external-api/v1', Transport.BuildBaseUrl('X-Test_1'), 'Test base URL.');
        Assert.AreEqual('https://secure.manor.is/' + PadStr('X', 100, 'a') + '/external-api/v1', Transport.BuildBaseUrl(PadStr('X', 100, 'a')), 'Maximum length must be accepted.');
        // [WHEN] Invalid path segments and overlength values are supplied.
        Values.Add('../X');
        Values.Add('X/Y');
        Values.Add('X%2fY');
        Values.Add('X?Y');
        Values.Add('X Y');
        Values.Add('Xá');
        Values.Add('X\Y');
        Values.Add(PadStr('X', 101, 'a'));
        foreach Invalid in Values do begin
            asserterror Setup.ValidateInstance(Invalid);
            Assert.IsTrue(GetLastErrorText() <> '', 'Each invalid segment must fail.');
            asserterror Transport.BuildBaseUrl(Invalid);
        end;
        asserterror Transport.BuildBaseUrl('');
        // [THEN] Table validation also protects the page and the singleton key.
        Setup.Get();
        asserterror Setup.Validate(Instance, '../X');
        asserterror Setup.Rename('X');
        Cleanup();
    end;

    local procedure VerifyMock(LanguageId: Integer)
    var
        Response: Codeunit "Manor Response ori";
        Store: Codeunit "Manor Mock Store ori";
        Environment: Enum "Manor Environment ori";
        Transport: Interface "Manor Transport ori";
        Requests: JsonArray;
        Token: JsonToken;
        Request: JsonObject;
        Value: JsonToken;
    begin
        // [GIVEN] Outbound HTTP is blocked by TestHttpRequestPolicy; no credentials exist.
        Initialize(LanguageId);
        Transport := Environment::Mock;
        Store.RegisterResponse('GET', 'projects', 200, '{"data":[]}');
        Store.RegisterResponse('POST', 'projects', 422, '{"errors":{}}');
        // [WHEN] Both registered and missing routes are invoked.
        Assert.IsTrue(Transport.Send('get', 'projects', 'page=2', '', Response), 'Registered success should succeed without HTTP.');
        Assert.AreEqual(200, Response.GetStatusCode(), 'Success status.');
        Assert.AreEqual('{"data":[]}', Response.GetBody(), 'Canned body.');
        Assert.IsFalse(Transport.Send('POST', 'projects', '', '{"name":"X"}', Response), 'Non-success status must return false.');
        Assert.AreEqual(422, Response.GetStatusCode(), 'Failure status.');
        Assert.IsFalse(Transport.Send('GET', 'missing', '', '', Response), 'Unregistered routes must fail deterministically.');
        Assert.AreEqual(404, Response.GetStatusCode(), 'Missing route status must replace earlier state.');
        Assert.AreEqual('{}', Response.GetBody(), 'Missing route body must replace earlier state.');
        // [THEN] Every request is recorded with method, path, query and body.
        Requests := Store.GetRequests();
        Assert.AreEqual(3, Requests.Count(), 'All requests must be captured.');
        Requests.Get(0, Token);
        Request := Token.AsObject();
        Request.Get('method', Value);
        Assert.AreEqual('GET', Value.AsValue().AsText(), 'Recorded method.');
        Request.Get('path', Value);
        Assert.AreEqual('projects', Value.AsValue().AsText(), 'Recorded path.');
        Request.Get('query', Value);
        Assert.AreEqual('page=2', Value.AsValue().AsText(), 'Recorded query.');
        Requests.Get(1, Token);
        Request := Token.AsObject();
        Request.Get('body', Value);
        Assert.AreEqual('{"name":"X"}', Value.AsValue().AsText(), 'Recorded request body.');
        Store.RegisterResponse('GET', 'projects', 204, '');
        Assert.IsTrue(Transport.Send('GET', 'projects', '', '', Response), 'Replacing a response must work.');
        Assert.AreEqual(204, Response.GetStatusCode(), 'Replacement status.');
        Store.Reset();
        Requests := Store.GetRequests();
        Assert.AreEqual(0, Requests.Count(), 'Reset must remove request history.');
        Assert.IsFalse(Transport.Send('GET', 'projects', '', '', Response), 'Reset must remove canned responses.');
        Assert.AreEqual('', Transport.BuildBaseUrl(''), 'Mock needs no instance or URL.');
        Cleanup();
    end;

    local procedure VerifyValidation(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
        TestKey: SecretText;
    begin
        // [GIVEN] Disabled defaults and no instance or key.
        Initialize(LanguageId);
        Setup.Get();
        // [WHEN/THEN] Each missing part has a localized error, and Mock needs neither credential nor instance.
        asserterror Setup.ValidateSetup();
        CheckError(LanguageId, 'Enable the Manor connection in Manor Setup.', 'Virkjaðu tenginguna við Manor í uppsetningu Manor.');
        Setup.Enabled := true;
        Setup.ValidateSetup();
        Setup.Environment := Setup.Environment::Production;
        asserterror Setup.ValidateSetup();
        CheckError(LanguageId, 'Enter the Manor instance in Manor Setup.', 'Sláðu inn Manor-tilvikið í uppsetningu Manor.');
        Setup.Validate(Instance, 'X');
        asserterror Setup.ValidateSetup();
        CheckError(LanguageId, 'Set the API key in Manor Setup.', 'Stilltu API-lykilinn í uppsetningu Manor.');
        TestKey := Format(CreateGuid(), 0, 4);
        Secrets.SetApiKey(TestKey);
        Clear(TestKey);
        Setup.ValidateSetup();
        Setup.Environment := Setup.Environment::Test;
        Setup.ValidateSetup();
        Cleanup();
    end;

    local procedure VerifyPermissions(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
        SetupPage: TestPage "Manor Setup ori";
        TestKey: SecretText;
    begin
        // [GIVEN] Real permission mocking and a record created using the full role.
        Initialize(LanguageId);
        Assert.IsTrue(PermissionsMock.IsStarted(), 'The runner must enable restrictive permission mocking.');
        Setup.Get();
        Setup.Validate(Instance, 'X');
        Setup.Modify(true);
        TestKey := Format(CreateGuid(), 0, 4);
        Secrets.SetApiKey(TestKey);
        // Denied writes must be tested against an already-persisted key.
        Commit();
        LowerPermissions.SetExactPermissionSet('Manor Setup Test ori');
        LowerPermissions.AddPermissionSet('BIFROST MnrRead ori');
        // [WHEN] The read role opens the actual card and attempts both data and secret changes.
        SetupPage.OpenView();
        Assert.IsFalse(SetupPage.Editable(), 'The read role cannot edit the card.');
        SetupPage.HasApiKey.AssertEquals(true);
        SetupPage.Close();
        Setup.Get();
        Assert.IsFalse(Setup.WritePermission(), 'Read must not imply setup-write permission.');
        Setup.Enabled := true;
        asserterror Setup.Modify(true);
        asserterror Secrets.SetApiKey(TestKey);
        asserterror Secrets.ClearApiKey();
        Assert.IsTrue(Secrets.HasApiKey(), 'Denied writes must preserve the secret.');
        // [THEN] Full can edit and remove the key.
        LowerPermissions.SetExactPermissionSet('Manor Setup Test ori');
        LowerPermissions.AddPermissionSet('BIFROST MnrFull ori');
        SetupPage.OpenEdit();
        Assert.IsTrue(SetupPage.Editable(), 'Full can edit the card.');
        SetupPage.Enabled.SetValue(true);
        SetupPage.ClearApiKey.Invoke();
        SetupPage.Close();
        Assert.IsFalse(Secrets.HasApiKey(), 'Full can clear storage.');
        Clear(TestKey);
        Cleanup();
    end;

    /// <summary>Enters a generated, non-provider test value and confirms or cancels the masked dialog.</summary>
    [ModalPageHandler]
    procedure KeyDialogHandler(var KeyDialog: TestPage "Manor API Key ori")
    begin
        KeyDialog.ApiKeyInput.SetValue(Format(CreateGuid(), 0, 4));
        if CancelKeyDialog then
            KeyDialog.Cancel().Invoke()
        else
            KeyDialog.OK().Invoke();
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
        CancelKeyDialog := false;
        Store.Reset();
        Secrets.ClearApiKey();
        Setup.DeleteAll(true);
        Setup.GetRecordOnce();
        // Expected errors roll back the current transaction; retain the self-seeded fixture.
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
