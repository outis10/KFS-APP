# [M4] Issue 16: Offline-First Local Storage

Status: Draft
Issue: #16
Epic: #4
Studio: outis10/kalitron-furniture-studio#107 (server model), #112 (payload shape)
Owner: TBD

## Goal

A local SQLite database (drift) as the single source of truth for the UI; the
network only feeds and drains it.

## Design

- UI reads from drift streams only; repositories write locally first.
- Tables (initial): `sessions`, `catalog_snapshots`, `measurements`
  (`measurementUuid`, sessionId, revision, `serverRevision`, status
  `DRAFT | CONFIRM_PENDING | CONFIRMED | CONFLICT`, `catalogVersion`, timestamps),
  `walls`, `corners`, `elements` (`elementUuid`), `measured_values` or
  columns with `{value, source, laserId}`, `photos` (`photoUuid`, path, sha256,
  uploaded flag), `outbox` (see #17).
- Every edit increments the local `revision` of the measurement.
- Mapping `Measurement → Studio payload (schemaVersion 1)` lives in one place
  and is tested against Studio fixtures (#112).
- Schema migrations with drift `MigrationStrategy`; migration tests for every version.
- Encryption at rest: evaluate SQLCipher (`sqlcipher_flutter_libs`) vs OS-level
  encryption (open question).

## Acceptance Criteria

- [ ] App killed during capture loses no confirmed field input.
- [ ] DB migrations tested from every previous schema version.
- [ ] Payload builder output matches Studio fixtures byte-for-byte (normalized JSON).
- [ ] Local data is scoped per logged-in user.

## Test Plan

- Unit: DAOs with in-memory drift; migration tests; payload builder vs fixtures.

## Open Questions

- [ ] SQLCipher or rely on device encryption?
- [ ] Retention: purge confirmed + synced measurements after N days?
