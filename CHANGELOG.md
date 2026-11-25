# Changelog

All notable changes to Bifrost Manor are documented here.

## [Unreleased]

### Added
- [Story A (#1)](https://github.com/businesscentralal/bc-origo-bifrost-manor/issues/1): Manor Setup with disabled Mock defaults, validated instance identifiers, a masked API-key dialog, company-scoped SecretText storage, and restrictive Full/Read permissions. Clear and setup deletion remove the key.
- Production/Test transport on a fixed host and a session-local mock with registered responses and request capture. New objects: table 10035641; pages 10035642, 10035647; enum 10035643; interface Manor Transport ori; codeunits 10035644–10035646, 10035648–10035649; bilingual test codeunit 98202. Foundation registration now opens Manor Setup.
- Repository scaffold: app registration with Bifröst Foundation, Bifrost Manor permission sets wired into the Foundation Full and Read roles, AL-Go CI/CD and source guards.
- Manor API reference summary (`docs/manor-api-summary.md`).
