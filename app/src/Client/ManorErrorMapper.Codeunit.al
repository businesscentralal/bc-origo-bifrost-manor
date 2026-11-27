namespace Origo.Bifrost.Manor;

/// <summary>Maps Manor HTTP failures to documented messages. Messages never contain the key, the URL query or the request body.</summary>
codeunit 10035652 "Manor Error Mapper ori"
{
    Access = Internal;

    var
        RejectedErr: Label 'Manor rejected the API key or its permissions.', Comment = 'is-IS=Manor hafnaði API-lyklinum eða heimildum hans.';
        RejectedPermissionErr: Label 'Manor rejected the API key or its permissions. Required Manor permission: %1.', Comment = '%1 = Manor permission name; is-IS=Manor hafnaði API-lyklinum eða heimildum hans. Nauðsynleg heimild í Manor: %1.';
        NotFoundErr: Label 'Manor could not find the requested resource.', Comment = 'is-IS=Manor fann ekki umbeðið gagn.';
        ValidationErr: Label 'Manor rejected the data: %1', Comment = '%1 = field messages; is-IS=Manor hafnaði gögnunum: %1';
        ValidationNoDetailErr: Label 'Manor rejected the data.', Comment = 'is-IS=Manor hafnaði gögnunum.';
        UnavailableErr: Label 'Manor is unavailable or busy (HTTP %1). Try again later.', Comment = '%1 = HTTP status; is-IS=Manor er ekki tiltækt eða of upptekið (HTTP %1). Reyndu aftur síðar.';
        UnreachableErr: Label 'Could not reach Manor. Try again later.', Comment = 'is-IS=Ekki náðist samband við Manor. Reyndu aftur síðar.';
        OtherErr: Label 'Manor returned HTTP status %1.', Comment = '%1 = HTTP status; is-IS=Manor skilaði HTTP-stöðu %1.';
        PermissionNamesTxt: Label 'manage_inbound_invoices,manage_rates,set_alternative_user_of_times', Locked = true;

    /// <summary>True for transport failures, 429 and 5xx, which are retried once.</summary>
    procedure IsRetryable(StatusCode: Integer): Boolean
    begin
        exit((StatusCode = 0) or (StatusCode = 429) or (StatusCode >= 500));
    end;

    /// <summary>Raises the documented error for a failed response.</summary>
    procedure RaiseError(StatusCode: Integer; Body: Text)
    begin
        case true of
            StatusCode = 0:
                Error(UnreachableErr);
            (StatusCode = 401) or (StatusCode = 403):
                RaiseRejected(Body);
            StatusCode = 404:
                Error(NotFoundErr);
            StatusCode = 422:
                RaiseValidation(Body);
            IsRetryable(StatusCode):
                Error(UnavailableErr, StatusCode);
            else
                Error(OtherErr, StatusCode);
        end;
    end;

    /// <summary>Returns localised create errors without copying provider text, request values or credentials.</summary>
    procedure RaiseCreateError(StatusCode: Integer; RequiredPermission: Text)
    begin
        if StatusCode in [401, 403] then
            Error(RejectedPermissionErr, RequiredPermission);
        // Empty provider text deliberately prevents reflected secrets in validation errors.
        RaiseError(StatusCode, '');
    end;

    local procedure RaiseRejected(Body: Text)
    var
        Names: Text;
        Name: Text;
    begin
        Names := PermissionNamesTxt;
        foreach Name in Names.Split(',') do
            if StrPos(Body, Name) > 0 then
                Error(RejectedPermissionErr, Name);
        Error(RejectedErr);
    end;

    local procedure RaiseValidation(Body: Text)
    var
        Details: Text;
    begin
        Details := ReadValidationDetails(Body);
        if Details = '' then
            Error(ValidationNoDetailErr);
        Error(ValidationErr, CopyStr(Details, 1, 1000));
    end;

    local procedure ReadValidationDetails(Body: Text): Text
    var
        Json: JsonObject;
        ErrorsToken: JsonToken;
        MessageToken: JsonToken;
        FieldToken: JsonToken;
        Item: JsonToken;
        Details: Text;
        FieldName: Text;
    begin
        if not Json.ReadFrom(Body) then
            exit('');
        if Json.Get('errors', ErrorsToken) and ErrorsToken.IsObject() then begin
            foreach FieldName in ErrorsToken.AsObject().Keys() do begin
                ErrorsToken.AsObject().Get(FieldName, FieldToken);
                if FieldToken.IsArray() then
                    foreach Item in FieldToken.AsArray() do
                        if Item.IsValue() then
                            AppendDetail(Details, FieldName, Item.AsValue().AsText());
            end;
            if Details <> '' then
                exit(Details);
        end;
        if Json.Get('message', MessageToken) and MessageToken.IsValue() then
            exit(MessageToken.AsValue().AsText());
        exit('');
    end;

    local procedure AppendDetail(var Details: Text; FieldName: Text; Message: Text)
    begin
        if Details <> '' then
            Details += ' ';
        Details += FieldName + ': ' + Message;
    end;
}
