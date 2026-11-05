# Public Transport / Metro Ticketing System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| rider_id | ticket records (list) |
| --- | --- |
| 201 | [401] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| ticket.ticket_id | ticket.rider_id | ticket.product_id | ticket.status | rider.rider_id | rider.email | fare_product.product_id | fare_product.product_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 201 | 301 | active | 201 | rider201@example.test | 301 | Day Pass |

Key: ticket_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## ticket_example

| ticket.ticket_id | ticket.rider_id | ticket.product_id | ticket.status | rider.rider_id | rider.email | fare_product.product_id | fare_product.product_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 201 | 301 | active | 201 | rider201@example.test | 301 | Day Pass |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## station

| station_id | station_name | zone | opened_on |
| --- | --- | --- | --- |
| 101 | Central | 1 | 2020-01-15 |

## rider

| rider_id | email | created_at |
| --- | --- | --- |
| 201 | rider201@example.test | 2026-01-10T09:00:00+00:00 |

## fare_product

| product_id | product_name | price | validity_days | enabled |
| --- | --- | --- | --- | --- |
| 301 | Day Pass | 8.5 | 1 | true |

## ticket

| ticket_id | rider_id | product_id | issued_at | expires_at | status |
| --- | --- | --- | --- | --- | --- |
| 401 | 201 | 301 | 2026-06-01T08:00:00+00:00 | 2026-06-02T08:00:00+00:00 | active |

## validation_event

| event_id | ticket_id | station_id | event_time | event_type | device_id |
| --- | --- | --- | --- | --- | --- |
| 501 | 401 | 101 | 2026-06-01T08:15:00+00:00 | entry | gate-central-01 |

## Dependencies

- station: (station_id) → station_name, zone, opened_on
- rider: (rider_id) → email, created_at
- fare_product: (product_id) → product_name, price, validity_days, enabled
- ticket: (ticket_id) → rider_id, product_id, issued_at, expires_at, status
- validation_event: (event_id) → ticket_id, station_id, event_time, event_type, device_id

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
