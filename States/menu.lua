button={}
M = {}


function menu_load()
	button={}
	background = love.graphics.newImage("Sprites/menuPrincipal.png")
	playButton = love.graphics.newImage("Sprites/playButton.png")
	creditsButton = love.graphics.newImage("Sprites/creditsButton.png")
	quitButton = love.graphics.newImage("Sprites/quitButton.png")

	table.insert(button, {x=600,y=300,image=playButton,id="play", mouseover=false})
	table.insert(button, {x=700,y=425,image=creditsButton,id="credits", mouseover=false})
	table.insert(button, {x=800,y=550,image=quitButton,id="quit", mouseover=false})
end

function menu_draw()
	love.graphics.draw(background, 0, 0)
	--mouseOver: se o mouse está em cima do botão
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
end

function menu_click(x,y)
	for i,v in ipairs(button) do
		if x> v.x and x< v.x +v.image:getWidth() and y> v.y and y< v.y + v.image:getHeight() then
			if v.id=="quit" then
				love.event.quit()
			end
			if v.id=="play" then
				return "onPlay"
			end
			if v.id=="credits" then 
				return "credits"
			end
		end
	end
end


function menu_check()
	for i,v in ipairs(button) do
		if mousex> v.x and mousex<v.x + v.image:getWidth() and mousey> v.y and mousey<v.y + v.image:getHeight() then
			v.mouseover=true
		else
			v.mouseover=false
		end
	end
end


M.menu_check = menu_check
M.menu_click = menu_click
M.menu_draw = menu_draw
M.menu_load = menu_load

return M