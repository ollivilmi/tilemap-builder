Class = require 'lib/class'
Gui = require 'lib/Gspot'
Json = require 'lib/json'
tilemath = require 'lib/tilemath'

require 'lib/coordinates'
require 'lib/Dequeue'
require 'lib/geometry'
require 'lib/tilemath'

require 'src/LevelBuilder'

local Builder

function love.load()
    love.filesystem.setIdentity('level-builder')
    love.window.setTitle('level builder')

    love.window.setMode(1280, 720, {fullscreen = false})
    Builder = LevelBuilder()
end

function love.update(dt)
    Builder:update(dt)
end

function love.mousepressed(x, y, button)
    Builder:mouse(x, y, button)
end

function love.wheelmoved(x, y)
    Builder:scroll(y)
end

function love.keypressed(key, code)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    Builder:render()
end