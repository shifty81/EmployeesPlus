# Quick Installation Guide

## ⚠️ Important: Game Integration Note

**This mod is a Lua-based library for Fast Food Simulator.** It provides employee management functionality that needs to be integrated into your game through Lua scripts or modding APIs.

### This mod does NOT:
- ❌ Add UI menus to the game automatically
- ❌ Show up in an in-game "hiring menu"
- ❌ Modify the game's executable or core files

### This mod DOES:
- ✅ Provide Lua code for employee management
- ✅ Offer order and tray systems
- ✅ Enable scripting of restaurant operations
- ✅ Work as a code library in your game scripts

---

## Install EmployeesPlus Mod in 3 Steps

### 1. Download
Get the mod from GitHub:
- Go to: https://github.com/shifty81/EmployeesPlus
- Click "Code" → "Download ZIP"
- Extract the ZIP file

### 2. Copy to Mods Folder
Place the `EmployeesPlus` folder in your game's mods directory:

**Windows:**
```
C:\Program Files\FastFoodSimulator\Mods\EmployeesPlus\
```
or
```
%APPDATA%\FastFoodSimulator\Mods\EmployeesPlus\
```

**macOS:**
```
~/Library/Application Support/FastFoodSimulator/Mods/EmployeesPlus/
```

**Linux:**
```
~/.local/share/FastFoodSimulator/Mods/EmployeesPlus/
```

### 3. Use in Your Scripts
To use the mod, add this code to your game scripts or console:

```lua
-- Load the mod
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Now you can hire employees and manage orders!
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
cashier:startWork()
```

**If you can run this code without errors, installation is successful! ✓**

---

## How to Use in Game

### Option 1: Game Console
1. Start Fast Food Simulator
2. Open the game console (usually `~` or `F1` key)
3. Type/paste Lua commands to use the mod:

```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
cashier:startWork()
EmployeesPlus:printStatus()
```

### Option 2: Create Custom Scripts
Create a file like `my_restaurant.lua` in your game's scripts folder:

```lua
-- my_restaurant.lua
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Hire employees
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
local cook = EmployeesPlus:hireEmployee("Cook", "Mike")

-- Start working
cashier:startWork()
cook:startWork()

-- Assign stations
cashier:assignWindow("WINDOW-1")
cook:assignCookingStation("GRILL-1", "grill")
```

Then load it in the game console: `dofile("my_restaurant.lua")`

---

## Verification

After installation, open the game console and run:

```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()
```

You should see:
```
========================================
EmployeesPlus Mod v1.0.0
Fast Food Simulator Enhancement
========================================
Loaded employees:
  - Fry Cook: Specializes in frying items
  - Cook: General food preparation
  - Drive Thru Cashier: Handles orders at window
========================================
```

**If you see this, installation succeeded! ✓**

---

## Troubleshooting

**"Module not found" error?**
- Make sure the `EmployeesPlus` folder is in the correct mods directory
- Verify `src/init.lua` exists inside the EmployeesPlus folder
- Check that the game's Lua path includes the mods directory

**Mod not appearing in game UI?**
- This is normal! The mod is a code library, not a UI mod
- Use it by writing Lua scripts or typing commands in the console
- See [USAGE.md](docs/USAGE.md) for examples

**Still having issues?**
See [INSTALL.md](docs/INSTALL.md) for detailed troubleshooting.

---

## What's Next?

- 📖 **Learn to use it**: [USAGE.md](docs/USAGE.md)
- 🧪 **Test the mod**: [TESTING.md](docs/TESTING.md) or [QUICKTEST.md](QUICKTEST.md)
- 🚀 **Start using**: Hire employees and process orders!

**Quick example with new tray system:**
```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Hire a cashier
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
cashier:startWork()
cashier:assignWindow("WINDOW-1")

-- Create an order
local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Fries", price = 2.99},
    {name = "Drink", price = 1.99}
})

-- Place ticket on tray
cashier:placeTicketOnTray(order)

-- After 20 seconds, cashier will automatically make drinks!
-- Tray completion is notified only when all items are present
```

## New Features! 🎉

### Tray System
- Place order tickets on a tray
- Track items as they're added to the tray
- Cashiers automatically make drinks after 20 seconds
- Tray completion notification only when ALL items are present

### Idle Task System
- Employees now have tasks when not actively working
- **Cashiers**: Monitor trays and make drinks
- **Cooks**: Clean and prep cooking stations
- **Fry Cooks**: Clean fryers and prep baskets
- **No more standing around!**

See [USAGE.md](docs/USAGE.md) for complete tray system documentation.

Enjoy! 🍔🍟
