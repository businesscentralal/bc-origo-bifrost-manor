namespace Origo.Bifrost.Manor;

/// <summary>Owns company-scoped secret storage. There is no procedure returning a stored key.</summary>
codeunit 10035648 "Manor Secrets ori"
{
    Access = Internal;

    var
        StorageKeyTok: Label 'Manor.ApiKey', Locked = true;
        PermissionErr: Label 'You need permission to edit Manor Setup to manage or use its API key.', Comment = 'is-IS=Þú þarft heimild til að breyta uppsetningu Manor til að stjórna eða nota API-lykilinn.';
        ReadPermissionErr: Label 'You need permission to read Manor Setup to use its API key for a read.', Comment = 'is-IS=Þú þarft lesheimild á uppsetningu Manor til að nota API-lykilinn fyrir lestur.';
        EmptyKeyErr: Label 'Enter an API key.', Comment = 'is-IS=Sláðu inn API-lykil.';
        MissingKeyErr: Label 'Set the API key in Manor Setup.', Comment = 'is-IS=Stilltu API-lykilinn í uppsetningu Manor.';

    /// <summary>Reports existence only, never the credential.</summary>
    procedure HasApiKey(): Boolean
    begin
        exit(IsolatedStorage.Contains(StorageKeyTok, DataScope::Company));
    end;

    /// <summary>Stores a secret in the current company after checking setup-write permission.</summary>
    procedure SetApiKey(ApiKey: SecretText)
    begin
        CheckWritePermission();
        if ApiKey.IsEmpty() then
            Error(EmptyKeyErr);
        IsolatedStorage.Set(StorageKeyTok, ApiKey, DataScope::Company);
    end;

    /// <summary>Removes the credential from the current company; safe to repeat.</summary>
    procedure ClearApiKey()
    begin
        CheckWritePermission();
        if HasApiKey() then
            IsolatedStorage.Delete(StorageKeyTok, DataScope::Company);
    end;

    /// <summary>Adds the credential directly to request headers without exposing plain text.</summary>
    internal procedure AddAuthorization(var Headers: HttpHeaders)
    begin
        CheckWritePermission();
        AddStoredAuthorization(Headers);
    end;

    /// <summary>Uses the stored key for a transport-verified GET; grants no key-management or write permission.</summary>
    internal procedure AddReadAuthorization(var Headers: HttpHeaders)
    var
        Setup: Record "Manor Setup ori";
    begin
        if not Setup.ReadPermission() then
            Error(ReadPermissionErr);
        AddStoredAuthorization(Headers);
    end;

    local procedure AddStoredAuthorization(var Headers: HttpHeaders)
    var
        ApiKey: SecretText;
    begin
        if not IsolatedStorage.Get(StorageKeyTok, DataScope::Company, ApiKey) then
            Error(MissingKeyErr);
        Headers.Add('Authorization', SecretStrSubstNo('Bearer %1', ApiKey));
        Clear(ApiKey);
    end;

    local procedure CheckWritePermission()
    var
        Setup: Record "Manor Setup ori";
    begin
        if not Setup.WritePermission() then
            Error(PermissionErr);
    end;
}
