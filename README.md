# KFS-APP

Flutter app (Android + iOS) for **on-site measurement** in Kalitron Furniture
Studio. Designers measure rooms with a Bosch GLM 50-27 C laser (or manually),
validate instantly offline and sync to Studio.

- Product plan: `kalitron-furniture-studio/docs/specs/e12-site-measurement/plan.md`
- App specs (Spec-Driven Development): [`docs/specs/`](docs/specs/README.md)

> **v0.1.0 is the foundation release**: architecture, environments, CI and
> release pipeline with no business logic. It is meant to be reused as the
> reference template for future Kalitron apps (see
> [Using this repo as a template](#using-this-repo-as-a-template)).

## Requirements

- Flutter stable (3.47+) / Dart 3.13+
- Android SDK (API 24+), JDK 17
- Xcode for iOS builds (iOS flavors are pending; Android is the pilot platform)

## Run

Each environment (flavor) has an entry point, an Android product flavor and an
`env/<flavor>.json` file with non-secret values.

```bash
flutter pub get

# dev (Studio on the host machine; 10.0.2.2 = host from the Android emulator)
flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=env/dev.json

# staging / prod
flutter run --flavor staging -t lib/main_staging.dart --dart-define-from-file=env/staging.json
flutter run --release --flavor prod -t lib/main_prod.dart --dart-define-from-file=env/prod.json
```

VS Code launch configurations are in `.vscode/launch.json`.

| Flavor | Application id | App name |
| --- | --- | --- |
| dev | `com.kalitron.kfs.dev` | KFS Dev |
| staging | `com.kalitron.kfs.stg` | KFS Staging |
| prod | `com.kalitron.kfs` | Kalitron Medición |

The three can be installed side by side.

## Code generation

```bash
dart run build_runner build --delete-conflicting-outputs   # drift, freezed, json
flutter gen-l10n                                            # localization
```

Generated files (`*.g.dart`, `lib/l10n/app_localizations*.dart`) are committed;
CI fails if they are out of date.

## Checks

```bash
dart format lib test integration_test
flutter analyze
flutter test
# on a device/emulator:
flutter test integration_test --flavor dev --dart-define-from-file=env/dev.json
```

## Architecture

Feature-first, layered. Dependency rule: `presentation → domain ← data`.

```text
lib/
  main_dev.dart · main_staging.dart · main_prod.dart   # flavor entry points
  app/            # bootstrap, app widget, router, theme
  core/
    config/       # Flavor, AppConfig (from --dart-define-from-file)
    errors/       # Failure (sealed), Result<T> (Ok/Err)
    logging/      # logging setup (never log tokens or client data)
    network/      # Dio client, auth + safe log interceptors, error mapping
    storage/      # SecureStore (Keychain/Keystore), AppDatabase (drift)
  features/
    <feature>/
      domain/        # entities + repository interfaces (pure Dart)
      data/          # repository implementations, DTOs, data sources
      presentation/  # screens, widgets, Riverpod providers
  l10n/           # app_es.arb (template), app_en.arb
```

| Concern | Choice |
| --- | --- |
| State / DI | `flutter_riverpod` 3 (providers overridden in tests) |
| Routing | `go_router` |
| HTTP | `dio` |
| Local DB | `drift` (SQLite), offline-first source of truth |
| Secrets | `flutter_secure_storage` |
| Models | `freezed` + `json_serializable` |
| i18n | `gen-l10n`, Spanish (Mexico) first |
| Lints | `very_good_analysis` |

Conventions:

- Repositories return `Result<T>`; they never throw across layers.
- Providers that fail surface a `Failure` through `AsyncValue.error`.
  Riverpod 3 retries failed providers automatically; tests disable it with
  `ProviderScope(retry: noRetry)`.
- Every screen handles loading, empty, error and success states.
- Nothing secret in `env/*.json` (public repo; values are embedded in the APK).
  Real prod URLs come from CI repository variables.

`features/app_info` is the reference feature wired end to end (repository →
provider → screen → tests).

## Release

1. Bump `version:` in `pubspec.yaml` (`x.y.z+buildNumber`; build number must
   always increase) and update `CHANGELOG.md`.
2. Merge to `main`, then tag: `git tag v0.1.0 && git push origin v0.1.0`.
3. `.github/workflows/release.yml` tests, builds the prod APK and publishes a
   GitHub release with `kfs-app-<version>.apk` and its `.sha256`.

### Signing

Release builds use `android/key.properties` (never committed). In CI it is
written from these repository secrets:

| Secret | Value |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 release.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | keystore password |
| `ANDROID_KEY_ALIAS` | key alias |
| `ANDROID_KEY_PASSWORD` | key password |

Without them the APK is **debug-signed** and the release notes say so — fine
for a reference build, not for distribution. Android only accepts updates
signed with the same key: create the keystore once, back it up outside the
repository, and never change it.

Repository variable `STUDIO_BASE_URL_PROD` provides the prod Studio URL.

## Using this repo as a template

1. Copy the repository (or use the `v0.1.0` tag) and rename:
   - `name:` in `pubspec.yaml` and every `package:kfs/` import;
   - `namespace`/`applicationId` in `android/app/build.gradle.kts` and the
     Kotlin package folder under `android/app/src/main/kotlin/`;
   - app names per flavor (`manifestPlaceholders["appName"]`);
   - iOS bundle identifier and display name in Xcode.
2. Replace `env/*.json` values, `AppTheme.seed` and `lib/l10n/*.arb`.
3. Keep `core/` as is; delete `features/app_info` once you have your own
   first feature (or keep it as the "About" screen).
4. Create the release keystore and CI secrets before the first real release.

## Specs

Work follows [`docs/specs/README.md`](docs/specs/README.md): one issue ↔ one
spec, status `Draft → Reviewed → Implementing → Implemented`.
