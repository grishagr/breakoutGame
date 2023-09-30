PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.paddle = params.paddle
    self.ball = params.ball
    self.score = params.score
    self.health = params.health
    self.bricks = params.bricks
    self.level = params.level
end

function PlayState:update(dt)

    -- update positions based on velocity
    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()
        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score
            })
        else
            gStateMachine:change('serve', {
                score = self.score,
                paddle = self.paddle,
                ball = self.ball,
                bricks = self.bricks,
                health = self.health,
                level = self.level
            })
        end
    end
    

    -- Collision Detection 1
    for k, brick in pairs(self.bricks) do
        -- ball/brick collision
        if brick.inPlay and self.ball:collides(brick) then
            
            self.score = self.score + (brick.tier * 200 + brick.color * 25) + gDifficulty * 100
            -- removes brick from screen
            brick:hit()

            if self:checkVictory() then
                gStateMachine:change('victory', {
                    score = self.score,
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    ball = self.ball
                })
            end

            -- left corner collision
            if self.ball.dx > 0 and self.ball.x + 2 < brick.x then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - self.ball.width

            -- right corner collision
            elseif self.ball.dx < 0 and self.ball.x + 6 > brick.x + brick.width then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + brick.width

            -- top collision
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - self.ball.height

            -- bottom collision
            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + brick.height
            end

            -- every collision speeds the game up (max ball velocity = 150)
            if math.abs(self.ball.dy) < (150 + gDifficulty * 100) then
                self.ball.dy = self.ball.dy * 1.02 + gDifficulty * 10
            end

            break
        end
    end

    -- Collision Detection 2
    -- paddle/ball collision
    if self.ball:collides(self.paddle) then
        -- right/left edge
        if self.ball.y > (self.paddle.y + self.paddle.height / 2) then
            self.ball.x = self.ball.dx > 0 and self.paddle.x - self.ball.width or 
                self.paddle.x + self.paddle.width
            self.ball.dx = -self.ball.dx
            return
        end
        
        self.ball.dy = -self.ball.dy

        -- collision physics
        -- left side + moving left
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
            
        -- right side + moving right
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
            
        else
            -- if none of the above, ball velocity changes based on paddle velocity
            self.ball.dx = self.ball.dx + self.paddle.dx / 8
        end

        -- reset ball position after collision
        self.ball.y = self.paddle.y - self.ball.width
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('pause', {
            paddle = self.paddle,
            score = self.score,
            ball = self.ball,
            bricks = self.bricks,
            health = self.health,
            level = self.level
        })
        gSounds['pause']:play()
    end

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end
end

function PlayState:render()
    self.paddle:render()
    self.ball:render()
    renderHealth(self.health)
    renderScore(self.score)

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end