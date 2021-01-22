#!/bin/sh
# To create a debug build, run `cmake -D CMAKE_BUILD_TYPE=Debug .` instead
echo "Building C-Dogs..."
cmake -DCMAKE_TOOLCHAIN_FILE="../../toolchain/steamlink-toolchain.cmake" -DCMAKE_PREFIX_PATH="../../rootfs/usr/lib/cmake/SDL2" -DNANOPB_GENERATOR_SOURCE_DIR="./src/proto/nanopb/extra" -DBUILD_EDITOR=OFF -DCDOGS_DATA_DIR="./" .
make

# Prepare package directory
rm "./output/cdogs-steamlink/cdogs-sdl"
cp "./src/cdogs-sdl" "./output/cdogs-steamlink/cdogs-sdl"
cp "./output/cdogs-steamlink/cdogs-sdl" "./output/cdogs-sdl"

echo "Packaging it for Steam-Link...."
export DESTDIR="${PWD}/output/cdogs-steamlink"
cd output

# Build TAR.GZ
name=$(basename ${DESTDIR})
tar zcvf $name.tgz $name || exit 3
echo "Build Complete! Check in /output/ directory."
