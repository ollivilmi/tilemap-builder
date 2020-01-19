Camera = Class{}

local DEFAULT_RES = 720

function Camera:init(increment)
    self.increment = increment
    self.x = 0
    self.y = 0

    self.zoom = 1
end

function Camera:update(dt)
    if love.keyboard.isDown('right') then
        self:move(self.x + self.increment, self.y)
    elseif love.keyboard.isDown('left') then
        self:move(self.x - self.increment, self.y)
    end

    if love.keyboard.isDown('up') then
        self:move(self.x, self.y - self.increment)
    elseif love.keyboard.isDown('down') then
        self:move(self.x, self.y + self.increment)
    end
end

function Camera:setZoom(zoom)
    self.zoom = zoom
end

function Camera:move(x, y)
    self.x = math.max(0, x)
    self.y = math.max(0, y)
end

function Camera:set()
    love.graphics.push()
    love.graphics.scale(1 / self.zoom, 1 / self.zoom)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:worldCoordinates(x, y)
    return x * self.zoom + self.x, y * self.zoom + self.y
end

function Camera:worldCursor()
    return self:worldCoordinates(love.mouse.getX(), love.mouse.getY())
end

function Camera:worldToUi(x, y)
    return (x - self.x) / self.zoom , (y - self.y) / self.zoom 
end
