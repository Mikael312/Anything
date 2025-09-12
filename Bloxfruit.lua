-- Blox Fruits Sea 1 Complete Script Hub with Mobile UI
-- Modular design for easy Sea 2 updates
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ===============================================
-- CONFIGURATION SYSTEM (Easy to update for Sea 2)
-- ===============================================
local CONFIG = {
    SEA_LEVEL = 1, -- Change to 2 for Sea 2
    
    -- Combat Settings
    COMBAT = {
        AUTO_FARM_ENABLED = false,
        AUTO_QUEST_ENABLED = false,
        SAFE_HEALTH = 20, -- Stop farming when health below this %
        USE_SKILLS = true,
        SKILL_DELAY = 1.5,
        AUTO_STATS = false
    },
    
    -- Movement Settings
    MOVEMENT = {
        WALK_SPEED = 16,
        TELEPORT_SPEED = 3,
        FLY_ENABLED = false,
        NOCLIP_ENABLED = false
    },
    
    -- Visual Settings
    ESP = {
        PLAYERS = false,
        FRUITS = false,
        NPCS = false,
        CHESTS = false,
        QUESTS = false
    },
    
    -- Auto Features
    AUTO = {
        REJOIN = true,
        COLLECT_CHESTS = false,
        EAT_FRUITS = false,
        STORE_FRUITS = true,
        SELL_ITEMS = false
    }
}

-- Sea 1 Specific Data (Will expand for Sea 2)
local SEA_DATA = {
    [1] = {
        ISLANDS = {
            ["Starter Island"] = CFrame.new(1094, 16, 1551),
            ["Marine Base"] = CFrame.new(-2566, 6, -294),
            ["Jungle"] = CFrame.new(-1612, 36, 149),
            ["Pirate Village"] = CFrame.new(-378, 7, 298),
            ["Desert"] = CFrame.new(944, 6, 4373),
            ["Frozen Village"] = CFrame.new(1198, 104, -1457),
            ["Skylands"] = CFrame.new(-4870, 717, -2667),
            ["Prison"] = CFrame.new(4875, 5, 734),
            ["Colosseum"] = CFrame.new(-1427, 7, -2792),
            ["Magma Village"] = CFrame.new(-5247, 12, -4849),
            ["Upper Skylands"] = CFrame.new(-7894, 5547, -380),
            ["Fountain City"] = CFrame.new(5127, 59, 4105)
        },
        
        ENEMIES = {
            -- Starter Island
            {name = "Bandit", level = {5, 7}, location = CFrame.new(1145, 17, 1634), questGiver = "Bandit Quest"},
            {name = "Monkey", level = {14, 16}, location = CFrame.new(-1448, 50, 11), questGiver = "Monkey Quest"},
            
            -- Marine Base
            {name = "Trainees", level = {8, 10}, location = CFrame.new(-2624, 6, -2447), questGiver = "Marine Quest"},
            {name = "Officers", level = {32, 35}, location = CFrame.new(-5058, 28, 4324), questGiver = "Marine Quest 2"},
            
            -- Jungle
            {name = "Gorilla", level = {20, 25}, location = CFrame.new(-1223, 6, -486), questGiver = "Jungle Quest"},
            {name = "Chief", level = {120, 150}, location = CFrame.new(-2978, 58, -853), questGiver = "Area 2 Quest"},
            
            -- Desert
            {name = "Desert Bandits", level = {60, 75}, location = CFrame.new(924, 6, 4481), questGiver = "Desert Quest"},
            {name = "Desert Officers", level = {70, 75}, location = CFrame.new(1547, 14, 4381), questGiver = "Desert Quest"},
            
            -- Prison
            {name = "Prisoners", level = {190, 250}, location = CFrame.new(5411, 96, 690), questGiver = "Prison Quest"},
            {name = "Dangerous Prisoners", level = {210, 250}, location = CFrame.new(5411, 96, 690), questGiver = "Prison Quest"},
            
            -- Colosseum
            {name = "Gladiators", level = {85, 90}, location = CFrame.new(-1353, 87, -2823), questGiver = "Colosseum Quest"},
            
            -- Magma Village
            {name = "Magma Ninjas", level = {300, 375}, location = CFrame.new(-5428, 78, -5959), questGiver = "Fire Quest"},
            {name = "Lava Pirates", level = {350, 400}, location = CFrame.new(-5213, 49, -4130), questGiver = "Fire Quest"}
        },
        
        BOSSES = {
            {name = "The Gorilla King", level = 25, location = CFrame.new(-1223, 6, -486), questGiver = "JungleQuest", questNumber = 3},
            {name = "Bobby", level = 55, location = CFrame.new(-2575, 2, -284), questGiver = "BuggyQuest1", questNumber = 3},
            {name = "Yeti", level = 110, location = CFrame.new(1180, 138, -1488), questGiver = "SnowQuest", questNumber = 3},
            {name = "Vice Admiral", level = 130, location = CFrame.new(-5026, 28, 4324), questGiver = "MarineQuest2", questNumber = 2},
            {name = "Warden", level = 220, location = CFrame.new(5278, 2, 747), questGiver = "ImpelQuest", questNumber = 1},
            {name = "Chief Warden", level = 230, location = CFrame.new(5206, 0, 747), questGiver = "ImpelQuest", questNumber = 2},
            {name = "Swan", level = 240, location = CFrame.new(5230, 4, 750), questGiver = "ImpelQuest", questNumber = 3},
            {name = "Magma Admiral", level = 350, location = CFrame.new(-5530, 22, -5277), questGiver = "FireSideQuest", questNumber = 2},
            {name = "Fishman Lord", level = 425, location = CFrame.new(61548, 31, 1113), questGiver = "FishmanQuest", questNumber = 3}
        },
        
        FRUITS = {
            "Rocket", "Spin", "Chop", "Spring", "Bomb", "Smoke", "Spike", "Flame", 
            "Falcon", "Ice", "Sand", "Dark", "Revive", "Diamond", "Light", "Love", 
            "Rubber", "Barrier", "Magma", "Quake", "Human: Buddha", "String", "Bird: Phoenix"
        },
        
        QUEST_GIVERS = {
            ["Bandit Quest"] = CFrame.new(1059, 16, 1549),
            ["Jungle Quest"] = CFrame.new(-1602, 36, 153),
            ["Marine Quest"] = CFrame.new(-2440, 73, 1395),
            ["Marine Quest 2"] = CFrame.new(-5039, 28, 4325),
            ["Desert Quest"] = CFrame.new(897, 6, 4388),
            ["Prison Quest"] = CFrame.new(5310, 1, 473),
            ["Colosseum Quest"] = CFrame.new(-1576, 7, -2985),
            ["Fire Quest"] = CFrame.new(-5429, 15, -5299)
        }
    }
}

