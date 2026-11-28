namespace Origo.Bifrost.Manor;

/// <summary>
/// Read-only Bifrost Manor role. Grants setup read access and execution of the approved read message types; no key management. The connection test can update its timestamp indirectly.
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
                  codeunit "Manor Telemetry ori" = X,
                  codeunit "Mnr Time List Impl ori" = X,
                  codeunit "Mnr Product List Impl ori" = X,
                  codeunit "Mnr Invoice List Impl ori" = X,
                  codeunit "Mnr Invoice Get Impl ori" = X,
                  codeunit "Mnr Inbound List Impl ori" = X,
                  codeunit "Manor Read Mgt ori" = X,
                  codeunit "Manor Read Parts ori" = X,
                  codeunit "Manor Client List Impl ori" = X,
                  codeunit "Manor Client Get Impl ori" = X,
                  codeunit "Manor Project List Impl ori" = X,
                  codeunit "Manor Project Get Impl ori" = X,
                  codeunit "Manor Activity List Impl ori" = X;
}
