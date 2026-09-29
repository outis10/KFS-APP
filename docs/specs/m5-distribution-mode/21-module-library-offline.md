# [M5] Issue 21: Download Module Library for Offline Use

Status: Draft
Issue: #21
Epic: #20
Studio: outis10/kalitron-furniture-studio#120 (`GET /api/module-library`)
Depends on: #10 (same prefetch flow), #16
Owner: TBD

## Goal

The module library (modules with allowed widths, rows, tags, icons; appliance
slots) is available offline, alongside the catalog.

## Behavior

- Downloaded with sessions/catalog on "Preparar visita" and on login refresh;
  `If-None-Match` → `304` when unchanged.
- Stored as `library_snapshots` (json + `libraryVersion` + fetchedAt).
- Distributions record the `libraryVersion` used.
- If a synced distribution references a code missing in a newer library, the
  item is shown as "código no disponible" (never silently replaced).

## Acceptance Criteria

- [ ] Library usable in airplane mode after preparing a visit.
- [ ] Re-download only when `libraryVersion` changes.

## Test Plan

- Unit: repository caching and ETag; widget: library panel from a fixture.
