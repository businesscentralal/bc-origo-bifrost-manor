namespace Origo.Bifrost.Manor;

using System.Reflection;

/// <summary>Shared Production/Test transport; the host is fixed and credentials stay SecretText.</summary>
codeunit 10035644 "Manor HTTP Impl ori" implements "Manor Transport ori"
{
    Access = Internal;
    var
        BaseUrlTok: Label 'https://secure.manor.is/%1/external-api/v1', Locked = true;
        MissingInstanceErr: Label 'Enter the Manor instance in Manor Setup.', Comment = 'is-IS=Sláðu inn Manor-tilvikið í uppsetningu Manor.';
        InvalidPathErr: Label 'Use a relative Manor API path without a host, query, fragment or parent segment.', Comment = 'is-IS=Notaðu afstæða Manor API-slóð án hýsils, fyrirspurnar, brots eða yfirslóðar.';
        InvalidEnvironmentErr: Label 'Select Production or Test before using the Manor HTTP transport.', Comment = 'is-IS=Veldu raunumhverfi eða prófunarumhverfi áður en HTTP-tenging við Manor er notuð.';

    /// <summary>Builds the same fixed-host URL for Production and Test.</summary>
    procedure BuildBaseUrl(Instance: Text): Text
    var
        Setup: Record "Manor Setup ori";
    begin
        if Instance = '' then
            Error(MissingInstanceErr);
        Setup.ValidateInstance(Instance);
        exit(StrSubstNo(BaseUrlTok, Instance));
    end;

    /// <summary>Executes a relative API request. Transport failure returns an empty response.</summary>
    procedure Send(Method: Text; RelativePath: Text; Query: Text; Body: Text; var Response: Codeunit "Manor Response ori"): Boolean
    var
        Setup: Record "Manor Setup ori";
        Secrets: Codeunit "Manor Secrets ori";
        Client: HttpClient;
        Request: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        ResponseBody: Text;
        Url: Text;
        SecretUrl: SecretText;
    begin
        Response.SetResponse(0, '');
        Setup.Get();
        Setup.ValidateSetup();
        if not (Setup.Environment in [Setup.Environment::Production, Setup.Environment::Test]) then
            Error(InvalidEnvironmentErr);
        ValidatePath(RelativePath, Query);
        Url := BuildBaseUrl(Setup.Instance) + '/' + RelativePath;
        if Query <> '' then
            Url += '?' + Query;
        SecretUrl := Url;
        Request.SetSecretRequestUri(SecretUrl);
        Request.Method := Method;
        Request.GetHeaders(Headers);
        if UpperCase(Method) = 'GET' then
            Secrets.AddReadAuthorization(Headers)
        else
            Secrets.AddAuthorization(Headers);
        Headers.Add('Accept', 'application/json');
        if Body <> '' then begin
            Content.WriteFrom(Body);
            Content.GetHeaders(Headers);
            Headers.Remove('Content-Type');
            Headers.Add('Content-Type', 'application/json');
            Request.Content := Content;
        end;
        if not Client.Send(Request, HttpResponse) then
            exit(false);
        HttpResponse.Content.ReadAs(ResponseBody);
        Response.SetResponse(HttpResponse.HttpStatusCode(), ResponseBody);
        exit(HttpResponse.IsSuccessStatusCode());
    end;

    local procedure ValidatePath(RelativePath: Text; Query: Text)
    begin
        if (RelativePath = '') or (CopyStr(RelativePath, 1, 1) = '/') or
           (StrPos(RelativePath, '..') > 0) or (StrPos(RelativePath, ':') > 0) or
           (StrPos(RelativePath, '?') > 0) or (StrPos(RelativePath, '#') > 0) or
           ((StrPos(RelativePath, '%') > 0) and not IsEncodedUserEmailPath(RelativePath)) or (StrPos(RelativePath, '\') > 0) or
           (StrPos(Query, '#') > 0)
        then
            Error(InvalidPathErr);
    end;

    local procedure IsEncodedUserEmailPath(RelativePath: Text): Boolean
    var
        TypeHelper: Codeunit "Type Helper";
        Encoded: Text;
        Email: Text;
        Index: Integer;
        AtPosition: Integer;
    begin
        if CopyStr(RelativePath, 1, 5) <> 'user/' then
            exit(false);
        Encoded := CopyStr(RelativePath, 6);
        Email := Encoded;
        Email := TypeHelper.UrlDecode(Email);
        AtPosition := StrPos(Email, '@');
        if (AtPosition <= 1) or (AtPosition = StrLen(Email)) then
            exit(false);
        if StrPos(CopyStr(Email, AtPosition + 1), '@') > 0 then
            exit(false);
        for Index := 1 to StrLen(Email) do
            if (Email[Index] <= 32) or (StrPos('/\?#:%', CopyStr(Email, Index, 1)) > 0) then
                exit(false);
        exit(TypeHelper.UriEscapeDataString(Email) = Encoded);
    end;
}
