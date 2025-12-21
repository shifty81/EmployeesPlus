#!/bin/bash
# run_tests.sh - Test runner script for EmployeesPlus mod

echo "=========================================="
echo "EmployeesPlus Mod Test Runner"
echo "=========================================="
echo ""

# Check if Lua is installed
if ! command -v lua &> /dev/null; then
    echo "❌ Error: Lua is not installed"
    echo "Please install Lua 5.3 or later:"
    echo "  - Ubuntu/Debian: sudo apt-get install lua5.3"
    echo "  - macOS: brew install lua"
    echo "  - Windows: Download from https://www.lua.org/download.html"
    exit 1
fi

echo "✓ Lua version: $(lua -v)"
echo ""

# Set up Lua path to find modules
export LUA_PATH="./src/?.lua;./src/?/init.lua;./?.lua;;$LUA_PATH"

# Function to run a test file
run_test() {
    local test_file=$1
    local test_name=$2
    
    echo "----------------------------------------"
    echo "Running: $test_name"
    echo "----------------------------------------"
    
    if [ -f "$test_file" ]; then
        lua "$test_file"
        local result=$?
        
        if [ $result -eq 0 ]; then
            echo ""
            echo "✓ $test_name PASSED"
            return 0
        else
            echo ""
            echo "❌ $test_name FAILED (exit code: $result)"
            return 1
        fi
    else
        echo "❌ Test file not found: $test_file"
        return 1
    fi
}

# Track test results
total_tests=0
passed_tests=0
failed_tests=0

# Run automated test suite
echo "Running Test Suite..."
echo ""
total_tests=$((total_tests + 1))
if run_test "tests/test_mod.lua" "Automated Test Suite"; then
    passed_tests=$((passed_tests + 1))
else
    failed_tests=$((failed_tests + 1))
fi

echo ""
echo ""

# Run basic example
echo "Running Examples..."
echo ""
total_tests=$((total_tests + 1))
if run_test "examples/example_basic.lua" "Basic Example"; then
    passed_tests=$((passed_tests + 1))
else
    failed_tests=$((failed_tests + 1))
fi

echo ""
echo ""

# Run drive-thru example
total_tests=$((total_tests + 1))
if run_test "examples/example_drive_thru.lua" "Drive-Thru Example"; then
    passed_tests=$((passed_tests + 1))
else
    failed_tests=$((failed_tests + 1))
fi

# Print summary
echo ""
echo "=========================================="
echo "TEST SUMMARY"
echo "=========================================="
echo "Total Tests:  $total_tests"
echo "Passed:       $passed_tests"
echo "Failed:       $failed_tests"
echo "=========================================="

# Exit with appropriate code
if [ $failed_tests -eq 0 ]; then
    echo ""
    echo "✓ All tests passed successfully!"
    echo ""
    exit 0
else
    echo ""
    echo "❌ Some tests failed. Please check the output above."
    echo ""
    exit 1
fi
