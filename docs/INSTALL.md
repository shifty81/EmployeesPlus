# EmployeesPlus Installation Guide

## Quick Installation (TL;DR)

1. **Download**: Get the mod from [GitHub releases](https://github.com/shifty81/EmployeesPlus/releases) or clone the repo
2. **Copy**: Place the `EmployeesPlus` folder in your game's mods directory
3. **Enable**: Make sure `config.json` has `"enabled": true`
4. **Play**: Launch the game and look for the initialization message

---

## Overview
EmployeesPlus is a Fast Food Simulator mod that adds three employee types and a comprehensive order/to-go bag system.

## Requirements
- Fast Food Simulator (version 1.0.0 or higher)
- Lua runtime environment (usually included with the game)
- Mod loader compatible with the game

## Detailed Installation Steps

### Step 1: Download the Mod

Choose one of these methods:

**Method A: Download ZIP (Easiest)**
1. Go to https://github.com/shifty81/EmployeesPlus
2. Click the green "Code" button
3. Select "Download ZIP"
4. Extract the ZIP file to a temporary location

**Method B: Clone with Git**
```bash
git clone https://github.com/shifty81/EmployeesPlus.git
```

**Method C: Download from Releases**
1. Go to https://github.com/shifty81/EmployeesPlus/releases
2. Download the latest release ZIP
3. Extract to a temporary location

### Step 2: Locate Your Game's Mods Folder

Find where Fast Food Simulator stores mods on your system:

**Windows:**
- Primary: `C:\Program Files\FastFoodSimulator\Mods\`
- Alternative: `C:\Program Files (x86)\FastFoodSimulator\Mods\`
- Steam: `C:\Program Files (x86)\Steam\steamapps\common\FastFoodSimulator\Mods\`
- User folder: `%APPDATA%\FastFoodSimulator\Mods\`

**macOS:**
- Primary: `~/Library/Application Support/FastFoodSimulator/Mods/`
- Alternative: `/Applications/FastFoodSimulator.app/Contents/Mods/`
- Steam: `~/Library/Application Support/Steam/steamapps/common/FastFoodSimulator/Mods/`

**Linux:**
- Primary: `~/.local/share/FastFoodSimulator/Mods/`
- Alternative: `~/FastFoodSimulator/Mods/`
- Steam: `~/.steam/steam/steamapps/common/FastFoodSimulator/Mods/`

**Can't find it?**
- Check the game's settings or documentation
- Look for a "Mods" or "Addons" folder in the game installation directory
- Create a `Mods` folder if it doesn't exist

### Step 3: Install the Mod

1. **Copy the entire folder**: Take the `EmployeesPlus` folder and copy it to your mods directory
   
   Your final structure should look like:
   ```
   FastFoodSimulator/
   └── Mods/
       └── EmployeesPlus/
           ├── mod.json
           ├── config.json
           ├── src/
           ├── examples/
           ├── docs/
           └── tests/
   ```

2. **Verify the structure**: Make sure `mod.json` is in the root of the `EmployeesPlus` folder, not in a subfolder

### Step 4: Configure the Mod (Optional)

The mod comes pre-configured and ready to use. If you want to customize:

1. Navigate to `EmployeesPlus/config.json`
2. Open it in a text editor
3. Ensure `"enabled": true` is set under the `"mod"` section

**Default configuration:**
```json
{
  "mod": {
    "enabled": true,
    "debug": false
  },
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

### Step 5: Launch the Game

1. **Start Fast Food Simulator**
2. **Watch for mod loading** - The game should automatically detect and load the mod
3. **Check the console** (usually accessible with `~` or `F1` key)

### Step 6: Verify Installation

Look for this message in the game console:

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

If you see this message, the mod is installed correctly!

### Step 7: Test the Mod (Optional)

To verify everything works, open the game console and run:

```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()
EmployeesPlus:printStatus()
```

You should see restaurant status information displayed.

## Alternative: Standalone Testing (Before Game Installation)

Want to test the mod before installing it in the game?

1. **Install Lua** (if not already installed):
   - Windows: Download from https://www.lua.org or use [LuaForWindows](https://github.com/rjpcomputing/luaforwindows)
   - macOS: `brew install lua`
   - Linux: `sudo apt-get install lua5.3`

2. **Run the test suite**:
   ```bash
   cd EmployeesPlus
   ./run_tests.sh        # Linux/Mac
   run_tests.bat         # Windows
   ```

3. **Or run tests manually**:
   ```bash
   lua tests/test_mod.lua
   lua examples/example_basic.lua
   ```

See [TESTING.md](TESTING.md) for comprehensive testing instructions.

---

## Mod Directory Structure

After installation, your mod should have this structure:
```
EmployeesPlus/
├── mod.json                    # Mod manifest (required)
├── config.json                 # Configuration settings
├── README.md                   # Documentation
├── QUICKTEST.md               # Quick testing guide
├── run_tests.sh               # Test runner (Linux/Mac)
├── run_tests.bat              # Test runner (Windows)
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
├── tests/
│   └── test_mod.lua           # Test suite
└── docs/
    ├── INSTALL.md             # This file
    ├── USAGE.md               # Usage guide
    ├── TESTING.md             # Testing guide
    └── ARCHITECTURE.md        # Architecture docs
```

---

## Configuration Options

### Employee Settings

Customize employee behavior in `config.json`:

```json
{
  "employees": {
    "fry_cook": {
      "enabled": true,
      "default_cook_time": 120,       // Seconds to cook items
      "max_simultaneous_items": 4      // Max items in fryer at once
    },
    "cook": {
      "enabled": true,
      "max_simultaneous_orders": 3     // Max orders cook can handle
    },
    "drive_thru_cashier": {
      "enabled": true,
      "auto_prepare_bags": true        // Automatically prepare bags
    }
  }
}
```

### Order Settings

```json
{
  "orders": {
    "starting_order_number": 1000,   // First order number
    "show_receipts": true,            // Print receipts to console
    "print_order_updates": true       // Show order status updates
  }
}
```

### To-Go Bag Settings

```json
{
  "to_go_bags": {
    "show_order_number": true,       // Display order # on bag
    "attach_receipt": true,           // Attach receipt to bag
    "require_preparation": true       // Require bag preparation step
  }
}
```

---

## Troubleshooting

### Problem: Mod Not Loading

**Symptoms**: No initialization message appears in game console

**Solutions**:
1. ✓ Check that `mod.json` exists in the root of `EmployeesPlus` folder
2. ✓ Verify `"enabled": true` in `config.json`
3. ✓ Make sure the folder is named exactly `EmployeesPlus`
4. ✓ Check game console for error messages (press `~` or `F1`)
5. ✓ Verify you're looking in the correct mods directory
6. ✓ Restart the game completely
7. ✓ Check game's mod manager (if it has one) to enable the mod

### Problem: "Module not found" Error

**Symptoms**: Game shows error like `module 'init' not found`

**Solutions**:
1. ✓ Verify all files are in the correct structure (see directory structure above)
2. ✓ Make sure `src/init.lua` exists
3. ✓ Check that all Lua files are in the `src/` directory
4. ✓ Ensure the game's Lua path includes the mod directory

### Problem: Mod Loads but Functions Don't Work

**Symptoms**: Initialization message appears, but employees/orders don't work

**Solutions**:
1. ✓ Check that all employee types are enabled in `config.json`
2. ✓ Run the test suite to verify functionality: `lua tests/test_mod.lua`
3. ✓ Review the [USAGE.md](USAGE.md) guide for correct API usage
4. ✓ Check game console for error messages
5. ✓ Try the examples: `lua examples/example_basic.lua`

### Problem: Permission Errors (Windows)

**Symptoms**: Cannot copy files to Program Files

**Solutions**:
1. ✓ Run File Explorer as Administrator
2. ✓ Or use the alternative location: `%APPDATA%\FastFoodSimulator\Mods\`
3. ✓ Check file permissions on the mods directory

### Problem: Mod Works in Test but Not in Game

**Symptoms**: `lua tests/test_mod.lua` passes, but game doesn't work

**Solutions**:
1. ✓ The game might use a different Lua version - check compatibility
2. ✓ Verify the game's mod loader is working with other mods
3. ✓ Check if game requires mods to be registered/enabled in settings
4. ✓ Review game's modding documentation

### Problem: Wrong Folder Structure

**Common mistake**: Having nested folders like `Mods/EmployeesPlus/EmployeesPlus/`

**Solution**: The structure should be `Mods/EmployeesPlus/mod.json` (not an extra folder level)

---

## Quick Verification Checklist

After installation, verify:

- [ ] `mod.json` exists in `Mods/EmployeesPlus/mod.json`
- [ ] `config.json` has `"enabled": true`
- [ ] `src/init.lua` exists
- [ ] Game console shows initialization message
- [ ] No error messages in game console
- [ ] Can run `EmployeesPlus:printStatus()` in game console

---

## Updating the Mod

To update to a newer version:

1. **Backup your config**: Copy `config.json` to a safe location
2. **Remove old version**: Delete the `EmployeesPlus` folder from your mods directory
3. **Install new version**: Follow installation steps above
4. **Restore config** (optional): Copy your saved `config.json` back
5. **Restart game**: Launch the game to load the new version

---

## Uninstallation

To completely remove the mod:

1. **Close the game** if it's running
2. **Navigate to**: Your game's mods directory
3. **Delete**: The entire `EmployeesPlus` folder
4. **Restart game**: Launch the game normally

The mod doesn't modify any game files, so uninstallation is clean.

---

## Getting Help

If you're still having issues:

1. **Read the docs**:
   - [USAGE.md](USAGE.md) - How to use the mod
   - [TESTING.md](TESTING.md) - How to test the mod
   - [QUICKTEST.md](../QUICKTEST.md) - Quick testing reference

2. **Run diagnostics**:
   ```bash
   cd EmployeesPlus
   lua tests/test_mod.lua
   ```

3. **Check GitHub Issues**: https://github.com/shifty81/EmployeesPlus/issues

4. **Create an issue**: If you found a bug, open a new issue with:
   - Your operating system
   - Game version
   - Steps to reproduce
   - Error messages from console
   - Whether standalone tests work

---

## Next Steps

After successful installation:

1. **Learn to use the mod**: Read [USAGE.md](USAGE.md)
2. **Try the examples**: Run the example scripts in the `examples/` folder
3. **Test features**: See [TESTING.md](TESTING.md) for testing guide
4. **Start playing**: Use the mod in your game!

## Quick Start After Installation

Once installed, open the game console and try:

```lua
-- Load the mod
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Hire a cashier
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
cashier:startWork()
cashier:assignWindow("WINDOW-1")

-- Create an order
local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Fries", price = 2.99}
})

-- Check status
EmployeesPlus:printStatus()
```

See [USAGE.md](USAGE.md) for complete API documentation and more examples!

---

## Support

For issues and support:
- 📖 Documentation: See the `docs/` folder
- 🐛 Bug Reports: https://github.com/shifty81/EmployeesPlus/issues
- 💬 Questions: Open a GitHub discussion or issue

Enjoy using EmployeesPlus! 🍔🍟🥤
