-- test_mod.lua
-- Simple test to verify mod functionality

print("========================================")
print("EmployeesPlus Mod Test Suite")
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

-- Test 3: Hire employees
print("Test 3: Hiring employees...")
local fryCook = EmployeesPlus:hireEmployee("FryCook", "TestFryCook")
local cook = EmployeesPlus:hireEmployee("Cook", "TestCook")
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "TestCashier")

if not fryCook or not cook or not cashier then
    print("❌ FAILED: Could not hire employees")
    os.exit(1)
end
print("✓ Employees hired successfully\n")

-- Test 4: Start employees
print("Test 4: Starting employees...")
fryCook:startWork()
cook:startWork()
cashier:startWork()

if not fryCook:getIsWorking() or not cook:getIsWorking() or not cashier:getIsWorking() then
    print("❌ FAILED: Employees not working")
    os.exit(1)
end
print("✓ Employees started working\n")

-- Test 5: Assign stations
print("Test 5: Assigning stations...")
fryCook:assignFryerStation("TEST-FRYER-1")
cook:assignCookingStation("TEST-GRILL-1", "grill")
cashier:assignWindow("TEST-WINDOW-1")
print("✓ Stations assigned\n")

-- Test 6: Create order
print("Test 6: Creating order...")
local order = EmployeesPlus:createOrder({
    {name = "Test Burger", price = 5.99},
    {name = "Test Fries", price = 2.99},
    {name = "Test Drink", price = 1.99}
})

if not order or not order:getOrderNumber() then
    print("❌ FAILED: Could not create order")
    os.exit(1)
end
print("✓ Order created: #" .. order:getOrderNumber() .. "\n")

-- Test 7: Cook prepares order
print("Test 7: Cook preparing order...")
if not cook:startPreparingOrder(order) then
    print("❌ FAILED: Could not start preparing order")
    os.exit(1)
end

cook:cookItem(1, "Test Burger")
cook:cookItem(1, "Test Fries")
cook:cookItem(1, "Test Drink")
local completedOrder = cook:completeOrder(1)

if not completedOrder then
    print("❌ FAILED: Could not complete order")
    os.exit(1)
end
print("✓ Order prepared and completed\n")

-- Test 8: Cashier handles to-go bag
print("Test 8: Cashier handling to-go bag...")
local bag = cashier:setupToGoBag(completedOrder)

if not bag then
    print("❌ FAILED: Could not setup to-go bag")
    os.exit(1)
end

if bag:getDisplayedOrderNumber() ~= completedOrder:getOrderNumber() then
    print("❌ FAILED: Order number not on bag")
    os.exit(1)
end

if not bag:getReceipt() then
    print("❌ FAILED: Receipt not attached to bag")
    os.exit(1)
end
print("✓ To-go bag setup with order number and receipt\n")

-- Test 9: Prepare and hand order
print("Test 9: Preparing and handing order...")
if not cashier:prepareBagForPickup(bag) then
    print("❌ FAILED: Could not prepare bag")
    os.exit(1)
end

if not cashier:handOrderToCustomer(1) then
    print("❌ FAILED: Could not hand order to customer")
    os.exit(1)
end
print("✓ Order handed to customer\n")

-- Test 10: Verify order completion
print("Test 10: Completing order in system...")
if not EmployeesPlus:completeOrder(completedOrder) then
    print("❌ FAILED: Could not complete order in system")
    os.exit(1)
end
print("✓ Order completed in system\n")

-- Test 11: Fry Cook functionality
print("Test 11: Testing Fry Cook...")
local order2 = EmployeesPlus:createOrder({
    {name = "Fried Item", price = 3.99}
})

if not fryCook:startFrying({name = "Fried Item", cookTime = 5}, order2:getOrderNumber()) then
    print("❌ FAILED: Could not start frying")
    os.exit(1)
end

if fryCook:getActiveItemCount() < 1 then
    print("❌ FAILED: Item not being fried")
    os.exit(1)
end
print("✓ Fry Cook working correctly\n")

-- Test 12: Print status
print("Test 12: Printing restaurant status...")
EmployeesPlus:printStatus()
print("✓ Status printed\n")

-- All tests passed
print("========================================")
print("✓ ALL TESTS PASSED!")
print("========================================")
print("\nMod is working correctly!")
print("- Fry Cook: Operational")
print("- Cook: Operational")
print("- Drive Thru Cashier: Operational")
print("- Order System: Operational")
print("- To-Go Bag System: Operational")
print("- Receipt System: Operational")
