# EmployeesPlus

A comprehensive Fast Food Simulator mod that adds three employee types, a complete order management system with to-go bags, and an intelligent tray system with automatic drink preparation.

## 🚀 Getting Started

### ⚠️ Important: How This Mod Works

**This is a Lua code library**, not a UI mod. It doesn't automatically add menus to your game. Instead:
- ✅ Use it through Lua scripts or the game console
- ✅ Integrates with your game's modding/scripting system
- ❌ Won't appear in in-game hiring menus by itself

### Installation (3 Steps)
1. **Download**: Get from [GitHub](https://github.com/shifty81/EmployeesPlus) (Code → Download ZIP)
2. **Copy**: Place `EmployeesPlus` folder in your game's mods directory
   - Windows: `C:\Program Files\FastFoodSimulator\Mods\`
   - macOS: `~/Library/Application Support/FastFoodSimulator/Mods/`
   - Linux: `~/.local/share/FastFoodSimulator/Mods/`
3. **Use**: Load in game console with `local EmployeesPlus = require("init")`

📖 **Detailed Guide**: [QUICKINSTALL.md](QUICKINSTALL.md) or [INSTALL.md](docs/INSTALL.md)

### Testing (Verify It Works)
```bash
# Run all tests
./run_tests.sh        # Linux/Mac
run_tests.bat         # Windows

# Or test manually
lua tests/test_mod.lua
lua tests/test_tray_system.lua
```

🧪 **Testing Guide**: [QUICKTEST.md](QUICKTEST.md) or [TESTING.md](docs/TESTING.md)

---

## Features

### 🎉 NEW: Tray System
Smart order management with automatic drink preparation:
- **Ticket placement**: Orders are placed on a tray as tickets
- **Item tracking**: Track which items have been added to each order
- **Auto drink-making**: After 20 seconds, cashiers automatically make drinks
- **Smart completion**: Tray only marked complete when ALL items are present
- **No standing around**: Cashiers stay productive between orders

### 🎉 NEW: Idle Task System
Employees now have productive tasks when not actively working:
- **Cashiers**: Monitor trays, make drinks, prep for next order
- **Cooks**: Clean and prep cooking stations
- **Fry Cooks**: Clean fryers and prep baskets

### Employee Types

#### 🍟 Fry Cook
Specializes in frying food items like fries, chicken, onion rings, and more.
- Manages fryer stations
- Cooks multiple items simultaneously
- Tracks cooking times and status
- **Cleans and preps when idle**

#### 👨‍🍳 Cook
General-purpose cook for preparing various food items.
- Handles multiple cooking stations (grill, oven, prep table)
- Manages complete orders
- Tracks order preparation status
- **Cleans and preps stations when idle**

#### 🚗 Drive Thru Cashier
Handles the drive-thru window and customer interactions.
- **Manages tray system with order tickets**
- **Automatically makes drinks after 20 seconds**
- Sets up to-go bags with order numbers and receipts
- Prepares orders for customer pickup
- Hands orders to customers through the drive-thru window
- Tracks orders handed out

### Order System
- Automatic order numbering (starting at #1000)
- Itemized receipts with prices
- Order status tracking (pending, preparing, ready, completed)
- Real-time order updates

### Tray System
The new tray system streamlines order management and reduces employee idle time:
- **Ticket Management**: Place order tickets on tray to track what needs to be prepared
- **Item Tracking**: Monitor which items have been placed on tray for each order
- **Automatic Drink Preparation**: Cashiers automatically make drinks 20 seconds after ticket placement
- **Smart Completion**: Tray only marked complete when ALL required items are present
- **Seamless Workflow**: Cashier returns to cashiering duties after making drinks

### To-Go Bag System
- **References order number on the bag**
- **Attaches receipt to the bag**
- Visual status indicators
- Preparation tracking

## Quick Start

### Basic Usage
```lua
-- Load the mod
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Hire employees
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
cashier:startWork()
cashier:assignWindow("DRIVE-THRU-1")

-- Create and process an order
local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Fries", price = 2.99}
})

-- Setup to-go bag with order number and receipt
local bag = cashier:setupToGoBag(order)
cashier:prepareBagForPickup(bag)
cashier:handOrderToCustomer(1)
```

### NEW: Using the Tray System
```lua
-- Load the mod
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Hire a cashier
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
cashier:startWork()
cashier:assignWindow("WINDOW-1")

-- Create an order with drinks
local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Fries", price = 2.99},
    {name = "Drink", price = 1.99}
})

-- Place ticket on tray
cashier:placeTicketOnTray(order)

-- Get the tray and add prepared items
local tray = cashier:getTray()
tray:placeItem(order:getOrderNumber(), "Burger")
tray:placeItem(order:getOrderNumber(), "Fries")

-- After 20 seconds, cashier automatically makes the drink!
cashier:checkAndMakeDrinks()

-- Check if tray is complete (only true when all items present)
if cashier:isTrayComplete(order:getOrderNumber()) then
    cashier:notifyTrayComplete(order:getOrderNumber())
