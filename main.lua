--##Game Logic
--#Imports
local menu  = require "menu"
local nuvem = require "Prefabs/nuvem"
local gameOver = require "gameOver"
local credits = require("States/credits")
local player = require("Prefabs/player")
local anim8 = require ("Lib/anim8")
local enemyOne = require ("Prefabs/enemyOne")
local enemies = {}
local apertou
local largura = love.graphics.getWidth()
local altura = love.graphics.getHeight()
local character = player.load(largura, altura)
local tempoDeJogo
local tempoDePausa = 0
local codigoInimigo
local backgroundAnim
local backGround
local corBack = 250
local decCorBack = 0.5
local menuSound = love.audio.newSource("Sounds/menu.mp3")


--#Variables
local gamestate = 0 --[[ intro - menu - onPlay - onPause - over - credits ]]

--#On Start
function  love.load()
	if gamestate == 0 then 
		gamestate = "menu"
	end
	if gamestate == "intro" then

	elseif gamestate == "menu" then
		love.window.setFullscreen(true)	
		gamestate = "menu"
		menu.menu_load()	
		
	elseif gamestate == "onPlay" or gamestate == "onPause" then
		carregaGame()
	elseif gamestate == "over" then
		gameOver.gameOver_load()
		
	elseif gamestate == "credits" then
		credits.credits_load()
	end
   
end
function carregaGame()	
	nuvem.carrega()
	codigoInimigo = 0
	enemies = {}
	enemyOne.zera(codigoInimigo)
	enemies[1] = enemyOne
	character = player.load(largura, altura)		
	esmaecerTela = false
	apertou = false
	esmaece = false
	musica = love.audio.newSource("Sounds/sound.mp3")
	musica:setVolume(0.75)
	backGround = love.graphics.newImage("Sprites/teste.png")		
end
--#On every frame
function love.update(dt)

	if gamestate == "intro" then

	elseif gamestate == "menu" then
		menuSound:play()
		mousex = love.mouse.getX()
		mousey = love.mouse.getY()
		menu.menu_check()
	
	elseif gamestate == "onPlay" then
		--backgroundAnim:update(dt)
		menuSound:stop()
		player.magoHead.anim:update(dt)
		enemies = player.atualizaEspecial(enemies)
		nuvem.atualiza(dt)
		tempoDeJogo = os.clock()-tempoDePausa
		character.mana=character.mana+0.03
		musica:play()
   		updateEnemies(dt)
      	


		if love.keyboard.isDown("right") then
			character.anim:update(dt)
      		character.x = character.x + (character.speed * dt)
   		elseif love.keyboard.isDown("left") then
			character.anim:update(dt)
      		character.x = character.x - (character.speed * dt)

   		end 
   		if love.keyboard.isDown("a") then    			  			
   			player.shoot()
   		end
   		if love.keyboard.isDown("s") then
   			player.ativaEspecial() 				
   		end
   		if love.keyboard.isDown("p") then
   			gamestate = "onPause"
   		end
   		if love.keyboard.isDown("escape") then
   			love.audio.stop()
   			gamestate = "menu"
   			love.load()
   		end
   		if character.x<0 then character.x=0 end  
   		if character.x>largura-character.largura then character.x = largura-character.largura end
   		
   		
   		if character.mana>100 then 
   			character.mana = 100
   		end
   		corBack = corBack+decCorBack
		if corBack < 60 or corBack> 250 then 
			decCorBack = decCorBack*-1
		end  

   		
	elseif gamestate == "onPause" then
		menuSound:stop()
		musica:pause()
		player.especial:pause()
		tempoDePausa = os.clock()-tempoDeJogo
		if love.keyboard.isDown("p") then
   			gamestate = "onPlay"   			
   		end

	elseif gamestate == "over" then
		menuSound:play()
		musica:pause()
		player.especial:pause()
		
		mousex = love.mouse.getX()
		mousey = love.mouse.getY()
		gameOver.gameOver_check()
		
	elseif gamestate == "credits" then
		menuSound:play()
		mousex = love.mouse.getX()
		mousey = love.mouse.getY()
		credits.credits_check()
	end
	
end

--Draw Objects
function love.draw(dt)
	if gamestate == "intro" then

	elseif gamestate == "menu" then
		menu.menu_draw()

	elseif gamestate == "onPlay" or gamestate == "onPause" then
		
		love.graphics.setColor(255, corBack, corBack)
		love.graphics.draw(backGround, 0, 0)
		love.graphics.setColor(255, 255, 255)
		nuvem.desenha()
		player.draw()
		
		local i	

		for i in ipairs(enemies) do
			enemies[i].draw()
		end
		
		if gamestate == "onPause" then
			local image = love.graphics.newImage("Sprites/paused.png")
			love.graphics.draw(image, (largura-image:getWidth())/2, (altura-image:getHeight())/2)
		end
	elseif gamestate == "over" then
		gameOver.gameOver_draw(character, player)

	elseif gamestate == "credits" then
		credits.credits_draw()
	end
	
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
	if #enemies==0 then 
   		enemyOne = require ("Prefabs/enemyOne")
   		codigoInimigo = codigoInimigo+1
   		enemyOne.zera(codigoInimigo)
   		table.insert(enemies, enemyOne)			
   	end
	for i in ipairs(enemies) do

		enemies[i].anim:update(dt)
		enemies[i].ataca(character.x+character.largura/2, character.y, enemies[i].x, enemies[i].y, tempoDeJogo)
		enemies[i].move(love.graphics.getWidth(), love.graphics.getHeight())		
		for j in ipairs(enemies[i].tiros) do
			enemies[i].tiros[j].ty = enemies[i].tiros[j].ty+1*enemies[i].tiros[j].tspeed
			if CheckCollision(enemies[i].tiros[j].tx, enemies[i].tiros[j].ty, enemies[i].tiros[j].tSprite:getWidth(), enemies[i].tiros[j].tSprite:getHeight(), character.x, character.y, character.largura, character.altura) then
				gamestate = "over"
				love.load()
			end
			if  (enemies[i].tiros[j].ty > altura-40) or (enemies[i].tiros[j].ty < -20) then
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


function love.mousepressed(x,y)
	local retorno
	if gamestate == "menu" then
		retorno = menu.menu_click(x,y)	
		if retorno ~= nil then 
			gamestate = retorno
			love.load()
		end
	elseif gamestate == "over" then
		retorno = gameOver.gameOver_click(x,y)	
		if retorno ~= nil then 
			gamestate = retorno
			love.load()
		end	
	elseif gamestate == "credits" then
		retorno = credits.credits_click(x,y)	
		if retorno ~= nil then 
			gamestate = retorno
			love.load()
		end
	end

end