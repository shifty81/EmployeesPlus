# EmployeesPlus Testing Guide

## Overview
This guide explains how to test the EmployeesPlus mod both with automated tests and in-game to verify everything works correctly.

## Quick Start Testing

### Option 1: Run the Automated Test Suite
The easiest way to verify the mod works is to run the automated test suite:

```bash
cd /path/to/EmployeesPlus
lua tests/test_mod.lua
```

This will run comprehensive tests covering:
- Module loading
- Employee hiring and management
- Order creation and processing
- To-go bag system with order numbers and receipts
- Drive-thru workflow
- All employee types (Fry Cook, Cook, Drive Thru Cashier)

### Option 2: Test with Example Scripts
Run the included example scripts to see the mod in action:

```bash
# Basic functionality test
lua examples/example_basic.lua

# Complete drive-thru workflow test
lua examples/example_drive_thru.lua
```

## In-Game Testing

### Prerequisites
1. Install Lua runtime (lua5.3 or lua5.4)
2. Ensure Fast Food Simulator is installed
3. Mod is placed in the correct mods directory

### Testing Method 1: Using the Test Suite

The automated test suite (`tests/test_mod.lua`) can be run standalone to verify all functionality:

```bash
cd EmployeesPlus
lua tests/test_mod.lua
```

**Expected Output:**
```
========================================
EmployeesPlus Mod Test Suite
========================================

Test 1: Loading modules...
✓ Modules loaded successfully

Test 2: Initializing mod...
========================================
EmployeesPlus Mod v1.0.0
Fast Food Simulator Enhancement
========================================
✓ Mod initialized

Test 3: Hiring employees...
✓ Employees hired successfully

... [more tests] ...

========================================
✓ ALL TESTS PASSED!
========================================

Mod is working correctly!
- Fry Cook: Operational
- Cook: Operational
- Drive Thru Cashier: Operational
- Order System: Operational
- To-Go Bag System: Operational
- Receipt System: Operational
```

### Testing Method 2: Using Example Scripts

#### Basic Functionality Test

Run the basic example to test core features:

```bash
lua examples/example_basic.lua
```

**What it tests:**
- Hiring all three employee types
- Starting employees
- Assigning stations
- Creating orders
- Food preparation
- To-go bag setup with order numbers
- Receipt attachment
- Order completion

