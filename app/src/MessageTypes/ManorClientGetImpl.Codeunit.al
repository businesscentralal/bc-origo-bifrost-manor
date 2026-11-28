namespace Origo.Bifrost.Manor;

using Origo.Bifrost;
using System.Reflection;

/// <summary>
/// Implementation of the <c>Manor.Client.Get</c> message type: Reads one Manor client by its id or by its national id (kennitala).
/// The call goes through the Manor client only; nothing is written in Business Central or in Manor.
/// </summary>
codeunit 10035662 "Manor Client Get Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;

    var
        DescriptionLbl: Label 'Reads one Manor client by its id or by its national id (kennitala).', Comment = 'is-IS=Les einn viðskiptavin í Manor eftir auðkenni eða kennitölu.';
        KeywordsLbl: Label 'manor client, get client, client by id, client by kennitala, client by national id, viðskiptavinur', Comment = 'is-IS=manor viðskiptavinur, sækja viðskiptavin, viðskiptavinur eftir auðkenni, viðskiptavinur eftir kennitölu, viðskiptavinur eftir kennitölu í manor, client';
        SelectionLbl: Label 'Reads one Manor client by clientId or nationalId; use Manor.Client.List to search by name.', Comment = 'is-IS=Les einn viðskiptavin í Manor eftir clientId eða nationalId; notaðu Manor.Client.List til að leita eftir nafni.';
        NotFoundNextLbl: Label 'Check the client id, or find the client with Manor.Client.List.', Comment = 'is-IS=Athugaðu auðkenni viðskiptavinar eða finndu hann með Manor.Client.List.';
        NationalIdNotFoundNextLbl: Label 'A missing national id does not prove the client is missing: foreign clients often have a made-up number. Search by name with Manor.Client.List.', Comment = 'is-IS=Kennitala sem finnst ekki sannar ekki að viðskiptavinurinn sé ekki til: erlendir viðskiptavinir eru oft með tilbúið númer. Leitaðu eftir nafni með Manor.Client.List.';

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
        exit(Parts.GetTarget('Manor.Client.Get', Target));
    end;

    /// <summary>The parameters chapter.</summary>
    /// <param name="Parameters">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetParameters(var Parameters: JsonArray): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Parameters := Parts.GetParameters('Manor.Client.Get');
        exit(true);
    end;

    /// <summary>The response chapter.</summary>
    /// <param name="Response">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetResponse(var Response: JsonObject): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Response := Parts.GetResponse('Manor.Client.Get');
        exit(true);
    end;

    /// <summary>The errors chapter.</summary>
    /// <param name="Errors">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetErrors(var Errors: JsonArray): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Errors := Parts.GetErrors('Manor.Client.Get');
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
        Related := Parts.GetRelated('Manor.Client.Get');
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
        Examples := Parts.GetExamples('Manor.Client.Get');
        exit(Examples.Count() > 0);
    end;

    /// <summary>The overview chapter.</summary>
    /// <param name="Overview">Receives the text.</param>
    /// <returns>True.</returns>
    procedure GetOverview(var Overview: Text): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Overview := Parts.GetOverview('Manor.Client.Get');
        exit(Overview <> '');
    end;

    /// <summary>The notes chapter.</summary>
    /// <param name="Notes">Receives the text.</param>
    /// <returns>True.</returns>
    procedure GetNotes(var Notes: Text): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Notes := Parts.GetNotes('Manor.Client.Get');
        exit(Notes <> '');
    end;

    /// <summary>Runs the call against Manor through the Manor client and answers with the mapped data.</summary>
    /// <param name="Argument">The Bifrost argument that holds the request and receives the response.</param>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        Mgt: Codeunit "Manor Read Mgt ori";
        TypeHelper: Codeunit "Type Helper";
        RequestJson: JsonObject;
        Item: JsonObject;
        Body: Text;
        ClientId: Text;
        NationalId: Text;
        MatchCount: Integer;
    begin
        Argument.AssertVersion1();
        Argument.AssertIsLicensed();
        RequestJson := Argument.GetRequestJson();
        Mgt.ReadId(Argument, RequestJson, 'clientId', ClientId);
        Mgt.ReadText(Argument, RequestJson, 'nationalId', NationalId);
        Mgt.RequireOne(Argument, ClientId, 'clientId', NationalId, 'nationalId');
        if Mgt.RespondIfInvalid(Argument) then
            exit;
        if ClientId <> '' then begin
            if not Mgt.Fetch(Argument, 'client/' + ClientId, '', NotFoundNextLbl, 'clientId', ClientId, Body) then
                exit;
        end else
            if not Mgt.Fetch(Argument, 'client-by-national-id/' + TypeHelper.UrlEncode(NationalId), '', NationalIdNotFoundNextLbl, 'nationalId', NationalId, Body) then
                exit;
        if not Mgt.ReadItem(Body, Item, MatchCount) then begin
            Mgt.RespondUnexpected(Argument);
            exit;
        end;
        Mgt.RespondItem(Argument, Item, 'client');
    end;
}
