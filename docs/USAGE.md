# EmployeesPlus Usage Guide

## Overview
This guide explains how to use the EmployeesPlus mod in your Fast Food Simulator game.

## Quick Start

### 1. Load the Mod
```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()
```

### 2. Hire Employees
```lua
local fryCook = EmployeesPlus:hireEmployee("FryCook", "Bob")
local cook = EmployeesPlus:hireEmployee("Cook", "Alice")
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Charlie")
```

### 3. Start Working
```lua
fryCook:startWork()
cook:startWork()
cashier:startWork()
```

## Employee Types

### Fry Cook
Specializes in frying items like fries, chicken, onion rings, etc.

**Methods:**
```lua
-- Assign a fryer station
fryCook:assignFryerStation("FRYER-1")

-- Start frying an item
fryCook:startFrying({
    name = "French Fries",
    cookTime = 120  -- seconds
}, orderNumber)

-- Check cooking status
fryCook:checkCookingStatus(itemIndex)

-- Retrieve finished item
local finishedItem = fryCook:retrieveFinishedItem(itemIndex)

-- Get active item count
local count = fryCook:getActiveItemCount()
```

**Example:**
```lua
local fryCook = EmployeesPlus:hireEmployee("FryCook", "Tony")
fryCook:startWork()
fryCook:assignFryerStation("FRYER-1")
fryCook:startFrying({name = "Fries", cookTime = 120}, 1001)
```

### Cook
General-purpose cook for preparing various food items and orders.

**Methods:**
```lua
-- Assign cooking station
cook:assignCookingStation("GRILL-1", "grill")

-- Start preparing an order
cook:startPreparingOrder(order)

-- Cook a specific item
cook:cookItem(orderIndex, "Burger")

-- Complete and return order
local completedOrder = cook:completeOrder(orderIndex)

-- Get active order count
local count = cook:getActiveOrderCount()
```

**Example:**
```lua
local cook = EmployeesPlus:hireEmployee("Cook", "Alice")
cook:startWork()
cook:assignCookingStation("GRILL-1", "grill")

local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Fries", price = 2.99}
})

cook:startPreparingOrder(order)
cook:cookItem(1, "Burger")
cook:cookItem(1, "Fries")
local completedOrder = cook:completeOrder(1)
```

### Drive Thru Cashier
Handles drive-thru window, creates to-go bags, and hands orders to customers.

**Methods:**
```lua
-- Assign drive-thru window
cashier:assignWindow("WINDOW-1")

-- Setup to-go bag with order number and receipt
local bag = cashier:setupToGoBag(order)

-- Prepare bag for pickup
cashier:prepareBagForPickup(bag)

-- Hand order to customer through window
cashier:handOrderToCustomer(bagIndex)

-- Process entire workflow (setup, prepare, hand out)
cashier:processOrder(order)

-- Get statistics
local readyCount = cashier:getReadyOrderCount()
local totalHanded = cashier:getTotalHandedOrders()
```

**Example:**
```lua
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
cashier:startWork()
cashier:assignWindow("DRIVE-THRU-1")

-- When order is ready
local bag = cashier:setupToGoBag(completedOrder)
cashier:prepareBagForPickup(bag)
cashier:handOrderToCustomer(1)
```

## Order System

### Creating Orders
```lua
local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99, quantity = 1},
    {name = "Fries", price = 2.99, quantity = 2},
    {name = "Soda", price = 1.99, quantity = 1}
})
```

### Order Methods
```lua
-- Get order number
local orderNum = order:getOrderNumber()

-- Get order status
local status = order:getStatus()  -- "pending", "preparing", "ready", "completed"

-- Set order status
order:setStatus("preparing")

-- Get receipt string
local receiptText = order:getReceiptString()

-- Get order items
local items = order:getItems()
```

### Receipt Format
```
ORDER #1001
Time: 14:30:15
-------------------
1x Burger - $5.99
2x Fries - $5.98
1x Soda - $1.99
-------------------
TOTAL: $13.96
```

## To-Go Bag System

### Creating and Using To-Go Bags
The Drive Thru Cashier specifically sets up to-go bags with order numbers and receipts:

```lua
-- Create bag for an order
local bag = ToGoBag.new(order)

-- Setup bag with order (done by cashier)
bag:setupWithOrder(order)

-- Attach receipt to bag
bag:attachReceipt()

-- Mark as prepared
bag:markAsPrepared()

-- Hand to customer
bag:handToCustomer()
```

### Bag Properties
```lua
-- Get order number displayed on bag
local orderNum = bag:getDisplayedOrderNumber()

-- Get receipt
local receipt = bag:getReceipt()

-- Check if ready
local isReady = bag:isReady()

-- Get bag status
local status = bag:getStatus()  -- "empty", "preparing", "ready", "delivered"
```

## Complete Workflow Example

### Drive-Thru Order Process

