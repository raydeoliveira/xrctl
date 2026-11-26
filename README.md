# xrctl

> **Product Hub:** [raymonddeoliveira.com/software](https://www.raymonddeoliveira.com/software#xrctl) · **Buy xrctl Pro ($19):** [Polar Checkout](https://buy.polar.sh/polar_cl_xBuVDUMFZ51noqtr3hX44WD57cnL7LkElA3lL2Hy2Dc) · **Complete 4-CLI Bundle ($49, save $57):** [Bundle Checkout](https://buy.polar.sh/polar_cl_KTtCY3iQC4bzjqp93aC6LCog8UZqzZzuDgkAs3BvF74) · **Verified MCP:** [Glama](https://glama.ai/mcp/servers/raydeoliveira/xrctl) · **Free Core:** `brew tap raydeoliveira/tap && brew install xrctl`

Clean-room C17 CLI and stdio MCP server for XREAL, VITURE, Rokid, and RayNeo AR glasses on macOS and Linux/SteamOS over USB-HID and XREAL One link-local TCP (`169.254.2.1:52999`).

`xrctl` compiles to a **145,360-byte (~142 KB)** stripped Mach-O `arm64` binary with **4.5 ms** average `--version` cold start and zero third-party runtime dependencies.

## What It Does / What It Does Not Do

| Capability | Supported | Notes / Limits |
|---|---|---|
| 4-vendor discovery (`probe`, `profiles`) | Yes | XREAL (`0x3318`), VITURE (`0x35ca`), Rokid (`0x04d2`), RayNeo (`0x1bbb`/`0x3941`) via IOKit HID (macOS), `hidraw` (Linux), and XREAL One TCP (`169.254.2.1:52999`). |
| 2D / 3D SBS switching (`mode`, `restore`) | Yes | Pre-change `lstat`-guarded atomic snapshot, `--dry-run`, non-TTY `--yes` fail-closed guard (`exit 2`), and 15-second `sigaction` (`sa_flags=0`) auto-revert to `2d`. |
| Electrochromic lens tint (`tint`) | Yes | Accepts `0..3`, `4..100`, `0%..100%`, or `clear\|mid\|dark\|opaque`; fails closed (`exit 3`) on models without electrochromic lenses. |
| Refresh rate & brightness (`refresh`, `brightness`) | Yes | `60\|90\|120` Hz (validated per model) and `0..100` panel brightness. |
| 1000Hz IMU & wear sensor (`imu`, `wear`) | Yes | Fixed 1024-slot O(1) circular ring buffer + Mahony 6DoF/9DoF quaternion fusion (`--count`, `--duration-ms`, `--stream` JSONL); IR/IMU wear status. |
| UNIX composability & MCP (`--from-json -`, `mcp`) | Yes | Consumes `display_identity`, `solved_mode`, and `target_surface` envelopes; built-in JSON-RPC 2.0 `mcp` server (`protocolVersion: "2024-11-05"`). |
| Kernel extensions / physical device lab testing | No | Zero kexts or vendor SDKs. On hosts without physical glasses attached, wire codecs, state transitions, loopback TCP/HTTP, and `SIGINT` rollback are verified against deterministic binary fixtures and loopback servers; live USB-HID (`IOKit`/`hidraw`) and physical XREAL TCP firmware exchanges have not been tested against attached hardware. |

## Install & Uninstall

The Homebrew package runs on Apple Silicon with macOS Sonoma (14) or later. List XREAL device profiles without connecting glasses.

```sh
brew install raydeoliveira/tap/xrctl
xrctl profiles --vendor xreal --json
```

The release page provides the macOS archive, MCP bundle and SHA-256 checksums. [Version 0.1.0 downloads](https://github.com/raydeoliveira/xrctl/releases/tag/v0.1.0)

### Uninstall

```sh
brew uninstall xrctl
```

## Quick Start (Human & `--json` Agent Usage)

With xrctl installed, add the [agent instructions](SKILL.md) to your project for AR glasses profiles and display mode previews.

```sh
npx skills add raydeoliveira/xrctl
```

Probe attached devices or run against deterministic hardware-free fixtures:
```bash
xrctl --version --json
# {"schema_version":1,"ok":true,"data":{"name":"xrctl","version":"0.1.0","edition":"commercial","arch":"arm64","platform":"macos-arm64"},"error":null}

xrctl probe --fixture xreal-air --json
# {"schema_version":1,"ok":true,"data":{"count":1,"first_vendor":"xreal","first_model":"XREAL Air 2 Pro","display_identity":{"vendor_id_hex":"3318","product_id_hex":"0424","manufacturer_code":"NRL","monitor_name":"XREAL Air 2 Pro","quirk_id":"xreal-air"},"devices":[{"vendor":"xreal","model":"XREAL Air 2 Pro","vendor_id_hex":"3318","product_id_hex":"0424","transport":"usb-hid","imu_hz":1000}]},"error":null}

xrctl profiles --vendor viture --json
# {"schema_version":1,"ok":true,"data":{"profiles":[{"vendor":"viture","vendor_id_hex":"0x35ca","known_pids":"0x1011 (One), 0x1015 (One Lite), 0x1019 (Pro)","transports":"usb-hid (0xFF 0xFE CRC16-CCITT)","modes":"2d, 3d-sbs, 3d-half-sbs","refresh_rates":"60, 90, 120","has_tint":true,"imu_hz":1000,"has_wear_sensor":true}]},"error":null}
```

Pipe upstream EDID patch / link-budget output into `xrctl` (`ok:false` or `fits:false` fails closed with exit `2`):
```bash
edidsmith edid patch --fixture xreal-ar-glasses --preset full-sbs-1080p-120 --dry-run --json \
  | xrctl mode 3d-sbs --fixture xreal-air --from-json - --confirm-timeout 15 --dry-run --json
```

## Safety & Rollback

1. **Non-TTY Guard**: Mutating `mode` commands without `--yes` (and without `--dry-run`) fail closed with exit `2` before writing snapshots or hardware registers.
2. **Symlink Guard**: Snapshot and license cache writes check `lstat()` (`S_ISLNK`) and refuse symlink targets with exit `4`.
3. **15-Second Auto-Revert**: `mode` snapshots prior state atomically, verifies readback, and runs a non-restarting `sigaction(sa_flags=0)` + `poll()` watchdog that reverts to `2d` on timeout (`exit 1`) or `SIGINT`/`SIGTERM` (`exit 130`).
4. **Permissions**: macOS Input Monitoring denial (`IOHIDCheckAccess`) and Linux `/dev/hidraw*` `EACCES`/`EPERM` exit `4` with OS remediation hints; absent hardware exits `3`.

## Exit Codes & CLI Reference

Run `xrctl --help` for human usage or `xrctl --describe` for the full JSON capability manifest:
- `0`: Success
- `1`: Runtime, wire-CRC, or confirmation-timeout rollback failure
- `2`: Invalid usage, non-TTY confirm required, unsupported refresh rate, or upstream `--from-json` failure
- `3`: Hardware or model capability unavailable (e.g., `tint` on non-electrochromic glasses)
- `4`: OS HID permission denied or symlink guard triggered
- `5`: Pro license required or invalid (`xrctl license activate --key <KEY>`)
- `130`: `SIGINT`/`SIGTERM` received and display mode reverted to `2d`

## License & Security

- Security policy: [SECURITY.md](SECURITY.md)
