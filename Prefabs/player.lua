--Imports
local anim8 = require ("Lib/anim8")
local saveFile = require ("Lib/saveFile")
local M = {}
local nomeArquivo = "character.sav"
local defaultMana = 100
local defaultRobe = 1
local character ={}
local defaultSpeed = 300
local bullets = {}


function savePlayer()
	success = love.filesystem.write(nomeArquivo , saveFile.tableShow(character, "loadedCharacter"))
end
function shoot()
	character.mana = character.mana-2
	table.insert(bullets, {
			bx = character.x+47/2,
			by = character.y-50,
			bspeed = 400
	})
end
function getSavedCharacter()
	existeArquivo = love.filesystem.exists(nomeArquivo)

	if existeArquivo then 
		chunk = love.filesystem.load(nomeArquivo)	
		chunk()
		savePlayer()
	else		
		
		savePlayer()
		--getSavedCharacter()
	end
	
	return loadedCharacter
end

function invokeCharacter()
	-- character = getSavedCharacter()
		character.x = 0
		character.y = 0
		character.mana = defaultMana  
		character.speed = defaultSpeed 
	if defaultRobe == 1 then
		nomeImagem = "Sprites/white.png"
	end

	image = love.graphics.newImage(nomeImagem)
	local g = anim8.newGrid(47, 48, image:getWidth(), image:getHeight())
	character.image = image
	character.anim = anim8.newAnimation(g('4-6',1), 0.1)
	
	return character
end




M.bullets = bullets
M.invokeCharacter = invokeCharacter
M.shoot = shoot

return M
