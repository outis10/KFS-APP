# [M1] Issue 6: Authentication Against Studio (JWT + Refresh Tokens)

Status: Draft
Issue: #6
Epic: #1
Studio: outis10/kalitron-furniture-studio#115 (mobile refresh tokens), #116 (`ROLE_MEASURER`)
Owner: TBD

## Problem

Only assigned measurers may download sessions and sync measurements. Visits
happen without signal, and a lost phone must be revocable.

## Goal

Log in once per device; stay logged in while the app is used; refresh silently
when online; never lose captured data because of auth.

## Non-Goals

- Registration or password reset in the app (link to Studio web).
- Google sign-in (open question).

## Studio API Used (#115, #116)

| Call | Notes |
| --- | --- |
| `POST /api/mobile/auth/login` `{ username, password, deviceId, deviceName, platform, appVersion }` | Returns access JWT (≈1 h) + refresh token (60 days sliding). `403` if user lacks `ROLE_MEASURER`/`ROLE_ADMIN`. |
| `POST /api/mobile/auth/refresh` `{ refreshToken, deviceId }` | Rotates: returns a new pair; old refresh token becomes invalid. |
| `POST /api/mobile/auth/logout` | Revokes this device. |
| `GET /api/account` | Profile and authorities. |

## Behavior

- `deviceId`: random UUID generated on first launch, kept in secure storage.
- Tokens in `flutter_secure_storage` (Keychain / Android Keystore).
- Dio interceptor:
  - adds `Authorization: Bearer <access>`;
  - on `401` or access near expiry → **single-flight** refresh (one refresh
    at a time, other requests wait), then retry once;
  - refresh `401` (expired/revoked/reused) → mark session expired → login sheet.
- Must persist the **new** refresh token before using it (rotation): if the app
  dies mid-refresh, the old token may be invalid → user logs in again; no data lost.
- **Offline:** everything works with local data; access expiry is irrelevant
  until the network returns. Sync (M4 #17) waits for a valid token.
- Different user logging in while another user's data is unsynced → blocked
  with explanation.

## User Flow

1. Start → update gate (#7) → valid refresh token? → sessions list.
2. Else login (user + password). Success → store tokens + profile.
3. Logout → warning if unsynced data → revoke device → clear tokens.

## UI States

- Loading: button spinner.
- Error: invalid credentials vs no role (`403`: "Tu usuario no tiene permiso de medición") vs network.
- Offline at first login: "Necesitas conexión para el primer inicio de sesión".
- Session expired: non-blocking banner "Inicia sesión para sincronizar".

## Acceptance Criteria

- [ ] Login once; app restarts keep the session.
- [ ] Access token refresh is silent and single-flight.
- [ ] Revoked device (admin action) is forced to log in on the next online call; local data kept.
- [ ] Users without `ROLE_MEASURER`/`ROLE_ADMIN` cannot use the app.
- [ ] Tokens never appear in logs or crash reports.

## Test Plan

- Unit: interceptor (single-flight, retry once, rotation persistence), role check.
- Widget: login states.
- Integration: Studio dev with short token lifetimes.

## Open Questions

- [ ] Google sign-in on mobile?
- [ ] Biometric unlock of the stored session?
- [ ] On logout, keep or wipe unsynced local data?
