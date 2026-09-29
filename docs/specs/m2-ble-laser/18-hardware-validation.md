# [M2] Issue 18: Validate BLE Laser Integration on a Physical GLM 50-27 C

Status: Draft (blocked until a device is available)
Issue: #18
Epic: #2
Depends on: #8 (path chosen), #9 (adapter)
Owner: TBD

## Goal

Confirm on real hardware that the #9 adapter reads the GLM 50-27 C correctly
and fix anything the research could not predict.

## Scope

- Confirm Service UUID discovery (device does not advertise its name) and
  identifier decoding.
- Pairing/bonding behavior, reconnect after device sleep, two devices nearby.
- Unit reporting (device set to m/ft/in) and conversion to mm.
- Latency from device button to value in the focused field.
- Record raw frames as fixtures for #9 unit tests.
- Test matrix: at least one Android ≥ 12 and one Android ≤ 11 (location
  permission path); iOS when a device and distribution channel exist.

## Acceptance Criteria

- [ ] 10 consecutive readings match the device display (mm) on Android.
- [ ] Value reaches the focused field ≤ 1 s after pressing the device button.
- [ ] Reconnects after device sleep without restarting the app.
- [ ] Raw frames committed as test fixtures.
- [ ] `docs/spikes/08-laser-integration.md` updated with confirmed facts.
- [ ] iOS result documented (or explicitly deferred).

## Open Questions

- [ ] Device procurement date.
