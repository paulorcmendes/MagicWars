--##Game Logic
--#Imports
local player = require("player")
character = player.invokeCharacter()

--#Variables
local gamestate  --[[ intro - menu - onPlay - onPause - over - credits ]]

--#On Start
function  love.load()
	gamestate = "onPlay"
end

--#On every frame
function love.update()
	if gamestate == "intro" then

	elseif gamestate == "menu" then

	elseif gamestate == "onPlay" then

	elseif gamestate == "onPause" then

	elseif gamestate == "over" then

	elseif gamestate == "credits" then

	end
end

--Draw Objects
function love.draw()
	if gamestate == "intro" then

	elseif gamestate == "menu" then

	elseif gamestate == "onPlay" then
		
		love.graphics.print(character[1])
	elseif gamestate == "onPause" then

	elseif gamestate == "over" then

	elseif gamestate == "credits" then
		
	end
end