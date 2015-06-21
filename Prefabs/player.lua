--Imports
local anim8 = require ("Lib/anim8")
local saveFile = require ("Lib/saveFile")
local player = {}
local nomeArquivo = "player.sav"
local especial = love.audio.newSource("Sounds/especial.mp3")
local defaultMana = 100
local defaultRobe = 1
local tempoDeTiro = 0.2
local tempoDeEspecial = 3
local character ={}
local defaultPontos = 0
local defaultSpeed = 300
local bullets = {}
local magoHead = {}
local quadBack
local quadManaBack
local manaBack
local manaBar
local backGround
local largura = love.graphics.getWidth()
local altura = love.graphics.getHeight()

function draw()

	character.anim:draw(character.image, character.x, character.y)	
	for i in ipairs(player.bullets) do
		love.graphics.draw(player.bullets[i].bimage, player.bullets[i].bx, player.bullets[i].by)
	end
	love.graphics.setFont(scoreFont)
	love.graphics.setColor(150,150,150)
	love.graphics.print("Score: "..character.pontos, 70, 5)
	love.graphics.setColor(255,255,255)
   	quadManaBack = love.graphics.newQuad(0, 0, character.mana*294/100, manaBack:getHeight()/3, manaBack:getWidth(), manaBack:getHeight()/3)
	love.graphics.draw(manaBack, quadManaBack, 65, 45)
	love.graphics.draw(manaBar, 5.5, 4.5)
	magoHead.anim:draw(magoHead.image, 10, -8)	
	if character.mana>=50 and podeJogarEspecial() then 
		love.graphics.draw(love.graphics.newImage("Sprites/bs.png"), 110, 70)
	end
	if character.mana>=2 then 
		love.graphics.draw(love.graphics.newImage("Sprites/ba.png"), 70, 70)
	end	
	if esmaecerTela then 
		love.graphics.setColor(250, 250, 250)
		love.graphics.rectangle("fill", 0, 0, largura+50, altura+50)
	end

end
function podeAtirar()
	local tempo
	if (os.clock()-ultimoTiro)<tempoDeTiro then
		tempo = false
	else
	    tempo = true
	end	
	return tempo and character.mana>=2
end
function podeJogarEspecial()
	local tempo
	if (os.clock()-ultimoEspecial)<tempoDeEspecial then
		tempo = false
	else
	    tempo = true
	end	
	return tempo and character.mana>=50
end
function savePlayer()
	success = love.filesystem.write(nomeArquivo , saveFile.tableShow(character, "loadedPlayer"))
end
function shoot()
	if podeAtirar() then
		ultimoTiro = os.clock()
		character.mana = character.mana-2
		table.insert(bullets, {
				bimage = love.graphics.newImage("Sprites/bullet.png"),
				bx = character.x+character.largura-22,
				by = character.y,
				bspeed = 600
		})
	end
end
function atualizaBestScore()
	existeArquivo = love.filesystem.exists(nomeArquivo)

	if existeArquivo then 
		chunk = love.filesystem.load(nomeArquivo)	
		chunk()		
	else			
		savePlayer()
		atualizaBestScore()
	end
	
	if character.pontos>loadedPlayer.pontos then 
		savePlayer()
	end 
	chunk = love.filesystem.load(nomeArquivo)	
	chunk()	
	return loadedPlayer.pontos

end

function load(largura, altura)
	-- character = getSavedCharacter()
	especial:setVolume(5)	

	scoreFont = love.graphics.setNewFont("Font/score.ttf", 30)
	character.largura = 110
	character.altura = 150
	character.pontos = defaultPontos	
	character.mana = defaultMana  
	character.speed = defaultSpeed
	ultimoTiro = os.clock()-tempoDeTiro
	ultimoEspecial = os.clock()-tempoDeEspecial
	esmaece = false
	apertou = false
	bullets = {}
	player.bullets = bullets
	manaBack = love.graphics.newImage("Sprites/manaBack.png")
	manaBack:setWrap( "repeat", "repeat" )
	quadManaBack = love.graphics.newQuad(0, 0, character.mana*294/100, manaBack:getHeight()/2, manaBack:getWidth(), manaBack:getHeight()/2)
	manaBar = love.graphics.newImage("Sprites/manaBar.png")

	magoHead.image = love.graphics.newImage("Sprites/magoHead.png")
	local g = anim8.newGrid(45, 100, magoHead.image:getWidth(), magoHead.image:getHeight())
	magoHead.anim = anim8.newAnimation(g('1-6', 1), 0.2)

	character.x = ((largura-character.largura)/2)  
	character.y = altura-character.altura-20
	
	if defaultRobe == 1 then
		nomeImagem = "Sprites/mago.png"
	end

	image = love.graphics.newImage(nomeImagem)
	local g = anim8.newGrid(character.largura, character.altura, image:getWidth(), image:getHeight())
	character.image = image
	character.anim = anim8.newAnimation(g('1-4',1), 0.1)
		
	return character
end
function ativaEspecial() 
	if podeJogarEspecial() then 
		ultimoEspecial = os.clock()
		apertou = true		
	   	comecoEsmaece = os.clock() 	
	   	character.mana = character.mana-50		   	
    end

   
end
function atualizaEspecial(enemies)
	if apertou then 
   		love.audio.play(especial)
   		if os.clock()-comecoEsmaece>1.5 then 
			esmaece = true
			comecoEsmaece = os.clock()
			nComeco = comecoEsmaece  			
	   		apertou = false
	   		for i in ipairs(enemies) do
				enemies[i].hp = enemies[i].hp-50
			end	
	   		character.pontos = character.pontos+10
		end
   	end
	if esmaece then
		love.audio.play(especial)

   		tAtual = os.clock()
   		if tAtual-comecoEsmaece<=1 then
   			if tAtual-nComeco<=0.02 then 
   				esmaecerTela = true
   			else 
   				esmaecerTela = false
   			end
   			if tAtual-nComeco>0.04 then
   				nComeco = tAtual
   			end
   			musica:setVolume(0.40)
   		else
   			musica:setVolume(0.75)
   		    apertou = false
   		    esmaece = false
   		    esmaecerTela = false
   		end
   	end
   	return enemies
end

player.ativaEspecial = ativaEspecial
player.especial = especial
player.atualizaBestScore = atualizaBestScore
player.atualizaEspecial = atualizaEspecial
player.load = load
player.shoot = shoot
player.draw = draw
player.magoHead = magoHead

return player
