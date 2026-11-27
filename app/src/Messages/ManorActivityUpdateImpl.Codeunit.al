namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Updates an activity (work item) in a Manor project (PUT /project/{projectId}/activity/{activityId}).</summary>
codeunit 10035676 "Manor Activity Update Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;

    var
        Contracts: Codeunit "Manor Contract Parts ori";
        DescriptionLbl: Label 'Updates an activity (work item) in a Manor project (PUT /project/{projectId}/activity/{activityId}).', MaxLength = 250, Comment = 'is-IS=Uppfærir verkþátt í verkefni í Manor (PUT /project/{projectId}/activity/{activityId}).';

    /// <summary>Reports availability.</summary>
    procedure IsEnabled(): Boolean
    begin
        exit(true);
    end;

    /// <summary>No Foundation record filter is used.</summary>
    procedure GetFilterTableNo(): Integer
    begin
        exit(0);
    end;

    /// <summary>Returns localized help.</summary>
    procedure GetDescription(): Text[250]
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Declares the write direction.</summary>
    procedure GetMessageDirection(): Enum "Msg Direction ori"
    begin
        exit(Enum::"Msg Direction ori"::Inbound);
    end;

    /// <summary>Returns localized search text.</summary>
    procedure GetKeywords(): Text
    var
        KeywordsLbl: Label 'update Manor activity, change work item, close activity, activity budget', Comment = 'is-IS=uppfæra verkþátt í Manor, breyta verkþætti, loka verkþætti, fjárhagsáætlun verkþáttar';
    begin
        exit(KeywordsLbl);
    end;

    /// <summary>Returns localized selection help.</summary>
    procedure GetSelectionDescription(): Text
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>Runs the licensed request through the shared write handler.</summary>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        Handler: Codeunit "Manor Write Handler ori";
    begin
        Argument.AssertIsLicensed();
        Argument.AssertVersion1();
        Handler.Execute(Enum::"Message Type ori"::"Manor.Activity.Update", Argument);
    end;

    /// <summary>Returns the envelope contract chapter.</summary>
    procedure GetEnvelope(var Envelope: JsonObject): Boolean
    begin
        Envelope := Contracts.Envelope(Enum::"Message Type ori"::"Manor.Activity.Update");
        exit(true);
    end;

    /// <summary>Returns the target contract chapter.</summary>
    procedure GetTarget(var Target: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Returns the parameters contract chapter.</summary>
    procedure GetParameters(var Parameters: JsonArray): Boolean
    begin
        Parameters := Contracts.Parameters(Enum::"Message Type ori"::"Manor.Activity.Update");
        exit(true);
    end;

    /// <summary>Returns the response contract chapter.</summary>
    procedure GetResponse(var Response: JsonObject): Boolean
    begin
        Response := Contracts.Response(Enum::"Message Type ori"::"Manor.Activity.Update");
        exit(true);
    end;

    /// <summary>Returns the errors contract chapter.</summary>
    procedure GetErrors(var Errors: JsonArray): Boolean
    begin
        Errors := Contracts.Errors(Enum::"Message Type ori"::"Manor.Activity.Update");
        exit(true);
    end;

    /// <summary>Returns the effect contract chapter.</summary>
    procedure GetEffect(var Effect: JsonObject): Boolean
    begin
        Effect := Contracts.Effect(Enum::"Message Type ori"::"Manor.Activity.Update");
        exit(true);
    end;

    /// <summary>Returns the metering contract chapter.</summary>
    procedure GetMetering(var Metering: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Returns the related contract chapter.</summary>
    procedure GetRelated(var Related: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>Returns the workflow contract chapter.</summary>
    procedure GetWorkflow(var Workflow: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>Returns the examples contract chapter.</summary>
    procedure GetExamples(var Examples: JsonArray): Boolean
    begin
        Examples := Contracts.Examples(Enum::"Message Type ori"::"Manor.Activity.Update");
        exit(true);
    end;

    /// <summary>Returns the overview contract chapter.</summary>
    procedure GetOverview(var Overview: Text): Boolean
    begin
        Overview := DescriptionLbl;
        exit(true);
    end;

    /// <summary>Returns the notes contract chapter.</summary>
    procedure GetNotes(var Notes: Text): Boolean
    begin
        Notes := Contracts.Notes();
        exit(true);
    end;
}