-- ===============================================
-- CORE SYSTEMS
-- ===============================================
local ScriptHub = {
    connections = {},
    isRunning = false,
    currentTarget = nil,
    currentQuest = nil,
    originalWalkSpeed = 16,
    UI = {}
}

-- Auto-update character reference
local function updateCharacter()
    character = player.Character
    if character then
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
        ScriptHub.originalWalkSpeed = humanoid.WalkSpeed
    end
end
player.CharacterAdded:Connect(updateCharacter)

-- ===============================================
-- UTILITY FUNCTIONS
-- ===============================================
local function safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Error:", result)
    end
    return success, result
end

local function tweenToPosition(targetCFrame, speed)
    if not rootPart or not rootPart.Parent then return end
    
    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    local time = distance / (speed or CONFIG.MOVEMENT.TELEPORT_SPEED)
    
    local tween = TweenService:Create(
        rootPart,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame}
    )
    
    tween:Play()
    return tween
end

local function getPlayerLevel()
    local success, level = safeCall(function()
        return player.Data.Level.Value
    end)
    return success and level or 1
end

local function getPlayerHealth()
    return humanoid and (humanoid.Health / humanoid.MaxHealth) * 100 or 0
end

-- ===============================================
-- COMBAT SYSTEM
-- ===============================================
local Combat = {}
function Combat.findNearestEnemy(maxDistance)
    maxDistance = maxDistance or 50
    local nearestEnemy = nil
    local shortestDistance = maxDistance
    
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local distance = (rootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = enemy
            end
        end
    end
    
    return nearestEnemy
end

function Combat.attackEnemy(enemy)
    if not enemy or not enemy.Parent or not enemy:FindFirstChild("Humanoid") then
        return false
    end
    
    if enemy.Humanoid.Health <= 0 then
        return false
    end
    
    -- Move to enemy
    if enemy:FindFirstChild("HumanoidRootPart") then
        rootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
    end
    
    -- Basic attack
    safeCall(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
    end)
    
    -- Use skills if enabled
    if CONFIG.COMBAT.USE_SKILLS then
        Combat.useSkills()
    end
    
    return true
end

function Combat.useSkills()
    local skills = {"Z", "X", "C", "V"}
    
    for _, skill in pairs(skills) do
        safeCall(function()
            game:GetService("VirtualUser"):TypeOnKeyboard(skill)
        end)
        wait(0.2)
    end
end

function Combat.farmEnemies()
    if not CONFIG.COMBAT.AUTO_FARM_ENABLED then return end
    
    local enemy = Combat.findNearestEnemy()
    if enemy then
        ScriptHub.currentTarget = enemy
        Combat.attackEnemy(enemy)
    end
end

-- ===============================================
-- QUEST SYSTEM
-- ===============================================
local Quest = {}
function Quest.findAppropriateQuest()
    local playerLevel = getPlayerLevel()
    local currentSeaData = SEA_DATA[CONFIG.SEA_LEVEL]
    
    for _, enemyData in pairs(currentSeaData.ENEMIES) do
        if playerLevel >= enemyData.level[1] and playerLevel <= enemyData.level[2] + 20 then
            return enemyData
        end
    end
    
    return nil
end

function Quest.getQuest(questGiver)
    local questGiverPos = SEA_DATA[CONFIG.SEA_LEVEL].QUEST_GIVERS[questGiver]
    if not questGiverPos then return false end
    
    -- Teleport to quest giver
    rootPart.CFrame = questGiverPos
    wait(1)
    
    -- Get quest (game-specific implementation needed)
    safeCall(function()
        local args = {
            [1] = "StartQuest",
            [2] = questGiver,
            [3] = 1
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end)
    
    return true
end

function Quest.autoQuest()
    if not CONFIG.COMBAT.AUTO_QUEST_ENABLED then return end
    
    local questData = Quest.findAppropriateQuest()
    if questData then
        if ScriptHub.currentQuest ~= questData.questGiver then
            Quest.getQuest(questData.questGiver)
            ScriptHub.currentQuest = questData.questGiver
            
            -- Teleport to enemy location
            wait(1)
            rootPart.CFrame = questData.location
        end
    end
end

-- ===============================================
-- ESP SYSTEM
-- ===============================================
local ESP = {}
ESP.objects = {}

function ESP.createESP(obj, color, text)
    if ESP.objects[obj] then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = obj
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.Adornee = obj
    billboard.AlwaysOnTop = true
    
    local frame = Instance.new("Frame")
    frame.Parent = billboard
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = color
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextScaled = true
    label.TextColor3 = Color3.new(1, 1, 1)
    
    ESP.objects[obj] = billboard
end

function ESP.removeESP(obj)
    if ESP.objects[obj] then
        ESP.objects[obj]:Destroy()
        ESP.objects[obj] = nil
    end
end

function ESP.updatePlayerESP()
    if not CONFIG.ESP.PLAYERS then return end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local character = otherPlayer.Character
            if character:FindFirstChild("HumanoidRootPart") then
                ESP.createESP(
                    character.HumanoidRootPart,
                    Color3.new(1, 0, 0),
                    otherPlayer.Name .. "\nLvl: " .. (otherPlayer.Data.Level.Value or "?")
                )
            end
        end
    end
end

function ESP.updateFruitESP()
    if not CONFIG.ESP.FRUITS then return end
    
    for _, fruit in pairs(Workspace:GetChildren()) do
        if fruit.Name:find("Fruit") and fruit:FindFirstChild("Handle") then
            ESP.createESP(
                fruit.Handle,
                Color3.new(1, 1, 0),
                fruit.Name:gsub("Fruit", "")
            )
        end
    end
end

-- ===============================================
-- AUTO FEATURES
-- ===============================================
local Auto = {}
function Auto.collectChests()
    if not CONFIG.AUTO.COLLECT_CHESTS then return end
    
    for _, chest in pairs(Workspace:GetChildren()) do
        if chest.Name == "Chest1" or chest.Name == "Chest2" or chest.Name == "Chest3" then
            if chest:FindFirstChild("Base") then
                local distance = (rootPart.Position - chest.Base.Position).Magnitude
                if distance < 50 then
                    rootPart.CFrame = chest.Base.CFrame
                    wait(0.5)
                    
                    -- Collect chest
                    fireproximityprompt(chest.Base.ProximityPrompt)
                end
            end
        end
    end
end

function Auto.collectFruits()
    if not CONFIG.AUTO.EAT_FRUITS and not CONFIG.AUTO.STORE_FRUITS then return end
    
    for _, fruit in pairs(Workspace:GetChildren()) do
        if fruit.Name:find("Fruit") and fruit:FindFirstChild("Handle") then
            local distance = (rootPart.Position - fruit.Handle.Position).Magnitude
            if distance < 50 then
                rootPart.CFrame = fruit.Handle.CFrame
                wait(0.5)
                
                if CONFIG.AUTO.EAT_FRUITS then
                    -- Eat fruit
                    fireproximityprompt(fruit.Handle.ProximityPrompt)
                elseif CONFIG.AUTO.STORE_FRUITS then
                    -- Store fruit logic here
                    print("Storing fruit:", fruit.Name)
                end
            end
        end
    end
end

function Auto.rejoin()
    if not CONFIG.AUTO.REJOIN then return end
    
    -- Auto rejoin when kicked/disconnected
    game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == 'ErrorPrompt' and child:FindFirstChild("MessageArea") and child.MessageArea:FindFirstChild("ErrorFrame") then
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end
    end)
end

-- ===============================================
-- MOVEMENT SYSTEM
-- ===============================================
local Movement = {}
function Movement.setWalkSpeed(speed)
    if humanoid then
        humanoid.WalkSpeed = speed or CONFIG.MOVEMENT.WALK_SPEED
    end
end

function Movement.fly(enabled)
    CONFIG.MOVEMENT.FLY_ENABLED = enabled
    
    if enabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        ScriptHub.connections.fly = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space then
                bodyVelocity.Velocity = Vector3.new(0, 50, 0)
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                bodyVelocity.Velocity = Vector3.new(0, -50, 0)
            end
        end)
        
        ScriptHub.connections.flyEnd = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if rootPart:FindFirstChild("BodyVelocity") then
            rootPart.BodyVelocity:Destroy()
        end
        
        if ScriptHub.connections.fly then
            ScriptHub.connections.fly:Disconnect()
            ScriptHub.connections.flyEnd:Disconnect()
        end
    end
