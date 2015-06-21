local M = {}
button={}

function gameOver_load()
	velocidade = 2
	i = 0	
	button={}
	scoreFont = love.graphics.setNewFont("Font/score.ttf", 30)
	background = love.graphics.newImage("Sprites/gameOver.png")
	menuButton = love.graphics.newImage("Sprites/menuButton.png")
	tryAgainButton = love.graphics.newImage("Sprites/tryAgainButton.png")

	table.insert(button, {x=683-menuButton:getWidth()-10,y=250,image=menuButton,id="menu", mouseover=false})
	table.insert(button, {x=683+10,y=250,image=tryAgainButton,id="tryAgain", mouseover=false})
end

function gameOver_draw(character, player)
	love.graphics.draw(background, 0, 0)
	for i,v in ipairs(button) do
		if v.mouseover == false then
			love.graphics.setColor(255,255,255)
		elseif
			v.mouseover == true then
			love.graphics.setColor(100,100,100)
		end
		love.graphics.draw(v.image, v.x,v.y)
	end
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(scoreFont)
	score = character.pontos
	
	i = i+velocidade

	if i>=score then 
		i = score 
		velocidade = 0
	end 
	

	stringScore = ("Score: "..i)
	stringBestScore = ("Best Score: "..player.atualizaBestScore())
	love.graphics.print(stringScore, 683-scoreFont:getWidth(stringScore)/2, 390)
	if i==score then
 		love.graphics.print(stringBestScore, 683-scoreFont:getWidth(stringBestScore)/2, 430)
 	end 
	
end

function gameOver_click(x,y)
	for i,v in ipairs(button) do
		if x> v.x and x< v.x +v.image:getWidth() and y> v.y and y< v.y + v.image:getHeight() then
			if v.id=="menu" then
				return "menu"
			end
			if v.id=="tryAgain" then
				return "onPlay"
			end
		end
	end
end

function gameOver_check()
	for i,v in ipairs(button) do
		if mousex> v.x and mousex<v.x + v.image:getWidth() and mousey> v.y and mousey<v.y + v.image:getHeight() then
			v.mouseover=true
		else
			v.mouseover=false
		end
	end
end

M.gameOver_check = gameOver_check
M.gameOver_click = gameOver_click
M.gameOver_draw = gameOver_draw
M.gameOver_load = gameOver_load

return M
