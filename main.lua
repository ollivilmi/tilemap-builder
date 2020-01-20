Class = require 'lib/class'
Gui = require 'lib/Gspot'
Json = require 'lib/json'
Lzw = require 'lib/lzw'
tilemath = require 'lib/tilemath'

require 'lib/coordinates'
require 'lib/Dequeue'
require 'lib/geometry'
require 'lib/tilemath'
require 'lib/Listener'

require 'src/LevelBuilder'

local Builder

local function clearInput()
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    love.mouse.buttonsReleased = {}
    love.mouse.wheelmoved = 0
end

function love.load()
    love.filesystem.setIdentity('level-builder')
    love.window.setTitle('level builder')
    love.window.setMode(1280, 720, {fullscreen = false})
    clearInput()

    Builder = LevelBuilder()
end

function love.update(dt)
    Gui:update(dt)
    Builder:update(dt)
    clearInput()
end

function love.draw()
    Builder:render()
    Gui:draw()
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
    Gui:mousepress(x, y, button)
end

function love.mousereleased(x, y, button)
    love.mouse.buttonsReleased[button] = true
    Gui:mouserelease(x, y, button)
end

function love.wheelmoved(x, y)
    love.mouse.wheelmoved = y
    Gui:mousewheel(x, y, button)
end

function love.keypressed(key, code)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        Builder.level.tilemap:save()
        love.event.quit()
    end
    if Gui.focus then
        Gui:keypress(key, code)
    end
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.mouse.wasReleased(button)
    return love.mouse.buttonsReleased[button]
end