require 'src/Level'
require 'src/Interface'
require 'src/Rendering'
require 'src/Camera'
require 'src/Cursor'

LevelBuilder = Class{__includes = Listener}

local bump = require 'lib/bump'

function LevelBuilder:init()
    Listener:init(self)

    self.level = Level(bump.newWorld(80))
    self.tiles = {}
    for k, __ in pairs(self.level.tilemap.types) do
        table.insert(self.tiles, k)
    end
    self.activeTile = 1

    self.interface = Interface(self)
    self.cursor = Cursor(self)
    self.rendering = Rendering(self)

    self.cursor:addListener('MOUSE RELEASED', function(mode, rectangle)
        if mode == 1 then
            self.level.tilemap:addRectangle(rectangle, self:getTile())
        else
            self.level.tilemap:removeRectangle(rectangle)
        end
    end)
end

function LevelBuilder:getTile()
    return self.tiles[self.activeTile]
end

function LevelBuilder:switchTile(dir)
    self.activeTile = self.activeTile + dir

    if self.activeTile < 1 then
        self.activeTile = #self.tiles
    elseif self.activeTile > #self.tiles then
        self.activeTile = 1
    end

    self:broadcastEvent("ACTIVE TILE", self:getTile())
end

function LevelBuilder:update(dt)
    if love.mouse.wheelmoved ~= 0 then
        self:switchTile(love.mouse.wheelmoved)
    end

    self.rendering:update(dt)
    self.cursor:update(dt)
end

function LevelBuilder:render()
    self.rendering:render()
end
