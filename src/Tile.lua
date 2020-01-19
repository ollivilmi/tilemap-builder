Tile = Class{}

function Tile:init(x, y, type)
    self.isTile = true
    self.type = type
    self.x = x
    self.y = y
end