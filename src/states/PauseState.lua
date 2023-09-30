PauseState = Class{__includes = BaseState}

local highlighted = 0

function PauseState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball
    self.level = params.level
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('up') then
        highlighted = (highlighted - 1) % 4
    
    elseif love.keyboard.wasPressed('down') then
        highlighted = (highlighted + 1) % 4

    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['select']:play()
        if highlighted == 0 then
            gStateMachine:change('play', {
                paddle = self.paddle,
                score = self.score,
                ball = self.ball,
                bricks = self.bricks,
                health = self.health,
                level = self.level
            })
        elseif highlighted == 1 then
            gStateMachine:change('paddle-select',{
                paddle = self.paddle,
                score = self.score,
                ball = self.ball,
                bricks = self.bricks,
                health = self.health,
                level = self.level,
                state = 'pause'
            })
        elseif highlighted == 2 then
            gStateMachine:change('settings', {
                paddle = self.paddle,
                score = self.score,
                ball = self.ball,
                bricks = self.bricks,
                health = self.health,
                level = self.level,
                state = 'pause'
            })
        else
            gStateMachine:change('start')
        end
    end
end

function PauseState:render()

    self.paddle:render()
    self.ball:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderHealth(self.health)
    renderScore(self.score)

    -- title
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Paused", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    
    -- instructions
    love.graphics.setFont(gFonts['medium'])

    -- if we're highlighting 1, render that option blue
    if highlighted == 0 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("Continue", 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    -- render option 2 blue if we're highlighting that one
    if highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("Paddle Skins", 0, VIRTUAL_HEIGHT / 2 + 20,
        VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("Settings", 0, VIRTUAL_HEIGHT / 2 + 40,
        VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 3 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("Main Menu", 0, VIRTUAL_HEIGHT / 2 + 60,
        VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
    
end