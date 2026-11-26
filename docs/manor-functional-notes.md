# Manor functional notes for Bifrost Manor

Read on 26.11.2026 from the public pages of https://www.manor.is/, the public knowledge base at https://adstod.manor.is/ and
the public API reference at https://api.manor.is/ (OpenAPI 3.1, version 1.0.3).
No account was used, no form was submitted and Manor was not contacted. Everything here is our own summary.
Short UI terms in *italics* are Manor's own Icelandic labels. Each point cites its source as `[S1]`, `[K3]` and so on;
the list of sources is at the end.

This file complements [manor-api-summary.md](manor-api-summary.md). That file describes the API surface. This one describes
what the entities mean in Manor's workflow, so that the message-type contracts (#3–#7) and the help (#9) can explain how to call
them safely.

## What the public sources cover, and where they are silent

- The knowledge base is Icelandic. The English part of it has only two articles: "Segments" and "Pricing overview" [K0].
  The English marketing pages use "cases and projects", "time entries", "invoices" and "work reports" [S2].
- Covered well: recording time, products, mileage and expenses; matters (create, close, delete, numbering, categories);
  work items; clients; rates, price list and special terms; issuing invoices; currencies; roles; retainers.
- Silent: rounding of hours beyond the 15-minute default unit, how `billable_hours` is priced, any approval or lock
  step other than invoicing, inbound (supplier) invoices, credit notes, invoice numbering, the "Beta" invoice API,
  what happens to an entry when its user is disabled, and the meaning of `labels`.
- api.manor.is links only to the knowledge base and to www.manor.is. It mentions release notes but gives no link,
  and it has no guides beyond the reference itself [A].

## Vocabulary: API term, Manor UI term (Icelandic) and English

| API term | Manor UI (is-IS) | English to use in Bifröst | Source |
| --- | --- | --- | --- |
| project | *Mál / Verk* (matter / project; the UI uses both) | Project (matter) | [K4], [K6] |
| project `identifier` | *Ytra málsnúmer* (external matter number; label set per instance) | External number | [K9], [K10] |
| project number (auto) | *Málsnúmer* / *Verknúmer* | Project number | [K10] |
| activity (legacy `segment`) | *Verkþáttur*, plural *Verkþættir* | Activity (work item) | [S3], [K11], [K0] |
| client | *Viðskiptavinur* | Client | [K12] |
| `national_id` | *Kennitala* | National ID (kennitala) | [K12] |
| time entry | *Tímafærsla*; the menu is *Tímar* | Time entry | [K1] |
| `hours` / `billable_hours` | *Lengd* / *Til greiðslu* | Hours / Billable hours | [K1] |
| time `description` | *Texti í vinnuskýrslu* | Description (shown on the work report) | [K1] |
| `internal_note` | *Innri athugasemd* | Internal note | [K1] |
| product | *Vara* (rate type *Söluvara*) | Product | [K2], [K16] |
| `quantity` / `billable_quantity` / `price` | *Magn* / *Magn til greiðslu* / *Sérverð* | Quantity / Billable quantity / Special price | [K2] |
| expense | *Kostnaður* | Expense | [K3] |
| expense `amount` / `billable_amount` | *Upphæð* / *Upphæð til greiðslu* | Amount / Billable amount | [K3] |
| expense `recipient` / `paid_at` / `vat_rate_id` | *Viðtakandi* / *Greitt þann* / *VSK flokkur* | Recipient / Paid on / VAT category | [K3] |
| mileage (rate type `travel`) | *Akstur* | Mileage | [K15] |
| rate | *Taxti*, plural *Taxtar* | Rate | [K16] |
| price list | *Verðskrá* | Price list | [K16] |
| special terms (client or project) | *Sérkjör* (button *Kjör*) | Special terms | [K17], [K18] |
| project `owner` | *Ábyrgðarmaður* | Owner (responsible person) | [K5] |
| participant | *Þátttakandi* | Participant | [K5] |
| project `subject_to_vat` | *Innheimta virðisaukaskatt* | Subject to VAT | [K5], [K24] |
| project `billing` | *Reikningagerð* (*virk*, *Hlé á reikningagerð*, *Innanhúsmál*) | Billing | [K5] |
| project budget | *Kostnaðaráætlun* | Budget | [K5], [K25] |
| activity `budget` / `time_budget` | *Áætlun* (in amounts or hours) | Budget / Time budget | [S3], [K11] |
| matter category | *Málaflokkur* | Category | [K8] |
| payer | *Greiðandi* (default *Sami og viðskiptavinur*) | Payer | [K1], [K14] |
| contact | *Tengiliður* | Contact | [K13] |
| invoice | *Reikningur*; action *Gefa út reikning* | Invoice; issue an invoice | [K19] |
| unbilled / invoiced | *Óreikningsfært* / *Reikningsfært* | Unbilled / Invoiced | [K20], [K19] |
| work report | *Vinnuskýrsla* | Work report | [K19], [K11] |
| payment term | *Greiðslufrestur* | Payment term | [K12] |
| due date / final due date | *Gjalddagi* / *Eindagi* | Due date / Final due date | [K23] |
| retainer | *Samningur* (*Fastir samningar*) | Retainer (fixed contract) | [K22], [S1] |
| user | *Notandi* | User | [K26] |
| department | *Deild* | Department | [K26] |
| role | *Hlutverk* (*Notandi*, *Stjórnandi*, *Kerfisstjóri*) | Role | [K27] |
| currency | *Gjaldmiðill* | Currency | [K12], [K28] |
| inbound invoice | not covered on the site | Inbound invoice | none |

