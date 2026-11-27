namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost;
using Origo.Bifrost.Manor;
using System.Utilities;

/// <summary>Self-seeds mock responses for an approved read, dispatches it, and restores setup and mock state.</summary>
codeunit 98232 "Manor Read Probe ori" implements "Msg Interface ori"
{
    Access = Internal;

    /// <summary>Enables the fixture only when setup is absent or already Mock.</summary>
    procedure IsEnabled(): Boolean
    var
        Setup: Record "Manor Setup ori";
    begin
        if not Setup.Get() then
            exit(true);
        exit(Setup.Environment = Setup.Environment::Mock);
    end;

    /// <summary>The fixture has no filter table.</summary>
    procedure GetFilterTableNo(): Integer
    begin
        exit(0);
    end;

    /// <summary>Describes this test-only probe.</summary>
    procedure GetDescription(): Text[250]
    begin
        exit('Test-app-only, self-cleaning Manor mock read probe.');
    end;

    /// <summary>Returns the outbound direction.</summary>
    procedure GetMessageDirection(): Enum "Msg Direction ori"
    begin
        exit("Msg Direction ori"::Outbound);
    end;

    /// <summary>Dispatches only one of the five approved reads with fixed synthetic fixtures.</summary>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        Setup: Record "Manor Setup ori";
        Original: Record "Manor Setup ori";
        Store: Codeunit "Manor Mock Store ori";
        Dispatcher: Codeunit "Dispatcher ori";
        ResponseBlob: Codeunit "Temp Blob";
        Input: BigText;
        Output: BigText;
        MessageType: Enum "Message Type ori";
        Request: JsonObject;
        ResponseStream: InStream;
        OutputType: Text[100];
        Response: Text;
        RequestText: Text;
        HadSetup: Boolean;
        EmptyTaskId: Guid;
        MessageId: Guid;
        ResponseTime: Duration;
    begin
        Argument.AssertIsLicensed();
        Argument.AssertVersion1();
        Request := Argument.GetRequestJson();
        case Request.GetText('messageType') of
            'Manor.Connection.Test':
                MessageType := MessageType::"Manor.Connection.Test";
            'Manor.Firm.List':
                MessageType := MessageType::"Manor.Firm.List";
            'Manor.User.List':
                MessageType := MessageType::"Manor.User.List";
            'Manor.User.Get':
                MessageType := MessageType::"Manor.User.Get";
            'Manor.Rate.List':
                MessageType := MessageType::"Manor.Rate.List";
            else
                Error('Only the five issue-3 read types are supported.');
        end;
        if not IsEnabled() then
            Error('The probe requires the Mock environment.');
        HadSetup := Original.Get();
        if HadSetup then
            Setup := Original
        else begin
            Setup.Init();
            Setup.Insert(false);
        end;
        Setup.Environment := Setup.Environment::Mock;
        Setup.Enabled := true;
        Setup.Modify(false);
        Store.Reset();
        Store.RegisterResponse('GET', 'ping', 200, '{"message":"XMock connection successful"}');
        Store.RegisterResponse('GET', 'firm', 200, '{"data":[{"id":1,"name":"XDemo firm","currency_code":"ISK","default_vat_rate_id":24}],"meta":{"current_page":1,"last_page":1}}');
        Store.RegisterResponse('GET', 'user', 200, '{"data":[{"id":1,"name":"XDemo employee","enabled":true,"owns_projects":true,"approves_invoices":true},{"id":2,"name":"XDisabled employee","enabled":false}],"meta":{"current_page":1,"last_page":1}}');
        Store.RegisterResponse('GET', 'user/1', 200, '{"id":1,"name":"XDemo employee","enabled":true}');
        Store.RegisterResponse('GET', 'rate', 200, '{"data":[{"id":1,"name":"XTime","type":"time","price":100,"latest_price":110},{"id":2,"type":"travel"}],"meta":{"current_page":1,"last_page":1}}');
        if Request.Contains('request') then begin
            Request.GetObject('request').WriteTo(RequestText);
            Input.AddText(RequestText);
        end
        else
            if MessageType = MessageType::"Manor.User.Get" then
                Input.AddText('{"userId":1}')
            else
                Input.AddText('{}');
        Dispatcher.EnqueueAndProcess(MessageType, "Message Version ori"::"1.0", '', '', 'text/json', Input, EmptyTaskId, GlobalLanguage(), MessageId, ResponseBlob, OutputType, ResponseTime, true);
        ResponseBlob.CreateInStream(ResponseStream);
        Output.Read(ResponseStream);
        Output.GetSubText(Response, 1);
        if HadSetup then begin
            Setup := Original;
            Setup.Modify(false);
        end else
            Setup.Delete(false);
        Store.Reset();
        Argument.SetResponseText(Response);
        Argument."Content Type" := OutputType;
    end;
}
