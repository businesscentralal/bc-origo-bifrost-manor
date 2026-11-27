namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost;
using System.Environment.Configuration;
using System.TestLibraries.Security.AccessControl;
using System.TestLibraries.Utilities;

/// <summary>
/// Supplies platform reads and execute on test codeunits and libraries for the restricted tests.
/// Product execute and administrator permissions must come from the real product roles.
/// </summary>
permissionset 98201 "Manor Setup Test ori"
{
    Assignable = true;
    Caption = 'Setup test platform', Locked = true;
    IncludedPermissionSets = "Guided Experience - View";
    Permissions =
        tabledata "NAV App Setting" = r,
        tabledata "Setup ori" = R,
        codeunit "Manor Setup Tst ori" = X,
        codeunit "Manor Scaffold Tst ori" = X,
        codeunit "Manor Client Tst ori" = X,
        codeunit "Manor Write Tst ori" = X,
        codeunit "Msg Contract Mgt ori" = X,
        codeunit "Library Assert" = X,
        codeunit "Library - Lower Permissions" = X,
        codeunit "Permissions Mock" = X;
}
