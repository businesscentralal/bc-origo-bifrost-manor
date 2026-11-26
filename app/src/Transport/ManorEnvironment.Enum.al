namespace Origo.Bifrost.Manor;

/// <summary>Selects the transport. New setup defaults to the connection-free mock.</summary>
enum 10035643 "Manor Environment ori" implements "Manor Transport ori"
{
    Extensible = true;
    /// <summary>Uses registered responses without a network connection.</summary>
    value(0; Mock)
    {
        Caption = 'Mock', Comment = 'is-IS=Sýndarumhverfi';
        Implementation = "Manor Transport ori" = "Manor Mock Impl ori";
    }
    /// <summary>Uses the configured production instance.</summary>
    value(1; Production)
    {
        Caption = 'Production', Comment = 'is-IS=Raunumhverfi';
        Implementation = "Manor Transport ori" = "Manor HTTP Impl ori";
    }
    /// <summary>Uses a separate test instance on the same fixed host.</summary>
    value(2; Test)
    {
        Caption = 'Test', Comment = 'is-IS=Prófunarumhverfi';
        Implementation = "Manor Transport ori" = "Manor HTTP Impl ori";
    }
}
