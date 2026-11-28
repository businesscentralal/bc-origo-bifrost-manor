namespace Origo.Bifrost.Manor;

using Origo.Bifrost;

/// <summary>Executes and documents Manor.TimeEntry.List.</summary>
codeunit 10035666 "Mnr Time List Impl ori" implements "Msg Interface ori", "Msg Discovery ori", "Msg Contract ori"
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
        DescriptionLbl: Label 'Lists visible time entries for one project. The date filter is one day; invoiced state is not returned.', Comment = 'is-IS=Sýnir sýnilegar tímafærslur eins verks. Dagsetningarsía nær yfir einn dag; reikningsstaða fylgir ekki.';
    begin
        exit(DescriptionLbl);
    end;

    /// <summary>GetKeywords: message execution or contract chapter.</summary>
    procedure GetKeywords(): Text
    var
        KeywordsLbl: Label 'time entries, project hours, billable time', Comment = 'is-IS=tímafærslur, verktímar, tímar til greiðslu';
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
        QueryBuilder: Codeunit "Manor Query Builder ori";
        Request: JsonObject;
        AllowedParameters: Text;
        Path: Text;
    begin
        Argument.AssertIsLicensed();
        Argument.AssertVersion1();
        Request := Argument.GetRequestJson();
        AllowedParameters := ',projectId,userId,date,updatedSince,perPage,maxPages,';
        ValidateKeys(Request, AllowedParameters);
        Path := '/project/' + Format(ReadInteger(Request, 'projectId', true, 1, 2147483647, 0), 0, 9) + '/time';
        if Request.Contains('userId') then
            QueryBuilder.Add('user_id', ReadInteger(Request, 'userId', false, 1, 2147483647, 0));
        AddDate(Request, QueryBuilder, 'date', 'date', false);
        AddDateTime(Request, QueryBuilder, 'updatedSince', 'updated_since', false);
        ReadList(Request, Argument, Path, QueryBuilder, false, '');
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
        Parameters.Add(ReadMgt.Parameter('userId', 'integer', false, ReadMgt.ParameterDescription('userId', false)));
        Parameters.Add(ReadMgt.Parameter('date', 'string', false, ReadMgt.ParameterDescription('date', false)));
        Parameters.Add(ReadMgt.Parameter('updatedSince', 'string', false, ReadMgt.ParameterDescription('updatedSince', false)));
        Parameters.Add(ReadMgt.Parameter('perPage', 'integer', false, ReadMgt.ParameterDescription('perPage', false)));
        Parameters.Add(ReadMgt.Parameter('maxPages', 'integer', false, ReadMgt.ParameterDescription('maxPages', false)));
        exit(true);
    end;

    /// <summary>GetResponse: message execution or contract chapter.</summary>
    procedure GetResponse(var Response: JsonObject): Boolean
    begin
        SharedResponse(1, Response);
        exit(true);
    end;

    /// <summary>GetErrors: message execution or contract chapter.</summary>
    procedure GetErrors(var Errors: JsonArray): Boolean
    begin
        SharedErrors(Errors);
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
        Example.ReadFrom('{"title":"Manor.TimeEntry.List","request":{"type":"Manor.TimeEntry.List","data":{"projectId":42,"date":"2026-01-15"}},"response":{"status":"Success","data":[],"count":0}}');
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
    begin
        Notes := SharedNotes(1);
        exit(true);
    end;

    // Shared read execution and contract fragments keep the five contracts consistent.

    /// <summary>Reads a complete list, then applies inbound de-duplication and optional status filtering.</summary>
    internal procedure ReadList(Request: JsonObject; var Argument: Record "Message Argument ori"; Path: Text; var QueryBuilder: Codeunit "Manor Query Builder ori"; Inbound: Boolean; Status: Text)
    var
        Response: JsonObject;
        Rows: JsonArray;
        MaxPages: Integer;
    begin
        MaxPages := ReadInteger(Request, 'maxPages', false, 1, 1000, 100);
        QueryBuilder.Add('per_page', ReadInteger(Request, 'perPage', false, 1, 100, 100));
        Rows := ReadPages(Path, QueryBuilder.Build(), MaxPages);
        if Inbound then
            Rows := FilterInbound(Rows, Status);
        Response.Add('data', Rows);
        Response.Add('count', Rows.Count());
        Response.Add('status', 'Success');
        Argument.SetResponseJson(Response);
    end;

    /// <summary>Reads one invoice and preserves canonical resource fields.</summary>
    internal procedure ReadInvoice(Path: Text; var Argument: Record "Message Argument ori")
    var
        Client: Codeunit "Manor Client ori";
        Resource: JsonObject;
        Response: JsonObject;
        Token: JsonToken;
    begin
        if not Resource.ReadFrom(Client.Get(Path, '')) then
            Error(ResponseErr);
        if Resource.Get('data', Token) then begin
            if not Token.IsObject() then
                Error(ResponseErr);
            Resource := Token.AsObject();
        end;
        Response.Add('status', 'Success');
        Response.Add('data', Resource);
        Argument.SetResponseJson(Response);
    end;

    /// <summary>Resolves exactly one of the two invoice selectors.</summary>
    internal procedure InvoicePath(Request: JsonObject): Text
    var
        FirmId: Integer;
        InvoiceNumber: Integer;
    begin
        if Request.Contains('invoiceId') then begin
            if Request.Contains('firmId') or Request.Contains('invoiceNumber') then
                Error(InvoiceSelectorErr);
            exit('/invoice/' + Format(ReadInteger(Request, 'invoiceId', true, 1, 2147483647, 0), 0, 9));
        end;
        FirmId := ReadInteger(Request, 'firmId', true, 1, 2147483647, 0);
        InvoiceNumber := ReadInteger(Request, 'invoiceNumber', true, 1, 2147483647, 0);
        exit('/invoice/' + Format(FirmId, 0, 9) + '/' + Format(InvoiceNumber, 0, 9));
    end;

    /// <summary>Validates the accepted/updated modes before any transport call.</summary>
    internal procedure InboundPath(Request: JsonObject; var QueryBuilder: Codeunit "Manor Query Builder ori"; var Status: Text): Text
    var
        Mode: Text;
    begin
        Mode := ReadText(Request, 'mode', true);
        if not (Mode in ['accepted', 'updated']) then
            Error(ModeErr);
        if Mode = 'updated' then begin
            if Request.Contains('from') or Request.Contains('to') then
                Error(UpdatedFiltersErr);
            AddDateTime(Request, QueryBuilder, 'updatedSince', 'updated_since', true);
            Status := ReadText(Request, 'status', false);
            if Request.Contains('status') and not (Status in ['not_assigned', 'pending', 'accepted', 'rejected']) then
                Error(StatusErr);
        end else begin
            if Request.Contains('status') or Request.Contains('updatedSince') then
                Error(AcceptedFiltersErr);
            AddDate(Request, QueryBuilder, 'from', 'from', true);
            AddDate(Request, QueryBuilder, 'to', 'to', true);
            ValidateDateRange(Request);
        end;
        exit('/inbound-invoice/' + Mode);
    end;

    local procedure ReadPages(Path: Text; QueryText: Text; MaxPages: Integer) Rows: JsonArray
    var
        Client: Codeunit "Manor Client ori";
        PageObject: JsonObject;
        Data: JsonToken;
        Meta: JsonToken;
        Last: JsonToken;
        Row: JsonToken;
        PageNo: Integer;
        LastPage: Integer;
    begin
        PageNo := 1;
        repeat
            Clear(PageObject);
            if not PageObject.ReadFrom(Client.Get(Path, QueryText + '&page=' + Format(PageNo, 0, 9))) then
                Error(ResponseErr);
            if not PageObject.Get('data', Data) then
                Error(ResponseErr);
            if not Data.IsArray() then
                Error(ResponseErr);
            foreach Row in Data.AsArray() do begin
                if not Row.IsObject() then
                    Error(ResponseErr);
                Rows.Add(Row.Clone());
            end;
            LastPage := 1;
            if PageObject.Get('meta', Meta) then begin
                if not Meta.IsObject() then
                    Error(ResponseErr);
                if Meta.AsObject().Get('last_page', Last) then begin
                    if not Last.IsValue() then
                        Error(ResponseErr);
                    if not Evaluate(LastPage, Last.AsValue().AsText(), 9) then
                        Error(ResponseErr);
                    if LastPage < PageNo then
                        Error(ResponseErr);
                end;
            end;
            if (PageNo >= MaxPages) and (PageNo < LastPage) then
                Error(PageLimitErr, MaxPages);
            PageNo += 1;
        until PageNo > LastPage;
    end;

    local procedure FilterInbound(Rows: JsonArray; Status: Text) Result: JsonArray
    var
        ById: JsonObject;
        Row: JsonToken;
        Id: JsonToken;
        State: JsonToken;
        ParameterName: Text;
    begin
        // De-duplicate the complete paged result before filtering: the latest occurrence wins.
        foreach Row in Rows do begin
            if not Row.AsObject().Get('id', Id) then
                Error(ResponseErr);
            if not Id.IsValue() then
                Error(ResponseErr);
            if Id.AsValue().IsNull() then
                Error(ResponseErr);
            ParameterName := Id.AsValue().AsText();
            if ParameterName = '' then
                Error(ResponseErr);
            if ById.Contains(ParameterName) then
                ById.Remove(ParameterName);
            ById.Add(ParameterName, Row.Clone());
        end;
        foreach ParameterName in ById.Keys() do begin
            ById.Get(ParameterName, Row);
            if Status = '' then
                Result.Add(Row)
            else begin
                if not Row.AsObject().Get('status', State) then
                    Error(ResponseErr);
                if not State.IsValue() then
                    Error(ResponseErr);
                if State.AsValue().AsText() = Status then
                    Result.Add(Row);
            end;
        end;
    end;

    /// <summary>Refuses unknown keys, including unsupported time-entry date ranges.</summary>
    internal procedure ValidateKeys(Request: JsonObject; Allowed: Text)
    var
        ParameterName: Text;
    begin
        foreach ParameterName in Request.Keys() do
            if not Allowed.Contains(',' + ParameterName + ',') then
                Error(UnknownParameterErr, ParameterName);
    end;

    local procedure ReadText(Request: JsonObject; ParameterName: Text; Required: Boolean): Text
    var
        Token: JsonToken;
        Raw: Text;
    begin
        if not Request.Get(ParameterName, Token) then begin
            if Required then
                Error(ParameterErr, ParameterName);
            exit('');
        end;
        if not Token.IsValue() then
            Error(ParameterErr, ParameterName);
        if Token.AsValue().IsNull() then
            Error(ParameterErr, ParameterName);
        Token.WriteTo(Raw);
        if CopyStr(Raw, 1, 1) <> '"' then
            Error(ParameterErr, ParameterName);
        if Token.AsValue().AsText() = '' then
            Error(ParameterErr, ParameterName);
        exit(Token.AsValue().AsText());
    end;

    /// <summary>Validates a typed request value before the transport call.</summary>
    internal procedure ReadInteger(Request: JsonObject; ParameterName: Text; Required: Boolean; Minimum: Integer; Maximum: Integer; DefaultValue: Integer): Integer
    var
        Token: JsonToken;
        Value: Integer;
        Raw: Text;
    begin
        if not Request.Get(ParameterName, Token) then begin
            if Required then
                Error(ParameterErr, ParameterName);
            exit(DefaultValue);
        end;
        Token.WriteTo(Raw);
        if DelChr(Raw, '=', '0123456789') <> '' then
            Error(ParameterErr, ParameterName);
        if not Evaluate(Value, Raw, 9) then
            Error(ParameterErr, ParameterName);
        if (Value < Minimum) or (Value > Maximum) then
            Error(ParameterErr, ParameterName);
        exit(Value);
    end;

    /// <summary>Validates a typed request value before the transport call.</summary>
    internal procedure AddDate(Request: JsonObject; var QueryBuilder: Codeunit "Manor Query Builder ori"; ParameterName: Text; QueryKey: Text; Required: Boolean)
    var
        Value: Date;
        Raw: Text;
    begin
        if not Request.Contains(ParameterName) and not Required then
            exit;
        Raw := ReadText(Request, ParameterName, true);
        if not Evaluate(Value, Raw, 9) then
            Error(ParameterErr, ParameterName);
        if (Value = 0D) or (Format(Value, 0, 9) <> Raw) then
            Error(ParameterErr, ParameterName);
        QueryBuilder.Add(QueryKey, Value);
    end;

    /// <summary>Validates a typed request value before the transport call.</summary>
    internal procedure AddDateTime(Request: JsonObject; var QueryBuilder: Codeunit "Manor Query Builder ori"; ParameterName: Text; QueryKey: Text; Required: Boolean)
    var
        Value: DateTime;
        Raw: Text;
    begin
        if not Request.Contains(ParameterName) and not Required then
            exit;
        Raw := ReadText(Request, ParameterName, true);
        if (StrLen(Raw) < 20) or not Raw.EndsWith('Z') or (CopyStr(Raw, 11, 1) <> 'T') then
            Error(ParameterErr, ParameterName);
        if not Evaluate(Value, Raw, 9) then
            Error(ParameterErr, ParameterName);
        if Value = 0DT then
            Error(ParameterErr, ParameterName);
        QueryBuilder.Add(QueryKey, Raw);
    end;

    /// <summary>Validates a typed request value before the transport call.</summary>
    internal procedure ValidateDateRange(Request: JsonObject)
    var
        FromDate: Date;
        ToDate: Date;
    begin
        if not (Request.Contains('from') and Request.Contains('to')) then
            exit;
        Evaluate(FromDate, ReadText(Request, 'from', true), 9);
        Evaluate(ToDate, ReadText(Request, 'to', true), 9);
        if FromDate > ToDate then
            Error(DateRangeErr);
    end;

    /// <summary>Builds a typed parameter with its bounds and allowed values.</summary>
    internal procedure Parameter(Name: Text; JsonType: Text; Required: Boolean; Description: Text) Entry: JsonObject
    var
        Contract: Codeunit "Msg Contract Mgt ori";
        Allowed: JsonArray;
    begin
        Entry := Contract.Parameter(Name, JsonType, Required, Description);
        case Name of
            'mode':
                begin
                    Allowed.Add('accepted');
                    Allowed.Add('updated');
                    Entry.Add('allowed', Allowed);
                end;
            'status':
                begin
                    Allowed.Add('not_assigned');
                    Allowed.Add('pending');
                    Allowed.Add('accepted');
                    Allowed.Add('rejected');
                    Entry.Add('allowed', Allowed);
                end;
            'perPage':
                begin
                    Entry.Add('minimum', 1);
                    Entry.Add('maximum', 100);
                    Entry.Add('default', 100);
                end;
            'maxPages':
                begin
                    Entry.Add('minimum', 1);
                    Entry.Add('maximum', 1000);
                    Entry.Add('default', 100);
                end;
            'date', 'from', 'to':
                Entry.Add('format', 'date');
            'createdSince', 'updatedSince':
                Entry.Add('format', 'date-time');
            else
                if JsonType = 'integer' then
                    Entry.Add('minimum', 1);
        end;
    end;

    /// <summary>Returns a localized parameter description.</summary>
    internal procedure ParameterDescription(Name: Text; Inbound: Boolean): Text
    begin
        if Inbound then
            case Name of
                'updatedSince':
                    exit(BilingualText('UpdatedRequiredTxt'));
                'from':
                    exit(BilingualText('AcceptedFromTxt'));
                'to':
                    exit(BilingualText('AcceptedToTxt'));
            end;
        case Name of
            'projectId':
                exit(BilingualText('ProjectIdTxt'));
            'userId':
                exit(BilingualText('UserIdTxt'));
            'date':
                exit(BilingualText('DateTxt'));
            'updatedSince':
                exit(BilingualText('UpdatedTxt'));
            'firmId':
                exit(BilingualText('FirmIdTxt'));
            'createdSince':
                exit(BilingualText('CreatedTxt'));
            'from':
                exit(BilingualText('FromTxt'));
            'to':
                exit(BilingualText('ToTxt'));
            'invoiceId':
                exit(BilingualText('InvoiceIdTxt'));
            'invoiceNumber':
                exit(BilingualText('InvoiceNumberTxt'));
            'mode':
                exit(BilingualText('ModeTxt'));
            'status':
                exit(BilingualText('StatusTxt'));
            'perPage':
                exit(BilingualText('PerPageTxt'));
            'maxPages':
                exit(BilingualText('MaxPagesTxt'));
        end;
    end;

    /// <summary>Builds the canonical response envelope and entity field descriptions.</summary>
    internal procedure SharedResponse(Kind: Integer; var Response: JsonObject)
    var
        Contract: Codeunit "Msg Contract Mgt ori";
        Fields: JsonArray;
        Children: JsonArray;
        DataField: JsonObject;
    begin
        Fields.Add(Contract.ResponseField('status', 'string', BilingualText('SuccessTxt')));
        if Kind <> 4 then
            Fields.Add(Contract.ResponseField('count', 'integer', BilingualText('CountTxt')));
        if Kind = 4 then
            DataField := Contract.ResponseField('data', 'object', BilingualText('CanonicalTxt'))
        else
            DataField := Contract.ResponseField('data', 'array', BilingualText('CanonicalTxt'));
        case Kind of
            1:
                begin
                    Children.Add(Contract.ResponseField('description', 'string', BilingualText('DescriptionTxt')));
                    Children.Add(Contract.ResponseField('internal_note', 'string', BilingualText('InternalNoteTxt')));
                    Children.Add(Contract.ResponseField('hours', 'number', BilingualText('HoursTxt')));
                    Children.Add(Contract.ResponseField('billable_hours', 'number', BilingualText('BillableHoursTxt')));
                end;
            2:
                begin
                    Children.Add(Contract.ResponseField('price', 'number', BilingualText('PriceTxt')));
                    Children.Add(Contract.ResponseField('quantity', 'number', BilingualText('QuantityTxt')));
                    Children.Add(Contract.ResponseField('billable_quantity', 'number', BilingualText('BillableQuantityTxt')));
                    Children.Add(Contract.ResponseField('custom_discount', 'number', BilingualText('DiscountTxt')));
                end;
            3, 4:
                begin
                    Children.Add(Contract.ResponseField('is_credit', 'boolean', BilingualText('CreditTxt')));
                    Children.Add(Contract.ResponseField('original_invoice_number', 'integer', BilingualText('OriginalInvoiceTxt')));
                    Children.Add(Contract.ResponseField('currency_code', 'string', BilingualText('CurrencyTxt')));
                    Children.Add(Contract.ResponseField('exchange_rate', 'number', BilingualText('ExchangeRateTxt')));
                    Children.Add(Contract.ResponseField('invoice_lines', 'array', BilingualText('LinesTxt')));
                end;
            5:
                Children.Add(Contract.ResponseField('status', 'string', BilingualText('StatusTxt')));
        end;
        DataField.Add('children', Children);
        Fields.Add(DataField);
        Response.Add('contentType', 'text/json');
        Response.Add('fields', Fields);
    end;

    /// <summary>Builds bilingual error guidance without upstream error bodies.</summary>
    internal procedure SharedErrors(var Errors: JsonArray)
    var
        Entry: JsonObject;
    begin
        Entry.Add('error', BilingualText('ErrorsTxt'));
        Entry.Add('when', BilingualText('ErrorWhenTxt'));
        Entry.Add('fix', BilingualText('ErrorFixTxt'));
        Errors.Add(Entry);
    end;

    /// <summary>Returns bilingual lifecycle and pagination notes.</summary>
    internal procedure SharedNotes(Kind: Integer): Text
    begin
        case Kind of
            1:
                exit(BilingualText('PagingTxt') + ' ' + BilingualText('TimeNotesTxt'));
            2:
                exit(BilingualText('PagingTxt') + ' ' + BilingualText('ProductNotesTxt'));
            3, 4:
                exit(BilingualText('PagingTxt') + ' ' + BilingualText('InvoiceNotesTxt'));
            5:
                exit(BilingualText('PagingTxt') + ' ' + BilingualText('InboundNotesTxt'));
        end;
    end;

    local procedure BilingualText(TextKey: Text): Text
    var
        SavedLanguageId: Integer;
        EnglishText: Text;
        IcelandicText: Text;
    begin
        // Foundation deliberately builds contract chapters in English. Include the Icelandic
        // wording explicitly so both versions survive that canonical-language boundary.
        SavedLanguageId := GlobalLanguage();
        GlobalLanguage(1033);
        EnglishText := ContractText(TextKey);
        GlobalLanguage(1039);
        IcelandicText := ContractText(TextKey);
        GlobalLanguage(SavedLanguageId);
        exit(EnglishText + ' / ' + IcelandicText);
    end;

    local procedure ContractText(TextKey: Text): Text
    begin
        case TextKey of
            'ProjectIdTxt':
                exit(ProjectIdTxt);
            'UserIdTxt':
                exit(UserIdTxt);
            'DateTxt':
                exit(DateTxt);
            'UpdatedTxt':
                exit(UpdatedTxt);
            'UpdatedRequiredTxt':
                exit(UpdatedRequiredTxt);
            'CreatedTxt':
                exit(CreatedTxt);
            'FirmIdTxt':
                exit(FirmIdTxt);
            'InvoiceIdTxt':
                exit(InvoiceIdTxt);
            'InvoiceNumberTxt':
                exit(InvoiceNumberTxt);
            'ModeTxt':
                exit(ModeTxt);
            'StatusTxt':
                exit(StatusTxt);
            'FromTxt':
                exit(FromTxt);
            'ToTxt':
                exit(ToTxt);
            'AcceptedFromTxt':
                exit(AcceptedFromTxt);
            'AcceptedToTxt':
                exit(AcceptedToTxt);
            'PerPageTxt':
                exit(PerPageTxt);
            'MaxPagesTxt':
                exit(MaxPagesTxt);
            'SuccessTxt':
                exit(SuccessTxt);
            'CountTxt':
                exit(CountTxt);
            'CanonicalTxt':
                exit(CanonicalTxt);
            'DescriptionTxt':
                exit(DescriptionTxt);
            'InternalNoteTxt':
                exit(InternalNoteTxt);
            'HoursTxt':
                exit(HoursTxt);
            'BillableHoursTxt':
                exit(BillableHoursTxt);
            'PriceTxt':
                exit(PriceTxt);
            'QuantityTxt':
                exit(QuantityTxt);
            'BillableQuantityTxt':
                exit(BillableQuantityTxt);
            'DiscountTxt':
                exit(DiscountTxt);
            'CreditTxt':
                exit(CreditTxt);
            'OriginalInvoiceTxt':
                exit(OriginalInvoiceTxt);
            'CurrencyTxt':
                exit(CurrencyTxt);
            'ExchangeRateTxt':
                exit(ExchangeRateTxt);
            'LinesTxt':
                exit(LinesTxt);
            'ErrorsTxt':
                exit(ErrorsTxt);
            'ErrorWhenTxt':
                exit(ErrorWhenTxt);
            'ErrorFixTxt':
                exit(ErrorFixTxt);
            'PagingTxt':
                exit(PagingTxt);
            'TimeNotesTxt':
                exit(TimeNotesTxt);
            'ProductNotesTxt':
                exit(ProductNotesTxt);
            'InvoiceNotesTxt':
                exit(InvoiceNotesTxt);
            'InboundNotesTxt':
                exit(InboundNotesTxt);
        end;
    end;

    var
        ParameterErr: Label 'Invalid or missing parameter: %1.', Comment = '%1 = parameter name; is-IS=Ógild eða ótilgreind stika: %1.';
        UnknownParameterErr: Label 'Unknown parameter: %1.', Comment = '%1 = parameter name; is-IS=Óþekkt stika: %1.';
        InvoiceSelectorErr: Label 'Supply invoiceId alone, or both firmId and invoiceNumber.', Comment = 'is-IS=Tilgreindu aðeins invoiceId eða bæði firmId og invoiceNumber.';
        ModeErr: Label 'mode must be accepted or updated.', Comment = 'is-IS=mode verður að vera accepted eða updated.';
        StatusErr: Label 'status must be not_assigned, pending, accepted or rejected.', Comment = 'is-IS=status verður að vera not_assigned, pending, accepted eða rejected.';
        UpdatedFiltersErr: Label 'Updated mode uses updatedSince, not from or to.', Comment = 'is-IS=Uppfærsluhamur notar updatedSince, ekki from eða to.';
        AcceptedFiltersErr: Label 'Accepted mode uses from and to; status and updatedSince are not supported.', Comment = 'is-IS=Samþykktarhamur notar from og to; status og updatedSince eru ekki studd.';
        ResponseErr: Label 'Manor returned an invalid read response.', Comment = 'is-IS=Manor skilaði ógildu lestrarsvari.';
        PageLimitErr: Label 'Manor has more than %1 pages. Narrow the filters or increase maxPages; no partial result was returned.', Comment = '%1 = page limit; is-IS=Manor hefur fleiri en %1 blaðsíður. Þrengdu síur eða hækkaðu maxPages; engin ófullkomin niðurstaða var skilað.';
        DateRangeErr: Label 'from must be on or before to.', Comment = 'is-IS=from verður að vera á undan eða sama dag og to.';
        ProjectIdTxt: Label 'Positive Manor project id.', Comment = 'is-IS=Jákvætt auðkenni verks í Manor.';
        UserIdTxt: Label 'Optional positive Manor user id, sent as user_id.', Comment = 'is-IS=Valfrjálst jákvætt notandaauðkenni í Manor, sent sem user_id.';
        DateTxt: Label 'One day, YYYY-MM-DD. Sent directly to Manor. For several days, call once per day.', Comment = 'is-IS=Einn dagur, YYYY-MM-DD. Sent beint til Manor. Fyrir marga daga, kallaðu einu sinni á dag.';
        UpdatedTxt: Label 'ISO 8601 UTC timestamp ending in Z, sent as updated_since.', Comment = 'is-IS=ISO 8601 UTC-tímastimpill sem endar á Z, sendur sem updated_since.';
        UpdatedRequiredTxt: Label 'Required in updated mode: ISO 8601 UTC timestamp ending in Z. Inclusive updated_since.', Comment = 'is-IS=Skylda í uppfærsluham: ISO 8601 UTC-tímastimpill sem endar á Z. updated_since er með upphafsgildi.';
        CreatedTxt: Label 'ISO 8601 UTC timestamp ending in Z, sent as created_since.', Comment = 'is-IS=ISO 8601 UTC-tímastimpill sem endar á Z, sendur sem created_since.';
        FirmIdTxt: Label 'Positive Manor firm id. Invoice.Get requires this with invoiceNumber, unless invoiceId is used.', Comment = 'is-IS=Jákvætt auðkenni stofu í Manor. Invoice.Get krefst þess með invoiceNumber nema invoiceId sé notað.';
        InvoiceIdTxt: Label 'Positive invoice id; mutually exclusive with firmId and invoiceNumber.', Comment = 'is-IS=Jákvætt reikningsauðkenni; má ekki nota með firmId eða invoiceNumber.';
        InvoiceNumberTxt: Label 'Positive invoice number. Requires firmId, without invoiceId.', Comment = 'is-IS=Jákvætt reikningsnúmer. Krefst firmId, án invoiceId.';
        ModeTxt: Label 'accepted or updated. Requires manage_inbound_invoices in Manor.', Comment = 'is-IS=accepted eða updated. Krefst manage_inbound_invoices í Manor.';
        StatusTxt: Label 'Updated mode only: not_assigned (unassigned), pending (awaiting approval), accepted (approved), rejected (refused). Filtered in BC after de-duplication. Omit for all statuses.', Comment = 'is-IS=Aðeins í uppfærsluham: not_assigned (óúthlutað), pending (bíður samþykktar), accepted (samþykkt), rejected (hafnað). Síað í BC eftir að tvítekningar eru fjarlægðar. Sleppt fyrir allar stöður.';
        FromTxt: Label 'Start date, YYYY-MM-DD, sent as from.', Comment = 'is-IS=Upphafsdagur, YYYY-MM-DD, sendur sem from.';
        ToTxt: Label 'End date, YYYY-MM-DD, sent as to. Must not precede from.', Comment = 'is-IS=Lokadagur, YYYY-MM-DD, sendur sem to. Má ekki vera á undan from.';
        AcceptedFromTxt: Label 'Required in accepted mode: start date, YYYY-MM-DD.', Comment = 'is-IS=Skylda í samþykktarham: upphafsdagur, YYYY-MM-DD.';
        AcceptedToTxt: Label 'Required in accepted mode: end date, YYYY-MM-DD; must not precede from.', Comment = 'is-IS=Skylda í samþykktarham: lokadagur, YYYY-MM-DD; má ekki vera á undan from.';
        PerPageTxt: Label 'Rows per upstream page, 1..100; default 100. All pages are read.', Comment = 'is-IS=Færslur á síðu í Manor, 1..100; sjálfgefið 100. Allar síður eru lesnar.';
        MaxPagesTxt: Label 'Maximum pages, 1..1000; default 100. Exceeding the limit fails without returning partial data.', Comment = 'is-IS=Hámarksfjöldi síðna, 1..1000; sjálfgefið 100. Ef mörkum er náð er villu skilað án ófullkominna gagna.';
        SuccessTxt: Label 'Success.', Comment = 'is-IS=Tókst.';
        CountTxt: Label 'Number of returned rows after local filtering and de-duplication where applicable.', Comment = 'is-IS=Fjöldi skilaðra færslna eftir staðbundna síun og fjarlægingu tvítekninga þar sem við á.';
        CanonicalTxt: Label 'Manor JSON with canonical field names, preserved without legacy alias mapping.', Comment = 'is-IS=JSON frá Manor með gildandi reitaheitum, varðveitt án vörpunar á eldri samheiti.';
        DescriptionTxt: Label 'Text printed on the work report.', Comment = 'is-IS=Texti í vinnuskýrslu.';
        InternalNoteTxt: Label 'Internal note, never printed on invoices or work reports.', Comment = 'is-IS=Innri athugasemd, aldrei birt á reikningum eða vinnuskýrslum.';
        HoursTxt: Label 'Recorded hours.', Comment = 'is-IS=Skráðir tímar.';
        BillableHoursTxt: Label 'Billable hours; may be less than hours.', Comment = 'is-IS=Tímar til greiðslu; geta verið færri en skráðir tímar.';
        PriceTxt: Label 'Special unit price when set.', Comment = 'is-IS=Sérverð á einingu þegar tilgreint.';
        QuantityTxt: Label 'Quantity; negative quantities can deduct prepayments on a final invoice.', Comment = 'is-IS=Magn; neikvætt magn getur dregið fyrirframgreiðslur frá lokareikningi.';
        BillableQuantityTxt: Label 'Quantity to bill.', Comment = 'is-IS=Magn til greiðslu.';
        DiscountTxt: Label 'Discount percentage.', Comment = 'is-IS=Afsláttarprósenta.';
        CreditTxt: Label 'True for a credit note.', Comment = 'is-IS=Satt fyrir kreditreikning.';
        OriginalInvoiceTxt: Label 'Original invoice number for a credit note.', Comment = 'is-IS=Númer upphaflegs reiknings fyrir kreditreikning.';
        CurrencyTxt: Label 'Client currency.', Comment = 'is-IS=Gjaldmiðill viðskiptamanns.';
        ExchangeRateTxt: Label 'Exchange rate against the firm default currency.', Comment = 'is-IS=Gengi miðað við sjálfgefinn gjaldmiðil stofunnar.';
        LinesTxt: Label 'Invoice lines may be itemised or summarised by rate; summarised lines do not identify individual time entries.', Comment = 'is-IS=Reikningslínur geta verið sundurliðaðar eða teknar saman eftir taxta; samanteknar línur auðkenna ekki einstakar tímafærslur.';
        ErrorsTxt: Label 'Invalid/missing input; HTTP 401/403 (key or permissions), 404 (not found), 422 (validation).', Comment = 'is-IS=Ógild/ótilgreind gögn; HTTP 401/403 (lykill eða heimildir), 404 (fannst ekki), 422 (gagnaprófun).';
        ErrorWhenTxt: Label 'Validation runs before transport. Manor errors are mapped by the shared client; no credentials or upstream response body are included.', Comment = 'is-IS=Gagnaprófun fer fram fyrir flutning. Sameiginlegur biðlari varpar Manor-villum; engar aðgangsupplýsingar eða hrátt villusvar fylgja.';
        ErrorFixTxt: Label 'Check parameters. For products grant manage_products; for inbound invoices grant manage_inbound_invoices. Check key permissions for 401/403, the identifier for 404 and input for 422.', Comment = 'is-IS=Athugaðu stikur. Fyrir vörur veittu manage_products; fyrir innkaupareikninga manage_inbound_invoices. Athugaðu lykilheimildir fyrir 401/403, auðkenni fyrir 404 og gögn fyrir 422.';
        PagingTxt: Label 'Lists read all pages, preserving canonical JSON. perPage defaults to 100 (1..100); maxPages defaults to 100 (1..1000). The page limit fails without partial results. Unknown parameters are refused.', Comment = 'is-IS=Listar lesa allar síður og varðveita gildandi JSON. perPage er sjálfgefið 100 (1..100); maxPages er sjálfgefið 100 (1..1000). Síðutakmörk valda villu án ófullkominna niðurstaðna. Óþekktum stikum er hafnað.';
        TimeNotesTxt: Label 'Only entries visible to the key user are returned; limited project access may show only own entries. No invoiced flag is returned, so billed and unbilled time cannot be distinguished. Invoiced entries are locked in Manor; payroll confirmation does not lock them. No date range: call once per day.', Comment = 'is-IS=Aðeins færslum sem notandi lykilsins má sjá er skilað; takmarkaður verkaaðgangur getur aðeins sýnt eigin færslur. Engin reikningsstaða fylgir svo ekki má greina reikningsfært frá óreikningsfærðu. Reikningsfærðar færslur eru læstar í Manor; launastaðfesting læsir þeim ekki. Ekkert dagabil: kallaðu einu sinni á dag.';
        ProductNotesTxt: Label 'Requires manage_products in Manor. Negative quantities are valid. price is a special unit price; custom_discount is a percentage.', Comment = 'is-IS=Krefst manage_products í Manor. Neikvætt magn er gilt. price er sérverð á einingu; custom_discount er prósenta.';
        InvoiceNotesTxt: Label 'Beta: Manor may change this endpoint contract. Only invoices visible to the key user are returned. One invoice has one payer; summarised lines do not map to individual time entries. is_credit identifies credit notes; original_invoice_number references the original invoice. Invoice.Get uses invoiceId alone or firmId with invoiceNumber.', Comment = 'is-IS=Beta: Manor getur breytt samningi endapunktsins. Aðeins reikningum sem notandi lykilsins má sjá er skilað. Einn reikningur hefur einn greiðanda; samanteknar línur tengjast ekki einstökum tímafærslum. is_credit auðkennir kreditreikninga; original_invoice_number vísar á upphaflegan reikning. Invoice.Get notar aðeins invoiceId eða firmId með invoiceNumber.';
        InboundNotesTxt: Label 'Requires manage_inbound_invoices. Updated mode is inclusive: duplicate ids across pages collapse to the last occurrence before optional status filtering in BC. Without status all states are returned. Poll from the last updated_at and de-duplicate ids across separate calls too. Accepted mode requires from/to and does not accept status or updatedSince.', Comment = 'is-IS=Krefst manage_inbound_invoices. Uppfærsluhamur tekur upphafsgildi með: tvítekin auðkenni á síðum falla saman í síðustu færslu áður en valfrjáls stöðusía er keyrð í BC. Án status fylgja allar stöður. Sæktu frá síðasta updated_at og fjarlægðu tvítekin auðkenni milli aðskildra kalla líka. Samþykktarhamur krefst from/to og tekur ekki við status eða updatedSince.';
}