```lua
-- Initialize
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Hire and setup employees
local cook = EmployeesPlus:hireEmployee("Cook", "Mike")
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")

cook:startWork()
cashier:startWork()

cook:assignCookingStation("GRILL-1", "grill")
cashier:assignWindow("DRIVE-THRU-1")

-- Customer places order
local order = EmployeesPlus:createOrder({
    {name = "Chicken Sandwich", price = 6.99},
    {name = "Fries", price = 2.99},
    {name = "Drink", price = 1.99}
})

-- Cook prepares order
cook:startPreparingOrder(order)
cook:cookItem(1, "Chicken Sandwich")
cook:cookItem(1, "Fries")
cook:cookItem(1, "Drink")
local completedOrder = cook:completeOrder(1)

-- Cashier handles at drive-thru
if completedOrder then
    -- Setup to-go bag (references order number and receipt)
    local bag = cashier:setupToGoBag(completedOrder)
    
    -- Prepare for customer
    cashier:prepareBagForPickup(bag)
    
    -- Hand through drive-thru window
    cashier:handOrderToCustomer(1)
    
    -- Complete order
    EmployeesPlus:completeOrder(completedOrder)
end

-- Check status
EmployeesPlus:printStatus()
```

## Restaurant Status

### View Current Status
```lua
-- Print complete restaurant status
EmployeesPlus:printStatus()
```

Output:
```
========== RESTAURANT STATUS ==========
Active Orders: 2
Completed Orders: 5
Employees: 3

Employee Status:
  - Bob (Fry Cook): Working - Task: Frying Fries for Order #1002
  - Alice (Cook): Working - Task: Preparing Order #1003
  - Charlie (Drive Thru Cashier): Working - Task: Ready to hand Order #1001
=======================================
```

### Get Orders
```lua
-- Get all active orders
local activeOrders = EmployeesPlus:getActiveOrders()

-- Get specific employee
local employee = EmployeesPlus:getEmployee("Bob")

-- Get all employees
local allEmployees = EmployeesPlus:getEmployees()
```

## Best Practices

1. **Always start employees before assigning tasks**
   ```lua
   employee:startWork()
   ```

2. **Assign stations before processing orders**
   ```lua
   cook:assignCookingStation("GRILL-1", "grill")
   cashier:assignWindow("WINDOW-1")
   ```

3. **Use cashier to setup to-go bags with order references**
   ```lua
   local bag = cashier:setupToGoBag(order)
   bag:attachReceipt()  -- Receipt shows order number
   ```

4. **Check order status before handing to customer**
   ```lua
   if order:getStatus() == "ready" and bag:isReady() then
       cashier:handOrderToCustomer(bagIndex)
   end
   ```

5. **Complete orders after delivery**
   ```lua
   EmployeesPlus:completeOrder(order)
   ```

## Advanced Usage

### Multiple Drive-Thru Windows
```lua
local cashier1 = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
local cashier2 = EmployeesPlus:hireEmployee("DriveThruCashier", "Tom")

cashier1:assignWindow("WINDOW-1")
cashier2:assignWindow("WINDOW-2")
```

### Tracking Employee Performance
```lua
-- For Fry Cook
local itemsCooked = fryCook:getActiveItemCount()

-- For Cook
local ordersInProgress = cook:getActiveOrderCount()

-- For Cashier
local ordersHandedOut = cashier:getTotalHandedOrders()
local ordersReady = cashier:getReadyOrderCount()
```

## Examples
See the `examples/` directory for complete working examples:
- `example_basic.lua` - Basic usage
- `example_drive_thru.lua` - Drive-thru workflow demonstration

## Testing

For testing the mod to ensure everything works:

### Quick Test
```bash
# Run all tests (Linux/Mac)
./run_tests.sh

# Run all tests (Windows)
run_tests.bat
```

### Manual Testing
```bash
# Test the mod functionality
lua tests/test_mod.lua

# Test basic features
lua examples/example_basic.lua

# Test drive-thru workflow
lua examples/example_drive_thru.lua
```

### In-Game Testing
Within the game console:
```lua
-- Load and initialize
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Run a quick test
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Test")
cashier:startWork()
cashier:assignWindow("TEST-1")

-- Create and process order
local order = EmployeesPlus:createOrder({{name = "Burger", price = 5.99}})
-- ... process order ...
EmployeesPlus:printStatus()
```

**For comprehensive testing instructions, see [TESTING.md](TESTING.md)**

## Troubleshooting

**Problem**: Employee not working
- **Solution**: Call `employee:startWork()` before assigning tasks

**Problem**: Order not preparing
- **Solution**: Ensure order has valid items with names and prices

**Problem**: Can't hand order to customer
- **Solution**: Verify bag is marked as prepared with `bag:markAsPrepared()`

**Problem**: Receipt not showing on bag
- **Solution**: Call `bag:attachReceipt()` after setting up the bag

## API Reference
For detailed API documentation, see the source code comments in:
- `src/Order.lua`
- `src/ToGoBag.lua`
- `src/employees/FryCook.lua`
- `src/employees/Cook.lua`
- `src/employees/DriveThruCashier.lua`
