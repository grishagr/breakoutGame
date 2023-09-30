-- lib
Class = require 'lib/class' -- https://github.com/vrld/hump/blob/master/class.lua
push = require 'lib/push' -- https://github.com/Ulydev/push

-- src files
require 'src/constants' -- constants
require 'src/Util' -- utility functions
require 'src/LevelMaker' -- level maker for bricks generation

-- game objects
require 'src/Paddle'
require 'src/Ball'
require 'src/Brick'

-- state machine
require 'src/StateMachine'

-- states
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/GameOverState'
require 'src/states/HighScoreState'
require 'src/states/PaddleSelectState'
require 'src/states/ServeState'
require 'src/states/PauseState'
require 'src/states/VictoryState'
require 'src/states/SettingsState'
require 'src/states/EnterHighScoreState'