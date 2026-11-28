# Create billable entries in Manor

```json
{"type":"Manor.TimeEntry.Create","data":{"projectId":17,"expectedCount":1,"dryRun":true,"begins_at":"2026-11-20T09:00:00Z","hours":2,"billable_hours":1,"description":"Work report description","user_id":5}}
```

The three creates send one billable entry through the configured Manor client. Set `dryRun` to preview the exact outbound payload. `expectedCount` is required and must be **1**, even for a preview. It is checked before any Manor call.

| Type | Write endpoint | Required payload fields |
| --- | --- | --- |
| Manor.TimeEntry.Create | POST /project/{projectId}/time | begins_at, hours, description, user_id |
| Manor.Expense.Create | POST /project/{projectId}/expense | description, amount, paid_at, paid_in_currency_code |
| Manor.Product.Create | POST /project/{projectId}/product | date, description, quantity, user_id, rate_id |

`projectId`, `expectedCount` and `dryRun` are Bifröst controls and are not sent in the Manor body. The remaining fields use canonical Manor names. Unknown fields and malformed JSON scalar types are refused before any call. Payload fields and optional defaults are listed in the English and Icelandic `Help.Implementation.Get` contracts.

```json
{"type":"Manor.Expense.Create","data":{"projectId":17,"expectedCount":1,"dryRun":true,"description":"Travel receipt","amount":1500,"paid_at":"2026-11-20T09:00:00Z","paid_in_currency_code":"ISK","vat_rate_id":3}}
```

```json
{"type":"Manor.Product.Create","data":{"projectId":17,"expectedCount":1,"dryRun":true,"date":"2026-11-20","description":"Prepayment deduction","quantity":-2,"user_id":5,"rate_id":8}}
```

| Rule | Behaviour |
| --- | --- |
| Time duration | More than zero, at most 24 hours, cannot cross midnight UTC. Ending exactly at midnight is allowed. Time-zone offsets are normalised for validation. |
| Billable hours | Zero through hours worked; omission leaves Manor's default unchanged. |
| Time rate | An explicit rate_id must match a time rate. The API exposes only GET /rate, so the implementation reads its pages until the ID is found, up to 100 pages. Requires manage_rates. No project or user pre-read. An omitted rate_id keeps Manor's default. |
| Expense VAT | An explicit vat_rate_id is sent unchanged. Otherwise GET /firm supplies default_vat_rate_id. Select firm_id when there are several firms; omission is accepted only for a single unambiguous firm. Missing defaults, unknown firms or an incomplete scan fail before POST. Maximum 100 pages. |
| Product quantity | Negative quantities are supported for prepayment deductions. No product-rate pre-read. |
| Dry run | Runs validation and permitted rate/firm reads; performs no POST. Returns status=Success, dryRun=true, noOfRecords=0, result=[], method, path and payload. |
| Create result | status=Success, dryRun=false, noOfRecords=1 and the canonical resource in result. Both a bare resource and a data-wrapped resource are supported. An empty or malformed response fails and asks the caller to inspect Manor before retrying. |
| Create failures | 401/403 provide the operation's permission hint; 404 reports a missing resource; 422 reports rejected data. Provider text is not echoed. No automatic create retry, including after a transient failure. |

Creates require `BIFROST MnrFull ori`. Read users cannot execute them. Manor permissions are `set_alternative_user_of_times`, `set_alternative_user_of_expenses` and `manage_products` respectively. Closed projects and disabled users are decided by Manor; there are no pre-reads for those conditions.

These writes cannot be undone through Bifröst. Correct a mistake in Manor before invoicing. Time descriptions appear on work reports, product descriptions on invoices; internal notes stay internal. Mileage and expense attachments are outside this contract.

Source: [Manor public API reference](https://api.manor.is/), read 27 November 2026. Product decisions: issue #7 comments by Gunnar on 25 and 26 November 2026 (NG-10 through NG-13). Tests use Mock transport and generated fixtures only.
