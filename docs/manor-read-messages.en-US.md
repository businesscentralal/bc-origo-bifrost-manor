# Manor read messages


## Manor.Connection.Test
**Direction**: Outbound (Read)
**Category**: Manor

### Overview

Tests the Manor connection; a successful ping does not prove resource permissions.

### Request Format

| Parameter | Type | Required | Description |
|---|---|---|---|
| — | — | — | No parameters. |
```json
{
  "type": "Manor.Connection.Test",
  "data": {}
}
```

### Response Format

```json
{
  "status": "Success",
  "noOfRecords": 1,
  "result": [
    {
      "ok": true,
      "message": "XMock connected"
    }
  ]
}
```

### Response Fields

| Field | Type | Description |
|---|---|---|
| `noOfRecords` | integer | Number of rows returned after local filtering. |
| `result` | array | One row with ok=true and the Manor message, when present. |
| `meta` | object | Source-page metadata for lists; absent for single reads and ping. |

### Error Response

```json
{"status":"Error","code":"BusinessCentralError","error":"..."}
```
Invalid types, ranges, missing or ambiguous user targets and unknown rate types are refused before transport. HTTP 401/403, 404 and 422 return localized messages without raw server text; rate 403 names manage_rates. Temporary failures are retried once.

### Configuration

Enable the connection in Manor Setup. Mock needs no credential or instance. Production/Test require an administrator-configured instance and API key. The Read role can invoke these types; it cannot edit setup or keys.
An administrator creates the API key; it acts as that Manor user within its own instance. A successful ping updates Last Connection Test only.

### Related Message Types

- `Manor.Firm.List`
- `Manor.User.List`
- `Manor.User.Get`
- `Manor.Rate.List`

## Manor.Firm.List
**Direction**: Outbound (Read)
**Category**: Manor

### Overview

Lists issuing firms and their default currency, VAT rate and Peppol identifier.

### Request Format

| Parameter | Type | Required | Description |
|---|---|---|---|
| `page` | integer | No | Page number, at least 1. Default 1. |
| `perPage` | integer | No | Rows per page, 1 to 100. Default 100. |
| `updated_since` | string | No | ISO 8601 timestamp for incremental reads, inclusive. |
| `page` | integer | No | Page number, at least 1. Default 1. |
| `perPage` | integer | No | Rows per page, 1 to 100. Default 100. |
| `updated_since` | string | No | ISO 8601 timestamp for incremental reads, inclusive. |
```json
{
  "type": "Manor.Firm.List",
  "data": {}
}
```

### Response Format

```json
{
  "status": "Success",
  "noOfRecords": 1,
  "result": [
    {
      "id": 1,
      "name": "XDemo firm",
      "currency_code": "ISK",
      "default_vat_rate_id": 24
    }
  ]
}
```

### Response Fields

| Field | Type | Description |
|---|---|---|
| `noOfRecords` | integer | Number of rows returned after local filtering. |
| `result` | array | Issuing firms with id, name, currency_code, default_vat_rate_id and peppol_identifier. |
| `meta` | object | Source-page metadata for lists; absent for single reads and ping. |

### Error Response

```json
{"status":"Error","code":"BusinessCentralError","error":"..."}
```
Invalid types, ranges, missing or ambiguous user targets and unknown rate types are refused before transport. HTTP 401/403, 404 and 422 return localized messages without raw server text; rate 403 names manage_rates. Temporary failures are retried once.

### Configuration

Enable the connection in Manor Setup. Mock needs no credential or instance. Production/Test require an administrator-configured instance and API key. The Read role can invoke these types; it cannot edit setup or keys.
default_vat_rate_id is the only VAT rate ID exposed by the Manor API.
Each call reads one page. Continue through meta.last_page even if a local filter returns no rows. Source metadata describes the unfiltered page, while noOfRecords counts the returned rows.

### Related Message Types

- `Manor.Connection.Test`
- `Manor.User.List`
- `Manor.User.Get`
- `Manor.Rate.List`

## Manor.User.List
**Direction**: Outbound (Read)
**Category**: Manor

### Overview

Lists Manor employees, optionally filtered by permissions and enabled status.

### Request Format

| Parameter | Type | Required | Description |
|---|---|---|---|
| `page` | integer | No | Page number, at least 1. Default 1. |
| `perPage` | integer | No | Rows per page, 1 to 100. Default 100. |
| `updated_since` | string | No | ISO 8601 timestamp for incremental reads, inclusive. |
| `owns_projects` | boolean | No | Filter by permission to own projects; omitted means all. |
| `approves_invoices` | boolean | No | Filter by permission to approve inbound invoices; omitted means all. |
| `enabledOnly` | boolean | No | True keeps only enabled users in Business Central; default false. |
| `page` | integer | No | Page number, at least 1. Default 1. |
| `perPage` | integer | No | Rows per page, 1 to 100. Default 100. |
| `updated_since` | string | No | ISO 8601 timestamp for incremental reads, inclusive. |
| `owns_projects` | boolean | No | Filter by permission to own projects; omitted means all. |
| `approves_invoices` | boolean | No | Filter by permission to approve inbound invoices; omitted means all. |
| `enabledOnly` | boolean | No | True keeps only enabled users in Business Central; default false. |
```json
{
  "type": "Manor.User.List",
  "data": {
    "owns_projects": true,
    "approves_invoices": true,
    "enabledOnly": true
  }
}
```

### Response Format

```json
{
  "status": "Success",
  "noOfRecords": 1,
  "result": [
    {
      "id": 1,
      "name": "XDemo employee",
      "enabled": true,
      "owns_projects": true,
      "approves_invoices": true
    }
  ]
}
```

### Response Fields

