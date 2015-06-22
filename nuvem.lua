math.randomseed(os.time())
local anim8 = require ("anim8")
nuvem = {}
r = {}
function carrega()
	nuvem = {}
	w = love.window.getWidth()
	r.image = love.graphics.newImage('Sprites/nuvem.png')
	local g = anim8.newGrid(200, 345, r.image:getWidth(), r.image:getHeight())
  	r.anim = anim8.newAnimation(g('1-5',1), 0.3)

	for i = 1,10 do
		table.insert(nuvem, {x = math.random(0,1400),
							velocidade = math.random(1, 5)})
	end
end
function atualiza(dt)

	r.anim:update(dt)
	for  i = 1,10 do
		nuvem[i].x = nuvem[i].x -nuvem[i].velocidade/10
		if nuvem[i].x < 0-r.image:getWidth() then
			nuvem[i].x = math.random(1400,1500)
		end
	end	
end
function desenha()
	for i = 1,10 do
		r.anim:draw(r.image, nuvem[i].x, i*20)
	end

end

r.carrega = carrega
r.atualiza = atualiza
r.desenha = desenha

return r
