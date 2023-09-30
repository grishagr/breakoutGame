SettingsState = Class{__includes = BaseState}
local highlighted = 0

function SettingsState:enter(params)
    self.previousState = params.state
    if self.previousState == 'pause' then
        self.paddle = params.paddle
        self.bricks = params.bricks
        self.health = params.health
        self.score = params.score
        self.ball = params.ball
        self.level = params.level
    end
end

function SettingsState:update(dt)

    --[[
        TODO
        -- make a function that takes in arguments for sound, music, or sound effects toggle
    ]]
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change(self.previousState, {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball,
            level = self.level
        })
    end

    if love.keyboard.wasPressed('down') then 
        if gSound then highlighted = (highlighted + 1) % 4 else highlighted = (highlighted - 1) % 2 end end
    if love.keyboard.wasPressed('up') then 
        if gSound then highlighted = highlighted == 0 and 3 or (highlighted - 1) % 4 else highlighted = highlighted == 0 and 1 or (highlighted - 1) % 2 end end
    if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('right') then
        if highlighted == 0 then
            if love.keyboard.wasPressed('left') then
                if gDifficulty == 0 then 
                    gDifficulty = 2 
                else 
                    gDifficulty = (gDifficulty - 1) % 3
                end
            else
                if gDifficulty == 2 then
                    gDifficulty = 0
                else
                    gDifficulty = (gDifficulty + 1) % 3 
                end
            end
        elseif highlighted == 1 then
                gSounds['select']:play()
                gSound = not gSound
        elseif highlighted == 2 then
            if not gSound then
                return
            end
            gSounds['select']:play()
            gMusic = not gMusic

        elseif highlighted == 3 then
            if not gSound then
                return
            end
            gSounds['select']:play()
            gEffectSound = not gEffectSound
        end       
    end
    toggleSounds() 
end

function SettingsState:render()
    if self.previousState == 'pause' then
        self.paddle:render()
        self.ball:render()
        for k, brick in pairs(self.bricks) do
            brick:render()
        end
        renderHealth(self.health)
        renderScore(self.score)
    end

    -- moving arrows
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT / 2 + 20 * (highlighted - 1) - gTextures['arrows']:getHeight() / 2 + 5)
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 8,
        VIRTUAL_HEIGHT / 2 + 20 * (highlighted - 1) - gTextures['arrows']:getHeight() / 2 + 5)
    
    love.graphics.setFont(gFonts['medium'])

    -- instructions
    love.graphics.printf('Use arrow keys to switch settings', 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH, 'center')

    -- option 1 | Difficulty
    if highlighted == 0 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("Difficulty", 100, VIRTUAL_HEIGHT / 2 - 20,
    VIRTUAL_WIDTH - 170, 'left')

    if gDifficulty == 0 then
        love.graphics.printf("[Normal]", 50, VIRTUAL_HEIGHT / 2 - 20,
        VIRTUAL_WIDTH - 170, 'right')
    elseif gDifficulty == 1 then
        love.graphics.printf("[Hard]", 50, VIRTUAL_HEIGHT / 2 - 20,
        VIRTUAL_WIDTH - 170, 'right')
    else
        love.graphics.printf("[UR A BEAST]", 50, VIRTUAL_HEIGHT / 2 - 20,
        VIRTUAL_WIDTH - 170, 'right')
    end  

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    -- option 2 | Sound
    if highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("Sound", 100, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH - 170, 'left')
    if gSound then
        love.graphics.printf("[ON]", 50, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH - 170, 'right')
    else
        love.graphics.printf("[OFF]", 50, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH - 170, 'right')
    end  

    -- reset the color
    if gSound then love.graphics.setColor(1, 1, 1, 1) else love.graphics.setColor(100/255, 100/255, 100/255, 1) end

    -- option 3 | Music
    if highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("Music", 100, VIRTUAL_HEIGHT / 2 + 20,
    VIRTUAL_WIDTH - 170, 'left')

    if gSound and gMusic then
        love.graphics.printf("[ON]", 50, VIRTUAL_HEIGHT / 2 + 20,
        VIRTUAL_WIDTH - 170, 'right')
    else
        love.graphics.printf("[OFF]", 50, VIRTUAL_HEIGHT / 2 + 20,
        VIRTUAL_WIDTH - 170, 'right')
    end 

    -- reset the color
    if gSound then love.graphics.setColor(1, 1, 1, 1) else love.graphics.setColor(100/255, 100/255, 100/255, 1) end

    -- option 4 | Sound Effects
    if highlighted == 3 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("Sound Effects", 100, VIRTUAL_HEIGHT / 2 + 40,
    VIRTUAL_WIDTH - 170, 'left')

    if gSound and gEffectSound then
        love.graphics.printf("[ON]", 50, VIRTUAL_HEIGHT / 2 + 40,
        VIRTUAL_WIDTH - 170, 'right')
    else
        love.graphics.printf("[OFF]", 50, VIRTUAL_HEIGHT / 2 + 40,
        VIRTUAL_WIDTH - 170, 'right')
    end 

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
    
end

function toggleSounds()
    if gSound then
        for i, sound in pairs(gSounds) do
            gSounds[i]:setVolume(1)
        end
    elseif not gSound then
        for i, sound in pairs(gSounds) do
            gSounds[i]:setVolume(0)
        end
    end

    if gMusic and gSound then
        gSounds['music']:setVolume(1)
    elseif not gMusic then
        gSounds['music']:setVolume(0)
    end

    if gEffectSound and gSound then
        for i, sound in pairs(gSounds) do
            if i ~= 'music' then
                gSounds[i]:setVolume(1)
            end
        end
    elseif not gEffectSound then
        for i, sound in pairs(gSounds) do
            if i ~= 'music' then
                gSounds[i]:setVolume(0)
            end
        end
    end
end