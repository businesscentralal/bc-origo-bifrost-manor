namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>
/// Includes the matching Bifrost Manor permissions in the Foundation Read role.
/// </summary>
permissionsetextension 10035640 "Manor Read Role ori" extends "BIFROST Read ori"
{
    IncludedPermissionSets = "BIFROST MnrRead ori";
}
