require 'src/Tile'

Tilemap = Class{}

function Tilemap:init(level)
    self.tileSize = level.tileSize
    self.world = level.world
    self.chunk = level.chunk

    self.types = require 'src/TileTypes'

    self.fileName = "tilemap"
    self:load()
end

function Tilemap:save()
    local tiles = {}
    for __, item in pairs(self.world:getItems()) do
        if item.isTile then
            table.insert(tiles, {id = item.type.id, x = item.x, y = item.y})
        end
    end

    love.filesystem.write(self.fileName, Lzw.compress(Json.encode(tiles)))

    -- love.filesystem.write(self.tilemap, Lzw.compress(Json.encode(tiles)))
end

function Tilemap:load()
    local tiles = {}

    if love.filesystem.getInfo(self.fileName) then
        -- tiles = Json.decode(Lzw.decompress(love.filesystem.read(self.fileName)))
        tiles = Json.decode(Lzw.decompress(love.filesystem.read(self.fileName)))
    else
        return
    end

    for __, tile in pairs(tiles) do
        self:setTile(tile.x, tile.y, tile.id)
    end
end

function Tilemap:addRectangle(rectangle, id)
    local id = id or 'r'

    sx = tilemath.snap(self.tileSize, rectangle.x)
    sy = tilemath.snap(self.tileSize, rectangle.y)

    local ex = tilemath.snap(self.tileSize, sx + rectangle.w) - 1
    local ey = tilemath.snap(self.tileSize, sy + rectangle.h) - 1

    for x = sx, ex, self.tileSize do
        for y = sy, ey, self.tileSize do
            self:setTile(x, y, id)
        end
    end
end

function Tilemap:removeRectangle(rectangle)
    sx = tilemath.snap(self.tileSize, rectangle.x)
    sy = tilemath.snap(self.tileSize, rectangle.y)

    local ex = tilemath.snap(self.tileSize, sx + rectangle.w) - 1
    local ey = tilemath.snap(self.tileSize, sy + rectangle.h) - 1

    for x = sx, ex, self.tileSize do
        for y = sy, ey, self.tileSize do
            self:removeIfExists(x, y, id)
        end
    end
end

function Tilemap:getTile(x, y)
    local items, len = self.world:queryRect(x, y, self.tileSize, self.tileSize,
    function(item)
        return item.isTile
    end)

    return items[1]
end

function Tilemap:removeTile(tile)
    self.world:remove(tile)
end

function Tilemap:removeIfExists(x, y)
    local tile = self:getTile(x, y)
    if tile then
        self:removeTile(tile)
    end
end

function Tilemap:setTile(x, y, id)
    if id ~= 0 and type(id) == 'string' then
        self:removeIfExists(x, y)

        self.world:add(Tile(x, y, self.types[id]), 
            x,
            y,
            self.tileSize,
            self.tileSize
        )
    end
end

-- World coordinates -> table coordinates (eg. tileSize 20 -> 20,20 -> 2,2)
function Tilemap:toTableCoordinates(x, y)
    return (x / self.tileSize) + 1, (y / self.tileSize) + 1
end

-- Compressed format for sending
function Tilemap:getChunk(chunk)
    local chunk = {
        x = chunk.x,
        y = chunk.y,
        tiles = {}
    }

    for y = 1, self.chunk.h / self.tileSize do
        chunk.tiles[y] = {}
        for x = 1, self.chunk.w / self.tileSize do
            chunk.tiles[y][x] = 0
        end
    end

    local tiles, len = self.world:queryRect(
        chunk.x, chunk.y, self.chunk.w, self.chunk.h, function(item)
            return item.isTile
        end
    )

    for __, tile in pairs(tiles) do
        local x, y = self:toTableCoordinates(tile.x - chunk.x, tile.y - chunk.y)

        chunk.tiles[y][x] = tile.type.id
    end

    return chunk
end

-- Table coordinates -> world coordinates
function Tilemap:fromTableCoordinates(x, y)
    return (x - 1) * self.tileSize, (y - 1) * self.tileSize
end

-- Set tiles from compressed format
function Tilemap:setChunk(chunk)
    for y = 1, self.chunk.h / self.tileSize do
        for x = 1, self.chunk.w / self.tileSize do
            local id = chunk.tiles[y][x]
            
            local cx, cy = self:fromTableCoordinates(x, y)
            self:setTile(cx + chunk.x, cy + chunk.y, id)
        end
    end
end
