# [M3] Issue 12: Capture Wall — Lengths and Elements with Nomenclature Buttons

Status: Draft
Issue: #12
Epic: #3
Studio: outis10/kalitron-furniture-studio#105 (codes + required fields)
Depends on: #11; laser input from #9 (manual works without it)
Owner: TBD

## Goal

For each wall, capture the three lengths, out-of-plumb and all elements using
catalog-driven buttons, with values from the laser or typed manually.

## User Flow

1. Open wall `A` → header with three length fields: `Piso`, `900 mm`, `Techo`
   (design length = minimum, shown live), plus `Desplome` (`dPl`) and
   optional `Cierre` (closing measurement: from the wall's **right** corner to
   the right edge of the rightmost element).
2. Element buttons grouped by catalog group (Aberturas, Servicios,
   Obstrucciones, Electrodomésticos) with code + es-MX label.
3. Tap `V` → form with the catalog's `requiredFields` for that code
   (`X`, `Y`, `A`, `H`, depth, swing for `P`).
4. Each numeric field: in **Automático** mode, focus it and press the laser
   button; in **Manual** mode (or any time), type. A small icon shows source
   (laser/manual). Mode toggle in the app bar; simulator available in dev.
5. Elements listed sorted by X, with a simple elevation strip of the wall;
   free spans between elements are **computed and displayed**, never captured.
6. Site data (`dP`) available from the floor plan / any wall.
7. Next/previous wall navigation.

## Rules

- Values are integers in mm; decimal input rejected.
- Editing a laser value manually changes its source to `MANUAL`.
- Deleting an element is soft (undo snackbar) until sync.
- Buttons and required fields come only from the downloaded catalog — no
  hardcoded codes.

## Local Data Impact

- `walls` (3 lengths + outOfPlumb + closingMm with source), `elements` (`elementUuid`,
  code, fields with source, swing, notes).

## UI States

- Empty wall: "Sin elementos — toca un código para agregar".
- Laser disconnected: status chip + manual input still enabled.
- Validation: inline issues from #13 next to affected fields.

## Platform Notes

- Numeric keypad; large touch targets for use with gloves/one hand; works in portrait on 360 px width.

## Acceptance Criteria

- [ ] Every catalog code has a button; forms show exactly its required fields.
- [ ] Free spans are derived from X/A and shown; the closing measurement is optional and validated by `WALL_CLOSURE_MISMATCH`.
- [ ] Laser value lands in the focused field; manual override marks `MANUAL`.
- [ ] Design length (min of three) updates live.
- [ ] Capturing a whole wall is possible without network or laser.

## Test Plan

- Widget: form generated from a test catalog; source flag behavior.
- Integration: fake laser stream fills fields in order.

## Open Questions

- [ ] Element ordering: by X or by capture order?
