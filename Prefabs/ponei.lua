e = {}
local hp = 100
local tiros = {}
local campoDeVisao = 15
local incremento = 2
local tempoDeTiro = 0.2
local ultimoTiro = os.clock()-tempoDeTiro
local x = 0
local y = 0

--local ultimoTiro = os.clock()-tempoDeTiro
function zera()
	e.x = x
	e.y = y
	e.hp = hp
	e.tiros = tiros
end
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
				tx = enemyX+shoot:getWidth()/2,
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


e.zera = zera
e.zera()
e.sprite = invokeEnemy()
e.move = move
e.ataca = ataca

return e