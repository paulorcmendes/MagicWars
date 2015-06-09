--##Game Logic
--#Imports
local player = require("player")
local anim8 = require 'anim8'


--#Variables
local gamestate  --[[ intro - menu - onPlay - onPause - over - credits ]]

--#On Start
function  love.load()
	gamestate = "onPlay"
	character = player.invokeCharacter()
	largura = love.graphics.getWidth()
	altura = love.graphics.getHeight()
	x = ((largura-47)/2)  
end

--#On every frame
function love.update(dt)
	if gamestate == "intro" then

	elseif gamestate == "menu" then

	elseif gamestate == "onPlay" then
		character.anim:update(dt)
		if love.keyboard.isDown("right") then
      		x = x + (character.speed * dt)
   		end
   		if love.keyboard.isDown("left") then
      		x = x - (character.speed * dt)
   		end 
   		if x<0 then x=0 end  
   		if x>largura-47 then x = largura-47 end
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
		character.anim:draw(character.image, x, altura - 50)
		love.graphics.print(character.mana)
	elseif gamestate == "onPause" then

	elseif gamestate == "over" then

	elseif gamestate == "credits" then

	end
end
