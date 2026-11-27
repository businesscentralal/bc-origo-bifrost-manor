namespace Origo.Bifrost.Manor;

/// <summary>Logs Manor calls with method, path template and status only: never keys, query values, bodies or ids.</summary>
codeunit 10035654 "Manor Telemetry ori"
{
    Access = Internal;

    var
        CallTxt: Label 'Manor API call', Locked = true;

    /// <summary>Logs one completed attempt.</summary>
    procedure LogCall(Method: Text; RelativePath: Text; StatusCode: Integer)
    var
        Dimensions: Dictionary of [Text, Text];
    begin
        Dimensions.Add('method', UpperCase(Method));
        Dimensions.Add('path', PathTemplate(RelativePath));
        Dimensions.Add('status', Format(StatusCode, 0, 9));
        Session.LogMessage('MNR0001', CallTxt, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, Dimensions);
    end;

    /// <summary>Replaces every path segment that contains a digit with {id}.</summary>
    procedure PathTemplate(RelativePath: Text): Text
    var
        Segment: Text;
        Result: Text;
    begin
        foreach Segment in RelativePath.Split('/') do begin
            if DelChr(Segment, '=', '0123456789') <> Segment then
                Segment := '{id}';
            if Result <> '' then
                Result += '/';
            Result += Segment;
        end;
        exit(Result);
    end;
}
