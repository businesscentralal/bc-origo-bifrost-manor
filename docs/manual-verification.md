# Manual verification against a Manor test instance

Purpose: confirm the Manor message types against a real Manor **test instance** once Gunnar provides one.
This is never part of CI. CI runs only the Mock contract suite (`Manor Contract Tst ori`, test ids 98280-98289), which needs no network and no credentials.

Rules
- Use a test environment of a demo company only. Never use a production instance or customer data.
- Do not write the instance name or the API key in this file, in a PR, in a log, in a screenshot or in an issue. The key is entered on the **Manor API Key** page and lives in company-scope isolated storage; the instance name is entered on **Manor Setup** and is not copied anywhere else.
- The run is read-only except for the explicitly listed write checks, which use `expectedCount` and demo records you remove again in Manor yourself (Bifröst has no delete message types).

Steps
1. Open **Manor Setup**, set Environment to `Test`, enter the instance identifier and enable the connection. Open **Manor API Key** and enter the test key.
2. Call `Manor.Connection.Test` (empty request). Expect `status` Success and a connected message.
3. Call the read types with a small page: `Manor.Firm.List`, `Manor.User.List`, `Manor.User.Get`, `Manor.Rate.List`, `Manor.Client.List`, `Manor.Client.Get`, `Manor.Project.List`, `Manor.Project.Get`, `Manor.Activity.List`, `Manor.TimeEntry.List`, `Manor.Product.List`, `Manor.Invoice.List`, `Manor.Invoice.Get`, `Manor.InboundInvoice.List`. Expect Success and a plausible `count`; a 403 names the Manor permission that is missing.
4. Optional write checks: one `Manor.Client.Create` and one `Manor.TimeEntry.Create` with `expectedCount` 1 on demo data. Expect Created with Manor's id.
5. Repeat steps 2-3 with the user language set to Icelandic (1039) and confirm the text is localised.
6. Set Environment back to `Mock` and clear the key (Manor API Key page).

Receipt (post as a PR comment, without instance name or key)
- Date, Bifröst app version, language(s) run, per message type: Success / failure and the error text if any.
- Confirmation that the key and instance name were not copied anywhere.
