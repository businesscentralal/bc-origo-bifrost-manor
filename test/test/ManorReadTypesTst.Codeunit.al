namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost;
using Origo.Bifrost.Manor;
using System.TestLibraries.Security.AccessControl;
using System.TestLibraries.Utilities;
using System.Utilities;

/// <summary>Issue 5: registered read contracts and dispatcher execution, using Mock only in both languages.</summary>
codeunit 98250 "Manor Read Types Tst ori"
{
    Subtype = Test;
    TestPermissions = Restrictive;
    TestHttpRequestPolicy = BlockOutboundRequests;

    var
        SavedSetup: Record "Manor Setup ori";
        Assert: Codeunit "Library Assert";
        LowerPermissions: Codeunit "Library - Lower Permissions";
        Store: Codeunit "Manor Mock Store ori";
        HadSetup: Boolean;
        PreviousLanguage: Integer;

    /// <summary>Contract for Time, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC01_TimeContract1033()
    begin
        Initialize(1033);
        VerifyContract(1);
        Cleanup();
    end;

    /// <summary>Happy for Time, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_TimeHappy1033()
    begin
        Initialize(1033);
        VerifyHappy(1);
        Cleanup();
    end;

    /// <summary>Empty for Time, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_TimeEmpty1033()
    begin
        Initialize(1033);
        VerifyEmpty(1);
        Cleanup();
    end;

    /// <summary>Errors for Time, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC04_TimeErrors1033()
    begin
        Initialize(1033);
        VerifyErrors(1);
        Cleanup();
    end;

    /// <summary>Invalid for Time, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_TimeInvalid1033()
    begin
        Initialize(1033);
        VerifyInvalid(1);
        Cleanup();
    end;

    /// <summary>Contract for Product, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC01_ProductContract1033()
    begin
        Initialize(1033);
        VerifyContract(2);
        Cleanup();
    end;

    /// <summary>Happy for Product, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_ProductHappy1033()
    begin
        Initialize(1033);
        VerifyHappy(2);
        Cleanup();
    end;

    /// <summary>Empty for Product, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_ProductEmpty1033()
    begin
        Initialize(1033);
        VerifyEmpty(2);
        Cleanup();
    end;

    /// <summary>Errors for Product, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC04_ProductErrors1033()
    begin
        Initialize(1033);
        VerifyErrors(2);
        Cleanup();
    end;

    /// <summary>Invalid for Product, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_ProductInvalid1033()
    begin
        Initialize(1033);
        VerifyInvalid(2);
        Cleanup();
    end;

    /// <summary>Contract for InvoiceList, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC01_InvoiceListContract1033()
    begin
        Initialize(1033);
        VerifyContract(3);
        Cleanup();
    end;

    /// <summary>Happy for InvoiceList, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_InvoiceListHappy1033()
    begin
        Initialize(1033);
        VerifyHappy(3);
        Cleanup();
    end;

    /// <summary>Empty for InvoiceList, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_InvoiceListEmpty1033()
    begin
        Initialize(1033);
        VerifyEmpty(3);
        Cleanup();
    end;

    /// <summary>Errors for InvoiceList, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC04_InvoiceListErrors1033()
    begin
        Initialize(1033);
        VerifyErrors(3);
        Cleanup();
    end;

    /// <summary>Invalid for InvoiceList, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_InvoiceListInvalid1033()
    begin
        Initialize(1033);
        VerifyInvalid(3);
        Cleanup();
    end;

    /// <summary>Contract for InvoiceGet, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC01_InvoiceGetContract1033()
    begin
        Initialize(1033);
        VerifyContract(4);
        Cleanup();
    end;

    /// <summary>Happy for InvoiceGet, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_InvoiceGetHappy1033()
    begin
        Initialize(1033);
        VerifyHappy(4);
        Cleanup();
    end;

    /// <summary>Empty for InvoiceGet, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_InvoiceGetEmpty1033()
    begin
        Initialize(1033);
        VerifyEmpty(4);
        Cleanup();
    end;

    /// <summary>Errors for InvoiceGet, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC04_InvoiceGetErrors1033()
    begin
        Initialize(1033);
        VerifyErrors(4);
        Cleanup();
    end;

    /// <summary>Invalid for InvoiceGet, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_InvoiceGetInvalid1033()
    begin
        Initialize(1033);
        VerifyInvalid(4);
        Cleanup();
    end;

    /// <summary>Contract for Inbound, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC01_InboundContract1033()
    begin
        Initialize(1033);
        VerifyContract(5);
        Cleanup();
    end;

    /// <summary>Happy for Inbound, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_InboundHappy1033()
    begin
        Initialize(1033);
        VerifyHappy(5);
        Cleanup();
    end;

    /// <summary>Empty for Inbound, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC03_InboundEmpty1033()
    begin
        Initialize(1033);
        VerifyEmpty(5);
        Cleanup();
    end;

    /// <summary>Errors for Inbound, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC04_InboundErrors1033()
    begin
        Initialize(1033);
        VerifyErrors(5);
        Cleanup();
    end;

    /// <summary>Invalid for Inbound, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_InboundInvalid1033()
    begin
        Initialize(1033);
        VerifyInvalid(5);
        Cleanup();
    end;

    /// <summary>InboundStatus boundary or validation, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_InboundStatus1033()
    begin
        Initialize(1033);
        VerifyInboundStatus();
        Cleanup();
    end;

    /// <summary>InvalidStatus boundary or validation, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_InvalidStatus1033()
    begin
        Initialize(1033);
        VerifyInvalidStatus();
        Cleanup();
    end;

    /// <summary>Accepted boundary or validation, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_Accepted1033()
    begin
        Initialize(1033);
        VerifyAccepted();
        Cleanup();
    end;

    /// <summary>DateRange boundary or validation, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_DateRange1033()
    begin
        Initialize(1033);
        VerifyDateRange();
        Cleanup();
    end;

    /// <summary>PageLimit boundary or validation, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_PageLimit1033()
    begin
        Initialize(1033);
        VerifyPageLimit();
        Cleanup();
    end;

    /// <summary>Bounds boundary or validation, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_Bounds1033()
    begin
        Initialize(1033);
        VerifyBounds();
        Cleanup();
    end;

    /// <summary>InvoiceNumber boundary or validation, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_InvoiceNumber1033()
    begin
        Initialize(1033);
        VerifyInvoiceNumber();
        Cleanup();
    end;

    /// <summary>InvalidSelector boundary or validation, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_InvalidSelector1033()
    begin
        Initialize(1033);
        VerifyInvalidSelector();
        Cleanup();
    end;

    /// <summary>Malformed boundary or validation, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_Malformed1033()
    begin
        Initialize(1033);
        VerifyMalformed();
        Cleanup();
    end;

    /// <summary>BadDates boundary or validation, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_BadDates1033()
    begin
        Initialize(1033);
        VerifyBadDates();
        Cleanup();
    end;

    /// <summary>AllStatuses boundary or validation, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC06_AllStatuses1033()
    begin
        Initialize(1033);
        VerifyAllStatuses();
        Cleanup();
    end;

    /// <summary>Contract for Time, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC01_TimeContract1039()
    begin
        Initialize(1039);
        VerifyContract(1);
        Cleanup();
    end;

    /// <summary>Happy for Time, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_TimeHappy1039()
    begin
        Initialize(1039);
        VerifyHappy(1);
        Cleanup();
    end;

    /// <summary>Empty for Time, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_TimeEmpty1039()
    begin
        Initialize(1039);
        VerifyEmpty(1);
        Cleanup();
    end;

    /// <summary>Errors for Time, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC04_TimeErrors1039()
    begin
        Initialize(1039);
        VerifyErrors(1);
        Cleanup();
    end;

    /// <summary>Invalid for Time, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_TimeInvalid1039()
    begin
        Initialize(1039);
        VerifyInvalid(1);
        Cleanup();
    end;

    /// <summary>Contract for Product, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC01_ProductContract1039()
    begin
        Initialize(1039);
        VerifyContract(2);
        Cleanup();
    end;

    /// <summary>Happy for Product, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_ProductHappy1039()
    begin
        Initialize(1039);
        VerifyHappy(2);
        Cleanup();
    end;

    /// <summary>Empty for Product, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_ProductEmpty1039()
    begin
        Initialize(1039);
        VerifyEmpty(2);
        Cleanup();
    end;

    /// <summary>Errors for Product, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC04_ProductErrors1039()
    begin
        Initialize(1039);
        VerifyErrors(2);
        Cleanup();
    end;

    /// <summary>Invalid for Product, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_ProductInvalid1039()
    begin
        Initialize(1039);
        VerifyInvalid(2);
        Cleanup();
    end;

    /// <summary>Contract for InvoiceList, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC01_InvoiceListContract1039()
    begin
        Initialize(1039);
        VerifyContract(3);
        Cleanup();
    end;

    /// <summary>Happy for InvoiceList, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_InvoiceListHappy1039()
    begin
        Initialize(1039);
        VerifyHappy(3);
        Cleanup();
    end;

    /// <summary>Empty for InvoiceList, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_InvoiceListEmpty1039()
    begin
        Initialize(1039);
        VerifyEmpty(3);
        Cleanup();
    end;

    /// <summary>Errors for InvoiceList, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC04_InvoiceListErrors1039()
    begin
        Initialize(1039);
        VerifyErrors(3);
        Cleanup();
    end;

    /// <summary>Invalid for InvoiceList, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_InvoiceListInvalid1039()
    begin
        Initialize(1039);
        VerifyInvalid(3);
        Cleanup();
    end;

    /// <summary>Contract for InvoiceGet, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC01_InvoiceGetContract1039()
    begin
        Initialize(1039);
        VerifyContract(4);
        Cleanup();
    end;

    /// <summary>Happy for InvoiceGet, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_InvoiceGetHappy1039()
    begin
        Initialize(1039);
        VerifyHappy(4);
        Cleanup();
    end;

    /// <summary>Empty for InvoiceGet, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_InvoiceGetEmpty1039()
    begin
        Initialize(1039);
        VerifyEmpty(4);
        Cleanup();
    end;

    /// <summary>Errors for InvoiceGet, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC04_InvoiceGetErrors1039()
    begin
        Initialize(1039);
        VerifyErrors(4);
        Cleanup();
    end;

    /// <summary>Invalid for InvoiceGet, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_InvoiceGetInvalid1039()
    begin
        Initialize(1039);
        VerifyInvalid(4);
        Cleanup();
    end;

    /// <summary>Contract for Inbound, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC01_InboundContract1039()
    begin
        Initialize(1039);
        VerifyContract(5);
        Cleanup();
    end;

    /// <summary>Happy for Inbound, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_InboundHappy1039()
    begin
        Initialize(1039);
        VerifyHappy(5);
        Cleanup();
    end;

    /// <summary>Empty for Inbound, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC03_InboundEmpty1039()
    begin
        Initialize(1039);
        VerifyEmpty(5);
        Cleanup();
    end;

    /// <summary>Errors for Inbound, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC04_InboundErrors1039()
    begin
        Initialize(1039);
        VerifyErrors(5);
        Cleanup();
    end;

    /// <summary>Invalid for Inbound, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_InboundInvalid1039()
    begin
        Initialize(1039);
        VerifyInvalid(5);
        Cleanup();
    end;

    /// <summary>InboundStatus boundary or validation, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_InboundStatus1039()
    begin
        Initialize(1039);
        VerifyInboundStatus();
        Cleanup();
    end;

    /// <summary>InvalidStatus boundary or validation, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_InvalidStatus1039()
    begin
        Initialize(1039);
        VerifyInvalidStatus();
        Cleanup();
    end;

    /// <summary>Accepted boundary or validation, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_Accepted1039()
    begin
        Initialize(1039);
        VerifyAccepted();
        Cleanup();
    end;

    /// <summary>DateRange boundary or validation, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_DateRange1039()
    begin
        Initialize(1039);
        VerifyDateRange();
        Cleanup();
    end;

    /// <summary>PageLimit boundary or validation, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_PageLimit1039()
    begin
        Initialize(1039);
        VerifyPageLimit();
        Cleanup();
    end;

    /// <summary>Bounds boundary or validation, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_Bounds1039()
    begin
        Initialize(1039);
        VerifyBounds();
        Cleanup();
    end;

    /// <summary>InvoiceNumber boundary or validation, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_InvoiceNumber1039()
    begin
        Initialize(1039);
        VerifyInvoiceNumber();
        Cleanup();
    end;

    /// <summary>InvalidSelector boundary or validation, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_InvalidSelector1039()
    begin
        Initialize(1039);
        VerifyInvalidSelector();
        Cleanup();
    end;

    /// <summary>Malformed boundary or validation, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_Malformed1039()
    begin
        Initialize(1039);
        VerifyMalformed();
        Cleanup();
    end;

    /// <summary>BadDates boundary or validation, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_BadDates1039()
    begin
        Initialize(1039);
        VerifyBadDates();
        Cleanup();
    end;

    /// <summary>AllStatuses boundary or validation, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC06_AllStatuses1039()
    begin
        Initialize(1039);
        VerifyAllStatuses();
        Cleanup();
    end;

    /// <summary>Session fixtures take precedence over persisted MCP fixtures, LCID 1033.</summary>
    [Test]
    procedure Scenario_AC02_MockPrecedence1033()
    begin
        Initialize(1033);
        VerifyMockPrecedence();
        Cleanup();
    end;

    /// <summary>Session fixtures take precedence over persisted MCP fixtures, LCID 1039.</summary>
    [Test]
    procedure Scenario_AC02_MockPrecedence1039()
    begin
        Initialize(1039);
        VerifyMockPrecedence();
        Cleanup();
    end;

    // Assumption: no page action exists. The registered Dispatcher is the public message surface.
    local procedure Initialize(LanguageId: Integer)
    var
        Setup: Record "Manor Setup ori";
    begin
        LowerPermissions.SetOutsideO365Scope();
        PreviousLanguage := GlobalLanguage();
        GlobalLanguage(LanguageId);
        Store.Reset();
        HadSetup := Setup.Get();
        if HadSetup then
            SavedSetup := Setup
        else begin
            Setup.Init();
            Setup.Insert(false);
        end;
        Setup.Environment := Setup.Environment::Mock;
        Setup.Enabled := true;
        Setup.Modify(false);
        Commit();
        LowerPermissions.SetExactPermissionSet('Manor Setup Test ori');
        LowerPermissions.AddPermissionSet('BIFROST Read ori');
        LowerPermissions.AddPermissionSet('BIFROST API ori');
        LowerPermissions.AddPermissionSet('BIFROST MnrRead ori');
    end;

    local procedure Cleanup()
    var
        Setup: Record "Manor Setup ori";
    begin
        LowerPermissions.SetOutsideO365Scope();
        if HadSetup then begin
            Setup.Get();
            Setup.TransferFields(SavedSetup, false);
            Setup.Modify(false);
        end else
            if Setup.Get() then
                Setup.Delete(false);
        Store.Reset();
        GlobalLanguage(PreviousLanguage);
    end;

    local procedure MessageType(Kind: Integer): Enum "Message Type ori"
    begin
        exit("Message Type ori".FromInteger(10035665 + Kind));
    end;

    local procedure Path(Kind: Integer): Text
    begin
        case Kind of
            1:
                exit('/project/42/time');
            2:
                exit('/project/42/product');
            3:
                exit('/invoice');
            4:
                exit('/invoice/7');
            5:
                exit('/inbound-invoice/updated');
        end;
    end;

    local procedure Request(Kind: Integer): Text
    begin
        case Kind of
            1:
                exit('{"projectId":42,"userId":3,"date":"2026-01-15","updatedSince":"2026-01-01T00:00:00Z"}');
            2:
                exit('{"projectId":42}');
            3:
                exit('{"firmId":1,"createdSince":"2026-01-01T00:00:00Z","updatedSince":"2026-01-02T00:00:00Z","from":"2026-01-01","to":"2026-01-31"}');
            4:
                exit('{"invoiceId":7}');
            5:
                exit('{"mode":"updated","updatedSince":"2026-01-01T00:00:00Z"}');
        end;
    end;

    local procedure Dispatch(Kind: Integer; RequestText: Text) Response: JsonObject
    var
        Dispatcher: Codeunit "Dispatcher ori";
        Blob: Codeunit "Temp Blob";
        RequestContent: BigText;
        ResponseText: Text;
        ContentType: Text[100];
        TaskId: Guid;
        MessageId: Guid;
        ResponseTime: Duration;
        Input: InStream;
    begin
        RequestContent.AddText(RequestText);
        // OmitCommit keeps test data inside the runner transaction; language is explicit.
        Dispatcher.EnqueueAndProcess(MessageType(Kind), "Message Version ori"::"1.0", '', 'MANOR-READ-TEST', 'application/json', RequestContent, TaskId, GlobalLanguage(), MessageId, Blob, ContentType, ResponseTime, true);
        Blob.CreateInStream(Input, TextEncoding::UTF8);
        Input.ReadText(ResponseText);
        Assert.IsTrue(Response.ReadFrom(ResponseText), 'Dispatcher returns JSON: ' + ResponseText);
    end;

    local procedure AssertStatus(Response: JsonObject; Expected: Text)
    var
        Token: JsonToken;
        ResponseText: Text;
    begin
        Response.WriteTo(ResponseText);
        Assert.IsTrue(Response.Get('status', Token), ResponseText);
        Assert.AreEqual(Expected, Token.AsValue().AsText(), ResponseText);
    end;

    local procedure AssertCount(Response: JsonObject; Expected: Integer)
    var
        Token: JsonToken;
    begin
        AssertStatus(Response, 'Success');
        Response.Get('count', Token);
        Assert.AreEqual(Expected, Token.AsValue().AsInteger(), 'Returned row count');
    end;

    local procedure VerifyContract(Kind: Integer)
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
        Contract: JsonObject;
        Token: JsonToken;
        Impl: Interface "Msg Interface ori";
        Discovery: Interface "Msg Discovery ori";
        ContractText: Text;
    begin
        Impl := MessageType(Kind);
        Discovery := MessageType(Kind);
        Assert.IsTrue(Impl.IsEnabled(), 'Discoverable');
        Assert.AreEqual("Msg Direction ori"::Outbound, Impl.GetMessageDirection(), 'Read direction');
        Assert.IsTrue(Discovery.GetSelectionDescription() <> '', 'Selection description');
        Assert.IsTrue(Discovery.GetKeywords() <> '', 'Keywords');
        Assert.IsTrue(ContractMgt.GetContract(MessageType(Kind), Contract), 'Contract registered');
        Assert.IsTrue(Contract.Get('parameters', Token), 'Parameters chapter');
        Assert.IsTrue(Contract.Get('response', Token), 'Response chapter');
        Assert.IsTrue(Contract.Get('errors', Token), 'Errors chapter');
        Assert.IsTrue(Contract.Get('notes', Token), 'Notes chapter');
        Contract.WriteTo(ContractText);
        Assert.IsTrue(ContractText.Contains('JSON frá Manor'), 'Icelandic response help survives Foundation English canonicalization');
        Assert.IsTrue(ContractText.Contains('Gagnaprófun fer fram'), 'Icelandic error guidance survives Foundation English canonicalization');
        Assert.IsTrue(ContractText.Contains('Manor JSON with canonical'), 'English response help retained');
        if Kind in [3, 4] then
            Assert.IsTrue(Token.AsValue().AsText().Contains('Beta'), 'Beta is documented');
    end;

    local procedure VerifyHappy(Kind: Integer)
    var
        Response: JsonObject;
        Requests: JsonArray;
        Row: JsonToken;
        Token: JsonToken;
        Query: Text;
        Body: Text;
    begin
        case Kind of
            1:
                Body := '{"id":1,"matter_id":42,"hours":2.5,"billable_hours":1.5,"description":"Work report","internal_note":"Demo note"}';
            2:
                Body := '{"id":1,"quantity":-1,"billable_quantity":-1,"price":2500,"custom_discount":10}';
            3, 4:
                Body := '{"id":1,"invoice_number":7,"currency_code":"ISK","exchange_rate":1,"is_credit":true,"original_invoice_number":6,"invoice_lines":[{"quantity":1,"unit_price":2500}]}';
            5:
                Body := '{"id":1,"status":"pending","updated_at":"2026-01-02T00:00:00Z"}';
        end;
        if Kind = 4 then
            Store.RegisterResponse('GET', Path(Kind), 200, '{"data":' + Body + '}')
        else begin
            Store.RegisterQueuedResponse('GET', Path(Kind), ExpectedQuery(Kind) + '&per_page=100&page=1', 200, '{"data":[' + Body + '],"meta":{"last_page":2}}');
            Store.RegisterQueuedResponse('GET', Path(Kind), ExpectedQuery(Kind) + '&per_page=100&page=2', 200, '{"data":[{"id":2}],"meta":{"last_page":2}}');
            if Kind = 2 then begin
                // No filter query: avoid a leading ampersand.
                Store.RegisterQueuedResponse('GET', Path(Kind), 'per_page=100&page=1', 200, '{"data":[' + Body + '],"meta":{"last_page":2}}');
                Store.RegisterQueuedResponse('GET', Path(Kind), 'per_page=100&page=2', 200, '{"data":[{"id":2}],"meta":{"last_page":2}}');
            end;
        end;
        Response := Dispatch(Kind, Request(Kind));
        AssertStatus(Response, 'Success');
        Response.Get('data', Token);
        if Kind = 4 then
            Row := Token
        else begin
            AssertCount(Response, 2);
            Token.AsArray().Get(0, Row);
        end;
        Body := '';
        Row.WriteTo(Body);
        Assert.IsTrue(Body.Contains('"id":1'), 'Canonical id retained');
        if Kind = 1 then
            Assert.IsTrue(Body.Contains('"billable_hours":1.5'), 'Canonical time fields retained');
        if Kind = 2 then
            Assert.IsTrue(Body.Contains('"quantity":-1'), 'Negative quantities preserved');
        Requests := Store.GetRequests();
        Requests.Get(0, Row);
        Row.AsObject().Get('method', Token);
        Assert.AreEqual('GET', Token.AsValue().AsText(), 'Read-only transport');
        Row.AsObject().Get('path', Token);
        Assert.AreEqual(Path(Kind), Token.AsValue().AsText(), 'Exact path');
        Row.AsObject().Get('query', Token);
        Query := Token.AsValue().AsText();
        if Kind = 4 then
            Assert.AreEqual('', Query, 'Get has no query')
        else
            Assert.IsTrue(Query.EndsWith('per_page=100&page=1'), 'Paging query');
    end;

    local procedure ExpectedQuery(Kind: Integer): Text
    var
        Builder: Codeunit "Manor Query Builder ori";
    begin
        case Kind of
            1:
                begin
                    Builder.Add('user_id', 3);
                    Builder.Add('date', '2026-01-15');
                    Builder.Add('updated_since', '2026-01-01T00:00:00Z');
                end;
            3:
                begin
                    Builder.Add('firm_id', 1);
                    Builder.Add('created_since', '2026-01-01T00:00:00Z');
                    Builder.Add('updated_since', '2026-01-02T00:00:00Z');
                    Builder.Add('from', '2026-01-01');
                    Builder.Add('to', '2026-01-31');
                end;
            5:
                Builder.Add('updated_since', '2026-01-01T00:00:00Z');
        end;
        exit(Builder.Build());
    end;

    local procedure VerifyEmpty(Kind: Integer)
    var
        Response: JsonObject;
    begin
        if Kind = 4 then begin
            Store.RegisterResponse('GET', Path(Kind), 404, '{}');
            asserterror Dispatch(Kind, Request(Kind));
        end else begin
            Store.RegisterResponse('GET', Path(Kind), 200, '{"data":[],"meta":{"last_page":1}}');
            Response := Dispatch(Kind, Request(Kind));
            AssertCount(Response, 0);
        end;
    end;

    local procedure VerifyErrors(Kind: Integer)
    var
        Response: JsonObject;
        TextValue: Text;
        StatusCode: Integer;
        Expected: Text;
    begin
        for StatusCode := 1 to 4 do begin
            case StatusCode of
                1:
                    Store.RegisterResponse('GET', Path(Kind), 401, '{"message":"DEMO_ERROR_MARKER"}');
                2:
                    Store.RegisterResponse('GET', Path(Kind), 403, '{"message":"DEMO_ERROR_MARKER"}');
                3:
                    Store.RegisterResponse('GET', Path(Kind), 404, '{"message":"DEMO_ERROR_MARKER"}');
                4:
                    Store.RegisterResponse('GET', Path(Kind), 422, '{"message":"DEMO_ERROR_MARKER","errors":{"field":["DEMO_ERROR_MARKER"]}}');
            end;
            asserterror Response := Dispatch(Kind, Request(Kind));
            TextValue := GetLastErrorText();
            Assert.IsFalse(TextValue.Contains('DEMO_ERROR_MARKER'), 'Do not echo upstream error body');
            if StatusCode in [1, 2] then begin
                if Kind = 2 then
                    Assert.IsTrue(TextValue.Contains('manage_products'), 'Product permission hint');
                if Kind = 5 then
                    Assert.IsTrue(TextValue.Contains('manage_inbound_invoices'), 'Inbound permission hint');
            end;
            if StatusCode = 3 then begin
                if GlobalLanguage() = 1039 then
                    Expected := 'Manor fann ekki'
                else
                    Expected := 'Manor could not find';
                Assert.IsTrue(TextValue.Contains(Expected), 'Localized not found');
            end;
        end;
    end;

    local procedure VerifyInvalid(Kind: Integer)
    begin
        if Kind = 3 then
            asserterror Dispatch(Kind, '{"firmId":0}')
        else
            asserterror Dispatch(Kind, '{}');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'Invalid input never calls transport');
    end;

    local procedure VerifyInboundStatus()
    var
        Query: Codeunit "Manor Query Builder ori";
        Response: JsonObject;
        Token: JsonToken;
        Row: JsonToken;
    begin
        Query.Add('updated_since', '2026-01-01T00:00:00Z');
        Store.RegisterQueuedResponse('GET', Path(5), Query.Build() + '&per_page=100&page=1', 200, '{"data":[{"id":1,"status":"pending"},{"id":2,"status":"accepted"}],"meta":{"last_page":2}}');
        Store.RegisterQueuedResponse('GET', Path(5), Query.Build() + '&per_page=100&page=2', 200, '{"data":[{"id":1,"status":"rejected"},{"id":3,"status":"pending"}],"meta":{"last_page":2}}');
        Response := Dispatch(5, '{"mode":"updated","updatedSince":"2026-01-01T00:00:00Z","status":"pending"}');
        AssertCount(Response, 1);
        Response.Get('data', Token);
        Token.AsArray().Get(0, Row);
        Row.AsObject().Get('id', Token);
        Assert.AreEqual(3, Token.AsValue().AsInteger(), 'De-duplicate before filtering; last occurrence wins');
    end;

    local procedure VerifyInvalidStatus()
    var
        Response: JsonObject;
        Value: Text;
    begin
        asserterror Response := Dispatch(5, '{"mode":"updated","updatedSince":"2026-01-01T00:00:00Z","status":"unknown"}');
        Value := GetLastErrorText();
        Assert.IsTrue(Value.Contains('not_assigned') and Value.Contains('pending') and Value.Contains('accepted') and Value.Contains('rejected'), 'Allowed values listed');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'Validate before transport');
    end;

    local procedure VerifyAccepted()
    var
        Response: JsonObject;
        Rows: JsonArray;
        Row: JsonToken;
        Token: JsonToken;
    begin
        Store.RegisterResponse('GET', '/inbound-invoice/accepted', 200, '{"data":[{"id":9,"status":"accepted"}]}');
        Response := Dispatch(5, '{"mode":"accepted","from":"2026-01-01","to":"2026-01-31"}');
        AssertCount(Response, 1);
        Rows := Store.GetRequests();
        Rows.Get(0, Row);
        Row.AsObject().Get('query', Token);
        Assert.AreEqual('from=2026-01-01&to=2026-01-31&per_page=100&page=1', Token.AsValue().AsText(), 'Accepted dates forwarded');
    end;

    local procedure VerifyDateRange()
    begin
        asserterror Dispatch(1, '{"projectId":42,"fromDate":"2026-01-01","toDate":"2026-01-02"}');
        asserterror Dispatch(3, '{"from":"2026-01-31","to":"2026-01-01"}');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'Ranges rejected before transport');
    end;

    local procedure VerifyPageLimit()
    begin
        Store.RegisterResponse('GET', Path(2), 200, '{"data":[],"meta":{"last_page":2}}');
        asserterror Dispatch(2, '{"projectId":42,"maxPages":1}');
        Assert.AreEqual(1, Store.GetRequests().Count(), 'Stop at page boundary without partial Success');
    end;

    local procedure VerifyBounds()
    begin
        asserterror Dispatch(2, '{"projectId":0}');
        asserterror Dispatch(2, '{"projectId":-1}');
        asserterror Dispatch(2, '{"projectId":42,"perPage":0}');
        asserterror Dispatch(2, '{"projectId":42,"perPage":101}');
        asserterror Dispatch(2, '{"projectId":42,"maxPages":0}');
        asserterror Dispatch(2, '{"projectId":42,"maxPages":1001}');
        asserterror Dispatch(2, '{"projectId":"42"}');
        asserterror Dispatch(2, '{"projectId":null}');
        asserterror Dispatch(2, '{"projectId":42.5}');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'All invalid bounds refused before transport');
        Store.RegisterResponse('GET', Path(2), 200, '{"data":[]}');
        AssertCount(Dispatch(2, '{"projectId":42,"perPage":1,"maxPages":1}'), 0);
        AssertCount(Dispatch(2, '{"projectId":42,"perPage":100,"maxPages":1000}'), 0);
    end;

    local procedure VerifyInvoiceNumber()
    begin
        Store.RegisterResponse('GET', '/invoice/1/99', 200, '{"invoice_number":99,"is_credit":false}');
        AssertStatus(Dispatch(4, '{"firmId":1,"invoiceNumber":99}'), 'Success');
    end;

    local procedure VerifyInvalidSelector()
    begin
        asserterror Dispatch(4, '{"invoiceId":7,"firmId":1,"invoiceNumber":99}');
        asserterror Dispatch(4, '{"firmId":1}');
        asserterror Dispatch(4, '{"invoiceNumber":99}');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'Ambiguous or incomplete selector refused before transport');
    end;

    local procedure VerifyMalformed()
    begin
        Store.RegisterResponse('GET', Path(2), 200, '{"data":{}}');
        asserterror Dispatch(2, Request(2));
        Store.RegisterResponse('GET', Path(2), 200, '{"data":[1]}');
        asserterror Dispatch(2, Request(2));
        Store.RegisterResponse('GET', Path(4), 200, '{"data":[]}');
        asserterror Dispatch(4, Request(4));
    end;

    local procedure VerifyBadDates()
    begin
        asserterror Dispatch(1, '{"projectId":42,"date":"2026-02-30"}');
        asserterror Dispatch(1, '{"projectId":42,"date":"15.01.2026"}');
        asserterror Dispatch(1, '{"projectId":42,"updatedSince":"yesterday"}');
        asserterror Dispatch(5, '{"mode":"accepted","from":"2026-01-01"}');
        asserterror Dispatch(5, '{"mode":"updated"}');
        asserterror Dispatch(5, '{"mode":"accepted","from":"2026-01-01","to":"2026-01-31","status":"pending"}');
        Assert.AreEqual(0, Store.GetRequests().Count(), 'Invalid dates/modes refused before transport');
    end;

    local procedure VerifyMockPrecedence()
    var
        Fixture: Record "Manor Read Fixture ori";
        Response: JsonObject;
        Token: JsonToken;
        Row: JsonToken;
    begin
        Fixture.Method := 'GET';
        Fixture.Path := CopyStr(Path(2), 1, MaxStrLen(Fixture.Path));
        Fixture.Query := 'per_page=100&page=1';
        Fixture.StatusCode := 200;
        Fixture.Body := '{"data":[{"id":999}]}';
        Fixture.Insert(false);
        Store.RegisterResponse('GET', Path(2), 200, '{"data":[{"id":1}]}');
        Response := Dispatch(2, Request(2));
        AssertCount(Response, 1);
        Response.Get('data', Token);
        Token.AsArray().Get(0, Row);
        Row.AsObject().Get('id', Token);
        Assert.AreEqual(1, Token.AsValue().AsInteger(), 'Session fixture wins');
        Store.Reset();
        Response := Dispatch(2, Request(2));
        Response.Get('data', Token);
        Token.AsArray().Get(0, Row);
        Row.AsObject().Get('id', Token);
        Assert.AreEqual(999, Token.AsValue().AsInteger(), 'Persisted fixture is the fallback');
        Fixture.Delete(false);
    end;

    local procedure VerifyAllStatuses()
    begin
        Store.RegisterResponse('GET', Path(5), 200, '{"data":[{"id":1,"status":"not_assigned"},{"id":2,"status":"pending"},{"id":3,"status":"accepted"},{"id":4,"status":"rejected"},{"id":1,"status":"pending"}]}');
        AssertCount(Dispatch(5, Request(5)), 4);
    end;
}
