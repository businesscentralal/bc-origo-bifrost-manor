namespace Origo.Bifrost.Manor;

/// <summary>
/// Read-only Bifrost Manor role. In the scaffold it grants registration only; read message types add their grants here.
/// </summary>
permissionset 10035638 "BIFROST MnrRead ori"
{
    Assignable = true;
    Access = Public;
    Caption = 'Bifrost Manor Read', MaxLength = 30, Comment = 'is-IS=Bifröst - Manor (lestur)';
    IncludedPermissionSets = "BIFROST Manor ori";
}
