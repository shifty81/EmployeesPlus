# Quick Installation Guide

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

### 3. Launch and Verify
1. Start Fast Food Simulator
2. Open the game console (usually `~` or `F1` key)
3. Look for this message:

```
========================================
EmployeesPlus Mod v1.0.0
Fast Food Simulator Enhancement
========================================
```

**If you see this, you're done! ✓**

---

## Quick Test (Optional)

In the game console, try:

```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()
EmployeesPlus:printStatus()
```

You should see restaurant status displayed.

---

## Troubleshooting

**Mod not loading?**
- Check that `mod.json` is in `Mods/EmployeesPlus/mod.json` (not in a subfolder)
- Verify `config.json` has `"enabled": true`
- Restart the game

**Still having issues?**
See [INSTALL.md](docs/INSTALL.md) for detailed troubleshooting.

---

## What's Next?

- 📖 **Learn to use it**: [USAGE.md](docs/USAGE.md)
- 🧪 **Test the mod**: [TESTING.md](docs/TESTING.md) or [QUICKTEST.md](QUICKTEST.md)
- 🚀 **Start using**: Hire employees and process orders!

**Quick example:**
```lua
local EmployeesPlus = require("init")
EmployeesPlus:init()

-- Hire a cashier
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
cashier:startWork()
cashier:assignWindow("WINDOW-1")

-- Create an order
local order = EmployeesPlus:createOrder({{name = "Burger", price = 5.99}})
```

Enjoy! 🍔🍟
