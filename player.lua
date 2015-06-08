--Imports
local anim8 = require 'anim8'
local saveFile = require 'saveFile'
local M = {}
local defaultMana = 5
local defaultRobe = 1
local character ={}
local defaultSpeed = 5

function savePlayer()
	success = love.filesystem.write( "character.sav", saveFile.tableShow(character, "loadedCharacter"))
end
function getSavedCharacter()
	chunk = love.filesystem.load( "character.sav" )
	chunk()
	return loadedCharacter
end

function invokeCharacter()
	if defaultRobe == 1 then
		image = love.graphics.newImage("white.png")
		local g = anim8.newGrid(47, 48, image:getWidth(), image:getHeight())
		character.mana = defaultMana + defaultRobe
		character.image = image
		character.anim = anim8.newAnimation(g('4-6',1), 0.1)
		character.speed = defaultSpeed + defaultRobe
	end
	return character
end



--savePlayer()
--character = getSavedCharacter()

M.invokeCharacter = invokeCharacter

return M
