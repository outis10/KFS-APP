# [M1] Issue 7: Auto-Update (Direct APK Pilot) and Minimum Supported Version

Status: Draft
Issue: #7
Epic: #1
Studio: outis10/kalitron-furniture-studio#114 (app config + APK hosting), #105 (`minAppVersion` in catalog)
Owner: TBD

## Problem

The pilot is distributed internally as a **direct APK** (no Play Store), so
there is no store to push updates. Rules and the sync contract evolve, and old
versions must be retired.

## Goal

The app checks Studio's policy, downloads new APKs itself, verifies them and
hands them to the Android installer; forced updates block outdated versions.

## Non-Goals

- iOS distribution (deferred). The update module keeps a `distribution`
  switch so Play Store / App Store / TestFlight can be added later.
- Silent installs (Android always asks the user to confirm).

## Studio API Used

`GET /api/mobile/app-config?platform=android` →
`minSupportedVersion`, `latestVersion`, `latestVersionCode`, `distribution`
(`DIRECT_APK`), `downloadUrl`, `sha256`, `fileSizeBytes`, `releaseNotesEsMx`,
`catalogVersion`, `maintenance`.

Also: catalog `minAppVersion` (#105).

## Behavior

1. On cold start and on resume (max once per hour): fetch app-config.
2. Decision:
   - `current < minSupportedVersion` or `current < catalog.minAppVersion` →
     **forced** screen.
   - `currentVersionCode < latestVersionCode` → **optional** dialog (once per version).
   - offline / error → cached policy; never block because the check failed.
3. Update (`DIRECT_APK`):
   1. Download APK to app cache with progress; resumable (`Range`).
   2. Verify `sha256` and size; mismatch → delete and show error.
   3. If "install unknown apps" is not allowed for KFS-APP, show a one-time
      guide and open the system setting (`REQUEST_INSTALL_PACKAGES`).
   4. Launch the Android package installer (FileProvider URI).
   5. Android verifies the signature matches the installed app.
4. Before installing, the app triggers a sync attempt and warns if unsynced
   data exists (data is kept in the app's database; updates preserve it).

## Implementation notes

- Android manifest: `REQUEST_INSTALL_PACKAGES`, FileProvider.
- Package: a maintained Flutter plugin for APK download/install or a small
  platform channel using `PackageInstaller` — chosen during implementation
  (both hidden behind an `AppUpdater` interface).
- Release APKs signed with the **same** release keystore forever; CI signs
  from secrets; keystore backed up outside the repo.
- `versionCode` monotonically increasing (`pubspec.yaml` `version: x.y.z+code`).

## UI States

- Forced: full screen, no back; "Actualizar" + progress + "Exportar datos locales".
- Optional: dialog with release notes; "Actualizar" / "Más tarde".
- Download error / checksum mismatch: retry.
- Permission denied (unknown sources): explanation + button to settings.

## Acceptance Criteria

- [ ] A device with v1 installs v2 from within the app (real Android device).
- [ ] Corrupted/tampered download (bad sha256) is never installed.
- [ ] Raising `minSupportedVersion` blocks older apps on next start.
- [ ] Local unsynced data survives the update.
- [ ] Offline start is never blocked by the update check.

## Test Plan

- Unit: version comparison, decision table, checksum verification.
- Widget: forced/optional screens.
- Manual: v1 → v2 update on two Android versions (e.g. 10 and 14).

## Open Questions

- [ ] Public vs authenticated APK download (Studio #114).
- [ ] Shorebird code push for Dart-only hotfixes?
- [ ] iOS channel when needed (TestFlight / Ad Hoc / custom app).
