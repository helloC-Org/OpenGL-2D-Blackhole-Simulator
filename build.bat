@echo off
REM Build and run script for Windows
REM
REM This script compiles your C++ project using CMake and runs the resulting executable.
REM Usage: build.bat [program arguments...]

setlocal enabledelayedexpansion

REM Navigate to the script's directory (project root when downloaded)
cd /d "%~dp0"

echo === OpenGL Project Build Script ===
echo.

REM Check for CMake
where cmake >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] CMake is not installed
    echo.
    echo Download and install CMake from: https://cmake.org/download/
    echo.
    exit /b 1
)

REM Check for Visual Studio or C++ compiler
where cl >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    where g++ >nul 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] No C++ compiler found
        echo.
        echo Install Visual Studio or Visual Studio Build Tools:
        echo https://visualstudio.microsoft.com/downloads/
        echo.
        exit /b 1
    )
)

for /f "tokens=*" %%i in ('cmake --version') do (
    echo [OK] CMake found: %%i
    goto :cmake_done
)
:cmake_done
echo [OK] C++ compiler found
echo.

REM Create build directory if it doesn't exist
if not exist build mkdir build
cd build

REM Configure with CMake
echo Configuring with CMake...
echo.

REM Try to use vcpkg if VCPKG_ROOT is set
set CMAKE_ARGS=
if defined VCPKG_ROOT (
    if exist "%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake" (
        echo [OK] Using vcpkg from: %VCPKG_ROOT%
        set CMAKE_ARGS=-DCMAKE_TOOLCHAIN_FILE=%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake
    )
) else (
    echo [NOTE] VCPKG_ROOT not set, using system libraries
    echo        To use vcpkg, set: set VCPKG_ROOT=C:\path\to\vcpkg
)

REM Run CMake configuration
cmake .. %CMAKE_ARGS%
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] CMake configuration failed
    echo.
    echo Common fixes:
    echo   1. Install dependencies with vcpkg:
    echo      vcpkg install glew glfw3 glm
    echo      set VCPKG_ROOT=C:\path\to\vcpkg
    echo.
    echo   2. Or download and install dependencies manually
    echo.
    exit /b 1
)

echo.
echo Compiling...
REM Build the project (Release configuration)
cmake --build . --config Release
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Build failed
    exit /b 1
)

echo.
echo === Build Complete! ===
echo.

REM Find the executable in Release directory
set EXECUTABLE=
for %%F in (Release\*.exe) do (
    set EXECUTABLE=%%F
    goto :found
)

REM If not found in Release, try Debug
for %%F in (Debug\*.exe) do (
    set EXECUTABLE=%%F
    goto :found
)

REM If still not found, try build root
for %%F in (*.exe) do (
    set EXECUTABLE=%%F
    goto :found
)

:found
if "%EXECUTABLE%"=="" (
    echo [ERROR] No executable found in build directory
    exit /b 1
)

echo Running: %EXECUTABLE%
echo ---
echo.

REM Run the program with any arguments passed to this script
%EXECUTABLE% %*
