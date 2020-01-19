Resources = Class{}

local RESOURCE_SIZE = 10

function Resources:init(level)
    self.world = level.world
    self.chunk = level.chunk

    self.types = {
        t = {
            id = 't',
        }
    }
end

function Resources:addResource(x, y, id)
    local type = self.types[id] or 't'
    if not type then return end

    local resource = {id = id, falling = true, isResource = true}
    self.world:add(resource, x, y, RESOURCE_SIZE, RESOURCE_SIZE)
end

function Resources:setResource(x, y, id)
    local type = self.types[id]

    if type then
        self:removeIfExists(x, y)
        self:addResource(x, y, id)
    end
end

function Resources:getResource(x, y)
    local items, len = self.world:queryRect(x, y, RESOURCE_SIZE, RESOURCE_SIZE, function(item)
        return item.isResource
    end)

    return items[1]
end

function Resources:removeResource(resource)
    self.world:remove(resource)
end

function Resources:removeIfExists(x, y)
    local resource = self:getResource(x, y)
    if resource then
        self:removeResource(resource)
    end
end

function Resources:getChunk(chunk)
    local resourceChunk = {}

    local resources, len = self.world:queryRect(
        chunk.x, chunk.y, self.chunk.w, self.chunk.h, function(item)
            return item.isResource
        end
    )

    for __, resource in pairs(resources) do
        local x, y = self.world:getRect(resource)
        table.insert(resourceChunk, {id = resource.id, x = x, y = y})
    end

    return resourceChunk
end

function Resources:setResources(resources)
    for id, resource in pairs(resources) do
        self:setResource(resource.x, resource.y, resource.id)
    end
end

-- function Resources:update(chunk, dt)
--     local resources = self.world:queryRect(chunk.x, chunk.y, self.chunk.w, self.chunk.h, function(item)
--         return item.isResource
--     end)

--     for __, resource in pairs(resources) do
--         local x, y = self.world:getRect(resource)

--         if resource.falling then
--             local __, __, cols, cols_len  = self.world:move(resource, x, y + (50 * dt))

--             if cols_len ~= 0 then
--                 resource.falling = false
--             end
--         else
--             if not self:resourceIsGrounded(resource, x, y) then
--                 resource.falling = true
--             end
--         end
--     end
-- end

-- function Resources:resourceIsGrounded(resource, x, y)
--     local size = self.types[resource.id].size

--     local items, len = self.world:queryRect(x, y + size + 1, size, 1)
--     return len ~= 0
-- end