## Firms and users (#3)

- **Firm.** The issuing company inside the instance. It holds the default currency, the default VAT rate and the Peppol
  identifier [A]. In the UI, the general payment term is set on the company (*Stjórnun → Fyrirtæki*) [K23].
- **Users.** Each user has a name, initials, email (also the login), language, phone, a department, a daily hours goal and
  one or more roles [K26]. Built-in roles: *Notandi* works only on projects where they are a participant; *Stjórnandi*
  works on all projects, manages rates, issues invoices and sees reports; *Kerfisstjóri* changes other users' access [K27].
  Custom roles can be built from individual permissions [K27].
- **Enabled users.** The API's `User` has `enabled`, and time entries can only be created for enabled users [A].
  The site does not describe disabling users.
- **Useful filters.** `GET /user` also filters by `approves_invoices` (may approve inbound invoices) and `owns_projects`
  (may be a project owner) [A]. The owner of a new project must be such a user.
- **The API key acts as its user.** List types return only what that user may see, for example time entries
  "accessible to the authenticated user" and invoices "visible to the current user" [A]. A short list is not proof that
  nothing else exists.

## Rates and pricing (#3)

- **Rate types.** API: `time`, `travel`, `product`, `per_diem` [A]. UI: *Vinna* (hourly, rate × hours), *Akstur*
  (per km), *Söluvara* (fixed price per unit) [K16].
- **Two set-ups.** A firm either has one rate per employee, named after the user and used automatically, or role-based
  rates (partner, associate, student) that staff must pick when they record time [K16], [K29].
- **Price resolution.** The general price list is overridden by client special terms, which are overridden by project
  special terms. Each level can set a fixed price and a discount percentage, and the fixed price is applied first [K17], [K18].
  Changing special terms reprices all *unbilled* entries from that moment [K17], [K18].
- **Consequence for agents.** `GET /rate` returns `price` (base) and `latest_price` (current price period) [A]. It does
  **not** return client or project special terms, so a rate's price is not necessarily what the client is charged.
  The API offers no read of special terms.
- **Currencies.** ISK is the base. Each client has one currency, used for all its projects and invoices. Manor fetches
  daily exchange rates from the Central Bank of Iceland [K28], [K12]. A rate can carry a fixed price per foreign currency [K16].
- **Permission.** `GET /rate` needs `manage_rates` [A]. In the UI, working with rates belongs to the *Stjórnandi* role [K27].

## Clients (#4, #6)

- **Meaning.** The party the projects are run for, and by default the payer of every entry on its projects [K14].
- **Fields in practice.** The UI requires only the name and the currency [K12]. The API requires `name`, `national_id`
  and `currency_code` (and documents `address` and `billing_address` as required in the request body) [A].
  With a valid Icelandic kennitala the UI can fetch the company from the national registry [K12].
- **Foreign clients.** They usually have no kennitala. Any number is accepted, with a warning in the UI, but it must
  match the number the accounting system uses. Some accounting systems need a ten-digit number starting with 99 [K30], [K31].
