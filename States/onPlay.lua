local nuvem = require "Prefabs/nuvem"
local player = require("Prefabs/player")
local enemyOne = require ("Prefabs/enemyOne")
local musica = love.audio.newSource("Sounds/sound.mp3")
local enemies = {}
local tempoDeJogo = 0
local tempoDePausa = 0
local codigoInimigo
local corBack = 250
local decCorBack = 0.5
local largura = love.graphics.getWidth()
local altura = love.graphics.getHeight()
local r = {}
local onPlay

function load()	

	onPlay = true
	nuvem.carrega()	
	corBack = 250
	codigoInimigo = 0
	enemies = {}
	enemyOne.zera(codigoInimigo)
	enemies[1] = enemyOne
	character = player.load(tempoDeJogo)		
	backGround = love.graphics.newImage("Sprites/teste.png")		
end

function atualiza(dt)
	if onPlay then
		player.update(tempoDeJogo, dt)		
		r.character = character		
		enemies = player.atualizaEspecial(enemies)
		nuvem.atualiza(dt)
		tempoDeJogo = os.clock()-tempoDePausa
		musica:play()
	   	updateEnemies(dt)
		if love.keyboard.isDown("right") then
			character.anim:update(dt)
	   		character.x = character.x + (character.speed * dt)
		elseif love.keyboard.isDown("left") then
			character.anim:update(dt)
	   		character.x = character.x - (character.speed * dt)
	  	end 
	   	if love.keyboard.isDown("a") then    			  			
	   		player.shoot()
	   	end
	   	if love.keyboard.isDown("s") then
	   		player.ativaEspecial() 				
	   	end
	  
	   	if love.keyboard.isDown("escape") then
	   		r.musica:stop()   		
	   		return "menu"	   		
	   	end
	   	if character.life<=0 then 
	   		return "over"
	   	end
	   	if character.x<0 then character.x=0 end  
	   	if character.x>largura-character.largura then character.x = largura-character.largura end
	   		
	   		
	   	if character.mana>100 then 
	   		character.mana = 100
	   	end
	   	corBack = corBack+decCorBack
		if corBack < 60 or corBack> 250 then 
			decCorBack = decCorBack*-1
		end  
	else 
		tempoDePausa = os.clock()-tempoDeJogo
		musica:pause()
		player.especial:pause()
		--love.keypressed()
	end
	
end

function love.keypressed(key)
	    
	if key == "p" then
		if onPlay then
	    	onPlay = false
	    else 
	        onPlay = true
	    end
	end
end

function draw()
	love.graphics.setColor(255, corBack, corBack)
	love.graphics.draw(backGround, 0, 0)
	love.graphics.setColor(255, 255, 255)
	nuvem.desenha()
	player.draw()
	
	local i	

	for i in ipairs(enemies) do
		enemies[i].draw()
	end
		
	if not(onPlay) then
		local image = love.graphics.newImage("Sprites/paused.png")
		love.graphics.draw(image, (largura-image:getWidth())/2, (altura-image:getHeight())/2)
	end
end
function updateEnemies(dt)
	local i 
	local j

	--Se não existirem inimigos, zera o inimigo e insere no vetor
	if #enemies==0 then 
   		enemyOne = require ("Prefabs/enemyOne")
   		codigoInimigo = codigoInimigo+1
   		enemyOne.zera(codigoInimigo)
   		table.insert(enemies, enemyOne)			
   	end


	for i in ipairs(enemies) do

		enemies[i].anim:update(dt)
		enemies[i].ataca(character.x+character.largura/2, character.y, enemies[i].x+enemies[i].largura/2, enemies[i].y, tempoDeJogo)
		enemies[i].move(love.graphics.getWidth(), love.graphics.getHeight())

		--Percorre os tiros, atualizando sua velocidade. Se algum colidir com o personagem, a vida eh removida e a bala tbm. Se a bala sair do mapa ela eh removida
		for j in ipairs(enemies[i].tiros) do
			enemies[i].tiros[j].ty = enemies[i].tiros[j].ty+1*enemies[i].tiros[j].tspeed
			if CheckCollision(enemies[i].tiros[j].tx, enemies[i].tiros[j].ty, enemies[i].tiros[j].tSprite:getWidth(), enemies[i].tiros[j].tSprite:getHeight(), character.x, character.y, character.largura, character.altura) then
				character.life = character.life-1
				table.remove(enemies[i].tiros, j)
			elseif  (enemies[i].tiros[j].ty > altura-40) or (enemies[i].tiros[j].ty < -20) then
			 	table.remove(enemies[i].tiros, j)
			end
		end

		--Percorre os tiros do player. Checa se a bala colidi com o inimigo, se colidir ela sai da tela para depois ser removida
		for j in ipairs(player.bullets) do
			if CheckCollision(enemies[i].x, enemies[i].y, enemies[i].largura, enemies[i].altura, player.bullets[j].bx, player.bullets[j].by, player.bullets[j].bimage:getWidth(), player.bullets[j].bimage:getHeight())  then
				enemies[i].hp = enemies[i].hp - 5
				character.pontos = character.pontos+5
				player.bullets[j].by = -25
			end
		end

		--Se um inimigo morre, são adicionados pontos e o inimigo eh removido
		if enemies[i].hp <= 0 then
			character.pontos = character.pontos+50
			table.remove(enemies, i)
		end	

	end

	-- Se a bala do player estiver fora da tela, então ela será removida
	for i in ipairs(player.bullets) do
		player.bullets[i].by = player.bullets[i].by - 1* player.bullets[i].bspeed * dt		
		if  (player.bullets[i].by < -20) or (player.bullets[i].by > love.graphics.getHeight() + 20) then
			table.remove(player.bullets, i)
		end
	end

end


function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

r.musica = musica
r.character = character
r.player = player
r.atualiza = atualiza
r.draw = draw 
r.load = load

return r