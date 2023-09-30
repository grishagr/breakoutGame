StartState = Class{__includes = BaseState}

-- whether we're highlighting "Start" or "High Scores"
local highlighted = 0

function StartState:update(dt)
    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') then
        highlighted = (highlighted - 1) % 4
    
    elseif love.keyboard.wasPressed('down') then
        highlighted = (highlighted + 1) % 4

    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['select']:play()
        if highlighted == 0 then
            gStateMachine:change('paddle-select', {state = 'start'})
        elseif highlighted == 1 then
            gStateMachine:change('high-scores')
        elseif highlighted == 2 then
            gStateMachine:change('settings', {state = 'start'})
        else
            love.event.quit()
        end
    end
end

function StartState:render()
    -- title
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    
    -- instructions
    love.graphics.setFont(gFonts['medium'])

    -- if we're highlighting 1, render that option blue
    if highlighted == 0 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 40,
        VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    -- render option 2 blue if we're highlighting that one
    if highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 60,
        VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    -- render option 2 blue if we're highlighting that one
    if highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("SETTINGS", 0, VIRTUAL_HEIGHT / 2 + 80,
        VIRTUAL_WIDTH, 'center')        

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 3 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("QUIT", 0, VIRTUAL_HEIGHT / 2 + 100,
        VIRTUAL_WIDTH, 'center')        

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
end