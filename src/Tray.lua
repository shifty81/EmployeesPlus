-- Tray.lua
-- Represents a tray for managing order tickets and items

local Tray = {}
Tray.__index = Tray

-- Create a new tray
function Tray.new()
    local self = setmetatable({}, Tray)
    self.tickets = {} -- List of order tickets on the tray
    self.items = {} -- Items placed on the tray
    self.ticketTimestamps = {} -- When each ticket was placed on the tray
    return self
end

-- Place a ticket on the tray
function Tray:placeTicket(order)
    if not order then
        print("Error: No order provided for ticket")
        return false
    end
    
    local ticket = {
        orderNumber = order:getOrderNumber(),
        order = order,
        itemsRequired = {},
        itemsOnTray = {},
        completed = false
    }
    
    -- Populate required items from order
    for _, item in ipairs(order:getItems()) do
        table.insert(ticket.itemsRequired, {
            name = item.name,
            quantity = item.quantity or 1,
            price = item.price
        })
    end
    
    table.insert(self.tickets, ticket)
    -- Record timestamp when ticket was placed
    self.ticketTimestamps[order:getOrderNumber()] = os.time()
    
    print(string.format("Ticket for Order #%d placed on tray", order:getOrderNumber()))
    return ticket
end

-- Place an item on the tray for a specific order
function Tray:placeItem(orderNumber, itemName)
    local ticket = self:getTicket(orderNumber)
    if not ticket then
        print(string.format("Error: No ticket found for Order #%d", orderNumber))
        return false
    end
    
    -- Check if item is required
    local itemRequired = false
    for _, reqItem in ipairs(ticket.itemsRequired) do
        if reqItem.name == itemName then
            itemRequired = true
            break
        end
    end
    
    if not itemRequired then
        print(string.format("Warning: %s is not required for Order #%d", itemName, orderNumber))
        return false
    end
    
    -- Add item to tray
    table.insert(ticket.itemsOnTray, itemName)
    
    -- Check if all items are now on tray
    if self:checkTrayComplete(orderNumber) then
        ticket.completed = true
        print(string.format("Tray for Order #%d is now complete!", orderNumber))
    else
        print(string.format("%s placed on tray for Order #%d", itemName, orderNumber))
    end
    
    return true
end

-- Check if all required items are on the tray
function Tray:checkTrayComplete(orderNumber)
    local ticket = self:getTicket(orderNumber)
    if not ticket then return false end
    
    -- Count required items vs items on tray
    local requiredCount = {}
    for _, item in ipairs(ticket.itemsRequired) do
        requiredCount[item.name] = (requiredCount[item.name] or 0) + item.quantity
    end
    
    local onTrayCount = {}
    for _, itemName in ipairs(ticket.itemsOnTray) do
        onTrayCount[itemName] = (onTrayCount[itemName] or 0) + 1
    end
    
    -- Check if all required items are present
    for itemName, required in pairs(requiredCount) do
        if (onTrayCount[itemName] or 0) < required then
            return false
        end
    end
    
    return true
end

-- Get ticket for a specific order
function Tray:getTicket(orderNumber)
    for _, ticket in ipairs(self.tickets) do
        if ticket.orderNumber == orderNumber then
            return ticket
        end
    end
    return nil
end

-- Get timestamp when ticket was placed
function Tray:getTicketTimestamp(orderNumber)
    return self.ticketTimestamps[orderNumber]
end

-- Get tickets that need drinks (placed >20 seconds ago and have drinks required)
function Tray:getTicketsNeedingDrinks(currentTime)
    local needsDrinks = {}
    
    for _, ticket in ipairs(self.tickets) do
        if not ticket.completed then
            local timestamp = self.ticketTimestamps[ticket.orderNumber]
            local elapsed = currentTime - timestamp
            
            if elapsed >= 20 then
                -- Check if drinks are required
                for _, item in ipairs(ticket.itemsRequired) do
                    local itemName = item.name:lower()
                    if itemName:find("drink") or itemName:find("soda") or 
                       itemName:find("beverage") or itemName:find("juice") or
                       itemName:find("water") or itemName:find("tea") or
                       itemName:find("coffee") then
                        
                        -- Check if drink is not already on tray
                        local drinkOnTray = false
                        for _, onTray in ipairs(ticket.itemsOnTray) do
                            if onTray == item.name then
                                drinkOnTray = true
                                break
                            end
                        end
                        
                        if not drinkOnTray then
                            table.insert(needsDrinks, {
                                orderNumber = ticket.orderNumber,
                                drinkName = item.name,
                                ticket = ticket
                            })
                            break -- Only one drink at a time per ticket
                        end
                    end
                end
            end
        end
    end
    
    return needsDrinks
end

-- Remove ticket from tray (when order is completed)
function Tray:removeTicket(orderNumber)
    for i, ticket in ipairs(self.tickets) do
        if ticket.orderNumber == orderNumber then
            table.remove(self.tickets, i)
            self.ticketTimestamps[orderNumber] = nil
            print(string.format("Ticket for Order #%d removed from tray", orderNumber))
            return true
        end
    end
    return false
end

-- Get all tickets on tray
function Tray:getTickets()
    return self.tickets
end

-- Get count of incomplete tickets
function Tray:getIncompleteTicketCount()
    local count = 0
    for _, ticket in ipairs(self.tickets) do
        if not ticket.completed then
            count = count + 1
        end
    end
    return count
end

-- Get count of complete tickets ready for pickup
function Tray:getCompleteTicketCount()
    local count = 0
    for _, ticket in ipairs(self.tickets) do
        if ticket.completed then
            count = count + 1
        end
    end
    return count
end

return Tray
