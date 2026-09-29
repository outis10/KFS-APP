# Spec-Driven Development — KFS-APP

KFS-APP is the Flutter (Android + iOS) on-site measurement app for Kalitron
Furniture Studio. It follows the same Spec-Driven Development workflow as
`outis10/kalitron-furniture-studio`.

Parent plan (source of truth for capture rules, nomenclature and validation):
`kalitron-furniture-studio/docs/specs/e12-site-measurement/plan.md`
(Studio epic outis10/kalitron-furniture-studio#104).

## Workflow

1. Create a branch for the issue: `feat/mN-short-description`.
2. Add or update the spec under `docs/specs/mN-feature-name/`.
3. Keep the spec in `Draft` while requirements are still changing.
4. Review Studio API usage, local data, UI states (incl. offline and
   permissions), platform notes, failures and tests.
5. Move the spec to `Reviewed`, then implement.
6. Update the spec if implementation changes the contract.
7. Move the spec to `Implemented` when the PR is ready.

## Status Values

| Status | Meaning |
| --- | --- |
| Draft | Requirements are being shaped. Do not implement yet. |
| Reviewed | Scope and contracts are stable enough to build. |
| Implementing | Code is in progress against this spec. |
| Implemented | Code and verification are complete. |

## Epics

| Epic | Issue | Folder |
| --- | --- | --- |
| M1 App foundation — architecture, JWT auth, auto-update | #1 | `m1-app-foundation/` |
| M2 Bosch GLM 50-27 C laser over BLE | #2 | `m2-ble-laser/` |
| M3 On-site measurement capture | #3 | `m3-measurement-capture/` |
| M4 Offline-first storage and sync | #4 | `m4-offline-sync/` |
| M5 Distribution mode — v0 on site (Studio E13 #118) | #20 | `m5-distribution-mode/` |

## Directory Layout

```text
docs/specs/
  README.md
  templates/
    feature-spec-template.md
    api-contract-template.md
  m1-app-foundation/     epic.md, 05-…, 06-…, 07-…
  m2-ble-laser/          epic.md, 08-…, 09-…, 18-…
  m3-measurement-capture/ epic.md, 10-… … 15-…
  m4-offline-sync/       epic.md, 16-…, 17-…
  m5-distribution-mode/  epic.md, 21-… … 24-…
```

## Rules

- One GitHub issue ↔ one spec.
- The app never defines nomenclature or validation rules; it consumes the
  Studio catalog (outis10/kalitron-furniture-studio#105).
- Studio is authoritative for validation and confirmation; the app is
  authoritative for nothing except unsynced local drafts.
- Every screen spec covers loading, empty, error, success, **offline** and
  **permission denied** states.
- Commit format: `type(mN): description - closes #N`.
