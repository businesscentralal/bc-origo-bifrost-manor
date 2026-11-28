namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Registers the three Manor creates approved by Gunnar on 25 November 2026.</summary>
enumextension 10035683 "Manor Message Types ori" extends "Message Type ori"
{
    value(10035677; "Manor.TimeEntry.Create")
    {
        Caption = 'Manor.TimeEntry.Create', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Time Create Impl ori", "Msg Discovery ori" = "Manor Time Create Impl ori", "Msg Contract ori" = "Manor Time Create Impl ori";
    }
    value(10035678; "Manor.Expense.Create")
    {
        Caption = 'Manor.Expense.Create', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Expense Create Impl ori", "Msg Discovery ori" = "Manor Expense Create Impl ori", "Msg Contract ori" = "Manor Expense Create Impl ori";
    }
    value(10035679; "Manor.Product.Create")
    {
        Caption = 'Manor.Product.Create', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Product Create Impl ori", "Msg Discovery ori" = "Manor Product Create Impl ori", "Msg Contract ori" = "Manor Product Create Impl ori";
    }
}
