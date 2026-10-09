BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "attendance" (
    "id" bigserial PRIMARY KEY,
    "eventId" bigint NOT NULL,
    "userId" uuid NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "attendance_event_user_idx" ON "attendance" USING btree ("eventId", "userId");
CREATE INDEX "attendance_user_idx" ON "attendance" USING btree ("userId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "attendance"
    ADD CONSTRAINT "attendance_fk_0"
    FOREIGN KEY("eventId")
    REFERENCES "event"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR spot
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('spot', '20261009183923508-attendance', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261009183923508-attendance', "timestamp" = now();

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
