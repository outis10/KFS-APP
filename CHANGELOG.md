# Changelog

All notable changes to this project are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/); versions follow
`pubspec.yaml` (`x.y.z+build`).

## [0.1.0] — 2026-09-30

Foundation release (M1 #5). No business logic; reference template for future
Kalitron apps.

### Added

- Flutter project (`com.kalitron.kfs`) for Android and iOS.
- Flavors `dev`, `staging`, `prod` with entry points, Android product flavors
  (side-by-side install) and `env/<flavor>.json` configuration.
- Feature-first layered architecture: `app/`, `core/` (config, errors,
  logging, network, storage), `features/`.
- Riverpod 3, go_router, dio (auth + safe logging interceptors, error
  mapping), drift database, secure storage, `Result`/`Failure` error model.
- Spanish (Mexico) and English localization.
- Reference feature `app_info` ("Acerca de") wired end to end with tests.
- Strict lints (`very_good_analysis`), unit/widget tests, integration smoke test.
- GitHub Actions: CI (codegen check, format, analyze, test, dev APK) and
  tag-triggered release (prod APK + SHA-256, optional release signing).
