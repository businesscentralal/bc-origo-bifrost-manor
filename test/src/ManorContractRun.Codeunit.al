namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost;
using System.Utilities;

/// <summary>Runs one dispatcher call so a raised error and an error response can be asserted the same way.</summary>
codeunit 98281 "Manor Contract Run ori"
{
    var
        MessageTypeToRun: Enum "Message Type ori";
        RequestText: Text;
        LanguageId: Integer;
        ResponseJson: JsonObject;

    /// <summary>Sets the message type, request body and language of the next run.</summary>
    procedure Prepare(NewMessageType: Enum "Message Type ori"; NewRequestText: Text; NewLanguageId: Integer)
    begin
        MessageTypeToRun := NewMessageType;
        RequestText := NewRequestText;
        LanguageId := NewLanguageId;
        Clear(ResponseJson);
    end;

    /// <summary>Returns the parsed dispatcher response of the last successful run.</summary>
    procedure GetResponse(): JsonObject
    begin
        exit(ResponseJson);
    end;

    trigger OnRun()
    var
        Dispatcher: Codeunit "Dispatcher ori";
        Blob: Codeunit "Temp Blob";
        Content: BigText;
        ResponseStream: InStream;
        ResponseContentType: Text[100];
        ResponseText: Text;
        TaskId: Guid;
        MessageId: Guid;
        ResponseTime: Duration;
    begin
        Content.AddText(RequestText);
        Dispatcher.EnqueueAndProcess(MessageTypeToRun, "Message Version ori"::"1.0", '', 'MANOR-CONTRACT-TEST', 'application/json', Content, TaskId, LanguageId, MessageId, Blob, ResponseContentType, ResponseTime, true);
        Blob.CreateInStream(ResponseStream, TextEncoding::UTF8);
        ResponseStream.ReadText(ResponseText);
        ResponseJson.ReadFrom(ResponseText);
    end;
}
