--Imports
local anim8 = require ("Lib/anim8")
local saveFile = require ("Lib/saveFile")
local player = {}
local nomeArquivo = "player.sav"
local defaultMana = 100
local defaultRobe = 1
local character ={}
local defaultPontos = 0
local defaultSpeed = 300
local bullets = {}
local quadBack
local quadManaBack
local manaBack
local manaBar
local backGround
function draw(altura)
	character.anim:draw(character.image, character.x, character.y)	
	for i in ipairs(player.bullets) do
		love.graphics.circle('fill', player.bullets[i].bx, player.bullets[i].by, 5, 5)
	end
	love.graphics.print("Score: "..character.pontos)
   	quadManaBack = love.graphics.newQuad(0, 0, character.mana*294/100, manaBack:getHeight()/2, manaBack:getWidth(), manaBack:getHeight()/2)
	love.graphics.draw(manaBack, quadManaBack, 10, 15)
	love.graphics.draw(manaBar, 7.5, 12.5)

end
function savePlayer()
	success = love.filesystem.write(nomeArquivo , saveFile.tableShow(character, "loadedPlayer"))
end
function shoot()
	character.mana = character.mana-2
	table.insert(bullets, {
			bx = character.x+character.largura,
			by = character.y,
			bspeed = 600
	})
end
function atualizaBestScore()
	existeArquivo = love.filesystem.exists(nomeArquivo)

	if existeArquivo then 
		chunk = love.filesystem.load(nomeArquivo)	
		chunk()		
	else			
		savePlayer()
		atualizaBestScore()
	end
	
	if character.pontos>loadedPlayer.pontos then 
		savePlayer()
	end 
	chunk = love.filesystem.load(nomeArquivo)	
	chunk()	
	return loadedPlayer.pontos

end

function load(largura, altura)
	-- character = getSavedCharacter()
	character.largura = 60
	character.altura = 100
	character.pontos = defaultPontos	
	character.mana = defaultMana  
	character.speed = defaultSpeed 
	bullets = {}
	player.bullets = bullets
	manaBack = love.graphics.newImage("Sprites/manaBack.png")
	manaBack:setWrap( "repeat", "repeat" )
	quadManaBack = love.graphics.newQuad(0, 0, character.mana*294/100, manaBack:getHeight()/2, manaBack:getWidth(), manaBack:getHeight()/2)
	manaBar = love.graphics.newImage("Sprites/manaBar.png")

	character.x = ((largura-character.largura)/2)  
	character.y = altura-character.altura-20
	
	if defaultRobe == 1 then
		nomeImagem = "Sprites/mago.png"
	end

	image = love.graphics.newImage(nomeImagem)
	local g = anim8.newGrid(character.largura, character.altura, image:getWidth(), image:getHeight())
	character.image = image
	character.anim = anim8.newAnimation(g('1-3',1), 0.1)	
	return character
end



player.atualizaBestScore = atualizaBestScore
player.load = load
player.shoot = shoot
player.draw = draw

return player
