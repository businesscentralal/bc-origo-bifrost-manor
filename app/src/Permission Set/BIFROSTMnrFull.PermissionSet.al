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
                  page "Manor API Key ori" = X,
                  codeunit "Manor Create Mgt ori" = X,
                  codeunit "Manor Time Create Impl ori" = X,
                  codeunit "Manor Expense Create Impl ori" = X,
                  codeunit "Manor Product Create Impl ori" = X,
                  codeunit "Manor Client Create Impl ori" = X,
                  codeunit "Manor Client Update Impl ori" = X,
                  codeunit "Manor Project Create Impl ori" = X,
                  codeunit "Manor Project Update Impl ori" = X,
                  codeunit "Manor Activity Create Impl ori" = X,
                  codeunit "Manor Activity Update Impl ori" = X,
                  codeunit "Manor Write Handler ori" = X,
                  codeunit "Manor Contract Parts ori" = X;
}
