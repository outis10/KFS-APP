# [M5] Issue 24: Sync v0 Distribution to Studio

Status: Draft
Issue: #24
Epic: #20
Studio: outis10/kalitron-furniture-studio#121 (`PUT …/distributions/by-uuid/{distributionUuid}`)
Extends: #17 (outbox)
Owner: TBD

## Goal

Send the v0 to Studio idempotently, after the measurement it depends on.

## Behavior

- New outbox kind `UPSERT_DISTRIBUTION` (`distributionUuid`, `revision`,
  `baseRevision`), ordered **after** the measurement upsert of the same visit.
- Coalesced: only the newest revision is sent.
- Responses:
  - `200/201` → store `versionNumber` and Studio issues (authoritative).
  - `409` revision conflict → conflict screen (#17).
  - `409 DISTRIBUTION_LOCKED` → Studio already continued from v0: local v0
    becomes read-only; pending local edits kept as notes and shown to the user.
  - `422 MEASUREMENT_NOT_SYNCED` → retry after the measurement upsert succeeds.
- Confirming the measurement (#15) does not require the v0 to be synced.

## Acceptance Criteria

- [ ] Replayed sync creates no duplicate versions in Studio.
- [ ] v0 is never sent before its measurement.
- [ ] Locked v0 becomes read-only without data loss.

## Test Plan

- Unit: outbox ordering and response handling with a fake API.
- Integration: Studio dev — sync v0, create v1 in Studio, edit v0 in app → locked.
