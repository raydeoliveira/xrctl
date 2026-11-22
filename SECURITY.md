# Security Policy — xrctl

## Reporting a Vulnerability
Report security vulnerabilities privately via GitHub Security Advisories on `https://github.com/raydeoliveira/xrctl`.

## Security & Hardware Safety Model
- **C17 memory safety**: Compiled with `-Wall -Wextra -Werror -Wpedantic -Wshadow -Wconversion` and tested under AddressSanitizer and UndefinedBehaviorSanitizer (`make test`).
- **Bounded buffers**: All HID reports, link-local TCP frames (`169.254.2.1:52999`), and IMU ring buffers use fixed-capacity bounds and explicit length validation.
- **Rollback safety**: 2D/3D SBS mode transitions enforce pre-change snapshots and non-restarting `sigaction` timed auto-revert back to `2d`.
