#!/bin/sh
#
# Build and run script for Linux/macOS
#
# This script compiles your C++ project using CMake and runs the resulting executable.
# Usage: ./run.sh [program arguments...]

set -e # Exit early if any commands fail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Navigate to the script's directory (project root when downloaded)
cd "$(dirname "$0")"

echo "=== OpenGL Project Build Script ==="
echo ""

# Check for CMake
if ! command -v cmake >/dev/null 2>&1; then
    echo "${RED}Error: CMake is not installed${NC}"
    echo ""
    echo "Install CMake:"
    echo "  macOS:  brew install cmake"
    echo "  Ubuntu: sudo apt install cmake"
    echo ""
    exit 1
fi

# Check for C++ compiler
if ! command -v c++ >/dev/null 2>&1 && ! command -v g++ >/dev/null 2>&1 && ! command -v clang++ >/dev/null 2>&1; then
    echo "${RED}Error: No C++ compiler found${NC}"
    echo ""
    echo "Install compiler:"
    echo "  macOS:  xcode-select --install"
    echo "  Ubuntu: sudo apt install build-essential"
    echo ""
    exit 1
fi

echo "${GREEN}✓${NC} CMake found: $(cmake --version | head -n 1)"
echo "${GREEN}✓${NC} C++ compiler found"
echo ""

# Create build directory if it doesn't exist
mkdir -p build
cd build

# Configure with CMake
echo "Configuring with CMake..."
echo ""

# Try to use vcpkg if VCPKG_ROOT is set
if [ -n "$VCPKG_ROOT" ] && [ -f "$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" ]; then
    echo "${GREEN}✓${NC} Using vcpkg from: $VCPKG_ROOT"
    CMAKE_ARGS="-DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"
else
    echo "${YELLOW}Note:${NC} VCPKG_ROOT not set, using system libraries"
    echo "      To use vcpkg, set: export VCPKG_ROOT=/path/to/vcpkg"
    CMAKE_ARGS=""
fi

# Run CMake configuration
if ! cmake .. $CMAKE_ARGS; then
    echo ""
    echo "${RED}Error: CMake configuration failed${NC}"
    echo ""
    echo "Common fixes:"
    echo "  1. Install dependencies with vcpkg:"
    echo "     vcpkg install glew glfw3 glm"
    echo "     export VCPKG_ROOT=/path/to/vcpkg"
    echo ""
    echo "  2. Or install system dependencies:"
    echo "     macOS:  brew install glew glfw glm"
    echo "     Ubuntu: sudo apt install libglew-dev libglfw3-dev libglm-dev"
    echo ""
    exit 1
fi

echo ""
echo "Compiling..."
# Build the project
if ! cmake --build .; then
    echo ""
    echo "${RED}Error: Build failed${NC}"
    exit 1
fi

echo ""
echo "${GREEN}=== Build Complete! ===${NC}"
echo ""

# Find the executable (first file in build directory that's executable)
# Use -perm for macOS compatibility
EXECUTABLE=$(find . -maxdepth 1 -type f -perm +111 -not -name "*.sh" 2>/dev/null | head -n 1)

# Fallback: if find with -perm fails, try without it and check manually
if [ -z "$EXECUTABLE" ]; then
    for file in ./*; do
        if [ -f "$file" ] && [ -x "$file" ] && [ "$(basename "$file")" != "*.sh" ]; then
            EXECUTABLE="$file"
            break
        fi
    done
fi

if [ -z "$EXECUTABLE" ]; then
    echo "${RED}Error: No executable found in build directory${NC}"
    exit 1
fi

echo "Running: $(basename $EXECUTABLE)"
echo "---"
echo ""

# Run the program with any arguments passed to this script
exec "$EXECUTABLE" "$@"
