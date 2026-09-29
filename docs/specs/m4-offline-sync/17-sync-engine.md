# [M4] Issue 17: Sync Engine with Studio (Outbox, Idempotent, Conflicts)

Status: Draft
Issue: #17
Epic: #4
Studio: outis10/kalitron-furniture-studio#112 (sync API)
Depends on: #6, #16
Owner: TBD

## Goal

Drain local changes to Studio reliably over flaky connections, idempotently,
and surface conflicts.

## Design

- **Outbox** table: `{ id, kind: UPSERT_MEASUREMENT | UPLOAD_PHOTO | CONFIRM, measurementUuid, photoUuid?, revision, attempts, nextAttemptAt, lastError }`.
- Order per measurement: latest `UPSERT` (coalesced: only the newest revision
  is sent) → pending photos → `CONFIRM`.
- Requests are idempotent by client UUIDs (`measurementUuid`, `photoUuid`) and
  carry `revision` + `baseRevision` (= last `serverRevision` acknowledged).
- Triggers: connectivity regained, app foreground, after confirm, manual
  "Sincronizar ahora", Android periodic `workmanager` job. iOS: foreground +
  connectivity only (background not guaranteed).
- Retries: exponential backoff with jitter; no retry on `400/403/422` (needs user action).
- Photos: upload one at a time; resume on failure; optional "solo Wi-Fi".
- Responses update `serverRevision`, `validationIssues` (authoritative) and
  `catalogOutdated` → trigger catalog refresh (#10).

## Conflict handling (`409`)

- Measurement → `CONFLICT`; nothing overwritten.
- Conflict screen shows local vs server summary per wall with options:
  1. Keep server version (discard local changes).
  2. Send my version as new revision on top of server (explicit overwrite).
  3. Save my version as a new measurement (open question).
- `ALREADY_CONFIRMED` → local becomes read-only copy of server.

## UI States

- Global sync indicator: pending count, syncing, error, all synced.
- Auth expired: "Inicia sesión para sincronizar" (outbox kept).

## Acceptance Criteria

- [ ] Replaying the same outbox item creates no duplicates in Studio.
- [ ] Network drop mid-upload resumes without data loss.
- [ ] `409` leads to the conflict screen; no silent overwrite.
- [ ] Expired token pauses sync and resumes after re-login.
- [ ] Only the newest revision of a measurement is uploaded when several are pending.

## Test Plan

- Unit: outbox ordering/coalescing, backoff, response handling with a fake API.
- Integration: Studio dev with network toggling; duplicate-replay test.

## Open Questions

- [ ] Can two devices edit the same measurement, or lock to the creator?
- [ ] Option 3 (fork into a new measurement) needed?
