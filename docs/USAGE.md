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

**NEW: Tray System Methods:**
```lua
-- Place order ticket on tray
cashier:placeTicketOnTray(order)

-- Get the tray
local tray = cashier:getTray()

-- Check if tray is complete for an order
cashier:isTrayComplete(orderNumber)

-- Check and make drinks automatically (after 20 seconds)
cashier:checkAndMakeDrinks()

-- Manually make a specific drink
cashier:makeDrink(orderNumber, drinkName)

-- Notify that tray is complete (only when all items present)
cashier:notifyTrayComplete(orderNumber)

-- Perform idle tasks (monitor trays, check for drinks)
cashier:performIdleTask()
```

**Tray System Example:**
```lua
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
cashier:startWork()
cashier:assignWindow("WINDOW-1")

-- Create order with drinks
local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Fries", price = 2.99},
    {name = "Drink", price = 1.99}
})

-- Place ticket on tray
cashier:placeTicketOnTray(order)

-- Add items as they're prepared
local tray = cashier:getTray()
tray:placeItem(order:getOrderNumber(), "Burger")
tray:placeItem(order:getOrderNumber(), "Fries")

-- After 20 seconds, drinks are made automatically
cashier:checkAndMakeDrinks()

-- Check if complete
if cashier:isTrayComplete(order:getOrderNumber()) then
    cashier:notifyTrayComplete(order:getOrderNumber())
end
```

## Tray System

The tray system provides intelligent order management with automatic drink preparation.

### Creating and Managing Trays

**Place Ticket on Tray:**
```lua
-- Place order ticket
local ticket = cashier:placeTicketOnTray(order)
```

**Add Items to Tray:**
```lua
local tray = cashier:getTray()
tray:placeItem(orderNumber, "Burger")
tray:placeItem(orderNumber, "Fries")
```

**Check Tray Completion:**
```lua
-- Only returns true when ALL required items are on tray
local isComplete = tray:checkTrayComplete(orderNumber)

-- Or use cashier method
if cashier:isTrayComplete(orderNumber) then
    print("Tray complete!")
end
```

**Automatic Drink Preparation:**
After 20 seconds of placing a ticket on the tray, cashiers automatically check for drinks and make them:
```lua
-- This is called automatically in game loops, or manually:
cashier:checkAndMakeDrinks()

-- The cashier will:
-- 1. Find tickets waiting 20+ seconds
-- 2. Check if drinks are required
-- 3. Make drinks not yet on the tray
-- 4. Return to cashiering after completing
```

**Tray Properties:**
```lua
-- Get ticket for specific order
local ticket = tray:getTicket(orderNumber)

-- Get all tickets
local allTickets = tray:getTickets()

-- Get incomplete ticket count
local incompleteCount = tray:getIncompleteTicketCount()

-- Get complete ticket count
local completeCount = tray:getCompleteTicketCount()

-- Remove ticket when order is delivered
tray:removeTicket(orderNumber)
```

### Tray Workflow Example

Complete workflow using the tray system:

```lua
-- Setup
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
local cook = EmployeesPlus:hireEmployee("Cook", "Mike")
cashier:startWork()
cook:startWork()
cashier:assignWindow("WINDOW-1")
cook:assignCookingStation("GRILL-1", "grill")

-- Customer orders
local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Fries", price = 2.99},
    {name = "Drink", price = 1.99}
})

-- Place ticket on tray
cashier:placeTicketOnTray(order)

-- Cook prepares food
cook:startPreparingOrder(order)
cook:cookItem(1, "Burger")
cook:cookItem(1, "Fries")

-- Add prepared items to tray
local tray = cashier:getTray()
tray:placeItem(order:getOrderNumber(), "Burger")
tray:placeItem(order:getOrderNumber(), "Fries")

-- After 20 seconds, cashier automatically makes drink
-- (In game loop or called periodically)
cashier:checkAndMakeDrinks()

-- Check if tray is complete
if cashier:isTrayComplete(order:getOrderNumber()) then
    -- Only notifies when ALL items are present
    cashier:notifyTrayComplete(order:getOrderNumber())
    
    -- Now ready to hand to customer
    local bag = cashier:setupToGoBag(order)
    cashier:prepareBagForPickup(bag)
    cashier:handOrderToCustomer(1)
end
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

## Idle Tasks

NEW: Employees now have productive tasks when not actively working, eliminating "standing around" time.

### Using Idle Tasks

All employee types support idle tasks:

```lua
-- Cashiers: Monitor trays and check for drinks to make
cashier:performIdleTask()

