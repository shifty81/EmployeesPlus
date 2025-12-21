-- example_drive_thru.lua
-- Example demonstrating the drive-thru workflow with cashier

-- Load the mod
local EmployeesPlus = require("init")

-- Initialize
EmployeesPlus:init()

-- Hire drive-thru staff
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Sarah")
local cook = EmployeesPlus:hireEmployee("Cook", "Mike")
local fryCook = EmployeesPlus:hireEmployee("FryCook", "Tony")

-- Start working
cashier:startWork()
cook:startWork()
fryCook:startWork()

-- Assign stations
cashier:assignWindow("DRIVE-THRU-1")
cook:assignCookingStation("PREP-1", "prep_table")
fryCook:assignFryerStation("FRYER-1")

print("\n=== DRIVE-THRU SIMULATION ===\n")

-- Customer 1 arrives
print("Customer 1 arrives at drive-thru...")
local order1 = EmployeesPlus:createOrder({
    {name = "Chicken Sandwich", price = 6.99},
    {name = "Onion Rings", price = 3.99},
    {name = "Soda", price = 1.99}
})

-- Kitchen prepares order
cook:startPreparingOrder(order1)
fryCook:startFrying({name = "Onion Rings", cookTime = 90}, order1:getOrderNumber())

print("\n[Kitchen preparing Order #" .. order1:getOrderNumber() .. "...]")

-- Complete cooking
cook:cookItem(1, "Chicken Sandwich")
cook:cookItem(1, "Onion Rings")
cook:cookItem(1, "Soda")
local readyOrder1 = cook:completeOrder(1)

-- Cashier processes the order
print("\nCashier processing order at drive-thru window...")
if readyOrder1 then
    -- This demonstrates the complete workflow:
    -- 1. Setup to-go bag
    local bag = cashier:setupToGoBag(readyOrder1)
    
    -- 2. Attach receipt to bag (showing order number)
    bag:attachReceipt()
    
    -- 3. Prepare bag for pickup
    cashier:prepareBagForPickup(bag)
    
    -- 4. Hand to customer through window
    cashier:handOrderToCustomer(1)
    
    EmployeesPlus:completeOrder(readyOrder1)
end

-- Customer 2 arrives
print("\n\nCustomer 2 arrives at drive-thru...")
local order2 = EmployeesPlus:createOrder({
    {name = "Double Burger", price = 7.99},
    {name = "Large Fries", price = 3.49},
    {name = "Milkshake", price = 4.99}
})

-- Kitchen prepares order
cook:startPreparingOrder(order2)
cook:cookItem(1, "Double Burger")
cook:cookItem(1, "Large Fries")
cook:cookItem(1, "Milkshake")
local readyOrder2 = cook:completeOrder(1)

-- Cashier uses simplified process method
print("\nCashier using quick process method...")
if readyOrder2 then
    cashier:processOrder(readyOrder2)
    EmployeesPlus:completeOrder(readyOrder2)
end

-- Show cashier statistics
print("\n=== CASHIER STATISTICS ===")
print(string.format("Orders handed out: %d", cashier:getTotalHandedOrders()))
print(string.format("Orders ready: %d", cashier:getReadyOrderCount()))

-- Print overall status
EmployeesPlus:printStatus()

print("Drive-thru example completed!")
