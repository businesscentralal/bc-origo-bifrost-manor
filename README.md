# Bifröst Manor

**App name:** Bifrost Manor
**Publisher:** Origo — **Version:** 28.0.0.0 — **Target:** Cloud (BC 28.0, runtime 17.0)
**App ID:** `b5ea6876-e337-4f58-a79e-cd15d6c157a8` — **Test app ID:** `722dcc26-ef33-4e28-abe0-4da350b5d240`
**Object ID range:** 10035635–10035684 (tests 98200–98299) — **Namespace:** `Origo.Bifrost.Manor`

Bifrost Manor connects Business Central with Manor, the practice-management system used by firms that bill for time:
an agent can read Manor clients, projects, time entries, rates and invoices, and (after confirmation) create or update
them, through Bifröst message types. Nothing is ever deleted in Manor.

**Status:** scaffold. Setup, the Manor API client and the message types are built in this repository's issues.
API notes: [docs/manor-api-summary.md](docs/manor-api-summary.md).

Foundation discovers this app on **Bifrost Setup** through its application registry. Assign `BIFROST Manor ori`,
`BIFROST MnrFull ori` or `BIFROST MnrRead ori` alongside the appropriate Foundation role. The object allocation is
recorded in [.claude/CLAUDE.md](.claude/CLAUDE.md).
