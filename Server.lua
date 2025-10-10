-- Advanced Server Hop Script with UI
-- by snickers

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local placeId = game.PlaceId

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerHopUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 280)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleCover = Instance.new("Frame")
titleCover.Size = UDim2.new(1, 0, 0, 20)
titleCover.Position = UDim2.new(0, 0, 1, -20)
titleCover.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
titleCover.BorderSizePixel = 0
titleCover.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔄 Server Hop"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -37, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

-- Server Info Frame
local infoFrame = Instance.new("Frame")
infoFrame.Name = "InfoFrame"
infoFrame.Size = UDim2.new(1, -20, 0, 60)
infoFrame.Position = UDim2.new(0, 10, 0, 50)
infoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
infoFrame.BorderSizePixel = 0
infoFrame.Parent = mainFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 1, -10)
infoLabel.Position = UDim2.new(0, 10, 0, 5)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = string.format("Current Server: %d/%d players\nPlace ID: %d", #Players:GetPlayers(), Players.MaxPlayers, placeId)
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = 13
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = infoFrame

-- Buttons Container
local buttonsContainer = Instance.new("Frame")
buttonsContainer.Name = "ButtonsContainer"
buttonsContainer.Size = UDim2.new(1, -20, 1, -170)
buttonsContainer.Position = UDim2.new(0, 10, 0, 120)
buttonsContainer.BackgroundTransparency = 1
buttonsContainer.Parent = mainFrame

-- Create Button Function
local function createButton(text, position, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = position
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = buttonsContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(
                math.min(color.R * 255 + 20, 255),
                math.min(color.G * 255 + 20, 255),
                math.min(color.B * 255 + 20, 255)
            )
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = color
        }):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 1, -40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready to hop!"
statusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.Parent = mainFrame

-- Server Hop Functions
local function updateStatus(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or Color3.fromRGB(200, 200, 200)
end

local function getServers(cursor)
    local url = string.format(
        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
        placeId
    )
    
    if cursor then
        url = url .. "&cursor=" .. cursor
    end
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        return HttpService:JSONDecode(result)
    else
        return nil
    end
end

local function getAllServers()
    local allServers = {}
    local cursor = nil
    local attempts = 0
    
    updateStatus("🔍 Scanning servers...", Color3.fromRGB(255, 200, 0))
    
    repeat
        local data = getServers(cursor)
        
        if data and data.data then
            for _, server in pairs(data.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    table.insert(allServers, server)
                end
            end
            
            cursor = data.nextPageCursor
            attempts = attempts + 1
            
            updateStatus(string.format("📊 Found %d servers...", #allServers), Color3.fromRGB(255, 200, 0))
            
            task.wait(0.3)
        else
            break
        end
        
    until not cursor or attempts >= 10
    
    return allServers
end

local function hopToSmallest()
    updateStatus("🔄 Finding smallest server...", Color3.fromRGB(100, 150, 255))
    
    task.spawn(function()
        local servers = getAllServers()
        
        if #servers == 0 then
            updateStatus("❌ No servers found!", Color3.fromRGB(255, 100, 100))
            return
        end
        
        table.sort(servers, function(a, b)
            return a.playing < b.playing
        end)
        
        local targetServer = servers[1]
        
        updateStatus(string.format("⏳ Hopping to server (%d/%d players)...", targetServer.playing, targetServer.maxPlayers), Color3.fromRGB(100, 255, 100))
        
        task.wait(1)
        
        TeleportService:TeleportToPlaceInstance(placeId, targetServer.id, player)
    end)
end

local function hopToHighest()
    updateStatus("🔄 Finding highest server...", Color3.fromRGB(100, 150, 255))
    
    task.spawn(function()
        local servers = getAllServers()
        
        if #servers == 0 then
            updateStatus("❌ No servers found!", Color3.fromRGB(255, 100, 100))
            return
        end
        
        table.sort(servers, function(a, b)
            return a.playing > b.playing
        end)
        
        local targetServer = servers[1]
        
        updateStatus(string.format("⏳ Hopping to server (%d/%d players)...", targetServer.playing, targetServer.maxPlayers), Color3.fromRGB(100, 255, 100))
        
        task.wait(1)
        
        TeleportService:TeleportToPlaceInstance(placeId, targetServer.id, player)
    end)
end

local function hopToRandom()
    updateStatus("🔄 Finding random server...", Color3.fromRGB(100, 150, 255))
    
    task.spawn(function()
        local servers = getAllServers()
        
        if #servers == 0 then
            updateStatus("❌ No servers found!", Color3.fromRGB(255, 100, 100))
            return
        end
        
        local targetServer = servers[math.random(1, #servers)]
        
        updateStatus(string.format("⏳ Hopping to server (%d/%d players)...", targetServer.playing, targetServer.maxPlayers), Color3.fromRGB(100, 255, 100))
        
        task.wait(1)
        
        TeleportService:TeleportToPlaceInstance(placeId, targetServer.id, player)
    end)
end

local function rejoinServer()
    updateStatus("⏳ Rejoining current server...", Color3.fromRGB(100, 150, 255))
    
    task.spawn(function()
        task.wait(1)
        TeleportService:Teleport(placeId, player)
    end)
end

-- Create Buttons
createButton("⬇️ Hop to Smallest Server", UDim2.new(0, 0, 0, 0), Color3.fromRGB(67, 160, 71), hopToSmallest)
createButton("⬆️ Hop to Highest Server", UDim2.new(0, 0, 0, 45), Color3.fromRGB(255, 152, 0), hopToHighest)
createButton("🎲 Hop to Random Server", UDim2.new(0, 0, 0, 90), Color3.fromRGB(156, 39, 176), hopToRandom)
createButton("🔄 Rejoin Current Server", UDim2.new(0, 0, 0, 135), Color3.fromRGB(33, 150, 243), rejoinServer)

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(232, 17, 35)}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
end)

-- Update player count every 5 seconds
task.spawn(function()
    while screenGui.Parent do
        task.wait(5)
        infoLabel.Text = string.format("Current Server: %d/%d players\nPlace ID: %d", #Players:GetPlayers(), Players.MaxPlayers, placeId)
    end
end)

print("✅ Server Hop UI loaded!")
print("🎮 UI is ready to use!")

-- Export functions for console access
_G.ServerHopUI = {
    smallest = hopToSmallest,
    highest = hopToHighest,
    random = hopToRandom,
    rejoin = rejoinServer
}
