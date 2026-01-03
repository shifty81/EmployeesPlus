-- FryCook.lua
-- Employee specialized in frying food items (fries, chicken, etc.)

local Employee = require("employees.Employee")

local FryCook = setmetatable({}, {__index = Employee})
FryCook.__index = FryCook

-- Create a new Fry Cook
function FryCook.new(name)
    local self = setmetatable(Employee.new(name, "Fry Cook"), FryCook)
    self.fryerStations = {}
    self.cookingItems = {}
    return self
end

-- Assign fryer station to cook
function FryCook:assignFryerStation(stationId)
    table.insert(self.fryerStations, stationId)
    print(string.format("%s assigned to fryer station %s", self.name, stationId))
end

-- Start frying an item
function FryCook:startFrying(item, orderNumber)
    if not self.isWorking then
        print(string.format("Error: %s is not working", self.name))
        return false
    end
    
    local cookingItem = {
        item = item,
        orderNumber = orderNumber,
        -- Note: os.time() is used as a default. Replace with game-specific timing API if available
        startTime = os.time(),
        cookTime = item.cookTime or 120, -- default 2 minutes
        status = "frying"
    }
    
    table.insert(self.cookingItems, cookingItem)
    self.currentTask = string.format("Frying %s for Order #%d", item.name, orderNumber)
    
    print(string.format("%s started frying %s for Order #%d", 
        self.name, item.name, orderNumber))
    
    return true
end

-- Check if item is done cooking
function FryCook:checkCookingStatus(itemIndex)
    local cookingItem = self.cookingItems[itemIndex]
    if not cookingItem then return nil end
    
    -- Note: For game integration, replace os.time() with game timing system
    local elapsedTime = os.time() - cookingItem.startTime
    if elapsedTime >= cookingItem.cookTime then
        cookingItem.status = "done"
        return "done"
    end
    
    return "frying"
end

-- Retrieve finished item
function FryCook:retrieveFinishedItem(itemIndex)
    local cookingItem = self.cookingItems[itemIndex]
    if not cookingItem then return nil end
    
    if cookingItem.status == "done" then
        local finishedItem = cookingItem.item
        finishedItem.orderNumber = cookingItem.orderNumber
        table.remove(self.cookingItems, itemIndex)
        
        print(string.format("%s finished frying %s for Order #%d", 
            self.name, finishedItem.name, cookingItem.orderNumber))
        
        if #self.cookingItems == 0 then
            self.currentTask = nil
        end
        
        return finishedItem
    end
    
    print(string.format("Item is not done yet (status: %s)", cookingItem.status))
    return nil
end

-- Get all cooking items
function FryCook:getCookingItems()
    return self.cookingItems
end

-- Get number of items being cooked
function FryCook:getActiveItemCount()
    return #self.cookingItems
end

-- Perform idle tasks when not actively frying
function FryCook:performIdleTask()
    if not self.isWorking then
        return
    end
    
    -- Clean fryer and prep baskets
    if #self.cookingItems == 0 then
        self.currentTask = "Cleaning fryer and prepping baskets"
        print(string.format("%s is cleaning the fryer and prepping baskets", self.name))
    else
        -- Check on items being fried
        self.currentTask = "Monitoring fryer"
    end
end

return FryCook
