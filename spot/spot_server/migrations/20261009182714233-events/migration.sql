BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "event" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "category" text NOT NULL,
    "startsAt" timestamp without time zone NOT NULL,
    "lat" double precision NOT NULL,
    "lng" double precision NOT NULL,
    "locationName" text NOT NULL,
    "capacity" bigint NOT NULL,
    "hostId" uuid NOT NULL,
    "hostName" text NOT NULL,
    "status" text NOT NULL DEFAULT 'open'::text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "event_starts_at_idx" ON "event" USING btree ("startsAt");
CREATE INDEX "event_host_idx" ON "event" USING btree ("hostId");
CREATE INDEX "event_lat_lng_idx" ON "event" USING btree ("lat", "lng");


--
-- MIGRATION VERSION FOR spot
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('spot', '20261009182714233-events', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261009182714233-events', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
