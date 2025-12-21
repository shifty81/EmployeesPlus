# EmployeesPlus

A comprehensive Fast Food Simulator mod that adds three employee types and a complete order management system with to-go bags.

## 🚀 Getting Started

### Installation (3 Steps)
1. **Download**: Get from [GitHub](https://github.com/shifty81/EmployeesPlus) (Code → Download ZIP)
2. **Copy**: Place `EmployeesPlus` folder in your game's mods directory
   - Windows: `C:\Program Files\FastFoodSimulator\Mods\`
   - macOS: `~/Library/Application Support/FastFoodSimulator/Mods/`
   - Linux: `~/.local/share/FastFoodSimulator/Mods/`
3. **Launch**: Start the game and look for initialization message

📖 **Detailed Guide**: [QUICKINSTALL.md](QUICKINSTALL.md) or [INSTALL.md](docs/INSTALL.md)

### Testing (Verify It Works)
```bash
# Run all tests
./run_tests.sh        # Linux/Mac
run_tests.bat         # Windows

# Or test manually
lua tests/test_mod.lua
```

🧪 **Testing Guide**: [QUICKTEST.md](QUICKTEST.md) or [TESTING.md](docs/TESTING.md)

---

## Features

### Employee Types

#### 🍟 Fry Cook
Specializes in frying food items like fries, chicken, onion rings, and more.
- Manages fryer stations
- Cooks multiple items simultaneously
- Tracks cooking times and status

#### 👨‍🍳 Cook
General-purpose cook for preparing various food items.
- Handles multiple cooking stations (grill, oven, prep table)
- Manages complete orders
- Tracks order preparation status

#### 🚗 Drive Thru Cashier
Handles the drive-thru window and customer interactions.
- **Sets up to-go bags with order numbers and receipts**
- Prepares orders for customer pickup
- Hands orders to customers through the drive-thru window
- Tracks orders handed out

### Order System
- Automatic order numbering (starting at #1000)
- Itemized receipts with prices
- Order status tracking (pending, preparing, ready, completed)
- Real-time order updates

### To-Go Bag System
- **References order number on the bag**
- **Attaches receipt to the bag**
- Visual status indicators
- Preparation tracking

## Quick Start

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

## Installation

**Quick Install:**
1. Download or clone this repository
2. Copy the `EmployeesPlus` folder to your game's mods directory:
   - **Windows**: `C:\Program Files\FastFoodSimulator\Mods\` or `%APPDATA%\FastFoodSimulator\Mods\`
   - **macOS**: `~/Library/Application Support/FastFoodSimulator/Mods/`
   - **Linux**: `~/.local/share/FastFoodSimulator/Mods/`
3. Make sure `config.json` has `"enabled": true`
4. Launch Fast Food Simulator
5. Look for the mod initialization message in the game console

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

4. **Handle at Drive-Thru**
   ```lua
   -- Cashier sets up to-go bag referencing order number and receipt
   local bag = cashier:setupToGoBag(readyOrder)
   cashier:prepareBagForPickup(bag)
   cashier:handOrderToCustomer(1)
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
│   └── employees/
│       ├── Employee.lua       # Base employee class
│       ├── FryCook.lua        # Fry cook implementation
│       ├── Cook.lua           # Cook implementation
│       └── DriveThruCashier.lua  # Drive-thru cashier
├── examples/
│   ├── example_basic.lua
│   └── example_drive_thru.lua
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

✅ **Fry Cook** - Specialized frying employee  
✅ **Cook** - General food preparation  
✅ **Drive Thru Cashier** - Window service specialist  
✅ **Order System** - Complete order management with unique numbers  
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
