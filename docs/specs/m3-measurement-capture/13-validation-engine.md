# [M3] Issue 13: Instant On-Device Validation Engine

Status: Draft
Issue: #13
Epic: #3
Studio: outis10/kalitron-furniture-studio#113 (Java engine + conformance vectors), #105 (rules in catalog)
Owner: TBD

## Problem

Designers must see problems while still on site, without signal. Studio is
authoritative, but waiting for sync defeats the purpose.

## Goal

A pure-Dart engine that executes the catalog's declarative `validationRules[]`
and produces the same issues as Studio for the same input.

## Design

- `features/validation/domain/` — no Flutter imports.
- `validate(Measurement, Catalog) -> List<ValidationIssue>`.
- Implements the same closed set of rule `kind`s as Studio #113
  (`SUM_WITHIN_TOLERANCE`, `SPREAD_WITHIN_TOLERANCE`, `THRESHOLD_EXCEEDED`,
  `REQUIRED_FIELDS`, `WITHIN_BOUNDS`, `CODE_IN_CATALOG`, `SOURCE_IS`,
  `HAS_ATTACHMENT`, `NO_OVERLAP`).
- Tolerances, severities and messages are read from the catalog, never hardcoded.
- Unknown `kind` in the catalog → forced update flow (#7), not silent skip.
- Same evaluation semantics as Studio #113: `ruleSet` (`MEASUREMENT` here,
  `DISTRIBUTION` in #23), `scope` (`WALL`, `ELEMENT`, `SITE`, `MEASUREMENT`),
  **all rules evaluated** (no short-circuit), unmet `prerequisites` skip
  without issues, deterministic issue order, same issue shape.
- Runs on every edit, re-evaluating only `WALL`/`ELEMENT` rules of the edited
  wall plus `SITE`/`MEASUREMENT` rules.
- Survey-only visits run `MEASUREMENT` rules; `DISTRIBUTION` rules run only
  when a v0 exists.

## Keeping app and Studio in sync

- CI job downloads Studio's versioned conformance vectors (#113) and runs them
  against the Dart engine; PRs fail on any mismatch.
- Engine declares its supported `rulesEngineVersion`; compared with the
  catalog's value at load time.
- After sync, Studio's issues replace local ones in the UI (authoritative).

## Acceptance Criteria

- [ ] Passes 100 % of Studio conformance vectors for the supported `rulesEngineVersion`. Vectors are compared **in order**.
- [ ] Validation of one wall completes in < 100 ms on a mid-range Android device.
- [ ] Changing a tolerance in the catalog changes results without an app release.
- [ ] Unknown rule kind triggers the update-required flow.

## Test Plan

- Unit: per kind; vector runner (`test/validation/vectors_test.dart`).
- Benchmark: 20 walls × 15 elements.

## Open Questions

- [x] CI fetches vectors from the Studio GitHub release asset
      `validation-vectors-{catalogVersion}.zip` (Studio #113), verifying its sha256.
