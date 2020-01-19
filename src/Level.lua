require 'src/Tilemap'
require 'src/Resources'

Level = Class{}

-- Contains level state, handled in chunks
-- -> tilemap, resources..
--
-- CHUNK
-- =====
-- Only send a chunk of the level state that is visible to the player
-- Chunk = (screen width * 2) * (screen height * 2)
-- ======
-- 
-- SCREEN
-- ======
-- Width / height is always the same, max zoom is scaled on client side
-- based on resolution
-- ======
function Level:init(world)
    self.world = world
    self.tileSize = (world.cellSize / 2^2)

    local zoom = 1.3

    self.screen = {
        w = tilemath.snap(self.tileSize, 1280 * zoom),
        h = tilemath.snap(self.tileSize, 720 * zoom)
    }

    self.chunk = {
        w = self.screen.w * 2, 
        h = self.screen.h * 2
    }

    self.tilemap = Tilemap(self)
    self.resources = Resources(self)
end

function Level:getEntityChunk(entity)
    local x, y = math.rectangleCenter(entity)

    local x = x - math.fmod(x, self.screen.w)
    local y = y - math.fmod(y, self.screen.h)

    return {
        x = x,
        y = y,
    }
end

function Level:getItems(chunk)
    return self.world:queryRect(chunk.x, chunk.y, self.chunk.w, self.chunk.h)
end

function Level:getChunk(chunk)
    return {
        tilemap = self.tilemap:getChunk(chunk),
        resources = self.resources:getChunk(chunk)
    }
end

function Level:setChunk(segment, snapshot)
    if segment == 'tilemap' then
        self.tilemap:setChunk(snapshot)
    elseif segment == 'resources' then
        self.resources:setResources(snapshot)
    end
end