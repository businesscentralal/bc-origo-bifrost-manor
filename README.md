# Bifröst Manor

**App name:** Bifrost Manor
**Publisher:** Origo — **Version:** 28.0.0.0 — **Target:** Cloud (BC 28.0, runtime 17.0)
**App ID:** `b5ea6876-e337-4f58-a79e-cd15d6c157a8` — **Test app ID:** `722dcc26-ef33-4e28-abe0-4da350b5d240`
**Object ID range:** 10035635–10035684 (tests 98200–98299) — **Namespace:** `Origo.Bifrost.Manor`

Bifrost Manor connects Business Central with Manor, the practice-management system used by firms that bill for time:
an agent can read Manor clients, projects, time entries, rates and invoices, and (after confirmation) create or update
them, through Bifröst message types. Nothing is ever deleted in Manor.

**Status:** setup and transport abstraction. Message types are tracked separately in this repository's issues.
API notes: [docs/manor-api-summary.md](docs/manor-api-summary.md).

Foundation discovers this app on **Bifrost Setup** through its application registry. Assign `BIFROST Manor ori`,
`BIFROST MnrFull ori` or `BIFROST MnrRead ori` alongside the appropriate Foundation role. The object allocation is
recorded in [.claude/CLAUDE.md](.claude/CLAUDE.md).

## Connection setup

1. Open **Manor Setup** from search or Bifröst Setup.
2. Keep **Mock** for connection-free development, or select **Production**/**Test** and enter an instance identifier (letters A–Z, digits, hyphens and underscores; maximum 100 characters).
3. Use **Set API Key** to enter a new key in the masked dialog. Only key presence is displayed afterwards. **Clear API Key** removes it for the current company.
4. Enable the connection when configuration is complete. A test environment is a separate instance on the same fixed Manor host.

`BIFROST MnrRead ori` reads existing setup and key presence. `BIFROST MnrFull ori` creates and edits setup and manages keys. Keys are `SecretText` in company-scoped IsolatedStorage; deleting setup through its table trigger removes the key. No URL or key field is stored in the setup table.

AL integrations select `Manor Transport ori` through `Manor Environment ori`. The mock uses `Manor Mock Store ori.RegisterResponse`, records method/path/query/body, and returns 404 for unregistered routes. Call `Reset` before and after each test. `Send` returns true for a 2xx response and false for other statuses. The response codeunit exposes status and body; no transport exposes the stored API key.

The test app targets OnPrem because AL's native `HttpClientHandler` is available only there. Product code remains Cloud-targeted. The tests intercept HTTP responses and set `TestHttpRequestPolicy = BlockOutboundRequests`; they never contact Manor. The setup scenarios run in LCIDs 1033 and 1039.

## Read message types

The approved connection, firm, user and rate reads are documented in [English](docs/manor-read-messages.en-US.md) and [Icelandic](docs/manor-read-messages.is-IS.md). Use `BIFROST MnrRead ori` to invoke them; setup and API-key editing require the Full role. Lists return one page with Manor metadata. Local filters apply to that page, so an empty filtered result can still have a next page.
