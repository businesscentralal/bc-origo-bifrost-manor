namespace Origo.Bifrost.Manor;

using System.Reflection;

/// <summary>Builds a URL query string with encoded values and culture-invariant ISO 8601 dates and times.</summary>
codeunit 10035653 "Manor Query Builder ori"
{
    Access = Public;

    var
        Parts: List of [Text];

    /// <summary>Adds a text parameter; the value is URL-encoded. Empty values are skipped.</summary>
    /// <param name="ParamName">The parameter name, for example updated_since.</param>
    /// <param name="Value">The unencoded value.</param>
    procedure Add(ParamName: Text; Value: Text)
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        if (ParamName = '') or (Value = '') then
            exit;
        Parts.Add(TypeHelper.UrlEncode(ParamName) + '=' + TypeHelper.UrlEncode(Value));
    end;

    /// <summary>Adds an integer parameter.</summary>
    /// <param name="ParamName">The parameter name.</param>
    /// <param name="Value">The value, formatted without thousands separators.</param>
    procedure Add(ParamName: Text; Value: Integer)
    begin
        Add(ParamName, Format(Value, 0, 9));
    end;

    /// <summary>Adds a boolean parameter as true or false.</summary>
    /// <param name="ParamName">The parameter name.</param>
    /// <param name="Value">The value.</param>
    procedure Add(ParamName: Text; Value: Boolean)
    begin
        Add(ParamName, Format(Value, 0, 9));
    end;

    /// <summary>Adds a date parameter as ISO 8601 (yyyy-mm-dd) regardless of the user language.</summary>
    /// <param name="ParamName">The parameter name.</param>
    /// <param name="Value">The date; a blank date is skipped.</param>
    procedure Add(ParamName: Text; Value: Date)
    begin
        if Value <> 0D then
            Add(ParamName, Format(Value, 0, 9));
    end;

    /// <summary>Adds a date-time parameter as ISO 8601 UTC regardless of the user language.</summary>
    /// <param name="ParamName">The parameter name.</param>
    /// <param name="Value">The date-time; a blank value is skipped.</param>
    procedure Add(ParamName: Text; Value: DateTime)
    begin
        if Value <> 0DT then
            Add(ParamName, Format(Value, 0, 9));
    end;

    /// <summary>Returns the query string without a leading question mark.</summary>
    /// <returns>The joined name=value pairs.</returns>
    procedure Build(): Text
    var
        Result: Text;
        Part: Text;
    begin
        foreach Part in Parts do begin
            if Result <> '' then
                Result += '&';
            Result += Part;
        end;
        exit(Result);
    end;

    /// <summary>Removes all parameters.</summary>
    procedure Reset()
    begin
        Clear(Parts);
    end;
}
