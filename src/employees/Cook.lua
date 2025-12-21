-- Cook.lua
-- General cook employee for preparing various food items

local Employee = require("employees.Employee")

local Cook = setmetatable({}, {__index = Employee})
Cook.__index = Cook

-- Create a new Cook
function Cook.new(name)
    local self = setmetatable(Employee.new(name, "Cook"), Cook)
    self.cookingStations = {}
    self.preparingOrders = {}
    return self
end

-- Assign cooking station
function Cook:assignCookingStation(stationId, stationType)
    table.insert(self.cookingStations, {
        id = stationId,
        type = stationType -- grill, oven, prep_table, etc.
    })
    print(string.format("%s assigned to %s station %s", 
        self.name, stationType, stationId))
end

-- Start preparing an order
function Cook:startPreparingOrder(order)
    if not self.isWorking then
        print(string.format("Error: %s is not working", self.name))
        return false
    end
    
    local preparingOrder = {
        order = order,
        orderNumber = order:getOrderNumber(),
        -- Note: os.time() is used as a default. Replace with game-specific timing API if available
        startTime = os.time(),
        itemsCompleted = {},
        status = "preparing"
    }
    
    table.insert(self.preparingOrders, preparingOrder)
    self.currentTask = string.format("Preparing Order #%d", order:getOrderNumber())
    order:setStatus("preparing")
    
    print(string.format("%s started preparing Order #%d with %d items", 
        self.name, order:getOrderNumber(), #order:getItems()))
    
    return true
end

-- Cook a specific item from the order
function Cook:cookItem(orderIndex, itemName)
    local preparingOrder = self.preparingOrders[orderIndex]
    if not preparingOrder then
        print("Error: Order not found")
        return false
    end
    
    -- Check if item exists in the order
    local found = false
    for _, item in ipairs(preparingOrder.order:getItems()) do
        if item.name == itemName then
            found = true
            break
        end
    end
    
    if not found then
        print(string.format("Error: Item %s not in order", itemName))
        return false
    end
    
    -- Add to completed items
    table.insert(preparingOrder.itemsCompleted, {
        name = itemName,
        completedTime = os.time()
    })
    
    print(string.format("%s cooked %s for Order #%d", 
        self.name, itemName, preparingOrder.orderNumber))
    
    -- Check if all items are completed
    if #preparingOrder.itemsCompleted >= #preparingOrder.order:getItems() then
        preparingOrder.status = "ready"
        preparingOrder.order:setStatus("ready")
        print(string.format("Order #%d is ready!", preparingOrder.orderNumber))
    end
    
    return true
end

-- Complete order and return it
function Cook:completeOrder(orderIndex)
    local preparingOrder = self.preparingOrders[orderIndex]
    if not preparingOrder then return nil end
    
    if preparingOrder.status ~= "ready" then
        print(string.format("Error: Order #%d is not ready yet (%d/%d items)", 
            preparingOrder.orderNumber,
            #preparingOrder.itemsCompleted,
            #preparingOrder.order:getItems()))
        return nil
    end
    
    local completedOrder = preparingOrder.order
    completedOrder:setStatus("completed")
    table.remove(self.preparingOrders, orderIndex)
    
    print(string.format("%s completed Order #%d", 
        self.name, completedOrder:getOrderNumber()))
    
    if #self.preparingOrders == 0 then
        self.currentTask = nil
    end
    
    return completedOrder
end

-- Get all orders being prepared
function Cook:getPreparingOrders()
    return self.preparingOrders
end

-- Get number of active orders
function Cook:getActiveOrderCount()
    return #self.preparingOrders
end

return Cook
