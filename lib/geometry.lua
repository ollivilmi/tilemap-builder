function math.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

-- Basically just pythagoras theorem
function math.distance(ax, ay, bx, by)
    return math.sqrt((ax - bx)^2 + (ay - by)^2)
end

-- https://math.stackexchange.com/questions/796243/how-to-determine-the-direction-of-one-point-from-another-given-their-coordinate
-- https://en.wikipedia.org/wiki/Atan2
-- basically returns the angle in radians
function math.direction(ax, ay, bx, by)
    return math.atan2(by-ay,bx-ax)
end

-- AABB collision
function math.rectangleCollidesRectangle(rectangleA, rectangleB)
    if rectangleA.x > rectangleB.x + rectangleB.w or rectangleB.x > rectangleA.x + rectangleA.w then
        return false
    end

    if rectangleA.y > rectangleB.y + rectangleB.h or rectangleB.y > rectangleA.y + rectangleA.h then
        return false
    end

    return true
end

function math.rectangleCenter(rectangle)
    local x = math.floor(rectangle.x + (rectangle.w / 2))
    local y = math.floor(rectangle.y + (rectangle.h / 2))

    return x, y
end

function math.circleCollidesRectangle(circle, rectangle)
    -- closest x and y to circle
    closestX = math.clamp(circle.x, rectangle.x, rectangle.x + rectangle.w)
    closestY = math.clamp(circle.y, rectangle.y, rectangle.y + rectangle.h)

    distanceX = circle.x - closestX
    distanceY = circle.y - closestY

    -- If the distance is less than the circle's radius, an intersection occurs
    distanceSquared = (distanceX * distanceX) + (distanceY * distanceY);
    return distanceSquared < (circle.radius * circle.radius);
end

function math.circleContainsRectangle(circle, rectangle)
    for x = rectangle.x, rectangle.x + rectangle.w, rectangle.w do
        for y = rectangle.y, rectangle.y + rectangle.h, rectangle.h do
            if not circle:hasPoint(x, y) then
                return false
            end
        end
    end
    return true
end

-- point a to point b
function math.vector(ax, ay, bx, by)
    -- if equal, return a zero vector
    if ax == bx and ay == by then
        return 0,0
    end

    local x = math.floor(bx - ax)
    local y = math.floor(by - ay)

    return x, y
end

-- unit vector is a vector which has the length of 1
--
-- so we get the reciprocal of the vector's length
-- and multiply dx dy by that value (resulting in a vector of length 1) 
function math.unitVector(ax, ay, bx, by)
    return math.vectorOfLength(ax, ay, bx, by, 1)
end

function math.vectorOfLength(ax, ay, bx, by, length)
    local x, y = math.vector(ax, ay, bx, by)

    local d = length / math.distance(ax, ay, bx, by)

    return x * d, y * d
end