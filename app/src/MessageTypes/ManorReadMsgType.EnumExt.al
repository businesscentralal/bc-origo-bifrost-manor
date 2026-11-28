namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>
/// Adds the Manor read message types for clients, projects and activities to Foundation's <c>Message Type ori</c> enum.
/// Captions are locked because message type names are part of the public wire contract.
/// </summary>
enumextension 10035680 "Manor Read Msg Type ori" extends "Message Type ori"
{
    /// <summary>Lists Manor clients, one page at a time.</summary>
    value(10035661; "Manor.Client.List")
    {
        Caption = 'Manor.Client.List', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Client List Impl ori", "Msg Discovery ori" = "Manor Client List Impl ori", "Msg Contract ori" = "Manor Client List Impl ori";
    }
    /// <summary>Reads one Manor client by id or national id.</summary>
    value(10035662; "Manor.Client.Get")
    {
        Caption = 'Manor.Client.Get', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Client Get Impl ori", "Msg Discovery ori" = "Manor Client Get Impl ori", "Msg Contract ori" = "Manor Client Get Impl ori";
    }
    /// <summary>Lists Manor projects, open projects by default.</summary>
    value(10035663; "Manor.Project.List")
    {
        Caption = 'Manor.Project.List', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Project List Impl ori", "Msg Discovery ori" = "Manor Project List Impl ori", "Msg Contract ori" = "Manor Project List Impl ori";
    }
    /// <summary>Reads one Manor project by id or external number.</summary>
    value(10035664; "Manor.Project.Get")
    {
        Caption = 'Manor.Project.Get', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Project Get Impl ori", "Msg Discovery ori" = "Manor Project Get Impl ori", "Msg Contract ori" = "Manor Project Get Impl ori";
    }
    /// <summary>Lists the activities (work items) of a Manor project.</summary>
    value(10035665; "Manor.Activity.List")
    {
        Caption = 'Manor.Activity.List', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Activity List Impl ori", "Msg Discovery ori" = "Manor Activity List Impl ori", "Msg Contract ori" = "Manor Activity List Impl ori";
    }
}
