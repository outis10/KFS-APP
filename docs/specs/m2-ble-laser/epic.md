---
epic: M2
title: Bosch GLM 50-27 C laser integration over BLE
status: Draft
issues: "#8 #9 #18"
studio_epic: "outis10/kalitron-furniture-studio#104"
---

# M2 — Bosch GLM 50-27 C over BLE

Status: Draft
Epic: #2

## Goal

The app has two capture modes: **Manual** and **Automático (láser)**. In
automatic mode, measurements from a Bosch GLM 50-27 C arrive in the focused
field in millimeters. Manual entry is always available.

## Constraint

No physical device is available yet. Work is split so nothing else waits:
research + interface + **simulated laser** (#8) → adapter (#9) → hardware
validation (#18) when a device arrives. The pilot can run in manual mode.

## Known facts (to be confirmed by the spike)

- The device uses Bluetooth LE and Bosch's MT protocol.
- It does **not** advertise its name; it is discovered by **Service UUID** and
  its identifier is decoded from the advertisement/device data.
- Bosch provides an SDK and sample apps through its developer community.

UUIDs, frame formats and pairing steps are **not** written here until the
spike (#8) documents them from the official SDK/docs.

## Issues

| Issue | Spec |
| --- | --- |
| #8 Spike (no device): research, interface, simulator | [08-spike-glm-50-27c.md](08-spike-glm-50-27c.md) |
| #9 BLE laser service (adapter) | [09-ble-laser-service.md](09-ble-laser-service.md) |
| #18 Hardware validation (requires device) | [18-hardware-validation.md](18-hardware-validation.md) |

## Epic acceptance criteria

- [ ] Integration path chosen and documented (#8).
- [ ] Automatic mode works end-to-end with the simulator.
- [ ] On real hardware (#18), values reach the focused field ≤ 1 s after pressing the device button.
- [ ] Loss of BLE never blocks manual capture.
