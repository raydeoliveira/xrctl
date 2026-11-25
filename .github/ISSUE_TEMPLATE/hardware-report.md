---
name: Hardware Compatibility Report
about: Share test results for xrctl on your physical hardware
title: "[HW] <device model> on <OS>"
labels: hardware-report
---

## Hardware Setup
- **OS & Architecture**: (e.g., macOS 15.x arm64, Ubuntu 24.04 x86_64)
- **Hardware Model / Interface**: (AR glasses make/model & firmware (XREAL / VITURE / Rokid / RayNeo, VID:PID) + host OS/arch)
- **`xrctl --version` output**:

## `probe` Output
```json
// paste output of `xrctl probe --json` (redact any serial numbers you do not wish to share)
```

## What Worked / Quirks
- What commands succeeded cleanly?
- Did `--dry-run` or timed auto-revert / restore behave as expected?
- Any timeouts, firmware quirks, or unexpected VID/PIDs?
