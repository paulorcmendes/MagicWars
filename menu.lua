button={}

function menu_load()
	image = love.graphics.newImage("Sprites/enemy.png")
	table.insert(button, {x=400,y=200,image=image,id="play", mouseover=false})
end

function menu_draw()
	for i,v in ipairs(button) do
		if v.mouseover == false then
			love.graphics.setColor(245,245,0)
		elseif
			v.mouseover == true then
			love.graphics.setColor(0,222,222)
		end
		love.graphics.draw(v.image, v.x,v.y)
	end
end

function menu_click(x,y)
	for i,v in ipairs(button) do
		if x> v.x and x< v.x +v.image:getWidth() and y> v.y and y< v.y + v.image:getHeight() then
			if v.id=="quit" then
				
			end
			if v.id=="play" then
				return "onPlay"
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


