---
epic: M4
title: Offline-first storage and sync with Studio
status: Draft
issues: "#16 #17"
studio_epic: "outis10/kalitron-furniture-studio#104"
---

# M4 — Offline-first storage and sync

Status: Draft
Epic: #4
Studio: outis10/kalitron-furniture-studio#112 (sync API), #107 (model)

## Goal

Captured data is never lost (app kill, no signal, expired token) and reaches
Studio exactly once, with conflicts surfaced instead of silently overwritten.

## Issues

| Issue | Spec |
| --- | --- |
| #16 Offline-first local storage | [16-local-storage.md](16-local-storage.md) |
| #17 Sync engine with Studio | [17-sync-engine.md](17-sync-engine.md) |

## Epic acceptance criteria

- [ ] Killing the app at any point loses no captured value.
- [ ] Replayed syncs create no duplicates in Studio.
- [ ] Conflicts (`409`) are shown to the user with explicit choices.
