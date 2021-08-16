#!/bin/bash

set -ex

# Remove -D_LIBCPP_DISABLE_AVAILABILITY once libcxx=12 is released
export CXXFLAGS="${CXXFLAGS} -D__STDC_FORMAT_MACROS -D_LIBCPP_DISABLE_AVAILABILITY"

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == 1 ]]; then
    WRT=no
else
    WRT=yes
fi

cmake ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS_RELEASE="-Wall -Wextra -O3 -funroll-loops -DNDEBUG" \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DWITH_LLVM=yes \
    -DWITH_XEUS=yes \
    -DWITH_RUNTIME_LIBRARY=$WRT \
    $SRC_DIR

make -j${CPU_COUNT}
make install
