ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.ball = Ball(math.random(7))
end

function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + self.paddle.width / 2 - self.ball.width / 2
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('space') then
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball,
            level = self.level
        })
    end

    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')
    end
end

function ServeState:render()
    self.paddle:render()
    self.ball:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    love.graphics.setFont(gFonts['small'])

    love.graphics.printf("Press Space to Serve", 0, VIRTUAL_HEIGHT / 2 + 25,
        VIRTUAL_WIDTH, 'center')
    
    love.graphics.printf('Press Escape for Main Menu', 0, VIRTUAL_HEIGHT / 2 + 35, 
        VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('Level ' .. self.level, 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end