| Field | Type | Description |
|---|---|---|
| `noOfRecords` | integer | Number of rows returned after local filtering. |
| `result` | array | Employees with id, name, email, enabled, owns_projects and approves_invoices. |
| `meta` | object | Source-page metadata for lists; absent for single reads and ping. |

### Error Response

```json
{"status":"Error","code":"BusinessCentralError","error":"..."}
```
Invalid types, ranges, missing or ambiguous user targets and unknown rate types are refused before transport. HTTP 401/403, 404 and 422 return localized messages without raw server text; rate 403 names manage_rates. Temporary failures are retried once.

### Configuration

Enable the connection in Manor Setup. Mock needs no credential or instance. Production/Test require an administrator-configured instance and API key. The Read role can invoke these types; it cannot edit setup or keys.
Only enabled users can receive time entries. Project owners need owns_projects=true. Omitted filters do not filter; enabledOnly=false also leaves all users.
Each call reads one page. Continue through meta.last_page even if a local filter returns no rows. Source metadata describes the unfiltered page, while noOfRecords counts the returned rows.

### Related Message Types

- `Manor.Connection.Test`
- `Manor.Firm.List`
- `Manor.User.Get`
- `Manor.Rate.List`

## Manor.User.Get
**Direction**: Outbound (Read)
**Category**: Manor

### Overview

Reads one Manor employee by user ID or email address.

### Request Format

| Parameter | Type | Required | Description |
|---|---|---|---|
| `userId` | integer | No | Positive Manor user ID. Send exactly one of userId and email. |
| `email` | string | No | User email. Send exactly one of userId and email. |
| `userId` | integer | No | Positive Manor user ID. Send exactly one of userId and email. |
| `email` | string | No | User email. Send exactly one of userId and email. |
```json
{
  "type": "Manor.User.Get",
  "data": {
    "userId": 1
  }
}
```

### Response Format

```json
{
  "status": "Success",
  "noOfRecords": 1,
  "result": [
    {
      "id": 1,
      "name": "XDemo employee",
      "enabled": true
    }
  ]
}
```

### Response Fields

| Field | Type | Description |
|---|---|---|
| `noOfRecords` | integer | Number of rows returned after local filtering. |
| `result` | array | Employees with id, name, email, enabled, owns_projects and approves_invoices. |
| `meta` | object | Source-page metadata for lists; absent for single reads and ping. |

### Error Response

```json
{"status":"Error","code":"BusinessCentralError","error":"..."}
```
Invalid types, ranges, missing or ambiguous user targets and unknown rate types are refused before transport. HTTP 401/403, 404 and 422 return localized messages without raw server text; rate 403 names manage_rates. Temporary failures are retried once.

### Configuration

Enable the connection in Manor Setup. Mock needs no credential or instance. Production/Test require an administrator-configured instance and API key. The Read role can invoke these types; it cannot edit setup or keys.
Only enabled users can receive time entries. Project owners need owns_projects=true.

### Related Message Types

- `Manor.Connection.Test`
- `Manor.Firm.List`
- `Manor.User.List`
- `Manor.Rate.List`

## Manor.Rate.List
**Direction**: Outbound (Read)
**Category**: Manor

### Overview

Lists Manor rates; prices exclude client and project special terms.

### Request Format

| Parameter | Type | Required | Description |
|---|---|---|---|
| `page` | integer | No | Page number, at least 1. Default 1. |
| `perPage` | integer | No | Rows per page, 1 to 100. Default 100. |
| `updated_since` | string | No | ISO 8601 timestamp for incremental reads, inclusive. |
| `type` | string | No | Rate type: time, travel (mileage), product or per_diem. Applied in Business Central. |
| `page` | integer | No | Page number, at least 1. Default 1. |
| `perPage` | integer | No | Rows per page, 1 to 100. Default 100. |
| `updated_since` | string | No | ISO 8601 timestamp for incremental reads, inclusive. |
| `type` | string | No | Rate type: time, travel (mileage), product or per_diem. Applied in Business Central. |
```json
{
  "type": "Manor.Rate.List",
  "data": {
    "type": "time"
  }
}
```

### Response Format

```json
{
  "status": "Success",
  "noOfRecords": 1,
  "result": [
    {
      "id": 1,
      "name": "XTime",
      "type": "time",
      "price": 100,
      "latest_price": 110
    }
  ]
}
```

### Response Fields

| Field | Type | Description |
|---|---|---|
| `noOfRecords` | integer | Number of rows returned after local filtering. |
| `result` | array | Rates with id, name, type, price and latest_price. Special terms are not exposed by Manor. |
| `meta` | object | Source-page metadata for lists; absent for single reads and ping. |

### Error Response

```json
{"status":"Error","code":"BusinessCentralError","error":"..."}
```
Invalid types, ranges, missing or ambiguous user targets and unknown rate types are refused before transport. HTTP 401/403, 404 and 422 return localized messages without raw server text; rate 403 names manage_rates. Temporary failures are retried once.

### Configuration

Enable the connection in Manor Setup. Mock needs no credential or instance. Production/Test require an administrator-configured instance and API key. The Read role can invoke these types; it cannot edit setup or keys.
Requires manage_rates (Manor administrator role). price is the base price; latest_price is the current price period. Special terms can override both, so neither is necessarily the billed price. Mileage uses the canonical type travel.
Each call reads one page. Continue through meta.last_page even if a local filter returns no rows. Source metadata describes the unfiltered page, while noOfRecords counts the returned rows.

### Related Message Types

- `Manor.Connection.Test`
- `Manor.Firm.List`
- `Manor.User.List`
- `Manor.User.Get`


Canonical Foundation contract chapters remain English. The envelope, parameters, response and errors also carry `translations.is-IS` metadata; discovery descriptions follow the session language.



API reference: [Manor API](https://api.manor.is/) (2026-11-27).
