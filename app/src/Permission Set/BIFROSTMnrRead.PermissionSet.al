namespace Origo.Bifrost.Manor;

/// <summary>
/// Read-only Bifrost Manor role. Grants setup read access without key management. The connection test can update its timestamp indirectly.
/// </summary>
permissionset 10035638 "BIFROST MnrRead ori"
{
    Assignable = true;
    Access = Public;
    Caption = 'Bifrost Manor Read', MaxLength = 30, Comment = 'is-IS=Bifröst - Manor (lestur)';
    IncludedPermissionSets = "BIFROST Manor ori";
    Permissions = table "Manor Setup ori" = X,
                  tabledata "Manor Setup ori" = Rm,
                  page "Manor Setup ori" = X,
                  codeunit "Manor Secrets ori" = X,
                  codeunit "Manor Response ori" = X,
                  codeunit "Manor Connection Test Impl ori" = X,
                  codeunit "Manor Firm List Impl ori" = X,
                  codeunit "Manor User List Impl ori" = X,
                  codeunit "Manor User Get Impl ori" = X,
                  codeunit "Manor Rate List Impl ori" = X,
                  codeunit "Manor HTTP Impl ori" = X,
                  codeunit "Manor Mock Impl ori" = X,
                  codeunit "Manor Mock Store ori" = X,
                  codeunit "Manor Client ori" = X,
                  codeunit "Manor Error Mapper ori" = X,
                  codeunit "Manor Query Builder ori" = X,
                  codeunit "Manor Telemetry ori" = X;
}
