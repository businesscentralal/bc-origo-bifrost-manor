namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Builds the contract chapters shared by the Manor write message types.</summary>
codeunit 10035679 "Manor Contract Parts ori"
{
    Access = Internal;

    var
        ExpectedCountHelpLbl: Label 'Number of records the caller expects to write. Must equal the number of records in the request; on a mismatch nothing is sent to Manor.', Comment = 'is-IS=Fjöldi færslna sem sá sem kallar býst við að skrifa. Verður að vera jafn fjölda færslna í beiðninni; ef ekki er ekkert sent til Manor.';
        RecordsHelpLbl: Label 'Optional array of records. Without it, the other fields of data describe one record. Each record uses the fields below.', Comment = 'is-IS=Valfrjáls listi færslna. Án hans lýsa aðrir reitir data einni færslu. Hver færsla notar reitina hér á eftir.';
        NotesLbl: Label 'Submit to POST /queues. Writes need the permission set BIFROST MnrFull ori. Manor 422 field errors are returned per record in results[].error. There are no delete message types. Never send an API key; it is kept in Manor setup. Data in Manor is created in the instance and environment chosen in Manor setup.', Comment = 'is-IS=Sendu á POST /queues. Skrif krefjast heimildasafnsins BIFROST MnrFull ori. Villur frá Manor (422) um reiti koma per færslu í results[].error. Engar skilaboðagerðir eyða gögnum. Sendu aldrei API-lykil; hann er geymdur í uppsetningu Manor. Gögn eru stofnuð í því tilviki og umhverfi sem er valið í uppsetningu Manor.';
        ClientIdHelpLbl: Label 'Manor client id.', Comment = 'is-IS=Auðkenni viðskiptavinar í Manor.';
        ProjectIdHelpLbl: Label 'Manor project id.', Comment = 'is-IS=Auðkenni verkefnis í Manor.';
        ActivityIdHelpLbl: Label 'Manor activity (work item, Verkþáttur) id.', Comment = 'is-IS=Auðkenni verkþáttar í Manor.';
        NationalIdHelpLbl: Label 'Kennitala. Foreign clients usually have none: Manor accepts any number with a warning, but it must match the accounting system; some systems use a ten-digit number starting with 99.', Comment = 'is-IS=Kennitala. Erlendir viðskiptavinir hafa yfirleitt enga: Manor tekur við hvaða númeri sem er með viðvörun, en það þarf að passa við bókhaldskerfið; sum kerfi nota tíu stafa númer sem byrjar á 99.';
        CurrencyHelpLbl: Label 'Currency code. A strong setting: it applies to all the client''s projects and invoices. In an update it needs confirmCurrencyChange=true.', Comment = 'is-IS=Gjaldmiðilskóði. Sterk stilling: gildir um öll verkefni og reikninga viðskiptavinarins. Í uppfærslu þarf confirmCurrencyChange=true.';
        ConfirmHelpLbl: Label 'Must be true when currency_code is sent in an update; otherwise the update is refused and nothing changes.', Comment = 'is-IS=Verður að vera true þegar currency_code er sendur í uppfærslu; annars er uppfærslu hafnað og engu breytt.';
        OwnerHelpLbl: Label 'Responsible person (Ábyrgðarmaður): a Manor user with the owns_projects permission.', Comment = 'is-IS=Ábyrgðarmaður: notandi í Manor með heimildina owns_projects.';
        BillingHelpLbl: Label 'enabled, internal or sensitive. sensitive hides entries from users without that permission. Default enabled. Any other value is refused.', Comment = 'is-IS=enabled, internal eða sensitive. sensitive felur færslur fyrir notendum án þeirrar heimildar. Sjálfgefið enabled. Öðrum gildum er hafnað.';
        OpenHelpLbl: Label 'true or false. Setting false closes the project and blocks ALL new entries on it for everyone; nothing is deleted and unbilled entries stay billable. Setting true reopens it; Bifrost adds no owner check, Manor may refuse.', Comment = 'is-IS=true eða false. false lokar verkefninu og hindrar ALLAR nýjar færslur fyrir alla; engu er eytt og óreikningsfærðar færslur haldast reikningshæfar. true opnar það aftur; Bifröst bætir ekki við eigandaathugun, Manor getur hafnað.';
        VatHelpLbl: Label 'true or false. False unless the instance always applies VAT and client and owner are in the same country. Must be right for invoicing to work.', Comment = 'is-IS=true eða false. False nema tilvikið beiti alltaf VSK og viðskiptavinur og ábyrgðarmaður séu í sama landi. Þarf að vera rétt til að reikningagerð virki.';
        BuyerRefHelpLbl: Label 'Buyer reference number, printed on invoices including e-invoices.', Comment = 'is-IS=Tilvísunarnúmer kaupanda, prentað á reikninga, einnig rafræna reikninga.';
        ClosingHelpLbl: Label 'Comment stored when a project is closed.', Comment = 'is-IS=Athugasemd sem vistast þegar verkefni er lokað.';
        ActivityDatesHelpLbl: Label 'Date. ends_at must be after begins_at.', Comment = 'is-IS=Dagsetning. ends_at verður að vera á eftir begins_at.';
        ActivityBudgetHelpLbl: Label 'Whole number of 1 or more, or null. Budgets must not overlap those of ancestors or children.', Comment = 'is-IS=Heil tala, 1 eða hærri, eða null. Fjárhagsáætlanir mega ekki skarast við áætlanir yfir- eða undirverkþátta.';
        ActivityParentHelpLbl: Label 'Parent activity id: same project, and not a milestone. internal must match the top-level parent. An activity cannot move to another project; settlement projects refuse activity changes.', Comment = 'is-IS=Auðkenni yfirverkþáttar: sama verkefni og ekki áfangi. internal verður að passa við efsta yfirverkþátt. Verkþáttur flyst ekki í annað verkefni; uppgjörsverkefni hafna breytingum á verkþáttum.';
        GenericHelpLbl: Label 'Manor field of the same name, sent as given. Manor validates it and returns 422 errors per record.', Comment = 'is-IS=Reitur í Manor með sama nafni, sendur óbreyttur. Manor staðfestir hann og skilar villum (422) per færslu.';

    /// <summary>Returns the envelope chapter.</summary>
    /// <param name="MessageType">The Manor write type.</param>
    /// <returns>The envelope object.</returns>
    procedure Envelope(MessageType: Enum "Message Type ori") Result: JsonObject
    var
        Subject: JsonObject;
        Forms: JsonArray;
    begin
        Subject.Add('use', 'notUsed');
        Subject.Add('forms', Forms);
        Result.Add('subject', Subject);
        Result.Add('dataRequired', true);
        Result.Add('version', '1.0');
        Result.Add('contentType', 'text/json');
        Result.Add('endpoint', 'POST /queues');
    end;

    /// <summary>Returns the parameters chapter.</summary>
    /// <param name="MessageType">The Manor write type.</param>
    /// <returns>The parameter array.</returns>
    procedure Parameters(MessageType: Enum "Message Type ori") Result: JsonArray
    var
        Contracts: Codeunit "Msg Contract Mgt ori";
        Handler: Codeunit "Manor Write Handler ori";
        Required: List of [Text];
        Parameter: JsonObject;
        Name: Text;
    begin
        Parameter := Contracts.Parameter('expectedCount', 'integer', true, ExpectedCountHelpLbl);
        Parameter.Add('minimum', 1);
        Result.Add(Parameter);
        Result.Add(Contracts.Parameter('records', 'array', false, RecordsHelpLbl));
        Required := Handler.RequiredFields(MessageType);
        foreach Name in Handler.AllowedFields(MessageType) do
            Result.Add(Contracts.Parameter(Name, FieldType(Name), Required.Contains(Name), FieldHelp(Name)));
    end;

    local procedure FieldType(Name: Text): Text
    begin
        if Name in ['open', 'subject_to_vat', 'add_transaction_fee', 'internal', 'confirmCurrencyChange'] then
            exit('boolean');
        if Name in ['budget', 'time_budget', 'estimate'] then
            exit('number');
        if Name = 'labels' then
            exit('array');
        exit('string');
    end;

    local procedure FieldHelp(Name: Text): Text
    begin
        case Name of
            'id':
                exit(ClientIdHelpLbl + ' ' + ProjectIdHelpLbl + ' ' + ActivityIdHelpLbl);
            'projectId':
                exit(ProjectIdHelpLbl);
            'national_id':
                exit(NationalIdHelpLbl);
            'currency_code':
                exit(CurrencyHelpLbl);
            'confirmCurrencyChange':
                exit(ConfirmHelpLbl);
            'owner':
                exit(OwnerHelpLbl);
            'billing':
                exit(BillingHelpLbl);
            'open', 'closing_comment':
                exit(OpenHelpLbl + ' ' + ClosingHelpLbl);
            'subject_to_vat':
                exit(VatHelpLbl);
            'buyer_reference_number':
                exit(BuyerRefHelpLbl);
            'begins_at', 'ends_at', 'closed_at':
                exit(ActivityDatesHelpLbl);
            'budget', 'time_budget':
                exit(ActivityBudgetHelpLbl);
            'parent', 'internal':
                exit(ActivityParentHelpLbl);
            else
                exit(GenericHelpLbl);
        end;
    end;

    /// <summary>Returns the response chapter.</summary>
    /// <param name="MessageType">The Manor write type.</param>
    /// <returns>The response object.</returns>
    procedure Response(MessageType: Enum "Message Type ori") Result: JsonObject
    var
        Contracts: Codeunit "Msg Contract Mgt ori";
        Fields: JsonArray;
        Children: JsonArray;
        ResultsField: JsonObject;
    begin
        Fields.Add(Contracts.ResponseField('status', 'string', 'Success when every record was written, Failed when at least one was not.'));
        Fields.Add(Contracts.ResponseField('succeeded', 'integer', 'Number of records written.'));
        Fields.Add(Contracts.ResponseField('failed', 'integer', 'Number of records Manor or the pre-checks refused.'));
        Children.Add(Contracts.ResponseField('index', 'integer', 'Position of the record in the request, from 1.'));
        Children.Add(Contracts.ResponseField('status', 'string', 'Created, Updated or Failed.'));
        Children.Add(Contracts.ResponseField('id', 'string', 'Manor id of the written record.'));
        Children.Add(Contracts.ResponseField('record', 'object', 'The record as Manor returned it, canonical field names.'));
        Children.Add(Contracts.ResponseField('error', 'string', 'EN or IS error text, such as Manor 422 field messages. Never contains a key.'));
        ResultsField := Contracts.ResponseField('results', 'array', 'One entry per record, in request order.');
        ResultsField.Add('children', Children);
        Fields.Add(ResultsField);
        Result.Add('contentType', 'text/json');
        Result.Add('fields', Fields);
        Result.Add('whenEmpty', 'A request without records is refused with MissingParameter.');
    end;

    /// <summary>Returns the errors chapter.</summary>
    /// <param name="MessageType">The Manor write type.</param>
    /// <returns>The error array.</returns>
    procedure Errors(MessageType: Enum "Message Type ori") Result: JsonArray
    var
        Contracts: Codeunit "Msg Contract Mgt ori";
    begin
        Result.Add(Contracts.ErrorEntry(Enum::"Bifrost Error Code ori"::InvalidParameter, 'expectedCount does not match the number of records, a field is unknown or has the wrong type, billing is not enabled/internal/sensitive, or currency_code is sent in an update without confirmCurrencyChange=true. Nothing is sent to Manor.', 'Correct the request; read the parameters chapter.'));
        Result.Add(Contracts.ErrorEntry(Enum::"Bifrost Error Code ori"::MissingParameter, 'A required field or all records are missing.', 'Send the required fields listed in the parameters chapter.'));
        Result.Add(Contracts.ErrorEntry(Enum::"Bifrost Error Code ori"::PreconditionFailed, 'In results[].error: Manor rejected the key or permission (401/403, with the Manor permission to grant, such as manage_activities), did not find the resource (404), rejected the data (400/422, field messages) or is unavailable.', 'Fix the cause named in the message and retry only the failed records. Create refuses a duplicate national_id and names the existing client id.'));
    end;

    /// <summary>Returns the effect chapter.</summary>
    /// <param name="MessageType">The Manor write type.</param>
    /// <returns>The effect object.</returns>
    procedure Effect(MessageType: Enum "Message Type ori") Result: JsonObject
    begin
        Result.Add('effect', 'write');
        Result.Add('changes', 'Creates or updates the listed records in Manor through the Manor external API. No delete type exists.');
        Result.Add('idempotent', false);
        Result.Add('permissionSet', 'BIFROST MnrFull ori');
    end;

    /// <summary>Returns the examples chapter.</summary>
    /// <param name="MessageType">The Manor write type.</param>
    /// <returns>The example array.</returns>
    procedure Examples(MessageType: Enum "Message Type ori") Result: JsonArray
    var
        Contracts: Codeunit "Msg Contract Mgt ori";
    begin
        case MessageType of
            MessageType::"Manor.Client.Create":
                Result.Add(Contracts.Example('Create a client', '{"type":"Manor.Client.Create","data":{"expectedCount":1,"name":"Demo Client","national_id":"0101010000","currency_code":"ISK"}}', '{"status":"Success","succeeded":1,"failed":0,"results":[{"index":1,"status":"Created","id":"10"}]}'));
            MessageType::"Manor.Client.Update":
                Result.Add(Contracts.Example('Update a client email', '{"type":"Manor.Client.Update","data":{"expectedCount":1,"id":"10","email":"demo@example.com"}}', '{"status":"Success","succeeded":1,"failed":0,"results":[{"index":1,"status":"Updated","id":"10"}]}'));
            MessageType::"Manor.Project.Create":
                Result.Add(Contracts.Example('Create a project', '{"type":"Manor.Project.Create","data":{"expectedCount":1,"name":"Demo Project","owner":"5","billing":"enabled"}}', '{"status":"Success","succeeded":1,"failed":0,"results":[{"index":1,"status":"Created","id":"20"}]}'));
            MessageType::"Manor.Project.Update":
                Result.Add(Contracts.Example('Close a project', '{"type":"Manor.Project.Update","data":{"expectedCount":1,"id":"20","open":false,"closing_comment":"Done"}}', '{"status":"Success","succeeded":1,"failed":0,"results":[{"index":1,"status":"Updated","id":"20"}]}'));
            MessageType::"Manor.Activity.Create":
                Result.Add(Contracts.Example('Create an activity', '{"type":"Manor.Activity.Create","data":{"expectedCount":1,"projectId":"20","name":"Design"}}', '{"status":"Success","succeeded":1,"failed":0,"results":[{"index":1,"status":"Created","id":"30"}]}'));
            MessageType::"Manor.Activity.Update":
                Result.Add(Contracts.Example('Rename an activity', '{"type":"Manor.Activity.Update","data":{"expectedCount":1,"projectId":"20","id":"30","name":"Design phase"}}', '{"status":"Success","succeeded":1,"failed":0,"results":[{"index":1,"status":"Updated","id":"30"}]}'));
        end;
    end;

    /// <summary>Returns the notes chapter.</summary>
    /// <returns>The notes text.</returns>
    procedure Notes(): Text
    begin
        exit(NotesLbl);
    end;
}