- **Currency is a strong setting.** It is set once per client and governs all its projects and invoices [K12], [K31].
- **Billing address** falls back to `address` when it is not set [A]. The UI has a "same as address" checkbox [K12].
- **Special attention** (*Sérstök athygli*) flags a client, for example for overdue debt. Users see a warning when they
  record time for that client's projects, but they are not blocked [K12].
- **Not in the API:** payment term, invoice comment and invoice layout are client settings in the UI [K12] but are not
  client fields in the API [A].
- **Deleting a client** keeps its projects and unbilled time, and Manor support can restore it [K32]. Bifrost exposes no
  delete type in any case.

## Projects (matters) (#4, #6)

- **Meaning.** The core unit of work. Time, products, mileage and expenses are recorded on a project [K4].
- **Numbering.** Manor numbers projects automatically in one ascending series. A number is never reused, even after the
  project is deleted [K10]. An optional free-text external number exists; it is not unique [K9]. In the API this is
  `identifier`, which is read-only in the project body [A].
- **Create.** API: `name` and `owner` are required [A]. UI: every project needs a responsible person (*Ábyrgðarmaður*),
  who must also be a participant and who can issue invoices [K5]. Client and categories are optional [K5], [K8].
- **Billing setting.** API `billing`: `enabled` (default), `internal` (never billed) or `sensitive` (internal, and
  entries hidden from users without that permission) [A]. The UI shows active, paused (*Hlé á reikningagerð*) and
  internal (*Innanhúsmál*) [K5]. Paused has no API value, and the site does not say how the API reports it.
  Entries on an excluded project stay on it, but cannot be invoiced until billing is switched back on [K21].
- **VAT.** `subject_to_vat` decides whether VAT is added when the project is invoiced, and it must be right for invoicing
  to work [K5], [K24]. API default is false, except when the instance always applies VAT and client and owner are in the
  same country [A].
- **Closing.** Closing (API `open=false` with `closing_comment`) stops new entries of every type for everyone. Unbilled
  entries stay and still show as unbilled. Nothing is deleted. In the UI only the responsible person can reopen [K7], [A].
- **Budget.** The project budget is an amount compared with all unbilled items. Going over it warns users and emails the
  owner, but never blocks entries [K25], [K5].
- **Settlement projects.** `settlement` is ignored on save, and activities cannot be created or updated in a settlement
  project (HTTP 400) [A]. The site does not explain settlement projects.
- **Retainers.** While a fixed contract is active, entries on the client's projects are tied to the contract and billed
  through it, not as an ordinary balance [K22].

## Activities (work items) (#4, #6)

- **Meaning.** A project can be split into work items, each with an optional budget in hours or in money. Manor shows
  live progress against the budget [S3], [K11].
- **Effect on output.** Work reports and invoices are split by work item, and a user can invoice one work item or several
  at a time [K11], [K33].
- **Entries.** Entries can be assigned to a work item and moved between work items [K11]. The site does not say whether
  a work item is mandatory, or whether a closed work item accepts entries.
- **API rules.** Only `name` is required. `internal` work items are not billed. Sub-activities inherit payer, framework
  agreement, `internal` and closed status from their ancestors. Budgets cannot overlap between an activity and its
  ancestors or sub-activities, and must be at least 1. `ends_at` must be after `begins_at`. An activity cannot move to
  another project [A]. Some firms do not accept entries directly on an activity that has sub-activities [A].
- **Permission.** Reading activities needs `manage_activities` [A].

## Time entries (#5, #7)

- **Meaning.** Hours a user worked on a project. The description goes on the work report, and more precise text makes
  the invoice less likely to be questioned [K1], [S1].
- **One day per entry.** In the UI a time entry covers one date only. Work over several days is recorded as one entry
  per day [K1].
- **Fields in practice.** UI: project, date, start, end and rate are required, and the length is computed [K1].
  API: `begins_at` (UTC), `hours`, `description` and `user_id` are required. `billable_hours` defaults to `hours`.
  `rate_id` defaults to the user's and project's rate [A].
- **Billable hours.** The billable amount can be lower than the hours worked (the UI's example: two hours worked, one
  billed) [K1]. The site does not say whether it can be higher.
- **Time unit.** The UI snaps entries to a minimum unit, 15 minutes by default, set by an administrator (6 minutes is
  mentioned for UK practice) [K34]. The site does not say whether the API rounds `hours`.
- **Rate.** Defaults to the rate last used on the project. With per-employee rates there is no choice to make [K1], [K16].
- **Payer.** Defaults to the client. Another payer can be set per entry, and each invoice covers one payer [K14].
  The API has no payer field.
