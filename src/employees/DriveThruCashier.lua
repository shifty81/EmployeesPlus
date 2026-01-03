-- DriveThruCashier.lua
-- Employee who handles drive-thru window and hands orders to customers

local Employee = require("employees.Employee")
local ToGoBag = require("ToGoBag")
local Tray = require("Tray")

local DriveThruCashier = setmetatable({}, {__index = Employee})
DriveThruCashier.__index = DriveThruCashier

-- Create a new Drive Thru Cashier
function DriveThruCashier.new(name)
    local self = setmetatable(Employee.new(name, "Drive Thru Cashier"), DriveThruCashier)
    self.windowId = nil
    self.readyBags = {}
    self.handedOrders = {}
    self.tray = Tray.new()
    self.drinksInProgress = {} -- Track which drinks are being made
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
        -- Note: os.time() is used as a default. Replace with game-specific timing API if available
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

-- Place a ticket on the tray for an order
function DriveThruCashier:placeTicketOnTray(order)
    if not self.isWorking then
        print(string.format("Error: %s is not working", self.name))
        return false
    end
    
    local ticket = self.tray:placeTicket(order)
    if ticket then
        self.currentTask = string.format("Managing tickets on tray")
        return ticket
    end
    return false
end

-- Check and make drinks for orders that have been waiting 20+ seconds
function DriveThruCashier:checkAndMakeDrinks(currentTime)
    if not self.isWorking then
        return
    end
    
    currentTime = currentTime or os.time()
    local ticketsNeedingDrinks = self.tray:getTicketsNeedingDrinks(currentTime)
    
    for _, drinkInfo in ipairs(ticketsNeedingDrinks) do
        -- Check if we're not already making this drink
        local alreadyMaking = false
        for _, inProgress in ipairs(self.drinksInProgress) do
            if inProgress.orderNumber == drinkInfo.orderNumber and 
               inProgress.drinkName == drinkInfo.drinkName then
                alreadyMaking = true
                break
            end
        end
        
        if not alreadyMaking then
            self:makeDrink(drinkInfo.orderNumber, drinkInfo.drinkName)
        end
    end
end

-- Make a drink and place it on the tray
function DriveThruCashier:makeDrink(orderNumber, drinkName)
    if not self.isWorking then
        print(string.format("Error: %s is not working", self.name))
        return false
    end
    
    -- Mark drink as in progress
    table.insert(self.drinksInProgress, {
        orderNumber = orderNumber,
        drinkName = drinkName,
        startTime = os.time()
    })
    
    self.currentTask = string.format("Making %s for Order #%d", drinkName, orderNumber)
    print(string.format("%s is making %s for Order #%d", self.name, drinkName, orderNumber))
    
    -- Simulate making the drink (in real game, this would take time)
    -- After drink is made, place it on tray
    self.tray:placeItem(orderNumber, drinkName)
    
    -- Remove from in-progress
    for i, inProgress in ipairs(self.drinksInProgress) do
        if inProgress.orderNumber == orderNumber and inProgress.drinkName == drinkName then
            table.remove(self.drinksInProgress, i)
            break
        end
    end
    
    -- Return to cashiering if no more drinks to make
    if #self.drinksInProgress == 0 then
        self.currentTask = nil
        print(string.format("%s returned to cashiering", self.name))
    end
    
    return true
end

-- Check if tray is complete for a specific order
function DriveThruCashier:isTrayComplete(orderNumber)
    return self.tray:checkTrayComplete(orderNumber)
end

-- Notify other employees that tray is complete (only when all items are on tray)
function DriveThruCashier:notifyTrayComplete(orderNumber)
    if not self.tray:checkTrayComplete(orderNumber) then
        print(string.format("Tray for Order #%d is not complete yet", orderNumber))
        return false
    end
    
    print(string.format("%s: Tray for Order #%d is complete and ready!", self.name, orderNumber))
    return true
end

-- Get the tray
function DriveThruCashier:getTray()
    return self.tray
end

-- Process idle tasks (check for drinks to make)
function DriveThruCashier:performIdleTask()
    if not self.isWorking then
        return
    end
    
    -- When idle, check if any drinks need to be made
    self:checkAndMakeDrinks()
    
    -- If still idle after checking drinks, update task status
    if not self.currentTask and self.tray:getIncompleteTicketCount() > 0 then
        self.currentTask = "Monitoring tray for drink orders"
    end
end

return DriveThruCashier
