Ball = Class{}

function Ball:init(skin)
    self.height = 8
    self.width = 8

    self.dx = math.random(-200, 200)
    self.dy = math.random(-100 - 100 * gDifficulty, -100 - 100 *gDifficulty  - 50 * (gDifficulty + 1))

    self.x = VIRTUAL_WIDTH / 2 - 4
    self.y = VIRTUAL_HEIGHT - 42

    self.skin = skin
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.x >= VIRTUAL_WIDTH - 8 then
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        gSounds['wall-hit']:play()
    end
end

function Ball:collides(object)
    if self.x > object.x + object.width or object.x > self.x + self.width then
        return false
    end

    if self.y > object.y + object.height or object.y > self.y + self.height then
        return false
    end 

    return true
end

function Ball:render()
    love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin],
        self.x, self.y)
end