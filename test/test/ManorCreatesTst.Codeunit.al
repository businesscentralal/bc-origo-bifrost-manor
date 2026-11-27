namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost;
using Origo.Bifrost.Manor;
using System.TestLibraries.Security.AccessControl;
using System.TestLibraries.Utilities;
using System.Utilities;

/// <summary>Issue 7: all create contracts through the public dispatcher, with mock-only transport in both languages.</summary>
codeunit 98270 "Manor Creates Tst ori"
{
    Subtype = Test;
    TestPermissions = Restrictive;
    TestHttpRequestPolicy = BlockOutboundRequests;

    var
        Assert: Codeunit "Library Assert";
        LowerPermissions: Codeunit "Library - Lower Permissions";
        Store: Codeunit "Manor Mock Store ori";
        PreviousLanguage: Integer;

    /// <summary>AC01: Contracts in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC01_ContractsEnglish()
    begin
        VerifyContracts(1033);
    end;

    /// <summary>AC01: Contracts in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC01_ContractsIcelandic()
    begin
        VerifyContracts(1039);
    end;

    /// <summary>AC02: Creates in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_CreatesEnglish()
    begin
        VerifyCreates(1033);
    end;

    /// <summary>AC02: Creates in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_CreatesIcelandic()
    begin
        VerifyCreates(1039);
    end;

    /// <summary>AC02: NegativeProduct in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_NegativeProductEnglish()
    begin
        VerifyNegativeProduct(1033);
    end;

    /// <summary>AC02: NegativeProduct in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_NegativeProductIcelandic()
    begin
        VerifyNegativeProduct(1039);
    end;

    /// <summary>AC03: WrappedTime in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_WrappedTimeEnglish()
    begin
        VerifyWrappedTime(1033);
    end;

    /// <summary>AC03: WrappedTime in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_WrappedTimeIcelandic()
    begin
        VerifyWrappedTime(1039);
    end;

    /// <summary>AC03: EmptyResponse in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_EmptyResponseEnglish()
    begin
        VerifyEmptyResponse(1033);
    end;

    /// <summary>AC03: EmptyResponse in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_EmptyResponseIcelandic()
    begin
        VerifyEmptyResponse(1039);
    end;

    /// <summary>AC04: Errors in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC04_ErrorsEnglish()
    begin
        VerifyErrors(1033);
    end;

    /// <summary>AC04: Errors in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC04_ErrorsIcelandic()
    begin
        VerifyErrors(1039);
    end;

    /// <summary>AC05: ExpectedCount in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC05_ExpectedCountEnglish()
    begin
        VerifyExpectedCount(1033);
    end;

    /// <summary>AC05: ExpectedCount in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC05_ExpectedCountIcelandic()
    begin
        VerifyExpectedCount(1039);
    end;

    /// <summary>AC06: InvalidScalars in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_InvalidScalarsEnglish()
    begin
        VerifyInvalidScalars(1033);
    end;

    /// <summary>AC06: InvalidScalars in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_InvalidScalarsIcelandic()
    begin
        VerifyInvalidScalars(1039);
    end;

    /// <summary>NG10: DryRun in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG10_DryRunEnglish()
    begin
        VerifyDryRun(1033);
    end;

    /// <summary>NG10: DryRun in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG10_DryRunIcelandic()
    begin
        VerifyDryRun(1039);
    end;

    /// <summary>NG12: BillableHours in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG12_BillableHoursEnglish()
    begin
        VerifyBillableHours(1033);
    end;

    /// <summary>NG12: BillableHours in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG12_BillableHoursIcelandic()
    begin
        VerifyBillableHours(1039);
    end;

    /// <summary>NG12: Over24Hours in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG12_Over24HoursEnglish()
    begin
        VerifyOver24Hours(1033);
    end;

    /// <summary>NG12: Over24Hours in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG12_Over24HoursIcelandic()
    begin
        VerifyOver24Hours(1039);
    end;

    /// <summary>NG12: CrossMidnight in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG12_CrossMidnightEnglish()
    begin
        VerifyCrossMidnight(1033);
    end;

    /// <summary>NG12: CrossMidnight in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG12_CrossMidnightIcelandic()
    begin
        VerifyCrossMidnight(1039);
    end;

    /// <summary>NG12: MidnightBoundary in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG12_MidnightBoundaryEnglish()
    begin
        VerifyMidnightBoundary(1033);
    end;

    /// <summary>NG12: MidnightBoundary in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG12_MidnightBoundaryIcelandic()
    begin
        VerifyMidnightBoundary(1039);
    end;

    /// <summary>NG12: RatePaging in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG12_RatePagingEnglish()
    begin
        VerifyRatePaging(1033);
    end;

    /// <summary>NG12: RatePaging in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG12_RatePagingIcelandic()
    begin
        VerifyRatePaging(1039);
    end;

    /// <summary>NG12: WrongRate in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG12_WrongRateEnglish()
    begin
        VerifyWrongRate(1033);
    end;

    /// <summary>NG12: WrongRate in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG12_WrongRateIcelandic()
    begin
        VerifyWrongRate(1039);
    end;

    /// <summary>NG12: MissingRate in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG12_MissingRateEnglish()
    begin
        VerifyMissingRate(1033);
    end;

    /// <summary>NG12: MissingRate in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG12_MissingRateIcelandic()
    begin
        VerifyMissingRate(1039);
    end;

    /// <summary>NG13: DefaultVat in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG13_DefaultVatEnglish()
    begin
        VerifyDefaultVat(1033);
    end;

    /// <summary>NG13: DefaultVat in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG13_DefaultVatIcelandic()
    begin
        VerifyDefaultVat(1039);
    end;

    /// <summary>NG13: ExplicitVat in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG13_ExplicitVatEnglish()
    begin
        VerifyExplicitVat(1033);
    end;

    /// <summary>NG13: ExplicitVat in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG13_ExplicitVatIcelandic()
    begin
        VerifyExplicitVat(1039);
    end;

    /// <summary>NG13: NoDefaultVat in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG13_NoDefaultVatEnglish()
    begin
        VerifyNoDefaultVat(1033);
    end;

    /// <summary>NG13: NoDefaultVat in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG13_NoDefaultVatIcelandic()
    begin
        VerifyNoDefaultVat(1039);
    end;

    /// <summary>NG13: AmbiguousFirm in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG13_AmbiguousFirmEnglish()
    begin
        VerifyAmbiguousFirm(1033);
    end;

    /// <summary>NG13: AmbiguousFirm in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG13_AmbiguousFirmIcelandic()
    begin
        VerifyAmbiguousFirm(1039);
    end;

    /// <summary>NG13: FirmPaging in LCID 1033.</summary>
    [Test]
    procedure Scenario_NG13_FirmPagingEnglish()
    begin
        VerifyFirmPaging(1033);
    end;

    /// <summary>NG13: FirmPaging in LCID 1039.</summary>
    [Test]
    procedure Scenario_NG13_FirmPagingIcelandic()
    begin
        VerifyFirmPaging(1039);
    end;

    /// <summary>AC02: SingleAttempt in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_SingleAttemptEnglish()
    begin
        VerifySingleAttempt(1033);
    end;

    /// <summary>AC02: SingleAttempt in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_SingleAttemptIcelandic()
    begin
        VerifySingleAttempt(1039);
    end;

    /// <summary>AC06: ReadRole in LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_ReadRoleEnglish()
    begin
        VerifyReadRole(1033);
    end;

    /// <summary>AC06: ReadRole in LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_ReadRoleIcelandic()
    begin
        VerifyReadRole(1039);
    end;

    /// <summary>NG12: offsets are normalised to UTC before validation and the preview.</summary>
    [Test]
    procedure Scenario_NG12_UtcOffsetEnglish()
    begin
        VerifyUtcOffset(1033);
    end;

    /// <summary>NG12: offsets are normalised to UTC in Icelandic sessions too.</summary>
    [Test]
    procedure Scenario_NG12_UtcOffsetIcelandic()
    begin
        VerifyUtcOffset(1039);
    end;

    local procedure VerifyUtcOffset(LanguageId: Integer)
    var
        Request: JsonObject;
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(1);
        Request.Replace('begins_at', '2026-11-20T22:00:00+02:00');
        Request.Add('dryRun', true);
        Response := RunCreate(Request, 1, LanguageId);
        AssertSuccess(Response);
        Assert.AreEqual('2026-11-20T20:00:00Z', Response.GetObject('payload').GetText('begins_at'), 'UTC payload.');
        Request.Replace('begins_at', '2026-11-20T02:00:00+03:00');
        AssertFailure(RunCreate(Request, 1, LanguageId), 0);
        Cleanup();
    end;

    local procedure Initialize(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
    begin
        // ASSUMPTION: the own-tenant Foundation test installer supplies EULA/trial setup; the dispatcher enforces it.
        LowerPermissions.SetOutsideO365Scope();
        PreviousLanguage := GlobalLanguage();
        GlobalLanguage(LanguageId);
        Store.Reset();
        Setup.GetRecordOnce();
        Setup.Environment := Setup.Environment::Mock;
        Setup.Enabled := true;
        Setup.Modify(true);
        Commit();
        LowerPermissions.SetExactPermissionSet('Manor Setup Test ori');
        LowerPermissions.AddPermissionSet('BIFROST Full ori');
        // Foundation test subscribers require execute rights even when their override is inactive.
        LowerPermissions.AddPermissionSet('BIFROST Tests ori');
        LowerPermissions.AddPermissionSet('BIFROST MnrFull ori');
    end;

    local procedure Cleanup()
    var
        Setup: Record "Manor Setup ori";
    begin
        LowerPermissions.SetOutsideO365Scope();
        if Setup.Get() then
            Setup.Delete(true);
        Store.Reset();
        GlobalLanguage(PreviousLanguage);
    end;

    local procedure RequestFor(Entity: Integer) Request: JsonObject
    begin
        Request.Add('projectId', 17);
        Request.Add('expectedCount', 1);
        Request.Add('description', 'Bifrost mock fixture');
        case Entity of
            1: begin
                Request.Add('begins_at', '2026-11-20T09:00:00Z');
                Request.Add('hours', 2);
                Request.Add('user_id', 5);
            end;
            2: begin
                Request.Add('amount', 1500);
                Request.Add('paid_at', '2026-11-20T09:00:00Z');
                Request.Add('paid_in_currency_code', 'ISK');
                Request.Add('vat_rate_id', 3);
            end;
            3: begin
                Request.Add('date', '2026-11-20');
                Request.Add('quantity', 2);
                Request.Add('user_id', 5);
                Request.Add('rate_id', 8);
            end;
        end;
    end;

    local procedure MessageTypeFor(Entity: Integer): Enum "Message Type ori"
    begin
        case Entity of
            1:
                exit(Enum::"Message Type ori"::"Manor.TimeEntry.Create");
            2:
                exit(Enum::"Message Type ori"::"Manor.Expense.Create");
            3:
                exit(Enum::"Message Type ori"::"Manor.Product.Create");
        end;
    end;

    local procedure PathFor(Entity: Integer): Text
    begin
        case Entity of
            1:
                exit('/project/17/time');
            2:
                exit('/project/17/expense');
            3:
                exit('/project/17/product');
        end;
    end;

    local procedure RunCreate(Request: JsonObject; Entity: Integer; LanguageId: Integer) Response: JsonObject
    var
        Dispatcher: Codeunit "Dispatcher ori";
        ResponseBlob: Codeunit "Temp Blob";
        RequestContent: BigText;
        ResponseStream: InStream;
        ResponseContentType: Text[100];
        RequestText: Text;
        ResponseText: Text;
        EmptyTaskId: Guid;
        MessageId: Guid;
        ResponseTime: Duration;
    begin
        Request.WriteTo(RequestText);
        RequestContent.AddText(RequestText);
        Dispatcher.EnqueueAndProcess(MessageTypeFor(Entity), Enum::"Message Version ori"::"1.0", '', 'ManorCreateTests', 'application/json', RequestContent, EmptyTaskId, LanguageId, MessageId, ResponseBlob, ResponseContentType, ResponseTime, true);
        ResponseBlob.CreateInStream(ResponseStream, TextEncoding::UTF8);
        ResponseStream.ReadText(ResponseText);
        Assert.IsTrue(Response.ReadFrom(ResponseText), 'Dispatcher returns JSON.');
    end;

    local procedure AssertSuccess(Response: JsonObject)
    var
        ResponseText: Text;
    begin
        Response.WriteTo(ResponseText);
        Assert.AreEqual('Success', Response.GetText('status'), ResponseText);
    end;

    local procedure AssertFailure(Response: JsonObject; Calls: Integer)
    var
        ResponseText: Text;
    begin
        Response.WriteTo(ResponseText);
        Assert.AreEqual('Error', Response.GetText('status'), ResponseText);
        Assert.AreEqual(Calls, Store.GetRequests().Count(), 'Exact outbound request count.');
    end;

    local procedure VerifyContracts(LanguageId: Integer)
    var
        Contract: Interface "Msg Contract ori";
        Discovery: Interface "Msg Discovery ori";
        Parameters: JsonArray;
        Errors: JsonArray;
        Response: JsonObject;
        Notes: Text;
        Entity: Integer;
    begin
        Initialize(LanguageId);
        for Entity := 1 to 3 do begin
            Contract := MessageTypeFor(Entity);
            Discovery := MessageTypeFor(Entity);
            Clear(Parameters);
            Clear(Errors);
            Clear(Response);
            Assert.IsTrue(Contract.GetParameters(Parameters), 'Parameters chapter.');
            Assert.IsTrue(Parameters.Count() >= 10, 'Includes payload and control parameters.');
            Assert.IsTrue(Contract.GetErrors(Errors), 'Errors chapter.');
            Assert.IsTrue(Contract.GetResponse(Response), 'Response chapter.');
            Assert.IsTrue(Contract.GetNotes(Notes), 'Notes chapter.');
            if LanguageId = 1039 then
                Assert.IsTrue(StrPos(Notes, 'Krefst') > 0, 'Icelandic contract.')
            else
                Assert.IsTrue(StrPos(Notes, 'Requires') > 0, 'English contract.');
            Assert.IsTrue(Discovery.GetKeywords() <> '', 'Search keywords.');
        end;
        Cleanup();
    end;

    local procedure VerifyCreates(LanguageId: Integer)
    var
        Response: JsonObject;
        Sent: JsonObject;
        Body: JsonObject;
        Item: JsonToken;
        Entity: Integer;
    begin
        Initialize(LanguageId);
        for Entity := 1 to 3 do begin
            Store.Reset();
            Store.RegisterResponse('POST', PathFor(Entity), 201, '{"id":101,"matter_id":17,"description":"Bifrost mock fixture"}');
            Response := RunCreate(RequestFor(Entity), Entity, LanguageId);
            AssertSuccess(Response);
            Assert.AreEqual(1, Response.GetInteger('noOfRecords'), 'One created resource.');
            Assert.AreEqual(1, Store.GetRequests().Count(), 'No project or user pre-reads.');
            Store.GetRequests().Get(0, Item);
            Sent := Item.AsObject();
            Assert.AreEqual('POST', Sent.GetText('method'), 'POST only.');
            Assert.AreEqual(PathFor(Entity), Sent.GetText('path'), 'Exact canonical endpoint.');
            Assert.AreEqual('', Sent.GetText('query'), 'No query on a create.');
            Body.ReadFrom(Sent.GetText('body'));
            Assert.AreEqual('Bifrost mock fixture', Body.GetText('description'), 'Canonical payload.');
            Assert.IsFalse(Body.Contains('expectedCount'), 'Control fields never reach Manor.');
            Assert.IsFalse(Body.Contains('projectId'), 'Project is in path only.');
            Response.GetArray('result').Get(0, Item);
            Assert.AreEqual(101, Item.AsObject().GetInteger('id'), 'Preserve canonical ID.');
        end;
        Cleanup();
    end;

    local procedure VerifyDryRun(LanguageId: Integer)
    var
        Request: JsonObject;
        Response: JsonObject;
        Payload: JsonObject;
        Entity: Integer;
    begin
        Initialize(LanguageId);
        for Entity := 1 to 3 do begin
            Request := RequestFor(Entity);
            Request.Add('dryRun', true);
            Response := RunCreate(Request, Entity, LanguageId);
            AssertSuccess(Response);
            Assert.IsTrue(Response.GetBoolean('dryRun'), 'Marked as dry run.');
            Assert.AreEqual(0, Response.GetInteger('noOfRecords'), 'Nothing created.');
            Assert.AreEqual(0, Response.GetArray('result').Count(), 'No invented resource.');
            Assert.AreEqual(PathFor(Entity), Response.GetText('path'), 'Preview path.');
            Payload := Response.GetObject('payload');
            Request.Remove('dryRun');
            Request.Remove('projectId');
            Request.Remove('expectedCount');
            Assert.AreEqual(Request.AsToken(), Payload.AsToken(), 'Exact outbound payload.');
            Assert.AreEqual(0, Store.GetRequests().Count(), 'No Manor calls needed for explicit fields.');
        end;
        Cleanup();
    end;

    local procedure VerifyExpectedCount(LanguageId: Integer)
    var
        Request: JsonObject;
        Entity: Integer;
    begin
        Initialize(LanguageId);
        for Entity := 1 to 3 do begin
            Request := RequestFor(Entity);
            Request.Replace('expectedCount', 2);
            AssertFailure(RunCreate(Request, Entity, LanguageId), 0);
            Request.Remove('expectedCount');
            AssertFailure(RunCreate(Request, Entity, LanguageId), 0);
        end;
        Cleanup();
    end;

    local procedure VerifyInvalidScalars(LanguageId: Integer)
    var
        Request: JsonObject;
        Entity: Integer;
    begin
        Initialize(LanguageId);
        for Entity := 1 to 3 do begin
            Request := RequestFor(Entity);
            Request.Replace('projectId', '../other');
            AssertFailure(RunCreate(Request, Entity, LanguageId), 0);
            Request := RequestFor(Entity);
            Request.Add('dryRun', 'true');
            AssertFailure(RunCreate(Request, Entity, LanguageId), 0);
            Request := RequestFor(Entity);
            Request.Remove('description');
            AssertFailure(RunCreate(Request, Entity, LanguageId), 0);
            Request := RequestFor(Entity);
            Request.Add('unexpected', true);
            AssertFailure(RunCreate(Request, Entity, LanguageId), 0);
        end;
        Request := RequestFor(2);
        Request.Replace('paid_at', '2026-11-20T09:00:00');
        AssertFailure(RunCreate(Request, 2, LanguageId), 0);
        Request := RequestFor(3);
        Request.Replace('date', '20/11/2026');
        AssertFailure(RunCreate(Request, 3, LanguageId), 0);
        Cleanup();
    end;

    local procedure VerifyErrors(LanguageId: Integer)
    var
        Response: JsonObject;
        ResponseText: Text;
        Entity: Integer;
        Status: Integer;
        Statuses: List of [Integer];
    begin
        Initialize(LanguageId);
        Statuses.AddRange(401, 403, 404, 422);
        for Entity := 1 to 3 do
            foreach Status in Statuses do begin
                Store.Reset();
                Store.RegisterResponse('POST', PathFor(Entity), Status, '{"message":"DO-NOT-ECHO-MOCK-MARKER","errors":{"key":["DO-NOT-ECHO-MOCK-MARKER"]}}');
                Response := RunCreate(RequestFor(Entity), Entity, LanguageId);
                AssertFailure(Response, 1);
                Response.WriteTo(ResponseText);
                Assert.AreEqual(0, StrPos(ResponseText, 'DO-NOT-ECHO-MOCK-MARKER'), 'No raw provider messages.');
                if Status in [401, 403] then
                    case Entity of
                        1:
                            Assert.IsTrue(StrPos(ResponseText, 'set_alternative_user_of_times') > 0, 'Time permission hint.');
                        2:
                            Assert.IsTrue(StrPos(ResponseText, 'set_alternative_user_of_expenses') > 0, 'Expense permission hint.');
                        3:
                            Assert.IsTrue(StrPos(ResponseText, 'manage_products') > 0, 'Product permission hint.');
                    end;
                if Status = 422 then
                    if LanguageId = 1039 then
                        Assert.IsTrue(StrPos(ResponseText, 'hafnaði') > 0, 'Icelandic validation error.')
                    else
                        Assert.IsTrue(StrPos(ResponseText, 'rejected') > 0, 'English validation error.');
            end;
        Cleanup();
    end;

    local procedure VerifySingleAttempt(LanguageId: Integer)
    var
        Entity: Integer;
    begin
        Initialize(LanguageId);
        for Entity := 1 to 3 do begin
            Store.Reset();
            Store.RegisterResponse('POST', PathFor(Entity), 503, '{}');
            AssertFailure(RunCreate(RequestFor(Entity), Entity, LanguageId), 1);
        end;
        Cleanup();
    end;

    local procedure VerifyNegativeProduct(LanguageId: Integer)
    var
        Request: JsonObject;
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(3);
        Request.Replace('quantity', -2);
        Request.Add('dryRun', true);
        Response := RunCreate(Request, 3, LanguageId);
        AssertSuccess(Response);
        Assert.AreEqual(-2, Response.GetObject('payload').GetDecimal('quantity'), 'Prepayment deduction preserved.');
        Cleanup();
    end;

    local procedure VerifyWrappedTime(LanguageId: Integer)
    var
        Response: JsonObject;
        Item: JsonToken;
    begin
        Initialize(LanguageId);
        Store.RegisterResponse('POST', PathFor(1), 201, '{"data":{"id":19,"hours":2,"billable_hours":1,"begins_at":"2026-11-20T09:00:00Z"}}');
        Response := RunCreate(RequestFor(1), 1, LanguageId);
        AssertSuccess(Response);
        Response.GetArray('result').Get(0, Item);
        Assert.AreEqual(1, Item.AsObject().GetDecimal('billable_hours'), 'Wrapped canonical fields preserved.');
        Cleanup();
    end;

    local procedure VerifyEmptyResponse(LanguageId: Integer)
    var
        Entity: Integer;
    begin
        Initialize(LanguageId);
        for Entity := 1 to 3 do begin
            Store.Reset();
            Store.RegisterResponse('POST', PathFor(Entity), 201, '{"data":[]}');
            AssertFailure(RunCreate(RequestFor(Entity), Entity, LanguageId), 1);
        end;
        Cleanup();
    end;

    local procedure VerifyBillableHours(LanguageId: Integer)
    var
        Request: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(1);
        Request.Add('billable_hours', 3);
        AssertFailure(RunCreate(Request, 1, LanguageId), 0);
        Request.Replace('billable_hours', -1);
        AssertFailure(RunCreate(Request, 1, LanguageId), 0);
        Cleanup();
    end;

    local procedure VerifyOver24Hours(LanguageId: Integer)
    var
        Request: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(1);
        Request.Replace('hours', 24.01);
        AssertFailure(RunCreate(Request, 1, LanguageId), 0);
        Request.Replace('hours', 0);
        AssertFailure(RunCreate(Request, 1, LanguageId), 0);
        Cleanup();
    end;

    local procedure VerifyCrossMidnight(LanguageId: Integer)
    var
        Request: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(1);
        Request.Replace('begins_at', '2026-11-20T23:00:00Z');
        AssertFailure(RunCreate(Request, 1, LanguageId), 0);
        Cleanup();
    end;

    local procedure VerifyMidnightBoundary(LanguageId: Integer)
    var
        Request: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(1);
        Request.Replace('begins_at', '2026-11-20T00:00:00Z');
        Request.Replace('hours', 24);
        Request.Add('billable_hours', 24);
        Request.Add('dryRun', true);
        AssertSuccess(RunCreate(Request, 1, LanguageId));
        Request.Replace('hours', 2);
        Request.Replace('billable_hours', 0);
        Request.Replace('begins_at', '2026-11-20T22:00:00Z');
        AssertSuccess(RunCreate(Request, 1, LanguageId));
        Cleanup();
    end;

    local procedure VerifyRatePaging(LanguageId: Integer)
    var
        Request: JsonObject;
        Item: JsonToken;
    begin
        Initialize(LanguageId);
        Request := RequestFor(1);
        Request.Add('rate_id', 8);
        Store.RegisterQueuedResponse('GET', '/rate', 'per_page=100&page=1', 200, '{"data":[{"id":7,"type":"product"}],"meta":{"last_page":2}}');
        Store.RegisterQueuedResponse('GET', '/rate', 'per_page=100&page=2', 200, '{"data":[{"id":8,"type":"time"}],"meta":{"last_page":2}}');
        Store.RegisterResponse('POST', PathFor(1), 201, '{"id":19}');
        AssertSuccess(RunCreate(Request, 1, LanguageId));
        Assert.AreEqual(3, Store.GetRequests().Count(), 'Two rate pages, one POST.');
        Store.GetRequests().Get(2, Item);
        Assert.AreEqual('POST', Item.AsObject().GetText('method'), 'Validation completed before POST.');
        Cleanup();
    end;

    local procedure VerifyWrongRate(LanguageId: Integer)
    var
        Request: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(1);
        Request.Add('rate_id', 8);
        Store.RegisterResponse('GET', '/rate', 200, '{"data":[{"id":8,"type":"travel"}],"meta":{"last_page":1}}');
        AssertFailure(RunCreate(Request, 1, LanguageId), 1);
        Cleanup();
    end;

    local procedure VerifyMissingRate(LanguageId: Integer)
    var
        Request: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(1);
        Request.Add('rate_id', 8);
        Store.RegisterResponse('GET', '/rate', 200, '{"data":[],"meta":{"last_page":1}}');
        AssertFailure(RunCreate(Request, 1, LanguageId), 1);
        Cleanup();
    end;

    local procedure VerifyDefaultVat(LanguageId: Integer)
    var
        Request: JsonObject;
        Response: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(2);
        Request.Remove('vat_rate_id');
        Request.Add('dryRun', true);
        Store.RegisterResponse('GET', '/firm', 200, '{"data":[{"id":4,"default_vat_rate_id":9}],"meta":{"last_page":1}}');
        Response := RunCreate(Request, 2, LanguageId);
        AssertSuccess(Response);
        Assert.AreEqual(9, Response.GetObject('payload').GetInteger('vat_rate_id'), 'Firm default in exact preview.');
        Assert.AreEqual(1, Store.GetRequests().Count(), 'One firm read and no POST in dry run.');
        Cleanup();
    end;

    local procedure VerifyExplicitVat(LanguageId: Integer)
    var
        Request: JsonObject;
        Item: JsonToken;
        Payload: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(2);
        Request.Replace('vat_rate_id', 19);
        Store.RegisterResponse('POST', PathFor(2), 201, '{"id":21,"vat_rate_id":19}');
        AssertSuccess(RunCreate(Request, 2, LanguageId));
        Assert.AreEqual(1, Store.GetRequests().Count(), 'No default lookup for explicit VAT.');
        Store.GetRequests().Get(0, Item);
        Payload.ReadFrom(Item.AsObject().GetText('body'));
        Assert.AreEqual(19, Payload.GetInteger('vat_rate_id'), 'Explicit VAT unchanged.');
        Cleanup();
    end;

    local procedure VerifyNoDefaultVat(LanguageId: Integer)
    var
        Request: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(2);
        Request.Remove('vat_rate_id');
        Store.RegisterResponse('GET', '/firm', 200, '{"data":[{"id":4,"default_vat_rate_id":null}],"meta":{"last_page":1}}');
        AssertFailure(RunCreate(Request, 2, LanguageId), 1);
        Cleanup();
    end;

    local procedure VerifyAmbiguousFirm(LanguageId: Integer)
    var
        Request: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(2);
        Request.Remove('vat_rate_id');
        Store.RegisterResponse('GET', '/firm', 200, '{"data":[{"id":4,"default_vat_rate_id":9},{"id":5,"default_vat_rate_id":10}],"meta":{"last_page":1}}');
        AssertFailure(RunCreate(Request, 2, LanguageId), 1);
        Cleanup();
    end;

    local procedure VerifyFirmPaging(LanguageId: Integer)
    var
        Request: JsonObject;
        Item: JsonToken;
        Payload: JsonObject;
    begin
        Initialize(LanguageId);
        Request := RequestFor(2);
        Request.Remove('vat_rate_id');
        Request.Add('firm_id', 5);
        Store.RegisterQueuedResponse('GET', '/firm', 'per_page=100&page=1', 200, '{"data":[{"id":4,"default_vat_rate_id":9}],"meta":{"last_page":2}}');
        Store.RegisterQueuedResponse('GET', '/firm', 'per_page=100&page=2', 200, '{"data":[{"id":5,"default_vat_rate_id":10}],"meta":{"last_page":2}}');
        Store.RegisterResponse('POST', PathFor(2), 201, '{"id":21,"vat_rate_id":10}');
        AssertSuccess(RunCreate(Request, 2, LanguageId));
        Assert.AreEqual(3, Store.GetRequests().Count(), 'Two firm pages then one POST.');
        Store.GetRequests().Get(2, Item);
        Payload.ReadFrom(Item.AsObject().GetText('body'));
        Assert.AreEqual(10, Payload.GetInteger('vat_rate_id'), 'Default from requested firm only.');
        Cleanup();
    end;

    local procedure VerifyReadRole(LanguageId: Integer)
    var
        Impl: Interface "Msg Interface ori";
        Entity: Integer;
    begin
        Initialize(LanguageId);
        LowerPermissions.SetExactPermissionSet('Manor Setup Test ori');
        LowerPermissions.AddPermissionSet('BIFROST Read ori');
        LowerPermissions.AddPermissionSet('BIFROST MnrRead ori');
        // Read callers do not receive execute rights for the create implementations.
        for Entity := 1 to 3 do begin
            Impl := MessageTypeFor(Entity);
            asserterror Impl.IsEnabled();
        end;
        Cleanup();
    end;
}
