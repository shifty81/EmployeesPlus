-- ToGoBag.lua
-- Represents a to-go bag that holds an order with receipt attached

local ToGoBag = {}
ToGoBag.__index = ToGoBag

-- Create a new to-go bag
function ToGoBag.new(order)
    local self = setmetatable({}, ToGoBag)
    self.order = order
    self.orderNumber = order and order:getOrderNumber() or nil
    self.receipt = order and order.receipt or nil
    self.isPrepared = false
    self.handedToCustomer = false
    return self
end

-- Setup the bag with order contents
function ToGoBag:setupWithOrder(order)
    self.order = order
    self.orderNumber = order:getOrderNumber()
    self.receipt = order.receipt
    self.isPrepared = false
    self.handedToCustomer = false
    
    print(string.format("To-go bag prepared for Order #%d", self.orderNumber))
end

-- Add receipt to bag
function ToGoBag:attachReceipt()
    if self.order then
        self.receipt = self.order.receipt
        print(string.format("Receipt attached to bag for Order #%d", self.orderNumber))
        return true
    end
    return false
end

-- Mark bag as prepared and ready
function ToGoBag:markAsPrepared()
    if self.order and self.receipt then
        self.isPrepared = true
        print(string.format("Bag #%d is ready for pickup", self.orderNumber))
        return true
    end
    print("Error: Cannot mark bag as prepared without order and receipt")
    return false
end

-- Hand bag to customer
function ToGoBag:handToCustomer()
    if self.isPrepared and not self.handedToCustomer then
        self.handedToCustomer = true
        print(string.format("Order #%d handed to customer", self.orderNumber))
        return true
    end
    if not self.isPrepared then
        print(string.format("Error: Order #%d is not ready yet", self.orderNumber))
    end
    return false
end

-- Get order number displayed on bag
function ToGoBag:getDisplayedOrderNumber()
    return self.orderNumber
end

-- Get receipt information
function ToGoBag:getReceipt()
    return self.receipt
end

-- Check if bag is ready for customer
function ToGoBag:isReady()
    return self.isPrepared
end

-- Get bag status
function ToGoBag:getStatus()
    if self.handedToCustomer then
        return "delivered"
    elseif self.isPrepared then
        return "ready"
    elseif self.order then
        return "preparing"
    else
        return "empty"
    end
end

return ToGoBag
