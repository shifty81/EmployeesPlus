# What's New in EmployeesPlus

## Recent Updates

### 🎉 NEW: Tray System (v1.1)
A smart order management system that eliminates employee idle time and automates drink preparation.

#### Key Features:
- **Order Ticket Management**: Place order tickets on a tray to track what needs to be prepared
- **Item Tracking**: Monitor which items have been added to each order
- **Smart Completion**: Tray only marked complete when ALL required items are present
- **Automatic Drink Preparation**: Cashiers automatically make drinks 20 seconds after ticket placement
- **Seamless Workflow**: Cashier returns to cashiering duties after making drinks

#### Quick Example:
```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Hire cashier
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

-- After 20 seconds, drink is automatically made!
cashier:checkAndMakeDrinks()

-- Check if complete (only true when all items present)
if cashier:isTrayComplete(order:getOrderNumber()) then
    cashier:notifyTrayComplete(order:getOrderNumber())
end
```

### 🎉 NEW: Idle Task System
Employees now have productive tasks when not actively working - no more standing around!

#### What Employees Do When Idle:
- **Drive Thru Cashiers**: Monitor trays for drink orders, check timers, prep for next order
- **Cooks**: Clean and prep cooking stations (grill, oven, prep table)
- **Fry Cooks**: Clean fryer stations and prep frying baskets

#### Usage:
```lua
-- Call when employee is idle
cashier:performIdleTask()
cook:performIdleTask()
fryCook:performIdleTask()

-- Or in a game loop
for _, employee in ipairs(EmployeesPlus:getEmployees()) do
    if not employee:getCurrentTask() then
        employee:performIdleTask()
    end
end
```

### 📚 Improved Documentation
We've clarified how the mod works and how to use it:

#### What Changed:
- ✅ **Clarified mod type**: This is a Lua code library, not a UI addon
- ✅ **Usage instructions**: How to use via game console or custom scripts
- ✅ **Installation guide**: Step-by-step with troubleshooting
- ✅ **Complete examples**: New tray system example added

#### Important to Know:
**This mod does NOT:**
- ❌ Add UI menus to the game automatically
- ❌ Show up in in-game hiring menus
- ❌ Modify the game's executable

**This mod DOES:**
- ✅ Provide Lua code for employee management
- ✅ Offer order and tray systems
- ✅ Enable scripting of restaurant operations
- ✅ Work as a code library you use from scripts

## How to Use

### Quick Start (Game Console):
```lua
-- Press ~ or F1 to open console
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Now you can use the mod!
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
cashier:startWork()
```

### Recommended (Custom Script):
Create a file `my_restaurant.lua`:
```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Setup employees
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
local cook = EmployeesPlus:hireEmployee("Cook", "Mike")
cashier:startWork()
cook:startWork()

-- Your restaurant logic here
```

Load it in game: `dofile("my_restaurant.lua")`

## Testing

Run the test suite to verify everything works:

```bash
# Linux/Mac
./run_tests.sh

# Windows
run_tests.bat

# Or individual tests
lua tests/test_mod.lua
lua tests/test_tray_system.lua
lua examples/example_tray_system.lua
```

## Migration Guide

If you're upgrading from a previous version:

### No Breaking Changes
All existing code continues to work! The tray system and idle tasks are optional additions.

### To Use New Features:

**Add Tray System:**
```lua
-- Old way still works
local bag = cashier:setupToGoBag(order)

-- New way with tray system
cashier:placeTicketOnTray(order)
local tray = cashier:getTray()
-- ... add items ...
cashier:checkAndMakeDrinks()
```

**Add Idle Tasks:**
```lua
-- Just add this where appropriate
employee:performIdleTask()
```

## Files Added

- `src/Tray.lua` - Tray system implementation
- `tests/test_tray_system.lua` - Comprehensive tray tests
- `examples/example_tray_system.lua` - Full demonstration
- `WHATSNEW.md` - This file

## Files Updated

- `src/employees/DriveThruCashier.lua` - Tray management, auto drinks
- `src/employees/Cook.lua` - Idle task functionality
- `src/employees/FryCook.lua` - Idle task functionality
- `README.md` - Added tray system docs, clarified usage
- `QUICKINSTALL.md` - Clarified mod is code library
- `docs/USAGE.md` - Added tray and idle task sections
- `docs/INSTALL.md` - Improved installation/troubleshooting
- Test runners - Include new tests

## Full Documentation

- **Installation**: [QUICKINSTALL.md](QUICKINSTALL.md) or [INSTALL.md](docs/INSTALL.md)
- **Usage Guide**: [USAGE.md](docs/USAGE.md)
- **Testing**: [QUICKTEST.md](QUICKTEST.md) or [TESTING.md](docs/TESTING.md)
- **Examples**: See `examples/` folder

## Questions?

- 📖 Read the docs in the `docs/` folder
- 🧪 Run the tests to see examples in action
- 💬 Open an issue on GitHub: https://github.com/shifty81/EmployeesPlus/issues

Enjoy the new features! 🍔🍟🥤
