namespace Origo.Bifrost.Manor.Test;

using System.Environment.Configuration;

/// <summary>
/// Supplies only platform reads for the restricted setup-page regression.
/// Product execute and administrator permissions must come from the real product roles.
/// </summary>
permissionset 98201 "Manor Setup Test ori"
{
    Assignable = true;
    Caption = 'Setup test platform', Locked = true;
    IncludedPermissionSets = "Guided Experience - View";
    Permissions = tabledata "NAV App Setting" = r;
}
