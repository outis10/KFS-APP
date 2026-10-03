# [M3] Issue 11: Capture Floor Plan — Walls and Corners

Status: Draft
Issue: #11
Epic: #3
Depends on: #10, #16 · Flow: #27 (steps 1–2 and 4)
Owner: TBD

## Goal

Define the room's walls and corners following the capture rules, as the
skeleton for per-wall capture.

## Non-Goals

- Free-hand drawing or CAD-like editing.
- Computing exact geometry from angles (Studio/E6 owns layout geometry).

## User Flow

1. Start measurement on a prepared session → creates a local measurement
   (`measurementUuid`, revision 1).
2. Enter ceiling height (laser or manual).
3. Add walls: app proposes `A`, `B`, `C`… in order (clockwise from left of the
   entry door, reminder shown with an illustration).
4. Corners `E-AB`, `E-BC`… auto-created between consecutive walls; angle
   defaults to 90°. Square check by the **diagonal method** (#27 step 4):
   legs 1000/1000 mm (editable) + measured diagonal → computed angle.
   Optional closing corner (last → A) for closed rooms.
5. Mark which wall contains the entry door (for reference).
6. Schematic preview: simple polygon/strip of walls (not to scale if angles unknown).

## Local Data Impact

- `measurements`, `walls` (code, order), `corners` (code, angleDeg), `ceilingHeight`.

## UI States

- Empty: "Agrega el primer muro (A)". Error: invalid angle.
- Offline: fully functional.

## Acceptance Criteria

- [ ] Walls are coded sequentially `A…n`; removing a wall asks before renaming the following ones.
- [ ] Corners follow `E-XY`; angle stored only when ≠ 90° is confirmed.
- [ ] Ceiling height accepts laser input.
- [ ] Everything persists immediately (app kill safe).

## Test Plan

- Unit: code generation, renaming, corner creation.
- Widget: add/remove wall flow.

## Open Questions

- [ ] Open layouts (L-shaped rooms without a closing wall): how to represent?
- [ ] Allow renaming walls manually (e.g. skipping a letter)?
