# Bifröst Manor

**App name:** Bifrost Manor
**Publisher:** Origo — **Version:** 28.0.0.0 — **Target:** Cloud (BC 28.0, runtime 17.0)
**App ID:** `b5ea6876-e337-4f58-a79e-cd15d6c157a8` — **Test app ID:** `722dcc26-ef33-4e28-abe0-4da350b5d240`
**Object ID range:** 10035635–10035684 (tests 98200–98299) — **Namespace:** `Origo.Bifrost.Manor`

Bifrost Manor connects Business Central with Manor, the practice-management system used by firms that bill for time:
an agent can read Manor clients, projects, time entries, rates and invoices, and (after confirmation) create or update
them, through Bifröst message types. Nothing is ever deleted in Manor.

**Status:** setup, API client and five approved read message types. Other message types are tracked separately in this repository's issues.
API notes: [docs/manor-api-summary.md](docs/manor-api-summary.md).

Foundation discovers this app on **Bifrost Setup** through its application registry. Assign `BIFROST Manor ori`,
`BIFROST MnrFull ori` or `BIFROST MnrRead ori` alongside the appropriate Foundation role. The object allocation is
recorded in [.claude/CLAUDE.md](.claude/CLAUDE.md).

## Connection setup

1. Open **Manor Setup** from search or Bifröst Setup.
2. Keep **Mock** for connection-free development, or select **Production**/**Test** and enter an instance identifier (letters A–Z, digits, hyphens and underscores; maximum 100 characters).
3. Use **Set API Key** to enter a new key in the masked dialog. Only key presence is displayed afterwards. **Clear API Key** removes it for the current company.
4. Enable the connection when configuration is complete. A test environment is a separate instance on the same fixed Manor host.

`BIFROST MnrRead ori` reads existing setup and key presence and executes the five read message types. `BIFROST MnrFull ori` creates and edits setup and manages keys. Keys are `SecretText` in company-scoped IsolatedStorage; deleting setup through its table trigger removes the key. No URL or key field is stored in the setup table.

AL integrations select `Manor Transport ori` through `Manor Environment ori`. The mock uses `Manor Mock Store ori.RegisterResponse`, records method/path/query/body, and returns 404 for unregistered routes. Call `Reset` before and after each test. `Send` returns true for a 2xx response and false for other statuses. The response codeunit exposes status and body; no transport exposes the stored API key.

The test app targets OnPrem because AL's native `HttpClientHandler` is available only there. Product code remains Cloud-targeted. The tests intercept HTTP responses and set `TestHttpRequestPolicy = BlockOutboundRequests`; they never contact Manor. The setup scenarios run in LCIDs 1033 and 1039.

## Read message types

```json
{"type":"Manor.TimeEntry.List","data":{"projectId":42,"date":"2026-01-15"}}
```

| Type | Required data | Optional filters |
| --- | --- | --- |
| `Manor.TimeEntry.List` | `projectId` | `userId`, `date` (one day), `updatedSince` |
| `Manor.Product.List` | `projectId` | None; requires Manor `manage_products` |
| `Manor.Invoice.List` (Beta) | None | `firmId`, `createdSince`, `updatedSince`, `from`, `to` |
| `Manor.Invoice.Get` (Beta) | `invoiceId` alone, or `firmId` + `invoiceNumber` | None |
| `Manor.InboundInvoice.List` | `mode=accepted` + `from` + `to`, or `mode=updated` + `updatedSince` | `status` in updated mode only; requires `manage_inbound_invoices` |

Dates use `YYYY-MM-DD`; timestamps use ISO 8601 UTC ending in `Z`. IDs and invoice numbers are positive integers.
All lists read every upstream page. `perPage` defaults to 100 (1–100), `maxPages` to 100 (1–1000). If more pages remain at the limit, the call fails without returning partial data. List responses contain `status`, `count` and `data`; Invoice.Get returns one object under `data`. Manor field names are preserved.

Updated inbound invoices are inclusive. Duplicate ids across pages collapse to the last occurrence before the optional BC status filter (`not_assigned`, `pending`, `accepted`, `rejected`). Omit `status` to return all states. De-duplicate across separate polling calls too.

Time lists cannot distinguish invoiced from unbilled entries. Invoice endpoints are Beta and summarised invoice lines need not identify individual time entries. Read the bilingual runtime contracts for field meanings, visibility limits, parameters and errors. Foundation canonicalizes contract chapters to English, so their human descriptions include the Icelandic wording explicitly alongside English; catalogue descriptions and runtime errors follow the requested language.

MCP verification uses disposable exact-route fixtures in the test app's `Manor Read Fixture ori` table. Its subscriber runs only for Mock transport in a CRONUS demo company; test code seeds and deletes its own fixtures. Product sessions without the test app keep the session-local mock behavior.
