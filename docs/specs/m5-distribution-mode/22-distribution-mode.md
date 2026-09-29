# [M5] User Story 22: Distribution Mode — Place Modules per Wall (v0)

Status: Draft
Issue: #22
Epic: #20
Studio: outis10/kalitron-furniture-studio#118 (schema), #120 (library)
Depends on: #11/#12 (walls and elements), #21, #23
Owner: TBD

## Goal

With the client, in 15–20 minutes, sketch which modules go on each wall.

## User Flow

1. Visit type "Levantamiento + distribución v0" (or switch later).
2. "Distribución" tab, available once walls have lengths (measurement can still be draft).
3. Per wall: elevation strip showing measured windows, doors, services
   (`TA`, `DR`, `GS`), beams and hood; two rows: **Bajos** and **Alacenas**.
4. Library buttons (filtered by row, big icons): tap → item appended at the
   end of the run with its default width. Also: **Relleno**, **Hueco**,
   **Electrodoméstico** (fridge, range, dishwasher…).
5. Width: stepper over allowed widths (`−` / `+`); **following items shift**
   (ripple). Long-press → exact allowed width list.
6. Drag to reorder; swipe to delete (undo).
7. Suggestions: filler at corners/out-of-plumb ends offered with one tap.
8. Live issues from #23 (e.g. "Tarja no está sobre agua/drenaje").
9. Client notes field ("Qué quiere el cliente") + quick chips (más cajones,
   alacenas hasta el techo, refrigerador grande…).
10. Badge "v0 — Preliminar" always visible.

## Rules

- Widths only from allowed widths; X derived (never typed).
- Laser not needed in this mode (approximate distribution).
- Editing allowed until Studio locks v0 (#24 receives `409 DISTRIBUTION_LOCKED`).

## UI States

- Empty wall: "Agrega el primer módulo".
- Wall without length: disabled with hint to measure first.
- Offline: fully functional.
- Locked (Studio already continued): read-only with message.

## Platform Notes

- Landscape recommended for long walls; portrait supported with horizontal scroll.
- Large touch targets; works on 360 px width.

## Acceptance Criteria

- [ ] A 3-wall kitchen can be sketched in ≤ 20 minutes (usability test with a designer).
- [ ] Changing a width shifts following items; X shown for each item.
- [ ] Only library codes and allowed widths can be used.
- [ ] Issues update on every change without network.

## Test Plan

- Widget: ripple, reorder, delete/undo, filler suggestion.
- Usability: timed session with a designer on a real kitchen.

## Open Questions

- [ ] Quick-chip list for client preferences (Kalitron to define).
- [ ] Show the client a simple summary screen at the end of the visit?
