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
            {name = "Monkey", level = {14, 16}, location = CFrame.new(-1448, 50, 11), questGiver = "Jungle Quest"},
            
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
    originalWalkSpeed = 16
}

-- Auto-update character reference
local function updateCharacter()
    character = player.Character
    if character then
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
        if humanoid then
            ScriptHub.originalWalkSpeed = humanoid.WalkSpeed
        end
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
        if player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") then
            return player.Data.Level.Value
        end
        return 1
    end)
    return success and level or 1
end

local function getPlayerHealth()
    if humanoid and humanoid.Health and humanoid.MaxHealth then
        return (humanoid.Health / humanoid.MaxHealth) * 100
    end
    return 0
end

-- Fixed fireproximityprompt function
local function fireProximityPrompt(prompt)
    if prompt and prompt.ClassName == "ProximityPrompt" then
        prompt:InputHoldBegin()
        wait(0.5)
        prompt:InputHoldEnd()
    end
end

-- ===============================================
-- COMBAT SYSTEM
-- ===============================================
local Combat = {}
function Combat.findNearestEnemy(maxDistance)
    if not rootPart then return nil end
    
    maxDistance = maxDistance or 50
    local nearestEnemy = nil
    local shortestDistance = maxDistance
    
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
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
    if not enemy or not enemy.Parent or not rootPart then
        return false
    end
    
    if not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0 then
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
        wait(CONFIG.COMBAT.SKILL_DELAY)
    end
end

function Combat.farmEnemies()
    if not CONFIG.COMBAT.AUTO_FARM_ENABLED or not rootPart then return end
    
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
    if not rootPart then return false end
    
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
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end)
    
    return true
end