end

function Movement.noclip(enabled)
    CONFIG.MOVEMENT.NOCLIP_ENABLED = enabled
    
    if enabled then
        ScriptHub.connections.noclip = RunService.Stepped:Connect(function()
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if ScriptHub.connections.noclip then
            ScriptHub.connections.noclip:Disconnect()
        end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

-- ===============================================
-- TELEPORTATION SYSTEM
-- ===============================================
local Teleport = {}
function Teleport.toIsland(islandName)
    local currentSeaData = SEA_DATA[CONFIG.SEA_LEVEL]
    local islandCFrame = currentSeaData.ISLANDS[islandName]
    
    if islandCFrame then
        rootPart.CFrame = islandCFrame
        print("✅ Teleported to", islandName)
        return true
    else
        warn("❌ Island not found:", islandName)
        return false
    end
end

function Teleport.toBoss(bossName)
    local currentSeaData = SEA_DATA[CONFIG.SEA_LEVEL]
    
    for _, boss in pairs(currentSeaData.BOSSES) do
        if boss.name == bossName then
            rootPart.CFrame = boss.location
            print("✅ Teleported to", bossName)
            return true
        end
    end
    
    warn("❌ Boss not found:", bossName)
    return false
end

-- ===============================================
-- MAIN LOOP
-- ===============================================
local function mainLoop()
    while ScriptHub.isRunning do
        safeCall(function()
            -- Safety check
            if getPlayerHealth() < CONFIG.COMBAT.SAFE_HEALTH then
                print("⚠️ Low health! Stopping farming...")
                wait(5)
                return
            end
            
            -- Auto quest
            Quest.autoQuest()
            
            -- Auto farm
            Combat.farmEnemies()
            
            -- Auto collect
            Auto.collectChests()
            Auto.collectFruits()
            
            -- Update ESP
            ESP.updatePlayerESP()
            ESP.updateFruitESP()
        end)
        
        wait(0.1) -- Main loop delay
    end
end

-- ===============================================
-- CONTROL FUNCTIONS
-- ===============================================
local function startScript()
    if ScriptHub.isRunning then return end
    
    ScriptHub.isRunning = true
    print("🚀 Blox Fruits Script Started!")
    
    -- Initialize auto rejoin
    Auto.rejoin()
    
    -- Start main loop
    spawn(mainLoop)
end

local function stopScript()
    ScriptHub.isRunning = false
    ScriptHub.currentTarget = nil
    ScriptHub.currentQuest = nil
    
    -- Disconnect all connections
    for name, connection in pairs(ScriptHub.connections) do
        if connection then
            connection:Disconnect()
        end
    end
    ScriptHub.connections = {}
    
    -- Restore original settings
    Movement.setWalkSpeed(ScriptHub.originalWalkSpeed)
    Movement.fly(false)
    Movement.noclip(false)
    
    print("🛑 Blox Fruits Script Stopped!")
end

-- ===============================================
-- UI CREATION
-- ===============================================
local function createUI()
    -- Main UI Container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ScriptHubX"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 650, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    
    -- Shadow effect
    local Shadow = Instance.new("Frame")
    Shadow.Name = "Shadow"
    Shadow.Parent = MainFrame
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, 5, 0, 5)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BorderSizePixel = 0
    Shadow.BackgroundTransparency = 0.4
    Shadow.ZIndex = -1
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TopBar.BorderSizePixel = 0
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.Size = UDim2.new(1, -120, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Script Hub X"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Buttons Container
    local ButtonsContainer = Instance.new("Frame")
    ButtonsContainer.Name = "ButtonsContainer"
    ButtonsContainer.Parent = TopBar
    ButtonsContainer.Size = UDim2.new(0, 110, 1, 0)
    ButtonsContainer.Position = UDim2.new(1, -110, 0, 0)
    ButtonsContainer.BackgroundTransparency = 1
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Parent = ButtonsContainer
    MinimizeBtn.Size = UDim2.new(0, 35, 1, 0)
    MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Font = Enum.Font.GothamBold
    
    -- Maximize Button
    local MaximizeBtn = Instance.new("TextButton")
    MaximizeBtn.Name = "MaximizeBtn"
    MaximizeBtn.Parent = ButtonsContainer
    MaximizeBtn.Size = UDim2.new(0, 35, 1, 0)
    MaximizeBtn.Position = UDim2.new(0, 35, 0, 0)
    MaximizeBtn.BackgroundTransparency = 1
    MaximizeBtn.Text = "□"
    MaximizeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    MaximizeBtn.TextSize = 16
    MaximizeBtn.Font = Enum.Font.GothamBold
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = ButtonsContainer
    CloseBtn.Size = UDim2.new(0, 35, 1, 0)
    CloseBtn.Position = UDim2.new(0, 70, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    CloseBtn.TextSize = 22
    CloseBtn.Font = Enum.Font.GothamBold
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.Size = UDim2.new(0, 170, 1, -35)
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TabContainer.BorderSizePixel = 0
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.Size = UDim2.new(1, -170, 1, -35)
    ContentContainer.Position = UDim2.new(0, 170, 0, 35)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    ContentContainer.BorderSizePixel = 0
    
    -- Create tabs
    local tabs = {
        {name = "General", icon = "🏠"},
        {name = "Combat", icon = "⚔️"},
        {name = "Navigation", icon = "🗺️"},
        {name = "ESP", icon = "🔍"},
        {name = "Movement", icon = "🚀"},
        {name = "Auto", icon = "💰"},
        {name = "Controls", icon = "⌨️"},
        {name = "Sea 1 Data", icon = "📊"},
        {name = "Credits", icon = "👤"}
    }
    
    local tabButtons = {}
    local tabContents = {}
    
    for i, tab in ipairs(tabs) do
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tab.name .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.Size = UDim2.new(1, 0, 0, 45)
        TabButton.Position = UDim2.new(0, 0, 0, (i-1) * 45)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TabButton.BorderSizePixel = 0
        TabButton.Text = "  " .. tab.icon .. "  " .. tab.name
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 185)
        TabButton.TextSize = 16
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Tab Highlight
        local TabHighlight = Instance.new("Frame")
        TabHighlight.Name = "Highlight"
        TabHighlight.Parent = TabButton
        TabHighlight.Size = UDim2.new(0, 4, 1, 0)
        TabHighlight.Position = UDim2.new(0, 0, 0, 0)
        TabHighlight.BackgroundColor3 = Color3.fromRGB(65, 130, 220)
        TabHighlight.BorderSizePixel = 0
        TabHighlight.Visible = (i == 1)
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tab.name .. "Content"
        TabContent.Parent = ContentContainer
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        TabContent.BorderSizePixel = 0
        TabContent.Visible = (i == 1)
        TabContent.ScrollBarThickness = 8
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        table.insert(tabButtons, TabButton)
        table.insert(tabContents, TabContent)
        
        -- Tab Button Click Event
        TabButton.MouseButton1Click:Connect(function()
            for j, content in ipairs(tabContents) do
                content.Visible = (j == i)
            end
            for j, button in ipairs(tabButtons) do
                local highlight = button:FindFirstChild("Highlight")
                if j == i then
                    button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    if highlight then highlight.Visible = true end
                else
                    button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                    button.TextColor3 = Color3.fromRGB(180, 180, 185)
                    if highlight then highlight.Visible = false end
                end
            end
        end)
        
        -- Tab Button Hover Effect
        TabButton.MouseEnter:Connect(function()
            if not TabButton.Highlight.Visible then
                TabButton.BackgroundColor3 = Color3.fromRGB(33, 33, 38)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabButton.Highlight.Visible then
                TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            end
        end)
    end
    
    -- Create toggle function with config integration
    local function createToggle(name, parent, position, configTable, configKey)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = name .. "Toggle"
        ToggleFrame.Parent = parent
        ToggleFrame.Size = UDim2.new(1, -20, 0, 35)
        ToggleFrame.Position = position
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.AutomaticSize = Enum.AutomaticSize.Y
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Name = "Label"
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
        ToggleLabel.TextSize = 15
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.TextWrapped = true
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "Button"
        ToggleButton.Parent = ToggleFrame
        ToggleButton.Size = UDim2.new(0, 55, 0, 25)
        ToggleButton.Position = UDim2.new(1, -70, 0.5, -12.5)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Text = ""
        ToggleButton.Font = Enum.Font.Gotham
        ToggleButton.TextSize = 14
        
        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Name = "Indicator"
        ToggleIndicator.Parent = ToggleButton
        ToggleIndicator.Size = UDim2.new(0, 21, 0, 21)
        ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
        ToggleIndicator.BorderSizePixel = 0
        ToggleIndicator.CornerRadius = UDim.new(0.5, 0)
        
        ToggleButton.CornerRadius = UDim.new(0, 4)
        ToggleFrame.CornerRadius = UDim.new(0, 4)
        
        -- Set initial state based on config
        local enabled = configTable and configKey and configTable[configKey] or false
        
        if enabled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(65, 130, 220)
            ToggleIndicator.Position = UDim2.new(0, 32, 0, 2)
        end
        
        ToggleButton.MouseButton1Click:Connect(function()
            enabled = not enabled
            if configTable and configKey then
                configTable[configKey] = enabled
            end
            
            if enabled then
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 130, 220)}):Play()
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 32, 0, 2)}):Play()
            else
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 85)}):Play()
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
            end
        end)
        
        return ToggleFrame, ToggleButton, enabled
    end
    
    -- Create section function
    local function createSection(title, parent, position)
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = title .. "Section"
        SectionFrame.Parent = parent
        SectionFrame.Size = UDim2.new(1, -20, 0, 30)
        SectionFrame.Position = position
        SectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        SectionFrame.BorderSizePixel = 0
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "Title"
        SectionTitle.Parent = SectionFrame
        SectionTitle.Size = UDim2.new(1, -10, 1, 0)
        SectionTitle.Position = UDim2.new(0, 10, 0, 0)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = title
        SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionTitle.TextSize = 18
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        SectionFrame.CornerRadius = UDim.new(0, 4)
        
        return SectionFrame, UDim2.new(0, 10, 0, position.Y.Offset + 35)
    end
    
    -- Create General tab content
    local GeneralContent = tabContents[1]
    local nextPos = UDim2.new(0, 10, 0, 10)
    
    createSection("General Settings", GeneralContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, 50)
    
    -- Start/Stop All Toggle
    local startStopToggle = createToggle("Start All Automation", GeneralContent, nextPos)
    startStopToggle.MouseButton1Click:Connect(function()
        if ScriptHub.isRunning then
            stopScript()
        else
            startScript()
        end
    end)
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Auto Update", GeneralContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Notifications", GeneralContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Anti-Detection", GeneralContent, nextPos)
    
    -- Create Combat tab content
    local CombatContent = tabContents[2]
    nextPos = UDim2.new(0, 10, 0, 10)
    
    createSection("⚔️ Combat System", CombatContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, 50)
    
    createToggle("Auto farm enemies based on level", CombatContent, nextPos, CONFIG.COMBAT, "AUTO_FARM_ENABLED")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Auto quest system", CombatContent, nextPos, CONFIG.COMBAT, "AUTO_QUEST_ENABLED")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Smart enemy targeting", CombatContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Skill rotation (Z, X, C, V)", CombatContent, nextPos, CONFIG.COMBAT, "USE_SKILLS")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Safety stop when health is low", CombatContent, nextPos)
    
    -- Create Navigation tab content
    local NavigationContent = tabContents[3]
    nextPos = UDim2.new(0, 10, 0, 10)
    
    createSection("🗺️ Navigation", NavigationContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, 50)
    
    -- Create island teleport buttons
    local currentSeaData = SEA_DATA[CONFIG.SEA_LEVEL]
    for islandName, islandCFrame in pairs(currentSeaData.ISLANDS) do
        local IslandButton = Instance.new("TextButton")
        IslandButton.Name = islandName .. "Button"
        IslandButton.Parent = NavigationContent
        IslandButton.Size = UDim2.new(1, -20, 0, 35)
        IslandButton.Position = nextPos
        IslandButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        IslandButton.BorderSizePixel = 0
        IslandButton.Text = "Teleport to " .. islandName
        IslandButton.TextColor3 = Color3.fromRGB(220, 220, 225)
        IslandButton.TextSize = 15
        IslandButton.Font = Enum.Font.Gotham
        IslandButton.CornerRadius = UDim.new(0, 4)
        
        IslandButton.MouseButton1Click:Connect(function()
            Teleport.toIsland(islandName)
        end)
        
        IslandButton.MouseEnter:Connect(function()
            TweenService:Create(IslandButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 60)}):Play()
        end)
        
        IslandButton.MouseLeave:Connect(function()
            TweenService:Create(IslandButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
        end)
        
        nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    end
    
    -- Create ESP tab content
    local ESPContent = tabContents[4]
    nextPos = UDim2.new(0, 10, 0, 10)
    
    createSection("🔍 ESP System", ESPContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, 50)
    
    createToggle("Player ESP (name + level)", ESPContent, nextPos, CONFIG.ESP, "PLAYERS")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Fruit ESP with highlighting", ESPContent, nextPos, CONFIG.ESP, "FRUITS")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Enemy ESP", ESPContent, nextPos, CONFIG.ESP, "NPCS")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Quest giver ESP", ESPContent, nextPos, CONFIG.ESP, "QUESTS")
    
    -- Create Movement tab content
    local MovementContent = tabContents[5]
    nextPos = UDim2.new(0, 10, 0, 10)
    
    createSection("🚀 Movement Features", MovementContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, 50)
    
    -- Walk Speed Slider
    local WalkSpeedFrame = Instance.new("Frame")
    WalkSpeedFrame.Name = "WalkSpeedFrame"
    WalkSpeedFrame.Parent = MovementContent
    WalkSpeedFrame.Size = UDim2.new(1, -20, 0, 60)
    WalkSpeedFrame.Position = nextPos
    WalkSpeedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    WalkSpeedFrame.BorderSizePixel = 0
    
    local WalkSpeedLabel = Instance.new("TextLabel")
    WalkSpeedLabel.Name = "Label"
    WalkSpeedLabel.Parent = WalkSpeedFrame
    WalkSpeedLabel.Size = UDim2.new(1, -20, 0, 25)
    WalkSpeedLabel.Position = UDim2.new(0, 10, 0, 5)
    WalkSpeedLabel.BackgroundTransparency = 1
    WalkSpeedLabel.Text = "Walk Speed: " .. CONFIG.MOVEMENT.WALK_SPEED
    WalkSpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
    WalkSpeedLabel.TextSize = 15
    WalkSpeedLabel.Font = Enum.Font.Gotham
    WalkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local WalkSpeedSlider = Instance.new("TextBox")
    WalkSpeedSlider.Name = "Slider"
    WalkSpeedSlider.Parent = WalkSpeedFrame
    WalkSpeedSlider.Size = UDim2.new(1, -20, 0, 25)
    WalkSpeedSlider.Position = UDim2.new(0, 10, 0, 30)
    WalkSpeedSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    WalkSpeedSlider.BorderSizePixel = 0
    WalkSpeedSlider.Text = tostring(CONFIG.MOVEMENT.WALK_SPEED)
    WalkSpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
    WalkSpeedSlider.TextSize = 15
    WalkSpeedSlider.Font = Enum.Font.Gotham
    WalkSpeedSlider.CornerRadius = UDim.new(0, 4)
    
    WalkSpeedSlider.FocusLost:Connect(function()
        local newSpeed = tonumber(WalkSpeedSlider.Text)
        if newSpeed and newSpeed > 0 and newSpeed <= 500 then
            CONFIG.MOVEMENT.WALK_SPEED = newSpeed
            Movement.setWalkSpeed(newSpeed)
            WalkSpeedLabel.Text = "Walk Speed: " .. newSpeed
        else
            WalkSpeedSlider.Text = tostring(CONFIG.MOVEMENT.WALK_SPEED)
        end
    end)
    
    WalkSpeedFrame.CornerRadius = UDim.new(0, 4)
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 70)
    
    createToggle("Fly mode (Space/Shift controls)", MovementContent, nextPos, CONFIG.MOVEMENT, "FLY_ENABLED")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Noclip mode", MovementContent, nextPos, CONFIG.MOVEMENT, "NOCLIP_ENABLED")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Smart teleportation", MovementContent, nextPos)
    
    -- Create Auto tab content
    local AutoContent = tabContents[6]
    nextPos = UDim2.new(0, 10, 0, 10)
    
    createSection("💰 Auto Features", AutoContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, 50)
    
    createToggle("Auto collect chests", AutoContent, nextPos, CONFIG.AUTO, "COLLECT_CHESTS")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Auto eat fruits", AutoContent, nextPos, CONFIG.AUTO, "EAT_FRUITS")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Auto store fruits", AutoContent, nextPos, CONFIG.AUTO, "STORE_FRUITS")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Auto rejoin when kicked", AutoContent, nextPos, CONFIG.AUTO, "REJOIN")
    nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 40)
    
    createToggle("Auto stat point distribution", AutoContent, nextPos, CONFIG.COMBAT, "AUTO_STATS")
    
    -- Create Controls tab content
    local ControlsContent = tabContents[7]
    nextPos = UDim2.new(0, 10, 0, 10)
    
    createSection("⌨️ Easy Controls", ControlsContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, 50)
    
    -- Create Controls info
    local ControlsInfo = {
        {key = "F1", desc = "Start/Stop all automation"},
        {key = "F2", desc = "Toggle auto farm"},
        {key = "F3", desc = "Toggle ESP"},
        {key = "F4", desc = "Toggle fly mode"}
    }
    
    for i, info in ipairs(ControlsInfo) do
        local ControlFrame = Instance.new("Frame")
        ControlFrame.Name = "Control" .. i
        ControlFrame.Parent = ControlsContent
        ControlFrame.Size = UDim2.new(1, -20, 0, 40)
        ControlFrame.Position = nextPos
        ControlFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        ControlFrame.BorderSizePixel = 0
        
        local KeyLabel = Instance.new("TextLabel")
        KeyLabel.Name = "Key"
        KeyLabel.Parent = ControlFrame
        KeyLabel.Size = UDim2.new(0, 60, 1, 0)
        KeyLabel.Position = UDim2.new(0, 15, 0, 0)
        KeyLabel.BackgroundTransparency = 1
        KeyLabel.Text = info.key
        KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyLabel.TextSize = 18
        KeyLabel.Font = Enum.Font.GothamBold
        KeyLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Name = "Description"
        DescLabel.Parent = ControlFrame
        DescLabel.Size = UDim2.new(1, -90, 1, 0)
        DescLabel.Position = UDim2.new(0, 85, 0, 0)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = info.desc
        DescLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
        DescLabel.TextSize = 15
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        ControlFrame.CornerRadius = UDim.new(0, 4)
        
        nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 45)
    end
    
    -- Create Sea 1 Data tab content
    local Sea1DataContent = tabContents[8]
    nextPos = UDim2.new(0, 10, 0, 10)
    
    createSection("📊 Sea 1 Complete Data", Sea1DataContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, 50)
    
    -- Create Sea 1 Data sections
    local Sea1Sections = {
        {title = "Islands", data = "All 12 islands with coordinates"},
        {title = "Enemies", data = "All enemies with level ranges"},
        {title = "Bosses", data = "All bosses with locations"},
        {title = "Quest Givers", data = "Quest giver locations"},
        {title = "Fruits", data = "Complete fruit list"}
    }
    
    for i, section in ipairs(Sea1Sections) do
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = "Section" .. i
        SectionFrame.Parent = Sea1DataContent
        SectionFrame.Size = UDim2.new(1, -20, 0, 70)
        SectionFrame.Position = nextPos
        SectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        SectionFrame.BorderSizePixel = 0
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "Title"
        SectionTitle.Parent = SectionFrame
        SectionTitle.Size = UDim2.new(1, -20, 0, 30)
        SectionTitle.Position = UDim2.new(0, 10, 0, 5)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = section.title
        SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionTitle.TextSize = 17
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local SectionData = Instance.new("TextLabel")
        SectionData.Name = "Data"
        SectionData.Parent = SectionFrame
        SectionData.Size = UDim2.new(1, -20, 0, 30)
        SectionData.Position = UDim2.new(0, 10, 0, 35)
        SectionData.BackgroundTransparency = 1
        SectionData.Text = "✅ " .. section.data
        SectionData.TextColor3 = Color3.fromRGB(100, 255, 100)
        SectionData.TextSize = 15
        SectionData.Font = Enum.Font.Gotham
        SectionData.TextXAlignment = Enum.TextXAlignment.Left
        SectionData.TextWrapped = true
        
        SectionFrame.CornerRadius = UDim.new(0, 4)
        
        nextPos = UDim2.new(0, 10, 0, nextPos.Y.Offset + 75)
    end
    
    -- Create Credits tab content
    local CreditsContent = tabContents[9]
    nextPos = UDim2.new(0, 10, 0, 10)
    
    createSection("👤 Credits", CreditsContent, nextPos)
    nextPos = UDim2.new(0, 10, 0, 50)
    
    -- Discord Section
    local DiscordFrame = Instance.new("Frame")
    DiscordFrame.Name = "DiscordFrame"
    DiscordFrame.Parent = CreditsContent
    DiscordFrame.Size = UDim2.new(1, -20, 0, 180)
    DiscordFrame.Position = nextPos
    DiscordFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    DiscordFrame.BorderSizePixel = 0
    
    local DiscordImage = Instance.new("ImageLabel")
    DiscordImage.Name = "DiscordImage"
    DiscordImage.Parent = DiscordFrame
    DiscordImage.Size = UDim2.new(0, 100, 0, 100)
    DiscordImage.Position = UDim2.new(0.5, -50, 0, 15)
    DiscordImage.BackgroundTransparency = 1
    DiscordImage.Image = "rbxassetid://113520323335055"
    
    local DiscordText = Instance.new("TextLabel")
    DiscordText.Name = "DiscordText"
    DiscordText.Parent = DiscordFrame
    DiscordText.Size = UDim2.new(1, -20, 0, 25)
    DiscordText.Position = UDim2.new(0, 10, 0, 125)
    DiscordText.BackgroundTransparency = 1
    DiscordText.Text = "Join our Discord community for updates and support!"
    DiscordText.TextColor3 = Color3.fromRGB(220, 220, 225)
    DiscordText.TextSize = 15
    DiscordText.Font = Enum.Font.Gotham
    DiscordText.TextXAlignment = Enum.TextXAlignment.Center
    DiscordText.TextWrapped = true
    
    local JoinDiscordBtn = Instance.new("TextButton")
    JoinDiscordBtn.Name = "JoinDiscordBtn"
    JoinDiscordBtn.Parent = DiscordFrame
    JoinDiscordBtn.Size = UDim2.new(0, 170, 0, 35)
    JoinDiscordBtn.Position = UDim2.new(0.5, -85, 0, 140)
    JoinDiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    JoinDiscordBtn.BorderSizePixel = 0
    JoinDiscordBtn.Text = "Join Discord"
    JoinDiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    JoinDiscordBtn.TextSize = 16
    JoinDiscordBtn.Font = Enum.Font.GothamBold
    JoinDiscordBtn.CornerRadius = UDim.new(0, 4)
    
    JoinDiscordBtn.MouseButton1Click:Connect(function()
        game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/kkVnwtfn")
    end)
    
    JoinDiscordBtn.MouseEnter:Connect(function()
        TweenService:Create(JoinDiscordBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(102, 126, 234)}):Play()
    end)
    
    JoinDiscordBtn.MouseLeave:Connect(function()
        TweenService:Create(JoinDiscordBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
    end)
    
    DiscordFrame.CornerRadius = UDim.new(0, 4)
    
    -- Creator Text
    local CreatorText = Instance.new("TextLabel")
    CreatorText.Name = "CreatorText"
    CreatorText.Parent = CreditsContent
    CreatorText.Size = UDim2.new(1, -20, 0, 25)
    CreatorText.Position = UDim2.new(0, 10, 0, nextPos.Y.Offset + 190)
    CreatorText.BackgroundTransparency = 1
    CreatorText.Text = "Made By Michel"
    CreatorText.TextColor3 = Color3.fromRGB(180, 180, 185)
    CreatorText.TextSize = 14
    CreatorText.Font = Enum.Font.GothamItalic
    CreatorText.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Open Hub Button
    local OpenHubBtn = Instance.new("ImageButton")
    OpenHubBtn.Name = "OpenHubBtn"
    OpenHubBtn.Parent = ScreenGui
    OpenHubBtn.Size = UDim2.new(0, 60, 0, 60)
    OpenHubBtn.Position = UDim2.new(0, 20, 0.5, -30)
    OpenHubBtn.BackgroundTransparency = 1
    OpenHubBtn.Image = "rbxassetid://73162230845258"
    OpenHubBtn.Visible = true
    OpenHubBtn.ZIndex = 10
    
    -- Button functionality
    local minimized = false
    local maximized = false
    local originalSize = MainFrame.Size
    local originalPosition = MainFrame.Position
    
    -- Minimize Button
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 250, 0, 35)}):Play()
            ContentContainer.Visible = false
            TabContainer.Visible = false
            OpenHubBtn.Visible = true
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = originalSize}):Play()
            ContentContainer.Visible = true
            TabContainer.Visible = true
            OpenHubBtn.Visible = false
        end
    end)
    
    -- Maximize Button
    MaximizeBtn.MouseButton1Click:Connect(function()
        maximized = not maximized
        if maximized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(1, -40, 1, -40),
                Position = UDim2.new(0, 20, 0, 20)
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                Size = originalSize,
                Position = originalPosition
            }):Play()
        end
    end)
    
    -- Close Button
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenHubBtn.Visible = true
    end)
    
    -- Open Hub Button
    OpenHubBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenHubBtn.Visible = false
        if minimized then
            minimized = false
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = originalSize}):Play()
            ContentContainer.Visible = true
            TabContainer.Visible = true
        end
    end)
    
    -- Grow animation when opening
    local function openAnimation()
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Size = originalSize,
            Position = originalPosition
        })
        tween:Play()
    end
    
    -- Initial animation
    openAnimation()
    
    -- Store UI references
    ScriptHub.UI = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        OpenHubBtn = OpenHubBtn
    }
    
    return ScreenGui
