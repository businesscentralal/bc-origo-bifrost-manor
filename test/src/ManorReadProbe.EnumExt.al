namespace Origo.Bifrost.Manor.Test;

using Origo.Bifrost;

/// <summary>Test-app-only fixture for invoking the five approved read types over MCP in one seeded session.</summary>
enumextension 98231 "Manor Read Probe Type ori" extends "Message Type ori"
{
    value(98232; "Test.Manor.Read.Probe")
    {
        Caption = 'Test.Manor.Read.Probe', Locked = true;
        Implementation = "Msg Interface ori" = "Manor Read Probe ori";
    }
}
