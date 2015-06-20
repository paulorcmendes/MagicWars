button={}
M = {}


function credits_load()
	button={}
	background = love.graphics.newImage("Sprites/credits.png")
	menuButton = love.graphics.newImage("Sprites/menuButton.png")
	table.insert(button, {x=375,y=620,image=menuButton,id="menu", mouseover=false})

end

function credits_draw()
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
end

function credits_click(x,y)
	for i,v in ipairs(button) do
		if x> v.x and x< v.x +v.image:getWidth() and y> v.y and y< v.y + v.image:getHeight() then
			if v.id=="menu" then
				return "menu"
			end
		end
	end
end


function credits_check()
	for i,v in ipairs(button) do
		if mousex> v.x and mousex<v.x + v.image:getWidth() and mousey> v.y and mousey<v.y + v.image:getHeight() then
			v.mouseover=true
		else
			v.mouseover=false
		end
	end
end


M.credits_check = credits_check
M.credits_click = credits_click
M.credits_draw = credits_draw
M.credits_load = credits_load

return M