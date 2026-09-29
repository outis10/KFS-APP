---
epic: M5
title: Distribution mode — v0 kitchen distribution on site
status: Draft
issues: "#21 #22 #23 #24 #25"
studio_epic: "outis10/kalitron-furniture-studio#118"
---

# M5 — Distribution mode (v0)

Status: Draft
Epic: #20
Studio epic: outis10/kalitron-furniture-studio#118 (E13 — versioned kitchen distribution)

## Problem

In some first visits the client has 15–20 minutes to sketch how the kitchen
would be distributed. Capturing that on paper means Studio has to re-capture
it later.

## Goal

A simple "modo distribución" in the app: after (or while) measuring, place
modules per wall using library codes and approximate widths, see instant
validation, and sync it to Studio as **v0 — preliminary**. Studio continues
from v0 without re-capture.

## Non-Goals

- Final/approved distributions (Studio only).
- 3D, renders, prices.

## Visit types

At the start of a visit: **Solo levantamiento** or **Levantamiento + distribución v0**.
The type can be changed later during the visit.

## Model

Same schema as Studio E13: per wall → runs (`BASE`, `WALL`) → ordered items
(`MODULE`, `FILLER`, `APPLIANCE_SLOT`, `GAP`) with widths; X derived.

## Issues

| Issue | Spec |
| --- | --- |
| #21 Module library offline | [21-module-library-offline.md](21-module-library-offline.md) |
| #22 Distribution mode per wall | [22-distribution-mode.md](22-distribution-mode.md) |
| #23 Distribution rules (Dart) | [23-distribution-rules-dart.md](23-distribution-rules-dart.md) |
| #24 Sync v0 | [24-sync-v0-distribution.md](24-sync-v0-distribution.md) |
| #25 Islands and peninsulas (v0) | [25-islands-and-peninsulas.md](25-islands-and-peninsulas.md) |

## Epic acceptance criteria

- [ ] A 3-wall kitchen v0 can be sketched in ≤ 20 minutes, offline.
- [ ] v0 appears in Studio as "v0 — Preliminar" linked to the measurement.
- [ ] Validation results match Studio for the shared vectors.
