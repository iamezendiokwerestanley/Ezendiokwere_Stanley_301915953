-- Show related ticket, rider, fare_product records (up to 20).
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

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
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

-- Find validation_event records where event_time matches "2026-06-01T08:15:00Z" (up to 20).
SELECT * FROM portfolio."validation_event"
WHERE "event_time" IS NOT DISTINCT FROM '2026-06-01T08:15:00Z'
ORDER BY "event_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."validation_event"
WHERE "event_time" IS NOT DISTINCT FROM '2026-06-01T08:15:00Z'
ORDER BY "event_id"
LIMIT 20;

-- Count validation_event records for each ticket_id (up to 20 groups).
SELECT "ticket_id", count(*) AS record_count
FROM portfolio."validation_event"
GROUP BY "ticket_id"
ORDER BY record_count DESC, "ticket_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "ticket_id", count(*) AS record_count
FROM portfolio."validation_event"
GROUP BY "ticket_id"
ORDER BY record_count DESC, "ticket_id" NULLS LAST
LIMIT 20;
