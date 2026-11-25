# Extension: Bifrost Manor

## Customer
Origo / AppSource

## Prefix
(none - objects use raw names with the mandatory `ori` suffix inside the `Origo.Bifrost.Manor` namespace; same as Bifrost ODBC)

## Namespace
Origo.Bifrost.Manor (tests: Origo.Bifrost.Manor.Test)

## Object ID Range
App:   10035635-10035684 (Public 1; registered in the OneDrive object-range workbook 25.11.2026, Solution Allocations row 10, ex Attachments block 1)
Tests: 98200-98299 (workbook sheet Test App Ranges, row 99015)

| Type | ID | Name |
| --- | --- | --- |
| Codeunit | 10035635 | Manor Registration ori |
| Permission set | 10035636 | BIFROST Manor ori |
| Permission set | 10035637 | BIFROST MnrFull ori |
| Permission set | 10035638 | BIFROST MnrRead ori |
| Permission set extension | 10035639 | Manor Full Role ori |
| Permission set extension | 10035640 | Manor Read Role ori |
| Test codeunit | 98200 | Manor Scaffold Tst ori |
| Test permission set | 98201 | Manor Setup Test ori |

| Table | 10035641 | Manor Setup ori |
| Page | 10035642 | Manor Setup ori |
| Enum | 10035643 | Manor Environment ori |
| Interface | (no ID) | Manor Transport ori |
| Codeunit | 10035644 | Manor HTTP Impl ori |
| Codeunit | 10035645 | Manor Mock Impl ori |
| Codeunit | 10035646 | Manor Response ori |
| Page | 10035647 | Manor API Key ori |
| Codeunit | 10035648 | Manor Secrets ori |
| Codeunit | 10035649 | Manor Mock Store ori |
| Test codeunit | 98202 | Manor Setup Tst ori |

Every new object is added to this table in the same PR.

## Product scope (Gunnar 25.11.2026: scaffold Bifrost Manor on https://api.manor.is/)
- Connector between Business Central and **Manor**, the Icelandic practice-management system (projects, clients,
  time entries, rates, sales invoices, inbound e-invoices). API reference summary: [docs/manor-api-summary.md](../docs/manor-api-summary.md).
- **Setup**: one setup record per company with the environment, the Manor instance identifier and the API key.
  The key is a `SecretText` in IsolatedStorage (company scope); it never appears in a response, log, error or help text.
- **Environment interface** (extensible enum + interface): `Production`, `Test`, `Mock`. The host
  `https://secure.manor.is/{instance}/external-api/v1` is fixed in code; setup holds only the instance identifier.
  `Mock` serves canned responses inside BC and never opens a connection.
- **Message types** `Manor.<Entity>.<Action>`: read types first; write types require `expectedCount` confirmation.
  **No delete message types** (Gunnar 05.11). Every new message type needs Gunnar's decision on the Decisions page
  before implementation (cards `d-20261125-manor-*`).
- Open decisions live on the Decisions artifact (collection `decisions`, ids `d-20261125-manor-*`); do not implement
  past an open card.

## Setup Notifications
Setup notifications live **only** on Bifröst Foundation's `Setup ori` page. This app never raises a `Notification` of its own.
It registers with Foundation through `App Registry ori.OnRegisterApps` (`app/src/Common/ManorRegistration.Codeunit.al`).

## Target BC Version
28.0 (application 28.0.0.0, platform 28.0.0.0, runtime 17.0)

## Source Control
Platform: GitHub
Organization: businesscentralal
Repository: bc-origo-bifrost-manor
Default branch: main

## Dependencies
- Bifrost Foundation (`7505e808-6e52-4b96-a328-82573391297a`, 28.0.16.0)

App ID `b5ea6876-e337-4f58-a79e-cd15d6c157a8`, test app ID `722dcc26-ef33-4e28-abe0-4da350b5d240`.

## Naming Rules
- Every object carries the `ori` suffix (AppSource mandatory affix), max 30 characters; permission set names max 20.
- Message type names have three parts: `Domain.Entity.Action`, domain `Manor`.
- Icelandic captions use "Bifröst".

## Development Standards
This project follows the **Origo BC Development Standards** (https://github.com/OrigoSoftwareSolutions/bc-dev-standards).
Before writing any AL code, load `origo-bc-al-coding-standards`, `origo-bc-test-writer`, `origo-bc-documentation-writer`.
- Namespace at the top of every file; XML documentation on every object and non-local procedure
- Bilingual captions (en-US + is-IS) via `Comment = 'is-IS=...'`; regenerate `app/Translations/Bifrost Manor.is-IS.xlf` with `tools/Update-IcelandicXlf.ps1`
- Implementation = code + tests + documentation (contract chapters of `Msg Contract ori`)

## Message Type Conventions
- One enum extension of Foundation's `Message Type ori`; keys are the published API contract and are never renamed.
- Each type has an Impl codeunit implementing `Msg Interface ori`, `Msg Discovery ori` and `Msg Contract ori`.
- Help text is public: no customer names, Manor instance names, tenant ids, internal hosts or API keys.

## Test App Rules
- Unit tests never need credentials and never call Manor: use the `Mock` environment (interface + enum in setup).
- Every message type is tested in languages 1033 and 1039.
