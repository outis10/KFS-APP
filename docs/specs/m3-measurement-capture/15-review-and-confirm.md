# [M3] Issue 15: Review and Confirm Measurement

Status: Draft
Issue: #15
Epic: #3
Studio: outis10/kalitron-furniture-studio#112 (confirm), #110 (conversion → `MEASURED`)
Depends on: #13, #17
Owner: TBD

## Goal

Before leaving the site, the designer reviews the whole measurement, fixes all
errors and confirms; Studio makes the final decision on sync.

## User Flow

1. "Revisar" → summary: walls with design length, element counts, photo count,
   **unanswered layers** (#27), issues grouped by severity (ERROR / WARNING /
   INFO); tap → jump to field.
2. "Confirmar medición" enabled only with 0 local `ERROR`s and every wall's
   4 layers answered.
3. Confirm → local state `CONFIRM_PENDING`; outbox enqueues upsert + photos + confirm.
4. After sync:
   - Studio `200` → `CONFIRMED`, session shown as `MEASURED`.
   - Studio `422` → back to `DRAFT` with Studio's issues shown as authoritative.
   - `409` → conflict screen (#17).

## UI States

- Offline: "Confirmada localmente — pendiente de enviar a Studio".
- Syncing: progress (photos n/m).
- Success: green state with timestamp.
- Error: server issues highlighted per wall.

## Acceptance Criteria

- [ ] Confirm is disabled while any local `ERROR` exists.
- [ ] Confirming offline queues the request; the UI shows it is pending.
- [ ] Studio's issues override local ones after sync.
- [ ] A confirmed measurement becomes read-only in the app.

## Test Plan

- Widget: gating and state transitions with a fake sync repository.
- Integration: end-to-end against Studio dev (confirm → `MEASURED`).

## Open Questions

- [ ] Allow "re-open" a confirmed measurement from the app (new measurement vs revision)?
