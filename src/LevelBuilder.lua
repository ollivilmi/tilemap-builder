require 'src/Level'
require 'src/Rendering'
require 'src/Camera'
require 'src/Cursor'

LevelBuilder = Class{}

local bump = require 'lib/bump'

function LevelBuilder:init()
    self.level = Level(bump.newWorld(80))
    Camera = Camera(self.level.tileSize)
    self.cursor = Cursor(self.level.tilemap)
    self.rendering = Rendering(self)
end

function LevelBuilder:update(dt)
    self.cursor:update(dt)
    Camera:update(dt)
end

function LevelBuilder:render()
    Camera:set()
    self.rendering:render()
    Camera:unset()
end