- **Lifecycle.** Unbilled → invoiced. An entry can be edited, and its project changed, until it is invoiced [K1].
  Invoiced entries cannot be edited or moved; deleting the invoice releases them [K19], [K35].
  Manager time confirmation for payroll does **not** lock entries [K36].
- **What the API cannot tell or do.** The `Time` object has no invoiced flag, and there is no update or delete route
  for time entries [A]. A wrong time entry created through Bifrost must be fixed by a person in Manor.
- **Not allowed on closed projects** [K7]. Users with the special-attention flag on the client see a warning only [K12].
- **Permission.** Creating needs `set_alternative_user_of_times`, and the user must be enabled [A].
- **Mileage** (*Akstur*) is recorded in kilometres against a travel rate [K15]. The API has no mileage route, and the
  product route is for items that are not time, travel or per diem [A].

## Products (#5, #7)

- **Meaning.** A sold item or fixed-price service on a project, priced by a product rate, for example a standard
  company registration [K16], [K2].
- **Fields.** UI: project, description (printed on the invoice), quantity, rate and date are required. Optional:
  billable quantity, special unit price and payer [K2]. API: `date`, `description`, `quantity`, `user_id` and `rate_id`
  are required. `billable_quantity` defaults to `quantity`, `price` defaults to the rate price, and `custom_discount`
  is a percentage [A].
- **Negative quantities** are used in practice to deduct prepayments on the final invoice [K37].
- **Permission.** Both listing and creating products need `manage_products` [A].

## Expenses (#7)

- **Meaning.** Outlays paid on a project, recorded with the supplier and VAT category, and billed on to the payer at
  the billable amount [K3], [K24].
- **Fields.** UI: project, description, currency, amount excluding VAT, optional billable amount, VAT category,
  recipient, paid date, payer [K3]. API: `description`, `amount`, `paid_at` (ISO 8601 with time zone),
  `vat_rate_id` and `paid_in_currency_code` are required [A]. The API has no route to list VAT rates; the firm's
  `default_vat_rate_id` is the only one readable [A].
- **Currency.** An expense keeps its original amount and an ISK amount at the rate of the expense date. On an ISK invoice
  the ISK amount is used; on a foreign-currency invoice it is converted at the invoice date [K38].
- **Delete.** Done in the UI from the project [K39]. Not exposed by Bifrost.
- **Permission.** Creating needs `set_alternative_user_of_expenses` [A].

## Sales invoices (#5)

- **How invoices are made.** A user with invoicing rights opens the list of projects with unbilled items, picks a
  project and a payer, sets the invoice date, ticks the lines and saves. Lines can be edited or moved before saving [K19],
  [K33], [K14]. The site describes no draft or approval step.
- **Layout.** Itemised (every entry, the default) or summarised (one line per rate, with a work report alongside),
  set per project [K40].
- **After issuing.** The entries become invoiced and locked [K19]. With an accounting connection (DK and others) the
  invoice is booked there at once, the client is created or updated there, and e-invoices or bank claims may go out
  automatically [K23]. The site does not cover credit notes; the API shows them as `is_credit` with
  `original_invoice_number` [A].
- **Currency.** The client's currency; the overview converts to ISK at the daily rate [K20], [K31].
- **API status.** The invoice routes are Beta and read-only in Bifrost [A].

## Inbound invoices (#5)

- The site says nothing about inbound (supplier) invoices. From the API: status is `not_assigned`, `pending`, `accepted`
  or `rejected`; an invoice has an assignee and an approver; users with `approves_invoices` can approve; reading needs
  `manage_inbound_invoices` [A].

## Writes that cannot be undone through Bifrost

Bifrost has no delete types, so every create is permanent from the agent's side:

- **Time entry:** no update and no delete route exists [A]. Corrections happen in Manor, and only until the entry is invoiced [K1].
- **Product and expense:** update routes exist but are not in the approved set, so corrections also happen in Manor.
- **Project close:** stops all new entries; only the responsible person reopens it in the UI [K7].
- **Client currency change:** changes the currency of all the client's projects and future invoices [K31].
- **Special terms change** (not exposed) reprices all unbilled entries [K17].

## Sources

