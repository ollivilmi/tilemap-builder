Dequeue = Class{}

function Dequeue:init()
    self.head = 1
    self.tail = 0
    self.items = {}
end

function Dequeue:push(value)
    self.tail = self.tail + 1

    self.items[self.tail] = value
end

function Dequeue:pushFirst(value)
    self.head = self.head - 1

    self.items[self.head] = value
end
  
function Dequeue:pop()
    if self:isEmpty() then error("list is empty") end

    local value = self.items[self.head]

    self.items[self.head] = nil
    self.head = self.head + 1

    return value
end

function Dequeue:popLast()
    if self:isEmpty() then error("list is empty") end

    local value = self.items[self.tail]

    self.items[self.tail] = nil
    self.tail = self.tail - 1

    return value
end

function Dequeue:peek()
    if self:isEmpty() then return nil end

    return self.items[self.head]
end

function Dequeue:peekLast()
    if self:isEmpty() then return nil end

    return self.items[self.tail]
end

function Dequeue:length()
    return (self.tail + 1) - self.head
end

function Dequeue:isEmpty()
    return self.head > self.tail
end