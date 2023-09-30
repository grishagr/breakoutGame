PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:enter(params)
    self.previousState = params.state
    
    if self.previousState == 'pause' then
        self.nextState = 'pause'
        self.skin = params.paddle.skin
        self.paddle = params.paddle
        self.bricks = params.bricks
        self.health = params.health
        self.score = params.score
        self.ball = params.ball
        self.level = params.level
    else
        self.nextState = 'serve'
        self.skin = 1
        self.level = 1
        self.health = 3
        self.bricks = LevelMaker.createMap(self.level)
        self.score = 0
        self.paddle = Paddle()
        self.ball = Ball(math.random(7))
    end
end

function PaddleSelectState:update(dt)

    if love.keyboard.wasPressed('left') then
        if self.skin == 1 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.skin = self.skin - 1
        end
        
    elseif love.keyboard.wasPressed('right') then
        if self.skin == 4 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.skin = self.skin + 1
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.paddle:changeSkin(self.skin)
        gSounds['confirm']:play()
        gStateMachine:change(self.nextState, {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball,
            level = self.level,
        })
    end

    if love.keyboard.wasPressed('escape') then
        gSounds['select']:play()
        gStateMachine:change(self.previousState,{
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball,
            level = self.level,
        })
    end
end

function PaddleSelectState:render()
    -- instructions
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select your paddle and press Enter", 0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')

    -- left arrow; should render normally if we're higher than 1, else
    -- in a shadowy form to let us know we're as far left as we can go
    if self.skin == 1 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
   
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1, 1, 1, 1)

    -- right arrow; should render normally if we're less than 4, else
    -- in a shadowy form to let us know we're as far right as we can go
    if self.skin == 4 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
    
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1, 1, 1, 1)

    -- draw the paddle itself, based on which we have selected
    love.graphics.draw(gTextures['main'], gFrames['paddles'][2 + 4 * (self.skin - 1)],
        VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
end