**Expected Output:**
You should see:
1. Employee hiring confirmations
2. Order creation with order number (e.g., #1001)
3. Receipt display with itemized prices
4. To-go bag setup confirmation
5. Order handoff confirmation
6. Final restaurant status

#### Drive-Thru Workflow Test

Run the drive-thru example for a complete workflow:

```bash
lua examples/example_drive_thru.lua
```

**What it tests:**
- Multiple orders processing
- Drive-thru window operations
- To-go bag creation with order references
- Receipt attachment to bags
- Order handoff through drive-thru window
- Cashier statistics tracking

### Testing Method 3: Interactive In-Game Testing

Create a test script to run within the game console:

```lua
-- Save this as test_ingame.lua
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Quick test: hire cashier and process one order
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "TestUser")
local cook = EmployeesPlus:hireEmployee("Cook", "TestCook")

cashier:startWork()
cook:startWork()

cashier:assignWindow("TEST-WINDOW-1")
cook:assignCookingStation("TEST-GRILL-1", "grill")

-- Create and process a simple order
local order = EmployeesPlus:createOrder({
    {name = "Test Burger", price = 5.99}
})

cook:startPreparingOrder(order)
cook:cookItem(1, "Test Burger")
local completedOrder = cook:completeOrder(1)

-- Cashier handles the order
local bag = cashier:setupToGoBag(completedOrder)
cashier:prepareBagForPickup(bag)
cashier:handOrderToCustomer(1)

print("\n✓ In-game test completed!")
print("Order #" .. order:getOrderNumber() .. " processed successfully")
```

Then in the game console:
```
/runlua test_ingame.lua
```

## Manual Verification Steps

Follow these steps to manually verify each feature:

### 1. Test Fry Cook
```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()

local fryCook = EmployeesPlus:hireEmployee("FryCook", "TestFryCook")
fryCook:startWork()
fryCook:assignFryerStation("FRYER-1")

-- Start frying
local result = fryCook:startFrying({
    name = "French Fries",
    cookTime = 120
}, 1001)

-- Verify
assert(result == true, "❌ Fry cook failed to start frying")
assert(fryCook:getActiveItemCount() >= 1, "❌ Item not in fryer")
print("✓ Fry Cook: Working")
```

### 2. Test Cook
```lua
local cook = EmployeesPlus:hireEmployee("Cook", "TestCook")
cook:startWork()
cook:assignCookingStation("GRILL-1", "grill")

local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99}
})

cook:startPreparingOrder(order)
cook:cookItem(1, "Burger")
local completed = cook:completeOrder(1)

-- Verify
assert(completed ~= nil, "❌ Cook failed to complete order")
assert(completed:getStatus() == "ready", "❌ Order not ready")
print("✓ Cook: Working")
```

### 3. Test Drive Thru Cashier
```lua
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "TestCashier")
cashier:startWork()
cashier:assignWindow("WINDOW-1")

-- Use completed order from previous test
local bag = cashier:setupToGoBag(completed)

-- Verify bag has order number and receipt
assert(bag:getDisplayedOrderNumber() == completed:getOrderNumber(), 
    "❌ Order number not on bag")
assert(bag:getReceipt() ~= nil, "❌ Receipt not attached")

cashier:prepareBagForPickup(bag)
cashier:handOrderToCustomer(1)

-- Verify
assert(cashier:getTotalHandedOrders() >= 1, "❌ Order not handed to customer")
print("✓ Drive Thru Cashier: Working")
```

### 4. Test Order System
```lua
local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Fries", price = 2.99},
    {name = "Drink", price = 1.99}
})

-- Verify
assert(order:getOrderNumber() >= 1000, "❌ Invalid order number")
assert(order:getStatus() == "pending", "❌ Wrong initial status")

local receipt = order:getReceiptString()
assert(receipt:find("ORDER #"), "❌ Receipt missing order number")
assert(receipt:find("TOTAL"), "❌ Receipt missing total")
assert(receipt:find("Burger"), "❌ Receipt missing items")
print("✓ Order System: Working")
```

### 5. Test To-Go Bag System
```lua
local order = EmployeesPlus:createOrder({
    {name = "Item", price = 1.99}
})
order:setStatus("ready")

local ToGoBag = require("ToGoBag")
local bag = ToGoBag.new(order)
bag:setupWithOrder(order)
bag:attachReceipt()

-- Verify
assert(bag:getDisplayedOrderNumber() == order:getOrderNumber(),
    "❌ Order number not displayed on bag")
assert(bag:getReceipt():find("ORDER #"), "❌ Receipt not properly attached")

bag:markAsPrepared()
assert(bag:isReady() == true, "❌ Bag not marked as ready")

bag:handToCustomer()
assert(bag:getStatus() == "delivered", "❌ Bag not delivered")
print("✓ To-Go Bag System: Working")
```

## Verification Checklist

Use this checklist to verify all features are working:

- [ ] **Module Loading**
  - [ ] `require("init")` loads without errors
  - [ ] `EmployeesPlus:init()` displays welcome message
  
- [ ] **Employee Hiring**
  - [ ] Can hire Fry Cook
  - [ ] Can hire Cook
  - [ ] Can hire Drive Thru Cashier
  - [ ] Employees appear in status list
  
- [ ] **Employee Operations**
  - [ ] Employees can start working
  - [ ] Can assign stations (fryer, grill, window)
  - [ ] Status updates correctly
  
- [ ] **Order System**
  - [ ] Orders get unique numbers starting at 1000
  - [ ] Receipts generate correctly with items and prices
  - [ ] Order status updates (pending → preparing → ready → completed)
  
- [ ] **Food Preparation**
  - [ ] Fry cook can start frying items
  - [ ] Cook can prepare orders
  - [ ] Items can be marked as cooked
  - [ ] Orders can be completed
  
- [ ] **To-Go Bag System**
  - [ ] Bags can be created for orders
  - [ ] **Order number displays on bag**
  - [ ] **Receipt attaches to bag**
  - [ ] Bags can be marked as prepared
  - [ ] Status updates correctly
  
- [ ] **Drive-Thru Operations**
  - [ ] Cashier can setup to-go bags
  - [ ] Bags reference correct order numbers
  - [ ] Orders can be handed to customers
  - [ ] Statistics track correctly
  
- [ ] **Restaurant Status**
  - [ ] `printStatus()` shows all information
  - [ ] Active order count is accurate
  - [ ] Completed order count is accurate
  - [ ] Employee statuses display correctly

## Troubleshooting

### Test Suite Fails to Run

**Problem**: `lua: module 'init' not found`

**Solution**: Make sure you're running from the EmployeesPlus directory and Lua can find the modules:
```bash
cd /path/to/EmployeesPlus
export LUA_PATH="./src/?.lua;./src/?/init.lua;./?.lua;;"
lua tests/test_mod.lua
```

### Example Scripts Fail

**Problem**: `attempt to call method 'hireEmployee' (a nil value)`

**Solution**: Ensure init.lua is being loaded correctly. Check that the path in the require statement is correct:
```lua
-- If examples are in examples/ directory, use:
package.path = package.path .. ";../src/?.lua;../src/?/init.lua"
local EmployeesPlus = require("init")
```

### In-Game Tests Don't Work

**Problem**: Mod doesn't load in game

**Solutions**:
1. Verify mod.json is in the root directory
2. Check config.json has `"enabled": true`
3. Ensure mod is in the correct mods folder
4. Check game console for error messages
5. Verify Lua version compatibility

### Orders Not Processing

**Problem**: Cook can't complete orders

**Solutions**:
1. Ensure cook has started work: `cook:startWork()`
2. Verify station is assigned: `cook:assignCookingStation("ID", "type")`
3. Check order was started: `cook:startPreparingOrder(order)`
4. Verify all items are cooked before completing

### To-Go Bags Missing Information

**Problem**: Order number or receipt not showing on bag

**Solutions**:
1. Ensure bag is setup with order: `bag:setupWithOrder(order)`
2. Attach receipt explicitly: `bag:attachReceipt()`
3. Verify order has valid order number
4. Check config.json has correct to-go bag settings

## Performance Testing

To test with high load:

```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Hire multiple employees
local employees = {}
for i = 1, 5 do
    local cook = EmployeesPlus:hireEmployee("Cook", "Cook" .. i)
    cook:startWork()
    cook:assignCookingStation("GRILL-" .. i, "grill")
    table.insert(employees, cook)
end

-- Create multiple orders
for i = 1, 20 do
    local order = EmployeesPlus:createOrder({
        {name = "Burger", price = 5.99},
        {name = "Fries", price = 2.99}
    })
    
    local cook = employees[(i % #employees) + 1]
    cook:startPreparingOrder(order)
    cook:cookItem(1, "Burger")
    cook:cookItem(1, "Fries")
    cook:completeOrder(1)
end

EmployeesPlus:printStatus()
```

## CI/CD Testing

For automated testing in CI/CD pipelines:

```bash
#!/bin/bash
# test.sh

echo "Running EmployeesPlus Tests..."

# Set Lua path
export LUA_PATH="./src/?.lua;./src/?/init.lua;./?.lua;;"

# Run test suite
lua tests/test_mod.lua
if [ $? -ne 0 ]; then
    echo "❌ Test suite failed"
    exit 1
fi

echo "✓ All tests passed"
exit 0
```

## Integration Testing

To test integration with Fast Food Simulator:

1. **Install mod in game**
   ```bash
   cp -r EmployeesPlus /path/to/FastFoodSimulator/Mods/
   ```

2. **Enable mod in game config**
   Edit game's mod configuration to enable EmployeesPlus

3. **Launch game and check console**
   Look for initialization message:
   ```
   ========================================
   EmployeesPlus Mod v1.0.0
   Fast Food Simulator Enhancement
   ========================================
   ```

4. **Test in-game commands**
   Use game console to run mod commands:
   ```
   /lua local EmployeesPlus = require("init")
   /lua EmployeesPlus:printStatus()
   ```

## Support

If you encounter issues during testing:

1. Check this guide's troubleshooting section
2. Review the logs in tests/test_mod.lua output
3. Verify your Lua version: `lua -v`
4. Check the GitHub issues: https://github.com/shifty81/EmployeesPlus/issues
5. Review USAGE.md for API documentation

## Summary

The mod provides three testing methods:
1. **Automated tests** - Run `lua tests/test_mod.lua`
2. **Example scripts** - Run examples for workflow demonstrations
3. **Manual testing** - Use verification steps for specific features

All three methods verify that the mod works correctly, including:
- All employee types functioning
- Orders processing with unique numbers
- To-go bags displaying order numbers
- Receipts attaching to bags
- Complete drive-thru workflow

Choose the method that best fits your needs!
