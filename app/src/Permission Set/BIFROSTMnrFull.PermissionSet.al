namespace Origo.Bifrost.Manor;

/// <summary>
/// Full Bifrost Manor role. Grants setup editing, key management and transport execution.
/// </summary>
permissionset 10035637 "BIFROST MnrFull ori"
{
    Assignable = true;
    Access = Public;
    Caption = 'Bifrost Manor Full', MaxLength = 30, Comment = 'is-IS=Bifröst - Manor (fullt)';
    IncludedPermissionSets = "BIFROST MnrRead ori";
    Permissions = tabledata "Manor Setup ori" = RIMD,
                  page "Manor API Key ori" = X;
}
