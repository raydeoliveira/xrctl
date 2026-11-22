# Polar.sh Product Listing — xrctl Pro (macOS & Linux/SteamOS)

> Enable Polar's built-in **License Keys** benefit (prefix: `XRCTL`, activation limit: `3` machines per buyer, expiration: never / perpetual).

---

## Product Title
**xrctl Pro — Unified 4-Vendor AR Glasses CLI & 1000Hz IMU Controller (macOS / Linux)**

## Price & Billing Model
- **$19 USD** — One-time purchase (Perpetual License, v0.x updates included, up to 3 personal machines).
- **Free Core Tier** included in the same binary (`probe`, `profiles`, `status`, `wear`, `restore`, `--dry-run`, and read-only MCP tools).

## Summary
Control XREAL (Air, Air 2 Pro, One), VITURE (One, Pro, Luma), Rokid (Air, Max), and RayNeo (Air 2/3S) AR glasses from one zero-dependency C17 CLI and stdio MCP server: 2D/3D SBS switching with 15-second auto-revert, electrochromic lens tint, 60/90/120Hz refresh rate, wear sensor state, and 1000Hz 6DoF/9DoF quaternion IMU telemetry.

## Free Core vs. Pro Comparison

| Feature | Free Core | Pro ($19 one-time) |
|---|---|---|
| `probe` & `status` (USB-HID + XREAL One TCP `169.254.2.1:52999`) | Included | Included |
| `profiles` (4-vendor capability & protocol DB) | Included | Included |
| `wear` (IR proximity / IMU wear sensor) | Included | Included |
| `mode --dry-run` & `restore` (rollback to `2d`) | Included | Included |
| `mcp` read-only & `dry_run: true` tools | Included | Included |
| `mode` live 2D/3D SBS write + 15s `sigaction` rollback | — | Included |
| `tint` electrochromic lens control (`clear`/`mid`/`dark`/`opaque` / `0..100`) | — | Included |
| `refresh` (`60`/`90`/`120` Hz) & `brightness` (`0..100`) writes | — | Included |
| `imu` 1000Hz O(1) ring buffer & quaternion JSONL stream | — | Included |
| `mcp` live write tools (`dry_run: false`) | — | Included |

## Requirements & Honest Limits
- **OS & Architecture**: macOS arm64 (IOKit HID + POSIX TCP) and Linux/SteamOS (`hidraw` + POSIX TCP).
- **Permissions**: macOS HID access requires Input Monitoring permission if denied by TCC (`exit 4`); Linux `hidraw` requires `udev` user access (`MODE="0660", TAG+="uaccess"`). No kernel extensions or proprietary vendor SDKs required.
- **Hardware Verification Note**: Because no physical AR glasses are attached to the build host and firmware revisions vary across models, wire codecs, state machines, 15s `sigaction` rollback, loopback TCP framing, and 4-vendor fixtures are verified in hardware-free ASan/UBSan test suites on Apple Silicon macOS; live USB-HID (`IOKit`/`hidraw`) and physical device exchanges await validation with attached hardware. Always preview with `--dry-run` first; 14-day refund policy applies if a specific firmware revision behaves unexpectedly.
