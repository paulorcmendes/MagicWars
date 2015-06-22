--##Game Logic
--#Imports
local onPlay = require "States/onPlay"
local menu  = require "States/menu"
local gameOver = require "States/gameOver"
local credits = require("States/credits")
local anim8 = require ("Lib/anim8")


--#Variables
local gamestate = 0 --[[ intro - menu - onPlay -  over - credits ]]
local largura = love.graphics.getWidth()
local altura = love.graphics.getHeight()
local backGround
local menuSound = love.audio.newSource("Sounds/menu.mp3")


--#On Start
function  love.load()
	if gamestate == 0 then 
		gamestate = "menu"
	end
	if gamestate == "menu" then
		love.window.setFullscreen(true)	
		menu.menu_load()	
		
	elseif gamestate == "onPlay"then
		onPlay.load()
	elseif gamestate == "over" then
		gameOver.gameOver_load()
		
	elseif gamestate == "credits" then
		credits.credits_load()
	end
   
end

--#On every frame
function love.update(dt)

	if gamestate == "menu" then
		menuSound:play()
		mousex = love.mouse.getX()
		mousey = love.mouse.getY()
		menu.menu_check()
	
	elseif gamestate == "onPlay" then

		--Recebe um gamestate do OnPlay
		retorno = onPlay.atualiza(dt)
		if retorno ~= nil then 
			gamestate = retorno
			love.load()
		end
		menuSound:stop()		

	elseif gamestate == "over" then
		menuSound:play()
		onPlay.musica:stop()
		onPlay.player.especial:stop()
		
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
	if gamestate == "menu" then
		menu.menu_draw()

	elseif gamestate == "onPlay" then
		onPlay.draw()
		
	elseif gamestate == "over" then
		gameOver.gameOver_draw(onPlay.character, onPlay.player)

	elseif gamestate == "credits" then
		credits.credits_draw()
	end	
end

function love.mousepressed(x,y)
	local retorno
	--Retornos de quando clica em cada coisa de cada gamestate
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