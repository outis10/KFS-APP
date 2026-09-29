# [M2] Spike 8: Laser Integration Research, Device Interface and Simulator (No Device)

Status: Draft
Issue: #8
Epic: #2
Follow-up with hardware: #18
Owner: TBD
Timebox: 4 working days (proposal)

## Context

The physical Bosch GLM 50-27 C is **not available yet**. Research indicates
BLE integration is feasible and that community projects expose libraries for
Bosch measuring tools, besides Bosch's official developer resources. The app
must support **manual** and **automatic (laser)** modes, so the laser must not
block the rest of the work.

## Questions to answer

1. Which integration path: official Bosch SDK (native, wrapped via platform
   channels/Pigeon) vs a community library vs direct BLE with
   `flutter_blue_plus` following the documented protocol?
2. Does each option cover the **GLM 50-27 C** specifically, on Android and iOS?
3. License and maintenance of each option (can we ship it in a distributed app?).
4. What does a measurement look like (units, precision, events), so the
   interface and simulator are realistic?

## Scope

- Desk research: official Bosch developer resources, community libraries
  (license, last activity, platforms, device coverage), BLE permission needs.
- Define the domain interface (no BLE code yet):

```text
LaserDevice
  Stream<LaserConnectionState> state
  Stream<LaserMeasurement> measurements   // mm, rawValue, rawUnit, deviceId, timestamp
  Future<void> connect(...) / disconnect()
LaserDiscovery
  Stream<DiscoveredLaser> scan()           // id, alias, rssi
```

- **Simulated laser** (`SimulatedLaserDevice`): dev-only screen/button or
  timer emitting readings, simulated disconnects and unit errors; selectable in
  dev/staging flavors. Used by #12 and tests so "automatic mode" can be built
  without hardware.
- Capture mode setting: **Manual** / **Automático (láser)**, persisted per device.

## Deliverables

- `docs/spikes/08-laser-integration.md`: options compared (coverage, license,
  platforms, maintenance, risk), recommendation, BLE permissions matrix,
  unknowns to confirm on hardware (#18).
- Interface + simulator merged behind the `laser` feature (no real BLE yet).

## Acceptance Criteria

- [ ] Written comparison with license notes and a recommended path.
- [ ] `LaserDevice` interface and `SimulatedLaserDevice` merged with unit tests.
- [ ] Capture UI can be driven end-to-end by the simulator in dev flavor.
- [ ] List of facts that must be confirmed with the physical device (#18).

## Open Questions

- [ ] Does the official SDK require an NDA or approval? Lead time?
- [ ] When will a physical device be available (buy/borrow)?
