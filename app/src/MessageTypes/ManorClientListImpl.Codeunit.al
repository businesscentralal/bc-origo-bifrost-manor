namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>
/// Implementation of the <c>Manor.Client.List</c> message type: Lists Manor clients one page at a time, optionally only those changed since a time.
/// The call goes through the Manor client only; nothing is written in Business Central or in Manor.
/// </summary>
codeunit 10035661 "Manor Client List Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;

    var
        DescriptionLbl: Label 'Lists Manor clients one page at a time, optionally only those changed since a time.', Comment = 'is-IS=Listar viðskiptavini í Manor eina blaðsíðu í einu, ef vill aðeins þá sem breyttust eftir ákveðinn tíma.';
        KeywordsLbl: Label 'manor clients, list clients, find client, customers in manor, clients changed since, viðskiptavinir', Comment = 'is-IS=manor viðskiptavinir, lista viðskiptavini, finna viðskiptavin, viðskiptavinir í manor, breyttir viðskiptavinir, customers';
        SelectionLbl: Label 'Lists Manor clients page by page; use Manor.Client.Get to read one client by id or national id.', Comment = 'is-IS=Listar viðskiptavini í Manor eftir blaðsíðum; notaðu Manor.Client.Get til að lesa einn viðskiptavin eftir auðkenni eða kennitölu.';

    /// <summary>Whether the caller may read the Manor setup this type depends on.</summary>
    /// <returns>True when the Manor setup is readable.</returns>
    procedure IsEnabled(): Boolean
    var
        Setup: Record "Manor Setup ori";
    begin
        exit(Setup.ReadPermission());
    end;

    /// <summary>The type has no filter table.</summary>
    /// <returns>0.</returns>
    procedure GetFilterTableNo(): Integer
    begin
        exit(0);
    end;

    /// <summary>The description shown in the message type catalogue.</summary>
    /// <returns>The description.</returns>
    procedure GetDescription(): Text[250]
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Search terms for ranking, English with the Icelandic translation.</summary>
    /// <returns>Comma-separated keywords.</returns>
    procedure GetKeywords(): Text
    begin
        exit(KeywordsLbl);
    end;

    /// <summary>What separates this type from its siblings.</summary>
    /// <returns>One sentence.</returns>
    procedure GetSelectionDescription(): Text
    begin
        exit(SelectionLbl);
    end;

    /// <summary>Reads data out of Manor.</summary>
    /// <returns>Outbound.</returns>
    procedure GetMessageDirection(): Enum "Msg Direction ori"
    begin
        exit(Enum::"Msg Direction ori"::Outbound);
    end;

    /// <summary>The envelope chapter.</summary>
    /// <param name="Envelope">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetEnvelope(var Envelope: JsonObject): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Envelope := Parts.GetEnvelope(false);
        exit(true);
    end;

    /// <summary>The target chapter.</summary>
    /// <param name="Target">Receives the chapter.</param>
    /// <returns>True when the type has a target.</returns>
    procedure GetTarget(var Target: JsonArray): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        exit(Parts.GetTarget('Manor.Client.List', Target));
    end;

    /// <summary>The parameters chapter.</summary>
    /// <param name="Parameters">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetParameters(var Parameters: JsonArray): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Parameters := Parts.GetParameters('Manor.Client.List');
        exit(true);
    end;

    /// <summary>The response chapter.</summary>
    /// <param name="Response">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetResponse(var Response: JsonObject): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Response := Parts.GetResponse('Manor.Client.List');
        exit(true);
    end;

    /// <summary>The errors chapter.</summary>
    /// <param name="Errors">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetErrors(var Errors: JsonArray): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Errors := Parts.GetErrors('Manor.Client.List');
        exit(true);
    end;

    /// <summary>The effect chapter: a read.</summary>
    /// <param name="Effect">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetEffect(var Effect: JsonObject): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Effect := Parts.GetEffect();
        exit(true);
    end;

    /// <summary>No metering chapter.</summary>
    /// <param name="Metering">Unused.</param>
    /// <returns>False.</returns>
    procedure GetMetering(var Metering: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>The related chapter.</summary>
    /// <param name="Related">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetRelated(var Related: JsonArray): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Related := Parts.GetRelated('Manor.Client.List');
        exit(true);
    end;

    /// <summary>No workflow chapter.</summary>
    /// <param name="Workflow">Unused.</param>
    /// <returns>False.</returns>
    procedure GetWorkflow(var Workflow: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>The examples chapter.</summary>
    /// <param name="Examples">Receives the chapter.</param>
    /// <returns>True when there are examples.</returns>
    procedure GetExamples(var Examples: JsonArray): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Examples := Parts.GetExamples('Manor.Client.List');
        exit(Examples.Count() > 0);
    end;

    /// <summary>The overview chapter.</summary>
    /// <param name="Overview">Receives the text.</param>
    /// <returns>True.</returns>
    procedure GetOverview(var Overview: Text): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Overview := Parts.GetOverview('Manor.Client.List');
        exit(Overview <> '');
    end;

    /// <summary>The notes chapter.</summary>
    /// <param name="Notes">Receives the text.</param>
    /// <returns>True.</returns>
    procedure GetNotes(var Notes: Text): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Notes := Parts.GetNotes('Manor.Client.List');
        exit(Notes <> '');
    end;

    /// <summary>Runs the call against Manor through the Manor client and answers with the mapped data.</summary>
    /// <param name="Argument">The Bifrost argument that holds the request and receives the response.</param>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        Mgt: Codeunit "Manor Read Mgt ori";
        Query: Codeunit "Manor Query Builder ori";
        RequestJson: JsonObject;
        Body: Text;
        Page: Integer;
        PerPage: Integer;
    begin
        Argument.AssertVersion1();
        Argument.AssertIsLicensed();
        RequestJson := Argument.GetRequestJson();
        Mgt.ReadUpdatedSince(Argument, RequestJson, Query);
        Mgt.ReadPaging(Argument, RequestJson, Query, Page, PerPage);
        if Mgt.RespondIfInvalid(Argument) then
            exit;
        if not Mgt.Fetch(Argument, 'client', Query.Build(), '', '', '', Body) then
            exit;
        Mgt.RespondList(Argument, Body, 'clients', Page, PerPage);
    end;
}
