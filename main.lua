--##Game Logic
--#Imports
local player = require("Prefabs/player")
local anim8 = require ("Lib/anim8")
local ponei = require ("Prefabs/ponei")
local enemies = {}
local apertou
local largura = love.graphics.getWidth()
local altura = love.graphics.getHeight()
local character = player.load(largura, altura)
local tempoDeJogo
local tempoDePausa = 0


--#Variables
local gamestate  --[[ intro - menu - onPlay - onPause - over - credits ]]

--#On Start
function  love.load()
	gamestate = "menu"	
end
function carregaGame()	

	enemies = {}
	ponei.zera()
	enemies[1] = ponei
	tempoDeTiro = 0.2
	ultimoTiro = os.clock()-tempoDeTiro	
	character = player.load(largura, altura)		
	esmaecerTela = false
	apertou = false
	esmaece = false
	musica = love.audio.newSource("Sounds/sound.mp3")
	musica:setVolume(0.75)
	especial = love.audio.newSource("Sounds/especial.mp3")
	especial:setVolume(5)
	floor = love.graphics.newImage("Sprites/floor.png")
	floor:setWrap( "repeat", "repeat" )
	quadFloor = love.graphics.newQuad(0, 0, largura, floor:getHeight(), floor:getWidth(), floor:getHeight())
	backGround = love.graphics.newImage("Sprites/background.png")
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
		tempoDeJogo = os.clock()-tempoDePausa
		character.mana=character.mana+0.03
		musica:play()
   		updateEnemies(dt)

		if love.keyboard.isDown("right") then
			character.anim:update(dt)
      		character.x = character.x + (character.speed * dt)
   		end  
   		if love.keyboard.isDown("left") then
			character.anim:update(dt)
      		character.x = character.x - (character.speed * dt)
   		end 
   		if love.keyboard.isDown("a") and podeAtirar() then 
   			ultimoTiro = os.clock()   			
   			player.shoot()
   		end
   		if love.keyboard.isDown("d") and character.mana>=75 then
   			character.mana = character.mana-75
   			comecoEsmaece = os.clock()
   			apertou = true
   		end
   		if love.keyboard.isDown("p") then
   			gamestate = "onPause"
   		end
   		if love.keyboard.isDown("escape") then
   			love.audio.stop()
   			love.load()
   		end
   		if character.x<0 then character.x=0 end  
   		if character.x>largura-character.largura then character.x = largura-character.largura end
   		if apertou then 
   			love.audio.play(especial)
   			if os.clock()-comecoEsmaece>1.5 then 

   				for i in ipairs(enemies) do
   					enemies[i].hp = enemies[i].hp-50
   				end
   				esmaece = true
   				comecoEsmaece = os.clock()
   				nComeco = comecoEsmaece   	
   				apertou = false			
   			end
   		end
   		if esmaece then
   			love.audio.play(especial)

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
   				musica:setVolume(0.40)
   			else
   				musica:setVolume(0.75)
   			    apertou = false
   			    esmaece = false
   			    esmaecerTela = false
   			end

   		end
   		
   		if character.mana>100 then 
   			character.mana = 100
   		end
   		if #enemies==0 then 
   			ponei = require ("Prefabs/ponei")
   			ponei.zera()
   			table.insert(enemies, ponei)			
   		end
   		
	elseif gamestate == "onPause" then
		musica:pause()
		especial:pause()
		tempoDePausa = os.clock()-tempoDeJogo
		if love.keyboard.isDown("p") then
   			gamestate = "onPlay"
   		end

	elseif gamestate == "over" then
		musica:pause()
		especial:pause()
		
		if love.keyboard.isDown("m") then
			love.load()			
		end
		if love.keyboard.isDown("r") then
			carregaGame()
			gamestate = "onPlay"			
		end
		
	elseif gamestate == "credits" then

	end
	
end

--Draw Objects
function love.draw(dt)
	if gamestate == "intro" then

	elseif gamestate == "menu" then
		love.graphics.print("Press space to start the best game of the world")

	elseif gamestate == "onPlay" or gamestate == "onPause" then
		love.graphics.draw(backGround, quadBack, 0, 0)		
		love.graphics.draw(floor, quadFloor, 0, altura-floor:getHeight())
		player.draw(altura)
		
		local i	

		for i in ipairs(enemies) do
			enemies[i].draw()
		end

		
		if esmaecerTela then 
			love.graphics.setColor(250, 250, 250)
			love.graphics.rectangle("fill", 0, 0, largura, altura)
		end
		if gamestate == "onPause" then
			local image = love.graphics.newImage("Sprites/paused.png")
			love.graphics.draw(image, (largura-image:getWidth())/2, (altura-image:getHeight())/2)
		end
	elseif gamestate == "over" then
		love.graphics.print("Score: "..character.pontos)
		love.graphics.print("Best Score: "..player.atualizaBestScore(), 0, 15)
		love.graphics.print("M - Menu", 0, 30)
		love.graphics.print("R - Try Again", 0, 45)
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
		enemies[i].anim:update(dt)
		enemies[i].ataca(character.x+character.largura/2, character.y, enemies[i].x, enemies[i].y, tempoDeJogo)
		enemies[i].move(love.graphics.getWidth(), love.graphics.getHeight())		
		for j in ipairs(enemies[i].tiros) do
			enemies[i].tiros[j].ty = enemies[i].tiros[j].ty+1*enemies[i].tiros[j].tspeed
			if CheckCollision(enemies[i].tiros[j].tx, enemies[i].tiros[j].ty, enemies[i].tiros[j].tSprite:getWidth(), enemies[i].tiros[j].tSprite:getHeight(), character.x, character.y, character.largura, character.altura) then
				gamestate = "over"
			end
			if  (enemies[i].tiros[j].ty < -20) or (enemies[i].tiros[j].ty > altura) then
			 	table.remove(enemies[i].tiros, j)
			end
		end
		for j in ipairs(player.bullets) do
			if CheckCollision(enemies[i].x, enemies[i].y, enemies[i].largura, enemies[i].altura, player.bullets[j].bx, player.bullets[j].by, player.bullets[j].bimage:getWidth(), player.bullets[j].bimage:getHeight())  then
				enemies[i].hp = enemies[i].hp - 5
				character.pontos = character.pontos+5
				player.bullets[j].by = -25
			end
		end
		if enemies[i].hp <= 0 then
			character.pontos = character.pontos+50
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
