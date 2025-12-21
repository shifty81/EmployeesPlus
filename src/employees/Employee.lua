-- Employee.lua
-- Base class for all employee types

local Employee = {}
Employee.__index = Employee

-- Create a new employee
function Employee.new(name, employeeType)
    local self = setmetatable({}, Employee)
    self.name = name or "Employee"
    self.employeeType = employeeType or "Generic"
    self.isWorking = false
    self.currentTask = nil
    return self
end

-- Start working
function Employee:startWork()
    self.isWorking = true
    print(string.format("%s (%s) started working", self.name, self.employeeType))
end

-- Stop working
function Employee:stopWork()
    self.isWorking = false
    self.currentTask = nil
    print(string.format("%s (%s) stopped working", self.name, self.employeeType))
end

-- Check if employee is working
function Employee:getIsWorking()
    return self.isWorking
end

-- Get current task
function Employee:getCurrentTask()
    return self.currentTask
end

-- Set current task
function Employee:setCurrentTask(task)
    self.currentTask = task
end

return Employee
