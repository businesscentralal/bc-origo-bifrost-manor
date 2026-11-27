namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Create a Manor time entry. Implements execution, bilingual discovery and the contract chapters.</summary>
codeunit 10035677 "Manor Time Create Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;

    var
        DescriptionTxt: Label 'Create a Manor time entry.', Comment = 'is-IS=Stofna tímafærslu í Manor.';
        KeywordsTxt: Label 'Manor, create, billable, dry run', Comment = 'is-IS=Manor, stofna, reikningsfærsla, prufukeyrsla';
        NotesTxt: Label 'Requires set_alternative_user_of_times. expectedCount is always 1. No project/user pre-reads. Creates cannot be undone through Bifrost; correct them in Manor before invoicing. Closed projects are rejected by Manor. Mileage is not supported. Creates are not retried automatically.', Comment = 'is-IS=Krefst set_alternative_user_of_times. expectedCount er alltaf 1. Verk og notendur eru ekki lesin fyrirfram. Ekki er hægt að afturkalla stofnun í Bifröst; leiðréttu í Manor fyrir reikningsfærslu. Manor hafnar lokuðum verkum. Akstur er ekki studdur. Stofnun er ekki endurreynd sjálfkrafa.';
        ResponseTxt: Label 'One canonical Manor resource in result; noOfRecords=1. A dry run has dryRun=true, noOfRecords=0, empty result, method, path and the exact payload.', Comment = 'is-IS=Ein færsla með staðlaðum Manor-reitum í result; noOfRecords=1. Prufukeyrsla hefur dryRun=true, noOfRecords=0, tómt result, method, path og nákvæm payload-gögn.';
        ErrorTxt: Label 'Invalid input or expectedCount; 401/403 includes the required permission, 404 means missing resource, 422 means Manor rejected the data. Provider text is not echoed.', Comment = 'is-IS=Ógild gögn eða expectedCount; 401/403 nefnir nauðsynlega heimild, 404 merkir að gögn vanti, 422 merkir að Manor hafnaði gögnunum. Texti þjónustuveitanda er ekki endurbirtur.';
        FixTxt: Label 'Correct the parameter, permission or Manor data. Inspect Manor before retrying a failed create.', Comment = 'is-IS=Leiðréttu færibreytu, heimild eða gögn í Manor. Athugaðu Manor áður en misheppnuð stofnun er reynd aftur.';
        Parameter0Txt: Label 'Manor project ID; no project or user pre-read.', Comment = 'is-IS=Auðkenni verks í Manor; verk og notendur eru ekki lesin fyrirfram.';
        Parameter1Txt: Label 'Must be 1, including dry run; checked before any Manor call.', Comment = 'is-IS=Verður að vera 1, einnig í prufukeyrslu; athugað áður en kallað er á Manor.';
        Parameter2Txt: Label 'Return the exact POST payload without writing to Manor. Default false. Permitted rate or firm reads still run.', Comment = 'is-IS=Skila nákvæmum POST-gögnum án þess að skrifa í Manor. Sjálfgefið false. Heimilaður lestur taxta eða fyrirtækis er samt framkvæmdur.';
        Parameter3Txt: Label 'Description printed on the work report or invoice.', Comment = 'is-IS=Lýsing sem birtist á vinnuskýrslu eða reikningi.';
        Parameter4Txt: Label 'Manor activity ID.', Comment = 'is-IS=Auðkenni verkþáttar í Manor.';
        Parameter5Txt: Label 'ISO 8601 timestamp with a time zone; validation uses UTC.', Comment = 'is-IS=ISO 8601 tímastimpill með tímabelti; sannprófun notar UTC.';
        Parameter6Txt: Label 'Hours worked, greater than zero and at most 24; must not cross midnight UTC. Ending exactly at midnight is allowed.', Comment = 'is-IS=Unnar klukkustundir, stærri en núll og mest 24; má ekki fara yfir miðnætti UTC. Má ljúka nákvæmlega á miðnætti.';
        Parameter7Txt: Label 'Billable hours from zero through hours; omission uses Manor default (hours).', Comment = 'is-IS=Reikningsfærðar klukkustundir frá núlli að hours; sé sleppt notar Manor sjálfgefið hours.';
        Parameter8Txt: Label 'Enabled Manor user ID; Manor checks whether the user is enabled.', Comment = 'is-IS=Auðkenni virks Manor-notanda; Manor kannar hvort notandinn sé virkur.';
        Parameter9Txt: Label 'Time rate ID. Reads /rate pages to find this ID and require type time (manage_rates permission). Omission uses the user/project default. Stops after 100 pages without creating if not found.', Comment = 'is-IS=Auðkenni tímataxta. Les síður frá /rate til að finna auðkennið og krefjast tegundarinnar time (heimild manage_rates). Sé sleppt er sjálfgefinn taxti notanda/verks notaður. Stöðvar án stofnunar eftir 100 síður ef taxti finnst ekki.';
        Parameter10Txt: Label 'Internal note, never printed for the client.', Comment = 'is-IS=Innri athugasemd sem birtist aldrei viðskiptavininum.';

    /// <summary>IsEnabled: Create a Manor time entry.</summary>
    procedure IsEnabled(): Boolean
    var
        CreateMgt: Codeunit "Manor Create Mgt ori";
    begin
        exit(CreateMgt.CanWrite());
    end;

    /// <summary>GetFilterTableNo: Create a Manor time entry.</summary>
    procedure GetFilterTableNo(): Integer
    begin
        exit(0);
    end;

    /// <summary>GetDescription: Create a Manor time entry.</summary>
    procedure GetDescription(): Text[250]
    begin
        exit(DescriptionTxt);
    end;

    /// <summary>GetKeywords: Create a Manor time entry.</summary>
    procedure GetKeywords(): Text
    begin
        exit(KeywordsTxt);
    end;

    /// <summary>GetSelectionDescription: Create a Manor time entry.</summary>
    procedure GetSelectionDescription(): Text
    begin
        exit(DescriptionTxt + ' ' + NotesTxt);
    end;

    /// <summary>GetMessageDirection: Create a Manor time entry.</summary>
    procedure GetMessageDirection(): Enum "Msg Direction ori"
    begin
        exit(Enum::"Msg Direction ori"::Inbound);
    end;

    /// <summary>ExecuteBifrostTask: Create a Manor time entry.</summary>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        CreateMgt: Codeunit "Manor Create Mgt ori";
    begin
        CreateMgt.Execute(Argument, 'time', 'set_alternative_user_of_times');
    end;

    /// <summary>GetParameters: Create a Manor time entry.</summary>
    procedure GetParameters(var Parameters: JsonArray): Boolean
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
    begin
        Parameters.Add(ContractMgt.Parameter('projectId', 'integer', true, Parameter0Txt));
        Parameters.Add(ContractMgt.Parameter('expectedCount', 'integer', true, Parameter1Txt));
        Parameters.Add(ContractMgt.Parameter('dryRun', 'boolean', false, Parameter2Txt));
        Parameters.Add(ContractMgt.Parameter('description', 'string', true, Parameter3Txt));
        Parameters.Add(ContractMgt.Parameter('activity_id', 'integer', false, Parameter4Txt));
        Parameters.Add(ContractMgt.Parameter('begins_at', 'string', true, Parameter5Txt));
        Parameters.Add(ContractMgt.Parameter('hours', 'number', true, Parameter6Txt));
        Parameters.Add(ContractMgt.Parameter('billable_hours', 'number', false, Parameter7Txt));
        Parameters.Add(ContractMgt.Parameter('user_id', 'integer', true, Parameter8Txt));
        Parameters.Add(ContractMgt.Parameter('rate_id', 'integer', false, Parameter9Txt));
        Parameters.Add(ContractMgt.Parameter('internal_note', 'string', false, Parameter10Txt));
        exit(true);
    end;

    /// <summary>GetResponse: Create a Manor time entry.</summary>
    procedure GetResponse(var Response: JsonObject): Boolean
    begin
        Response.Add('description', ResponseTxt);
        exit(true);
    end;

    /// <summary>GetErrors: Create a Manor time entry.</summary>
    procedure GetErrors(var Errors: JsonArray): Boolean
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
    begin
        Errors.Add(ContractMgt.ErrorEntry("Bifrost Error Code ori"::InvalidParameter, ErrorTxt, FixTxt));
        exit(true);
    end;

    /// <summary>GetEffect: Create a Manor time entry.</summary>
    procedure GetEffect(var Effect: JsonObject): Boolean
    begin
        Effect.Add('effect', 'write');
        Effect.Add('permissionSet', 'BIFROST MnrFull ori');
        Effect.Add('idempotent', false);
        Effect.Add('changes', NotesTxt);
        exit(true);
    end;

    /// <summary>GetOverview: Create a Manor time entry.</summary>
    procedure GetOverview(var Overview: Text): Boolean
    begin
        Overview := DescriptionTxt;
        exit(true);
    end;

    /// <summary>GetNotes: Create a Manor time entry.</summary>
    procedure GetNotes(var Notes: Text): Boolean
    begin
        Notes := NotesTxt;
        exit(true);
    end;

    /// <summary>GetEnvelope: Create a Manor time entry.</summary>
    procedure GetEnvelope(var Envelope: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetTarget: Create a Manor time entry.</summary>
    procedure GetTarget(var Target: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetMetering: Create a Manor time entry.</summary>
    procedure GetMetering(var Metering: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetRelated: Create a Manor time entry.</summary>
    procedure GetRelated(var Related: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetWorkflow: Create a Manor time entry.</summary>
    procedure GetWorkflow(var Workflow: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetExamples: Create a Manor time entry.</summary>
    procedure GetExamples(var Examples: JsonArray): Boolean
    begin
        exit(false);
    end;
}
