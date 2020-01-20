Cursor = Class{__includes = Listener}

function Cursor:init(levelBuilder)
    self.tileSize = levelBuilder.level.tileSize

    Listener:init(self)
    -- tile mouse coords
    self.sx = 0
    self.sy = 0

    self.ex = 0
    self.ey = 0

    self.w = 2
    self.h = 2

    self.mode = 1

    self.cursors = {
        love.mouse.getSystemCursor('crosshair'),
        love.mouse.getSystemCursor('no')
    }
    love.mouse.setCursor(self.cursors[self.mode])
end

function Cursor:update(dt)
    if Gui.mousein then return end

    if love.mouse.wasReleased(1) then
        -- move rectangle starting coordinate if negative width or height
        local x = self.w < 0 and self.sx + self.w or self.sx
        local y = self.h < 0 and self.sy + self.h or self.sy

        -- use abs for width / height now that the starting coords have been sorted
        local rectangle = {x = x, y = y, w = math.abs(self.w), h = math.abs(self.h)}

        self:broadcastEvent('MOUSE RELEASED', self.mode, rectangle)

        self.w = 2
        self.h = 2
    end

    if love.mouse.isDown(1) then
        self.ex, self.ey = tilemath.snap(self.tileSize, Camera:worldCursor())
        self.w = self.ex - self.sx
        self.h = self.ey - self.sy
    else
        self.sx, self.sy = tilemath.snap(self.tileSize, Camera:worldCursor())
    end

    if love.mouse.wasPressed(1) then
        self.sx, self.sy = tilemath.snap(self.tileSize, Camera:worldCursor())    
    end

    if love.mouse.wasPressed(2) then
        self.mode = self.mode == 1 and 2 or 1
        love.mouse.setCursor(self.cursors[self.mode])
    end
end