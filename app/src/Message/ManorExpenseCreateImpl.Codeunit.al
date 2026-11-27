namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Create a Manor expense. Implements execution, bilingual discovery and the contract chapters.</summary>
codeunit 10035678 "Manor Expense Create Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
{
    Access = Internal;

    var
        DescriptionTxt: Label 'Create a Manor expense.', Comment = 'is-IS=Stofna útlagðan kostnað í Manor.';
        KeywordsTxt: Label 'Manor, create, billable, dry run', Comment = 'is-IS=Manor, stofna, reikningsfærsla, prufukeyrsla';
        NotesTxt: Label 'Requires set_alternative_user_of_expenses. expectedCount is always 1. No project/user pre-reads. Creates cannot be undone through Bifrost; correct them in Manor before invoicing. Closed projects are rejected by Manor. Mileage is not supported. Creates are not retried automatically.', Comment = 'is-IS=Krefst set_alternative_user_of_expenses. expectedCount er alltaf 1. Verk og notendur eru ekki lesin fyrirfram. Ekki er hægt að afturkalla stofnun í Bifröst; leiðréttu í Manor fyrir reikningsfærslu. Manor hafnar lokuðum verkum. Akstur er ekki studdur. Stofnun er ekki endurreynd sjálfkrafa.';
        ResponseTxt: Label 'One canonical Manor resource in result; noOfRecords=1. A dry run has dryRun=true, noOfRecords=0, empty result, method, path and the exact payload.', Comment = 'is-IS=Ein færsla með staðlaðum Manor-reitum í result; noOfRecords=1. Prufukeyrsla hefur dryRun=true, noOfRecords=0, tómt result, method, path og nákvæm payload-gögn.';
        ErrorTxt: Label 'Invalid input or expectedCount; 401/403 includes the required permission, 404 means missing resource, 422 means Manor rejected the data. Provider text is not echoed.', Comment = 'is-IS=Ógild gögn eða expectedCount; 401/403 nefnir nauðsynlega heimild, 404 merkir að gögn vanti, 422 merkir að Manor hafnaði gögnunum. Texti þjónustuveitanda er ekki endurbirtur.';
        FixTxt: Label 'Correct the parameter, permission or Manor data. Inspect Manor before retrying a failed create.', Comment = 'is-IS=Leiðréttu færibreytu, heimild eða gögn í Manor. Athugaðu Manor áður en misheppnuð stofnun er reynd aftur.';
        Parameter0Txt: Label 'Manor project ID; no project or user pre-read.', Comment = 'is-IS=Auðkenni verks í Manor; verk og notendur eru ekki lesin fyrirfram.';
        Parameter1Txt: Label 'Must be 1, including dry run; checked before any Manor call.', Comment = 'is-IS=Verður að vera 1, einnig í prufukeyrslu; athugað áður en kallað er á Manor.';
        Parameter2Txt: Label 'Return the exact POST payload without writing to Manor. Default false. Permitted rate or firm reads still run.', Comment = 'is-IS=Skila nákvæmum POST-gögnum án þess að skrifa í Manor. Sjálfgefið false. Heimilaður lestur taxta eða fyrirtækis er samt framkvæmdur.';
        Parameter3Txt: Label 'Description printed on the work report or invoice.', Comment = 'is-IS=Lýsing sem birtist á vinnuskýrslu eða reikningi.';
        Parameter4Txt: Label 'Manor activity ID.', Comment = 'is-IS=Auðkenni verkþáttar í Manor.';
        Parameter5Txt: Label 'Amount excluding VAT in the original currency.', Comment = 'is-IS=Fjárhæð án VSK í upphaflegum gjaldmiðli.';
        Parameter6Txt: Label 'Amount to bill; omitted values are left to Manor.', Comment = 'is-IS=Fjárhæð til reikningsfærslu; Manor ákvarðar gildi sem er sleppt.';
        Parameter7Txt: Label 'ISO 8601 payment timestamp with a time zone.', Comment = 'is-IS=ISO 8601 tímastimpill greiðslu með tímabelti.';
        Parameter8Txt: Label 'Three-letter currency code, for example ISK.', Comment = 'is-IS=Þriggja stafa gjaldmiðilskóði, til dæmis ISK.';
        Parameter9Txt: Label 'VAT rate ID. If omitted, reads /firm pages and uses default_vat_rate_id; refuses if missing. Explicit values are sent unchanged.', Comment = 'is-IS=Auðkenni VSK-taxta. Sé sleppt eru síður frá /firm lesnar og default_vat_rate_id notað; hafnað ef það vantar. Uppgefin gildi eru send óbreytt.';
        Parameter10Txt: Label 'Selects the firm for default VAT. May be omitted only when the firm list has one firm. No project lookup or setup mapping.', Comment = 'is-IS=Velur fyrirtækið fyrir sjálfgefinn VSK. Má aðeins sleppa þegar eitt fyrirtæki er á listanum. Ekkert verk er flett upp og engin uppsetningarvörpun notuð.';
        Parameter11Txt: Label 'Manor user ID.', Comment = 'is-IS=Auðkenni notanda í Manor.';
        Parameter12Txt: Label 'Expense recipient.', Comment = 'is-IS=Viðtakandi útlagðs kostnaðar.';
        Parameter13Txt: Label 'Expense document number.', Comment = 'is-IS=Skjalanúmer útlagðs kostnaðar.';

    /// <summary>IsEnabled: Create a Manor expense.</summary>
    procedure IsEnabled(): Boolean
    var
        CreateMgt: Codeunit "Manor Create Mgt ori";
    begin
        exit(CreateMgt.CanWrite());
    end;

    /// <summary>GetFilterTableNo: Create a Manor expense.</summary>
    procedure GetFilterTableNo(): Integer
    begin
        exit(0);
    end;

    /// <summary>GetDescription: Create a Manor expense.</summary>
    procedure GetDescription(): Text[250]
    begin
        exit(DescriptionTxt);
    end;

    /// <summary>GetKeywords: Create a Manor expense.</summary>
    procedure GetKeywords(): Text
    begin
        exit(KeywordsTxt);
    end;

    /// <summary>GetSelectionDescription: Create a Manor expense.</summary>
    procedure GetSelectionDescription(): Text
    begin
        exit(DescriptionTxt + ' ' + NotesTxt);
    end;

    /// <summary>GetMessageDirection: Create a Manor expense.</summary>
    procedure GetMessageDirection(): Enum "Msg Direction ori"
    begin
        exit(Enum::"Msg Direction ori"::Inbound);
    end;

    /// <summary>ExecuteBifrostTask: Create a Manor expense.</summary>
    procedure ExecuteBifrostTask(var Argument: Record "Message Argument ori")
    var
        CreateMgt: Codeunit "Manor Create Mgt ori";
    begin
        CreateMgt.Execute(Argument, 'expense', 'set_alternative_user_of_expenses');
    end;

    /// <summary>GetParameters: Create a Manor expense.</summary>
    procedure GetParameters(var Parameters: JsonArray): Boolean
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
    begin
        Parameters.Add(ContractMgt.Parameter('projectId', 'integer', true, Parameter0Txt));
        Parameters.Add(ContractMgt.Parameter('expectedCount', 'integer', true, Parameter1Txt));
        Parameters.Add(ContractMgt.Parameter('dryRun', 'boolean', false, Parameter2Txt));
        Parameters.Add(ContractMgt.Parameter('description', 'string', true, Parameter3Txt));
        Parameters.Add(ContractMgt.Parameter('activity_id', 'integer', false, Parameter4Txt));
        Parameters.Add(ContractMgt.Parameter('amount', 'number', true, Parameter5Txt));
        Parameters.Add(ContractMgt.Parameter('billable_amount', 'number', false, Parameter6Txt));
        Parameters.Add(ContractMgt.Parameter('paid_at', 'string', true, Parameter7Txt));
        Parameters.Add(ContractMgt.Parameter('paid_in_currency_code', 'string', true, Parameter8Txt));
        Parameters.Add(ContractMgt.Parameter('vat_rate_id', 'integer', false, Parameter9Txt));
        Parameters.Add(ContractMgt.Parameter('firm_id', 'integer', false, Parameter10Txt));
        Parameters.Add(ContractMgt.Parameter('user_id', 'integer', false, Parameter11Txt));
        Parameters.Add(ContractMgt.Parameter('recipient', 'string', false, Parameter12Txt));
        Parameters.Add(ContractMgt.Parameter('document_number', 'string', false, Parameter13Txt));
        exit(true);
    end;

    /// <summary>GetResponse: Create a Manor expense.</summary>
    procedure GetResponse(var Response: JsonObject): Boolean
    begin
        Response.Add('description', ResponseTxt);
        exit(true);
    end;

    /// <summary>GetErrors: Create a Manor expense.</summary>
    procedure GetErrors(var Errors: JsonArray): Boolean
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
    begin
        Errors.Add(ContractMgt.ErrorEntry("Bifrost Error Code ori"::InvalidParameter, ErrorTxt, FixTxt));
        exit(true);
    end;

    /// <summary>GetEffect: Create a Manor expense.</summary>
    procedure GetEffect(var Effect: JsonObject): Boolean
    begin
        Effect.Add('effect', 'write');
        Effect.Add('permissionSet', 'BIFROST MnrFull ori');
        Effect.Add('idempotent', false);
        Effect.Add('changes', NotesTxt);
        exit(true);
    end;

    /// <summary>GetOverview: Create a Manor expense.</summary>
    procedure GetOverview(var Overview: Text): Boolean
    begin
        Overview := DescriptionTxt;
        exit(true);
    end;

    /// <summary>GetNotes: Create a Manor expense.</summary>
    procedure GetNotes(var Notes: Text): Boolean
    begin
        Notes := NotesTxt;
        exit(true);
    end;

    /// <summary>GetEnvelope: Create a Manor expense.</summary>
    procedure GetEnvelope(var Envelope: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetTarget: Create a Manor expense.</summary>
    procedure GetTarget(var Target: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetMetering: Create a Manor expense.</summary>
    procedure GetMetering(var Metering: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetRelated: Create a Manor expense.</summary>
    procedure GetRelated(var Related: JsonArray): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetWorkflow: Create a Manor expense.</summary>
    procedure GetWorkflow(var Workflow: JsonObject): Boolean
    begin
        exit(false);
    end;

    /// <summary>GetExamples: Create a Manor expense.</summary>
    procedure GetExamples(var Examples: JsonArray): Boolean
    begin
        exit(false);
    end;
}
