# Lestrarskilaboð Manor


## Manor.Connection.Test
**Direction**: Outbound (Read)
**Category**: Manor

### Overview

Prófar tengingu við Manor; heppnað tengipróf staðfestir ekki heimildir á gögnum.

### Request Format

| Parameter | Type | Required | Description |
|---|---|---|---|
| — | — | — | Engin viðföng. |
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
| `noOfRecords` | integer | Fjöldi skilaðra færslna eftir staðbundna síun. |
| `result` | array | Ein færsla með ok=true og skilaboðum Manor, ef þau eru til staðar. |
| `meta` | object | Lýsigögn upprunalegrar síðu fyrir lista; vantar við stakan lestur og tengipróf. |

### Error Response

```json
{"status":"Error","code":"BusinessCentralError","error":"..."}
```
Röng gerð, ógilt bil, vantandi eða tvírætt notandamarkmið og óþekkt gerð taxta eru stöðvuð fyrir sendingu. HTTP 401/403, 404 og 422 skila þýddum skilaboðum án hrátexta frá þjóni; 403 fyrir taxta nefnir manage_rates. Tímabundnar bilanir eru endurteknar einu sinni.

### Configuration

Virkjaðu tenginguna í uppsetningu Manor. Mock þarf hvorki lykil né tilvik. Production/Test þurfa tilvik og API-lykil frá kerfisstjóra. Lestrarhlutverkið getur kallað á þessar gerðir; það getur ekki breytt uppsetningu eða lyklum.
Kerfisstjóri stofnar API-lykilinn; hann notar heimildir þess notanda í eigin tilviki. Heppnað tengipróf uppfærir aðeins síðustu tengiprófun.

### Related Message Types

- `Manor.Firm.List`
- `Manor.User.List`
- `Manor.User.Get`
- `Manor.Rate.List`

## Manor.Firm.List
**Direction**: Outbound (Read)
**Category**: Manor

### Overview

Sýnir útgáfufyrirtæki og sjálfgefinn gjaldmiðil þeirra, VSK-hlutfall og Peppol-auðkenni.

### Request Format

| Parameter | Type | Required | Description |
|---|---|---|---|
| `page` | integer | No | Blaðsíðunúmer, minnst 1. Sjálfgefið 1. |
| `perPage` | integer | No | Færslur á blaðsíðu, 1 til 100. Sjálfgefið 100. |
| `updated_since` | string | No | ISO 8601 tímastimpill fyrir breytingalestur, að tímanum meðtöldum. |
| `page` | integer | No | Blaðsíðunúmer, minnst 1. Sjálfgefið 1. |
| `perPage` | integer | No | Færslur á blaðsíðu, 1 til 100. Sjálfgefið 100. |
| `updated_since` | string | No | ISO 8601 tímastimpill fyrir breytingalestur, að tímanum meðtöldum. |
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
| `noOfRecords` | integer | Fjöldi skilaðra færslna eftir staðbundna síun. |
| `result` | array | Útgáfufyrirtæki með id, name, currency_code, default_vat_rate_id og peppol_identifier. |
| `meta` | object | Lýsigögn upprunalegrar síðu fyrir lista; vantar við stakan lestur og tengipróf. |

### Error Response

```json
{"status":"Error","code":"BusinessCentralError","error":"..."}
```
Röng gerð, ógilt bil, vantandi eða tvírætt notandamarkmið og óþekkt gerð taxta eru stöðvuð fyrir sendingu. HTTP 401/403, 404 og 422 skila þýddum skilaboðum án hrátexta frá þjóni; 403 fyrir taxta nefnir manage_rates. Tímabundnar bilanir eru endurteknar einu sinni.

### Configuration

Virkjaðu tenginguna í uppsetningu Manor. Mock þarf hvorki lykil né tilvik. Production/Test þurfa tilvik og API-lykil frá kerfisstjóra. Lestrarhlutverkið getur kallað á þessar gerðir; það getur ekki breytt uppsetningu eða lyklum.
default_vat_rate_id er eina auðkenni VSK-hlutfalls sem Manor API birtir.
Hvert kall les eina síðu. Haldið áfram samkvæmt meta.last_page þótt staðbundin sía skili engum færslum. Lýsigögn lýsa ósíaðri síðu en noOfRecords telur skilaðar færslur.

### Related Message Types

- `Manor.Connection.Test`
- `Manor.User.List`
- `Manor.User.Get`
- `Manor.Rate.List`

