function love.conf(t)
   t.window.width = 1366 -- t.screen.width in 0.8.0 and earlier
   t.window.height = 758-- t.screen.height in 0.8.0 and earlier
   t.window.borderless = false -- Remove all border visuals from the window (boolean)
   t.window.resizable = t       -- Let the window be user-resizable (boolean)
   t.window.minwidth = 800             
   t.window.minheight = 600
   t.window.title = "Magic Wars - Avoid The Darkness" 
    t.window.icon = "Sprites/icon.png"
   t.identity = "mw-ad"  
end