end

-- ===============================================
-- HOTKEY BINDINGS
-- ===============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        if ScriptHub.isRunning then
            stopScript()
        else
            startScript()
        end
    elseif input.KeyCode == Enum.KeyCode.F2 then
        CONFIG.COMBAT.AUTO_FARM_ENABLED = not CONFIG.COMBAT.AUTO_FARM_ENABLED
        print("🎯 Auto Farm:", CONFIG.COMBAT.AUTO_FARM_ENABLED and "ON" or "OFF")
    elseif input.KeyCode == Enum.KeyCode.F3 then
        CONFIG.ESP.PLAYERS = not CONFIG.ESP.PLAYERS
        CONFIG.ESP.FRUITS = not CONFIG.ESP.FRUITS
        print("🔍 ESP:", CONFIG.ESP.PLAYERS and "ON" or "OFF")
    elseif input.KeyCode == Enum.KeyCode.F4 then
        Movement.fly(not CONFIG.MOVEMENT.FLY_ENABLED)
        print("🚀 Fly:", CONFIG.MOVEMENT.FLY_ENABLED and "ON" or "OFF")
    end
end)

-- ===============================================
-- MOBILE TOUCH CONTROLS
-- ===============================================
local function setupMobileControls()
    -- Create mobile fly controls
    local flyUpButton = Instance.new("TextButton")
    flyUpButton.Name = "FlyUpButton"
    flyUpButton.Parent = ScriptHub.UI.ScreenGui
    flyUpButton.Size = UDim2.new(0, 60, 0, 60)
    flyUpButton.Position = UDim2.new(0, 100, 0.5, -100)
    flyUpButton.BackgroundColor3 = Color3.fromRGB(65, 130, 220)
    flyUpButton.BorderSizePixel = 0
    flyUpButton.Text = "↑"
    flyUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyUpButton.TextSize = 30
    flyUpButton.Font = Enum.Font.GothamBold
    flyUpButton.Visible = false
    flyUpButton.CornerRadius = UDim.new(0, 10)
    
    local flyDownButton = Instance.new("TextButton")
    flyDownButton.Name = "FlyDownButton"
    flyDownButton.Parent = ScriptHub.UI.ScreenGui
    flyDownButton.Size = UDim2.new(0, 60, 0, 60)
    flyDownButton.Position = UDim2.new(0, 100, 0.5, 40)
    flyDownButton.BackgroundColor3 = Color3.fromRGB(65, 130, 220)
    flyDownButton.BorderSizePixel = 0
    flyDownButton.Text = "↓"
    flyDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyDownButton.TextSize = 30
    flyDownButton.Font = Enum.Font.GothamBold
    flyDownButton.Visible = false
    flyDownButton.CornerRadius = UDim.new(0, 10)
    
    -- Show/hide mobile fly controls based on fly mode
    local function updateMobileFlyControls()
        flyUpButton.Visible = CONFIG.MOVEMENT.FLY_ENABLED
        flyDownButton.Visible = CONFIG.MOVEMENT.FLY_ENABLED
    end
    
    -- Connect to config changes
    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function()
        updateMobileFlyControls()
    end)
    
    -- Mobile fly controls functionality
    local flyingUp = false
    local flyingDown = false
    
    flyUpButton.TouchBegan:Connect(function()
        flyingUp = true
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("BodyVelocity") then
            rootPart.BodyVelocity.Velocity = Vector3.new(0, 50, 0)
        end
    end)
    
    flyUpButton.TouchEnded:Connect(function()
        flyingUp = false
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("BodyVelocity") and not flyingDown then
            rootPart.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    flyDownButton.TouchBegan:Connect(function()
        flyingDown = true
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("BodyVelocity") then
            rootPart.BodyVelocity.Velocity = Vector3.new(0, -50, 0)
        end
    end)
    
    flyDownButton.TouchEnded:Connect(function()
        flyingDown = false
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("BodyVelocity") and not flyingUp then
            rootPart.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Store mobile controls
    ScriptHub.UI.MobileControls = {
        FlyUpButton = flyUpButton,
        FlyDownButton = flyDownButton,
        Connection = conn
    }
end

-- ===============================================
-- INITIALIZATION
-- ===============================================
-- Create UI
local ui = createUI()

-- Set up mobile controls
setupMobileControls()

-- Make functions global
_G.BloxFruitsHub = {
    start = startScript,
    stop = stopScript,
    teleport = Teleport,
    movement = Movement,
    config = CONFIG,
    combat = Combat,
    quest = Quest,
    auto = Auto,
    esp = ESP
}

print("🎮 Script loaded! Press F1 to start automation!")
print("📊 Current Sea Level:", CONFIG.SEA_LEVEL)
print("📱 Mobile controls enabled!")
