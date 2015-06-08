--Imports
local anim8 = require 'anim8'
local saveFile = require 'saveFile'
local M = {}
local mana = 5
local robe = 1
local character = {mana, robe}

function savePlayer()
	success = love.filesystem.write( "character.sav", saveFile.tableShow(character, "loadedCharacter"))
end
function getSavedCharacter()
	chunk = love.filesystem.load( "character.sav" )
	chunk()
	return loadedCharacter
end

function invokeCharacter()
	if robe == 1 then
		image = love.graphics.newImage("white.png")
		local g = anim8.newGrid(47, 48, image:getWidth(), image:getHeight())
		character[3] = image
		character[4] = anim8.newAnimation(g('4-6',1), 0.1)
	end
	return character
end



--savePlayer()
--character = getSavedCharacter()

M.invokeCharacter = invokeCharacter

return M
