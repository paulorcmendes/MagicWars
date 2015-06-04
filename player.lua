--Imports
local anim8 = require 'anim8'

local M = {}

local mana
local robe = {}
local currentRobe

function getRobes()
	 --nothing
end
function reloadPlayer()
	mana = 5 + robe[currentRobe].mana
end
getRobes()
reloadPlayer()

function invokePlayer()
	local character = {mana, robe}
	return character
end

M.invokePlayer = invokePlayer
return M