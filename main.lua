-- Initialize variables
local playerName = ""
local customfont
local nameEntered = false -- Add a flag to track if the name has been entered




function love.load()
    love.window.setTitle("Cozy Tea Shop")
    --love.window.setMode(1200, 800)
    customfont = love.graphics.newFont("FontsLove/Starla.ttf",24) 
        love.window.setMode(2000,1200, {fullscreen = false})
    teas = love.graphics.newImage("AssetsLove/TeaSelection.png")
    background = love.graphics.newImage("AssetsLove/EmptyBar.png")
    desk = love.graphics.newImage("AssetsLove/desk.png")
   
end

function love.textinput(text)
      -- Handle text input only 
      if not nameEntered then
        playerName = playerName .. text
    end
end

function love.keypressed(key)
      -- Handle keypress events
      if not nameEntered then
        if key == "return" and #playerName > 0 then
            -- User pressed Enter and there is a name input
            welcomeMessage = "Welcome to " .. playerName .. "'s Tea House"
            nameEntered = true -- Set the flag to indicate that the name has been entered
        elseif key == "backspace" then
            -- Handle backspace to remove characters
            playerName = string.sub(playerName, 1, #playerName - 1)
        end
    end
end

function love.draw()
   
    --love.graphics.setColor(147, 0, 26) 
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(teas,0,0)
    love.graphics.draw(desk,0,0)
    

    love.graphics.setFont(customfont)
    
   
    if not nameEntered then
        love.graphics.print("Enter your name: " .. playerName, 20, 20)
    end

    love.graphics.printf("Welcome to the tea shop", 0, love.graphics.getHeight() / 2 , love.graphics.getWidth(), "center")
    
    if welcomeMessage then
        love.graphics.print(welcomeMessage, 20, 60)
    end
end

