# [M1] Issue 5: Project Setup, Architecture and CI

Status: Draft
Issue: #5
Epic: #1
Owner: TBD

## Problem

The repo is empty. Offline-first + BLE + sync is easy to get wrong without
clear boundaries between UI, domain logic, device I/O and persistence.

## Goal

Create the Flutter project with the recommended architecture, tooling,
flavors and CI so feature issues can be built consistently.

## Non-Goals

- Feature screens (M2–M4).

## Recommended architecture

**Feature-first, layered** (inspired by Clean Architecture, without ceremony):

```text
lib/
  main_dev.dart / main_staging.dart / main_prod.dart
  app/                 # App widget, router, theme, DI bootstrap, flavors
  core/
    config/            # Env (dart-define), flavor config
    network/           # Dio client, auth interceptor, error mapping
    storage/           # drift database, secure storage wrappers
    errors/            # Failure types, Result<T>
    l10n/              # es-MX (default), en
    utils/
  features/
    auth/              # data / domain / presentation
    app_update/
    sessions/          # session list + prefetch
    catalog/           # catalog download + cache
    floor_plan/
    wall_capture/
    laser/             # BLE device abstraction + GLM 50-27 C adapter
    validation/        # Dart rules engine (catalog-driven)
    photos/
    review/
    sync/              # outbox + sync engine
test/ integration_test/
```

Per feature:

- `domain/` — pure Dart entities, value objects (`Millimeters`,
  `MeasuredValue{value, source}`), repository interfaces, use cases.
  No Flutter imports.
- `data/` — DTOs (freezed/json_serializable), remote data sources (Dio),
  local data sources (drift DAOs), repository implementations.
- `presentation/` — widgets, Riverpod controllers/notifiers.

Dependency rule: `presentation → domain ← data`. Device I/O (BLE, camera,
connectivity) is behind interfaces in `domain` so it can be faked in tests.

### Recommended stack

| Concern | Choice | Why |
| --- | --- | --- |
| State + DI | `flutter_riverpod` (+ `riverpod_generator`) | Testable, compile-safe DI, no BuildContext coupling |
| Routing | `go_router` | Declarative, redirect for auth/update gates |
| HTTP | `dio` | Interceptors for JWT, retries, multipart upload progress |
| Models | `freezed` + `json_serializable` | Immutable models, unions for states |
| Local DB | `drift` (SQLite) | Relational, typed queries, migrations, reactive streams |
| Secrets | `flutter_secure_storage` | Keychain / Keystore for JWT |
| BLE | `flutter_blue_plus`, Bosch SDK via platform channels, or a community library | Decided by spike #8; hidden behind `LaserDevice` |
| Camera | `image_picker` / `camera` + `flutter_image_compress` | Evidence photos |
| Connectivity | `connectivity_plus` | Trigger sync |
| Background | `workmanager` (Android); foreground sync on iOS | iOS background limits |
| Updates | Custom `AppUpdater`: direct APK download + sha256 + Android installer (pilot) | See #7 |
| i18n | `flutter_localizations` + `gen-l10n` | es-MX default |
| Logging/crash | TBD (Sentry or Firebase Crashlytics) | Open question |
| Lints | `very_good_analysis` or `flutter_lints` (strict) | Consistency |

### Flavors / environments

- `dev` (local Studio via LAN IP), `staging`, `prod`.
- Config via `--dart-define-from-file=env/<flavor>.json` (`STUDIO_BASE_URL`,
  `APP_CONFIG_URL`); no secrets in the repo.
- Android `productFlavors` and iOS schemes/configurations with distinct app ids
  so dev and prod can be installed side by side.

## Acceptance Criteria

- [ ] `flutter create` with org `com.kalitron` (final app id: open question).
- [ ] Folder structure above with one example feature wired end-to-end (e.g. app version screen).
- [ ] Three flavors run on Android emulator and iOS simulator.
- [ ] `flutter analyze` clean with strict lints; `dart format` enforced.
- [ ] GitHub Actions: analyze + unit/widget tests on every PR; debug APK artifact.
- [ ] Release workflow builds a **signed release APK** (keystore from CI secrets), computes sha256 and attaches both to the release (input for Studio #114).
- [ ] iOS builds deferred (pilot is Android direct APK); project stays iOS-compatible.
- [ ] `.gitattributes` with `* text=auto` to avoid CRLF noise (repo lives on Windows).
- [ ] `README.md` explains how to run each flavor.

## Platform Notes

- Android: `minSdk` 24+ (BLE permission model differs < 31; see M2).
- iOS: deployment target 13+ (TBD by Bosch SDK requirements).

## Test Plan

- CI green on a sample unit test, widget test and `integration_test` smoke test.

## Open Questions

- [ ] Final application id / bundle id (e.g. `com.kalitron.kfs`).
- [ ] iOS CI when iOS is enabled: GitHub macOS runners, Codemagic, or local Mac?
- [ ] Crash reporting provider.
- [ ] Minimum OS versions (depend on Bosch SDK).
