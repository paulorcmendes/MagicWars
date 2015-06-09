--Imports
local anim8 = require 'anim8'
local saveFile = require 'saveFile'
local M = {}
local nomeArquivo = "character.sav"
local defaultMana = 5
local defaultRobe = 1
local character ={}
local defaultSpeed = 5

function savePlayer()
	success = love.filesystem.write(nomeArquivo , saveFile.tableShow(character, "loadedCharacter"))
end
function getSavedCharacter()
	existeArquivo = love.filesystem.exists(nomeArquivo)

	if existeArquivo then 
		chunk = love.filesystem.load(nomeArquivo)	
		chunk()
	else		
		character.mana = defaultMana + defaultRobe
		character.speed = defaultSpeed + defaultRobe
		savePlayer()
		getSavedCharacter()
	end
	
	return loadedCharacter
end

function invokeCharacter()
	character = getSavedCharacter()
	if defaultRobe == 1 then
		nomeImagem = "white.png"
	end

	image = love.graphics.newImage(nomeImagem)
	local g = anim8.newGrid(47, 48, image:getWidth(), image:getHeight())
	character.image = image
	character.anim = anim8.newAnimation(g('4-6',1), 0.1)
	
	return character
end





M.invokeCharacter = invokeCharacter

return M
