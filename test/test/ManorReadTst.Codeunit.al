namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost;
using Origo.Bifrost.Manor;
using System.TestLibraries.Security.AccessControl;
using System.TestLibraries.Utilities;
using System.Utilities;

/// <summary>Issue 3: approved read messages through the public dispatcher, with no network or credentials.</summary>
codeunit 98230 "Manor Read Tst ori"
{
    Subtype = Test;
    TestPermissions = Restrictive;
    TestHttpRequestPolicy = BlockOutboundRequests;

    var
        OriginalSetup: Record "Manor Setup ori";
        Assert: Codeunit "Library Assert";
        LowerPermissions: Codeunit "Library - Lower Permissions";
        Store: Codeunit "Manor Mock Store ori";
        HadSetup: Boolean;
        PreviousLanguage: Integer;
        HttpCalls: Integer;

    /// <summary>Verifies Catalogue in LCID 1033.</summary>
    [Test]
    procedure CatalogueEnglish()
    begin
        Initialize(1033);
        VerifyCatalogue();
        Cleanup();
    end;

    /// <summary>Verifies Catalogue in LCID 1039.</summary>
    [Test]
    procedure CatalogueIcelandic()
    begin
        Initialize(1039);
        VerifyCatalogue();
        Cleanup();
    end;

    /// <summary>Verifies Ping in LCID 1033.</summary>
    [Test]
    procedure PingEnglish()
    begin
        Initialize(1033);
        VerifyPing();
        Cleanup();
    end;

    /// <summary>Verifies Ping in LCID 1039.</summary>
    [Test]
    procedure PingIcelandic()
    begin
        Initialize(1039);
        VerifyPing();
        Cleanup();
    end;

    /// <summary>Verifies Firms in LCID 1033.</summary>
    [Test]
    procedure FirmsEnglish()
    begin
        Initialize(1033);
        VerifyFirms();
        Cleanup();
    end;

    /// <summary>Verifies Firms in LCID 1039.</summary>
    [Test]
    procedure FirmsIcelandic()
    begin
        Initialize(1039);
        VerifyFirms();
        Cleanup();
    end;

    /// <summary>Verifies Users in LCID 1033.</summary>
    [Test]
    procedure UsersEnglish()
    begin
        Initialize(1033);
        VerifyUsers();
        Cleanup();
    end;

    /// <summary>Verifies Users in LCID 1039.</summary>
    [Test]
    procedure UsersIcelandic()
    begin
        Initialize(1039);
        VerifyUsers();
        Cleanup();
    end;

    /// <summary>Verifies UserId in LCID 1033.</summary>
    [Test]
    procedure UserIdEnglish()
    begin
        Initialize(1033);
        VerifyUserId();
        Cleanup();
    end;

    /// <summary>Verifies UserId in LCID 1039.</summary>
    [Test]
    procedure UserIdIcelandic()
    begin
        Initialize(1039);
        VerifyUserId();
        Cleanup();
    end;

    /// <summary>Verifies Email in LCID 1033.</summary>
    [Test]
    procedure EmailEnglish()
    begin
        Initialize(1033);
        VerifyEmail();
        Cleanup();
    end;

    /// <summary>Verifies Email in LCID 1039.</summary>
    [Test]
    procedure EmailIcelandic()
    begin
        Initialize(1039);
        VerifyEmail();
        Cleanup();
    end;

    /// <summary>Verifies Rates in LCID 1033.</summary>
    [Test]
    procedure RatesEnglish()
    begin
        Initialize(1033);
        VerifyRates();
        Cleanup();
    end;

    /// <summary>Verifies Rates in LCID 1039.</summary>
    [Test]
    procedure RatesIcelandic()
    begin
        Initialize(1039);
        VerifyRates();
        Cleanup();
    end;

    /// <summary>Verifies Empty in LCID 1033.</summary>
    [Test]
    procedure EmptyEnglish()
    begin
        Initialize(1033);
        VerifyEmpty();
        Cleanup();
    end;

    /// <summary>Verifies Empty in LCID 1039.</summary>
    [Test]
    procedure EmptyIcelandic()
    begin
        Initialize(1039);
        VerifyEmpty();
        Cleanup();
    end;

    /// <summary>Verifies Paging in LCID 1033.</summary>
    [Test]
    procedure PagingEnglish()
    begin
        Initialize(1033);
        VerifyPaging();
        Cleanup();
    end;

    /// <summary>Verifies Paging in LCID 1039.</summary>
    [Test]
    procedure PagingIcelandic()
    begin
        Initialize(1039);
        VerifyPaging();
        Cleanup();
    end;

    /// <summary>Verifies OwnsProjects in LCID 1033.</summary>
    [Test]
    procedure OwnsProjectsEnglish()
    begin
        Initialize(1033);
        VerifyOwns();
        Cleanup();
    end;

    /// <summary>Verifies OwnsProjects in LCID 1039.</summary>
    [Test]
    procedure OwnsProjectsIcelandic()
    begin
        Initialize(1039);
        VerifyOwns();
        Cleanup();
    end;

    /// <summary>Verifies ApprovesInvoices in LCID 1033.</summary>
    [Test]
    procedure ApprovesInvoicesEnglish()
    begin
        Initialize(1033);
        VerifyApproves();
        Cleanup();
    end;

    /// <summary>Verifies ApprovesInvoices in LCID 1039.</summary>
    [Test]
    procedure ApprovesInvoicesIcelandic()
    begin
        Initialize(1039);
        VerifyApproves();
        Cleanup();
    end;

    /// <summary>Verifies EnabledOnly in LCID 1033.</summary>
    [Test]
    procedure EnabledOnlyEnglish()
    begin
        Initialize(1033);
        VerifyEnabled();
        Cleanup();
    end;

    /// <summary>Verifies EnabledOnly in LCID 1039.</summary>
    [Test]
    procedure EnabledOnlyIcelandic()
    begin
        Initialize(1039);
        VerifyEnabled();
        Cleanup();
    end;

    /// <summary>Verifies CombinedFilters in LCID 1033.</summary>
    [Test]
    procedure CombinedFiltersEnglish()
    begin
        Initialize(1033);
        VerifyCombined();
        Cleanup();
    end;

    /// <summary>Verifies CombinedFilters in LCID 1039.</summary>
    [Test]
    procedure CombinedFiltersIcelandic()
    begin
        Initialize(1039);
        VerifyCombined();
        Cleanup();
    end;

    /// <summary>Verifies FalseFilters in LCID 1033.</summary>
    [Test]
    procedure FalseFiltersEnglish()
    begin
        Initialize(1033);
        VerifyFalse();
        Cleanup();
    end;

    /// <summary>Verifies FalseFilters in LCID 1039.</summary>
    [Test]
    procedure FalseFiltersIcelandic()
    begin
        Initialize(1039);
        VerifyFalse();
        Cleanup();
    end;

    /// <summary>Verifies InvalidTypes in LCID 1033.</summary>
    [Test]
    procedure InvalidTypesEnglish()
    begin
        Initialize(1033);
        VerifyInvalidTypes();
        Cleanup();
    end;

    /// <summary>Verifies InvalidTypes in LCID 1039.</summary>
    [Test]
    procedure InvalidTypesIcelandic()
    begin
        Initialize(1039);
        VerifyInvalidTypes();
        Cleanup();
    end;

    /// <summary>Verifies InvalidTargets in LCID 1033.</summary>
    [Test]
    procedure InvalidTargetsEnglish()
    begin
        Initialize(1033);
        VerifyInvalidTargets();
        Cleanup();
    end;

    /// <summary>Verifies InvalidTargets in LCID 1039.</summary>
    [Test]
    procedure InvalidTargetsIcelandic()
    begin
        Initialize(1039);
        VerifyInvalidTargets();
        Cleanup();
    end;

    /// <summary>Verifies InvalidRate in LCID 1033.</summary>
    [Test]
    procedure InvalidRateEnglish()
    begin
        Initialize(1033);
        VerifyInvalidRate();
        Cleanup();
    end;

    /// <summary>Verifies InvalidRate in LCID 1039.</summary>
    [Test]
    procedure InvalidRateIcelandic()
    begin
        Initialize(1039);
        VerifyInvalidRate();
        Cleanup();
    end;

    /// <summary>Verifies RateTypes in LCID 1033.</summary>
    [Test]
    procedure RateTypesEnglish()
    begin
        Initialize(1033);
        VerifyRateTypes();
        Cleanup();
    end;

    /// <summary>Verifies RateTypes in LCID 1039.</summary>
    [Test]
    procedure RateTypesIcelandic()
    begin
        Initialize(1039);
        VerifyRateTypes();
        Cleanup();
    end;

    /// <summary>Verifies Errors in LCID 1033.</summary>
    [Test]
    procedure ErrorsEnglish()
    begin
        Initialize(1033);
        VerifyErrors();
        Cleanup();
    end;

    /// <summary>Verifies Errors in LCID 1039.</summary>
    [Test]
    procedure ErrorsIcelandic()
    begin
        Initialize(1039);
        VerifyErrors();
        Cleanup();
    end;

    /// <summary>Verifies InvalidResponse in LCID 1033.</summary>
    [Test]
    procedure InvalidResponseEnglish()
    begin
        Initialize(1033);
        VerifyInvalidResponse();
        Cleanup();
    end;

    /// <summary>Verifies InvalidResponse in LCID 1039.</summary>
    [Test]
    procedure InvalidResponseIcelandic()
    begin
        Initialize(1039);
        VerifyInvalidResponse();
        Cleanup();
    end;

    /// <summary>Verifies real transport path validation and intercepted reads in English.</summary>
    [Test]
    [HandlerFunctions('ReadHttpHandler')]
    procedure HttpRoutesEnglish()
    begin
        Initialize(1033);
        VerifyHttpRoutes();
        Cleanup();
    end;

    /// <summary>Verifies real transport path validation and intercepted reads in Icelandic.</summary>
    [Test]
    [HandlerFunctions('ReadHttpHandler')]
    procedure HttpRoutesIcelandic()
    begin
        Initialize(1039);
        VerifyHttpRoutes();
        Cleanup();
    end;

    local procedure VerifyHttpRoutes()
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
        Client: Codeunit "Manor Client ori";
        Reply: JsonObject;
        TestKey: SecretText;
        Path: Text;
    begin
        LowerPermissions.SetOutsideO365Scope();
        Assert.IsFalse(Secrets.HasApiKey(), 'HTTP fixture must never replace an existing key');
        Setup.Get();
        Setup.Environment := Setup.Environment::Test;
        Setup.Instance := 'X';
        Setup.Modify(false);
        TestKey := Format(CreateGuid(), 0, 4);
        Secrets.SetApiKey(TestKey);
        Clear(TestKey);
        Commit();
        LowerPermissions.SetExactPermissionSet('Manor Setup Test ori');
        LowerPermissions.AddPermissionSet('BIFROST Read ori');
        LowerPermissions.AddPermissionSet('BIFROST API ori');
        HttpCalls := 0;
        Reply := Success("Message Type ori"::"Manor.Connection.Test", '{}', 1);
        Reply := Success("Message Type ori"::"Manor.Firm.List", '{}', 0);
        Reply := Success("Message Type ori"::"Manor.User.List", '{}', 0);
        Reply := Success("Message Type ori"::"Manor.User.Get", '{"userId":1}', 1);
        Reply := Success("Message Type ori"::"Manor.User.Get", '{"email":"x+demo@example.invalid"}', 1);
        Reply := Success("Message Type ori"::"Manor.Rate.List", '{}', 0);
        Assert.AreEqual(6, HttpCalls, 'All routes reached the HTTP handler without leaving BC');
        foreach Path in 'user/x%40example.invalid%2fproject|user/x%40example.invalid%3fquery|user/%252e%252e%40example.invalid|user/x%0a%40example.invalid'.Split('|') do
            asserterror Client.GetRead(Path, '');
        Assert.AreEqual(6, HttpCalls, 'Encoded path injection refused before HTTP');
        asserterror Client.Post('client', '{}');
        Assert.AreEqual(6, HttpCalls, 'Read role cannot send a write with the stored key');
        LowerPermissions.SetOutsideO365Scope();
        Secrets.ClearApiKey();
    end;

    /// <summary>Intercepts every transport call; the test policy blocks outbound network access.</summary>
    [HttpClientHandler]
    procedure ReadHttpHandler(Request: TestHttpRequestMessage; var Response: TestHttpResponseMessage): Boolean
    begin
        HttpCalls += 1;
        Assert.IsTrue(Request.HasSecretUri(), 'Configured instance stays in a secret URI');
        Assert.IsTrue(Request.RequestType = HttpRequestType::Get, 'Read method');
        Response.HttpStatusCode := 200;
        Response.Content.WriteFrom('{"data":[],"message":"XIntercepted"}');
        Response.IsSuccessfulRequest := true;
        exit(false);
    end;

    local procedure Initialize(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
    begin
        LowerPermissions.SetOutsideO365Scope();
        PreviousLanguage := GlobalLanguage();
        GlobalLanguage(LanguageId);
        HadSetup := OriginalSetup.Get();
        if HadSetup then
            Setup := OriginalSetup
        else begin
            Setup.Init();
            Setup.Insert(false);
        end;
        Setup.Environment := Setup.Environment::Mock;
        Setup.Enabled := true;
        Setup.Modify(false);
        Store.Reset();
        Commit();
        LowerPermissions.SetExactPermissionSet('Manor Setup Test ori');
        LowerPermissions.AddPermissionSet('BIFROST Read ori');
        LowerPermissions.AddPermissionSet('BIFROST API ori');
    end;

    local procedure Cleanup()
    var
        Setup: Record "Manor Setup ori";
    begin
        LowerPermissions.SetOutsideO365Scope();
        if HadSetup then begin
            Setup.Get();
            Setup.TransferFields(OriginalSetup, false);
            Setup.Modify(false);
        end else
            if Setup.Get() then
                Setup.Delete(false);
        Store.Reset();
        GlobalLanguage(PreviousLanguage);
    end;

    local procedure Execute(MessageType: Enum "Message Type ori"; Body: Text) Reply: JsonObject
    var
        Dispatcher: Codeunit "Dispatcher ori";
        ResponseBlob: Codeunit "Temp Blob";
        Input: BigText;
        Output: BigText;
        ResponseStream: InStream;
        ContentType: Text[100];
        Response: Text;
        EmptyTaskId: Guid;
        MessageId: Guid;
        ResponseTime: Duration;
    begin
        Input.AddText(Body);
        Dispatcher.EnqueueAndProcess(MessageType, "Message Version ori"::"1.0", '', '', 'text/json', Input, EmptyTaskId, GlobalLanguage(), MessageId, ResponseBlob, ContentType, ResponseTime, true);
        ResponseBlob.CreateInStream(ResponseStream);
        Output.Read(ResponseStream);
        Output.GetSubText(Response, 1);
        Assert.IsTrue(Reply.ReadFrom(Response), 'Dispatcher JSON: ' + Response);
    end;

    local procedure Success(MessageType: Enum "Message Type ori"; Body: Text; ExpectedCount: Integer) Reply: JsonObject
    begin
        Reply := Execute(MessageType, Body);
        Assert.AreEqual('Success', Reply.GetText('status'), 'Dispatcher status: ' + AsText(Reply));
        Assert.AreEqual(ExpectedCount, Reply.GetInteger('noOfRecords'), 'Returned rows');
    end;

    local procedure VerifyCatalogue()
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
        MessageType: Enum "Message Type ori";
        Contract: JsonObject;
        Impl: Interface "Msg Interface ori";
        Discovery: Interface "Msg Discovery ori";
        Ordinal: Integer;
    begin
        for Ordinal := 10035656 to 10035660 do begin
            MessageType := "Message Type ori".FromInteger(Ordinal);
            Impl := MessageType;
            Discovery := MessageType;
            Assert.IsTrue(Impl.IsEnabled(), 'Read permission enables catalogue entry');
            Assert.AreNotEqual('', Impl.GetDescription(), 'Localized description');
            Assert.AreNotEqual('', Discovery.GetKeywords(), 'Discovery keywords');
            Clear(Contract);
            Assert.IsTrue(ContractMgt.GetContract(MessageType, Contract), 'Contract registered');
            Assert.IsTrue(Contract.Contains('parameters'), 'Parameters chapter');
            Assert.IsTrue(Contract.Contains('response'), 'Response chapter');
            Assert.IsTrue(Contract.Contains('errors'), 'Errors chapter');
            Assert.IsTrue(Contract.GetObject('envelope').Contains('translations'), 'Icelandic metadata exposed in canonical catalogue');
            Assert.AreNotEqual(Contract.GetObject('response').GetText('description'), Contract.GetObject('response').GetObject('translations').GetObject('is-IS').GetText('description'), 'Translated response chapter');
            Assert.AreNotEqual(Contract.GetArray('errors').GetObject(0).GetText('when'), Contract.GetArray('errors').GetObject(0).GetObject('translations').GetObject('is-IS').GetText('when'), 'Translated error chapter');
            if Contract.GetArray('parameters').Count() > 0 then
                Assert.AreNotEqual(Contract.GetArray('parameters').GetObject(0).GetText('description'), Contract.GetArray('parameters').GetObject(0).GetObject('translations').GetObject('is-IS').GetText('description'), 'Translated parameter chapter');
            if GlobalLanguage() = 1039 then
                Assert.IsTrue(StrPos(AsText(Contract), 'Sýnir') + StrPos(AsText(Contract), 'Prófar') + StrPos(AsText(Contract), 'Les einn') > 0, 'Icelandic contract');
        end;
    end;

    local procedure VerifyPing()
    var
        Setup: Record "Manor Setup ori";
        Reply: JsonObject;
    begin
        Store.RegisterResponse('GET', 'ping', 200, '{"message":"XConnected"}');
        Reply := Success("Message Type ori"::"Manor.Connection.Test", '{}', 1);
        Assert.IsTrue(Reply.GetArray('result').GetObject(0).GetBoolean('ok'), 'Ping ok');
        Assert.AreEqual('XConnected', Reply.GetArray('result').GetObject(0).GetText('message'), 'Manor message');
        Setup.Get();
        Assert.AreNotEqual(0DT, Setup."Last Connection Test", 'Successful timestamp');
        AssertRequest('ping', '');
    end;

    local procedure VerifyFirms()
    var
        Reply: JsonObject;
    begin
        Store.RegisterResponse('GET', 'firm', 200, '{"data":[{"id":1,"name":"XDemo firm","currency_code":"ISK","default_vat_rate_id":24,"peppol_identifier":"XDemo"}],"meta":{"current_page":1,"last_page":1}}');
        Reply := Success("Message Type ori"::"Manor.Firm.List", '{}', 1);
        Assert.AreEqual(24, Reply.GetArray('result').GetObject(0).GetInteger('default_vat_rate_id'), 'Canonical VAT id');
        AssertRequest('firm', 'page=1&per_page=100');
    end;

    local procedure SeedUsers()
    begin
        Store.RegisterResponse('GET', 'user', 200, '{"data":[{"id":1,"name":"XEnabled","enabled":true,"owns_projects":true,"approves_invoices":true},{"id":2,"name":"XDisabled","enabled":false,"owns_projects":false,"approves_invoices":false}],"meta":{"current_page":1,"last_page":2,"total":3}}');
    end;

    local procedure VerifyUsers()
    var
        Reply: JsonObject;
    begin
        SeedUsers();
        Reply := Success("Message Type ori"::"Manor.User.List", '{}', 2);
        Assert.IsTrue(Reply.GetArray('result').GetObject(0).GetBoolean('enabled'), 'enabled retained');
        Assert.AreEqual(2, Reply.GetObject('meta').GetInteger('last_page'), 'Paging retained');
        AssertRequest('user', 'page=1&per_page=100');
    end;

    local procedure VerifyUserId()
    var
        Reply: JsonObject;
    begin
        Store.RegisterResponse('GET', 'user/9223372036854775807', 200, '{"id":9223372036854775807,"name":"XEmployee","enabled":true}');
        Reply := Success("Message Type ori"::"Manor.User.Get", '{"userId":9223372036854775807}', 1);
        Assert.AreEqual('XEmployee', Reply.GetArray('result').GetObject(0).GetText('name'), 'User mapped');
        AssertRequest('user/9223372036854775807', '');
    end;

    local procedure VerifyEmail()
    var
        Reply: JsonObject;
    begin
        Store.RegisterResponse('GET', 'user/x%2Bdemo%40example.invalid', 200, '{"id":7,"name":"XEmployee","enabled":true}');
        Reply := Success("Message Type ori"::"Manor.User.Get", '{"email":"x+demo@example.invalid"}', 1);
        AssertRequest('user/x%2Bdemo%40example.invalid', '');
    end;

    local procedure SeedRates()
    begin
        Store.RegisterResponse('GET', 'rate', 200, '{"data":[{"id":1,"name":"XTime","type":"time","price":100,"latest_price":110},{"id":2,"type":"travel"},{"id":3,"type":"product"},{"id":4,"type":"per_diem"}],"meta":{"current_page":1,"last_page":1}}');
    end;

    local procedure VerifyRates()
    var
        Reply: JsonObject;
    begin
        SeedRates();
        Reply := Success("Message Type ori"::"Manor.Rate.List", '{}', 4);
        Assert.AreEqual(110, Reply.GetArray('result').GetObject(0).GetInteger('latest_price'), 'Current price retained');
        AssertRequest('rate', 'page=1&per_page=100');
    end;

    local procedure VerifyEmpty()
    var
        Reply: JsonObject;
    begin
        Store.RegisterResponse('GET', 'firm', 200, '{"data":[]}');
        Store.RegisterResponse('GET', 'user', 200, '{"data":[]}');
        Store.RegisterResponse('GET', 'rate', 200, '{"data":[]}');
        Reply := Success("Message Type ori"::"Manor.Firm.List", '{}', 0);
        Reply := Success("Message Type ori"::"Manor.User.List", '{}', 0);
        Reply := Success("Message Type ori"::"Manor.Rate.List", '{}', 0);
    end;

    local procedure VerifyPaging()
    var
        Reply: JsonObject;
    begin
        Store.RegisterQueuedResponse('GET', 'user', 'page=2&per_page=1&updated_since=2026-01-01T00%3a00%3a00Z', 200, '{"data":[{"id":3,"enabled":true}],"meta":{"current_page":2,"last_page":2,"total":3}}');
        Reply := Success("Message Type ori"::"Manor.User.List", '{"page":2,"perPage":1,"updated_since":"2026-01-01T00:00:00Z"}', 1);
        Assert.AreEqual(3, Reply.GetArray('result').GetObject(0).GetInteger('id'), 'Requested second page');
    end;

    local procedure VerifyOwns()
    var
        Reply: JsonObject;
    begin
        SeedUsers();
        Reply := Success("Message Type ori"::"Manor.User.List", '{"owns_projects":true}', 2);
        AssertRequest('user', 'page=1&per_page=100&owns_projects=true');
    end;

    local procedure VerifyApproves()
    var
        Reply: JsonObject;
    begin
        SeedUsers();
        Reply := Success("Message Type ori"::"Manor.User.List", '{"approves_invoices":true}', 2);
        AssertRequest('user', 'page=1&per_page=100&approves_invoices=true');
    end;

    local procedure VerifyEnabled()
    var
        Reply: JsonObject;
    begin
        SeedUsers();
        Reply := Success("Message Type ori"::"Manor.User.List", '{"enabledOnly":true}', 1);
        Assert.AreEqual(1, Reply.GetArray('result').GetObject(0).GetInteger('id'), 'Disabled user excluded');
        AssertRequest('user', 'page=1&per_page=100');
    end;

    local procedure VerifyCombined()
    var
        Reply: JsonObject;
    begin
        SeedUsers();
        Reply := Success("Message Type ori"::"Manor.User.List", '{"owns_projects":true,"approves_invoices":true,"enabledOnly":true}', 1);
        AssertRequest('user', 'page=1&per_page=100&owns_projects=true&approves_invoices=true');
    end;

    local procedure VerifyFalse()
    var
        Reply: JsonObject;
    begin
        SeedUsers();
        Reply := Success("Message Type ori"::"Manor.User.List", '{"owns_projects":false,"approves_invoices":false,"enabledOnly":false}', 2);
        AssertRequest('user', 'page=1&per_page=100&owns_projects=false&approves_invoices=false');
    end;

    local procedure Reject(MessageType: Enum "Message Type ori"; Body: Text)
    var
        Reply: JsonObject;
    begin
        Store.Reset();
        asserterror Reply := Execute(MessageType, Body);
        Assert.AreEqual(0, Store.GetRequests().Count(), 'Refused before transport');
    end;

    local procedure VerifyInvalidTypes()
    var
        Body: Text;
    begin
        foreach Body in '{"page":0}|{"page":1.5}|{"page":"1"}|{"perPage":101}|{"perPage":0}|{"owns_projects":"true"}|{"approves_invoices":null}|{"enabledOnly":{}}|{"updated_since":"bad"}'.Split('|') do
            Reject("Message Type ori"::"Manor.User.List", Body);
    end;

    local procedure VerifyInvalidTargets()
    var
        Body: Text;
    begin
        foreach Body in '{}|{"userId":1,"email":"x@example.invalid"}|{"userId":0}|{"userId":-1}|{"userId":"1"}|{"email":""}|{"email":true}'.Split('|') do
            Reject("Message Type ori"::"Manor.User.Get", Body);
    end;

    local procedure VerifyInvalidRate()
    var
        Reply: JsonObject;
    begin
        Reject("Message Type ori"::"Manor.Rate.List", '{"type":"mileage"}');
        asserterror Reply := Execute("Message Type ori"::"Manor.Rate.List", '{"type":"unknown"}');
        Assert.IsTrue(StrPos(GetLastErrorText(), 'time, travel, product') > 0, 'Allowed types listed');
    end;

    local procedure VerifyRateTypes()
    var
        RateType: Text;
        Reply: JsonObject;
    begin
        SeedRates();
        foreach RateType in 'time|travel|product|per_diem'.Split('|') do begin
            Reply := Success("Message Type ori"::"Manor.Rate.List", '{"type":"' + RateType + '"}', 1);
            Assert.AreEqual(RateType, Reply.GetArray('result').GetObject(0).GetText('type'), 'Local rate filter');
        end;
        AssertRequest('rate', 'page=1&per_page=100');
    end;

    local procedure VerifyErrors()
    var
        StatusCode: Integer;
        StatusCodes: List of [Integer];
        Reply: JsonObject;
        ErrorText: Text;
    begin
        StatusCodes.AddRange(401, 403, 404, 422);
        foreach StatusCode in StatusCodes do begin
            Store.Reset();
            Store.RegisterResponse('GET', 'rate', StatusCode, '{"message":"XDO-NOT-ECHO","errors":{"key":["XDO-NOT-ECHO"]}}');
            asserterror Reply := Execute("Message Type ori"::"Manor.Rate.List", '{}');
            ErrorText := GetLastErrorText();
            Assert.AreEqual(0, StrPos(ErrorText, 'XDO-NOT-ECHO'), 'No raw server error echoed');
            if StatusCode = 403 then
                Assert.IsTrue(StrPos(ErrorText, 'manage_rates') > 0, 'Permission hint');
            if GlobalLanguage() = 1039 then
                Assert.IsTrue(StrPos(ErrorText, 'hafnaði') + StrPos(ErrorText, 'fann ekki') > 0, 'Icelandic mapped error');
        end;
    end;

    local procedure VerifyInvalidResponse()
    var
        Reply: JsonObject;
    begin
        Store.RegisterResponse('GET', 'user', 200, '{"data":{}}');
        asserterror Reply := Execute("Message Type ori"::"Manor.User.List", '{}');
    end;

    local procedure AsText(Value: JsonObject) Result: Text
    begin
        Value.WriteTo(Result);
    end;

    local procedure AssertRequest(ExpectedPath: Text; ExpectedQuery: Text)
    var
        Request: JsonObject;
    begin
        Request := Store.GetRequests().GetObject(0);
        Assert.AreEqual('GET', Request.GetText('method'), 'HTTP method');
        Assert.AreEqual(ExpectedPath, Request.GetText('path'), 'HTTP path');
        Assert.AreEqual(ExpectedQuery, Request.GetText('query'), 'HTTP query');
        Assert.AreEqual('', Request.GetText('body'), 'No write body');
    end;
}
