--##Game Logic
--#Imports
local player = require("player")
local anim8 = require 'anim8'
character = player.invokeCharacter()

--#Variables
local gamestate  --[[ intro - menu - onPlay - onPause - over - credits ]]

--#On Start
function  love.load()
	gamestate = "onPlay"
end

--#On every frame
function love.update(dt)
	if gamestate == "intro" then

	elseif gamestate == "menu" then

	elseif gamestate == "onPlay" then
		character.anim:update(dt)
	elseif gamestate == "onPause" then

	elseif gamestate == "over" then

	elseif gamestate == "credits" then

	end
end

--Draw Objects
function love.draw(dt)
	if gamestate == "intro" then

	elseif gamestate == "menu" then

	elseif gamestate == "onPlay" then
		character.anim:draw(character.image, (love.graphics.getWidth()/2) - 23.5, love.graphics.getHeight() - 50)
		love.graphics.print(character.mana)
	elseif gamestate == "onPause" then

	elseif gamestate == "over" then

	elseif gamestate == "credits" then

	end
end
