# Public Transport / Metro Ticketing System — SQL queries

## 1. Show related ticket, rider, fare_product records (up to 20).

```sql
SELECT t0."ticket_id" AS "ticket_ticket_id",
       t0."issued_at" AS "ticket_issued_at",
       t1."rider_id" AS "rider_rider_id",
       t1."email" AS "rider_email",
       t2."product_id" AS "fare_product_product_id",
       t2."product_name" AS "fare_product_product_name"
FROM portfolio."ticket" t0
JOIN portfolio."rider" t1 ON t0."rider_id" = t1."rider_id"
JOIN portfolio."fare_product" t2 ON t0."product_id" = t2."product_id"
ORDER BY t0."ticket_id", t1."rider_id", t2."product_id"
LIMIT 20;
```

| ticket_ticket_id | ticket_issued_at | rider_rider_id | rider_email | fare_product_product_id | fare_product_product_name |
| --- | --- | --- | --- | --- | --- |
| 401 | 2026-06-01T08:00:00+00:00 | 201 | rider201@example.test | 301 | Day Pass |

## 2. Find validation_event records where event_time matches "2026-06-01T08:15:00Z" (up to 20).

```sql
SELECT * FROM portfolio."validation_event"
WHERE "event_time" IS NOT DISTINCT FROM '2026-06-01T08:15:00Z'
ORDER BY "event_id"
LIMIT 20;
```

| event_id | ticket_id | station_id | event_time | event_type | device_id |
| --- | --- | --- | --- | --- | --- |
| 501 | 401 | 101 | 2026-06-01T08:15:00+00:00 | entry | gate-central-01 |

## 3. Count validation_event records for each ticket_id (up to 20 groups).

```sql
SELECT "ticket_id", count(*) AS record_count
FROM portfolio."validation_event"
GROUP BY "ticket_id"
ORDER BY record_count DESC, "ticket_id" NULLS LAST
LIMIT 20;
```

| ticket_id | record_count |
| --- | --- |
| 401 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.389 | 2.382, 2.422, 2.389 | Sort → Seq Scan | 274 |
| After index | 0.261 | 0.261, 0.261, 0.357 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.389 ms to 0.261 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.352..2.355 rows=50 loops=1)
  Seq Scan on validation_event (actual time=0.015..2.314 rows=50 loops=1)
Planning Time: 0.328 ms
Execution Time: 2.382 ms
```

### Before index, run 2

```text
Sort (actual time=2.391..2.394 rows=50 loops=1)
  Seq Scan on validation_event (actual time=0.015..2.354 rows=50 loops=1)
Planning Time: 0.349 ms
Execution Time: 2.422 ms
```

### Before index, run 3

```text
Sort (actual time=2.358..2.361 rows=50 loops=1)
  Seq Scan on validation_event (actual time=0.015..2.32 rows=50 loops=1)
Planning Time: 0.325 ms
Execution Time: 2.389 ms
```

### After index, run 1

```text
Sort (actual time=0.199..0.201 rows=50 loops=1)
  Bitmap Heap Scan on validation_event (actual time=0.029..0.16 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=50 loops=1)
Planning Time: 0.632 ms
Execution Time: 0.261 ms
```

### After index, run 2

```text
Sort (actual time=0.2..0.202 rows=50 loops=1)
  Bitmap Heap Scan on validation_event (actual time=0.028..0.162 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=50 loops=1)
Planning Time: 0.525 ms
Execution Time: 0.261 ms
```

### After index, run 3

```text
Sort (actual time=0.274..0.278 rows=50 loops=1)
  Bitmap Heap Scan on validation_event (actual time=0.04..0.221 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=50 loops=1)
Planning Time: 0.816 ms
Execution Time: 0.357 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Ezendiokwere_Stanley_301915953_P2_Queries.sql, then Ezendiokwere_Stanley_301915953_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Ezendiokwere_Stanley_301915953_P2_QueryResults.png) · [Index comparison](screenshots/Ezendiokwere_Stanley_301915953_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

