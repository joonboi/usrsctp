#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
: "${DEVKITPRO:=/opt/devkitpro}"
build="${1:-$repo/build-nintendo-switch}"
install="$build/install"

cc="$DEVKITPRO/devkitA64/bin/aarch64-none-elf-gcc"
ar="$DEVKITPRO/devkitA64/bin/aarch64-none-elf-ar"
ranlib="$DEVKITPRO/devkitA64/bin/aarch64-none-elf-ranlib"

test -x "$cc"
test -x "$ar"
test -x "$ranlib"
test -f "$DEVKITPRO/libnx/include/switch.h"

cmake -S "$repo" -B "$build" -G "Unix Makefiles" \
  -DCMAKE_SYSTEM_NAME=Generic \
  -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
  -DCMAKE_C_COMPILER="$cc" \
  -DCMAKE_AR="$ar" \
  -DCMAKE_RANLIB="$ranlib" \
  -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
  -DCMAKE_INSTALL_PREFIX="$install" \
  -DCMAKE_C_FLAGS="-D__SWITCH__ -D_DEFAULT_SOURCE=1 -I$DEVKITPRO/libnx/include -march=armv8-a -mtune=cortex-a57 -mtp=soft -fPIE" \
  -DCMAKE_BUILD_TYPE=Release \
  -Dsctp_build_shared_lib=OFF \
  -Dsctp_build_programs=OFF \
  -Dsctp_werror=OFF \
  -Dsctp_debug=OFF \
  -Dsctp_inet=ON \
  -Dsctp_inet6=OFF \
  -DSCTP_USE_MBEDTLS_SHA1=OFF

cmake --build "$build" --parallel "$(nproc)"
cmake --install "$build"

test -s "$install/lib/libusrsctp.a"
test -f "$install/include/usrsctp.h"

echo "=== USRSCTP SWITCH BUILD COMPLETE ==="
echo "Library: $install/lib/libusrsctp.a"
echo "Headers: $install/include"
