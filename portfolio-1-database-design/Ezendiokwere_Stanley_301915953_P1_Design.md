# Public Transport / Metro Ticketing System — database design

My case study records station, rider, fare_product, ticket, validation_event.

## Users

- Synthetic riders purchasing tickets
- Station staff reviewing validation activity
- Analysts summarizing synthetic station usage

## Main operations

- Maintain stations and fare products
- Issue and manage rider tickets
- Record ticket entry and exit validations
- Review and summarize validation activity

## Entities

| Entity | Information stored |
| --- | --- |
| station | A metro station where a ticket can be validated. |
| rider | A synthetic account that can hold a metro ticket. |
| fare_product | A ticket offering with a price and validity period. |
| ticket | A ticket issued to one rider for one fare product. |
| validation_event | An entry or exit validation of a ticket at a station. |

## station

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| station_id | BIGINT | PK | Yes |
| station_name | TEXT | Unique | Yes |
| zone | INTEGER |  | Yes |
| opened_on | DATE |  | Yes |
- Unique key: (station_name).

## rider

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| rider_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## fare_product

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| product_id | BIGINT | PK | Yes |
| product_name | TEXT | Unique | Yes |
| price | NUMERIC(18,2) |  | Yes |
| validity_days | INTEGER |  | Yes |
| enabled | BOOLEAN |  | Yes |
- Unique key: (product_name).

## ticket

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| ticket_id | BIGINT | PK | Yes |
| rider_id | BIGINT | FK | Yes |
| product_id | BIGINT | FK | Yes |
| issued_at | TIMESTAMPTZ |  | Yes |
| expires_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
- rider_id → rider.rider_id
- product_id → fare_product.product_id

## validation_event

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| event_id | BIGINT | PK | Yes |
| ticket_id | BIGINT | FK | Yes |
| station_id | BIGINT | FK | Yes |
| event_time | TIMESTAMPTZ |  | Yes |
| event_type | TEXT |  | Yes |
| device_id | TEXT |  | Yes |
- ticket_id → ticket.ticket_id
- station_id → station.station_id

## Relationships and business rules

- Each station has a distinct name.
- A fare product must have a positive price and a positive validity period.
- Ticket status is limited to active, redeemed, expired, or void.
- Every ticket must reference an existing rider.
- Every ticket must reference an existing fare product.
- A rider may have at most one ticket whose status is active, enforced by a partial unique index on rider_id for active tickets.
- A validation event type is limited to entry or exit.
- Every validation event must reference an existing station.

## Assumptions

- Each ticket belongs to one rider and one fare product.
- A rider may have at most one active ticket at a time; this rule is enforced by a partial unique constraint.
- Validation events record entry or exit at one station and refer to an issued ticket.
- All records and benchmark inputs are synthetic; no student names or IDs are included.

