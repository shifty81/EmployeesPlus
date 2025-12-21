# Quick Testing Guide

## TL;DR - Test the Mod

### Run All Tests (Easiest)
```bash
# Linux/Mac
./run_tests.sh

# Windows
run_tests.bat
```

### Quick Manual Test
```bash
# Install Lua if needed
# Ubuntu/Debian: sudo apt-get install lua5.3
# macOS: brew install lua
# Windows: Download from https://www.lua.org

# Run the test suite
cd EmployeesPlus
lua tests/test_mod.lua

# Or run examples
lua examples/example_basic.lua
lua examples/example_drive_thru.lua
```

### Test In-Game (Fast Food Simulator)

1. **Install the mod**
   - Copy `EmployeesPlus` folder to your game's mods directory
   - Enable in `config.json`

2. **Launch the game and open console**

3. **Run quick test:**
   ```lua
   local EmployeesPlus = require("init")
   EmployeesPlus:init()
   
   -- Hire and test
   local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Test")
   cashier:startWork()
   cashier:assignWindow("TEST-1")
   
   -- Create order
   local order = EmployeesPlus:createOrder({{name = "Burger", price = 5.99}})
   print("Order created: #" .. order:getOrderNumber())
   
   -- Check status
   EmployeesPlus:printStatus()
   ```

4. **You should see:**
   - Mod initialization message
   - Employee hired message
   - Order created with number (e.g., #1000)
   - Receipt printed
   - Status showing 1 active order

## What Gets Tested

✓ **Employee Types**: Fry Cook, Cook, Drive Thru Cashier  
✓ **Order System**: Unique order numbers starting at #1000  
✓ **Receipts**: Itemized receipts with prices and totals  
✓ **To-Go Bags**: Bags reference order numbers  
✓ **Receipt Attachment**: Receipts attached to bags  
✓ **Drive-Thru**: Complete workflow from order to delivery  
✓ **Status Tracking**: Real-time order and employee status  

## Need More Help?

See [TESTING.md](docs/TESTING.md) for comprehensive testing instructions, troubleshooting, and manual verification steps.