end
```

### Idle Tasks
```lua
-- Employees can perform idle tasks when not busy
cashier:performIdleTask()  -- Monitors tray for drinks to make
cook:performIdleTask()     -- Cleans and preps station
fryCook:performIdleTask()  -- Cleans fryer and preps baskets
```

## Installation

**Important:** This mod is a Lua code library that you use through scripts, not a UI mod.

**Quick Install:**
1. Download or clone this repository
2. Copy the `EmployeesPlus` folder to your game's mods directory:
   - **Windows**: `C:\Program Files\FastFoodSimulator\Mods\` or `%APPDATA%\FastFoodSimulator\Mods\`
   - **macOS**: `~/Library/Application Support/FastFoodSimulator/Mods/`
   - **Linux**: `~/.local/share/FastFoodSimulator/Mods/`
3. Use in your game scripts or console: `local EmployeesPlus = require("init")`
4. Look for the mod initialization message when you run `EmployeesPlus:init()`

**How to Use:**
- Open game console (usually `~` or `F1` key)
- Type: `local EmployeesPlus = require("init")`
- Type: `EmployeesPlus:init()`
- You should see the initialization message!

**See [INSTALL.md](docs/INSTALL.md) for detailed installation instructions, troubleshooting, and alternative installation methods.**

## Testing

See [TESTING.md](docs/TESTING.md) for comprehensive testing instructions.

**Quick test:**
```bash
./run_tests.sh        # Linux/Mac
run_tests.bat         # Windows
```

Or run individual tests:
```bash
lua tests/test_mod.lua              # Automated test suite
lua tests/test_tray_system.lua      # New tray system tests
lua examples/example_basic.lua      # Basic usage example
lua examples/example_drive_thru.lua # Drive-thru workflow
```

## Usage

See [USAGE.md](docs/USAGE.md) for complete API documentation and examples.

### Basic Workflow

1. **Hire Employees**
   ```lua
   local cook = EmployeesPlus:hireEmployee("Cook", "Mike")
   local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
   ```

2. **Start Work & Assign Stations**
   ```lua
   cook:startWork()
   cashier:startWork()
   cook:assignCookingStation("GRILL-1", "grill")
   cashier:assignWindow("DRIVE-THRU-1")
   ```

3. **Process Orders**
   ```lua
   local order = EmployeesPlus:createOrder({items})
   cook:startPreparingOrder(order)
   cook:cookItem(1, "Burger")
   local readyOrder = cook:completeOrder(1)
   ```

4. **Handle at Drive-Thru (Traditional Method)**
   ```lua
   -- Cashier sets up to-go bag referencing order number and receipt
   local bag = cashier:setupToGoBag(readyOrder)
   cashier:prepareBagForPickup(bag)
   cashier:handOrderToCustomer(1)
   ```

5. **NEW: Use Tray System**
   ```lua
   -- Place ticket on tray
   cashier:placeTicketOnTray(order)
   
   -- Add items as they're prepared
   local tray = cashier:getTray()
   tray:placeItem(order:getOrderNumber(), "Burger")
   tray:placeItem(order:getOrderNumber(), "Fries")
   
   -- After 20 seconds, drinks are automatically made
   cashier:checkAndMakeDrinks()
   
   -- Notify when complete
   if cashier:isTrayComplete(order:getOrderNumber()) then
       cashier:notifyTrayComplete(order:getOrderNumber())
   end
   ```

## Examples

Check out the `examples/` directory:
- `example_basic.lua` - Basic usage demonstration
- `example_drive_thru.lua` - Complete drive-thru workflow

## File Structure

```
EmployeesPlus/
├── mod.json                    # Mod manifest
├── config.json                 # Configuration settings
├── README.md                   # This file
├── src/
│   ├── init.lua               # Main entry point
│   ├── Order.lua              # Order management system
│   ├── ToGoBag.lua            # To-go bag with receipt system
│   ├── Tray.lua               # NEW: Tray system for order tracking
│   └── employees/
│       ├── Employee.lua       # Base employee class
│       ├── FryCook.lua        # Fry cook implementation
│       ├── Cook.lua           # Cook implementation
│       └── DriveThruCashier.lua  # Drive-thru cashier
├── examples/
│   ├── example_basic.lua
│   └── example_drive_thru.lua
├── tests/
│   ├── test_mod.lua           # Main test suite
│   └── test_tray_system.lua   # NEW: Tray system tests
└── docs/
    ├── INSTALL.md             # Installation guide
    └── USAGE.md               # Usage documentation
```

## Configuration

Customize employee behavior in `config.json`:

```json
{
  "employees": {
    "fry_cook": {
      "enabled": true,
      "default_cook_time": 120,
      "max_simultaneous_items": 4
    },
    "cook": {
      "enabled": true,
      "max_simultaneous_orders": 3
    },
    "drive_thru_cashier": {
      "enabled": true,
      "auto_prepare_bags": true
    }
  }
}
```

## Key Features Implemented

✅ **Fry Cook** - Specialized frying employee with idle tasks  
✅ **Cook** - General food preparation with idle tasks  
✅ **Drive Thru Cashier** - Window service specialist with tray management  
✅ **Order System** - Complete order management with unique numbers  
✅ **Tray System** - Smart order tracking with automatic drink preparation  
✅ **Auto Drink Making** - Cashiers make drinks after 20 seconds automatically  
✅ **Idle Tasks** - Employees stay productive when not actively cooking/serving  
✅ **To-Go Bags** - References order number and receipt on bag  
✅ **Receipt System** - Itemized receipts with totals  
✅ **Status Tracking** - Real-time order and employee status  

## License

MIT License - See repository for details

## Support

For issues, questions, or contributions:
- GitHub Issues: https://github.com/shifty81/EmployeesPlus/issues
- Documentation: See `docs/` folder

## Version

Current version: 1.0.0