function Quest.autoQuest()
    if not CONFIG.COMBAT.AUTO_QUEST_ENABLED or not rootPart then return end
    
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
    billboard.Name = "ESP_" .. obj.Name
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
    
    -- Clean up ESP when object is removed
    obj.AncestryChanged:Connect(function(_, newParent)
        if not newParent then
            ESP.removeESP(obj)
        end
    end)
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
            local char = otherPlayer.Character
            if char:FindFirstChild("HumanoidRootPart") then
                local level = "Unknown"
                if otherPlayer:FindFirstChild("Data") and otherPlayer.Data:FindFirstChild("Level") then
                    level = tostring(otherPlayer.Data.Level.Value)
                end
                
                ESP.createESP(
                    char.HumanoidRootPart,
                    Color3.new(1, 0, 0),
                    otherPlayer.Name .. "\nLvl: " .. level
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
    if not CONFIG.AUTO.COLLECT_CHESTS or not rootPart then return end
    
    for _, chest in pairs(Workspace:GetChildren()) do
        if (chest.Name == "Chest1" or chest.Name == "Chest2" or chest.Name == "Chest3") and chest:FindFirstChild("Base") then
            local distance = (rootPart.Position - chest.Base.Position).Magnitude
            if distance < 50 then
                rootPart.CFrame = chest.Base.CFrame
                wait(0.5)
                
                -- Collect chest
                if chest.Base:FindFirstChild("ProximityPrompt") then
                    fireProximityPrompt(chest.Base.ProximityPrompt)
                end
            end
        end
    end
end

function Auto.collectFruits()
    if not (CONFIG.AUTO.EAT_FRUITS or CONFIG.AUTO.STORE_FRUITS) or not rootPart then return end
    
    for _, fruit in pairs(Workspace:GetChildren()) do
        if fruit.Name:find("Fruit") and fruit:FindFirstChild("Handle") then
            local distance = (rootPart.Position - fruit.Handle.Position).Magnitude
            if distance < 50 then
                rootPart.CFrame = fruit.Handle.CFrame
                wait(0.5)
                
                if fruit.Handle:FindFirstChild("ProximityPrompt") then
                    if CONFIG.AUTO.EAT_FRUITS then
                        -- Eat fruit
                        fireProximityPrompt(fruit.Handle.ProximityPrompt)
                    elseif CONFIG.AUTO.STORE_FRUITS then
                        -- Store fruit logic here
                        print("Storing fruit:", fruit.Name)
                    end
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
    
    if enabled and rootPart then
        -- Remove existing body velocity if any
        if rootPart:FindFirstChild("FlyVelocity") then
            rootPart.FlyVelocity:Destroy()
        end
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
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
        if rootPart and rootPart:FindFirstChild("FlyVelocity") then
            rootPart.FlyVelocity:Destroy()
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
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if ScriptHub.connections.noclip then
            ScriptHub.connections.noclip:Disconnect()
        end
        
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- ===============================================
-- TELEPORTATION SYSTEM
-- ===============================================
local Teleport = {}
function Teleport.toIsland(islandName)
    if not rootPart then return false end
    
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
    if not rootPart then return false end
    
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
        
        wait(0.2) -- Main loop delay (slightly increased for performance)
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
    
    -- Clean up ESP objects
    for obj, esp in pairs(ESP.objects) do
        if esp then
            esp:Destroy()
        end
    end
    ESP.objects = {}
    
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
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 350, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TopBar.BorderSizePixel = 0
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Script Hub X"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = TopBar
    CloseBtn.Size = UDim2.new(0, 40, 0, 30)
    CloseBtn.Position = UDim2.new(1, -45, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.Size = UDim2.new(1, 0, 0, 40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabContainer.BorderSizePixel = 0
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.Size = UDim2.new(1, 0, 1, -80)
    ContentContainer.Position = UDim2.new(0, 0, 0, 80)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ContentContainer.BorderSizePixel = 0
    
    -- Create tabs
    local tabs = {"Combat", "Navigation", "ESP", "Movement", "Auto", "Controls", "Data", "Credits"}
    local tabButtons = {}
    local tabContents = {}
    
    for i, tabName in ipairs(tabs) do
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.Size = UDim2.new(1 / #tabs, 0, 1, 0)
        TabButton.Position = UDim2.new((i-1) / #tabs, 0, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        TabButton.BorderSizePixel = 0
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 205)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Parent = ContentContainer
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TabContent.BorderSizePixel = 0
        TabContent.Visible = (i == 1)
        TabContent.ScrollBarThickness = 5
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
        
        table.insert(tabButtons, TabButton)
        table.insert(tabContents, TabContent)
        
        -- Tab Button Click Event
        TabButton.MouseButton1Click:Connect(function()
            for j, content in ipairs(tabContents) do
                content.Visible = (j == i)
            end
            for j, button in ipairs(tabButtons) do
                if j == i then
                    button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                    button.TextColor3 = Color3.fromRGB(200, 200, 205)
                end
            end
        end)
    end
    
    -- Create toggle function
    local function createToggle(name, parent, configTable, configKey)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = name .. "Toggle"
        ToggleFrame.Parent = parent
        ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        ToggleFrame.BorderSizePixel = 0
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Name = "Label"
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.TextWrapped = true
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "Button"
        ToggleButton.Parent = ToggleFrame
        ToggleButton.Size = UDim2.new(0, 50, 0, 25)
        ToggleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Text = ""
        ToggleButton.Font = Enum.Font.Gotham
        ToggleButton.TextSize = 14
        
        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Name = "Indicator"
        ToggleIndicator.Parent = ToggleButton
        ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
        ToggleIndicator.Position = UDim2.new(0, 3, 0, 2.5)
        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
        ToggleIndicator.BorderSizePixel = 0
        
        ToggleButton.CornerRadius = UDim.new(0, 4)
        ToggleFrame.CornerRadius = UDim.new(0, 4)
        
        -- Set initial state
        local enabled = configTable and configKey and configTable[configKey] or false
        
        if enabled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(65, 130, 220)
            ToggleIndicator.Position = UDim2.new(0, 27, 0, 2.5)
        end
        
        ToggleButton.MouseButton1Click:Connect(function()
            enabled = not enabled
            if configTable and configKey then
                configTable[configKey] = enabled
            end
            
            if enabled then
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 130, 220)}):Play()
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 27, 0, 2.5)}):Play()
            else
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 85)}):Play()
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0, 2.5)}):Play()
            end
        end)
        
        return ToggleFrame
    end
    
    -- Create button function
    local function createButton(name, parent, callback)
        local Button = Instance.new("TextButton")
        Button.Name = name .. "Button"
        Button.Parent = parent
        Button.Size = UDim2.new(1, -20, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        Button.BorderSizePixel = 0
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(220, 220, 225)
        Button.TextSize = 14
        Button.Font = Enum.Font.Gotham
        Button.CornerRadius = UDim.new(0, 4)
        
        Button.MouseButton1Click:Connect(callback)
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
        end)
        
        return Button
    end
    
    -- Create label function
    local function createLabel(text, parent)
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Parent = parent
        Label.Size = UDim2.new(1, -20, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(200, 200, 205)
        Label.TextSize = 14
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextWrapped = true
        
        return Label
    end
    
    -- Populate Combat tab
    local CombatContent = tabContents[1]
    createToggle("Auto Farm Enemies", CombatContent, CONFIG.COMBAT, "AUTO_FARM_ENABLED")
    createToggle("Auto Quest System", CombatContent, CONFIG.COMBAT, "AUTO_QUEST_ENABLED")
    createToggle("Smart Enemy Targeting", CombatContent)
    createToggle("Skill Rotation (Z, X, C, V)", CombatContent, CONFIG.COMBAT, "USE_SKILLS")
    createToggle("Safety Stop (Low Health)", CombatContent)
    
    -- Populate Navigation tab
    local NavigationContent = tabContents[2]
    createButton("Teleport to Starter Island", NavigationContent, function()
        Teleport.toIsland("Starter Island")
    end)
    createButton("Teleport to Marine Base", NavigationContent, function()
        Teleport.toIsland("Marine Base")
    end)
    createButton("Teleport to Jungle", NavigationContent, function()
        Teleport.toIsland("Jungle")
    end)
    createButton("Teleport to Desert", NavigationContent, function()
        Teleport.toIsland("Desert")
    end)
    createButton("Teleport to Frozen Village", NavigationContent, function()
        Teleport.toIsland("Frozen Village")
    end)
    createButton("Teleport to Skylands", NavigationContent, function()
        Teleport.toIsland("Skylands")
    end)
    
    -- Populate ESP tab
    local ESPContent = tabContents[3]
    createToggle("Player ESP (Name + Level)", ESPContent, CONFIG.ESP, "PLAYERS")
    createToggle("Fruit ESP with Highlighting", ESPContent, CONFIG.ESP, "FRUITS")
    createToggle("Enemy ESP", ESPContent, CONFIG.ESP, "NPCS")
    createToggle("Chest ESP", ESPContent, CONFIG.ESP, "CHESTS")
    createToggle("Quest Giver ESP", ESPContent, CONFIG.ESP, "QUESTS")
    
    -- Populate Movement tab
    local MovementContent = tabContents[4]
    createToggle("Fly Mode (Space/Shift)", MovementContent, CONFIG.MOVEMENT, "FLY_ENABLED")
    createToggle("Noclip Mode", MovementContent, CONFIG.MOVEMENT, "NOCLIP_ENABLED")
    
    local WalkSpeedFrame = Instance.new("Frame")
    WalkSpeedFrame.Name = "WalkSpeedFrame"
    WalkSpeedFrame.Parent = MovementContent
    WalkSpeedFrame.Size = UDim2.new(1, -20, 0, 50)
    WalkSpeedFrame.Position = UDim2.new(0, 10, 0, 150)
    WalkSpeedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    WalkSpeedFrame.BorderSizePixel = 0
    
    local WalkSpeedLabel = Instance.new("TextLabel")
    WalkSpeedLabel.Name = "Label"
    WalkSpeedLabel.Parent = WalkSpeedFrame
    WalkSpeedLabel.Size = UDim2.new(1, -20, 0, 20)
    WalkSpeedLabel.Position = UDim2.new(0, 10, 0, 5)
    WalkSpeedLabel.BackgroundTransparency = 1
    WalkSpeedLabel.Text = "Walk Speed: " .. CONFIG.MOVEMENT.WALK_SPEED
    WalkSpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
    WalkSpeedLabel.TextSize = 14
    WalkSpeedLabel.Font = Enum.Font.Gotham
    
    local WalkSpeedInput = Instance.new("TextBox")
    WalkSpeedInput.Name = "Input"
    WalkSpeedInput.Parent = WalkSpeedFrame
    WalkSpeedInput.Size = UDim2.new(1, -20, 0, 25)
    WalkSpeedInput.Position = UDim2.new(0, 10, 0, 25)
    WalkSpeedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    WalkSpeedInput.BorderSizePixel = 0
    WalkSpeedInput.Text = tostring(CONFIG.MOVEMENT.WALK_SPEED)
    WalkSpeedInput.TextColor3 = Color3.fromRGB(220, 220, 225)
    WalkSpeedInput.TextSize = 14
    WalkSpeedInput.Font = Enum.Font.Gotham
    
    WalkSpeedInput.FocusLost:Connect(function()
        local newSpeed = tonumber(WalkSpeedInput.Text)
        if newSpeed and newSpeed > 0 then
            CONFIG.MOVEMENT.WALK_SPEED = newSpeed
            WalkSpeedLabel.Text = "Walk Speed: " .. newSpeed
            if humanoid then
                humanoid.WalkSpeed = newSpeed
            end
        else
            WalkSpeedInput.Text = tostring(CONFIG.MOVEMENT.WALK_SPEED)
        end
    end)
    
    WalkSpeedFrame.CornerRadius = UDim.new(0, 4)
    
    -- Populate Auto tab
    local AutoContent = tabContents[5]
    createToggle("Auto Collect Chests", AutoContent, CONFIG.AUTO, "COLLECT_CHESTS")
    createToggle("Auto Eat Fruits", AutoContent, CONFIG.AUTO, "EAT_FRUITS")
    createToggle("Auto Store Fruits", AutoContent, CONFIG.AUTO, "STORE_FRUITS")
    createToggle("Auto Rejoin When Kicked", AutoContent, CONFIG.AUTO, "REJOIN")
    
    -- Populate Controls tab
    local ControlsContent = tabContents[6]
    createLabel("F1 - Start/Stop All Automation", ControlsContent)
    createLabel("F2 - Toggle Auto Farm", ControlsContent)
    createLabel("F3 - Toggle ESP", ControlsContent)
    createLabel("F4 - Toggle Fly Mode", ControlsContent)
    
    -- Populate Data tab
    local DataContent = tabContents[7]
    createLabel("✅ All 12 islands with coordinates", DataContent)
    createLabel("✅ All enemies with level ranges", DataContent)
    createLabel("✅ All bosses with locations", DataContent)
    createLabel("✅ Quest giver locations", DataContent)
    createLabel("✅ Complete fruit list", DataContent)
    
    -- Populate Credits tab
    local CreditsContent = tabContents[8]
    
    local DiscordFrame = Instance.new("Frame")
    DiscordFrame.Name = "DiscordFrame"
    DiscordFrame.Parent = CreditsContent
    DiscordFrame.Size = UDim2.new(1, -20, 0, 150)
    DiscordFrame.Position = UDim2.new(0, 10, 0, 10)
    DiscordFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    DiscordFrame.BorderSizePixel = 0
    
    local DiscordImage = Instance.new("ImageLabel")
    DiscordImage.Name = "DiscordImage"
    DiscordImage.Parent = DiscordFrame
    DiscordImage.Size = UDim2.new(0, 80, 0, 80)
    DiscordImage.Position = UDim2.new(0.5, -40, 0, 10)
    DiscordImage.BackgroundTransparency = 1
    DiscordImage.Image = "rbxassetid://113520323335055"
    
    local DiscordText = Instance.new("TextLabel")
    DiscordText.Name = "DiscordText"
    DiscordText.Parent = DiscordFrame
    DiscordText.Size = UDim2.new(1, -20, 0, 30)
    DiscordText.Position = UDim2.new(0, 10, 0, 100)
    DiscordText.BackgroundTransparency = 1
    DiscordText.Text = "Join our Discord community!"
    DiscordText.TextColor3 = Color3.fromRGB(220, 220, 225)
    DiscordText.TextSize = 14
    DiscordText.Font = Enum.Font.Gotham
    DiscordText.TextXAlignment = Enum.TextXAlignment.Center
    DiscordText.TextWrapped = true
    
    local JoinDiscordBtn = Instance.new("TextButton")
    JoinDiscordBtn.Name = "JoinDiscordBtn"
    JoinDiscordBtn.Parent = DiscordFrame
    JoinDiscordBtn.Size = UDim2.new(0, 150, 0, 30)
    JoinDiscordBtn.Position = UDim2.new(0.5, -75, 0, 115)
    JoinDiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    JoinDiscordBtn.BorderSizePixel = 0
    JoinDiscordBtn.Text = "Join Discord"
    JoinDiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    JoinDiscordBtn.TextSize = 14
    JoinDiscordBtn.Font = Enum.Font.GothamBold
    JoinDiscordBtn.CornerRadius = UDim.new(0, 4)
    
    JoinDiscordBtn.MouseButton1Click:Connect(function()
        game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/kkVnwtfn")
    end)
    
    local CreatorText = Instance.new("TextLabel")
    CreatorText.Name = "CreatorText"
    CreatorText.Parent = CreditsContent
    CreatorText.Size = UDim2.new(1, -20, 0, 20)
    CreatorText.Position = UDim2.new(0, 10, 0, 170)
    CreatorText.BackgroundTransparency = 1
    CreatorText.Text = "Made By Michel"
    CreatorText.TextColor3 = Color3.fromRGB(180, 180, 185)
    CreatorText.TextSize = 14
    CreatorText.Font = Enum.Font.GothamItalic
    CreatorText.TextXAlignment = Enum.TextXAlignment.Center
    
    DiscordFrame.CornerRadius = UDim.new(0, 4)
    
    -- Open Hub Button
    local OpenHubBtn = Instance.new("ImageButton")
    OpenHubBtn.Name = "OpenHubBtn"
    OpenHubBtn.Parent = ScreenGui
    OpenHubBtn.Size = UDim2.new(0, 60, 0, 60)
    OpenHubBtn.Position = UDim2.new(0, 20, 0.5, -30)
    OpenHubBtn.BackgroundTransparency = 1
    OpenHubBtn.Image = "rbxassetid://73162230845258"
    OpenHubBtn.Visible = true
    
    -- Mobile Fly Controls
    local FlyUpBtn = Instance.new("TextButton")
    FlyUpBtn.Name = "FlyUpBtn"
    FlyUpBtn.Parent = ScreenGui
    FlyUpBtn.Size = UDim2.new(0, 60, 0, 60)
    FlyUpBtn.Position = UDim2.new(0, 100, 0.5, -100)
    FlyUpBtn.BackgroundColor3 = Color3.fromRGB(65, 130, 220)
    FlyUpBtn.BorderSizePixel = 0
    FlyUpBtn.Text = "↑"
    FlyUpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlyUpBtn.TextSize = 30
    FlyUpBtn.Font = Enum.Font.GothamBold
    FlyUpBtn.Visible = false
    FlyUpBtn.CornerRadius = UDim.new(0, 10)
    
    local FlyDownBtn = Instance.new("TextButton")
    FlyDownBtn.Name = "FlyDownBtn"
    FlyDownBtn.Parent = ScreenGui
    FlyDownBtn.Size = UDim2.new(0, 60, 0, 60)
    FlyDownBtn.Position = UDim2.new(0, 100, 0.5, 40)
    FlyDownBtn.BackgroundColor3 = Color3.fromRGB(65, 130, 220)
    FlyDownBtn.BorderSizePixel = 0
    FlyDownBtn.Text = "↓"
    FlyDownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlyDownBtn.TextSize = 30
    FlyDownBtn.Font = Enum.Font.GothamBold
    FlyDownBtn.Visible = false
    FlyDownBtn.CornerRadius = UDim.new(0, 10)
    
    -- Button functionality
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenHubBtn.Visible = true
    end)
    
    OpenHubBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenHubBtn.Visible = false
    end)
    
    -- Fly controls
    FlyUpBtn.TouchBegan:Connect(function()
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("FlyVelocity") then
            rootPart.FlyVelocity.Velocity = Vector3.new(0, 50, 0)
        end
    end)
    
    FlyDownBtn.TouchBegan:Connect(function()
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("FlyVelocity") then
            rootPart.FlyVelocity.Velocity = Vector3.new(0, -50, 0)
        end
    end)
    
    FlyUpBtn.TouchEnded:Connect(function()
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("FlyVelocity") then
            rootPart.FlyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    FlyDownBtn.TouchEnded:Connect(function()
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("FlyVelocity") then
            rootPart.FlyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Update fly controls visibility
    game:GetService("RunService").Heartbeat:Connect(function()
        FlyUpBtn.Visible = CONFIG.MOVEMENT.FLY_ENABLED
        FlyDownBtn.Visible = CONFIG.MOVEMENT.FLY_ENABLED
    end)
    
    -- Notification
    local function notify(text)
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification"
        Notification.Parent = ScreenGui
        Notification.Size = UDim2.new(0, 300, 0, 80)
        Notification.Position = UDim2.new(0.5, -150, 0, -100)
        Notification.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Notification.BorderSizePixel = 0
        Notification.CornerRadius = UDim.new(0, 8)
        
        local NotificationText = Instance.new("TextLabel")
        NotificationText.Name = "Text"
        NotificationText.Parent = Notification
        NotificationText.Size = UDim2.new(1, -20, 1, -20)
        NotificationText.Position = UDim2.new(0, 10, 0, 10)
        NotificationText.BackgroundTransparency = 1
        NotificationText.Text = text
        NotificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotificationText.TextSize = 16
        NotificationText.Font = Enum.Font.Gotham
        NotificationText.TextXAlignment = Enum.TextXAlignment.Center
        NotificationText.TextYAlignment = Enum.TextYAlignment.Center
        NotificationText.TextWrapped = true
        
        -- Animate notification
        Notification:TweenPosition(UDim2.new(0.5, -150, 0, 20), "Out", "Back", 0.5)
        
        -- Remove after 3 seconds
        game:GetService("Debris"):AddItem(Notification, 3)
        
        -- Animate out
        spawn(function()
            wait(2.5)
            Notification:TweenPosition(UDim2.new(0.5, -150, 0, -100), "In", "Back", 0.5)
        end)
    end
    
    notify("Script Hub X Loaded Successfully!")
    
    return ScreenGui
end

-- ===============================================
-- MOBILE TOUCH CONTROLS
-- ===============================================
local function setupMobileControls()
    -- Create mobile fly controls
    local flyUpButton = Instance.new("TextButton")
    flyUpButton.Name = "FlyUpButton"
    flyUpButton.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
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
    flyUpButton.ZIndex = 10
    
    local flyDownButton = Instance.new("TextButton")
    flyDownButton.Name = "FlyDownButton"
    flyDownButton.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
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
    flyDownButton.ZIndex = 10
    
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
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("FlyVelocity") then
            rootPart.FlyVelocity.Velocity = Vector3.new(0, 50, 0)
        end
    end)
    
    flyUpButton.TouchEnded:Connect(function()
        flyingUp = false
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("FlyVelocity") and not flyingDown then
            rootPart.FlyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    flyDownButton.TouchBegan:Connect(function()
        flyingDown = true
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("FlyVelocity") then
            rootPart.FlyVelocity.Velocity = Vector3.new(0, -50, 0)
        end
    end)
    
    flyDownButton.TouchEnded:Connect(function()
        flyingDown = false
        if CONFIG.MOVEMENT.FLY_ENABLED and rootPart and rootPart:FindFirstChild("FlyVelocity") and not flyingUp then
            rootPart.FlyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Store mobile controls
    ScriptHub.UI = {
        FlyUpButton = flyUpButton,
        FlyDownButton = flyDownButton,
        Connection = conn
    }
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
