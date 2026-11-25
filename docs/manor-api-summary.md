# Manor external API: summary for Bifrost Manor

Source: the public reference at https://api.manor.is/ (Manor API, OpenAPI 3.1, version 1.0.3), read 25.11.2026.
Knowledge base: https://adstod.manor.is. Contact on the spec: manor@manor.is.
Nothing here comes from an authenticated call. No account was created, and no credentials were used.

## What Manor is

Manor is an Icelandic practice-management system for firms that bill for time. Each firm runs its own **instance**
(tenant). Inside an instance, people work with:

- **clients**: the customers that projects are run for, and the payers of invoices
- **projects**: the API term for a matter or case
- **activities** within a project
- billable items:
  - **time entries**
  - **products**
  - **expenses**
- **rates** for pricing
- **sales invoices**
- **inbound** (supplier) e-invoices, which are received, assigned to a project and approved.

## Base URL and environments

| Item | Value |
| --- | --- |
| Server | `https://secure.manor.is/{instance}/external-api/v1` |
| `{instance}` | Unique identifier of the Manor instance (the spec's default is `dev`) |

The spec documents **one host**. It has no separate sandbox or test host, and it says nothing about rate limits.
A test environment is therefore a separate **instance** on the same host, for example the `dev` instance.
For Bifrost Manor, that means:

- the host stays fixed in code;
- setup stores only the instance identifier;
- the Production and Test environments differ by instance (and API key), not by URL;
- the Mock environment never leaves Business Central.

## Authentication

- HTTP bearer: `Authorization: Bearer <token>`.
- A Manor user with administration rights in the instance creates the API key.
- The token is opaque. Send it whole, never parse it, and store it as a secret (IsolatedStorage, `SecretText`).
- What the key may do follows that user's Manor permissions. Some calls need a named permission:
  - `manage_inbound_invoices` for inbound invoices;
  - `manage_rates` for listing rates;
  - `set_alternative_user_of_times` for creating time entries.
- There is no OAuth flow, and the spec mentions no token expiry or refresh.

## Conventions

- **Format:** JSON request and response bodies, except the inbound-invoice import, which takes `application/xml` (UBL).
- **Pagination:** Laravel-style. The query takes `page` and `per_page`. The response carries:
  - `data`;
  - `links` (`first`, `last`, `prev`, `next`);
  - `meta` (`current_page`, `last_page`, `per_page`, `total`, …).
- **Incremental reads:** most list calls accept `updated_since`.
  - The inbound-invoice `updated` list is inclusive and oldest change first. De-duplicate by `id`, and poll from the last `updated_at`.
- **Errors:** all error bodies use `ApiError`, except 422.
  - 401 and 403: unauthorised.
  - 404: not found.
  - 405: invalid input.
  - 422: validation failure, Laravel `{ "message", "errors": { field: [messages] } }`.
- **Versioning:** the contract is `/v1`.
  - Additive fields and endpoints can arrive without a version change.
  - Renames and removals are breaking changes.
  - The **Invoices** endpoints, and project analysis, carry a **Beta** badge, "in development … may have breaking changes".
- **Legacy aliases:**
  - `subjects` is an alias of `labels`;
  - the `segment` routes alias the `activity` routes;
  - the old address fields alias `locality`, `administrative_area`, `postal_code` and `country_code`.
  - Use the canonical names.

## Resources and operations

| Tag | Read | Write (create / update) | Delete (never exposed by Bifrost) |
| --- | --- | --- | --- |
| Utility | `GET /ping` | | |
| Firms | `GET /firm` | | |
| Users | `GET /user`, `GET /user/{userId}`, `GET /user/{email}` | `PUT /user/{userId}` | |
| Clients | `GET /client`, `GET /client/{clientId}`, `GET /client-by-national-id/{nationalId}` | `POST /client`, `PUT /client/{clientId}` | `DELETE /client/{clientId}` |
| Projects | `GET /project` (filters: `status`, `client_id`, `asset_id`, `identifier`, `with_activities`), `GET /project/{projectId}`, `GET /project-by-identifier/{identifier}`, `GET /project/{projectId}/analysis` (Beta) | `POST /project`, `PUT /project/{projectId}` | |
| Project activities | `GET /project/{projectId}/activity`, `GET /project/{projectId}/activity/{activityId}` | `POST …/activity`, `PUT …/activity/{activityId}` (legacy `segment` aliases) | |
| Project links | | `POST /project/{projectId}/link`, `PUT …/link/{linkId}` | |
| Time entries | `GET /project/{projectId}/time` (filters: `user_id`, `date`, `updated_since`), `GET …/time/{timeId}` | `POST /project/{projectId}/time` | |
| Products | `GET /project/{projectId}/product`, `GET …/product/{productId}` | `POST …/product`, `PUT …/product/{productId}` | `DELETE …/product/{productId}` |
| Expenses | | `POST /project/{projectId}/expense`, `PUT …/expense/{expenseId}`, `POST …/expense/{expenseId}/attachment` | `DELETE …/expense/{expenseId}`, `DELETE …/attachment` |
| Rates | `GET /rate` | | |
| Assets (optional instance feature, off by default) | `GET /asset`, `GET /asset/{assetId}`, `GET /asset-by-identifier/{identifier}` | `POST /asset`, `PUT /asset/{assetId}` | `DELETE /asset/{assetId}` |
| Invoices (Beta) | `GET /invoice` (filters: `created_since`, `updated_since`, `firm_id`, `from`, `to`), `GET /invoice/{invoiceId}`, `GET /invoice/{firmId}/{invoiceNumber}` | | |
| Inbound invoices | `GET /inbound-invoice/accepted`, `GET /inbound-invoice/updated`, `GET /inbound-invoice/{id}`, `GET /inbound-invoice/{id}/xml` (annotated UBL) | `POST /inbound-invoice` (UBL Invoice or CreditNote; the buyer's Peppol id selects the firm) | `DELETE /inbound-invoice/{id}` |
| Extensions | `GET /extension` | `POST /extension/{extension}/{action}` (runs an instance-specific action) | |
| Webhook subscriptions | `GET /webhook/{webhookId}`, `GET /webhook/call` (delivery log) | `POST /webhook`, `PUT /webhook/{webhookId}` | `DELETE /webhook/{webhookId}` |

Main fields by entity:

- **Client:**
  - `id`, `name`, `national_id` (kennitala)
  - `address`, `billing_address`
  - `email`, `phone`
  - `currency_code`, `special_attention`, `add_transaction_fee`
- **Project:**
  - `id`, `identifier`, `name`
  - `client`, `owner`, `billing_owner`, `department`
  - `open`, `subject_to_vat`, `settlement`, `billing`
  - `budget`, `time_budget`, `estimate`
  - `activities`, `labels`, `links`
  - buyer reference and contact fields
- **Time:**
  - `id`, `matter_id`, `activity_id`, `user_id`, `rate_id`
  - `begins_at`, `hours`, `billable_hours`
  - `description`, `internal_note`
- **Invoice:**
  - `invoice_number`, `invoice_date`, `due_date`, `currency_code`, `exchange_rate`
  - `issuer`, `client`, `is_credit`
  - `original_invoice_number`
  - `amounts`, `invoice_lines`. Each line has `product_number`, `quantity`, `unit_price`, `discount_percentage`, `vat_rate_percentage`, `activity` and `amounts`.
- **InboundInvoice:**
  - `status`, `received_at`, `accepted_at`, `rejected_at`
  - `supplier`
  - `matter_id`, `activity_id`
  - `amounts`, `invoice_lines`

## Webhooks

A subscription has these fields:

- `type`: one of `project_saved`, `activity_saved`, `client_saved`, `user_saved` or `inbound_invoice_saved`;
- `url`;
- `client_state` (optional): a value Manor echoes in every payload;
- `exclude_self`: set it to skip events that the subscribing user caused.

Every payload has the same envelope:

- `trigger`;
- `type`: `created`, `updated` or `deleted`;
- `client_state`;
- `user_id`;
- a snapshot of the entity.

The spec documents no payload signature, so `client_state` is the only authenticity check. Use `GET /webhook/call` to see past deliveries.

Business Central online cannot expose a public URL by itself, so webhooks need a relay. The other option is to poll with `updated_since`. That choice is an open decision.

## Rate limits

None documented, and the spec has no `429` or `Retry-After` responses. The client must still:

- back off on `429` and `5xx`;
- cap `per_page`;
- page through results instead of asking for everything at once.

## What Bifrost Manor will not do

- **No delete message types.** None of the `DELETE` routes above will be exposed.
- **Assets, Extensions and webhook subscription management** are left out of v1 until Gunnar decides on them.
- **Beta endpoints** (Invoices, project analysis) are read-only. Their contract chapters will say they are Beta.
