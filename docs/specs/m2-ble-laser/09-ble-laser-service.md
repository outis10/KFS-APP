# [M2] Issue 9: BLE Laser Service — Discovery, Connection, Measurement Stream

Status: Draft
Issue: #9
Epic: #2
Depends on: #8 (path, interface, simulator) · Hardware validation: #18
Related: #12 (wall capture consumes the stream)
Owner: TBD

## Goal

The GLM 50-27 C adapter implementing the `LaserDevice` interface from #8, that exposes discovery,
connection state and a stream of measurements in millimeters to the capture UI.

## Non-Goals

- Other laser models (the interface must allow them later).
- Remote-triggering measurements from the phone, unless the spike shows it is supported.

## Design

```text
features/laser/
  domain/  LaserDevice (interface), LaserMeasurement{mm, rawValue, rawUnit, deviceId, timestamp},
           LaserConnectionState, LaserRepository
  data/    Glm5027cAdapter (SDK or BLE per spike), frame decoder
  presentation/ device picker sheet, connection status chip
```

- Discovery filtered by the Service UUID documented in the spike; decoded
  identifier shown to the user (plus a user-given alias).
- Remember last device; auto-reconnect on app resume and when the device wakes.
- Measurement stream → `LaserInputController` that routes each value to the
  **currently focused** numeric field and advances focus (configurable).
- Values not in mm are converted; unknown units are rejected with a message.
- Every value keeps `source = LASER` and `laserId`; manual edits flip it to `MANUAL`.

## UI States

- Status chip: disconnected / scanning / connected (battery if available).
- Permission denied → explanation + "Abrir ajustes" + continue manual.
- Bluetooth off → prompt to enable (Android) / instructions (iOS).
- Multiple devices found → picker with identifier/alias.

## Acceptance Criteria

- [ ] Adapter implements discovery by Service UUID, identifier decoding, connect/reconnect and the measurement stream per the #8 findings.
- [ ] Capture works identically with the simulator and the adapter (same interface).
- [ ] Mode switch Manual / Automático persists per device.
- [ ] Hardware acceptance (latency, reconnect, real readings) is verified in #18.
- [ ] Denied permissions or Bluetooth off never block manual entry.
- [ ] Adapter covered by unit tests using recorded frames from the spike.

## Test Plan

- Unit: decoder with frames from docs/fixtures (real frames added in #18); unit conversion; focus routing.
- Widget: status chip states with a fake `LaserDevice`.
- Device: Android + iOS manual test script (connect, 20 readings, sleep/wake, disconnect).

## Open Questions

- [ ] Auto-advance focus after each reading: always, or per field group?
- [ ] Support phone-triggered measurement if the protocol allows it?
