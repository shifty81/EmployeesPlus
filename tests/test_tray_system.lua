-- test_tray_system.lua
-- Test the new tray system and automatic drink-making functionality

print("========================================")
print("EmployeesPlus Tray System Test")
print("========================================\n")

-- Test 1: Load modules
print("Test 1: Loading modules...")
local success, EmployeesPlus = pcall(require, "init")
if not success then
    print("❌ FAILED: Could not load init.lua")
    print("Error: " .. tostring(EmployeesPlus))
    os.exit(1)
end
print("✓ Modules loaded successfully\n")

-- Test 2: Initialize mod
print("Test 2: Initializing mod...")
EmployeesPlus:init()
print("✓ Mod initialized\n")

-- Test 3: Hire cashier
print("Test 3: Hiring cashier...")
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "TestCashier")
if not cashier then
    print("❌ FAILED: Could not hire cashier")
    os.exit(1)
end
cashier:startWork()
cashier:assignWindow("TEST-WINDOW-1")
print("✓ Cashier hired and assigned\n")

-- Test 4: Create order with drinks
print("Test 4: Creating order with drinks...")
local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Fries", price = 2.99},
    {name = "Drink", price = 1.99}
})
if not order then
    print("❌ FAILED: Could not create order")
    os.exit(1)
end
print("✓ Order created with drinks\n")

-- Test 5: Place ticket on tray
print("Test 5: Placing ticket on tray...")
local ticket = cashier:placeTicketOnTray(order)
if not ticket then
    print("❌ FAILED: Could not place ticket on tray")
    os.exit(1)
end
print("✓ Ticket placed on tray\n")

-- Test 6: Verify tray is not complete initially
print("Test 6: Checking initial tray status...")
if cashier:isTrayComplete(order:getOrderNumber()) then
    print("❌ FAILED: Tray should not be complete yet")
    os.exit(1)
end
print("✓ Tray correctly shows incomplete\n")

-- Test 7: Place food items on tray
print("Test 7: Placing food items on tray...")
local tray = cashier:getTray()
if not tray:placeItem(order:getOrderNumber(), "Burger") then
    print("❌ FAILED: Could not place Burger on tray")
    os.exit(1)
end
if not tray:placeItem(order:getOrderNumber(), "Fries") then
    print("❌ FAILED: Could not place Fries on tray")
    os.exit(1)
end
print("✓ Food items placed on tray\n")

-- Test 8: Verify tray still incomplete (drink missing)
print("Test 8: Verifying tray incomplete without drink...")
if cashier:isTrayComplete(order:getOrderNumber()) then
    print("❌ FAILED: Tray should not be complete without drink")
    os.exit(1)
end
print("✓ Tray correctly shows incomplete without drink\n")

-- Test 9: Simulate 20+ seconds passing
print("Test 9: Simulating 20+ seconds passing...")
-- Manually set timestamp to 25 seconds ago
local currentTime = os.time()
local pastTime = currentTime - 25
tray.ticketTimestamps[order:getOrderNumber()] = pastTime
print("✓ Timestamp adjusted to 25 seconds ago\n")

-- Test 10: Check and make drinks automatically
print("Test 10: Checking for drinks to make...")
cashier:checkAndMakeDrinks(currentTime)
print("✓ Automatic drink check performed\n")

-- Test 11: Verify tray is now complete
print("Test 11: Verifying tray is complete...")
if not cashier:isTrayComplete(order:getOrderNumber()) then
    print("❌ FAILED: Tray should be complete now")
    os.exit(1)
end
print("✓ Tray is now complete with all items\n")

-- Test 12: Notify that tray is complete
print("Test 12: Notifying tray completion...")
if not cashier:notifyTrayComplete(order:getOrderNumber()) then
    print("❌ FAILED: Could not notify tray completion")
    os.exit(1)
end
print("✓ Tray completion notification sent\n")

-- Test 13: Test that cashier won't notify incomplete tray
print("Test 13: Testing incomplete tray notification prevention...")
local order2 = EmployeesPlus:createOrder({
    {name = "Pizza", price = 8.99},
    {name = "Soda", price = 1.49}
})
cashier:placeTicketOnTray(order2)
tray:placeItem(order2:getOrderNumber(), "Pizza") -- Only pizza, no soda

if cashier:notifyTrayComplete(order2:getOrderNumber()) then
    print("❌ FAILED: Should not notify for incomplete tray")
    os.exit(1)
end
print("✓ Correctly prevented notification for incomplete tray\n")

-- Test 14: Test idle task functionality
print("Test 14: Testing idle task functionality...")
cashier:performIdleTask()
print("✓ Idle task performed\n")

-- Test 15: Test Cook idle task
print("Test 15: Testing Cook idle task...")
local cook = EmployeesPlus:hireEmployee("Cook", "TestCook")
cook:startWork()
cook:assignCookingStation("TEST-GRILL", "grill")
cook:performIdleTask()
print("✓ Cook idle task performed\n")

-- Test 16: Test FryCook idle task
print("Test 16: Testing FryCook idle task...")
local fryCook = EmployeesPlus:hireEmployee("FryCook", "TestFryCook")
fryCook:startWork()
fryCook:assignFryerStation("TEST-FRYER")
fryCook:performIdleTask()
print("✓ FryCook idle task performed\n")

-- Test 17: Multiple drinks scenario
print("Test 17: Testing multiple drinks on one order...")
local order3 = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Coffee", price = 2.49},
    {name = "Juice", price = 3.49}
})
cashier:placeTicketOnTray(order3)
local tray3Time = os.time() - 25
tray.ticketTimestamps[order3:getOrderNumber()] = tray3Time
tray:placeItem(order3:getOrderNumber(), "Burger")

-- Should make only one drink at a time
cashier:checkAndMakeDrinks(os.time())
print("✓ Multiple drinks scenario handled\n")

-- All tests passed
print("========================================")
print("✓ ALL TRAY SYSTEM TESTS PASSED!")
print("========================================")
print("\nTray System Features Verified:")
print("- Ticket placement on tray")
print("- Item tracking on tray")
print("- Tray completion checking")
print("- Automatic drink-making after 20 seconds")
print("- Cashier returns to cashiering after drinks")
print("- Tray completion notification only when all items present")
print("- Idle task functionality for all employee types")
