# [M3] Issue 14: Wall Evidence Photos

Status: Draft
Issue: #14
Epic: #3
Studio: outis10/kalitron-furniture-studio#112 (photo upload), #107 (`SITE_PHOTO`)
Depends on: #12, #16
Owner: TBD

## Goal

Attach at least one photo per wall as evidence, stored locally and synced later.

## User Flow

1. In a wall, "Foto" → camera (or gallery).
2. Photo compressed and saved with `photoUuid`, `wallCode`, sha256.
3. Thumbnails in the wall header; tap to view full screen; delete with confirm.

## Rules

- Compress to max 2048 px long side, JPEG quality ~80 (tunable); strip GPS EXIF (privacy).
- Stored in app documents directory, not the public gallery.
- `WALL_WITHOUT_PHOTO` warning from the catalog rules (#13).

## UI States

- Camera permission denied → explanation + settings link; capture continues without photo (warning).
- Storage low → warning before capture.

## Platform Notes

- iOS: `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription` if gallery is used.
- Android: camera permission; scoped storage (no broad storage permission).

## Acceptance Criteria

- [ ] Photos survive app restart and are linked to the right wall.
- [ ] Uploaded photos have no GPS metadata.
- [ ] Missing photo produces a warning, not a blocker.

## Test Plan

- Unit: compression/EXIF stripping, sha256.
- Manual: camera on Android and iOS.

## Open Questions

- [ ] Photo retention policy on device after successful sync (delete after N days?).