-- Cooks: Clean and prep cooking stations
cook:performIdleTask()

-- Fry Cooks: Clean fryers and prep baskets
fryCook:performIdleTask()
```

### Automatic Idle Behavior

The idle task system is designed to be called periodically (e.g., in a game loop):

```lua
-- In your game update loop
function updateRestaurant()
    -- Update all employees
    for _, employee in ipairs(EmployeesPlus:getEmployees()) do
        if employee:getIsWorking() and not employee:getCurrentTask() then
            employee:performIdleTask()
        end
    end
    
    -- Check for drinks to make (cashiers)
    for _, employee in ipairs(EmployeesPlus:getEmployees()) do
        if employee.checkAndMakeDrinks then
            employee:checkAndMakeDrinks()
        end
    end
end
```

### What Each Employee Does When Idle

**Drive Thru Cashier:**
- Monitors tray for orders needing drinks
- Checks if 20 seconds have passed since ticket placement
- Automatically makes drinks when needed
- Updates task status

**Cook:**
- Cleans cooking stations (grill, oven, prep table)
- Preps ingredients for next orders
- Monitors orders in progress
- Maintains station cleanliness

**Fry Cook:**
- Cleans fryer stations
- Preps frying baskets
- Monitors items currently frying
- Maintains fryer temperature

### Example with Idle Tasks

Complete restaurant simulation with idle tasks:

```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Setup employees
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
local cook = EmployeesPlus:hireEmployee("Cook", "Mike")
local fryCook = EmployeesPlus:hireEmployee("FryCook", "Tony")

cashier:startWork()
cook:startWork()
fryCook:startWork()

cashier:assignWindow("WINDOW-1")
cook:assignCookingStation("GRILL-1", "grill")
fryCook:assignFryerStation("FRYER-1")

-- Game loop simulation
function gameUpdate()
    -- Process any active orders
    -- ... order processing code ...
    
    -- Have idle employees do productive tasks
    if not cashier:getCurrentTask() then
        cashier:performIdleTask()
    end
    
    if not cook:getCurrentTask() then
        cook:performIdleTask()
    end
    
    if not fryCook:getCurrentTask() then
        fryCook:performIdleTask()
    end
    
    -- Check for automatic drink-making
    cashier:checkAndMakeDrinks()
end

-- Run game loop
for i = 1, 100 do
    gameUpdate()
    -- ... other game logic ...
end
```

## Troubleshooting

**Problem**: Employee not working
- **Solution**: Call `employee:startWork()` before assigning tasks

**Problem**: Order not preparing
- **Solution**: Ensure order has valid items with names and prices

**Problem**: Can't hand order to customer
- **Solution**: Verify bag is marked as prepared with `bag:markAsPrepared()`

**Problem**: Receipt not showing on bag
- **Solution**: Call `bag:attachReceipt()` after setting up the bag

**Problem**: Tray not marking as complete
- **Solution**: Ensure ALL required items have been placed on the tray, including drinks

**Problem**: Drinks not being made automatically
- **Solution**: Call `cashier:checkAndMakeDrinks()` periodically, ensure 20+ seconds have passed since ticket placement

**Problem**: Employees standing around idle
- **Solution**: Call `employee:performIdleTask()` when employees don't have active tasks

## API Reference
For detailed API documentation, see the source code comments in:
- `src/Order.lua`
- `src/ToGoBag.lua`
- `src/Tray.lua`
- `src/employees/FryCook.lua`
- `src/employees/Cook.lua`
- `src/employees/DriveThruCashier.lua`
