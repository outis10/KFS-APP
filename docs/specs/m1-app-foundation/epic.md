---
epic: M1
title: App foundation — architecture, JWT auth, auto-update
status: Draft
issues: "#5 #6 #7"
studio_epic: "outis10/kalitron-furniture-studio#104"
---

# M1 — App foundation

Status: Draft
Epic: #1
Studio epic: outis10/kalitron-furniture-studio#104

## Goal

A production-ready Flutter skeleton for Android and iOS: agreed architecture,
flavors and CI, login against Studio with JWT, and a remotely controlled
update policy so old versions can be retired.

## Issues

| Issue | Spec |
| --- | --- |
| #5 Project setup, architecture and CI | [05-project-setup-architecture.md](05-project-setup-architecture.md) |
| #6 JWT authentication against Studio | [06-jwt-authentication.md](06-jwt-authentication.md) |
| #7 Auto-update and minimum supported version | [07-auto-update.md](07-auto-update.md) |

## Epic acceptance criteria

- [ ] CI builds a signed Android release APK (+ sha256) from tags; iOS deferred.
- [ ] A measurer logs in once per device (refresh tokens) and keeps working offline.
- [ ] Studio can force an update by changing `minSupportedVersion`; the app installs the new APK itself.
