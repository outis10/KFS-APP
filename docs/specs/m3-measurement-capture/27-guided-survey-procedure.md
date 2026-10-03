# [M3] User Story 27: Guided Survey Procedure (Step by Step, by Layers)

Status: Draft
Issue: #27
Epic: #3
Studio: outis10/kalitron-furniture-studio#105 (catalog groups/codes), #106 (backup sheet follows the same order), #112 (corner diagonal in payload)
Related: #11 (floor plan), #12 (wall capture), #9 (laser), #15 (review), #22 (v0 distribution)
Owner: TBD

## Problem

Without a fixed procedure each measurer surveys in a different order, and
omissions (a gas outlet, a beam, a whole wall) are only found at the office.
The app must guide the survey so it is complete, repeatable and fast — and so
the laser can fill fields without touching the screen.

## Goal

A **guided mode** (default) that walks the measurer through a standard
procedure, step by step, with explicit confirmations per layer; plus a free
mode for experienced users. The same procedure is the training reference and
the order of the printable backup sheet.

## Non-Goals

- Changing capture rules or validations (catalog, Studio #105/#113).
- Distribution (M5) — offered as an optional last step only.

## Procedure

**0. Before leaving** (outside the guided flow): visit prepared offline (#10),
laser charged and paired (#9).

**1. Start on site**
1. Visit type: *Solo levantamiento* / *Levantamiento + distribución v0*.
2. General photo of the room from the entry door.
3. Ceiling height.

**2. Floor plan — name the room** (#11)
1. Stand at the entry door: the wall on the **left** is **A**; continue
   clockwise (B, C, …). Illustration shown.
2. Number of walls; closed room or open (L, galley).
3. Corners `E-AB`, `E-BC`, … created automatically.

**3. Each wall, in order A → B → C …** (#12)

| Step | Captures | Notes |
| --- | --- | --- |
| 3a | Wall photo | Evidence before measuring |
| 3b | 3 lengths: floor → 900 mm → ceiling | Corner to corner; required before anything else on the wall |
| 3c | Out of plumb (`dPl`) | Optional; "No aplica" allowed |
| 3d | **Layer 1 — Openings** (`V`, `P`) | Left → right |
| 3e | **Layer 2 — Obstructions** (`CL`, `VG`, `TB`, `RG`) | Left → right |
| 3f | **Layer 3 — Services** (`TA`, `DR`, `GS`, `CT`, `AP`, `CE`) | Left → right |
| 3g | **Layer 4 — Existing appliances** (`RF`, `ES`, `PA`, `HO`, `CA`, `MW`, `LV`, `TJ`) | Left → right |
| 3h | Closing measurement | From the wall's **right** corner to the right edge of the rightmost element; skipped automatically if no element has width |
| 3i | Wall review | Wall issues (#13); fix or continue |

**Layer confirmation.** Each layer ends with an explicit answer: the measurer
adds elements and taps **"Listo"**, or taps **"No hay [aberturas] en este
muro"**. A layer cannot be left unanswered; the wall is complete only when its
4 layers are answered. Buttons in each layer show only that layer's catalog
group (codes and labels from the catalog).

**4. Corners — square check (diagonal method)**

For each corner, the measurer chooses **"Está a escuadra"** or
**"Verificar"**. To verify:

1. Mark a point **1000 mm** from the corner on each wall (legs are editable).
2. Measure the **diagonal** between the two points (laser or manual).
3. The app computes the angle with the law of cosines:
   `angle = acos((a² + b² − d²) / (2ab))`, rounded to the nearest degree.
   1000/1000 legs → 1414 mm ≈ 90°; ~12 mm of diagonal ≈ 1°.
4. The legs, the diagonal and the computed angle are stored; Studio
   recomputes the angle from the diagonal on sync (authoritative).

**5. Site** — floor out of level (`dP`) with location, or "No aplica".

**6. Final review** (#15) — summary per wall, pending issues, missing photos
and unanswered layers; confirm.

**7. Optional** — v0 distribution with the client (#22), only for visit type
*Levantamiento + distribución v0*.

## Guided mode behavior

- One step per screen; header with progress ("Muro B · Servicios · 3 de 6")
  and a short instruction + illustration.
- **Laser follows the procedure**: in automatic mode each reading fills the
  current field and advances focus to the next field of the step (e.g. floor →
  900 → ceiling; X → Y → A → H for an element). Manual typing always possible.
- "Siguiente" is enabled when the step's required data or explicit
  "No aplica / No hay" is present; ERROR issues of the wall are shown at 3i but
  do not block moving on (they block final confirmation, #15).
- **Resume**: progress is persisted (#16); reopening a measurement returns to
  the exact step.
- **Free mode** (toggle): jump to any wall/layer/step; the step list shows
  completed, pending and unanswered items. Switching back to guided resumes at
  the first incomplete step.

## Data Impact

- Local: `survey_progress` (measurementUuid, current step, per-wall layer
  answers: `DONE` / `NONE` / `PENDING`), corner checks
  (`legAMm`, `legBMm`, `diagonalMm`, `angleDeg`).
- Sync payload (Studio #112): `corners[].squareCheck { legAMm, legBMm, diagonalMm }`
  next to `angleDeg`; `walls[].layers { OPENING, OBSTRUCTION, SERVICE, APPLIANCE: DONE|NONE }`
  so Studio knows a layer was explicitly confirmed empty.

## UI States

- Loading: resuming progress.
- Empty: new measurement starts at step 1.
- Error: issues shown inline at 3i and 6.
- Offline: fully functional.
- Laser disconnected: banner + manual input; procedure unchanged.

## Platform Notes

- Large buttons, one-handed use, portrait; works on 360 px width.
- Illustrations bundled (no network).

## Acceptance Criteria

- [ ] Guided mode is the default and follows steps 1–6 in order (7 when applicable).
- [ ] A wall is complete only when lengths are captured and its 4 layers are answered (`Listo` or `No hay`).
- [ ] In automatic mode, consecutive laser readings fill the fields of a step in order without touching the screen.
- [ ] The diagonal check computes the angle (1000/1000/1414 → 90°) and stores legs, diagonal and angle.
- [ ] Closing the app mid-survey and reopening resumes at the same step.
- [ ] Free mode allows jumping anywhere and lists unanswered layers.
- [ ] Usability test: a designer completes a 3-wall kitchen in guided mode without instructions beyond the app.

## Test Plan

- Unit: step machine (next/previous/resume), layer completion, angle from diagonal.
- Widget: layer confirmation, progress header, focus advance with a fake laser stream.
- Manual: timed survey of a real kitchen.

## Open Questions

- [ ] Ceiling height: one reading or several (e.g. per wall)?
- [ ] Default leg length 1000 mm OK for small corners (e.g. columns)?
