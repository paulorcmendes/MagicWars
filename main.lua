--##Game Logic
--#Imports
local player = require("player")
local anim8 = require 'anim8'
local bullets = {}
--#Variables
local gamestate  --[[ intro - menu - onPlay - onPause - over - credits ]]

--#On Start
function  love.load()
	gamestate = "menu"	
end
function carregaGame()	
	character = player.invokeCharacter()
	largura = love.graphics.getWidth()
	altura = love.graphics.getHeight()
	tempoDeTiro = 0.2
	ultimoTiro = os.clock()-tempoDeTiro	
	x = ((largura-47)/2)  
	y = altura
	musica = love.audio.newSource("sound.mp3")
	floor = love.graphics.newImage("floor.png")
	floor:setWrap( "repeat", "repeat" )
	quadFloor = love.graphics.newQuad(0, 0, largura, floor:getHeight(), floor:getWidth(), floor:getHeight())
	backGround = love.graphics.newImage("background.png")
	backGround:setWrap( "repeat", "repeat" )
	quadBack = love.graphics.newQuad(0, 0, largura, altura, backGround:getWidth()/1.5, backGround:getHeight()/1.5)

end
--#On every frame
function love.update(dt)
	if gamestate == "intro" then

	elseif gamestate == "menu" then
		
		if love.keyboard.isDown(" ") then
			carregaGame()
			gamestate = "onPlay"			
		end
	elseif gamestate == "onPlay" then
		love.audio.play(musica)
		character.anim:update(dt)
		if love.keyboard.isDown("right") then
      		x = x + (character.speed * dt)
   		end
   		if love.keyboard.isDown("left") then
      		x = x - (character.speed * dt)
   		end 
   		if love.keyboard.isDown("a") and podeAtirar() then 
   			shoot()
   		end
   		if love.keyboard.isDown("escape") then
   			love.audio.stop()
   			love.load()
   		end
   		if x<0 then x=0 end  
   		if x>largura-47 then x = largura-47 end

	elseif gamestate == "onPause" then

	elseif gamestate == "over" then

	elseif gamestate == "credits" then

	end
	updateBullets(dt)
end

--Draw Objects
function love.draw(dt)
	if gamestate == "intro" then

	elseif gamestate == "menu" then
		love.graphics.print("Press space to start the best game of the world")
	elseif gamestate == "onPlay" then
		love.graphics.draw(backGround, quadBack, 0, 0)
		love.graphics.draw(floor, quadFloor, 0, altura-floor:getHeight())
		character.anim:draw(character.image, x, altura - 80)		
		love.graphics.print(character.mana.. "Press escape to return to the menu")
		local i, o
		for i, o in ipairs(bullets) do
			love.graphics.circle('fill', o.bx, o.by, 2, 8)
		end
	elseif gamestate == "onPause" then

	elseif gamestate == "over" then

	elseif gamestate == "credits" then

	end
end

function shoot()
	character.mana = character.mana+1
	ultimoTiro = os.clock()
	table.insert(bullets, {
			bx = x+47/2,
			by = y-50,
			bspeed = 400
	})
end
function podeAtirar()
	if os.clock()-ultimoTiro<tempoDeTiro then
		return false
	else
	    return true
	end	
end
function updateBullets(dt)
	-- update bullets:
	local i, o
	for i, o in ipairs(bullets) do
		o.by = o.by - 1* o.bspeed * dt
		if  (o.by < -20) or (o.by > love.graphics.getHeight() + 20) then
			table.remove(bullets, i)
		end
	end
end
