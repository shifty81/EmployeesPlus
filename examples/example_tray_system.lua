-- example_tray_system.lua
-- Demonstration of the new tray system with automatic drink preparation

print("========================================")
print("EmployeesPlus Tray System Demo")
print("========================================\n")

-- Load and initialize
local EmployeesPlus = require("init")
EmployeesPlus:init()

print("\n--- Setting Up Restaurant ---")

-- Hire employees
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
local cook = EmployeesPlus:hireEmployee("Cook", "Mike")
local fryCook = EmployeesPlus:hireEmployee("FryCook", "Tony")

-- Start working
cashier:startWork()
cook:startWork()
fryCook:startWork()

-- Assign stations
cashier:assignWindow("WINDOW-1")
cook:assignCookingStation("GRILL-1", "grill")
fryCook:assignFryerStation("FRYER-1")

print("\n--- Customer Order Arrives ---")

-- Create order with food and drinks
local order1 = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Fries", price = 2.99},
    {name = "Drink", price = 1.99}
})

print("\n--- Cashier Places Ticket on Tray ---")
cashier:placeTicketOnTray(order1)

print("\n--- Cook Prepares Food ---")
cook:startPreparingOrder(order1)
cook:cookItem(1, "Burger")

print("\n--- Fry Cook Prepares Fries ---")
fryCook:startFrying({name = "Fries", cookTime = 5}, order1:getOrderNumber())

print("\n--- Items Added to Tray as Prepared ---")
local tray = cashier:getTray()
tray:placeItem(order1:getOrderNumber(), "Burger")
tray:placeItem(order1:getOrderNumber(), "Fries")

print("\n--- Check Tray Status ---")
if cashier:isTrayComplete(order1:getOrderNumber()) then
    print("✓ Tray is complete!")
else
    print("⏳ Tray is incomplete - drink still needed")
end

print("\n--- Simulate 20 Seconds Passing ---")
-- Adjust timestamp to simulate time passing
local currentTime = os.time()
tray.ticketTimestamps[order1:getOrderNumber()] = currentTime - 25

print("\n--- Cashier Checks for Drinks to Make ---")
cashier:checkAndMakeDrinks(currentTime)

print("\n--- Verify Tray is Now Complete ---")
if cashier:isTrayComplete(order1:getOrderNumber()) then
    print("✓ Tray is now complete with all items!")
    cashier:notifyTrayComplete(order1:getOrderNumber())
end

print("\n--- Second Order Arrives ---")
local order2 = EmployeesPlus:createOrder({
    {name = "Chicken Sandwich", price = 6.99},
    {name = "Coffee", price = 2.49},
    {name = "Juice", price = 3.49}
})

cashier:placeTicketOnTray(order2)

print("\n--- Cook Prepares Sandwich ---")
cook:completeOrder(1) -- Complete first order
cook:startPreparingOrder(order2)
cook:cookItem(1, "Chicken Sandwich")

print("\n--- Sandwich Added to Tray ---")
tray:placeItem(order2:getOrderNumber(), "Chicken Sandwich")

print("\n--- Check Second Tray Status ---")
if cashier:isTrayComplete(order2:getOrderNumber()) then
    print("✓ Tray is complete!")
else
    print("⏳ Tray incomplete - drinks still needed")
end

print("\n--- Simulate 20+ Seconds for Second Order ---")
tray.ticketTimestamps[order2:getOrderNumber()] = currentTime - 25

print("\n--- Cashier Makes One Drink at a Time ---")
cashier:checkAndMakeDrinks(currentTime)

print("\n--- Check Progress ---")
if cashier:isTrayComplete(order2:getOrderNumber()) then
    print("✓ All items on tray!")
else
    print("⏳ Still one more drink to make...")
    -- Make second drink
    cashier:makeDrink(order2:getOrderNumber(), "Juice")
end

print("\n--- Final Check ---")
if cashier:isTrayComplete(order2:getOrderNumber()) then
    print("✓ Tray is now complete!")
    cashier:notifyTrayComplete(order2:getOrderNumber())
end

print("\n--- Demonstrate Idle Tasks ---")
print("\n--- Employees Between Orders ---")
cashier:performIdleTask()
cook:performIdleTask()
fryCook:performIdleTask()

print("\n--- Restaurant Status ---")
EmployeesPlus:printStatus()

print("\n========================================")
print("Tray System Demo Complete!")
print("========================================")
print("\nKey Features Demonstrated:")
print("✓ Ticket placement on tray")
print("✓ Items tracked as they're added")
print("✓ Tray completion only when ALL items present")
print("✓ Automatic drink-making after 20 seconds")
print("✓ Cashier returns to cashiering after drinks")
print("✓ Idle tasks for all employee types")
print("\nNo more standing around - employees stay productive!")
