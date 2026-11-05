-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. station pk. Expected: pk_station, SQLSTATE 23505.
INSERT INTO portfolio."station" ("station_id", "station_name", "zone", "opened_on")
VALUES (101, 'North Terminal', 2, '2021-03-01');

-- 2. station unique. Expected: uq_station_0, SQLSTATE 23505.
INSERT INTO portfolio."station" ("station_id", "station_name", "zone", "opened_on")
VALUES (10001, 'Central', 2, '2021-03-01');

-- 3. station null id. Expected: station_id, SQLSTATE 23502.
INSERT INTO portfolio."station" ("station_id", "station_name", "zone", "opened_on")
VALUES (NULL, 'Harbor', 2, '2021-03-01');

-- 4. station null name. Expected: station_name, SQLSTATE 23502.
INSERT INTO portfolio."station" ("station_id", "station_name", "zone", "opened_on")
VALUES (10002, NULL, 2, '2021-03-01');

-- 5. station null zone. Expected: zone, SQLSTATE 23502.
INSERT INTO portfolio."station" ("station_id", "station_name", "zone", "opened_on")
VALUES (10003, 'Harbor', NULL, '2021-03-01');

-- 6. station null opened. Expected: opened_on, SQLSTATE 23502.
INSERT INTO portfolio."station" ("station_id", "station_name", "zone", "opened_on")
VALUES (10004, 'Harbor', 2, NULL);

-- 7. rider pk. Expected: pk_rider, SQLSTATE 23505.
INSERT INTO portfolio."rider" ("rider_id", "email", "created_at")
VALUES (201, 'alternate201@example.test', '2026-02-01T10:00:00Z');

-- 8. rider unique. Expected: uq_rider_0, SQLSTATE 23505.
INSERT INTO portfolio."rider" ("rider_id", "email", "created_at")
VALUES (10005, 'rider201@example.test', '2026-02-01T10:00:00Z');

-- 9. rider null id. Expected: rider_id, SQLSTATE 23502.
INSERT INTO portfolio."rider" ("rider_id", "email", "created_at")
VALUES (NULL, 'rider202@example.test', '2026-02-01T10:00:00Z');

-- 10. rider null email. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."rider" ("rider_id", "email", "created_at")
VALUES (10006, NULL, '2026-02-01T10:00:00Z');

-- 11. rider null created. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."rider" ("rider_id", "email", "created_at")
VALUES (10007, 'rider203@example.test', NULL);

-- 12. fare product pk. Expected: pk_fare_product, SQLSTATE 23505.
INSERT INTO portfolio."fare_product" ("product_id", "product_name", "price", "validity_days", "enabled")
VALUES (301, 'Weekly Pass', 22, 7, TRUE);

-- 13. fare product unique. Expected: uq_fare_product_0, SQLSTATE 23505.
INSERT INTO portfolio."fare_product" ("product_id", "product_name", "price", "validity_days", "enabled")
VALUES (10008, 'Day Pass', 22, 7, TRUE);

-- 14. fare null id. Expected: product_id, SQLSTATE 23502.
INSERT INTO portfolio."fare_product" ("product_id", "product_name", "price", "validity_days", "enabled")
VALUES (NULL, 'Weekly Pass', 22, 7, TRUE);

-- 15. fare null name. Expected: product_name, SQLSTATE 23502.
INSERT INTO portfolio."fare_product" ("product_id", "product_name", "price", "validity_days", "enabled")
VALUES (10009, NULL, 22, 7, TRUE);

-- 16. fare null price. Expected: price, SQLSTATE 23502.
INSERT INTO portfolio."fare_product" ("product_id", "product_name", "price", "validity_days", "enabled")
VALUES (10010, 'Weekly Pass', NULL, 7, TRUE);

-- 17. fare null validity. Expected: validity_days, SQLSTATE 23502.
INSERT INTO portfolio."fare_product" ("product_id", "product_name", "price", "validity_days", "enabled")
VALUES (10011, 'Weekly Pass', 22, NULL, TRUE);

-- 18. fare null enabled. Expected: enabled, SQLSTATE 23502.
INSERT INTO portfolio."fare_product" ("product_id", "product_name", "price", "validity_days", "enabled")
VALUES (10012, 'Weekly Pass', 22, 7, NULL);

-- 19. fare price check. Expected: fare_product_price_positive, SQLSTATE 23514.
INSERT INTO portfolio."fare_product" ("product_id", "product_name", "price", "validity_days", "enabled")
VALUES (10013, 'Single Ride', 0, 1, TRUE);

-- 20. ticket pk. Expected: pk_ticket, SQLSTATE 23505.
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status")
VALUES (401, 201, 301, '2026-05-01T08:00:00Z', '2026-05-02T08:00:00Z', 'redeemed');

-- 21. ticket fk rider. Expected: fk_ticket_0, SQLSTATE 23503.
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status")
VALUES (10014, 90001, 301, '2026-05-01T08:00:00Z', '2026-05-02T08:00:00Z', 'redeemed');

