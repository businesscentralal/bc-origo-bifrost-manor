namespace Origo.Bifrost.Manor.Test;

/// <summary>Disposable exact-route mock fixtures for MCP tests. No credentials or external calls.</summary>
table 98251 "Manor Read Fixture ori"
{
    DataClassification = CustomerContent;
    Caption = 'Manor read fixture', Locked = true;
    fields
    {
        field(1; Method; Code[10])
        {
            Caption = 'Method', Locked = true;
        }
        field(2; Path; Text[100])
        {
            Caption = 'Path', Locked = true;
        }
        field(3; Query; Text[250])
        {
            Caption = 'Query', Locked = true;
        }
        field(4; StatusCode; Integer)
        {
            Caption = 'Status code', Locked = true;
        }
        field(5; Body; Text[2048])
        {
            Caption = 'Body', Locked = true;
        }
    }
    keys
    {
        key(PK; Method, Path, Query)
        {
            Clustered = true;
        }
    }
}
