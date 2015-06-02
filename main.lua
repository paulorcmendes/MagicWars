--Imports
local player = require("player")

local gamestate 
--[[ intro - menu - onPlay - onPause - over - credits ]]

function  love.load()
	gamestate = "onPlay"
end
function love.update()
	if gamestate == "intro" then

	elseif gamestate == "menu" then

	elseif gamestate == "onPlay" then

	elseif gamestate == "onPause" then

	elseif gamestate == "over" then

	elseif gamestate == "credits" then

	end
end

function love.draw()
	if gamestate == "intro" then

	elseif gamestate == "menu" then

	elseif gamestate == "onPlay" then
		love.graphics.print(player.invokePlayer())
	elseif gamestate == "onPause" then

	elseif gamestate == "over" then

	elseif gamestate == "credits" then
		
	end
end