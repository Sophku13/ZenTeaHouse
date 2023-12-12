--C:\Program Files\Love\love.exe

-- Initialize variables
local playerName = ""
local customfont
local smallfont
local nameEntered = false -- Add a flag to track if the name has been entered
local background
local idle
local currentBackground 
local timeSinceLastMovement = 0 --for idle screen

local messageTimer = 0
local messageDisplayTime = 3  -- Time in seconds to display the message
local isMessageDisplayed = false
-----------Serve button variables----------------------
local serveButton = love.graphics.newImage("AssetsLove/Serve.png")
local serveButtonX = 522 
local serveButtonY = 610  
------------Guest list variables----------------------------
local guest = { 
{name = "Rabbit", preferredTea = "green", image = love.graphics.newImage("AssetsLove/Guests/Rabbit.png"), x = 336, y = 270, scale = 1, happyImage = love.graphics.newImage("AssetsLove/Guests/RabbitHappy.png"), x = 336, y = 270, sadImage = love.graphics.newImage("AssetsLove/Guests/RabbitSad.png"), x = 336, y = 270},
{name = "Tiger", preferredTea = "fruit", image = love.graphics.newImage("AssetsLove/Guests/Tiger.png"), x = 336, y = 270, scale = 1, happyImage = love.graphics.newImage("AssetsLove/Guests/TigerHappy.png"),x = 336, y = 270, sadImage = love.graphics.newImage("AssetsLove/Guests/TigerSad.png"), x = 336, y = 270},
{name = "Lucky Cat", preferredTea = "black", image = love.graphics.newImage("AssetsLove/Guests/LuckyCat.png"), x = 336, y = 270, scale = 1, happyImage = love.graphics.newImage("AssetsLove/Guests/LuckyCatHappy.png"),x = 336, y = 270, sadImage = love.graphics.newImage("AssetsLove/Guests/LuckyCatSad.png"), x = 336, y = 270},
}
-------------Guest Dialogue------------------------------------
local dialogues = {
    "Good day, I have gone through many perils today, and am looking for something to calm my mind",
    "Achooo!   Im so sorry I think I have a cold",
    "Do you have anything which helps with anxiety?",
    "Ive been having a hard time falling asleep lately... Could you recommend something"
}

--Guest stats------------------
local currentGuest
local currentDialogue
local dialogueIndex = 0
local guestAlpha = 0 --opacity
local timeSinceLastAppearance = 0
local guestVisible = false
local currentGuestIndex = 1
local currentGuest = guest[currentGuestIndex]
local reactionTime = 0 

--idle background settings--------
local morningBackground
local afternoonBackground
local nightBackground

--Tea selection buttons------------
local buttons = {}
local selectedTea = nil  -- Keeps track of the currently selected tea

function love.load()
    currentDialogue = "" --need to initialize for debugging purposes
    love.window.setTitle("Cozy Tea Shop")
    love.window.setMode(700, 700) --window size
    customfont = love.graphics.newFont("FontsLove/Starla.ttf",24) 
    smallFont = love.graphics.newFont("FontsLove/Starla.ttf", 18)
    background = love.graphics.newImage("AssetsLove/Background.png")
    currentBackground = background
     --love.window.setMode(2000,1200, {fullscreen = false})

--idle backgrounds
      morningBackground = love.graphics.newImage("AssetsLove/Idle/Morning.png")
      afternoonBackground = love.graphics.newImage("AssetsLove/Idle/Afternoon.png")
      nightBackground = love.graphics.newImage("AssetsLove/Idle/Night.png")
      
