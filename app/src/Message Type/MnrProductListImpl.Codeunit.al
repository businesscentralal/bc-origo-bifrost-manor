namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Executes and documents Manor.Product.List.</summary>
codeunit 10035667 "Mnr Product List Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;

    /// <summary>IsEnabled: message execution or contract chapter.</summary>
    procedure IsEnabled(): Boolean
    begin
        exit(true);
    end;

    /// <summary>GetFilterTableNo: message execution or contract chapter.</summary>
    procedure GetFilterTableNo(): Integer
    begin
        exit(0);
    end;

    /// <summary>GetDescription: message execution or contract chapter.</summary>
    procedure GetDescription(): Text[250]
    var
        DescriptionLbl: Label 'Lists products for one project. Requires the Manor permission manage_products.', Comment = 'is-IS=Sýnir vörur eins verks. Krefst heimildarinnar manage_products í Manor.';
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>GetKeywords: message execution or contract chapter.</summary>
    procedure GetKeywords(): Text
    var
        KeywordsLbl: Label 'products, special price, billable quantity', Comment = 'is-IS=vörur, sérverð, magn til greiðslu';
    begin
        exit(KeywordsLbl);
    end;

    /// <summary>GetSelectionDescription: message execution or contract chapter.</summary>
    procedure GetSelectionDescription(): Text
    begin
        exit(GetDescription());
    end;

    /// <summary>GetMessageDirection: message execution or contract chapter.</summary>
    procedure GetMessageDirection(): Enum "Msg Direction ori"
    begin
        exit("Msg Direction ori"::Outbound);
    end;

    /// <summary>Validates and executes this read through the registered interface.</summary>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        ReadMgt: Codeunit "Mnr Time List Impl ori";
        QueryBuilder: Codeunit "Manor Query Builder ori";
        Request: JsonObject;
        AllowedParameters: Text;
        Path: Text;
    begin
        Argument.AssertIsLicensed();
        Argument.AssertVersion1();
        Request := Argument.GetRequestJson();
        AllowedParameters := ',projectId,perPage,maxPages,';
        ReadMgt.ValidateKeys(Request, AllowedParameters);
        Path := '/project/' + Format(ReadMgt.ReadInteger(Request, 'projectId', true, 1, 2147483647, 0), 0, 9) + '/product';
        ReadMgt.ReadList(Request, Argument, Path, QueryBuilder, false, '');
    end;

    /// <summary>GetEnvelope: message execution or contract chapter.</summary>
    procedure GetEnvelope(var Envelope: JsonObject): Boolean
    begin
        Envelope.ReadFrom('{"subject":{"use":"notUsed"},"dataRequired":true,"version":"1.0","contentType":"application/json"}');
        exit(true);
    end;

    /// <summary>GetTarget: message execution or contract chapter.</summary>
    procedure GetTarget(var Target: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Declares the parameters read by this type.</summary>
    procedure GetParameters(var Parameters: JsonArray): Boolean
    var
        ReadMgt: Codeunit "Mnr Time List Impl ori";
    begin
        Parameters.Add(ReadMgt.Parameter('projectId', 'integer', true, ReadMgt.ParameterDescription('projectId', false)));
        Parameters.Add(ReadMgt.Parameter('perPage', 'integer', false, ReadMgt.ParameterDescription('perPage', false)));
        Parameters.Add(ReadMgt.Parameter('maxPages', 'integer', false, ReadMgt.ParameterDescription('maxPages', false)));
        exit(true);
    end;

    /// <summary>GetResponse: message execution or contract chapter.</summary>
    procedure GetResponse(var Response: JsonObject): Boolean
    var
        ReadMgt: Codeunit "Mnr Time List Impl ori";
    begin
        ReadMgt.SharedResponse(2, Response);
        exit(true);
    end;

    /// <summary>GetErrors: message execution or contract chapter.</summary>
    procedure GetErrors(var Errors: JsonArray): Boolean
    var
        ReadMgt: Codeunit "Mnr Time List Impl ori";
    begin
        ReadMgt.SharedErrors(Errors);
        exit(true);
    end;

    /// <summary>GetEffect: message execution or contract chapter.</summary>
    procedure GetEffect(var Effect: JsonObject): Boolean
    begin
        Effect.ReadFrom('{"effect":"read","idempotent":true,"permissionSet":"BIFROST MnrRead ori"}');
        exit(true);
    end;

    /// <summary>GetMetering: message execution or contract chapter.</summary>
    procedure GetMetering(var Metering: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetRelated: message execution or contract chapter.</summary>
    procedure GetRelated(var Related: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetWorkflow: message execution or contract chapter.</summary>
    procedure GetWorkflow(var Workflow: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetExamples: message execution or contract chapter.</summary>
    procedure GetExamples(var Examples: JsonArray): Boolean
    var
        Example: JsonObject;
    begin
        Example.ReadFrom('{"title":"Manor.Product.List","request":{"type":"Manor.Product.List","data":{"projectId":42}},"response":{"status":"Success","data":[],"count":0}}');
        Examples.Add(Example);
        exit(true);
    end;

    /// <summary>GetOverview: message execution or contract chapter.</summary>
    procedure GetOverview(var Overview: Text): Boolean
    begin
        Overview := GetDescription();
        exit(true);
    end;

    /// <summary>GetNotes: message execution or contract chapter.</summary>
    procedure GetNotes(var Notes: Text): Boolean
    var
        ReadMgt: Codeunit "Mnr Time List Impl ori";
    begin
        Notes := ReadMgt.SharedNotes(2);
        exit(true);
    end;

}
