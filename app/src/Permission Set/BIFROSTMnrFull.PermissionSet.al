namespace Origo.Bifrost.Manor;

/// <summary>
/// Full Bifrost Manor role. In the scaffold it grants registration only; write message types add their grants here.
/// </summary>
permissionset 10035637 "BIFROST MnrFull ori"
{
    Assignable = true;
    Access = Public;
    Caption = 'Bifrost Manor Full', MaxLength = 30, Comment = 'is-IS=Bifröst - Manor (fullt)';
    IncludedPermissionSets = "BIFROST Manor ori";
}
