# Changelog

All notable changes to Bifrost Manor are documented here.

## [Unreleased]

### Added
- [Read message types (#5)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/5): `Manor.TimeEntry.List`, `Manor.Product.List`, `Manor.Invoice.List`, `Manor.Invoice.Get` and `Manor.InboundInvoice.List`, with EN/is-IS discovery and contracts, canonical JSON, bounded complete pagination, read-role permissions and localized errors. Time uses one day; updated inbound invoices de-duplicate by id before optional validated local status filtering. Invoice contracts identify the upstream Beta status. New objects: enum extension 10035666; implementation codeunits 10035666–10035670; bilingual test codeunit 98250, mock fixture table 98251 and subscriber codeunit 98252 (test app only).
- [Story B (#2)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/2): Manor API client (`Manor Client ori`: Get, GetAll with paging, Post, Put; no delete) with one retry on 429/5xx, documented EN/IS error mapping that never echoes the key, query or body, an ISO 8601 query builder and path-template telemetry. The mock store gained queued per-query responses. New objects: codeunits 10035651–10035654; bilingual test codeunit 98220.
- [Story A (#1)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/1): Manor Setup with disabled Mock defaults, validated instance identifiers, a masked API-key dialog, company-scoped SecretText storage, and restrictive Full/Read permissions. Clear and setup deletion remove the key.
- Production/Test transport on a fixed host and a session-local mock with registered responses and request capture. New objects: table 10035641; pages 10035642, 10035647; enum 10035643; interface Manor Transport ori; codeunits 10035644–10035646, 10035648–10035649; bilingual test codeunit 98202. Foundation registration now opens Manor Setup.
- Repository scaffold: app registration with Bifröst Foundation, Bifrost Manor permission sets wired into the Foundation Full and Read roles, AL-Go CI/CD and source guards.
- Manor API reference summary (`docs/manor-api-summary.md`).
