namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Registers the five approved read message types.</summary>
enumextension 10035666 "Manor Read Types ori" extends "Message Type ori"
{
    /// <summary>Manor.TimeEntry.List.</summary>
    value(10035666; "Manor.TimeEntry.List")
    {
        Caption = 'Manor.TimeEntry.List', Locked = true, Comment = 'is-IS=Manor.TimeEntry.List';
        Implementation = "Msg Interface ori" = "Mnr Time List Impl ori", "Msg Discovery ori" = "Mnr Time List Impl ori", "Msg Contract ori" = "Mnr Time List Impl ori";
    }
    /// <summary>Manor.Product.List.</summary>
    value(10035667; "Manor.Product.List")
    {
        Caption = 'Manor.Product.List', Locked = true, Comment = 'is-IS=Manor.Product.List';
        Implementation = "Msg Interface ori" = "Mnr Product List Impl ori", "Msg Discovery ori" = "Mnr Product List Impl ori", "Msg Contract ori" = "Mnr Product List Impl ori";
    }
    /// <summary>Manor.Invoice.List.</summary>
    value(10035668; "Manor.Invoice.List")
    {
        Caption = 'Manor.Invoice.List', Locked = true, Comment = 'is-IS=Manor.Invoice.List';
        Implementation = "Msg Interface ori" = "Mnr Invoice List Impl ori", "Msg Discovery ori" = "Mnr Invoice List Impl ori", "Msg Contract ori" = "Mnr Invoice List Impl ori";
    }
    /// <summary>Manor.Invoice.Get.</summary>
    value(10035669; "Manor.Invoice.Get")
    {
        Caption = 'Manor.Invoice.Get', Locked = true, Comment = 'is-IS=Manor.Invoice.Get';
        Implementation = "Msg Interface ori" = "Mnr Invoice Get Impl ori", "Msg Discovery ori" = "Mnr Invoice Get Impl ori", "Msg Contract ori" = "Mnr Invoice Get Impl ori";
    }
    /// <summary>Manor.InboundInvoice.List.</summary>
    value(10035670; "Manor.InboundInvoice.List")
    {
        Caption = 'Manor.InboundInvoice.List', Locked = true, Comment = 'is-IS=Manor.InboundInvoice.List';
        Implementation = "Msg Interface ori" = "Mnr Inbound List Impl ori", "Msg Discovery ori" = "Mnr Inbound List Impl ori", "Msg Contract ori" = "Mnr Inbound List Impl ori";
    }
}
