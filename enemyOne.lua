e = {}

local anim8 = require ("anim8")
local hp = 100
local tiros = {}
local incremento = 0.5
local tempoDeTiro = 0.5
local ultimoTiro = os.clock()-tempoDeTiro
local y = -100
local largura = 100
local altura = 101
local telaX = love.graphics.getWidth()
local telaY = love.graphics.getHeight()

function zera(codigoInimigo)
	e.altura = altura
	e.largura = largura
	campoDeVisao = e.largura/2
	incremento = 2

	if codigoInimigo<=5 then
		incremento=incremento+codigoInimigo/3
	else
		incremento=incremento+5
		campoDeVisao = campoDeVisao+(codigoInimigo-5)*5
	end

	e.y = y	
	--repeat 
	--	e.min = math.random(0, telaX/2-e.largura)
	--	e.max = math.random(telaX/2+e.largura, telaX)
	--until e.max - e.min > e.largura*1.5  
	e.min = 0
	e.max = telaX-e.largura
	e.x = math.random(e.min, e.max)
	e.hp = hp
	tiros = {}
	e.tiros = tiros
	e.image = love.graphics.newImage("Sprites/enemylocal.png")
	local g = anim8.newGrid(e.largura, e.altura, e.image:getWidth(), e.image:getHeight())
	e.anim = anim8.newAnimation(g('1-8', 1), 0.08)
end
function move()	
	--while e.max - e.min <=e.largura*1.5 do
	--	e.min = math.random(0, telaX/2-e.largura)
	--	e.max = math.random(telaX/2+e.largura, telaX)
	--end
	if e.y<120 then 
		e.y = e.y + incremento
	else
		if e.x>  e.max then 

			--while e.max - e.min <=e.largura*1.5 do
			--	e.min = math.random(0, telaX/2-e.largura)
			--end
			incremento = incremento*-1
		end
		if e.x<e.min then
			--while e.max - e.min <=e.largura*1.5 do
			--	e.max = math.random(telaX/2+e.largura, telaX)
			--end
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
		if (playerX >= enemyX-campoDeVisao  and playerX  <= enemyX + campoDeVisao and e.y>=50) then
			ultimoTiro = tempoDeJogo
			shoot = love.graphics.newImage("Sprites/bolaArcoiris.png")

			table.insert(tiros, {
				tSprite = shoot,
				tx = enemyX-shoot:getWidth()/2,
				ty = enemyY,
				tspeed = 2
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

e.zera = zera
e.move = move
e.ataca = ataca
e.draw = draw

return e