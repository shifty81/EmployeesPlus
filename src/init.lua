-- init.lua
-- Main entry point for EmployeesPlus mod

-- Import core modules
local Order = require("Order")
local ToGoBag = require("ToGoBag")
local Employee = require("employees.Employee")
local FryCook = require("employees.FryCook")
local Cook = require("employees.Cook")
local DriveThruCashier = require("employees.DriveThruCashier")

-- EmployeesPlus Mod
local EmployeesPlus = {
    version = "1.0.0",
    name = "EmployeesPlus",
    employees = {},
    activeOrders = {},
    completedOrders = {}
}

-- Initialize the mod
function EmployeesPlus:init()
    print("========================================")
    print("EmployeesPlus Mod v" .. self.version)
    print("Fast Food Simulator Enhancement")
    print("========================================")
    print("Loaded employees:")
    print("  - Fry Cook: Specializes in frying items")
    print("  - Cook: General food preparation")
    print("  - Drive Thru Cashier: Handles orders at window")
    print("========================================")
end

-- Create a new order
function EmployeesPlus:createOrder(items)
    local order = Order.new(items)
    table.insert(self.activeOrders, order)
    print("\nNew order created: #" .. order:getOrderNumber())
    print(order:getReceiptString())
    return order
end

-- Hire a new employee
function EmployeesPlus:hireEmployee(employeeType, name)
    local employee
    
    if employeeType == "FryCook" then
        employee = FryCook.new(name)
    elseif employeeType == "Cook" then
        employee = Cook.new(name)
    elseif employeeType == "DriveThruCashier" then
        employee = DriveThruCashier.new(name)
    else
        employee = Employee.new(name, employeeType)
    end
    
    table.insert(self.employees, employee)
    print(string.format("\nHired: %s as %s", name, employeeType))
    return employee
end

-- Get employee by name
function EmployeesPlus:getEmployee(name)
    for _, employee in ipairs(self.employees) do
        if employee.name == name then
            return employee
        end
    end
    return nil
end

-- Complete an order
function EmployeesPlus:completeOrder(order)
    for i, activeOrder in ipairs(self.activeOrders) do
        if activeOrder:getOrderNumber() == order:getOrderNumber() then
            table.remove(self.activeOrders, i)
            table.insert(self.completedOrders, order)
            print(string.format("\nOrder #%d completed!", order:getOrderNumber()))
            return true
        end
    end
    return false
end

-- Get active orders
function EmployeesPlus:getActiveOrders()
    return self.activeOrders
end

-- Get all employees
function EmployeesPlus:getEmployees()
    return self.employees
end

-- Print status of all employees
function EmployeesPlus:printStatus()
    print("\n========== RESTAURANT STATUS ==========")
    print(string.format("Active Orders: %d", #self.activeOrders))
    print(string.format("Completed Orders: %d", #self.completedOrders))
    print(string.format("Employees: %d", #self.employees))
    print("\nEmployee Status:")
    for _, employee in ipairs(self.employees) do
        local status = employee:getIsWorking() and "Working" or "Idle"
        local task = employee:getCurrentTask() or "None"
        print(string.format("  - %s (%s): %s - Task: %s", 
            employee.name, employee.employeeType, status, task))
    end
    print("=======================================\n")
end

-- Export the module
return EmployeesPlus
