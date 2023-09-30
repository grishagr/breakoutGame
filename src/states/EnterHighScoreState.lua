EnterHighScoreState = Class{__includes = BaseState}

function EnterHighScoreState:enter(params)
    self.score = params.score
    self.index = params.index
    self.looking = true
    self.name = ""
end

function EnterHighScoreState:update(dt)
    local string = "qwertyuiopasdfghjklzxcvbnm "

    for letter in string:gmatch"." do
        if love.keyboard.wasPressed(letter) then
            if #self.name < 5 then
                self.name = self.name .. letter
            end
        end
    end

    if love.keyboard.wasPressed('backspace') and #self.name > 0 then
         self.name = self.name:sub(1,-2)   
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        for i = 10, self.index, -1 do
            highScores[i + 1] = {
                name = highScores[i].name,
                score = highScores[i].score
            }
        end

        highScores[self.index].name = self.name
        highScores[self.index].score = self.score

        local scoresStr = ''

        for i = 1, 10 do
            scoresStr = scoresStr .. highScores[i].name .. '\n'
            scoresStr = scoresStr .. tostring(highScores[i].score) .. '\n'
        end

        love.filesystem.write('breakout.lst', scoresStr)

        gStateMachine:change('high-scores')

    end    
end

function EnterHighScoreState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Score: '.. self.score, 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Type your name and press Enter', 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(self.name, 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end