--##Game Logic
--#Imports
local player = require("Prefabs/player")
local anim8 = require ("Lib/anim8")
local ponei = require ("Prefabs/ponei")
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
	character.x = ((largura-47)/2)  
	character.y = altura	
	esmaecerTela = false
	apertou = false
	esmaece = false
	musica = love.audio.newSource("Sounds/sound.mp3")
	musica:setVolume(0.25)
	especial = love.audio.newSource("Sounds/especial.mp3")
	especial:setVolume(5)
	floor = love.graphics.newImage("Sprites/floor.png")
	floor:setWrap( "repeat", "repeat" )
	quadFloor = love.graphics.newQuad(0, 0, largura, floor:getHeight(), floor:getWidth(), floor:getHeight())
	backGround = love.graphics.newImage("Sprites/background.png")
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
		musica:play()
		character.anim:update(dt)
		if love.keyboard.isDown("right") then
      		character.x = character.x + (character.speed * dt)
   		end  
   		if love.keyboard.isDown("left") then
      		character.x = character.x - (character.speed * dt)
   		end 
   		if love.keyboard.isDown("a") and podeAtirar() then 
   			ultimoTiro = os.clock()   			
   			player.shoot()
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
   		if character.x<0 then character.x=0 end  
   		if character.x>largura-47 then character.x = largura-47 end
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
   		
   		updateEnemies(dt)
   		quadManaBack = love.graphics.newQuad(0, 0, character.mana*294/100, manaBack:getHeight()/2, manaBack:getWidth(), manaBack:getHeight()/2)
   		if character.mana>100 then 
   			character.mana = 100
   		end
   		if #enemies==0 then 
   			ponei = require ("Prefabs/ponei")
   			ponei.zera()
   			table.insert(enemies, ponei)			
   		end
   		
	elseif gamestate == "onPause" then

	elseif gamestate == "over" then
		
	elseif gamestate == "credits" then

	end
	
end

--Draw Objects
function love.draw(dt)
	if gamestate == "intro" then

	elseif gamestate == "menu" then
		love.graphics.print("Press space to start the best game of the world")

	elseif gamestate == "onPlay" then
		love.graphics.draw(backGround, quadBack, 0, 0)
		love.graphics.draw(floor, quadFloor, 0, altura-floor:getHeight())

		character.anim:draw(character.image, character.x, altura - 80)		
		--love.graphics.print(character.mana.. "Press escape to return to the menu")
		local i
		for i in ipairs(player.bullets) do
			love.graphics.circle('fill', player.bullets[i].bx, player.bullets[i].by, 5, 5)
		end

		for i in ipairs(enemies) do
			love.graphics.draw(enemies[i].sprite, enemies[i].x, enemies[i].y)
			love.graphics.setColor(255, 0, 0)
			love.graphics.rectangle("fill", enemies[i].x, enemies[i].y+enemies[i].sprite:getHeight(), enemies[i].sprite:getWidth()/100*enemies[i].hp, 10)
			love.graphics.setColor(255, 255, 255)
			local j 
			for j in ipairs(enemies[i].tiros) do
				love.graphics.draw(enemies[i].tiros[j].tSprite, enemies[i].tiros[j].tx, enemies[i].tiros[j].ty)
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

function podeAtirar()
	local tempo
	if (os.clock()-ultimoTiro)<tempoDeTiro then
		tempo = false
	else
	    tempo = true
	end	
	return tempo and character.mana>=2
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function updateEnemies(dt)
	local i 
	local j
	for i in ipairs(enemies) do 			
		enemies[i].ataca(character.x, character.y, enemies[i].x, enemies[i].y)
		enemies[i].move(love.graphics.getWidth(), love.graphics.getHeight())		
		for j in ipairs(enemies[i].tiros) do
			enemies[i].tiros[j].ty = enemies[i].tiros[j].ty+1*enemies[i].tiros[j].tspeed
			if CheckCollision(enemies[i].tiros[j].tx, enemies[i].tiros[j].ty, enemies[i].tiros[j].tSprite:getWidth(), enemies[i].tiros[j].tSprite:getHeight(), character.x, character.y, 47, 48) then
				gamestate = "over"
			end
			if  (enemies[i].tiros[j].ty < -20) or (enemies[i].tiros[j].ty > altura) then
			 	table.remove(enemies[i].tiros, j)
			end
		end
		for j in ipairs(player.bullets) do
			if CheckCollision(enemies[i].x, enemies[i].y, enemies[i].sprite:getWidth(), enemies[i].sprite:getHeight(), player.bullets[j].bx, player.bullets[j].by, 5, 5) then
				enemies[i].hp = enemies[i].hp - 5
				player.bullets[j].by = -25
			end
		end
		if enemies[i].hp <= 0 then
			table.remove(enemies, i)
		end	
	end
	for i in ipairs(player.bullets) do
		player.bullets[i].by = player.bullets[i].by - 1* player.bullets[i].bspeed * dt		
		if  (player.bullets[i].by < -20) or (player.bullets[i].by > love.graphics.getHeight() + 20) then
			table.remove(player.bullets, i)
		end
	end
end