## Manor.User.List
**Direction**: Outbound (Read)
**Category**: Manor

### Overview

Sýnir starfsmenn í Manor, valfrjálst síaða eftir heimildum og virkni.

### Request Format

| Parameter | Type | Required | Description |
|---|---|---|---|
| `page` | integer | No | Blaðsíðunúmer, minnst 1. Sjálfgefið 1. |
| `perPage` | integer | No | Færslur á blaðsíðu, 1 til 100. Sjálfgefið 100. |
| `updated_since` | string | No | ISO 8601 tímastimpill fyrir breytingalestur, að tímanum meðtöldum. |
| `owns_projects` | boolean | No | Sía eftir heimild til að eiga verkefni; ótilgreint sýnir alla. |
| `approves_invoices` | boolean | No | Sía eftir heimild til að samþykkja móttekna reikninga; ótilgreint sýnir alla. |
| `enabledOnly` | boolean | No | True heldur aðeins virkum notendum í Business Central; sjálfgefið false. |
| `page` | integer | No | Blaðsíðunúmer, minnst 1. Sjálfgefið 1. |
| `perPage` | integer | No | Færslur á blaðsíðu, 1 til 100. Sjálfgefið 100. |
| `updated_since` | string | No | ISO 8601 tímastimpill fyrir breytingalestur, að tímanum meðtöldum. |
| `owns_projects` | boolean | No | Sía eftir heimild til að eiga verkefni; ótilgreint sýnir alla. |
| `approves_invoices` | boolean | No | Sía eftir heimild til að samþykkja móttekna reikninga; ótilgreint sýnir alla. |
| `enabledOnly` | boolean | No | True heldur aðeins virkum notendum í Business Central; sjálfgefið false. |
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
| `noOfRecords` | integer | Fjöldi skilaðra færslna eftir staðbundna síun. |
| `result` | array | Starfsmenn með id, name, email, enabled, owns_projects og approves_invoices. |
| `meta` | object | Lýsigögn upprunalegrar síðu fyrir lista; vantar við stakan lestur og tengipróf. |

### Error Response

```json
{"status":"Error","code":"BusinessCentralError","error":"..."}
```
Röng gerð, ógilt bil, vantandi eða tvírætt notandamarkmið og óþekkt gerð taxta eru stöðvuð fyrir sendingu. HTTP 401/403, 404 og 422 skila þýddum skilaboðum án hrátexta frá þjóni; 403 fyrir taxta nefnir manage_rates. Tímabundnar bilanir eru endurteknar einu sinni.

### Configuration

Virkjaðu tenginguna í uppsetningu Manor. Mock þarf hvorki lykil né tilvik. Production/Test þurfa tilvik og API-lykil frá kerfisstjóra. Lestrarhlutverkið getur kallað á þessar gerðir; það getur ekki breytt uppsetningu eða lyklum.
Aðeins virkir notendur geta fengið tímafærslur. Verkefnaeigendur þurfa owns_projects=true. Ótilgreindar síur sía ekki; enabledOnly=false sýnir einnig alla notendur.
Hvert kall les eina síðu. Haldið áfram samkvæmt meta.last_page þótt staðbundin sía skili engum færslum. Lýsigögn lýsa ósíaðri síðu en noOfRecords telur skilaðar færslur.

### Related Message Types

- `Manor.Connection.Test`
- `Manor.Firm.List`
- `Manor.User.Get`
- `Manor.Rate.List`

## Manor.User.Get
**Direction**: Outbound (Read)
**Category**: Manor

### Overview

Les einn starfsmann í Manor eftir notandaauðkenni eða netfangi.

### Request Format

| Parameter | Type | Required | Description |
|---|---|---|---|
| `userId` | integer | No | Jákvætt notandaauðkenni í Manor. Sendið annaðhvort userId eða email. |
| `email` | string | No | Netfang notanda. Sendið annaðhvort userId eða email. |
| `userId` | integer | No | Jákvætt notandaauðkenni í Manor. Sendið annaðhvort userId eða email. |
| `email` | string | No | Netfang notanda. Sendið annaðhvort userId eða email. |
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
| `noOfRecords` | integer | Fjöldi skilaðra færslna eftir staðbundna síun. |
| `result` | array | Starfsmenn með id, name, email, enabled, owns_projects og approves_invoices. |
| `meta` | object | Lýsigögn upprunalegrar síðu fyrir lista; vantar við stakan lestur og tengipróf. |

