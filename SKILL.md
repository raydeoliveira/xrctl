---
name: xrctl
description: >-
  Provides device profiles for XREAL, VITURE, Rokid and RayNeo AR glasses
  over USB-HID and XREAL One link-local TCP. Model-specific features include 2D/3D SBS
  mode switching with 15-second auto-revert, electrochromic lens tint, 60/90/120Hz
  refresh control, 1000Hz 6DoF/9DoF IMU quaternion streaming, wear sensor queries,
  --from-json - UNIX pipes, and built-in stdio MCP tools.
---

# Skill: xrctl (`xrctl`)

## Install

The v0.1.0 CLI and MCP bundle run on Apple Silicon with macOS 14 or later. Linux and SteamOS support is source-only. Device profiles and fixtures can be inspected without an attached pair of glasses.

```bash
brew install raydeoliveira/tap/xrctl
# Inspect capability manifest:
xrctl --describe
```

## Safe 2D/3D Display Workflow
1. Probe attached hardware or inspect deterministic profiles (read-only, Free):
   ```bash
   xrctl probe --json
   xrctl profiles --json
   ```
2. Preview a mode switch before writing hardware registers (`--dry-run` works non-interactively):
   ```bash
   xrctl mode 3d-sbs --fixture xreal-air --dry-run --json
   ```
3. Apply 3D mode with snapshot and 15-second auto-revert watchdog (non-TTY requires `--yes`):
   ```bash
   xrctl mode 3d-sbs --confirm-timeout 15 --json
   ```
4. Restore 2D mode immediately at any time (always Free):
   ```bash
   xrctl restore --json
   ```

## Tint, Refresh & 1000Hz IMU
- Electrochromic tint (`0..3`, `4..100`, `0%..100%`, or `clear|mid|dark|opaque`; exits `3` if hardware lacks electrochromic lenses):
  ```bash
  xrctl tint dark --fixture viture-pro --json
  ```
- Refresh rate (`60|90|120` Hz) and panel brightness (`0..100`):
  ```bash
  xrctl refresh 120 --fixture xreal-one-tcp --json
  xrctl brightness 80 --fixture xreal-air --json
  ```
- 1000Hz IMU JSONL stream & wear sensor:
  ```bash
  xrctl imu --fixture xreal-air --count 5 --stream
  xrctl wear --fixture rokid-max --json
  ```

## UNIX Composability (`--from-json -`)
Pipe `edidsmith` `solved_mode` JSON directly into `xrctl` (`ok:false` or `fits:false` fails closed with exit `2`; explicit CLI flags override piped JSON):
```bash
edidsmith edid patch --fixture xreal-ar-glasses --preset full-sbs-1080p-120 --dry-run --json \
  | xrctl mode 3d-sbs --fixture xreal-air --from-json - --confirm-timeout 15 --dry-run --json
```

## Native MCP Mode
Run `xrctl mcp` for stdio JSON-RPC 2.0 (`protocolVersion: "2024-11-05"`):
`list_xr_profiles`, `probe_xr_glasses`, `get_xr_status`, `read_wear_sensor`, `set_xr_mode` (defaults `dry_run: true`), `set_xr_tint` (defaults `dry_run: true`), `set_xr_refresh` (defaults `dry_run: true`), `set_xr_brightness` (defaults `dry_run: true`), `restore_xr_2d` (defaults `dry_run: true`), and `sample_xr_imu`.

## Exit Codes
- `0` ok | `1` runtime/rollback timeout | `2` usage/validation/bandwidth/non-TTY | `3` hardware or capability unavailable | `4` permission or symlink denied | `5` Pro license required (`xrctl license activate --key <KEY>`) | `130` interrupted (`SIGINT`/`SIGTERM`) after 2D rollback
