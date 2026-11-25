namespace Origo.Bifrost.Manor;

/// <summary>
/// Grants Bifrost Manor scaffold execution without access to external data sources.
/// Message types add their own permissions here as they are built.
/// </summary>
permissionset 10035636 "BIFROST Manor ori"
{
    Assignable = true;
    Access = Public;
    Caption = 'Bifrost Manor', MaxLength = 30, Comment = 'is-IS=Bifröst - Manor';
    Permissions = codeunit "Manor Registration ori" = X;
}
