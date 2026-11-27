namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Registers the six Manor write message types.</summary>
enumextension 10035677 "Manor Message Type ori" extends "Message Type ori"
{
    /// <summary>Creates a Manor client (POST /client). Refuses a duplicate national_id and names the existing client id.</summary>
    value(10035671; "Manor.Client.Create")
    {
        Caption = 'Manor.Client.Create', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Client Create Impl ori", "Msg Discovery ori" = "Manor Client Create Impl ori", "Msg Contract ori" = "Manor Client Create Impl ori";
    }
    /// <summary>Updates a Manor client (PUT /client/{clientId}). Changing currency_code needs confirmCurrencyChange=true.</summary>
    value(10035672; "Manor.Client.Update")
    {
        Caption = 'Manor.Client.Update', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Client Update Impl ori", "Msg Discovery ori" = "Manor Client Update Impl ori", "Msg Contract ori" = "Manor Client Update Impl ori";
    }
    /// <summary>Creates a Manor project (POST /project). billing is enabled, internal or sensitive.</summary>
    value(10035673; "Manor.Project.Create")
    {
        Caption = 'Manor.Project.Create', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Project Create Impl ori", "Msg Discovery ori" = "Manor Project Create Impl ori", "Msg Contract ori" = "Manor Project Create Impl ori";
    }
    /// <summary>Updates a Manor project (PUT /project/{projectId}). open=false closes the project and blocks all new entries; open=true reopens it.</summary>
    value(10035674; "Manor.Project.Update")
    {
        Caption = 'Manor.Project.Update', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Project Update Impl ori", "Msg Discovery ori" = "Manor Project Update Impl ori", "Msg Contract ori" = "Manor Project Update Impl ori";
    }
    /// <summary>Creates an activity (work item) in a Manor project (POST /project/{projectId}/activity).</summary>
    value(10035675; "Manor.Activity.Create")
    {
        Caption = 'Manor.Activity.Create', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Activity Create Impl ori", "Msg Discovery ori" = "Manor Activity Create Impl ori", "Msg Contract ori" = "Manor Activity Create Impl ori";
    }
    /// <summary>Updates an activity (work item) in a Manor project (PUT /project/{projectId}/activity/{activityId}).</summary>
    value(10035676; "Manor.Activity.Update")
    {
        Caption = 'Manor.Activity.Update', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Activity Update Impl ori", "Msg Discovery ori" = "Manor Activity Update Impl ori", "Msg Contract ori" = "Manor Activity Update Impl ori";
    }
}
