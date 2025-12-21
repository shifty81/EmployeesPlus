-- DriveThruCashier.lua
-- Employee who handles drive-thru window and hands orders to customers

local Employee = require("employees.Employee")
local ToGoBag = require("ToGoBag")

local DriveThruCashier = setmetatable({}, {__index = Employee})
DriveThruCashier.__index = DriveThruCashier

-- Create a new Drive Thru Cashier
function DriveThruCashier.new(name)
    local self = setmetatable(Employee.new(name, "Drive Thru Cashier"), DriveThruCashier)
    self.windowId = nil
    self.readyBags = {}
    self.handedOrders = {}
    return self
end

-- Assign drive-thru window
function DriveThruCashier:assignWindow(windowId)
    self.windowId = windowId
    print(string.format("%s assigned to drive-thru window %s", self.name, windowId))
end

-- Setup a to-go bag for an order
function DriveThruCashier:setupToGoBag(order)
    if not self.isWorking then
        print(string.format("Error: %s is not working", self.name))
        return nil
    end
    
    -- Create new to-go bag
    local bag = ToGoBag.new(order)
    bag:setupWithOrder(order)
    bag:attachReceipt()
    
    print(string.format("%s setup to-go bag for Order #%d (referencing order number and receipt)", 
        self.name, order:getOrderNumber()))
    
    return bag
end

-- Prepare bag for customer pickup
function DriveThruCashier:prepareBagForPickup(bag)
    if not bag then
        print("Error: No bag provided")
        return false
    end
    
    if bag:markAsPrepared() then
        table.insert(self.readyBags, bag)
        self.currentTask = string.format("Ready to hand Order #%d", bag:getDisplayedOrderNumber())
        
        print(string.format("%s has Order #%d ready at the window", 
            self.name, bag:getDisplayedOrderNumber()))
        return true
    end
    
    return false
end

-- Hand order to customer through drive-thru window
function DriveThruCashier:handOrderToCustomer(bagIndex)
    if not self.windowId then
        print(string.format("Error: %s not assigned to a window", self.name))
        return false
    end
    
    local bag = self.readyBags[bagIndex]
    if not bag then
        print("Error: Bag not found")
        return false
    end
    
    if bag:handToCustomer() then
        -- Record the handed order
        table.insert(self.handedOrders, {
            orderNumber = bag:getDisplayedOrderNumber(),
            timestamp = os.time(),
            receipt = bag:getReceipt()
        })
        
        table.remove(self.readyBags, bagIndex)
        
        print(string.format("%s handed Order #%d to customer through window %s", 
            self.name, bag:getDisplayedOrderNumber(), self.windowId))
        
        if #self.readyBags == 0 then
            self.currentTask = nil
        end
        
        return true
    end
    
    return false
end

-- Complete workflow: setup bag, prepare it, and hand to customer
function DriveThruCashier:processOrder(order)
    -- Setup to-go bag
    local bag = self:setupToGoBag(order)
    if not bag then return false end
    
    -- Prepare for pickup
    if not self:prepareBagForPickup(bag) then return false end
    
    -- Hand to customer
    return self:handOrderToCustomer(#self.readyBags)
end

-- Get all ready bags
function DriveThruCashier:getReadyBags()
    return self.readyBags
end

-- Get handed orders history
function DriveThruCashier:getHandedOrders()
    return self.handedOrders
end

-- Get number of orders ready to hand out
function DriveThruCashier:getReadyOrderCount()
    return #self.readyBags
end

-- Get total orders handed out
function DriveThruCashier:getTotalHandedOrders()
    return #self.handedOrders
end

return DriveThruCashier
