namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost;
using Origo.Bifrost.Manor;
using System.TestLibraries.Security.AccessControl;
using System.TestLibraries.Utilities;

/// <summary>Story D: the Manor read message types (clients, projects, activities) over the Mock transport in both languages.</summary>
codeunit 98240 "Manor Read Msg Tst ori"
{
    Subtype = Test;
    TestPermissions = Disabled;
    TestHttpRequestPolicy = BlockOutboundRequests;

    var
        Assert: Codeunit "Library Assert";
        LowerPermissions: Codeunit "Library - Lower Permissions";
        Store: Codeunit "Manor Mock Store ori";
        PreviousLanguage: Integer;

    /// <summary>Checks ContractChapters in LCID 1033.</summary>
    [Test]
    procedure Scenario_ContractChaptersEnglish()
    begin
        VerifyContractChapters(1033);
    end;

    /// <summary>Checks ContractChapters in LCID 1039.</summary>
    [Test]
    procedure Scenario_ContractChaptersIcelandic()
    begin
        VerifyContractChapters(1039);
    end;

    /// <summary>Checks ClientListPaging in LCID 1033.</summary>
    [Test]
    procedure Scenario_ClientListPagingEnglish()
    begin
        VerifyClientListPaging(1033);
    end;

    /// <summary>Checks ClientListPaging in LCID 1039.</summary>
    [Test]
    procedure Scenario_ClientListPagingIcelandic()
    begin
        VerifyClientListPaging(1039);
    end;

    /// <summary>Checks ClientListEmpty in LCID 1033.</summary>
    [Test]
    procedure Scenario_ClientListEmptyEnglish()
    begin
        VerifyClientListEmpty(1033);
    end;

    /// <summary>Checks ClientListEmpty in LCID 1039.</summary>
    [Test]
    procedure Scenario_ClientListEmptyIcelandic()
    begin
        VerifyClientListEmpty(1039);
    end;

    /// <summary>Checks ClientGetById in LCID 1033.</summary>
    [Test]
    procedure Scenario_ClientGetByIdEnglish()
    begin
        VerifyClientGetById(1033);
    end;

    /// <summary>Checks ClientGetById in LCID 1039.</summary>
    [Test]
    procedure Scenario_ClientGetByIdIcelandic()
    begin
        VerifyClientGetById(1039);
    end;

    /// <summary>Checks ClientGetByNationalId in LCID 1033.</summary>
    [Test]
    procedure Scenario_ClientGetByNationalIdEnglish()
    begin
        VerifyClientGetByNationalId(1033);
    end;

    /// <summary>Checks ClientGetByNationalId in LCID 1039.</summary>
    [Test]
    procedure Scenario_ClientGetByNationalIdIcelandic()
    begin
        VerifyClientGetByNationalId(1039);
    end;

    /// <summary>Checks ClientGetIdentifierProblems in LCID 1033.</summary>
    [Test]
    procedure Scenario_ClientGetIdentifierProblemsEnglish()
    begin
        VerifyClientGetIdentifierProblems(1033);
    end;

    /// <summary>Checks ClientGetIdentifierProblems in LCID 1039.</summary>
    [Test]
    procedure Scenario_ClientGetIdentifierProblemsIcelandic()
    begin
        VerifyClientGetIdentifierProblems(1039);
    end;

    /// <summary>Checks ClientGetNotFound in LCID 1033.</summary>
    [Test]
    procedure Scenario_ClientGetNotFoundEnglish()
    begin
        VerifyClientGetNotFound(1033);
    end;

    /// <summary>Checks ClientGetNotFound in LCID 1039.</summary>
    [Test]
    procedure Scenario_ClientGetNotFoundIcelandic()
    begin
        VerifyClientGetNotFound(1039);
    end;

    /// <summary>Checks ProjectListDefaultOpen in LCID 1033.</summary>
    [Test]
    procedure Scenario_ProjectListDefaultOpenEnglish()
    begin
        VerifyProjectListDefaultOpen(1033);
    end;

    /// <summary>Checks ProjectListDefaultOpen in LCID 1039.</summary>
    [Test]
    procedure Scenario_ProjectListDefaultOpenIcelandic()
    begin
        VerifyProjectListDefaultOpen(1039);
    end;

    /// <summary>Checks ProjectListFilters in LCID 1033.</summary>
    [Test]
    procedure Scenario_ProjectListFiltersEnglish()
    begin
        VerifyProjectListFilters(1033);
    end;

    /// <summary>Checks ProjectListFilters in LCID 1039.</summary>
    [Test]
    procedure Scenario_ProjectListFiltersIcelandic()
    begin
        VerifyProjectListFilters(1039);
    end;

    /// <summary>Checks ProjectListBadStatus in LCID 1033.</summary>
    [Test]
    procedure Scenario_ProjectListBadStatusEnglish()
    begin
        VerifyProjectListBadStatus(1033);
    end;

    /// <summary>Checks ProjectListBadStatus in LCID 1039.</summary>
    [Test]
    procedure Scenario_ProjectListBadStatusIcelandic()
    begin
        VerifyProjectListBadStatus(1039);
    end;

    /// <summary>Checks ProjectGetById in LCID 1033.</summary>
    [Test]
    procedure Scenario_ProjectGetByIdEnglish()
    begin
        VerifyProjectGetById(1033);
    end;

    /// <summary>Checks ProjectGetById in LCID 1039.</summary>
    [Test]
    procedure Scenario_ProjectGetByIdIcelandic()
    begin
        VerifyProjectGetById(1039);
    end;

    /// <summary>Checks ProjectGetByIdentifier in LCID 1033.</summary>
    [Test]
    procedure Scenario_ProjectGetByIdentifierEnglish()
    begin
        VerifyProjectGetByIdentifier(1033);
    end;

    /// <summary>Checks ProjectGetByIdentifier in LCID 1039.</summary>
    [Test]
    procedure Scenario_ProjectGetByIdentifierIcelandic()
    begin
        VerifyProjectGetByIdentifier(1039);
    end;

    /// <summary>Checks ProjectGetAmbiguous in LCID 1033.</summary>
    [Test]
    procedure Scenario_ProjectGetAmbiguousEnglish()
    begin
        VerifyProjectGetAmbiguous(1033);
    end;

    /// <summary>Checks ProjectGetAmbiguous in LCID 1039.</summary>
    [Test]
    procedure Scenario_ProjectGetAmbiguousIcelandic()
    begin
        VerifyProjectGetAmbiguous(1039);
    end;

    /// <summary>Checks ActivityListPath in LCID 1033.</summary>
    [Test]
    procedure Scenario_ActivityListPathEnglish()
    begin
        VerifyActivityListPath(1033);
    end;

    /// <summary>Checks ActivityListPath in LCID 1039.</summary>
    [Test]
    procedure Scenario_ActivityListPathIcelandic()
    begin
        VerifyActivityListPath(1039);
    end;

    /// <summary>Checks ActivityListMissingProject in LCID 1033.</summary>
    [Test]
    procedure Scenario_ActivityListMissingProjectEnglish()
    begin
        VerifyActivityListMissingProject(1033);
    end;

    /// <summary>Checks ActivityListMissingProject in LCID 1039.</summary>
    [Test]
    procedure Scenario_ActivityListMissingProjectIcelandic()
    begin
        VerifyActivityListMissingProject(1039);
    end;

    /// <summary>Checks ActivityListForbidden in LCID 1033.</summary>
    [Test]
    procedure Scenario_ActivityListForbiddenEnglish()
    begin
        VerifyActivityListForbidden(1033);
    end;

    /// <summary>Checks ActivityListForbidden in LCID 1039.</summary>
    [Test]
    procedure Scenario_ActivityListForbiddenIcelandic()
    begin
        VerifyActivityListForbidden(1039);
    end;

    /// <summary>Checks ClientListRejectedAndValidation in LCID 1033.</summary>
    [Test]
    procedure Scenario_ClientListRejectedAndValidationEnglish()
    begin
        VerifyClientListRejectedAndValidation(1033);
    end;

    /// <summary>Checks ClientListRejectedAndValidation in LCID 1039.</summary>
    [Test]
    procedure Scenario_ClientListRejectedAndValidationIcelandic()
    begin
        VerifyClientListRejectedAndValidation(1039);
    end;

    /// <summary>Checks MissingSetup in LCID 1033.</summary>
    [Test]
    procedure Scenario_MissingSetupEnglish()
    begin
        VerifyMissingSetup(1033);
    end;

    /// <summary>Checks NoSecretInErrors in LCID 1033.</summary>
    [Test]
    procedure Scenario_NoSecretInErrorsEnglish()
    begin
        VerifyNoSecretInErrors(1033);
    end;

    /// <summary>Checks MissingSetup in LCID 1039.</summary>
    [Test]
    procedure Scenario_MissingSetupIcelandic()
    begin
        VerifyMissingSetup(1039);
    end;

    /// <summary>Checks NoSecretInErrors in LCID 1039.</summary>
    [Test]
    procedure Scenario_NoSecretInErrorsIcelandic()
    begin
        VerifyNoSecretInErrors(1039);
    end;

    local procedure VerifyContractChapters(LanguageId: Integer)
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
        Contract: JsonObject;
        MessageType: Enum "Message Type ori";
        Msg: Interface "Msg Contract ori";
        Discovery: Interface "Msg Discovery ori";
        Name: Text;
        Ordinal: Integer;
        Token: JsonToken;
        Parameters: JsonArray;
        Errors: JsonArray;
        Effect: JsonObject;
        Overview: Text;
    begin
        Initialize(LanguageId);
        foreach Name in TypeNames() do begin
            MessageType := Enum::"Message Type ori".FromInteger(Enum::"Message Type ori".Ordinals().Get(Enum::"Message Type ori".Names().IndexOf(Name)));
            Assert.IsTrue(ContractMgt.GetContract(MessageType, Contract), Name + ' has a contract.');
            Msg := MessageType;
            Discovery := MessageType;
            Assert.IsTrue(Msg.GetEffect(Effect), Name + ' effect.');
            Effect.Get('effect', Token);
            Assert.AreEqual('read', Token.AsValue().AsText(), Name + ' is a read.');
            Assert.IsTrue(Msg.GetErrors(Errors), Name + ' errors.');
            Assert.IsTrue(Errors.Count() >= 4, Name + ' documents its errors.');
            Assert.IsTrue(Msg.GetOverview(Overview), Name + ' overview.');
            Assert.AreNotEqual('', Discovery.GetKeywords(), Name + ' keywords.');
            Msg.GetParameters(Parameters);
            Assert.IsTrue(Parameters.Count() >= 2, Name + ' parameters.');
            Ordinal += 1;
        end;
        Assert.AreEqual(5, Ordinal, 'Five types.');
        // [THEN] The text follows the session language.
        MessageType := Enum::"Message Type ori"::"Manor.Client.List";
        Discovery := MessageType;
        if LanguageId = 1039 then
            Assert.IsTrue(Discovery.GetSelectionDescription().Contains('viðskiptavini'), 'Icelandic selection text.')
        else
            Assert.IsTrue(Discovery.GetSelectionDescription().Contains('Lists Manor clients'), 'English selection text.');
        Cleanup();
    end;

    local procedure VerifyClientListPaging(LanguageId: Integer)
    var
        Response: JsonObject;
        Data: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'client', 200, '{"data":[{"id":1,"name":"A ehf.","currency_code":"ISK","special_attention":true},{"id":2,"name":"B ehf."}],"meta":{"current_page":2,"last_page":3,"per_page":2,"total":5}}');
        Response := Run(Enum::"Message Type ori"::"Manor.Client.List", '{"updatedSince":"2026-11-01T00:00:00Z","page":2,"perPage":2}');
        Assert.AreEqual('Success', GetText(Response, 'status'), 'Status.');
        Data := GetObject(Response, 'data');
        Assert.AreEqual(2, GetArray(Data, 'clients').Count(), 'Clients.');
        Assert.AreEqual(2, GetInt(Data, 'page'), 'Page.');
        Assert.AreEqual(3, GetInt(Data, 'lastPage'), 'Last page.');
        Assert.AreEqual(5, GetInt(Data, 'total'), 'Total.');
        Assert.AreEqual(2, GetInt(Data, 'count'), 'Count.');
        Assert.IsTrue(GetBool(Data, 'hasMore'), 'More pages follow.');
        CheckRequest(0, 'GET', 'client', 'updated_since=2026-11-01T00%3a00%3a00Z&page=2&per_page=2');
        Cleanup();
    end;

    local procedure VerifyClientListEmpty(LanguageId: Integer)
    var
        Response: JsonObject;
        Data: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'client', 200, '{"data":[]}');
        Response := Run(Enum::"Message Type ori"::"Manor.Client.List", '{}');
        Data := GetObject(Response, 'data');
        Assert.AreEqual(0, GetArray(Data, 'clients').Count(), 'No clients.');
        Assert.AreEqual(0, GetInt(Data, 'total'), 'Total.');
        Assert.AreEqual(1, GetInt(Data, 'lastPage'), 'Last page.');
        Assert.IsFalse(GetBool(Data, 'hasMore'), 'No more pages.');
        CheckRequest(0, 'GET', 'client', 'page=1&per_page=100');
        Cleanup();
    end;

    local procedure VerifyClientGetById(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'client/7', 200, '{"data":{"id":7,"name":"Seven ehf.","currency_code":"EUR"}}');
        Response := Run(Enum::"Message Type ori"::"Manor.Client.Get", '{"clientId":7}');
        Assert.AreEqual('Seven ehf.', GetText(GetObject(GetObject(Response, 'data'), 'client'), 'name'), 'Client name.');
        CheckRequest(0, 'GET', 'client/7', '');
        Cleanup();
    end;

    local procedure VerifyClientGetByNationalId(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'client-by-national-id/0101012980', 200, '{"id":9,"name":"Nine ehf.","national_id":"0101012980"}');
        Response := Run(Enum::"Message Type ori"::"Manor.Client.Get", '{"nationalId":"0101012980"}');
        Assert.AreEqual('Nine ehf.', GetText(GetObject(GetObject(Response, 'data'), 'client'), 'name'), 'Client name.');
        CheckRequest(0, 'GET', 'client-by-national-id/0101012980', '');
        Cleanup();
    end;

    local procedure VerifyClientGetIdentifierProblems(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Response := Run(Enum::"Message Type ori"::"Manor.Client.Get", '{}');
        Assert.AreEqual('MissingParameter', GetText(Response, 'code'), 'Neither identifier.');
        Response := Run(Enum::"Message Type ori"::"Manor.Client.Get", '{"clientId":7,"nationalId":"0101012980"}');
        Assert.AreEqual('ConflictingIdentifiers', GetText(Response, 'code'), 'Both identifiers.');
        Response := Run(Enum::"Message Type ori"::"Manor.Client.Get", '{"clientId":"abc"}');
        Assert.AreEqual('InvalidParameterFormat', GetText(Response, 'code'), 'Bad id.');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'Manor is never called for a bad request.');
        Cleanup();
    end;

    local procedure VerifyClientGetNotFound(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'client-by-national-id/9912345678', 404, '{"message":"Not found"}');
        Response := Run(Enum::"Message Type ori"::"Manor.Client.Get", '{"nationalId":"9912345678"}');
        Assert.AreEqual('RecordNotFound', GetText(Response, 'code'), 'Not found.');
        Assert.AreEqual('nationalId', GetText(Response, 'parameter'), 'Parameter.');
        Assert.IsTrue(GetText(Response, 'nextStep').Contains('Manor.Client.List'), 'Suggests a search by name.');
        Cleanup();
    end;

    local procedure VerifyProjectListDefaultOpen(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'project', 200, '{"data":[{"id":3,"identifier":"M-3","open":true}],"meta":{"current_page":1,"last_page":1,"total":1}}');
        Response := Run(Enum::"Message Type ori"::"Manor.Project.List", '{}');
        Assert.AreEqual(1, GetArray(GetObject(Response, 'data'), 'projects').Count(), 'Projects.');
        CheckRequest(0, 'GET', 'project', 'page=1&per_page=100&status=open');
        Cleanup();
    end;

    local procedure VerifyProjectListFilters(LanguageId: Integer)
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'project', 200, '{"data":[]}');
        Run(Enum::"Message Type ori"::"Manor.Project.List", '{"status":"CLOSED","clientId":"12","identifier":"A B","withActivities":true}');
        Run(Enum::"Message Type ori"::"Manor.Project.List", '{"status":"all"}');
        CheckRequest(0, 'GET', 'project', 'page=1&per_page=100&status=closed&client_id=12&identifier=A+B&with_activities=true');
        CheckRequest(1, 'GET', 'project', 'page=1&per_page=100&status=all');
        Cleanup();
    end;

    local procedure VerifyProjectListBadStatus(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Response := Run(Enum::"Message Type ori"::"Manor.Project.List", '{"status":"paused"}');
        Assert.AreEqual('InvalidParameter', GetText(Response, 'code'), 'Bad status.');
        Assert.AreEqual('status', GetText(Response, 'parameter'), 'Parameter.');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'Manor is not called.');
        Cleanup();
    end;

    local procedure VerifyProjectGetById(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'project/3', 200, '{"data":{"id":3,"identifier":"M-3","open":false}}');
        Response := Run(Enum::"Message Type ori"::"Manor.Project.Get", '{"projectId":3}');
        Assert.AreEqual('M-3', GetText(GetObject(GetObject(Response, 'data'), 'project'), 'identifier'), 'Identifier.');
        CheckRequest(0, 'GET', 'project/3', '');
        Cleanup();
    end;

    local procedure VerifyProjectGetByIdentifier(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'project-by-identifier/M-3', 200, '{"data":[{"id":3,"identifier":"M-3"}]}');
        Response := Run(Enum::"Message Type ori"::"Manor.Project.Get", '{"identifier":"M-3"}');
        Assert.AreEqual(3, GetInt(GetObject(GetObject(Response, 'data'), 'project'), 'id'), 'Project id.');
        CheckRequest(0, 'GET', 'project-by-identifier/M-3', '');
        Cleanup();
    end;

    local procedure VerifyProjectGetAmbiguous(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'project-by-identifier/X1', 200, '{"data":[{"id":3},{"id":4}]}');
        Response := Run(Enum::"Message Type ori"::"Manor.Project.Get", '{"identifier":"X1"}');
        Assert.AreEqual('AmbiguousRecord', GetText(Response, 'code'), 'More than one match.');
        Cleanup();
    end;

    local procedure VerifyActivityListPath(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'project/12/activity', 200, '{"data":[{"id":1,"name":"Design"},{"id":2,"name":"Build"}],"meta":{"current_page":1,"last_page":1,"total":2}}');
        Response := Run(Enum::"Message Type ori"::"Manor.Activity.List", '{"projectId":12}');
        Assert.AreEqual(2, GetArray(GetObject(Response, 'data'), 'activities').Count(), 'Activities.');
        CheckRequest(0, 'GET', 'project/12/activity', 'page=1&per_page=100');
        Cleanup();
    end;

    local procedure VerifyActivityListMissingProject(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Response := Run(Enum::"Message Type ori"::"Manor.Activity.List", '{}');
        Assert.AreEqual('MissingParameter', GetText(Response, 'code'), 'Missing project.');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'Manor is not called.');
        Cleanup();
    end;

    local procedure VerifyActivityListForbidden(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'project/12/activity', 403, '{"message":"Requires manage_activities"}');
        Response := Run(Enum::"Message Type ori"::"Manor.Activity.List", '{"projectId":12}');
        Assert.AreEqual('PermissionDenied', GetText(Response, 'code'), 'Forbidden.');
        Assert.IsTrue(GetText(Response, 'error').Contains('manage_activities'), 'Names the permission.');
        Assert.IsTrue(GetText(Response, 'nextStep').Contains('manage_activities'), 'Hint names the permission.');
        Cleanup();
    end;

    local procedure VerifyClientListRejectedAndValidation(LanguageId: Integer)
    var
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('GET', 'client', 401, '{}');
        Response := Run(Enum::"Message Type ori"::"Manor.Client.List", '{}');
        Assert.AreEqual('PermissionDenied', GetText(Response, 'code'), '401.');
        Store.RegisterResponse('GET', 'client', 422, '{"errors":{"updated_since":["invalid"]}}');
        Response := Run(Enum::"Message Type ori"::"Manor.Client.List", '{}');
        Assert.AreEqual('InvalidParameter', GetText(Response, 'code'), '422.');
        Assert.IsTrue(GetText(Response, 'error').Contains('updated_since'), 'Field message.');
        Response := Run(Enum::"Message Type ori"::"Manor.Client.List", '{"perPage":500,"updatedSince":"yesterday"}');
        Assert.AreEqual('MultipleErrors', GetText(Response, 'code'), 'Two request problems.');
        Cleanup();
    end;

    local procedure VerifyMissingSetup(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Setup.DeleteAll(true);
        Response := Run(Enum::"Message Type ori"::"Manor.Client.List", '{}');
        Assert.AreEqual('PreconditionFailed', GetText(Response, 'code'), 'No setup.');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'Manor is not called.');
        Cleanup();
    end;

    local procedure VerifyNoSecretInErrors(LanguageId: Integer)
    var
        Secrets: Codeunit "Manor Secrets ori";
        Response: JsonObject;
        ResponseText: Text;
        KeyValue: SecretText;
        KeyText: Text;
    begin
        Initialize(LanguageId);
        KeyText := Format(CreateGuid(), 0, 4);
        KeyValue := KeyText;
        Secrets.SetApiKey(KeyValue);
        Store.RegisterResponse('GET', 'project/5', 403, '{"message":"' + KeyText + ' is not allowed"}');
        Response := Run(Enum::"Message Type ori"::"Manor.Project.Get", '{"projectId":5}');
        Response.WriteTo(ResponseText);
        Assert.IsFalse(ResponseText.Contains(KeyText), 'The key is never echoed.');
        Cleanup();
    end;

    local procedure Run(MessageType: Enum "Message Type ori"; RequestText: Text) Response: JsonObject
    var
        Dispatcher: Codeunit "Dispatcher ori";
        RequestContent: BigText;
        ResponseContent: BigText;
        ResponseContentType: Text[100];
        ResponseText: Text;
    begin
        RequestContent.AddText(RequestText);
        Dispatcher.Execute(MessageType, Enum::"Message Version ori"::"1.0", '', '', 'application/json', RequestContent, ResponseContent, ResponseContentType);
        ResponseContent.GetSubText(ResponseText, 1);
        Response.ReadFrom(ResponseText);
    end;

    local procedure TypeNames() Names: List of [Text]
    begin
        Names.Add('Manor.Client.List');
        Names.Add('Manor.Client.Get');
        Names.Add('Manor.Project.List');
        Names.Add('Manor.Project.Get');
        Names.Add('Manor.Activity.List');
    end;

    local procedure CheckRequest(Index: Integer; Method: Text; Path: Text; Query: Text)
    var
        Requests: JsonArray;
        Token: JsonToken;
        Request: JsonObject;
    begin
        Requests := Store.GetRequests();
        Assert.IsTrue(Requests.Count() > Index, 'Request ' + Format(Index) + ' was sent.');
        Requests.Get(Index, Token);
        Request := Token.AsObject();
        Assert.AreEqual(Method, GetText(Request, 'method'), 'Method.');
        Assert.AreEqual(Path, GetText(Request, 'path'), 'Path.');
        Assert.AreEqual(Query, GetText(Request, 'query'), 'Query.');
        Assert.AreEqual('', GetText(Request, 'body'), 'A read sends no body.');
    end;

    local procedure GetText(Source: JsonObject; PropertyName: Text): Text
    var
        Token: JsonToken;
    begin
        if Source.Get(PropertyName, Token) then
            exit(Token.AsValue().AsText());
    end;

    local procedure GetInt(Source: JsonObject; PropertyName: Text): Integer
    var
        Token: JsonToken;
    begin
        Source.Get(PropertyName, Token);
        exit(Token.AsValue().AsInteger());
    end;

    local procedure GetBool(Source: JsonObject; PropertyName: Text): Boolean
    var
        Token: JsonToken;
    begin
        Source.Get(PropertyName, Token);
        exit(Token.AsValue().AsBoolean());
    end;

    local procedure GetObject(Source: JsonObject; PropertyName: Text) Result: JsonObject
    var
        Token: JsonToken;
    begin
        Source.Get(PropertyName, Token);
        Result := Token.AsObject();
    end;

    local procedure GetArray(Source: JsonObject; PropertyName: Text) Result: JsonArray
    var
        Token: JsonToken;
    begin
        Source.Get(PropertyName, Token);
        Result := Token.AsArray();
    end;

    local procedure Initialize(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
    begin
        LowerPermissions.SetOutsideO365Scope();
        PreviousLanguage := GlobalLanguage();
        GlobalLanguage(LanguageId);
        Store.Reset();
        Secrets.ClearApiKey();
        Setup.DeleteAll(true);
        Setup.GetRecordOnce();
        Commit();
    end;

    local procedure Cleanup()
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
    begin
        LowerPermissions.SetOutsideO365Scope();
        Secrets.ClearApiKey();
        Setup.DeleteAll(true);
        Store.Reset();
        GlobalLanguage(PreviousLanguage);
    end;
}
