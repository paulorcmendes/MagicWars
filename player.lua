--Imports
local anim8 = require 'anim8'
local saveFile = require 'saveFile'
local M = {}
local mana = 100
local robe
local character = {mana, robe}

function savePlayer()
	success = love.filesystem.write( "character.sav", saveFile.tableShow(character, "loadedCharacter"))	
end
function getSavedCharacter()
	chunk = love.filesystem.load( "character.sav" )
	chunk()
	return loadedCharacter
end
function reloadCharacter()
	character[1] = character[1]+5

end
function invokeCharacter()	
	return character
end



savePlayer()
character = getSavedCharacter()
reloadCharacter()
M.invokeCharacter = invokeCharacter

return M