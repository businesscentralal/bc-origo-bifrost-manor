namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost.Manor;

/// <summary>Resolves explicitly seeded mock routes in the test app; never intercepts a real transport.</summary>
codeunit 98252 "Manor Mock Fixture Sub ori"
{
    Permissions = tabledata "Manor Read Fixture ori" = r;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Manor Mock Store ori", OnBeforeResolve, '', false, false)]
    local procedure ResolveFixture(Method: Text; RelativePath: Text; Query: Text; var Response: Codeunit "Manor Response ori"; var Handled: Boolean)
    var
        Fixture: Record "Manor Read Fixture ori";
    begin
        if Handled then
            exit;
        if (StrLen(Method) > MaxStrLen(Fixture.Method)) or (StrLen(RelativePath) > MaxStrLen(Fixture.Path)) or (StrLen(Query) > MaxStrLen(Fixture.Query)) then
            exit;
        if not Fixture.Get(Method, RelativePath, Query) then
            exit;
        if not CompanyName().StartsWith('CRONUS') then
            Error('Mock fixtures are allowed only in CRONUS demo companies.');
        Response.SetResponse(Fixture.StatusCode, Fixture.Body);
        Handled := true;
    end;
}