- [S1] https://www.manor.is/ (Icelandic home page)
- [S2] https://www.manor.is/overview (English overview)
- [S3] https://www.manor.is/verkthaettir (work items)
- [S4] https://www.manor.is/manor-api (API page: keys made in the admin panel, one API per company)
- [A] https://api.manor.is/ (API reference, version 1.0.3)
- [K0] https://adstod.manor.is/en/support/solutions (English part of the knowledge base)
- [K1] https://adstod.manor.is/is/support/solutions/articles/29000023512 (recording time)
- [K2] https://adstod.manor.is/is/support/solutions/articles/29000023515 (recording a product)
- [K3] https://adstod.manor.is/is/support/solutions/articles/29000024777 (recording an expense)
- [K4] https://adstod.manor.is/is/support/solutions/articles/29000023543 (what a matter is)
- [K5] https://adstod.manor.is/is/support/solutions/articles/29000023541 (creating a matter)
- [K6] https://adstod.manor.is/is/support/solutions/folders/29000054063 (matters folder)
- [K7] https://adstod.manor.is/is/support/solutions/articles/29000023570 (closing a matter)
- [K8] https://adstod.manor.is/is/support/solutions/articles/29000023574 (matter categories)
- [K9] https://adstod.manor.is/is/support/solutions/articles/29000023573 (external matter number)
- [K10] https://adstod.manor.is/is/support/solutions/articles/29000023572 (matter number series)
- [K11] https://adstod.manor.is/is/support/solutions/articles/29000043366 (using work items)
- [K12] https://adstod.manor.is/is/support/solutions/articles/29000023532 (creating a client)
- [K13] https://adstod.manor.is/is/support/solutions/articles/29000023533 (creating a contact)
- [K14] https://adstod.manor.is/is/support/solutions/articles/29000023751 (several payers on one matter)
- [K15] https://adstod.manor.is/is/support/solutions/articles/29000023514 (recording mileage)
- [K16] https://adstod.manor.is/is/support/solutions/articles/29000040652 (setting up the price list)
- [K17] https://adstod.manor.is/is/support/solutions/articles/29000023595 (special terms on a client)
- [K18] https://adstod.manor.is/is/support/solutions/articles/29000023591 (special terms on a matter)
- [K19] https://adstod.manor.is/is/support/solutions/articles/29000023507 (issuing an invoice without an accounting system)
- [K20] https://adstod.manor.is/is/support/solutions/articles/29000023740 (total unbilled)
- [K21] https://adstod.manor.is/is/support/solutions/articles/29000023526 (excluding a matter from invoicing)
- [K22] https://adstod.manor.is/is/support/solutions/articles/29000044226 (retainers)
- [K23] https://adstod.manor.is/is/support/solutions/articles/29000048491 (DK+ connection)
- [K24] https://adstod.manor.is/is/support/solutions/articles/29000023525 (VAT settings)
- [K25] https://adstod.manor.is/is/support/solutions/articles/29000034407 (matter budget)
- [K26] https://adstod.manor.is/is/support/solutions/articles/29000023518 (adding users)
- [K27] https://adstod.manor.is/is/support/solutions/articles/29000023519 (user roles)
- [K28] https://adstod.manor.is/is/support/solutions/articles/29000023531 (currencies)
- [K29] https://adstod.manor.is/is/support/solutions/articles/29000023741 (first price list)
- [K30] https://adstod.manor.is/is/support/solutions/articles/29000023738 (foreign client)
- [K31] https://adstod.manor.is/is/support/solutions/articles/29000023739 (invoicing in a foreign currency)
- [K32] https://adstod.manor.is/is/support/solutions/articles/29000023618 (deleting a client)
- [K33] https://adstod.manor.is/is/support/solutions/articles/29000023750 (invoicing from a matter)
- [K34] https://adstod.manor.is/is/support/solutions/articles/29000023743 (time unit)
- [K35] https://adstod.manor.is/is/support/solutions/articles/29000023746 (moving entries between matters)
- [K36] https://adstod.manor.is/is/support/solutions/articles/29000043619 (manager confirms an employee's time)
- [K37] https://adstod.manor.is/is/support/solutions/articles/29000043043 (prepayments on a matter)
- [K38] https://adstod.manor.is/is/support/solutions/articles/29000044511 (expenses in a foreign currency)
- [K39] https://adstod.manor.is/is/support/solutions/articles/29000024776 (deleting an expense)
- [K40] https://adstod.manor.is/is/support/solutions/articles/29000041485 (invoice layout)
