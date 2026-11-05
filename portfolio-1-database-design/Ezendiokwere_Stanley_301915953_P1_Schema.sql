-- Public Transport / Metro Ticketing System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."station" (
  "station_id" bigint NOT NULL,
  "station_name" text NOT NULL,
  "zone" bigint NOT NULL,
  "opened_on" date NOT NULL,
  CONSTRAINT "pk_station" PRIMARY KEY ("station_id"),
  CONSTRAINT "uq_station_0" UNIQUE ("station_name")
);
CREATE TABLE portfolio."rider" (
  "rider_id" bigint NOT NULL,
  "email" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_rider" PRIMARY KEY ("rider_id"),
  CONSTRAINT "uq_rider_0" UNIQUE ("email")
);
CREATE TABLE portfolio."fare_product" (
  "product_id" bigint NOT NULL,
  "product_name" text NOT NULL,
  "price" numeric(18,2) NOT NULL,
  "validity_days" bigint NOT NULL,
  "enabled" boolean NOT NULL,
  CONSTRAINT "pk_fare_product" PRIMARY KEY ("product_id"),
  CONSTRAINT "uq_fare_product_0" UNIQUE ("product_name")
);
CREATE TABLE portfolio."ticket" (
  "ticket_id" bigint NOT NULL,
  "rider_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "issued_at" timestamptz NOT NULL,
  "expires_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_ticket" PRIMARY KEY ("ticket_id")
);
CREATE TABLE portfolio."validation_event" (
  "event_id" bigint NOT NULL,
  "ticket_id" bigint NOT NULL,
  "station_id" bigint NOT NULL,
  "event_time" timestamptz NOT NULL,
  "event_type" text NOT NULL,
  "device_id" text NOT NULL,
  CONSTRAINT "pk_validation_event" PRIMARY KEY ("event_id")
);
ALTER TABLE portfolio."ticket" ADD CONSTRAINT "fk_ticket_0" FOREIGN KEY ("rider_id") REFERENCES portfolio."rider" ("rider_id");
ALTER TABLE portfolio."ticket" ADD CONSTRAINT "fk_ticket_1" FOREIGN KEY ("product_id") REFERENCES portfolio."fare_product" ("product_id");
ALTER TABLE portfolio."validation_event" ADD CONSTRAINT "fk_validation_event_0" FOREIGN KEY ("ticket_id") REFERENCES portfolio."ticket" ("ticket_id");
ALTER TABLE portfolio."validation_event" ADD CONSTRAINT "fk_validation_event_1" FOREIGN KEY ("station_id") REFERENCES portfolio."station" ("station_id");
ALTER TABLE portfolio."fare_product" ADD CONSTRAINT "fare_product_price_positive" CHECK (("price" > 0) AND ("validity_days" > 0));
ALTER TABLE portfolio."ticket" ADD CONSTRAINT "ticket_status_allowed" CHECK (("status" = 'active') OR ("status" = 'redeemed') OR ("status" = 'expired') OR ("status" = 'void'));
CREATE UNIQUE INDEX "ticket_one_active_per_rider" ON portfolio."ticket" ("rider_id") WHERE ("status" = 'active');
ALTER TABLE portfolio."validation_event" ADD CONSTRAINT "event_type_allowed" CHECK (("event_type" = 'entry') OR ("event_type" = 'exit'));
COMMIT;