-- 22. ticket fk product. Expected: fk_ticket_1, SQLSTATE 23503.
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status")
VALUES (10015, 201, 90002, '2026-05-01T08:00:00Z', '2026-05-02T08:00:00Z', 'redeemed');

-- 23. ticket null id. Expected: ticket_id, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status")
VALUES (NULL, 201, 301, '2026-05-01T08:00:00Z', '2026-05-02T08:00:00Z', 'redeemed');

-- 24. ticket null rider. Expected: rider_id, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status")
VALUES (10016, NULL, 301, '2026-05-01T08:00:00Z', '2026-05-02T08:00:00Z', 'redeemed');

-- 25. ticket null product. Expected: product_id, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status")
VALUES (10017, 201, NULL, '2026-05-01T08:00:00Z', '2026-05-02T08:00:00Z', 'redeemed');

-- 26. ticket null issued. Expected: issued_at, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status")
VALUES (10018, 201, 301, NULL, '2026-05-02T08:00:00Z', 'redeemed');

-- 27. ticket null expires. Expected: expires_at, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status")
VALUES (10019, 201, 301, '2026-05-01T08:00:00Z', NULL, 'redeemed');

-- 28. ticket null status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status")
VALUES (10020, 201, 301, '2026-05-01T08:00:00Z', '2026-05-02T08:00:00Z', NULL);

-- 29. ticket status check. Expected: ticket_status_allowed, SQLSTATE 23514.
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status")
VALUES (10021, 201, 301, '2026-05-01T08:00:00Z', '2026-05-02T08:00:00Z', 'pending');

-- 30. ticket partial unique. Expected: ticket_one_active_per_rider, SQLSTATE 23505.
INSERT INTO portfolio."ticket" ("ticket_id", "rider_id", "product_id", "issued_at", "expires_at", "status")
VALUES (10022, 201, 301, '2026-05-01T08:00:00Z', '2026-05-02T08:00:00Z', 'active');

-- 31. event pk. Expected: pk_validation_event, SQLSTATE 23505.
INSERT INTO portfolio."validation_event" ("event_id", "ticket_id", "station_id", "event_time", "event_type", "device_id")
VALUES (501, 401, 101, '2026-05-01T09:00:00Z', 'exit', 'gate-central-02');

-- 32. event fk ticket. Expected: fk_validation_event_0, SQLSTATE 23503.
INSERT INTO portfolio."validation_event" ("event_id", "ticket_id", "station_id", "event_time", "event_type", "device_id")
VALUES (10023, 90003, 101, '2026-05-01T09:00:00Z', 'exit', 'gate-central-02');

-- 33. event fk station. Expected: fk_validation_event_1, SQLSTATE 23503.
INSERT INTO portfolio."validation_event" ("event_id", "ticket_id", "station_id", "event_time", "event_type", "device_id")
VALUES (10024, 401, 90004, '2026-05-01T09:00:00Z', 'exit', 'gate-central-02');

-- 34. event null id. Expected: event_id, SQLSTATE 23502.
INSERT INTO portfolio."validation_event" ("event_id", "ticket_id", "station_id", "event_time", "event_type", "device_id")
VALUES (NULL, 401, 101, '2026-05-01T09:00:00Z', 'exit', 'gate-central-02');

-- 35. event null ticket. Expected: ticket_id, SQLSTATE 23502.
INSERT INTO portfolio."validation_event" ("event_id", "ticket_id", "station_id", "event_time", "event_type", "device_id")
VALUES (10025, NULL, 101, '2026-05-01T09:00:00Z', 'exit', 'gate-central-02');

-- 36. event null station. Expected: station_id, SQLSTATE 23502.
INSERT INTO portfolio."validation_event" ("event_id", "ticket_id", "station_id", "event_time", "event_type", "device_id")
VALUES (10026, 401, NULL, '2026-05-01T09:00:00Z', 'exit', 'gate-central-02');

-- 37. event null time. Expected: event_time, SQLSTATE 23502.
INSERT INTO portfolio."validation_event" ("event_id", "ticket_id", "station_id", "event_time", "event_type", "device_id")
VALUES (10027, 401, 101, NULL, 'exit', 'gate-central-02');

-- 38. event null type. Expected: event_type, SQLSTATE 23502.
INSERT INTO portfolio."validation_event" ("event_id", "ticket_id", "station_id", "event_time", "event_type", "device_id")
VALUES (10028, 401, 101, '2026-05-01T09:00:00Z', NULL, 'gate-central-02');

-- 39. event null device. Expected: device_id, SQLSTATE 23502.
INSERT INTO portfolio."validation_event" ("event_id", "ticket_id", "station_id", "event_time", "event_type", "device_id")
VALUES (10029, 401, 101, '2026-05-01T09:00:00Z', 'exit', NULL);

-- 40. event type check. Expected: event_type_allowed, SQLSTATE 23514.
INSERT INTO portfolio."validation_event" ("event_id", "ticket_id", "station_id", "event_time", "event_type", "device_id")
VALUES (10030, 401, 101, '2026-05-01T09:00:00Z', 'transfer', 'gate-central-02');
