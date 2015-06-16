--##Game Logic
--#Imports
local player = require("player")
local anim8 = require 'anim8'
local ponei = require 'ponei'
local bullets = {}
local enemies = {}
local largura
local altura 
enemies[1] = ponei
e.x = 50
e.y = 50
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
	esmaecerTela = false
	apertou = false
	esmaece = false
	musica = love.audio.newSource("sound.mp3")
	musica:setVolume(0.25)
	especial = love.audio.newSource("especial.mp3")
	especial:setVolume(5)
	floor = love.graphics.newImage("floor.png")
	floor:setWrap( "repeat", "repeat" )
	quadFloor = love.graphics.newQuad(0, 0, largura, floor:getHeight(), floor:getWidth(), floor:getHeight())
	backGround = love.graphics.newImage("background.png")
	backGround:setWrap( "repeat", "repeat" )
	quadBack = love.graphics.newQuad(0, 0, largura, altura, backGround:getWidth()/1.5, backGround:getHeight()/1.5)

	manaBack = love.graphics.newImage("Sprites/manaBack.png")
	manaBack:setWrap( "repeat", "repeat" )
	quadManaBack = love.graphics.newQuad(0, 0, character.mana*294/100, manaBack:getHeight()/2, manaBack:getWidth(), manaBack:getHeight()/2)

	manaBar = love.graphics.newImage("Sprites/manaBar.png")
	
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
		character.mana=character.mana+0.03
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
   		if love.keyboard.isDown("d") and character.mana>=75 then
   			character.mana = character.mana-75
   			love.audio.play(especial)
   			comecoEsmaece = os.clock()
   			apertou = true
   		end
   		if love.keyboard.isDown("escape") then
   			love.audio.stop()
   			love.load()
   		end
   		if x<0 then x=0 end  
   		if x>largura-47 then x = largura-47 end
   		if apertou then 
   			
   			if os.clock()-comecoEsmaece>3.5 then 
   				esmaece = true
   				comecoEsmaece = os.clock()
   				nComeco = comecoEsmaece   				
   			end
   		end
   		if esmaece then
   			tAtual = os.clock()
   			if tAtual-comecoEsmaece<=1 then
   				if tAtual-nComeco<=0.02 then 
   					esmaecerTela = true
   				else 
   					esmaecerTela = false
   				end
   				if tAtual-nComeco>0.04 then
   					nComeco = tAtual
   				end
   				musica:setVolume(0.15)
   			else
   				musica:setVolume(0.25)
   			    apertou = false
   			    esmaece = false
   			    esmaecerTela = false
   			end

   		end

   		quadManaBack = love.graphics.newQuad(0, 0, character.mana*294/100, manaBack:getHeight()/2, manaBack:getWidth(), manaBack:getHeight()/2)
   		if character.mana>100 then 
   			character.mana = 100
   		end
	elseif gamestate == "onPause" then

	elseif gamestate == "over" then

	elseif gamestate == "credits" then

	end
	updateBullets(dt)
	updateEnemies()
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
		--love.graphics.print(character.mana.. "Press escape to return to the menu")
		local i, o
		for i, o in ipairs(bullets) do
			love.graphics.circle('fill', o.bx, o.by, 2, 8)
		end

		for i in ipairs(enemies) do
			love.graphics.draw(enemies[i].sprite, enemies[i].x, enemies[i].y)
			love.graphics.print(enemies[i].x.. love.graphics.getWidth())
			local j 

			for j in ipairs(enemies[i].tiros) do
				love.graphics.draw(enemies[i].tiros[j].tSprite, enemies[i].x, enemies[i].y)
			end

		end

		love.graphics.draw(manaBack, quadManaBack, 10, 10)
		love.graphics.draw(manaBar, 7.5, 7.5)
		if esmaecerTela then 
			love.graphics.setColor(250, 250, 250)
			love.graphics.rectangle("fill", 0, 0, largura, altura)
		end
	elseif gamestate == "onPause" then

	elseif gamestate == "over" then

	elseif gamestate == "credits" then

	end
end
function esmaecerTela(comecoEsmaece)
	
end

function shoot()
	character.mana = character.mana-2
	ultimoTiro = os.clock()
	table.insert(bullets, {
			bx = x+47/2,
			by = y-50,
			bspeed = 400
	})
end
function podeAtirar()
	local tempo
	if os.clock()-ultimoTiro<tempoDeTiro then
		tempo = false
	else
	    tempo = true
	end	
	return tempo and character.mana>=2
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
function updateEnemies()
	local i 

	for i in ipairs(enemies) do 
		enemies[i].move(love.graphics.getWidth(), love.graphics.getHeight())
	end
end
