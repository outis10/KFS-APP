---
epic: M3
title: On-site measurement capture
status: Draft
issues: "#10 #11 #12 #13 #14 #15"
studio_epic: "outis10/kalitron-furniture-studio#104"
---

# M3 — On-site measurement capture

Status: Draft
Epic: #3
Studio: outis10/kalitron-furniture-studio#105 (catalog), #112 (sync API), #113 (rules)

## Goal

A designer captures a full room offline: floor plan (walls, corners), per-wall
lengths and elements through nomenclature buttons, laser or manual values,
photos per wall, instant validation and a final review/confirm.

## Capture rules

See the Studio plan (`kalitron-furniture-studio/docs/specs/e12-site-measurement/plan.md`,
section *Capture Rules*). Summary: millimeters only; walls `A…n` clockwise from
the left of the entry door; corners `E-AB` with angle if ≠ 90°; three lengths per
wall (floor, 900 mm, ceiling; design uses the minimum); X cumulative from the
wall's left corner; Y from finished floor; at least one photo per wall.

## Issues

| Issue | Spec |
| --- | --- |
| #10 Download sessions and catalog | [10-download-sessions-and-catalog.md](10-download-sessions-and-catalog.md) |
| #11 Floor plan capture | [11-floor-plan-capture.md](11-floor-plan-capture.md) |
| #12 Wall capture with nomenclature buttons | [12-wall-capture.md](12-wall-capture.md) |
| #13 Instant validation engine | [13-validation-engine.md](13-validation-engine.md) |
| #14 Wall evidence photos | [14-wall-photos.md](14-wall-photos.md) |
| #15 Review and confirm | [15-review-and-confirm.md](15-review-and-confirm.md) |

## Epic acceptance criteria

- [ ] A full kitchen can be captured in airplane mode.
- [ ] Every code and required field comes from the Studio catalog.
- [ ] The Dart engine passes Studio's conformance vectors.
