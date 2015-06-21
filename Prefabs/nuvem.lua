nuvem = {}
r = {}
function carrega()
	w = love.window.getWidth()
	image = love.graphics.newImage('Sprites/nuvem.png')
	r.image = image
	for i = 1,10 do
		table.insert(nuvem, {x = love.math.random(0,1400),
							velocidade = love.math.random(1, 5)})
	end
end
function atualiza()
	for  i = 1,10 do
		nuvem[i].x = nuvem[i].x -nuvem[i].velocidade/10
		if nuvem[i].x < 0-image:getWidth() then
			nuvem[i].x = love.math.random(1400,1500)
		end
	end	
end
function desenha()
	for i = 1,10 do
		love.graphics.draw(r.image,nuvem[i].x, i*20)
	end

end

r.carrega = carrega
r.atualiza = atualiza
r.desenha = desenha

return r
