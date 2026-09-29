# [M5] Issue 25: Islands and Peninsulas in Distribution Mode (v0)

Status: Draft
Issue: #25
Epic: #20
Studio: outis10/kalitron-furniture-studio#128 (model + rules)
Depends on: #22, #23
Owner: TBD

## Goal

During the visit, add a rough island or peninsula to the v0 so Studio and the
AI proposals start from what the client wants.

## User Flow

1. In "Distribución": **Agregar isla** / **Agregar península**.
2. Anchor wall (picker), distance along the wall from its left corner, distance
   from the wall face (island only; laser allowed), depth, overhang for seating.
3. Items per side (`Frente` working side, `Atrás` seating/storage) with the
   same library buttons and ripple as wall runs (only modules allowed on
   freestanding runs).
4. **Mini plan view** (top view): walls, wall runs, island/peninsula
   rectangle, aisle distances colored (ok / warning / error).
5. Issues from #23 (aisles, inside room, floor services warning).

## Rules

- Positions are anchored to a wall (never absolute coordinates typed by the user).
- If the room is not closed (walls/corners incomplete), aisle checks show
  "no se puede verificar" (INFO) instead of blocking.

## Acceptance Criteria

- [ ] An island and a peninsula can be added, edited and removed offline.
- [ ] Aisle distances are shown and validated live.
- [ ] Synced v0 shows the island/peninsula in the Studio plan view.

## Test Plan

- Widget: anchor form, mini plan view rendering, aisle coloring.
- Unit: plan coordinates from wall anchor (shared vectors).
