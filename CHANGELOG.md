# Changelog

All notable changes to Bifrost Manor are documented here.

## [Unreleased]

### Added
- [Story (#6)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/6): six write message types `Manor.Client.Create/Update`, `Manor.Project.Create/Update` and `Manor.Activity.Create/Update` with `expectedCount` confirmation (refused before any call on a mismatch), per-record 400/422 errors, duplicate-kennitala refusal on client create, `confirmCurrencyChange` for currency changes, billing values enabled/internal/sensitive, project close and reopen, and the `manage_activities` permission hint. New objects: codeunits 10035671-10035676 (Impl), 10035678 (Manor Write Handler ori), 10035679 (Manor Contract Parts ori); enum extension 10035677; test codeunit 98260.
- [Story B (#2)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/2): Manor API client (`Manor Client ori`: Get, GetAll with paging, Post, Put; no delete) with one retry on 429/5xx, documented EN/IS error mapping that never echoes the key, query or body, an ISO 8601 query builder and path-template telemetry. The mock store gained queued per-query responses. New objects: codeunits 10035651–10035654; bilingual test codeunit 98220.
- [Story A (#1)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/1): Manor Setup with disabled Mock defaults, validated instance identifiers, a masked API-key dialog, company-scoped SecretText storage, and restrictive Full/Read permissions. Clear and setup deletion remove the key.
- Production/Test transport on a fixed host and a session-local mock with registered responses and request capture. New objects: table 10035641; pages 10035642, 10035647; enum 10035643; interface Manor Transport ori; codeunits 10035644–10035646, 10035648–10035649; bilingual test codeunit 98202. Foundation registration now opens Manor Setup.
- Repository scaffold: app registration with Bifröst Foundation, Bifrost Manor permission sets wired into the Foundation Full and Read roles, AL-Go CI/CD and source guards.
- Manor API reference summary (`docs/manor-api-summary.md`).
