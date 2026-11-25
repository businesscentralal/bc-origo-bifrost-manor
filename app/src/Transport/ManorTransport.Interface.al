namespace Origo.Bifrost.Manor;

/// <summary>Environment-specific URL construction and request execution.</summary>
interface "Manor Transport ori"
{
    /// <summary>Builds the base URL for a validated instance segment.</summary>
    procedure BuildBaseUrl(Instance: Text): Text

    /// <summary>Sends a relative request and returns its response. Query excludes the leading question mark.</summary>
    procedure Send(Method: Text; RelativePath: Text; Query: Text; Body: Text; var Response: Codeunit "Manor Response ori"): Boolean
}
