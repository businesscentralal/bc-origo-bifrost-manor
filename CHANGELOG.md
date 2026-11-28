# Changelog

All notable changes to Bifrost Manor are documented here.

## [Unreleased]

### Added
- Manor.TimeEntry.Create, Manor.Expense.Create and Manor.Product.Create with expectedCount=1, dryRun previews, bilingual contracts, mock tests, time validation and default expense VAT. Objects: codeunits 10035650, 10035677–10035679; enum extension 10035677; test codeunit 98270.
- Create-specific client overload sends once and returns safe localised errors without provider text.
- [Story D (#4)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/4): read message types `Manor.Client.List`, `Manor.Client.Get`, `Manor.Project.List` (open projects by default, Gunnar 26.11.2026), `Manor.Project.Get` and `Manor.Activity.List`, each with an EN + is-IS contract, mapped Manor errors (401/403 with the `manage_activities` hint, 404, 422) and no secrets in any answer. New objects: enum extension 10035680; codeunits 10035661-10035665 (Impl), 10035681 (contract parts), 10035682 (shared reading and response mapping); test codeunit 98240. The client, query builder, transport and telemetry codeunits moved into `BIFROST MnrRead ori` so a read-only user can run the types.
- [Story B (#2)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/2): Manor API client (`Manor Client ori`: Get, GetAll with paging, Post, Put; no delete) with one retry on 429/5xx, documented EN/IS error mapping that never echoes the key, query or body, an ISO 8601 query builder and path-template telemetry. The mock store gained queued per-query responses. New objects: codeunits 10035651–10035654; bilingual test codeunit 98220.
- [Story A (#1)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/1): Manor Setup with disabled Mock defaults, validated instance identifiers, a masked API-key dialog, company-scoped SecretText storage, and restrictive Full/Read permissions. Clear and setup deletion remove the key.
- Production/Test transport on a fixed host and a session-local mock with registered responses and request capture. New objects: table 10035641; pages 10035642, 10035647; enum 10035643; interface Manor Transport ori; codeunits 10035644–10035646, 10035648–10035649; bilingual test codeunit 98202. Foundation registration now opens Manor Setup.
- Repository scaffold: app registration with Bifröst Foundation, Bifrost Manor permission sets wired into the Foundation Full and Read roles, AL-Go CI/CD and source guards.
- Manor API reference summary (`docs/manor-api-summary.md`).
