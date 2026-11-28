namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Registers the approved Manor v1 read message types.</summary>
enumextension 10035655 "Manor Message Type ori" extends "Message Type ori"
{
    /// <summary>Tests the Manor connection; a successful ping does not prove resource permissions.</summary>
    value(10035656; "Manor.Connection.Test")
    {
        Caption = 'Manor.Connection.Test', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Connection Test Impl ori", "Msg Discovery ori" = "Manor Connection Test Impl ori", "Msg Contract ori" = "Manor Connection Test Impl ori";
    }
    /// <summary>Lists issuing firms and their default currency, VAT rate and Peppol identifier.</summary>
    value(10035657; "Manor.Firm.List")
    {
        Caption = 'Manor.Firm.List', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Firm List Impl ori", "Msg Discovery ori" = "Manor Firm List Impl ori", "Msg Contract ori" = "Manor Firm List Impl ori";
    }
    /// <summary>Lists Manor employees, optionally filtered by permissions and enabled status.</summary>
    value(10035658; "Manor.User.List")
    {
        Caption = 'Manor.User.List', Locked = true;
        Implementation = "Msg Interface ori" = "Manor User List Impl ori", "Msg Discovery ori" = "Manor User List Impl ori", "Msg Contract ori" = "Manor User List Impl ori";
    }
    /// <summary>Reads one Manor employee by user ID or email address.</summary>
    value(10035659; "Manor.User.Get")
    {
        Caption = 'Manor.User.Get', Locked = true;
        Implementation = "Msg Interface ori" = "Manor User Get Impl ori", "Msg Discovery ori" = "Manor User Get Impl ori", "Msg Contract ori" = "Manor User Get Impl ori";
    }
    /// <summary>Lists Manor rates; prices exclude client and project special terms.</summary>
    value(10035660; "Manor.Rate.List")
    {
        Caption = 'Manor.Rate.List', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Rate List Impl ori", "Msg Discovery ori" = "Manor Rate List Impl ori", "Msg Contract ori" = "Manor Rate List Impl ori";
    }
}
