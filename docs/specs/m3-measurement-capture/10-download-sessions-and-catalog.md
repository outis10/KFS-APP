# [M3] Issue 10: Download Design Sessions and Nomenclature Catalog for Offline Use

Status: Draft
Issue: #10
Epic: #3
Studio: outis10/kalitron-furniture-studio#105 (catalog), #116 (assigned sessions)
Depends on: #6 (auth), #16 (local storage)
Owner: TBD

## Problem

Sites often have no signal. Everything needed to measure must be on the phone
before the designer arrives.

## Goal

Before a visit, the designer downloads the sessions to measure and the current
catalog; both are available offline.

## Studio API Used

| Call | Notes |
| --- | --- |
| `GET /api/mobile/sessions` (Studio #116) | Sessions assigned to the measurer; minimal DTO (id, `sessionCode`, project type, status, client display name). |
| `GET /api/croquis/catalog` with `If-None-Match` | `304` when current. |

## User Flow

1. Home → "Sesiones" list (cached) with pull-to-refresh.
2. "Preparar visita" on a session → stored locally with status "Lista sin conexión".
3. Catalog refreshed automatically on login/refresh; version shown in settings.

## Local Data Impact

- Tables: `sessions`, `catalog_snapshots` (json + version + fetchedAt).
- Only the latest catalog is active; measurements record the `catalogVersion`
  they were validated with.

## UI States

- Loading: skeleton list. Empty: "No tienes sesiones asignadas".
- Error: retry. Offline: cached list with "Sin conexión — datos del {fecha}".
- Success: badge per session prepared offline.

## Acceptance Criteria

- [ ] Prepared sessions and catalog are usable with airplane mode on.
- [ ] Catalog is only re-downloaded when its version changes (ETag).
- [ ] Only minimal client data is cached (no address/phone unless required — open question).

## Test Plan

- Unit: repository caching, ETag handling.
- Integration: airplane-mode test after preparing a session.

## Open Questions

- [ ] Should the address be cached for navigation to the site (privacy)?
