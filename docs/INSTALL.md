# EmployeesPlus Installation Guide

## Overview
EmployeesPlus is a Fast Food Simulator mod that adds three employee types and a comprehensive order/to-go bag system.

## Requirements
- Fast Food Simulator (version 1.0.0 or higher)
- Lua runtime environment
- Mod loader compatible with the game

## Installation Steps

### 1. Download the Mod
Download or clone the EmployeesPlus mod to your mods directory:
```bash
git clone https://github.com/shifty81/EmployeesPlus.git
```

### 2. Mod Directory Structure
Ensure your mod is structured as follows:
```
EmployeesPlus/
├── mod.json                    # Mod manifest
├── config.json                 # Configuration settings
├── src/
│   ├── init.lua               # Main entry point
│   ├── Order.lua              # Order system
│   ├── ToGoBag.lua            # To-go bag system
│   └── employees/
│       ├── Employee.lua       # Base employee class
│       ├── FryCook.lua        # Fry cook implementation
│       ├── Cook.lua           # Cook implementation
│       └── DriveThruCashier.lua  # Drive-thru cashier
├── examples/
│   ├── example_basic.lua
│   └── example_drive_thru.lua
└── docs/
    ├── INSTALL.md
    └── USAGE.md
```

### 3. Copy to Mods Folder
Copy the entire `EmployeesPlus` folder to your Fast Food Simulator mods directory:
- **Windows**: `C:\Program Files\FastFoodSimulator\Mods\`
- **Mac**: `~/Library/Application Support/FastFoodSimulator/Mods/`
- **Linux**: `~/.local/share/FastFoodSimulator/Mods/`

### 4. Enable the Mod
Edit `config.json` if needed to customize settings:
```json
{
  "mod": {
    "enabled": true,
    "debug": false
  }
}
```

### 5. Launch the Game
Start Fast Food Simulator. The mod should load automatically.

### 6. Verify Installation
Check the game console for the startup message:
```
========================================
EmployeesPlus Mod v1.0.0
Fast Food Simulator Enhancement
========================================
```

## Configuration

### Employee Settings
Edit `config.json` to customize employee behavior:

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

### Order Settings
```json
{
  "orders": {
    "starting_order_number": 1000,
    "show_receipts": true,
    "print_order_updates": true
  }
}
```

## Troubleshooting

### Mod Not Loading
1. Check that `mod.json` is in the root of the EmployeesPlus folder
2. Verify `"enabled": true` in `config.json`
3. Check game console for error messages

### Employees Not Working
1. Ensure employees are started with `employee:startWork()`
2. Assign appropriate stations to employees
3. Check that orders are properly created

### Orders Not Processing
1. Verify order items have required fields (name, price)
2. Check that cooks are assigned to orders
3. Ensure to-go bags are properly setup with orders

## Uninstallation
To remove the mod:
1. Delete the `EmployeesPlus` folder from your mods directory
2. Restart the game

## Support
For issues and support, visit: https://github.com/shifty81/EmployeesPlus/issues
