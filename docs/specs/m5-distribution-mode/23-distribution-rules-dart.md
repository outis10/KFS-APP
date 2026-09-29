# [M5] Issue 23: Distribution Rules in the Dart Validation Engine

Status: Draft
Issue: #23
Epic: #20
Studio: outis10/kalitron-furniture-studio#122 (rules, kinds, vectors)
Extends: #13 (Dart engine)
Owner: TBD

## Goal

Add the distribution rule kinds (`rulesEngineVersion` 2) to the Dart engine so
the app validates v0 instantly and offline with the same results as Studio.

## Kinds to implement

`FITS_SEGMENT`, `FILLER_AT_END`, `CONTAINS_POINT`, `MIN_CLEARANCE`,
`NO_COLLISION`, `WIDTH_ALLOWED`, `CODE_IN_LIBRARY`, `STATE_IS`,
`MIN_DISTANCE_BETWEEN_RUNS`, `INSIDE_ROOM` (islands/peninsulas, #25) — semantics in
Studio #122; rules/params from the catalog (effective values incl. admin overrides, Studio #127); acknowledgeable flag supported
(display only — acknowledgements are done in Studio).

## Acceptance Criteria

- [ ] Passes 100 % of Studio distribution conformance vectors.
- [ ] Validation of a full kitchen < 100 ms on a mid-range Android device.
- [ ] Catalog requiring a higher `rulesEngineVersion` triggers the forced update flow (#7).

## Test Plan

- Unit per kind; vector runner shared with #13.
