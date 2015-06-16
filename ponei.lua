e = {}

tiros = {}
campoDeVisao = 2
incremento = 2
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
	if playerX - campoDeVisao < enemyX and enemyX < playerX + campoDeVisao then
		shoot = love.graphics.newImage("Sprites/bolaArcoiris.png")
		table.insert(tiros, {
			tSprite = shoot,
			tx = enemyX,
			ty = enemyY,
			tspeed = 400
		})
	end

end

function invokeEnemy()
	sprite = love.graphics.newImage("Sprites/enemy.png")
	return sprite	
end

e.x = 0
e.y = 0

e.tiros = tiros
e.sprite = invokeEnemy()
e.move = move
e.ataca = ataca

return e