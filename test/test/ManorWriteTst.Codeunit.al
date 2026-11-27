namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost;
using Origo.Bifrost.Manor;
using System.TestLibraries.Security.AccessControl;
using System.TestLibraries.Utilities;

/// <summary>Manor write message types over the Mock transport: endpoints, expectedCount, duplicate and currency rules, errors and contracts in both languages.</summary>
codeunit 98260 "Manor Write Tst ori"
{
    Subtype = Test;
    TestPermissions = Restrictive;
    TestHttpRequestPolicy = BlockOutboundRequests;

    var
        Assert: Codeunit "Library Assert";
        LowerPermissions: Codeunit "Library - Lower Permissions";
        PreviousLanguage: Integer;

    /// <summary>Checks ClientCreateNew in LCID 1033.</summary>
    [Test]
    procedure Scenario_ClientCreateNewEnglish()
    begin
        VerifyCreateNew(1033);
    end;

    /// <summary>Checks ClientCreateNew in LCID 1039.</summary>
    [Test]
    procedure Scenario_ClientCreateNewIcelandic()
    begin
        VerifyCreateNew(1039);
    end;

    /// <summary>Checks ClientCreateDuplicate in LCID 1033.</summary>
    [Test]
    procedure Scenario_ClientCreateDuplicateEnglish()
    begin
        VerifyCreateDuplicate(1033);
    end;

    /// <summary>Checks ClientCreateDuplicate in LCID 1039.</summary>
    [Test]
    procedure Scenario_ClientCreateDuplicateIcelandic()
    begin
        VerifyCreateDuplicate(1039);
    end;

    /// <summary>Checks ClientUpdateCurrencyFlag in LCID 1033.</summary>
    [Test]
    procedure Scenario_ClientUpdateCurrencyFlagEnglish()
    begin
        VerifyCurrencyFlag(1033);
    end;

    /// <summary>Checks ClientUpdateCurrencyFlag in LCID 1039.</summary>
    [Test]
    procedure Scenario_ClientUpdateCurrencyFlagIcelandic()
    begin
        VerifyCurrencyFlag(1039);
    end;

    /// <summary>Checks ExpectedCountMismatch in LCID 1033.</summary>
    [Test]
    procedure Scenario_ExpectedCountMismatchEnglish()
    begin
        VerifyCountMismatch(1033);
    end;

    /// <summary>Checks ExpectedCountMismatch in LCID 1039.</summary>
    [Test]
    procedure Scenario_ExpectedCountMismatchIcelandic()
    begin
        VerifyCountMismatch(1039);
    end;

    /// <summary>Checks ProjectBilling in LCID 1033.</summary>
    [Test]
    procedure Scenario_ProjectBillingEnglish()
    begin
        VerifyBilling(1033);
    end;

    /// <summary>Checks ProjectBilling in LCID 1039.</summary>
    [Test]
    procedure Scenario_ProjectBillingIcelandic()
    begin
        VerifyBilling(1039);
    end;

    /// <summary>Checks ProjectCloseReopen in LCID 1033.</summary>
    [Test]
    procedure Scenario_ProjectCloseReopenEnglish()
    begin
        VerifyCloseReopen(1033);
    end;

    /// <summary>Checks ProjectCloseReopen in LCID 1039.</summary>
    [Test]
    procedure Scenario_ProjectCloseReopenIcelandic()
    begin
        VerifyCloseReopen(1039);
    end;

    /// <summary>Checks ActivityCreateUpdate in LCID 1033.</summary>
    [Test]
    procedure Scenario_ActivityCreateUpdateEnglish()
    begin
        VerifyActivityPaths(1033);
    end;

    /// <summary>Checks ActivityCreateUpdate in LCID 1039.</summary>
    [Test]
    procedure Scenario_ActivityCreateUpdateIcelandic()
    begin
        VerifyActivityPaths(1039);
    end;

    /// <summary>Checks ErrorMapping in LCID 1033.</summary>
    [Test]
    procedure Scenario_ErrorMappingEnglish()
    begin
        VerifyErrors(1033);
    end;

    /// <summary>Checks ErrorMapping in LCID 1039.</summary>
    [Test]
    procedure Scenario_ErrorMappingIcelandic()
    begin
        VerifyErrors(1039);
    end;

    /// <summary>Checks ContractsDiscoverable in LCID 1033.</summary>
    [Test]
    procedure Scenario_ContractsDiscoverableEnglish()
    begin
        VerifyContracts(1033);
    end;

    /// <summary>Checks ContractsDiscoverable in LCID 1039.</summary>
    [Test]
    procedure Scenario_ContractsDiscoverableIcelandic()
    begin
        VerifyContracts(1039);
    end;

    local procedure VerifyCreateNew(LanguageId: Integer)
    var
        Store: Codeunit "Manor Mock Store ori";
        Result: JsonObject;
    begin
        // [GIVEN] A kennitala Manor does not know, and a create response.
        Initialize(LanguageId);
        Store.RegisterResponse('POST', '/client', 201, '{"data":{"id":10,"name":"Demo Client"}}');
        // [WHEN] The client is created.
        Result := Run(Enum::"Message Type ori"::"Manor.Client.Create", '{"expectedCount":1,"name":"Demo Client","national_id":"0101010000","currency_code":"ISK"}');
        // [THEN] One lookup and one POST ran, and the record is Created with Manor's id.
        Assert.AreEqual('Success', Result.GetText('status'), Format(Result));
        Assert.AreEqual(2, Store.GetRequests().Count(), 'Lookup and POST.');
        CheckRequest(Store, 0, 'GET', '/client-by-national-id/0101010000', '');
        CheckRequest(Store, 1, 'POST', '/client', '{"name":"Demo Client","national_id":"0101010000","currency_code":"ISK"}');
        Assert.AreEqual('Created', FirstResult(Result).GetText('status'), 'Status.');
        Assert.AreEqual('10', FirstResult(Result).GetText('id'), 'Id.');
        Cleanup();
    end;

    local procedure VerifyCreateDuplicate(LanguageId: Integer)
    var
        Store: Codeunit "Manor Mock Store ori";
        Result: JsonObject;
    begin
        // [GIVEN] A client with the same kennitala already exists.
        Initialize(LanguageId);
        Store.RegisterResponse('GET', '/client-by-national-id/0101010000', 200, '{"data":{"id":77}}');
        // [WHEN] Create is called.
        Result := Run(Enum::"Message Type ori"::"Manor.Client.Create", '{"expectedCount":1,"name":"Demo Client","national_id":"0101010000","currency_code":"ISK"}');
        // [THEN] It is refused, names client 77 and sends no POST.
        Assert.AreEqual('Failed', FirstResult(Result).GetText('status'), 'Status.');
        Assert.IsTrue(StrPos(FirstResult(Result).GetText('error'), '77') > 0, 'Names the existing id.');
        Assert.AreEqual(1, Store.GetRequests().Count(), 'Only the lookup.');
        Cleanup();
    end;

    local procedure VerifyCurrencyFlag(LanguageId: Integer)
    var
        Store: Codeunit "Manor Mock Store ori";
        Result: JsonObject;
    begin
        // [GIVEN] Update responses.
        Initialize(LanguageId);
        Store.RegisterResponse('PUT', '/client/10', 200, '{"data":{"id":10}}');
        // [WHEN] A currency change is sent without the flag.
        Result := Run(Enum::"Message Type ori"::"Manor.Client.Update", '{"expectedCount":1,"id":"10","currency_code":"EUR"}');
        // [THEN] It is refused before any call.
        Assert.AreEqual('Error', Result.GetText('status'), 'Refused: ' + Format(Result));
        Assert.AreEqual('confirmCurrencyChange', Result.GetText('parameter'), 'Names the flag.');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'No call.');
        // [WHEN] With the flag, and another field without it.
        Result := Run(Enum::"Message Type ori"::"Manor.Client.Update", '{"expectedCount":1,"id":"10","currency_code":"EUR","confirmCurrencyChange":true}');
        Assert.AreEqual('Updated', FirstResult(Result).GetText('status'), 'Flagged update.');
        CheckRequest(Store, 0, 'PUT', '/client/10', '{"currency_code":"EUR"}');
        Result := Run(Enum::"Message Type ori"::"Manor.Client.Update", '{"expectedCount":1,"id":"10","email":"a@example.com"}');
        // [THEN] Both go through.
        Assert.AreEqual('Updated', FirstResult(Result).GetText('status'), 'Unflagged other field.');
        CheckRequest(Store, 1, 'PUT', '/client/10', '{"email":"a@example.com"}');
        Cleanup();
    end;

    local procedure VerifyCountMismatch(LanguageId: Integer)
    var
        Store: Codeunit "Manor Mock Store ori";
        Result: JsonObject;
    begin
        // [GIVEN] Two records but expectedCount 1.
        Initialize(LanguageId);
        // [WHEN] The call is made.
        Result := Run(Enum::"Message Type ori"::"Manor.Project.Create", '{"expectedCount":1,"records":[{"name":"A","owner":"1"},{"name":"B","owner":"1"}]}');
        // [THEN] It is refused before Manor is called; a missing expectedCount is refused as well.
        Assert.AreEqual('Error', Result.GetText('status'), 'Refused.');
        Assert.AreEqual('expectedCount', Result.GetText('parameter'), 'Parameter.');
        Result := Run(Enum::"Message Type ori"::"Manor.Project.Create", '{"name":"A","owner":"1"}');
        Assert.AreEqual('Error', Result.GetText('status'), 'Missing count refused.');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'No call.');
        Cleanup();
    end;

    local procedure VerifyBilling(LanguageId: Integer)
    var
        Store: Codeunit "Manor Mock Store ori";
        Result: JsonObject;
        Value: Text;
    begin
        // [GIVEN] A create response.
        Initialize(LanguageId);
        Store.RegisterResponse('POST', '/project', 201, '{"data":{"id":20}}');
        // [WHEN] Each of the three billing values is sent.
        foreach Value in 'enabled,internal,sensitive'.Split(',') do begin
            Result := Run(Enum::"Message Type ori"::"Manor.Project.Create", '{"expectedCount":1,"name":"P","owner":"1","billing":"' + Value + '"}');
            Assert.AreEqual('Created', FirstResult(Result).GetText('status'), Value);
        end;
        // [THEN] Any other value is refused and nothing more is sent.
        Result := Run(Enum::"Message Type ori"::"Manor.Project.Create", '{"expectedCount":1,"name":"P","owner":"1","billing":"free"}');
        Assert.AreEqual('billing', Result.GetText('parameter'), 'Refused value.');
        Assert.AreEqual(3, Store.GetRequests().Count(), 'Three calls only.');
        Cleanup();
    end;

    local procedure VerifyCloseReopen(LanguageId: Integer)
    var
        Store: Codeunit "Manor Mock Store ori";
        Result: JsonObject;
    begin
        // [GIVEN] Manor accepts the close and refuses the reopen with a 422.
        Initialize(LanguageId);
        Store.RegisterQueuedResponse('PUT', '/project/20', '', 200, '{"data":{"id":20,"open":false}}');
        Store.RegisterQueuedResponse('PUT', '/project/20', '', 422, '{"errors":{"open":["Only the owner can reopen."]}}');
        // [WHEN] The project is closed, then reopened.
        Result := Run(Enum::"Message Type ori"::"Manor.Project.Update", '{"expectedCount":1,"id":"20","open":false,"closing_comment":"Done"}');
        Assert.AreEqual('Updated', FirstResult(Result).GetText('status'), 'Close.');
        CheckRequest(Store, 0, 'PUT', '/project/20', '{"open":false,"closing_comment":"Done"}');
        Result := Run(Enum::"Message Type ori"::"Manor.Project.Update", '{"expectedCount":1,"id":"20","open":true}');
        // [THEN] Manor's refusal is returned to the caller unchanged.
        Assert.AreEqual('Failed', FirstResult(Result).GetText('status'), 'Reopen refused by Manor.');
        Assert.IsTrue(StrPos(FirstResult(Result).GetText('error'), 'Only the owner can reopen.') > 0, 'Manor message returned.');
        Cleanup();
    end;

    local procedure VerifyActivityPaths(LanguageId: Integer)
    var
        Store: Codeunit "Manor Mock Store ori";
        Result: JsonObject;
    begin
        // [GIVEN] Activity responses.
        Initialize(LanguageId);
        Store.RegisterResponse('POST', '/project/20/activity', 201, '{"data":{"id":30}}');
        Store.RegisterResponse('PUT', '/project/20/activity/30', 200, '{"data":{"id":30}}');
        // [WHEN] An activity is created and updated.
        Result := Run(Enum::"Message Type ori"::"Manor.Activity.Create", '{"expectedCount":1,"projectId":"20","name":"Design","budget":100}');
        Assert.AreEqual('30', FirstResult(Result).GetText('id'), 'Created id.');
        Result := Run(Enum::"Message Type ori"::"Manor.Activity.Update", '{"expectedCount":1,"projectId":"20","id":"30","name":"Design phase"}');
        // [THEN] The paths and bodies are right; ids never enter the body.
        Assert.AreEqual('Updated', FirstResult(Result).GetText('status'), 'Updated.');
        CheckRequest(Store, 0, 'POST', '/project/20/activity', '{"name":"Design","budget":100}');
        CheckRequest(Store, 1, 'PUT', '/project/20/activity/30', '{"name":"Design phase"}');
        Cleanup();
    end;

    local procedure VerifyErrors(LanguageId: Integer)
    var
        Store: Codeunit "Manor Mock Store ori";
        Result: JsonObject;
        Results: JsonArray;
        Token: JsonToken;
    begin
        // [GIVEN] Manor answers 403 (manage_activities), 404, 400 and 422 for four updates.
        Initialize(LanguageId);
        Store.RegisterResponse('PUT', '/project/20/activity/1', 403, '{"message":"Requires manage_activities"}');
        Store.RegisterResponse('PUT', '/project/20/activity/2', 404, '{}');
        Store.RegisterResponse('PUT', '/project/20/activity/3', 400, '{"message":"Cannot update activity in settlement project"}');
        Store.RegisterResponse('PUT', '/project/20/activity/4', 422, '{"errors":{"ends_at":["must be after begins_at"]}}');
        // [WHEN] One request carries all four records.
        Result := Run(Enum::"Message Type ori"::"Manor.Activity.Update", '{"expectedCount":4,"records":[{"projectId":"20","id":"1","name":"a"},{"projectId":"20","id":"2","name":"b"},{"projectId":"20","id":"3","name":"c"},{"projectId":"20","id":"4","ends_at":"2026-01-01"}]}');
        // [THEN] Every record reports its own mapped error, with the permission hint, and no key.
        Assert.AreEqual('Failed', Result.GetText('status'), 'Overall.');
        Assert.AreEqual(4, Result.GetInteger('failed'), 'Failed count.');
        Result.Get('results', Token);
        Results := Token.AsArray();
        Results.Get(0, Token);
        Assert.IsTrue(StrPos(Token.AsObject().GetText('error'), 'manage_activities') > 0, 'Permission hint.');
        Results.Get(2, Token);
        Assert.IsTrue(StrPos(Token.AsObject().GetText('error'), 'settlement project') > 0, 'Settlement message.');
        Results.Get(3, Token);
        Assert.IsTrue(StrPos(Token.AsObject().GetText('error'), 'ends_at') > 0, 'Field error.');
        Cleanup();
    end;

    local procedure VerifyContracts(LanguageId: Integer)
    var
        Implementation: Interface "Msg Interface ori";
        Contract: Interface "Msg Contract ori";
        Discovery: Interface "Msg Discovery ori";
        MessageType: Enum "Message Type ori";
        Parameters: JsonArray;
        Ordinal: Integer;
    begin
        // [GIVEN] The six registered ordinals.
        Initialize(LanguageId);
        for Ordinal := 10035671 to 10035676 do begin
            MessageType := Enum::"Message Type ori".FromInteger(Ordinal);
            Implementation := MessageType;
            Contract := MessageType;
            Discovery := MessageType;
            // [THEN] Each is a write type with a description, keywords and parameters including expectedCount.
            Assert.AreEqual(Enum::"Msg Direction ori"::Inbound, Implementation.GetMessageDirection(), 'Write direction.');
            Assert.IsTrue(Implementation.GetDescription() <> '', 'Description.');
            Assert.IsTrue(Discovery.GetKeywords() <> '', 'Keywords.');
            Clear(Parameters);
            Assert.IsTrue(Contract.GetParameters(Parameters), 'Parameters chapter.');
            Assert.IsTrue(Format(Parameters).Contains('expectedCount'), 'expectedCount parameter.');
        end;
        Cleanup();
    end;

    local procedure Run(MessageType: Enum "Message Type ori"; Body: Text) Reply: JsonObject
    var
        TempArgument: Record "Message Argument ori" temporary;
        Handler: Codeunit "Manor Write Handler ori";
        Request: JsonObject;
    begin
        Request.ReadFrom(Body);
        TempArgument.Init();
        TempArgument.Insert();
        TempArgument.SetRequestJson(Request);
        Handler.Execute(MessageType, TempArgument);
        Reply := TempArgument.GetResponseJson();
    end;

    local procedure FirstResult(Reply: JsonObject): JsonObject
    var
        Token: JsonToken;
        Item: JsonToken;
    begin
        Reply.Get('results', Token);
        Token.AsArray().Get(0, Item);
        exit(Item.AsObject());
    end;

    local procedure CheckRequest(Store: Codeunit "Manor Mock Store ori"; Index: Integer; Method: Text; Path: Text; Body: Text)
    var
        Requests: JsonArray;
        Token: JsonToken;
    begin
        Requests := Store.GetRequests();
        Requests.Get(Index, Token);
        Assert.AreEqual(Method, Token.AsObject().GetText('method'), 'Method ' + Format(Index));
        Assert.AreEqual(Path, Token.AsObject().GetText('path'), 'Path ' + Format(Index));
        if Body <> '' then
            Assert.AreEqual(Body, Token.AsObject().GetText('body'), 'Body ' + Format(Index));
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
