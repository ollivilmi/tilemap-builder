Cursor = Class{}

function Cursor:init(tilemap)
    self.tilemap = tilemap

    -- tile mouse coords
    self.sx = 0
    self.sy = 0

    self.ex = 0
    self.ey = 0

    self.w = 2
    self.h = 2

    local tileTypes = require 'src/TileTypes'
    self.tiles = {}

    for k, __ in pairs(tileTypes) do
        table.insert(self.tiles, k)
    end

    self.selected = 1
    self.mode = 1

    self.cursors = {
        love.mouse.getSystemCursor('crosshair'),
        love.mouse.getSystemCursor('no')
    }
    love.mouse.setCursor(self.cursors[self.mode])
end

function Cursor:switchTile(dir)
    self.selected = self.selected + dir

    if self.selected < 1 then
        self.selected = #self.tiles
    elseif self.selected > #self.tiles then
        self.selected = 1
    end
end

function Cursor:update(dt)
    if love.mouse.wheelmoved ~= 0 then
        self:switchTile(love.mouse.wheelmoved)
    end

    if love.mouse.wasPressed(1) then
        self.sx, self.sy = tilemath.snap(self.tilemap.tileSize, Camera:worldCursor())    
    end

    if love.mouse.wasPressed(2) then
        self.mode = self.mode == 1 and 2 or 1
        love.mouse.setCursor(self.cursors[self.mode])
    end

    if love.mouse.wasReleased(1) then
        -- move rectangle starting coordinate if negative width or height
        local x = self.w < 0 and self.sx + self.w or self.sx
        local y = self.h < 0 and self.sy + self.h or self.sy

        -- use abs for width / height now that the starting coords have been sorted
        local rectangle = {x = x, y = y, w = math.abs(self.w), h = math.abs(self.h)}

        if self.mode == 1 then
            self.tilemap:addRectangle(rectangle, self.tiles[self.selected])
        else
            self.tilemap:removeRectangle(rectangle)
        end

        self.w = 2
        self.h = 2
    end

    if love.mouse.isDown(1) then
        self.ex, self.ey = tilemath.snap(self.tilemap.tileSize, Camera:worldCursor())
        self.w = self.ex - self.sx
        self.h = self.ey - self.sy
    else
        self.sx, self.sy = tilemath.snap(self.tilemap.tileSize, Camera:worldCursor())
    end
end