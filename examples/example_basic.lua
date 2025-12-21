-- example_basic.lua
-- Basic example showing how to use the EmployeesPlus mod

-- Load the mod
local EmployeesPlus = require("init")

-- Initialize the mod
EmployeesPlus:init()

-- Hire employees
local fryCook = EmployeesPlus:hireEmployee("FryCook", "Bob")
local cook = EmployeesPlus:hireEmployee("Cook", "Alice")
local cashier = EmployeesPlus:hireEmployee("DriveThruCashier", "Charlie")

-- Start employees working
fryCook:startWork()
cook:startWork()
cashier:startWork()

-- Assign stations
fryCook:assignFryerStation("FRYER-1")
cook:assignCookingStation("GRILL-1", "grill")
cashier:assignWindow("WINDOW-1")

-- Create a customer order
local order = EmployeesPlus:createOrder({
    {name = "Burger", price = 5.99},
    {name = "Fries", price = 2.99},
    {name = "Drink", price = 1.99, quantity = 2}
})

-- Cook prepares the order
cook:startPreparingOrder(order)
cook:cookItem(1, "Burger")

-- Fry cook makes the fries
fryCook:startFrying({name = "Fries", cookTime = 120}, order:getOrderNumber())

-- Simulate cooking time
print("\n[Simulating cooking time...]")

-- Complete items
cook:cookItem(1, "Fries")
cook:cookItem(1, "Drink")
local completedOrder = cook:completeOrder(1)

-- Cashier handles the order
if completedOrder then
    -- Setup to-go bag with order number and receipt
    local bag = cashier:setupToGoBag(completedOrder)
    
    -- Prepare bag for customer
    cashier:prepareBagForPickup(bag)
    
    -- Hand order to customer through drive-thru window
    cashier:handOrderToCustomer(1)
    
    -- Mark order as complete
    EmployeesPlus:completeOrder(completedOrder)
end

-- Print final status
EmployeesPlus:printStatus()

print("\nExample completed successfully!")
