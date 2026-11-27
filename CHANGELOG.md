# Changelog

All notable changes to Bifrost Manor are documented here.

## [28.0.0.0] - 2026-11-27

### Added
- [Read message types (#3)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/3): `Manor.Connection.Test`, `Manor.Firm.List`, `Manor.User.List`, `Manor.User.Get` and `Manor.Rate.List`, with bilingual discovery/contracts (including explicit Icelandic metadata in canonical English catalogue contracts), canonical response fields and paging. Optional user permission filters go to Manor; enabled-user and rate-type filters run in Business Central. The connection test records a successful timestamp without granting setup editing to the read role. New objects: enum extension 10035655; codeunits 10035656–10035660; bilingual test codeunit 98230 and test-only mock probe objects 98231–98232. Rate-list 403 errors always name `manage_rates`; message reads do not echo upstream 422 details. Existing client Get/Post/Put contracts are preserved. The Read role can use the stored key only for GET requests and still cannot edit setup or keys or send writes. Email lookup safely escapes a single user path segment; encoded delimiters, control characters and double encoding are rejected.
- [Story B (#2)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/2): Manor API client (`Manor Client ori`: Get, GetAll with paging, Post, Put; no delete) with one retry on 429/5xx, documented EN/IS error mapping that never echoes the key, query or body, an ISO 8601 query builder and path-template telemetry. The mock store gained queued per-query responses. New objects: codeunits 10035651–10035654; bilingual test codeunit 98220.
- [Story A (#1)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/1): Manor Setup with disabled Mock defaults, validated instance identifiers, a masked API-key dialog, company-scoped SecretText storage, and restrictive Full/Read permissions. Clear and setup deletion remove the key.
- Production/Test transport on a fixed host and a session-local mock with registered responses and request capture. New objects: table 10035641; pages 10035642, 10035647; enum 10035643; interface Manor Transport ori; codeunits 10035644–10035646, 10035648–10035649; bilingual test codeunit 98202. Foundation registration now opens Manor Setup.
- Repository scaffold: app registration with Bifröst Foundation, Bifrost Manor permission sets wired into the Foundation Full and Read roles, AL-Go CI/CD and source guards.
- Manor API reference summary (`docs/manor-api-summary.md`).
