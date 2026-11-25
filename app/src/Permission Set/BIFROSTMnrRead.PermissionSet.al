namespace Origo.Bifrost.Manor;

/// <summary>
/// Read-only Bifrost Manor role. Grants setup read access without key management or transport execution.
/// </summary>
permissionset 10035638 "BIFROST MnrRead ori"
{
    Assignable = true;
    Access = Public;
    Caption = 'Bifrost Manor Read', MaxLength = 30, Comment = 'is-IS=Bifröst - Manor (lestur)';
    IncludedPermissionSets = "BIFROST Manor ori";
    Permissions = table "Manor Setup ori" = X,
                  tabledata "Manor Setup ori" = R,
                  page "Manor Setup ori" = X,
                  codeunit "Manor Secrets ori" = X,
                  codeunit "Manor Response ori" = X;
}
