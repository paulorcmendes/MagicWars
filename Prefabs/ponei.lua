e = {}
local anim8 = require ("Lib/anim8")
local hp = 100
local tiros = {}
local incremento = 5
local tempoDeTiro = 0.2
local ultimoTiro = os.clock()-tempoDeTiro
local x = 50
local y = -100
local largura = 100
local altura = 101

function zera()
	incremento = 5
	e.altura = altura
	e.largura = largura
	campoDeVisao = e.largura/2
	e.x = x
	e.y = y
	e.hp = hp
	tiros = {}
	e.tiros = tiros
	e.image = love.graphics.newImage("Sprites/enemylocal.png")
	local g = anim8.newGrid(e.largura, e.altura, e.image:getWidth(), e.image:getHeight())
	e.anim = anim8.newAnimation(g('1-8', 1), 0.08)
end
function move(telaX, telaY)	
	if e.y<50 then 
		e.y = e.y + incremento
	else
		if e.x>  telaX-e.largura  then 

			incremento = incremento*-1
		end
		if e.x<0 then
			incremento = incremento*-1
		end
		e.x = e.x+incremento
	end
end

function ataca(playerX, playerY, enemyX, enemyY, tempoDeJogo)
	
	local tempo
	if (tempoDeJogo-ultimoTiro)<tempoDeTiro then
		tempo = false
	else
	    tempo = true
	end	
	if  tempo then
		if (playerX - campoDeVisao < enemyX and enemyX < playerX + campoDeVisao and e.y>=50) then
			ultimoTiro = tempoDeJogo
			shoot = love.graphics.newImage("Sprites/bolaArcoiris.png")

			table.insert(tiros, {
				tSprite = shoot,
				tx = enemyX+e.largura/2,
				ty = enemyY,
				tspeed = 10
			})
		end
	end
end
function draw()
	e.anim:draw(e.image, e.x, e.y)
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", e.x, e.y+e.altura+10, e.largura/100*e.hp, 10)
	love.graphics.setColor(255, 255, 255)
	local j 
	for j in ipairs(e.tiros) do
		love.graphics.draw(e.tiros[j].tSprite, e.tiros[j].tx, e.tiros[j].ty)
	end
end

function invokeEnemy()
			
end


e.zera = zera
e.zera()
invokeEnemy()
e.move = move
e.ataca = ataca
e.draw = draw

return e