--Tea buttons
buttons = {
    --Green tea
    {normal = love.graphics.newImage("AssetsLove/Tea/Oolong.png"), x = 183, y = 392, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/OolongLit.png"), x = 183, y = 392, scale = 0.5, name = "Oolong Tea", type = "green"},
    {normal = love.graphics.newImage("AssetsLove/Tea/Sencha.png"), x = 163, y = 325, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/SenchaLit.png"), x = 163, y = 325, scale = 0.5, name = "Sencha Tea", type = "green"},
    {normal = love.graphics.newImage("AssetsLove/Tea/Matcha.png"), x = 172, y = 264, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/MatchaLit.png"), x = 172, y = 264, scale = 0.5, name = "Matcha Tea", type = "green"},
    {normal = love.graphics.newImage("AssetsLove/Tea/Jasmine.png"), x = 194, y = 205, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/JasmineLit.png"), x = 194, y = 205, scale = 0.5, name = "Jasmine Tea", type = "green"},
    --Fruit tea
    {normal = love.graphics.newImage("AssetsLove/Tea/Lemon.png"), x = 234 , y = 163, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/LemonLit.png"), x = 234 , y = 163, scale = 0.5, name = "Lemon Tea", type = "fruit"},
    {normal = love.graphics.newImage("AssetsLove/Tea/Mint.png"), x = 240 , y = 116, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/MintLit.png"), x = 292 , y = 116, scale = 0.5, name = "Mint Tea", type = "fruit"},
    {normal = love.graphics.newImage("AssetsLove/Tea/Ginger.png"), x = 355, y = 116, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/GingerLit.png"),x = 355, y = 116, scale = 0.5, name = "Ginger Tea", type = "fruit"},
    {normal = love.graphics.newImage("AssetsLove/Tea/Hibiscus.png"), x = 410, y = 141, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/HibiscusLit.png"), x = 410, y = 141, scale = 0.5, name = "Hibiscus Tea", type = "fruit"},
    --Black tea
    {normal = love.graphics.newImage("AssetsLove/Tea/Roobios.png"), x = 474, y = 162, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/RoobiosLit.png"), x = 474, y = 162, scale = 0.5, name = "Roobios Tea", type = "black"},
    {normal = love.graphics.newImage("AssetsLove/Tea/Chai.png"), x = 512, y = 209, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/ChaiLit.png"),x = 512, y = 209, scale = 0.5, name = "Chai Tea", type = "black"},
    {normal = love.graphics.newImage("AssetsLove/Tea/Darjeeling.png"), x = 539, y = 257, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/DarjeelingLit.png"), x = 539, scale = 0.5, y = 257, name = "Darjeeling Tea", type = "black"},
    {normal = love.graphics.newImage("AssetsLove/Tea/EarlGrey.png"), x = 543, y = 322, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/EarlGreyLit.png"), x = 543, y = 322, scale = 0.5, name = "Earl Grey Tea", type = "black"},
    {normal = love.graphics.newImage("AssetsLove/Tea/Assam.png"), x = 529, y = 388, scale = 0.5, lit = love.graphics.newImage("AssetsLove/TeaLit/AssamLit.png"),x = 529, y = 388, scale = 0.5, name = "Assam Tea", type = "black"},
}
end
songs = {
    {source = love.audio.newSource("MusicLove/LunarEclipse.mp3", "stream"), name = "Lunar Eclipse - Purple cat", paused = false},
    {source = love.audio.newSource("MusicLove/kudasaiTtechnicolor.mp3", "stream"), name = "Kudasai - Technicolor", paused = false},
    {source = love.audio.newSource("MusicLove/KainbeatsWanderer.mp3", "stream"), name = "Kainbeats - Wanderer", paused = false}
}

for _, song in ipairs(songs) do
    song.source:setVolume(0.5)  -- Set to a lower volume
end

currentSongIndex = 1
songs[currentSongIndex].source:play()
function love.textinput(text)
      -- Handle text input only, player name stats
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
    if key == 'lshift' then
        -- Toggle pause/play
        local currentSong = songs[currentSongIndex]
        if currentSong.source:isPlaying() then
            currentSong.source:pause()
            currentSong.paused = true
        else
            currentSong.source:play()
            currentSong.paused = false
        end
    elseif key == 'rshift' then
        -- Stop the current song and skip to the next song
        local currentSong = songs[currentSongIndex]
        currentSong.source:stop()  -- Stop the current song
        currentSong.paused = false

        currentSongIndex = currentSongIndex + 1
        if currentSongIndex > #songs then
            currentSongIndex = 1
        end
        songs[currentSongIndex].source:play()
    end
end

--idle initilization settings
local timeSinceLastMovement = 0
local idleThreshold = 90 -- Idle threshold in seconds
local lastMouseX, lastMouseY = love.mouse.getPosition()

local typewriterTimer = 0
local typewriterSpeed = 0.09

--check if time since last moved is bigger than 90s so it can switch to idle screen
function isIdle()
    return timeSinceLastMovement > idleThreshold
end

function love.update(dt) --delta time
    local currentSong = songs[currentSongIndex]
    if not currentSong.source:isPlaying() and not currentSong.paused then
        -- Move to the next song
        currentSongIndex = currentSongIndex + 1
        if currentSongIndex > #songs then
            currentSongIndex = 1
        end
        songs[currentSongIndex].source:play()
    end

    timeSinceLastAppearance = timeSinceLastAppearance + dt

    if fadeOut then
        fadeAlpha = fadeAlpha - fadeSpeed * dt
        if fadeAlpha <= 0 then
            fadeAlpha = 0
            fadeOut = false
            guestVisible = false  -- Hide the guest after fade out
            currentGuest = nil
            selectedTea = nil
        end
    end
    -- Randomly decide to show a guest
    if not guestVisible and timeSinceLastAppearance > 5 then -- if no guest for over 5s it will show another one
        guestVisible = true
        guestAlpha = 0
        dialogueIndex = 0
        timeSinceLastAppearance = 0

        -- Randomly select a guest and their dialogue
        currentGuest = guest[love.math.random(#guest)]
        currentDialogue = dialogues[love.math.random(#dialogues)]
    end

    if guestVisible and guestAlpha < 1 then  guestAlpha = guestAlpha + dt / 2
        -- Adjust the fade-in speed 
    end

    -- Increment the dialogue index to create a typewriter effect
    if guestVisible and dialogueIndex < #currentDialogue then
        typewriterTimer = typewriterTimer + dt
        if typewriterTimer >= typewriterSpeed then
            dialogueIndex = dialogueIndex + 1
            typewriterTimer = 0 -- Reset the timer
        end
    end

    if isMessageDisplayed then
        messageTimer = messageTimer - dt
        if messageTimer <= 0 then
            displayMessage = nil
            isMessageDisplayed = false
        end
    end

    if love.mouse.isDown(1) or love.mouse.getX() ~= lastMouseX or love.mouse.getY() ~= lastMouseY then
        timeSinceLastMovement = 0
        currentBackground = background -- Reset to active background
    else
        timeSinceLastMovement = timeSinceLastMovement + dt
        if timeSinceLastMovement > idleThreshold then
            currentBackground = idle -- Set to idle background
        end
    end

    -- Update the last mouse position
    lastMouseX, lastMouseY = love.mouse.getPosition()
    -- Check for mouse movement
    if love.mouse.isDown(1) or love.mouse.getX() ~= lastMouseX or love.mouse.getY() ~= lastMouseY then
        timeSinceLastMovement = 0
        currentBackground = background
    else
        timeSinceLastMovement = timeSinceLastMovement + dt
    end

    -- Switch the background after 90 seconds of inactivity
    if timeSinceLastMovement > 90 then
        currentBackground = idle
    end

    -- Update the last mouse position
    lastMouseX, lastMouseY = love.mouse.getPosition()

    if timeSinceLastMovement > 90 then 
        local currentTime = os.date("*t")
        if currentTime.hour >= 5 and currentTime.hour < 12 then
            currentBackground = morningBackground
        elseif currentTime.hour >= 12 and currentTime.hour < 18 then
            currentBackground = afternoonBackground
        else  -- For hours from 18:00 to 04:59
            currentBackground = nightBackground
        end
    end
end

function serveTea()
    --if you press serve while there is no guest on screen
    if not currentGuest then
        displayMessage = "No customer"
        messageColor = {0.8, 0.2, 0.2} 
        messageTimer = messageDisplayTime
        isMessageDisplayed = true
        return
    end

    if not selectedTea then
     --if you press serve when you didnt select a tea
        displayMessage = "No tea selected"
        messageColor = {0.8, 0.2, 0.2} 
        messageTimer = messageDisplayTime
        isMessageDisplayed = true
        return
    end
    checkCustomerReaction()
end
  
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then --left mouse button
        local scaledWidth = serveButton:getWidth() * 0.68 --sizing the serve button 
        local scaledHeight = serveButton:getHeight() * 0.68
        if x >= serveButtonX and x <= serveButtonX + scaledWidth and y >= serveButtonY and y <= serveButtonY + scaledHeight then
            serveTea()
            return
        end
        for _, teaButton in ipairs(buttons) do --iterating over the elements of a table sequentially
            if x > teaButton.x and x < teaButton.x + teaButton.normal:getWidth() and y > teaButton.y and y < teaButton.y + teaButton.normal:getHeight() then
                selectedTea = {name = teaButton.name, type = teaButton.type}  -- Store both name and type of the tea
                -- Deselect other teas and select this one
                for _, otherTeaButton in ipairs(buttons) do
                    otherTeaButton.selected = false
                end
                teaButton.selected = true
                break
            end
        end
    end
end 

function checkCustomerReaction()
    if currentGuest == nil then
        return  -- If there's no current guest
    end

    local correctTeaServed = selectedTea.type == currentGuest.preferredTea

    if correctTeaServed then
        currentGuest.image = currentGuest.happyImage
        currentDialogue = "Wow this tea is amazing, thank you so much!"
    else
        currentGuest.image = currentGuest.sadImage
        currentDialogue = "Euhh this was not what I had in mind.. thank you though"
    end

    dialogueIndex = #currentDialogue  -- Set dialogue index to the length of the new dialogue
    startFadeOut()
end

local fadeOut = false
local fadeAlpha = 1  -- Initial alpha value (1 is fully opaque, 0 is fully transparent)
local fadeSpeed = 0.5  -- How fast the fade occurs (higher is faster)

function startFadeOut()
    fadeOut = true
    fadeAlpha = 1
end

function love.draw()

    local windowWidth, windowHeight = love.graphics.getWidth(), love.graphics.getHeight()
    local imageWidth, imageHeight = background:getDimensions()

    love.graphics.draw(background, 0, 0, 0, 0.7, 0.7)
    love.graphics.draw(currentBackground, 0, 0, 0, 0.7, 0.7) 
    if isIdle() then
        -- Only display the song name in idle mode
        local songName = songs[currentSongIndex].name
        love.graphics.setFont(smallFont)
        love.graphics.setColor(0.675, 0.302, 0.749) 
        love.graphics.print("Now Playing: " .. songName, 20, 50) 
        love.graphics.print("Press [[lshift]] to Pause/Play current song", 20, 70)
        love.graphics.print("Press [[rshift]] to Skip song", 20, 90)
        end

    if not isIdle() then
        -- Draw buttons and selected tea name if the game is not idle
        for _, button in ipairs(buttons) do
            local image = button.selected and button.lit or button.normal
            love.graphics.draw(image, button.x, button.y)
        end
        love.graphics.setColor(1, 1, 1, 1)

        if selectedTea then
            love.graphics.print(selectedTea.name .. " selected", 20, 50)
        end

        local scale = 0.68  
        love.graphics.draw(serveButton, serveButtonX, serveButtonY, 0, scale, scale)

    -- Check if the current background is not one of the idle backgrounds
    if currentBackground ~= morningBackground and currentBackground ~= afternoonBackground and currentBackground ~= nightBackground then
    -- Draw guest and dialogue only if the current background is not an idle background
    end

    if currentGuest and fadeOut then
        love.graphics.setColor(1, 1, 1, fadeAlpha)
        love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
    end

local textBoxWidth = 250

if displayMessage then
    love.graphics.setColor(messageColor)
    love.graphics.print(displayMessage, 249, 600)  -- Position of the message
    love.graphics.setColor(1, 1, 1)  -- Reset color to white
end

        if guestVisible then
            -- Draw the guest's name
            love.graphics.setColor(0.435, 0.306, 0.216, 1)
            love.graphics.print(currentGuest.name, 355, 555)

            -- Draw the guest with the current alpha
            love.graphics.setColor(1, 1, 1, guestAlpha) 
            love.graphics.draw(currentGuest.image, 250, 220, 0, 0.5,0.5)  
            love.graphics.setColor(1, 1, 1, 1)

            -- Draw the dialogue with a typewriter effect
            love.graphics.setColor(0.435, 0.306, 0.216, 1)
            love.graphics.setFont(smallFont)
            love.graphics.printf(string.sub(currentDialogue, 1, dialogueIndex), 249, 600, textBoxWidth)
        end
    end

    love.graphics.setColor(0.435, 0.306, 0.216, 1)
    love.graphics.setFont(customfont)

    local time = os.date("%H:%M:%S") -- Gets the current time in hours, minutes, and seconds
    love.graphics.print(time, 75, love.graphics.getHeight() - 69) 
    love.graphics.setColor(1, 1, 1, 1)
   

    if not nameEntered then
        love.graphics.print("Enter your name: " .. playerName, 20, 20)
    end

    if welcomeMessage then
        love.graphics.print(welcomeMessage, 20, 20)
    end
end