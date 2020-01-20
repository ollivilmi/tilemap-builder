Interface = Class{}

function Interface:init(levelBuilder)
    Gui.style.unit = math.max(40, love.graphics.getWidth() / 25)

    self.tileTextures = {
        r = love.graphics.newImage('src/assets/tile/rock.png'),
        g = love.graphics.newImage('src/assets/tile/grass.png'),
    }

    self.grp = Gui:group(nil, {50, love.graphics.getHeight() - 150, 500, 100})
    self.grp.drag = true
    self.grp.style.bg = {0,0,0,0.8}

    local activeTile = Gui:image("Active tile", {50, 30}, self.grp, self.tileTextures[levelBuilder:getTile()])

    levelBuilder:addListener('ACTIVE TILE', function(id)
        activeTile.img = self.tileTextures[id]
    end)
end