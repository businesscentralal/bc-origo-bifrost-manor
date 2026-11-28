namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost;
using Origo.Bifrost.Manor;
using System.TestLibraries.Security.AccessControl;
using System.TestLibraries.Utilities;

/// <summary>Issue 8: contract replay of every Manor message type over the Mock transport (no network, no credentials), the no-delete guard and the catalogue guard, in 1033 and 1039.</summary>
codeunit 98280 "Manor Contract Tst ori"
{
    Subtype = Test;
    TestPermissions = Restrictive;
    TestHttpRequestPolicy = BlockOutboundRequests;

    var
        Assert: Codeunit "Library Assert";
        LowerPermissions: Codeunit "Library - Lower Permissions";
        Store: Codeunit "Manor Mock Store ori";
        PreviousLanguage: Integer;
        ErrorMarkerLbl: Label 'XDO-NOT-ECHO-CONTRACT', Locked = true;

    /// <summary>AC01: every type replays a happy path on the Mock, English.</summary>
    [Test]
    procedure Scenario_AC01_ReplayHappy1033()
    begin
        ReplayHappy(1033);
    end;

    /// <summary>AC01: every type replays a happy path on the Mock, Icelandic.</summary>
    [Test]
    procedure Scenario_AC01_ReplayHappy1039()
    begin
        ReplayHappy(1039);
    end;

    /// <summary>AC01: every type maps upstream errors without echoing the upstream body, English.</summary>
    [Test]
    procedure Scenario_AC01_ReplayErrors1033()
    begin
        ReplayErrors(1033);
    end;

    /// <summary>AC01: every type maps upstream errors without echoing the upstream body, Icelandic.</summary>
    [Test]
    procedure Scenario_AC01_ReplayErrors1039()
    begin
        ReplayErrors(1039);
    end;

    /// <summary>AC02: no Manor type is a delete type and no replay ever sends HTTP DELETE.</summary>
    [Test]
    procedure Scenario_AC02_NoDeleteGuard()
    var
        Name: Text;
        Found: Integer;
    begin
        foreach Name in "Message Type ori".Names() do
            if Name.StartsWith('Manor.') then begin
                Found += 1;
                Assert.IsFalse(Name.EndsWith('.Delete'), 'Delete type: ' + Name);
                Assert.IsFalse(Name.ToLower().Contains('delete'), 'Delete wording: ' + Name);
            end;
        Assert.AreEqual(CaseCount(), Found, 'Every Manor message type is covered by a replay case; add a case for a new type.');
        ReplayHappy(1033);
    end;

    /// <summary>AC01: each replay case names a distinct registered Manor type.</summary>
    [Test]
    procedure Scenario_AC01_CasesCoverCatalogue()
    var
        Seen: List of [Text];
        Names: List of [Text];
        Index: Integer;
        Name: Text;
    begin
        for Index := 1 to CaseCount() do begin
            Name := Format(CaseType(Index));
            Assert.IsFalse(Seen.Contains(Name), 'Duplicate case ' + Name);
            Seen.Add(Name);
        end;
        Names := "Message Type ori".Names();
        foreach Name in Names do
            if Name.StartsWith('Manor.') then
                Assert.IsTrue(Seen.Contains(Name), 'No replay case for ' + Name);
    end;

    local procedure ReplayHappy(LanguageId: Integer)
    var
        Runner: Codeunit "Manor Contract Run ori";
        Response: JsonObject;
        Token: JsonToken;
        Index: Integer;
        Info: Text;
    begin
        Initialize(LanguageId);
        for Index := 1 to CaseCount() do begin
            Store.Reset();
            RegisterCase(Index, 200 + 0, CaseBody(Index));
            Runner.Prepare(CaseType(Index), CaseRequest(Index), LanguageId);
            Info := Format(CaseType(Index)) + ' ' + Format(LanguageId);
            if not Runner.Run() then
                Assert.Fail(Info + ' raised: ' + GetLastErrorText());
            Response := Runner.GetResponse();
            Assert.IsTrue(Response.Get('status', Token), Info + ' has a status');
            Assert.AreEqual('Success', Token.AsValue().AsText(), Info + ' status');
            AssertRequests(Index, Info);
        end;
        Cleanup();
    end;

    local procedure ReplayErrors(LanguageId: Integer)
    var
        Runner: Codeunit "Manor Contract Run ori";
        Response: JsonObject;
        Token: JsonToken;
        Index: Integer;
        Status: Integer;
        Info: Text;
        Reply: Text;
    begin
        Initialize(LanguageId);
        for Index := 1 to CaseCount() do
            foreach Status in ErrorStatuses() do begin
                Store.Reset();
                RegisterCase(Index, Status, '{"message":"' + ErrorMarkerLbl + '","errors":{"key":["invalid"]}}');
                Runner.Prepare(CaseType(Index), CaseRequest(Index), LanguageId);
                Info := Format(CaseType(Index)) + ' ' + Format(Status) + ' ' + Format(LanguageId);
                if Runner.Run() then begin
                    Response := Runner.GetResponse();
                    Response.WriteTo(Reply);
                    if Response.Get('status', Token) then
                        Assert.AreNotEqual('Success', Token.AsValue().AsText(), Info + ' must not succeed');
                end else
                    Reply := GetLastErrorText();
                Assert.AreEqual(0, StrPos(Reply, ErrorMarkerLbl), Info + ' must not echo the upstream body');
                Assert.AreNotEqual('', Reply, Info + ' reports something');
            end;
        Cleanup();
    end;

    local procedure ErrorStatuses() Statuses: List of [Integer]
    begin
        Statuses.AddRange(401, 403, 404, 422, 503);
    end;

    local procedure AssertRequests(Index: Integer; Info: Text)
    var
        Requests: JsonArray;
        Request: JsonToken;
        Value: JsonToken;
        Method: Text;
        RequestPath: Text;
        Matched: Boolean;
    begin
        Requests := Store.GetRequests();
        foreach Request in Requests do begin
            Request.AsObject().Get('method', Value);
            Method := Value.AsValue().AsText();
            Assert.IsTrue(Method in ['GET', 'POST', 'PUT'], Info + ' uses only GET, POST or PUT, not ' + Method);
            Request.AsObject().Get('path', Value);
            RequestPath := Value.AsValue().AsText().TrimStart('/');
            if (Method = CaseMethod(Index)) and (RequestPath = CasePath(Index)) then
                Matched := true;
        end;
        Assert.IsTrue(Matched, Info + ' sent ' + CaseMethod(Index) + ' ' + CasePath(Index));
    end;

    local procedure RegisterCase(Index: Integer; Status: Integer; Body: Text)
    begin
        // Paths are registered with and without the leading slash because families differ.
        Store.RegisterResponse(CaseMethod(Index), CasePath(Index), Status, Body);
        Store.RegisterResponse(CaseMethod(Index), '/' + CasePath(Index), Status, Body);
        if Index = 24 then begin
            Store.RegisterResponse('GET', 'rate', 200, '{"data":[{"id":8,"type":"product"}],"meta":{"last_page":1}}');
            Store.RegisterResponse('GET', '/rate', 200, '{"data":[{"id":8,"type":"product"}],"meta":{"last_page":1}}');
        end;
    end;

    local procedure CaseCount(): Integer
    begin
        exit(24);
    end;

    local procedure CaseType(Index: Integer): Enum "Message Type ori"
    var
        Names: List of [Text];
        Ordinal: Integer;
    begin
        Names.AddRange('Manor.Connection.Test', 'Manor.Firm.List', 'Manor.User.List', 'Manor.User.Get', 'Manor.Rate.List',
            'Manor.Client.List', 'Manor.Client.Get', 'Manor.Project.List', 'Manor.Project.Get', 'Manor.Activity.List',
            'Manor.TimeEntry.List', 'Manor.Product.List', 'Manor.Invoice.List', 'Manor.Invoice.Get', 'Manor.InboundInvoice.List',
            'Manor.Client.Create', 'Manor.Client.Update', 'Manor.Project.Create', 'Manor.Project.Update', 'Manor.Activity.Create',
            'Manor.Activity.Update', 'Manor.TimeEntry.Create', 'Manor.Expense.Create', 'Manor.Product.Create');
        Ordinal := "Message Type ori".Ordinals().Get("Message Type ori".Names().IndexOf(Names.Get(Index)));
        exit("Message Type ori".FromInteger(Ordinal));
    end;

    local procedure CaseMethod(Index: Integer): Text
    begin
        case Index of
            1 .. 15:
                exit('GET');
            16, 18, 20, 22, 23, 24:
                exit('POST');
            else
                exit('PUT');
        end;
    end;

    local procedure CasePath(Index: Integer): Text
    begin
        case Index of
            1:
                exit('ping');
            2:
                exit('firm');
            3:
                exit('user');
            4:
                exit('user/1');
            5:
                exit('rate');
            6:
                exit('client');
            7:
                exit('client/7');
            8:
                exit('project');
            9:
                exit('project/3');
            10:
                exit('project/12/activity');
            11:
                exit('project/42/time');
            12:
                exit('project/42/product');
            13:
                exit('invoice');
            14:
                exit('invoice/7');
            15:
                exit('inbound-invoice/updated');
            16:
                exit('client');
            17:
                exit('client/10');
            18:
                exit('project');
            19:
                exit('project/20');
            20:
                exit('project/20/activity');
            21:
                exit('project/20/activity/30');
            22:
                exit('project/17/time');
            23:
                exit('project/17/expense');
            24:
                exit('project/17/product');
        end;
    end;

    local procedure CaseRequest(Index: Integer): Text
    begin
        case Index of
            1, 2, 3, 5, 6, 8:
                exit('{}');
            4:
                exit('{"userId":1}');
            7:
                exit('{"clientId":7}');
            9:
                exit('{"projectId":3}');
            10:
                exit('{"projectId":12}');
            11:
                exit('{"projectId":42,"userId":3,"date":"2026-01-15","updatedSince":"2026-01-01T00:00:00Z"}');
            12:
                exit('{"projectId":42}');
            13:
                exit('{"firmId":1,"createdSince":"2026-01-01T00:00:00Z","updatedSince":"2026-01-02T00:00:00Z","from":"2026-01-01","to":"2026-01-31"}');
            14:
                exit('{"invoiceId":7}');
            15:
                exit('{"mode":"updated","updatedSince":"2026-01-01T00:00:00Z"}');
            16:
                exit('{"expectedCount":1,"name":"Demo Client","national_id":"0101010000","currency_code":"ISK"}');
            17:
                exit('{"expectedCount":1,"id":"10","email":"a@example.com"}');
            18:
                exit('{"expectedCount":1,"name":"P","owner":"1"}');
            19:
                exit('{"expectedCount":1,"id":"20","open":true}');
            20:
                exit('{"expectedCount":1,"projectId":"20","name":"Design","budget":100}');
            21:
                exit('{"expectedCount":1,"projectId":"20","id":"30","name":"Design phase"}');
            22:
                exit('{"projectId":17,"expectedCount":1,"description":"Contract fixture","begins_at":"2026-11-20T09:00:00Z","hours":2,"user_id":5}');
            23:
                exit('{"projectId":17,"expectedCount":1,"description":"Contract fixture","amount":1500,"paid_at":"2026-11-20T09:00:00Z","paid_in_currency_code":"ISK","vat_rate_id":3}');
            24:
                exit('{"projectId":17,"expectedCount":1,"description":"Contract fixture","date":"2026-11-20","quantity":2,"user_id":5,"rate_id":8}');
        end;
    end;

    local procedure CaseBody(Index: Integer): Text
    begin
        case Index of
            1:
                exit('{"message":"Connected"}');
            2, 3, 5, 6, 8, 10, 11, 12, 13, 15:
                exit('{"data":[{"id":1,"name":"Demo"}],"meta":{"current_page":1,"last_page":1}}');
            4:
                exit('{"id":1,"name":"Demo","enabled":true}');
            7, 9, 14:
                exit('{"data":{"id":7,"name":"Demo"}}');
            else
                exit('{"data":{"id":10,"name":"Demo"}}');
        end;
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
        Setup.Environment := Setup.Environment::Mock;
        Setup.Enabled := true;
        Setup.Modify(false);
        Commit();
        LowerPermissions.SetExactPermissionSet('Manor Setup Test ori');
        LowerPermissions.AddPermissionSet('BIFROST Read ori');
        LowerPermissions.AddPermissionSet('BIFROST API ori');
        LowerPermissions.AddPermissionSet('BIFROST MnrFull ori');
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
