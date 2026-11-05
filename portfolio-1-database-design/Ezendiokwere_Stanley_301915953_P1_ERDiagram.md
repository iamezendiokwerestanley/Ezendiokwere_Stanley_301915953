# Public Transport / Metro Ticketing System — ER diagram

```mermaid
erDiagram
    direction LR
    station {
        bigint station_id PK
        text station_name UK
        integer zone
        date opened_on
    }
    rider {
        bigint rider_id PK
        text email UK
        timestamptz created_at
    }
    fare_product {
        bigint product_id PK
        text product_name UK
        numeric price
        integer validity_days
        boolean enabled
    }
    ticket {
        bigint ticket_id PK
        bigint rider_id FK
        bigint product_id FK
        timestamptz issued_at
        timestamptz expires_at
        text status
    }
    validation_event {
        bigint event_id PK
        bigint ticket_id FK
        bigint station_id FK
        timestamptz event_time
        text event_type
        text device_id
    }
    rider ||--o{ ticket : "rider_id"
    fare_product ||--o{ ticket : "product_id"
    ticket ||--o{ validation_event : "ticket_id"
    station ||--o{ validation_event : "station_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Ezendiokwere_Stanley_301915953_ERDiagram.png)
