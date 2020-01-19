require 'src/Level'
require 'src/Rendering'

LevelBuilder = Class{}

local bump = require 'lib/bump'

function LevelBuilder:init()
    self.level = Level(bump.newWorld(80))
    self.rendering = Rendering(self)

    -- tile mouse coords
    self.x = 0
    self.y = 0

    local tileTypes = require 'src/TileTypes'
    self.tiles = {}

    for k, __ in pairs(tileTypes) do
        table.insert(self.tiles, k)
    end

    self.selected = 1
end

function LevelBuilder:mouse(x, y, button)
    local rectangle = {x = self.x, y = self.y, w = self.level.tileSize, h = self.level.tileSize}

    if button == 1 then
        self.level.tilemap:addRectangle(rectangle, self.tiles[self.selected])
    else
        self.level.tilemap:removeRectangle(rectangle)
    end
end

function LevelBuilder:scroll(dir)
    self.selected = self.selected + dir

    if self.selected < 1 then
        self.selected = #self.tiles
    elseif self.selected > #self.tiles then
        self.selected = 1
    end
end

function LevelBuilder:update(dt)
    self.x, self.y = tilemath.snap(self.level.tileSize, love.mouse.getX(), love.mouse.getY())
end

function LevelBuilder:render()
    self.rendering:render()
end
