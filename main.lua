-- Initialize variables
local playerName = ""
local customfont
local nameEntered = false -- Add a flag to track if the name has been entered
local background
local idle
local currentBackground 
local timeSinceLastMovement = 0 --for idle screen

local serveButton = love.graphics.newImage("AssetsLove/Serve.png")

local guest = { --guest list
    {image = love.graphics.newImage("AssetsLove/Guests/Rabbit.png"), name = "Rabbit"},
    {image = love.graphics.newImage("AssetsLove/Guests/Tiger.png"), name = "Tiger"},
    {image = love.graphics.newImage("AssetsLove/Guests/Dog.png"), name = "Dog"}
    --{ image = love.graphics.newImage("path/to/customer1.png"), happy = love.graphics.newImage("path/to/happy1.png"), sad = love.graphics.newImage("path/to/sad1.png"), preferredTea = "green" },
}
local dialogues = {
    "Helllllllooo jwe",
    "woofwooooooofwoooof",
    "weeeeeeeeeeeeeee",
    "bsrawgdjtdjsj",
    "grrrrrrrr rawr"
}

local currentGuest
local currentDialogue
local dialogueIndex = 0
local guestAlpha = 0
local timeSinceLastAppearance = 0
local guestVisible = false
local currentGuestIndex = 1
local currentGuest = guest[currentGuestIndex]
local selectedTea = nil -- set this based on player input
local reactionTime = 0 -- Time to display the reaction



function love.load()
    love.window.setTitle("Cozy Tea Shop")
    love.window.setMode(700, 700)
    customfont = love.graphics.newFont("FontsLove/Starla.ttf",24) 
        --love.window.setMode(2000,1200, {fullscreen = false})
 
    background = love.graphics.newImage("AssetsLove/Background.png")
    idle = love.graphics.newImage("AssetsLove/idle.png")
    currentBackground = background

   
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

function love.update(dt)
    timeSinceLastAppearance = timeSinceLastAppearance + dt

    -- Randomly decide to show a creature
    if not guestVisible and timeSinceLastAppearance > 5 then -- 5 seconds for example
        guestVisible = true
        guestAlpha = 0
        dialogueIndex = 0
        timeSinceLastAppearance = 0

        -- Randomly select a creature and a dialogue
        currentGuest = guest[love.math.random(#guest)]
        currentDialogue = dialogues[love.math.random(#dialogues)]
    end

    if guestVisibleVisible and guestAlpha < 1 then
        guestAlphaAlpha = guestAlpha + dt / 2 -- Adjust the fade-in speed 
    end

    -- Increment the dialogue index to create a typewriter effect
    if guestVisible and dialogueIndex < #currentDialogue then
        dialogueIndex = dialogueIndex + 1
    end

    -- Check for mouse movement
    if love.mouse.isDown(1) or love.mouse.getX() ~= lastMouseX or love.mouse.getY() ~= lastMouseY then
        timeSinceLastMovement = 0
        currentBackground = background
    else
        timeSinceLastMovement = timeSinceLastMovement + dt
    end

    -- Switch the background after __ seconds of inactivity
    if timeSinceLastMovement > 100 then
        currentBackground = idle
    end

    -- Update the last mouse position
    lastMouseX, lastMouseY = love.mouse.getPosition()
end

function love.draw()
   
    --love.graphics.setColor(147, 0, 26) 
    
    local windowWidth, windowHeight = love.graphics.getWidth(), love.graphics.getHeight()
    local imageWidth, imageHeight = background:getDimensions()

    love.graphics.draw(background, 0, 0, 0, 0.7, 0.7)
    love.graphics.draw(currentBackground, 0, 0, 0, 0.7, 0.7) 

    
    if guestVisible then
        -- Draw the creature with the current alpha
        love.graphics.setColor(1, 1, 1, guestAlpha)
        love.graphics.draw(currentGuest.image, 350, 300) -- Adjust position as needed
        love.graphics.setColor(1, 1, 1, 1)

        -- Draw the creature's name
        love.graphics.print(currentGuest.name, 355, 555)

        -- Draw the dialogue with a typewriter effect
        love.graphics.print(string.sub(currentDialogue, 1, dialogueIndex), 249, 600) -- Adjust position as needed
    end


    love.graphics.setColor(0.435, 0.306, 0.216, 1)
    love.graphics.setFont(customfont)
    

    local time = os.date("%H:%M:%S") -- Gets the current time in hours, minutes, and seconds
    love.graphics.print(time, 75, love.graphics.getHeight() - 69) 
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(serveButton, 350, -100)

   
    if not nameEntered then
        love.graphics.print("Enter your name: " .. playerName, 20, 20)
    end

   
    if welcomeMessage then
        love.graphics.print(welcomeMessage, 20, 20)
    end
end

