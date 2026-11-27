namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>
/// The contract chapters (English with Icelandic translations) of the Manor read message types
/// Manor.Client.List, Manor.Client.Get, Manor.Project.List, Manor.Project.Get and Manor.Activity.List.
/// </summary>
codeunit 10035681 "Manor Read Parts ori"
{
    Access = Internal;

    var
        PageLbl: Label 'The page to read, starting at 1. Default 1.', Comment = 'is-IS=Blaðsíðan sem á að lesa, frá 1. Sjálfgefið 1.';
        PerPageLbl: Label 'Items per page, from 1 to 100. Default 100.', Comment = 'is-IS=Fjöldi á blaðsíðu, frá 1 til 100. Sjálfgefið 100.';
        UpdatedSinceLbl: Label 'Only items changed since this date and time (ISO 8601, for example 2026-11-01T00:00:00Z).', Comment = 'is-IS=Aðeins atriði sem breyttust eftir þessa dagsetningu og tíma (ISO 8601, til dæmis 2026-11-01T00:00:00Z).';
        ClientIdLbl: Label 'The Manor client id. Send either clientId or nationalId, not both.', Comment = 'is-IS=Auðkenni viðskiptavinar í Manor. Sendu annaðhvort clientId eða nationalId, ekki bæði.';
        NationalIdLbl: Label 'The national id (kennitala) of the client. Foreign clients often carry a made-up number. Send either clientId or nationalId, not both.', Comment = 'is-IS=Kennitala viðskiptavinar. Erlendir viðskiptavinir eru oft með tilbúið númer. Sendu annaðhvort clientId eða nationalId, ekki bæði.';
        StatusLbl: Label 'Which projects to return: open (default), closed or all. Closed projects accept no new entries.', Comment = 'is-IS=Hvaða verk á að skila: open (sjálfgefið), closed eða all. Lokuð verk taka ekki við nýjum færslum.';
        ClientFilterLbl: Label 'Only the projects of this Manor client id.', Comment = 'is-IS=Aðeins verk þessa viðskiptavinar í Manor.';
        IdentifierFilterLbl: Label 'Only projects with this external project number (identifier). It is not unique in Manor.', Comment = 'is-IS=Aðeins verk með þetta ytra málsnúmer (identifier). Það er ekki einkvæmt í Manor.';
        WithActivitiesLbl: Label 'When true every project carries its activities. Default false.', Comment = 'is-IS=Þegar það er satt fylgja verkþættir hverju verki. Sjálfgefið ósatt.';
        ProjectIdLbl: Label 'The Manor project id. Send either projectId or identifier, not both.', Comment = 'is-IS=Auðkenni verks í Manor. Sendu annaðhvort projectId eða identifier, ekki bæði.';
        ProjectIdentifierLbl: Label 'The external project number (identifier). It is not unique: more than one match is refused with AmbiguousRecord. Send either projectId or identifier, not both.', Comment = 'is-IS=Ytra málsnúmer verks (identifier). Það er ekki einkvæmt: fleiri en ein samsvörun er hafnað með AmbiguousRecord. Sendu annaðhvort projectId eða identifier, ekki bæði.';
        ActivityProjectIdLbl: Label 'The Manor project id whose activities are listed.', Comment = 'is-IS=Auðkenni verks í Manor sem verkþættir eru listaðir fyrir.';
        EnvelopeLbl: Label 'The message is identified by its type; it has no subject record.', Comment = 'is-IS=Skilaboðin eru auðkennd með gerð sinni; þau hafa enga viðfangsfærslu.';
        SuccessLbl: Label 'The Manor data of the call, taken from the canonical Manor fields.', Comment = 'is-IS=Gögn Manor fyrir kallið, tekin úr kanónískum reitum Manor.';
        PagingItemsLbl: Label 'The items of the requested page, as Manor returns them (canonical field names).', Comment = 'is-IS=Atriði umbeðinnar blaðsíðu eins og Manor skilar þeim (kanónísk reitaheiti).';
        PagePropLbl: Label 'The page that was read.', Comment = 'is-IS=Blaðsíðan sem var lesin.';
        PerPagePropLbl: Label 'The page size that was used.', Comment = 'is-IS=Blaðsíðustærðin sem var notuð.';
        LastPagePropLbl: Label 'The last page number Manor reports.', Comment = 'is-IS=Síðasta blaðsíðunúmer sem Manor skilar.';
        TotalPropLbl: Label 'The total number of items Manor reports for the filter.', Comment = 'is-IS=Heildarfjöldi atriða sem Manor skilar fyrir síuna.';
        CountPropLbl: Label 'The number of items on this page. 0 means an empty result.', Comment = 'is-IS=Fjöldi atriða á þessari blaðsíðu. 0 þýðir tóm niðurstaða.';
        HasMorePropLbl: Label 'True when more pages follow; send page + 1 to read them.', Comment = 'is-IS=Satt þegar fleiri blaðsíður fylgja; sendu page + 1 til að lesa þær.';
        ClientPropLbl: Label 'The client. currency_code governs all its projects and invoices; special_attention flags the client (for example for overdue debt): tell the user before time is recorded for it.', Comment = 'is-IS=Viðskiptavinurinn. currency_code gildir fyrir öll verk hans og reikninga; special_attention merkir viðskiptavininn (til dæmis vegna vanskila): láttu notandann vita áður en tími er skráður á hann.';
        ProjectPropLbl: Label 'The project. identifier is the external number; open false means closed (no new entries); billing says whether it is invoiced.', Comment = 'is-IS=Verkið. identifier er ytra númerið; open false þýðir lokað (engar nýjar færslur); billing segir hvort það er reikningsfært.';
        MissingErrLbl: Label 'A required identifier is missing, or both identifiers were sent. Returns MissingParameter or ConflictingIdentifiers.', Comment = 'is-IS=Auðkenni vantar eða bæði auðkennin voru send. Skilar MissingParameter eða ConflictingIdentifiers.';
        MissingFixLbl: Label 'Send exactly one of the identifiers and try again.', Comment = 'is-IS=Sendu nákvæmlega eitt auðkennanna og reyndu aftur.';
        RequiredErrLbl: Label 'projectId is missing. Returns MissingParameter.', Comment = 'is-IS=projectId vantar. Skilar MissingParameter.';
        RequiredFixLbl: Label 'Find the project with Manor.Project.List and send its id.', Comment = 'is-IS=Finndu verkið með Manor.Project.List og sendu auðkenni þess.';
        FormatErrLbl: Label 'A parameter has the wrong form: an id that is not a positive whole number, a page or perPage outside its range, a status other than open, closed or all, or a date that is not ISO 8601.', Comment = 'is-IS=Breyta er á röngu formi: auðkenni sem er ekki jákvæð heiltala, page eða perPage utan marka, status annað en open, closed eða all, eða dagsetning sem er ekki ISO 8601.';
        FormatFixLbl: Label 'Correct the value named in the error and try again.', Comment = 'is-IS=Leiðréttu gildið sem nefnt er í villunni og reyndu aftur.';
        NotFoundErrLbl: Label 'Manor has no such item (HTTP 404). Returns RecordNotFound.', Comment = 'is-IS=Manor á ekkert slíkt atriði (HTTP 404). Skilar RecordNotFound.';
        NotFoundFixLbl: Label 'Check the id, or find the item with the list message type.', Comment = 'is-IS=Athugaðu auðkennið eða finndu atriðið með listaskilaboðunum.';
        NationalIdNotFoundFixLbl: Label 'A missing national id does not prove the client is missing: foreign clients often have a made-up number. Search by name with Manor.Client.List.', Comment = 'is-IS=Kennitala sem finnst ekki sannar ekki að viðskiptavinurinn sé ekki til: erlendir viðskiptavinir eru oft með tilbúið númer. Leitaðu eftir nafni með Manor.Client.List.';
        AmbiguousErrLbl: Label 'More than one project has this identifier. Returns AmbiguousRecord.', Comment = 'is-IS=Fleiri en eitt verk hefur þetta auðkenni. Skilar AmbiguousRecord.';
        AmbiguousFixLbl: Label 'Find the project with Manor.Project.List and read it by projectId.', Comment = 'is-IS=Finndu verkið með Manor.Project.List og lestu það með projectId.';
        RejectedErrLbl: Label 'Manor rejected the API key or its permissions (HTTP 401 or 403). Returns PermissionDenied. Activities need the Manor permission manage_activities.', Comment = 'is-IS=Manor hafnaði API-lyklinum eða heimildum hans (HTTP 401 eða 403). Skilar PermissionDenied. Verkþættir krefjast Manor-heimildarinnar manage_activities.';
        RejectedFixLbl: Label 'Check the API key and the Manor permissions of its user in Manor Setup. The key is never shown.', Comment = 'is-IS=Athugaðu API-lykilinn og Manor-heimildir notandans í uppsetningu Manor. Lykillinn er aldrei sýndur.';
        RejectedDataErrLbl: Label 'Manor rejected the values (HTTP 422). Returns InvalidParameter with the field messages.', Comment = 'is-IS=Manor hafnaði gildunum (HTTP 422). Skilar InvalidParameter með skilaboðum um reiti.';
        RejectedDataFixLbl: Label 'Correct the values named in the error and try again.', Comment = 'is-IS=Leiðréttu gildin sem nefnd eru í villunni og reyndu aftur.';
        UnavailableErrLbl: Label 'Manor is unreachable, busy or failed (HTTP 429, 5xx or no connection) after one retry. Returns Retryable or BusinessCentralError.', Comment = 'is-IS=Ekki næst í Manor, það er of upptekið eða bilað (HTTP 429, 5xx eða ekkert samband) eftir eina endurtilraun. Skilar Retryable eða BusinessCentralError.';
        UnavailableFixLbl: Label 'Try again later.', Comment = 'is-IS=Reyndu aftur síðar.';
        ChangesLbl: Label 'Reads only; nothing is changed in Business Central or in Manor.', Comment = 'is-IS=Les aðeins; engu er breytt í Business Central eða Manor.';
        PreconditionLbl: Label 'Manor Setup holds the environment and, unless it is Mock, the instance and the API key.', Comment = 'is-IS=Uppsetning Manor geymir umhverfið og, nema það sé Mock, tilvikið og API-lykilinn.';
        RelatedClientListLbl: Label 'Find a client by name or list clients changed since a time.', Comment = 'is-IS=Finna viðskiptavin eftir nafni eða lista viðskiptavini sem breyttust eftir ákveðinn tíma.';
        RelatedClientGetLbl: Label 'Read one client by id or national id.', Comment = 'is-IS=Lesa einn viðskiptavin eftir auðkenni eða kennitölu.';
        RelatedProjectListLbl: Label 'Find the project id by client, external number or status.', Comment = 'is-IS=Finna auðkenni verks eftir viðskiptavini, ytra númeri eða stöðu.';
        RelatedProjectGetLbl: Label 'Read one project by id or external number.', Comment = 'is-IS=Lesa eitt verk eftir auðkenni eða ytra númeri.';
        RelatedActivityListLbl: Label 'List the activities (work items) of a project.', Comment = 'is-IS=Lista verkþætti (vinnuliði) verks.';
        OverviewClientListLbl: Label 'Lists Manor clients (Viðskiptavinur), one page at a time, optionally only those changed since a time. A client is the party the projects are run for and, by default, the payer of every entry on them.', Comment = 'is-IS=Listar viðskiptavini í Manor, eina blaðsíðu í einu, ef vill aðeins þá sem breyttust eftir ákveðinn tíma. Viðskiptavinur er sá sem verkin eru unnin fyrir og, sjálfgefið, greiðandi allra færslna á þeim.';
        OverviewClientGetLbl: Label 'Reads one Manor client by its id or by its national id (kennitala).', Comment = 'is-IS=Les einn viðskiptavin í Manor eftir auðkenni eða kennitölu.';
        OverviewProjectListLbl: Label 'Lists Manor projects (Mál / Verk), open projects by default. Closed projects accept no new entries, so ask for status closed or all only when you need them.', Comment = 'is-IS=Listar verk í Manor (Mál / Verk), sjálfgefið opin verk. Lokuð verk taka ekki við nýjum færslum, svo biddu um status closed eða all aðeins þegar þú þarft þau.';
        OverviewProjectGetLbl: Label 'Reads one Manor project by its id or by its external number (identifier).', Comment = 'is-IS=Les eitt verk í Manor eftir auðkenni eða ytra málsnúmeri (identifier).';
        OverviewActivityListLbl: Label 'Lists the activities (Verkþættir, work items) of one Manor project through the canonical activity route. Reading activities needs the Manor permission manage_activities.', Comment = 'is-IS=Listar verkþætti eins verks í Manor um kanónísku activity-slóðina. Til að lesa verkþætti þarf Manor-heimildina manage_activities.';
        NotesClientLbl: Label 'special_attention flags a client for the firm, for example for overdue debt. Users get a warning when they record time for that client but are not blocked: tell the user before you record time. currency_code governs all projects and invoices of the client. Payment term, invoice comment and invoice layout are not part of the Manor API.', Comment = 'is-IS=special_attention merkir viðskiptavin fyrir fyrirtækið, til dæmis vegna vanskila. Notendur fá viðvörun þegar þeir skrá tíma á viðskiptavininn en eru ekki stöðvaðir: láttu notandann vita áður en þú skráir tíma. currency_code gildir fyrir öll verk og reikninga viðskiptavinarins. Greiðslufrestur, athugasemd á reikningi og útlit reiknings eru ekki hluti af Manor API.';
        NotesProjectLbl: Label 'identifier is the optional external number and is not unique. open false means closed: no new entries of any type, but unbilled entries stay billable. billing is enabled, internal (never billed) or sensitive (internal and hidden); the Manor UI also has a paused state that the API does not name. subject_to_vat decides whether VAT is added on invoicing. budget is an amount compared with unbilled items; it warns but never blocks.', Comment = 'is-IS=identifier er valfrjálst ytra númer og er ekki einkvæmt. open false þýðir lokað: engar nýjar færslur af neinu tagi, en óreikningsfærðar færslur má enn reikningsfæra. billing er enabled, internal (aldrei reikningsfært) eða sensitive (innanhúss og falið); Manor-viðmótið hefur líka hléstöðu sem API nefnir ekki. subject_to_vat ræður því hvort VSK leggst á við reikningagerð. budget er upphæð borin saman við óreikningsfærð atriði; það varar við en stöðvar aldrei.';
        NotesActivityLbl: Label 'Sub-activities inherit payer, internal and closed state from their ancestors. A parent budget in the response is the total of its own and its children. Some firms do not accept entries directly on an activity that has sub-activities. Only the canonical activity route is used, never the legacy segment alias.', Comment = 'is-IS=Undirverkþættir erfa greiðanda, internal og lokaða stöðu frá forverum sínum. Áætlun yfirverkþáttar í svarinu er heildin af hans eigin og undirverkþáttanna. Sum fyrirtæki taka ekki við færslum beint á verkþátt sem hefur undirverkþætti. Aðeins kanónísk activity-slóð er notuð, aldrei gamla segment-slóðin.';
        ExampleEmptyTitleLbl: Label 'An empty result', Comment = 'is-IS=Tóm niðurstaða';

    /// <summary>Builds the envelope chapter: no subject, no required data.</summary>
    /// <param name="DataRequired">Whether the call needs data.</param>
    /// <returns>The envelope chapter.</returns>
    procedure GetEnvelope(DataRequired: Boolean) Envelope: JsonObject
    var
        Subject: JsonObject;
        Forms: JsonArray;
    begin
        Subject.Add('use', 'notUsed');
        Subject.Add('forms', Forms);
        Subject.Add('description', EnvelopeLbl);
        Envelope.Add('subject', Subject);
        Envelope.Add('dataRequired', DataRequired);
        Envelope.Add('version', '1.0');
        Envelope.Add('contentType', 'text/json');
    end;

    /// <summary>Builds the target chapter of a get type.</summary>
    /// <param name="MessageType">The message type name.</param>
    /// <param name="Target">Receives the target entries.</param>
    /// <returns>True for the get types.</returns>
    procedure GetTarget(MessageType: Text; var Target: JsonArray): Boolean
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
    begin
        Clear(Target);
        case MessageType of
            'Manor.Client.Get':
                begin
                    Target.Add(ContractMgt.TargetEntry('data.clientId', 'Manor client id', ClientIdLbl));
                    Target.Add(ContractMgt.TargetEntry('data.nationalId', 'national id (kennitala)', NationalIdLbl));
                end;
            'Manor.Project.Get':
                begin
                    Target.Add(ContractMgt.TargetEntry('data.projectId', 'Manor project id', ProjectIdLbl));
                    Target.Add(ContractMgt.TargetEntry('data.identifier', 'external project number', ProjectIdentifierLbl));
                end;
            'Manor.Activity.List':
                Target.Add(ContractMgt.TargetEntry('data.projectId', 'Manor project id', ActivityProjectIdLbl));
            else
                exit(false);
        end;
        exit(true);
    end;

    /// <summary>Builds the parameters chapter.</summary>
    /// <param name="MessageType">The message type name.</param>
    /// <returns>The parameters.</returns>
    procedure GetParameters(MessageType: Text) Parameters: JsonArray
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
    begin
        case MessageType of
            'Manor.Client.List':
                begin
                    Parameters.Add(ContractMgt.Parameter('updatedSince', 'string', false, UpdatedSinceLbl));
                    AddPaging(Parameters);
                end;
            'Manor.Client.Get':
                begin
                    Parameters.Add(ContractMgt.Parameter('clientId', 'string', false, ClientIdLbl));
                    Parameters.Add(ContractMgt.Parameter('nationalId', 'string', false, NationalIdLbl));
                end;
            'Manor.Project.List':
                begin
                    Parameters.Add(ContractMgt.Parameter('status', 'string', false, StatusLbl));
                    Parameters.Add(ContractMgt.Parameter('clientId', 'string', false, ClientFilterLbl));
                    Parameters.Add(ContractMgt.Parameter('identifier', 'string', false, IdentifierFilterLbl));
                    Parameters.Add(ContractMgt.Parameter('updatedSince', 'string', false, UpdatedSinceLbl));
                    Parameters.Add(ContractMgt.Parameter('withActivities', 'boolean', false, WithActivitiesLbl));
                    AddPaging(Parameters);
                end;
            'Manor.Project.Get':
                begin
                    Parameters.Add(ContractMgt.Parameter('projectId', 'string', false, ProjectIdLbl));
                    Parameters.Add(ContractMgt.Parameter('identifier', 'string', false, ProjectIdentifierLbl));
                end;
            'Manor.Activity.List':
                begin
                    Parameters.Add(ContractMgt.Parameter('projectId', 'string', true, ActivityProjectIdLbl));
                    AddPaging(Parameters);
                end;
        end;
    end;

    local procedure AddPaging(var Parameters: JsonArray)
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
    begin
        Parameters.Add(ContractMgt.Parameter('page', 'integer', false, PageLbl));
        Parameters.Add(ContractMgt.Parameter('perPage', 'integer', false, PerPageLbl));
    end;

    /// <summary>Builds the response chapter.</summary>
    /// <param name="MessageType">The message type name.</param>
    /// <returns>The response chapter.</returns>
    procedure GetResponse(MessageType: Text) Response: JsonObject
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
        Fields: JsonArray;
    begin
        Response.Add('contentType', 'text/json');
        Response.Add('description', SuccessLbl);
        Response.Add('status', 'Success');
        Response.Add('payloadPath', 'data');
        case MessageType of
            'Manor.Client.List':
                AddListFields(Fields, 'clients');
            'Manor.Project.List':
                AddListFields(Fields, 'projects');
            'Manor.Activity.List':
                AddListFields(Fields, 'activities');
            'Manor.Client.Get':
                Fields.Add(ContractMgt.ResponseField('client', 'object', ClientPropLbl));
            'Manor.Project.Get':
                Fields.Add(ContractMgt.ResponseField('project', 'object', ProjectPropLbl));
        end;
        Response.Add('fields', Fields);
    end;

    local procedure AddListFields(var Fields: JsonArray; ListName: Text)
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
    begin
        Fields.Add(ContractMgt.ResponseField(ListName, 'array', PagingItemsLbl));
        Fields.Add(ContractMgt.ResponseField('page', 'integer', PagePropLbl));
        Fields.Add(ContractMgt.ResponseField('perPage', 'integer', PerPagePropLbl));
        Fields.Add(ContractMgt.ResponseField('lastPage', 'integer', LastPagePropLbl));
        Fields.Add(ContractMgt.ResponseField('total', 'integer', TotalPropLbl));
        Fields.Add(ContractMgt.ResponseField('count', 'integer', CountPropLbl));
        Fields.Add(ContractMgt.ResponseField('hasMore', 'boolean', HasMorePropLbl));
    end;

    /// <summary>Builds the errors chapter.</summary>
    /// <param name="MessageType">The message type name.</param>
    /// <returns>The errors.</returns>
    procedure GetErrors(MessageType: Text) Errors: JsonArray
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
    begin
        if MessageType in ['Manor.Client.Get', 'Manor.Project.Get'] then
            Errors.Add(ContractMgt.ErrorEntry("Bifrost Error Code ori"::MissingParameter, MissingErrLbl, MissingFixLbl));
        if MessageType = 'Manor.Activity.List' then
            Errors.Add(ContractMgt.ErrorEntry("Bifrost Error Code ori"::MissingParameter, RequiredErrLbl, RequiredFixLbl));
        Errors.Add(ContractMgt.ErrorEntry("Bifrost Error Code ori"::InvalidParameterFormat, FormatErrLbl, FormatFixLbl));
        if MessageType in ['Manor.Client.Get', 'Manor.Project.Get', 'Manor.Activity.List'] then begin
            if MessageType = 'Manor.Client.Get' then
                Errors.Add(ContractMgt.ErrorEntry("Bifrost Error Code ori"::RecordNotFound, NotFoundErrLbl, NationalIdNotFoundFixLbl))
            else
                Errors.Add(ContractMgt.ErrorEntry("Bifrost Error Code ori"::RecordNotFound, NotFoundErrLbl, NotFoundFixLbl));
        end;
        if MessageType = 'Manor.Project.Get' then
            Errors.Add(ContractMgt.ErrorEntry("Bifrost Error Code ori"::AmbiguousRecord, AmbiguousErrLbl, AmbiguousFixLbl));
        Errors.Add(ContractMgt.ErrorEntry("Bifrost Error Code ori"::PermissionDenied, RejectedErrLbl, RejectedFixLbl));
        Errors.Add(ContractMgt.ErrorEntry("Bifrost Error Code ori"::InvalidParameter, RejectedDataErrLbl, RejectedDataFixLbl));
        Errors.Add(ContractMgt.ErrorEntry("Bifrost Error Code ori"::BusinessCentralError, UnavailableErrLbl, UnavailableFixLbl));
    end;

    /// <summary>Builds the effect chapter: a read.</summary>
    /// <returns>The effect chapter.</returns>
    procedure GetEffect() Effect: JsonObject
    var
        Preconditions: JsonArray;
    begin
        Preconditions.Add(PreconditionLbl);
        Effect.Add('effect', 'read');
        Effect.Add('changes', ChangesLbl);
        Effect.Add('idempotent', true);
        Effect.Add('permissionSet', 'BIFROST MnrRead ori');
        Effect.Add('preconditions', Preconditions);
    end;

    /// <summary>Builds the related chapter.</summary>
    /// <param name="MessageType">The message type name.</param>
    /// <returns>The related message types.</returns>
    procedure GetRelated(MessageType: Text) Related: JsonArray
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
    begin
        if MessageType <> 'Manor.Client.List' then
            Related.Add(ContractMgt.RelatedEntry('Manor.Client.List', RelatedClientListLbl));
        if MessageType <> 'Manor.Client.Get' then
            Related.Add(ContractMgt.RelatedEntry('Manor.Client.Get', RelatedClientGetLbl));
        if MessageType <> 'Manor.Project.List' then
            Related.Add(ContractMgt.RelatedEntry('Manor.Project.List', RelatedProjectListLbl));
        if MessageType <> 'Manor.Project.Get' then
            Related.Add(ContractMgt.RelatedEntry('Manor.Project.Get', RelatedProjectGetLbl));
        if MessageType <> 'Manor.Activity.List' then
            Related.Add(ContractMgt.RelatedEntry('Manor.Activity.List', RelatedActivityListLbl));
    end;

    /// <summary>Builds the examples chapter. List types show an empty result; the Mock environment answers it.</summary>
    /// <param name="MessageType">The message type name.</param>
    /// <returns>The examples.</returns>
    procedure GetExamples(MessageType: Text) Examples: JsonArray
    var
        ContractMgt: Codeunit "Msg Contract Mgt ori";
        ListName: Text;
        RequestTxt: Label '{"type":"%1","data":{},"lcid":1033}', Locked = true;
        ResponseTxt: Label '{"status":"Success","data":{"%1":[],"page":1,"perPage":100,"lastPage":1,"total":0,"count":0,"hasMore":false}}', Locked = true;
    begin
        case MessageType of
            'Manor.Client.List':
                ListName := 'clients';
            'Manor.Project.List':
                ListName := 'projects';
            else
                exit;
        end;
        Examples.Add(ContractMgt.Example(ExampleEmptyTitleLbl, StrSubstNo(RequestTxt, MessageType), StrSubstNo(ResponseTxt, ListName)));
    end;

    /// <summary>Builds the overview text.</summary>
    /// <param name="MessageType">The message type name.</param>
    /// <returns>The overview.</returns>
    procedure GetOverview(MessageType: Text): Text
    begin
        case MessageType of
            'Manor.Client.List':
                exit(OverviewClientListLbl);
            'Manor.Client.Get':
                exit(OverviewClientGetLbl);
            'Manor.Project.List':
                exit(OverviewProjectListLbl);
            'Manor.Project.Get':
                exit(OverviewProjectGetLbl);
            'Manor.Activity.List':
                exit(OverviewActivityListLbl);
        end;
    end;

    /// <summary>Builds the notes text.</summary>
    /// <param name="MessageType">The message type name.</param>
    /// <returns>The notes.</returns>
    procedure GetNotes(MessageType: Text): Text
    begin
        case MessageType of
            'Manor.Client.List', 'Manor.Client.Get':
                exit(NotesClientLbl);
            'Manor.Project.List', 'Manor.Project.Get':
                exit(NotesProjectLbl);
            'Manor.Activity.List':
                exit(NotesActivityLbl);
        end;
    end;
}
