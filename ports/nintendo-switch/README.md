# Nintendo Switch support

This port builds usrsctp as a static library for Nintendo Switch
homebrew using devkitPro, devkitA64, and libnx.

## Requirements

- devkitPro with devkitA64 and libnx
- CMake
- GNU Make
- Bash

The build script defaults to `/opt/devkitpro`. Set `DEVKITPRO`
if your installation uses another location.

## Building

From the repository root, run:

    ./ports/nintendo-switch/build.sh

To specify an external build directory:

    ./ports/nintendo-switch/build.sh /path/to/build-directory

The script installs the library and headers beneath the selected
build directory:

    install/lib/libusrsctp.a
    install/include/usrsctp.h

## Build configuration

- Nintendo Switch AArch64 target
- Static library only
- Position-independent compilation (`-fPIE`)
- IPv4 enabled
- IPv6 disabled
- Programs and tests disabled
- Mbed TLS SHA-1 integration disabled

## Validation

An isolated devkitA64 static-library build succeeded.

A Switch AArch64 static-PIE consumer executable successfully linked
against the public `usrsctp_init` and `usrsctp_finish` functions.

These results establish compilation and linking compatibility,
not successful networking operation.

## Known limitations

- Actual SCTP networking on Switch hardware remains untested.
- IPv6 is not supported by the validated configuration.
- Interface enumeration through `getifaddrs()` is disabled.
- Interface MTU lookup is unavailable.
- Existing usrsctp route and default MTU handling remains in use.
- Runtime path-MTU discovery remains unverified.
- SCTP association establishment, packet delivery, and connection
  stability have not been verified on Switch hardware.

This port is not yet validated for production networking use.
