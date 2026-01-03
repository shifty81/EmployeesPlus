@echo off
REM run_tests.bat - Test runner script for EmployeesPlus mod (Windows)

echo ==========================================
echo EmployeesPlus Mod Test Runner
echo ==========================================
echo.

REM Check if Lua is installed
where lua >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo X Error: Lua is not installed
    echo Please install Lua 5.3 or later from https://www.lua.org/download.html
    echo Or use LuaForWindows: https://github.com/rjpcomputing/luaforwindows
    exit /b 1
)

lua -v
echo.

REM Set up Lua path to find modules
set LUA_PATH=./src/?.lua;./src/?/init.lua;./?.lua;;%LUA_PATH%

REM Track test results
set total_tests=0
set passed_tests=0
set failed_tests=0

REM Run automated test suite
echo Running Test Suite...
echo.
echo ------------------------------------------
echo Running: Automated Test Suite
echo ------------------------------------------
set /a total_tests+=1

if exist "tests\test_mod.lua" (
    lua "tests\test_mod.lua"
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo [32m✓ Automated Test Suite PASSED[0m
        set /a passed_tests+=1
    ) else (
        echo.
        echo [31mX Automated Test Suite FAILED[0m
        set /a failed_tests+=1
    )
) else (
    echo X Test file not found: tests\test_mod.lua
    set /a failed_tests+=1
)

echo.
echo.

REM Run tray system tests
echo ------------------------------------------
echo Running: Tray System Test Suite
echo ------------------------------------------
set /a total_tests+=1

if exist "tests\test_tray_system.lua" (
    lua "tests\test_tray_system.lua"
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo [32m✓ Tray System Test Suite PASSED[0m
        set /a passed_tests+=1
    ) else (
        echo.
        echo [31mX Tray System Test Suite FAILED[0m
        set /a failed_tests+=1
    )
) else (
    echo X Test file not found: tests\test_tray_system.lua
    set /a failed_tests+=1
)

echo.
echo.

REM Run basic example
echo Running Examples...
echo.
echo ------------------------------------------
echo Running: Basic Example
echo ------------------------------------------
set /a total_tests+=1

if exist "examples\example_basic.lua" (
    lua "examples\example_basic.lua"
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo [32m✓ Basic Example PASSED[0m
        set /a passed_tests+=1
    ) else (
        echo.
        echo [31mX Basic Example FAILED[0m
        set /a failed_tests+=1
    )
) else (
    echo X Test file not found: examples\example_basic.lua
    set /a failed_tests+=1
)

echo.
echo.

REM Run drive-thru example
echo ------------------------------------------
echo Running: Drive-Thru Example
echo ------------------------------------------
set /a total_tests+=1

if exist "examples\example_drive_thru.lua" (
    lua "examples\example_drive_thru.lua"
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo [32m✓ Drive-Thru Example PASSED[0m
        set /a passed_tests+=1
    ) else (
        echo.
        echo [31mX Drive-Thru Example FAILED[0m
        set /a failed_tests+=1
    )
) else (
    echo X Test file not found: examples\example_drive_thru.lua
    set /a failed_tests+=1
)

echo.
echo.

REM Run tray system example
echo ------------------------------------------
echo Running: Tray System Example
echo ------------------------------------------
set /a total_tests+=1

if exist "examples\example_tray_system.lua" (
    lua "examples\example_tray_system.lua"
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo [32m✓ Tray System Example PASSED[0m
        set /a passed_tests+=1
    ) else (
        echo.
        echo [31mX Tray System Example FAILED[0m
        set /a failed_tests+=1
    )
) else (
    echo X Test file not found: examples\example_tray_system.lua
    set /a failed_tests+=1
)

REM Print summary
echo.
echo ==========================================
echo TEST SUMMARY
echo ==========================================
echo Total Tests:  %total_tests%
echo Passed:       %passed_tests%
echo Failed:       %failed_tests%
echo ==========================================

REM Exit with appropriate code
if %failed_tests% EQU 0 (
    echo.
    echo [32m✓ All tests passed successfully![0m
    echo.
    exit /b 0
) else (
    echo.
    echo [31mX Some tests failed. Please check the output above.[0m
    echo.
    exit /b 1
)
