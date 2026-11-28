namespace Origo.Bifrost.Manor;

using Origo.Bifrost;
using System.Reflection;

/// <summary>
/// Implementation of the <c>Manor.Project.Get</c> message type: Reads one Manor project by its id or by its external number (identifier).
/// The call goes through the Manor client only; nothing is written in Business Central or in Manor.
/// </summary>
codeunit 10035664 "Manor Project Get Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;

    var
        DescriptionLbl: Label 'Reads one Manor project by its id or by its external number (identifier).', Comment = 'is-IS=Les eitt verk í Manor eftir auðkenni eða ytra málsnúmeri (identifier).';
        KeywordsLbl: Label 'manor project, get project, project by id, project by identifier, matter by external number, verk', Comment = 'is-IS=manor verk, sækja verk, verk eftir auðkenni, verk eftir ytra númeri, mál eftir ytra málsnúmeri, project';
        SelectionLbl: Label 'Reads one Manor project by projectId or identifier; use Manor.Project.List to search with filters.', Comment = 'is-IS=Les eitt verk í Manor eftir projectId eða identifier; notaðu Manor.Project.List til að leita með síum.';
        NotFoundNextLbl: Label 'Check the project id or external number, or find the project with Manor.Project.List (status all also finds closed projects).', Comment = 'is-IS=Athugaðu auðkenni eða ytra númer verks eða finndu verkið með Manor.Project.List (status all finnur líka lokuð verk).';
        AmbiguousErr: Label '%1 projects have this external number (identifier), and it is not unique in Manor.', Comment = '%1 = number of projects; is-IS=%1 verk hafa þetta ytra númer (identifier) og það er ekki einkvæmt í Manor.';
        AmbiguousNextLbl: Label 'Find the project with Manor.Project.List and read it by projectId.', Comment = 'is-IS=Finndu verkið með Manor.Project.List og lestu það með projectId.';

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
        exit(Parts.GetTarget('Manor.Project.Get', Target));
    end;

    /// <summary>The parameters chapter.</summary>
    /// <param name="Parameters">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetParameters(var Parameters: JsonArray): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Parameters := Parts.GetParameters('Manor.Project.Get');
        exit(true);
    end;

    /// <summary>The response chapter.</summary>
    /// <param name="Response">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetResponse(var Response: JsonObject): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Response := Parts.GetResponse('Manor.Project.Get');
        exit(true);
    end;

    /// <summary>The errors chapter.</summary>
    /// <param name="Errors">Receives the chapter.</param>
    /// <returns>True.</returns>
    procedure GetErrors(var Errors: JsonArray): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Errors := Parts.GetErrors('Manor.Project.Get');
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
        Related := Parts.GetRelated('Manor.Project.Get');
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
        Examples := Parts.GetExamples('Manor.Project.Get');
        exit(Examples.Count() > 0);
    end;

    /// <summary>The overview chapter.</summary>
    /// <param name="Overview">Receives the text.</param>
    /// <returns>True.</returns>
    procedure GetOverview(var Overview: Text): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Overview := Parts.GetOverview('Manor.Project.Get');
        exit(Overview <> '');
    end;

    /// <summary>The notes chapter.</summary>
    /// <param name="Notes">Receives the text.</param>
    /// <returns>True.</returns>
    procedure GetNotes(var Notes: Text): Boolean
    var
        Parts: Codeunit "Manor Read Parts ori";
    begin
        Notes := Parts.GetNotes('Manor.Project.Get');
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
        ProjectId: Text;
        Identifier: Text;
        MatchCount: Integer;
    begin
        Argument.AssertVersion1();
        Argument.AssertIsLicensed();
        RequestJson := Argument.GetRequestJson();
        Mgt.ReadId(Argument, RequestJson, 'projectId', ProjectId);
        Mgt.ReadText(Argument, RequestJson, 'identifier', Identifier);
        Mgt.RequireOne(Argument, ProjectId, 'projectId', Identifier, 'identifier');
        if Mgt.RespondIfInvalid(Argument) then
            exit;
        if ProjectId <> '' then begin
            if not Mgt.Fetch(Argument, 'project/' + ProjectId, '', NotFoundNextLbl, 'projectId', ProjectId, Body) then
                exit;
        end else
            if not Mgt.Fetch(Argument, 'project-by-identifier/' + TypeHelper.UrlEncode(Identifier), '', NotFoundNextLbl, 'identifier', Identifier, Body) then
                exit;
        if not Mgt.ReadItem(Body, Item, MatchCount) then begin
            Mgt.RespondUnexpected(Argument);
            exit;
        end;
        if MatchCount > 1 then begin
            Argument.RespondWithError("Bifrost Error Code ori"::AmbiguousRecord, StrSubstNo(AmbiguousErr, MatchCount), 'identifier', CopyStr(Identifier, 1, 50), '', AmbiguousNextLbl);
            exit;
        end;
        Mgt.RespondItem(Argument, Item, 'project');
    end;
}
