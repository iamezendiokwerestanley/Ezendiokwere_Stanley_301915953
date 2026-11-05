-- Fictional sample records for Public Transport / Metro Ticketing System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."station" ("station_id", "station_name", "zone", "opened_on") VALUES (101, 'Central', 1, '2020-01-15');
INSERT INTO portfolio."rider" ("rider_id", "email", "created_at") VALUES (201, 'rider201@example.test', '2026-01-10T09:00:00Z');
INSERT INTO portfolio."fare_product" ("product_id", "product_name", "price", "validity_days", "enabled") VALUES (301, 'Day Pass', 8.5, 1, TRUE);
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status") VALUES (401, 201, 301, '2026-06-01T08:00:00Z', '2026-06-02T08:00:00Z', 'active');
INSERT INTO portfolio."validation_event" ("event_id", "ticket_id", "station_id", "event_time", "event_type", "device_id") VALUES (501, 401, 101, '2026-06-01T08:15:00Z', 'entry', 'gate-central-01');
COMMIT;
