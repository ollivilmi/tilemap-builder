Rendering = Class{}

function Rendering:init(builder)
    self.builder = builder
    self.level = builder.level
    self.cursor = builder.cursor

    self.tileTextures = {
        r = love.graphics.newImage('src/assets/tile/rock.png'),
        g = love.graphics.newImage('src/assets/tile/grass.png'),
    }

    self.resourceTextures = {
        t = love.graphics.newImage('src/assets/tile/sand.png'),
    }
end

function Rendering:renderTile(tile)
    local texture = self.tileTextures[tile.type.id] or self.tileTextures['r']
    love.graphics.draw(texture, tile.x, tile.y)
end

function Rendering:renderResource(resource)
    local texture = self.resourceTextures[resource.id] or self.resourceTextures['t']
    local x, y = self.level.world:getRect(resource)
    love.graphics.draw(texture, x, y)
end

function Rendering:render()
    love.graphics.setColor(1,1,1)

    local assets = self.level.world:getItems()

    for __, asset in pairs(assets) do
        if asset.isTile then
            self:renderTile(asset)
        elseif asset.isResource then
            self:renderResource(asset)
        end
    end

    love.graphics.rectangle('line', self.cursor.sx, self.cursor.sy, self.cursor.w, self.cursor.h)
end