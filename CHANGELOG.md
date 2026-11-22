# Changelog — xrctl

## 0.1.0 (Milestone M2)
- Implemented 4-vendor USB-HID discovery (`IOKit/hid` + `IOHIDCheckAccess` on macOS, `hidraw` on Linux) and XREAL One link-local TCP (`169.254.2.1:52999`/`52998`, `XRCTL_TCP_ENDPOINT`).
- Implemented clean-room wire codecs (XREAL `0xFD` CRC32 & BE TCP framing, VITURE `0xFF 0xFE` CRC16-CCITT, Rokid `0x11`, RayNeo `99 65 40 00`) with checked-in binary trace fixtures and loopback TCP mock tests.
- Implemented `mode` 2D/3D SBS switching with non-TTY `--yes` guard, `lstat` symlink-guarded atomic snapshots, readback verify, `sigaction(sa_flags=0)` 15s auto-revert to `2d`, `restore`, `tint`, `refresh`, `brightness`, `wear`, and 1000Hz `imu` Mahony quaternion fusion in a 1024-slot O(1) ring buffer.
- Added strict RFC 8259 JSON parser, dynamic `--describe` manifest, `--from-json -` composability, `profiles`, stdio JSON-RPC 2.0 `mcp` server, Polar.sh licensing (`-DOSS_EDITION` offline seam), and Trinity packaging (`SKILL.md`, `server.json`, Homebrew, Polar listing, `package_release.sh`).
