e = {}
local hp = 1000000000
local tiros = {}
local campoDeVisao = 30000000
local incremento = 2
local tempoDeTiro = 2
--local ultimoTiro = os.clock()-tempoDeTiro

function move(telaX, telaY)	

	if e.x>  telaX-e.sprite:getWidth()  then 

		incremento = incremento*-1
	end
	if e.x<0 then
		incremento = incremento*-1
	end
	e.x = e.x+incremento
end

function ataca(playerX, playerY, enemyX, enemyY)
	e.hp = e.hp - 1
	local tempo
	if (os.clock()-ultimoTiro)<tempoDeTiro then
		tempo = false
	else
	    tempo = true
	end	
	if  tempo then
		if (playerX - campoDeVisao < enemyX and enemyX < playerX + campoDeVisao) then
			ultimoTiro = os.clock()
			shoot = love.graphics.newImage("Sprites/bolaArcoiris.png")

			table.insert(tiros, {
				tSprite = shoot,
				tx = enemyX,
				ty = enemyY,
				tspeed = 10
			})
		end
	end
end


function invokeEnemy()
	sprite = love.graphics.newImage("Sprites/enemy.png")
	return sprite	
end


e.x = 0
e.y = 0

e.hp = hp
e.tiros = tiros
e.sprite = invokeEnemy()
e.move = move
e.ataca = ataca

return e