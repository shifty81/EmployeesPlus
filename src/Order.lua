-- Order.lua
-- Represents a customer order with order number and receipt

local Order = {}
Order.__index = Order

-- Order counter for generating unique order numbers
local orderCounter = 1000

-- Create a new order
function Order.new(items)
    local self = setmetatable({}, Order)
    self.orderNumber = orderCounter
    orderCounter = orderCounter + 1
    self.items = items or {}
    -- Note: os.time() is used as a default. Replace with game-specific timing API if available
    self.timestamp = os.time()
    self.status = "pending" -- pending, preparing, ready, completed
    self.receipt = self:generateReceipt()
    return self
end

-- Generate a receipt for the order
function Order:generateReceipt()
    local receipt = {
        orderNumber = self.orderNumber,
        items = {},
        timestamp = self.timestamp,
        total = 0
    }
    
    for _, item in ipairs(self.items) do
        table.insert(receipt.items, {
            name = item.name,
            quantity = item.quantity or 1,
            price = item.price or 0
        })
        receipt.total = receipt.total + (item.price or 0) * (item.quantity or 1)
    end
    
    return receipt
end

-- Get formatted receipt string
function Order:getReceiptString()
    local str = string.format("ORDER #%d\n", self.orderNumber)
    str = str .. string.format("Time: %s\n", os.date("%H:%M:%S", self.timestamp))
    str = str .. "-------------------\n"
    
    for _, item in ipairs(self.receipt.items) do
        str = str .. string.format("%dx %s - $%.2f\n", 
            item.quantity, item.name, item.price * item.quantity)
    end
    
    str = str .. "-------------------\n"
    str = str .. string.format("TOTAL: $%.2f\n", self.receipt.total)
    
    return str
end

-- Update order status
function Order:setStatus(newStatus)
    self.status = newStatus
end

-- Get order status
function Order:getStatus()
    return self.status
end

-- Get order number
function Order:getOrderNumber()
    return self.orderNumber
end

-- Get items in order
function Order:getItems()
    return self.items
end

return Order
