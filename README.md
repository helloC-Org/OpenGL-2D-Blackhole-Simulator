# OpenGL 2D Black Hole Simulator

This project creates a 2D black hole gravitational lensing simulation using OpenGL and the Schwarzschild metric. You'll visualize how light rays bend around a massive black hole using numerical integration.

## Quick Start (Recommended)

**Use the automated build scripts included with your download:**

### Linux/macOS
```bash
chmod +x run.sh
./run.sh
```

### Windows
```cmd
build.bat
```

**The scripts will:**
- ✓ Check for CMake and C++ compiler
- ✓ Automatically use vcpkg if `VCPKG_ROOT` is set
- ✓ Fall back to system libraries otherwise
- ✓ Build and run your project
- ✓ Provide helpful error messages if dependencies are missing

**If the script fails**, follow the manual installation instructions below to install dependencies, then run the script again.

---

## Building Requirements

- C++ Compiler supporting C++17 or newer
- [CMake](https://cmake.org/)
- [Vcpkg](https://vcpkg.io/en/) (recommended) or system package manager
- [Git](https://git-scm.com/)

## Dependencies

- **GLEW** (OpenGL Extension Wrangler Library)
- **GLFW** (Window and input management)
- **GLM** (OpenGL Mathematics library)

# Manual Build Instructions

If you prefer manual control or the automated scripts fail, follow these detailed instructions.

### 1. Install Dependencies with Vcpkg (Recommended)

If you already have vcpkg installed:
```bash
vcpkg install glew glfw3 glm
export VCPKG_ROOT=/path/to/vcpkg  # Set this environment variable
./run.sh                           # Then use the automated script
```

If you don't have vcpkg yet:
```bash
# Clone vcpkg
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg

# Bootstrap (Windows)
.\bootstrap-vcpkg.bat

# Bootstrap (macOS/Linux)
./bootstrap-vcpkg.sh

# Install dependencies
./vcpkg install glew glfw3 glm

# Set environment variable for automated script
export VCPKG_ROOT=$(pwd)           # Linux/macOS
set VCPKG_ROOT=%CD%                 # Windows

# Return to your project and run the script
cd /path/to/your/project
./run.sh                            # Linux/macOS
build.bat                           # Windows
```

**The automated scripts will automatically detect and use vcpkg if `VCPKG_ROOT` is set!**

If you cannot get vcpkg working, jump to the platform-specific alternatives below.

## Alternative: Debian/Ubuntu (apt)

Install system packages and use the automated script:

```bash
sudo apt update
sudo apt install build-essential cmake \
    libglew-dev libglfw3-dev libglm-dev libgl1-mesa-dev

# Run the automated script (no VCPKG_ROOT needed)
./run.sh
```

Or build manually:
```bash
cmake -B build -S .
cmake --build build
./build/[executable-name]
```

## Alternative: macOS (Homebrew)

Install dependencies via [Homebrew](https://brew.sh/) and use the automated script:

```bash
# Install dependencies
brew install cmake glew glfw glm

# Run the automated script
./run.sh
```

Or build manually:
```bash
cmake -B build -S .
cmake --build build
./build/[executable-name]
```

## Alternative: Windows Manual Build

If the `build.bat` script doesn't work, you can build manually:

```cmd
REM From your project directory
mkdir build
cd build
cmake ..
cmake --build . --config Release
Release\[executable-name].exe
```

## What You'll Build

This 2D simulator demonstrates:
- Light ray bending around a black hole
- Schwarzschild metric implementation
- Runge-Kutta 4th order (RK4) numerical integration
- Real-time visualization of gravitational lensing

## Learning Resources

- [Learn OpenGL](https://learnopengl.com/) - Comprehensive OpenGL tutorial
- [GLFW Documentation](https://www.glfw.org/documentation.html)
- [Schwarzschild Metric](https://en.wikipedia.org/wiki/Schwarzschild_metric) - Physics background
- [Gravitational Lensing](https://en.wikipedia.org/wiki/Gravitational_lens) - Physics background

## Support

If you encounter compilation errors:

1. **Verify all dependencies are installed** using the commands in your platform's section
2. **Check CMake output** for specific missing libraries
3. **Update graphics drivers** to the latest version
4. **Ensure C++17 support** - use GCC 7+, Clang 5+, or MSVC 2017+

### Report Issues

Found a bug or have suggestions? Please report issues on GitHub:

**https://github.com/helloC-Org/OpenGL-2D-Blackhole-Simulator/issues**

When reporting issues, please include:
- Your operating system and version
- CMake version (`cmake --version`)
- Compiler version (`c++ --version` or `g++ --version`)
- Full error message or unexpected behavior
- Steps to reproduce the issue

Happy coding!