### Error Response

```json
{"status":"Error","code":"BusinessCentralError","error":"..."}
```
Röng gerð, ógilt bil, vantandi eða tvírætt notandamarkmið og óþekkt gerð taxta eru stöðvuð fyrir sendingu. HTTP 401/403, 404 og 422 skila þýddum skilaboðum án hrátexta frá þjóni; 403 fyrir taxta nefnir manage_rates. Tímabundnar bilanir eru endurteknar einu sinni.

### Configuration

Virkjaðu tenginguna í uppsetningu Manor. Mock þarf hvorki lykil né tilvik. Production/Test þurfa tilvik og API-lykil frá kerfisstjóra. Lestrarhlutverkið getur kallað á þessar gerðir; það getur ekki breytt uppsetningu eða lyklum.
Aðeins virkir notendur geta fengið tímafærslur. Verkefnaeigendur þurfa owns_projects=true.

### Related Message Types

- `Manor.Connection.Test`
- `Manor.Firm.List`
- `Manor.User.List`
- `Manor.Rate.List`

## Manor.Rate.List
**Direction**: Outbound (Read)
**Category**: Manor

### Overview

Sýnir taxta í Manor; verð inniheldur ekki sérkjör viðskiptavina og verkefna.

### Request Format

| Parameter | Type | Required | Description |
|---|---|---|---|
| `page` | integer | No | Blaðsíðunúmer, minnst 1. Sjálfgefið 1. |
| `perPage` | integer | No | Færslur á blaðsíðu, 1 til 100. Sjálfgefið 100. |
| `updated_since` | string | No | ISO 8601 tímastimpill fyrir breytingalestur, að tímanum meðtöldum. |
| `type` | string | No | Gerð taxta: time (vinna), travel (akstur), product (söluvara) eða per_diem (dagpeningar). Síað í Business Central. |
| `page` | integer | No | Blaðsíðunúmer, minnst 1. Sjálfgefið 1. |
| `perPage` | integer | No | Færslur á blaðsíðu, 1 til 100. Sjálfgefið 100. |
| `updated_since` | string | No | ISO 8601 tímastimpill fyrir breytingalestur, að tímanum meðtöldum. |
| `type` | string | No | Gerð taxta: time (vinna), travel (akstur), product (söluvara) eða per_diem (dagpeningar). Síað í Business Central. |
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
| `noOfRecords` | integer | Fjöldi skilaðra færslna eftir staðbundna síun. |
| `result` | array | Taxtar með id, name, type, price og latest_price. Manor birtir ekki sérkjör. |
| `meta` | object | Lýsigögn upprunalegrar síðu fyrir lista; vantar við stakan lestur og tengipróf. |

### Error Response

```json
{"status":"Error","code":"BusinessCentralError","error":"..."}
```
Röng gerð, ógilt bil, vantandi eða tvírætt notandamarkmið og óþekkt gerð taxta eru stöðvuð fyrir sendingu. HTTP 401/403, 404 og 422 skila þýddum skilaboðum án hrátexta frá þjóni; 403 fyrir taxta nefnir manage_rates. Tímabundnar bilanir eru endurteknar einu sinni.

### Configuration

Virkjaðu tenginguna í uppsetningu Manor. Mock þarf hvorki lykil né tilvik. Production/Test þurfa tilvik og API-lykil frá kerfisstjóra. Lestrarhlutverkið getur kallað á þessar gerðir; það getur ekki breytt uppsetningu eða lyklum.
Krefst manage_rates (Stjórnandi í Manor). price er grunnverð; latest_price er núverandi verðtímabil. Sérkjör geta yfirskrifað bæði og því er hvorugt endilega innheimt verð. Akstur notar staðlaða gerðina travel.
Hvert kall les eina síðu. Haldið áfram samkvæmt meta.last_page þótt staðbundin sía skili engum færslum. Lýsigögn lýsa ósíaðri síðu en noOfRecords telur skilaðar færslur.

### Related Message Types

- `Manor.Connection.Test`
- `Manor.Firm.List`
- `Manor.User.List`
- `Manor.User.Get`


Canonical Foundation contract chapters remain English. The envelope, parameters, response and errors also carry `translations.is-IS` metadata; discovery descriptions follow the session language.



API-heimild: [Manor API](https://api.manor.is/) (2026-11-27).
