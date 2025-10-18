-- Load The Library
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ========================================
-- SERVICES
-- ========================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterPlayer = game:GetService("StarterPlayer")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- ========================================
-- PLAYER VARIABLES
-- ========================================
local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ========================================
-- ANTI-RAGDOLL VARIABLES
-- ========================================
local antiRagdollConnections = {}
local antiRagdollMonitoringConnections = {}
local MAX_VELOCITY = 500
local MAX_ANGULAR_VELOCITY = 100
local EXTREME_VELOCITY_THRESHOLD = 1000

-- ========================================
-- BYPASSED VARIABLES
-- ========================================
local grappleHookConnection = nil

-- ========================================
-- STEAL COUNT VARIABLES
-- ========================================
local lastStealCount = 0
local isMonitoring = false

-- ========================================
-- PLATFORM VARIABLES
-- ========================================
local platformEnabled = false
local currentPlatform = nil
local platformUpdateConnection = nil
local PLATFORM_OFFSET = 3.6

-- ========================================
-- SLOW FALL VARIABLES
-- ========================================
local SLOW_FALL_SPEED = -0.45 
local originalGravity = nil
local bodyVelocity = nil
local elevationBodyVelocity = nil

-- ========================================
-- WALL TRANSPARENCY VARIABLES
-- ========================================
local wallTransparencyEnabled = false
local originalTransparencies = {}
local TRANSPARENCY_LEVEL = 0.6
local playerCollisionConnection = nil

-- ========================================
-- COMBO FLOAT + WALL VARIABLES
-- ========================================
local comboFloatEnabled = false
local comboCurrentPlatform = nil
local comboPlatformUpdateConnection = nil
local comboPlayerCollisionConnection = nil
local COMBO_PLATFORM_OFFSET = 3.7

-- ========================================
-- TELEPORT TO HIGHEST BRAINROT VARIABLES
-- ========================================
local teleportEnabled = false
local teleportGrappleConnection = nil
local lastClickTime = 0
local DOUBLE_CLICK_PREVENTION_TIME = 1.5
local highestBrainrotData = nil
local teleportOverlay = nil

-- ========================================
-- HIGHEST VALUE ESP VARIABLES
-- ========================================
local highestValueESP = nil
local highestValueData = nil
local espUpdateConnection = nil
local tracerUpdateConnection = nil

-- ========================================
-- TARGET BRAINROT NAMES
-- ========================================
local brainrotNames = {
    "Los Tralaleritos", "Guerriro Digitale", "Las Tralaleritas", "Job Job Job Sahur",
    "Las Vaquitas Saturnitas", "Graipuss Medussi", "Noo My Hotspot", "Sahur Combinasion",
    "Pot Hotspot", "Chicleteira Bicicleteira", "Los Nooo My Hotspotsitos", "La Grande Combinasion",
    "Los Combinasionas", "Nuclearo Dinossauro", "Karkerkar combinasion", "Los Hotspotsitos",
    "Tralaledon", "Esok Sekolah", "Ketupat Kepat", "Los Bros", "La Supreme Combinasion",
    "Ketchuru and Masturu", "Garama and Madundung", "Spaghetti Tualetti", "Dragon Cannelloni",
    "Blackhole Goat", "Agarrini la Palini", "Los Spyderinis", "Fragola la la la", "Strawberry Elephant"
}

-- ========================================
-- CREATE LOOKUP TABLE
-- ========================================
local brainrotLookup = {}
for _, name in pairs(brainrotNames) do
    brainrotLookup[name] = true
end

-- ========================================
-- ESP VARIABLES
-- ========================================
local plotDisplays = {}
local playerBaseName = LocalPlayer.DisplayName .. "'s Base"
local playerBaseTimeWarning = false
local alertGui = nil

local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- GLOBAL STATES
-- ========================================
local States = {
    FullBright = false,
    LowGFX = false,
    AntiRagdoll = false,
    Float = false,
    FloorSteal = false,
    ESP = false,
    MonitorSteals = false,
}

-- ========================================
-- CONNECTIONS STORAGE
-- ========================================
local Connections = {
    LowGFX = nil,
    AntiRagdoll = nil,
}

-- ========================================
-- LOW GFX STORAGE
-- ========================================
local LowGFXStorage = {
    SavedProperties = {},
    SavedLighting = {},
}

-- ========================================
-- THEMES
-- ========================================
WindUI:AddTheme({
    Name = "Dark",
    Accent = Color3.fromHex("#FF0F7B"),
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FF0F7B"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#FF0F7B")
})

WindUI:AddTheme({
    Name = "Light",
    Accent = Color3.fromHex("#F89B29"),
    Dialog = Color3.fromHex("#f5f5f5"),
    Outline = Color3.fromHex("#F89B29"),
    Text = Color3.fromHex("#000000"),
    Placeholder = Color3.fromHex("#5a5a5a"),
    Background = Color3.fromHex("#ffffff"),
    Button = Color3.fromHex("#e5e5e5"),
    Icon = Color3.fromHex("#F89B29")
})

WindUI:AddTheme({
    Name = "Purple Dream",
    Accent = Color3.fromHex("#9333EA"),
    Dialog = Color3.fromHex("#1a1625"),
    Outline = Color3.fromHex("#A855F7"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0f0b16"),
    Button = Color3.fromHex("#4c2a6e"),
    Icon = Color3.fromHex("#C084FC")
})

WindUI:AddTheme({
    Name = "Ocean Blue",
    Accent = Color3.fromHex("#0EA5E9"),
    Dialog = Color3.fromHex("#161e28"),
    Outline = Color3.fromHex("#38BDF8"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1420"),
    Button = Color3.fromHex("#1e3a5f"),
    Icon = Color3.fromHex("#7DD3FC")
})

WindUI:AddTheme({
    Name = "Forest Green",
    Accent = Color3.fromHex("#10B981"),
    Dialog = Color3.fromHex("#16211c"),
    Outline = Color3.fromHex("#34D399"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1610"),
    Button = Color3.fromHex("#1e4d3a"),
    Icon = Color3.fromHex("#6EE7B7")
})

WindUI:AddTheme({
    Name = "Crimson Red",
    Accent = Color3.fromHex("#DC2626"),
    Dialog = Color3.fromHex("#211616"),
    Outline = Color3.fromHex("#EF4444"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#180a0a"),
    Button = Color3.fromHex("#5f1e1e"),
    Icon = Color3.fromHex("#F87171")
})

WindUI:AddTheme({
    Name = "Sunset Orange",
    Accent = Color3.fromHex("#F97316"),
    Dialog = Color3.fromHex("#211a16"),
    Outline = Color3.fromHex("#FB923C"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#18120a"),
    Button = Color3.fromHex("#5f371e"),
    Icon = Color3.fromHex("#FDBA74")
})

WindUI:AddTheme({
    Name = "Midnight Purple",
    Accent = Color3.fromHex("#7C3AED"),
    Dialog = Color3.fromHex("#1a1625"),
    Outline = Color3.fromHex("#8B5CF6"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0f0a18"),
    Button = Color3.fromHex("#3d2a5f"),
    Icon = Color3.fromHex("#A78BFA")
})

WindUI:AddTheme({
    Name = "Cyan Glow",
    Accent = Color3.fromHex("#06B6D4"),
    Dialog = Color3.fromHex("#162228"),
    Outline = Color3.fromHex("#22D3EE"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1418"),
    Button = Color3.fromHex("#1e4550"),
    Icon = Color3.fromHex("#67E8F9")
})

WindUI:AddTheme({
    Name = "Rose Pink",
    Accent = Color3.fromHex("#F43F5E"),
    Dialog = Color3.fromHex("#211619"),
    Outline = Color3.fromHex("#FB7185"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#180a0f"),
    Button = Color3.fromHex("#5f1e2d"),
    Icon = Color3.fromHex("#FDA4AF")
})

WindUI:AddTheme({
    Name = "Golden Hour",
    Accent = Color3.fromHex("#FBBF24"),
    Dialog = Color3.fromHex("#21200f"),
    Outline = Color3.fromHex("#FCD34D"),
    Text = Color3.fromHex("#000000"),
    Placeholder = Color3.fromHex("#5a5a5a"),
    Background = Color3.fromHex("#1a1808"),
    Button = Color3.fromHex("#6b5a1e"),
    Icon = Color3.fromHex("#FDE68A")
})

WindUI:AddTheme({
    Name = "Neon Green",
    Accent = Color3.fromHex("#22C55E"),
    Dialog = Color3.fromHex("#162116"),
    Outline = Color3.fromHex("#4ADE80"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1610"),
    Button = Color3.fromHex("#1e5f2d"),
    Icon = Color3.fromHex("#86EFAC")
})

WindUI:AddTheme({
    Name = "Electric Blue",
    Accent = Color3.fromHex("#3B82F6"),
    Dialog = Color3.fromHex("#161c28"),
    Outline = Color3.fromHex("#60A5FA"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1220"),
    Button = Color3.fromHex("#1e3d6b"),
    Icon = Color3.fromHex("#93C5FD")
})

WindUI:AddTheme({
    Name = "Custom",
    Accent = Color3.fromHex("#FF0F7B"),
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FF0F7B"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#FF0F7B")
})

-- Set default theme
WindUI:SetTheme("Dark")

-- ========================================
-- CREATING WINDOW
-- ========================================
local Window = WindUI:CreateWindow({
    Title = "Steal A Brainrot SHX | Official",
    Icon = "sword",
    Author = "by PickleTalk and Mhicel",
    Folder = "Scripts Hub X",
    Transparent = true,
    Theme = "Dark",
})

-- Window must always transparent!
Window:ToggleTransparency(true)

-- ========================================
-- CONFIG MANAGER
-- ========================================
local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("StealABrainrot")

-- ========================================
-- EDITING THE MINIMIZED BUTTON
-- ========================================
Window:EditOpenButton({
    Title = "Scripts Hub X | Official",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- ========================================
-- CREATING TABS
-- ========================================
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "home",
})

local ESPTab = Window:Tab({
    Title = "ESP",
    Icon = "eye",
})

local OptimizationsTab = Window:Tab({
    Title = "Optimizations",
    Icon = "zap",
})

local CreditsTab = Window:Tab({
    Title = "Credits",
    Icon = "heart",
})

local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "info",
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

-- ========================================
-- HELPER FUNCTIONS
-- ========================================
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")

    task.wait(0.5)
    if States.AntiRagdoll then
        setupAntiRagdollProtection()
    end
    
    originalGravity = nil
    bodyVelocity = nil
    elevationBodyVelocity = nil

    if States.Float then
        task.wait(1)
        
        if currentPlatform then
            currentPlatform:Destroy()
        end
        
        currentPlatform = createPlatform()
        applySlowFall()
        updatePlatformPosition()
        
        task.wait(0.5)
    end
end

-- ========================================
-- ANTI-RAGDOLL FUNCTIONS
-- ========================================
local function getAntiRagdollComponents()
    local success, result = pcall(function()
        if not LocalPlayer.Character then
            return false
        end
        
        local char = LocalPlayer.Character
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        
        return char and hum and root
    end)
    
    return success and result
end

local function preventRagdoll()
    if not (humanoid and humanoid.Parent) then
        return
    end
    
    pcall(function()
        humanoid.PlatformStand = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        
        if humanoid:GetState() == Enum.HumanoidStateType.Physics then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part ~= rootPart then
                for _, joint in pairs(part:GetChildren()) do
                    if joint:IsA("Motor6D") and joint.Part0 and joint.Part1 then
                        joint.Enabled = true
                        if not joint.Part0.Anchored and not joint.Part1.Anchored then
                            joint.C0 = joint.C0
                            joint.C1 = joint.C1
                        end
                    end
                end
            end
        end
    end)
end

local function preventFling()
    if not (rootPart and rootPart.Parent) then
        return
    end
    
    pcall(function()
        local velocity = rootPart.AssemblyLinearVelocity
        local angularVelocity = rootPart.AssemblyAngularVelocity
        
        if velocity.Magnitude > EXTREME_VELOCITY_THRESHOLD then
            rootPart.AssemblyLinearVelocity = velocity.Unit * MAX_VELOCITY
        end
        
        if angularVelocity.Magnitude > MAX_ANGULAR_VELOCITY * 2 then
            rootPart.AssemblyAngularVelocity = angularVelocity.Unit * MAX_ANGULAR_VELOCITY
        end
    end)
end

local function disableSentryBulletTouch(sentryBullet)
    pcall(function()
        if not sentryBullet or not sentryBullet.Parent then
            return
        end
        
        local touchInterest = sentryBullet:FindFirstChild("TouchInterest")
        if touchInterest then
            touchInterest:Destroy()
        end
        
        if sentryBullet:IsA("BasePart") then
            sentryBullet.CanTouch = false
        end
        
        sentryBullet.CanCollide = false
        
        pcall(function()
            sentryBullet.CollisionGroup = "SentryBulletDisabled"
        end)
    end)
end

local function monitorSentryBullets()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "SentryBullet" and obj:IsA("BasePart") then
            disableSentryBulletTouch(obj)
        end
    end
    
    local connection = workspace.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "SentryBullet" and descendant:IsA("BasePart") then
            task.wait()
            disableSentryBulletTouch(descendant)
        end
    end)
    
    table.insert(antiRagdollMonitoringConnections, connection)
end

function setupAntiRagdollProtection()
    if not getAntiRagdollComponents() then
        return false
    end
    
    for _, connection in pairs(antiRagdollConnections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    antiRagdollConnections = {}
    
    local stateConnection = humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Physics then
            preventRagdoll()
        end
    end)
    table.insert(antiRagdollConnections, stateConnection)
    
    local platformConnection = humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if humanoid.PlatformStand then
            preventRagdoll()
        end
    end)
    table.insert(antiRagdollConnections, platformConnection)
    
    local heartbeatRagdoll = RunService.Heartbeat:Connect(function()
        preventRagdoll()
        preventFling()
    end)
    table.insert(antiRagdollConnections, heartbeatRagdoll)
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local touchConnection = part.Touched:Connect(function(hit)
                if hit.Name == "SentryBullet" then
                    return
                end
            end)
            table.insert(antiRagdollConnections, touchConnection)
        end
    end
    
    return true
end

local function cleanupAntiRagdoll()
    for _, connection in pairs(antiRagdollConnections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    antiRagdollConnections = {}
    
    for _, connection in pairs(antiRagdollMonitoringConnections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    antiRagdollMonitoringConnections = {}
end

local function toggleAntiRagdoll(state)
    States.AntiRagdoll = state
    
    if state then
        if LocalPlayer.Character then
            task.wait(0.5)
            setupAntiRagdollProtection()
        end
        
        Connections.AntiRagdoll = player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if States.AntiRagdoll then
                setupAntiRagdollProtection()
            end
        end)
        
        monitorSentryBullets()
        
        WindUI:Notify({
            Title = "Anti-Ragdoll Enabled",
            Content = "You are now protected from ragdolling!",
            Duration = 3,
            Icon = "shield",
        })
    else
        if Connections.AntiRagdoll then
            Connections.AntiRagdoll:Disconnect()
            Connections.AntiRagdoll = nil
        end
        
        cleanupAntiRagdoll()
        
        WindUI:Notify({
            Title = "Anti-Ragdoll Disabled",
            Content = "Anti-ragdoll protection has been disabled!",
            Duration = 3,
            Icon = "shield-off",
        })
    end
end

-- ========================================
-- GRAPPLE HOOK FUNCTIONS
-- ========================================
local function equipGrappleHook()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if backpack and character then
        local grappleHook = backpack:FindFirstChild("Grapple Hook")
        if grappleHook and grappleHook:IsA("Tool") then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(grappleHook)
            end
        end
    end
end

local function unEquipGrappleHook()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if backpack and character then
        local grappleHook = backpack:FindFirstChild("Grapple Hook")
        if grappleHook and grappleHook:IsA("Tool") then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:UnequipTool(grappleHook)
            end
        end
    end
end

local function fireGrappleHook()
    local args = {0.08707536856333414}
    
    local success, error = pcall(function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem"):FireServer(unpack(args))
    end)
    
    if not success then
        warn("Failed to fire grapple hook: " .. tostring(error))
    end
end

local function equipAndFireGrapple()
    fireGrappleHook()
    equipGrappleHook()
end

-- ========================================
-- QUANTUM CLONER FUNCTIONS
-- ========================================
local function equipQuantumCloner()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if backpack and character then
        local quantumCloner = backpack:FindFirstChild("Quantum Cloner")
        if quantumCloner and quantumCloner:IsA("Tool") then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(quantumCloner)
                print("Equipped Quantum Cloner")
                return true
            end
        else
            warn("Quantum Cloner not found in backpack")
            return false
        end
    end
    return false
end

local function fireQuantumCloner()
    local success, error = pcall(function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem"):FireServer()
    end)
    
    if not success then
        warn("Failed to fire Quantum Cloner: " .. tostring(error))
    end
end

local function fireQuantumClonerTeleport()
    local success, error = pcall(function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/QuantumCloner/OnTeleport"):FireServer()
    end)
    
    if not success then
        warn("Failed to fire Quantum Cloner teleport: " .. tostring(error))
    end
end

-- ========================================
-- STEAL COUNT FUNCTIONS
-- ========================================
local function getStealCount()
    local success, result = pcall(function()
        if not LocalPlayer then
            return 0
        end
        
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if not leaderstats then
            warn("Leaderstats not found for LocalPlayer")
            return 0
        end
        
        local stealsObject = leaderstats:FindFirstChild("Steals")
        if not stealsObject then
            warn("Steals stat not found in leaderstats")
            return 0
        end
        
        local stealValue
        if stealsObject:IsA("IntValue") or stealsObject:IsA("NumberValue") then
            stealValue = stealsObject.Value
        elseif stealsObject:IsA("StringValue") then
            stealValue = tonumber(stealsObject.Value) or 0
        else
            if stealsObject.Text then
                stealValue = tonumber(stealsObject.Text) or 0
            else
                stealValue = tonumber(tostring(stealsObject.Value)) or 0
            end
        end
        
        return stealValue
    end)
    
    if success then
        return result
    else
        warn("Error getting steal count: " .. tostring(result))
        return 0
    end
end

local function kickPlayer()
    local success, error = pcall(function()
        LocalPlayer:Kick("Steal Success!!!!!")
    end)
    
    if not success then
        warn("Failed to kick player: " .. tostring(error))
        game:Shutdown()
    end
end

local function monitorSteals()
    if isMonitoring then
        return
    end
    
    isMonitoring = true
    
    lastStealCount = getStealCount()
    
    task.spawn(function()
        while isMonitoring do
            task.wait(0.1)
            
            local currentStealCount = getStealCount()
            
            if currentStealCount > lastStealCount then
                isMonitoring = false
                task.wait(0.1)
                kickPlayer()
                break
            end
            
            lastStealCount = currentStealCount
        end
    end)
end

local function stopMonitoring()
    isMonitoring = false
end

local function waitForLeaderstats()
    if not LocalPlayer then
        Players.PlayerAdded:Wait()
        LocalPlayer = Players.LocalPlayer
    end
    
    local leaderstats = LocalPlayer:WaitForChild("leaderstats", 30)
    if not leaderstats then
        warn("Leaderstats failed to load within 30 seconds")
        return false
    end
    
    local stealsObject = leaderstats:WaitForChild("Steals", 10)
    if not stealsObject then
        warn("Steals stat failed to load within 10 seconds")
        return false
    end
    
    return true
end

local function toggleMonitorSteals(state)
    States.MonitorSteals = state
    
    if state then
        if waitForLeaderstats() then
            monitorSteals()
            
            WindUI:Notify({
                Title = "Steal Monitoring Enabled",
                Content = "You will be kicked when your steal count increases!",
                Duration = 3,
                Icon = "eye",
            })
        else
            warn("Failed to initialize - leaderstats or Steals stat not found")
            WindUI:Notify({
                Title = "Error",
                Content = "Failed to initialize steal monitoring!",
                Duration = 3,
                Icon = "x",
            })
        end
    else
        stopMonitoring()
        
        WindUI:Notify({
            Title = "Steal Monitoring Disabled",
            Content = "Steal monitoring has been disabled!",
            Duration = 3,
            Icon = "eye-off",
        })
    end
end

-- ========================================
-- PLATFORM FUNCTIONS
-- ========================================
local function createPlatform()
    local platform = Instance.new("Part")
    platform.Name = "PlayerPlatform"
    platform.Size = Vector3.new(8, 0.5, 8)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.CanCollide = true
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    platform.Transparency = 1
    
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.fromRGB(0, 162, 255)
    pointLight.Brightness = 1
    pointLight.Range = 10
    pointLight.Parent = platform
    
    return platform
end

local function updatePlatformPosition()
    if not platformEnabled or not currentPlatform or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local playerPosition = humanoidRootPart.Position
        local platformPosition = Vector3.new(
            playerPosition.X, 
            playerPosition.Y - PLATFORM_OFFSET, 
            playerPosition.Z
        )
        currentPlatform.Position = platformPosition
    end
end

local function applySlowFall()
    if not player.Character then return end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    local lastTapTime = 0
    local DOUBLE_TAP_DELAY = 0.3
    
    local function performJump()
        if humanoid then
            equipAndFireGrapple()
            
            task.spawn(function()
                task.wait(0.1)
                if platformEnabled and humanoid then
                    humanoid.Jump = true
                    equipAndFireGrapple()
                    unEquipGrappleHook()
                end
            end)
        end
    end
    
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        
        if input.KeyCode == Enum.KeyCode.Space and platformEnabled then
            local currentTime = tick()
            
            if currentTime - lastTapTime <= DOUBLE_TAP_DELAY then
                performJump()
            end
            
            lastTapTime = currentTime
        end
    end)
end

local function removeSlowFall()
    if originalGravity and player.Character then
        local character = player.Character
        local humanoid = character:FindFirstChild("Humanoid")
        
        if humanoid then
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
            if elevationBodyVelocity then
                elevationBodyVelocity:Destroy()
                elevationBodyVelocity = nil
            end
        end
    end
    originalGravity = nil
end

local function enablePlatform()
    if platformEnabled then return end
    
    platformEnabled = true
    currentPlatform = createPlatform()
    
    applySlowFall()
    
    platformUpdateConnection = RunService.Heartbeat:Connect(updatePlatformPosition)
    updatePlatformPosition()

    if not grappleHookConnection then
        grappleHookConnection = task.spawn(function()
            while platformEnabled do
                task.wait(2)
                equipAndFireGrapple()
                task.wait(0.1)
                unEquipGrappleHook()
            end
        end)
    end
end

local function disablePlatform()
    if not platformEnabled then return end

    platformEnabled = false
    
    if platformUpdateConnection then
        platformUpdateConnection:Disconnect()
        platformUpdateConnection = nil
    end
    
    if currentPlatform then
        currentPlatform:Destroy()
        currentPlatform = nil
    end
    
    if grappleHookConnection then
        task.cancel(grappleHookConnection)
        grappleHookConnection = nil
        equipAndFireGrapple()
        task.wait(0.5)
        equipAndFireGrapple()
    end
end

local function toggleFloat(state)
    States.Float = state
    
    if state then
        enablePlatform()
        
        WindUI:Notify({
            Title = "Float Enabled",
            Content = "You are now floating! Double-tap space to jump higher.",
            Duration = 3,
            Icon = "arrow-up",
        })
    else
        disablePlatform()
        
        WindUI:Notify({
            Title = "Float Disabled",
            Content = "Float has been disabled!",
            Duration = 3,
            Icon = "arrow-down",
        })
    end
end

-- ========================================
-- WALL TRANSPARENCY FUNCTIONS
-- ========================================
local function createComboPlatform()
    local platform = Instance.new("Part")
    platform.Name = "ComboPlatform"
    platform.Size = Vector3.new(8, 1.5, 8)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.CanCollide = true
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    platform.Transparency = 1
    
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.fromRGB(0, 162, 255)
    pointLight.Brightness = 1
    pointLight.Range = 15
    pointLight.Parent = platform
    
    return platform
end

local function updateComboPlatformPosition()
    if not comboFloatEnabled or not comboCurrentPlatform or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local playerPosition = humanoidRootPart.Position
        local platformPosition = Vector3.new(
            playerPosition.X, 
            playerPosition.Y - COMBO_PLATFORM_OFFSET, 
            playerPosition.Z
        )
        comboCurrentPlatform.Position = platformPosition
    end
end

local function storeOriginalTransparencies()
    originalTransparencies = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent ~= player.Character and obj.Name ~= "PlayerPlatform" and obj.Name ~= "ComboPlayerPlatform" then
            local name = obj.Name
            if name == "structure base home" then
                originalTransparencies[obj] = {
                    transparency = obj.Transparency,
                    canCollide = obj.CanCollide
                }
            end
        end
    end
end

local function makeWallsTransparent(transparent)
    for obj, data in pairs(originalTransparencies) do
        if obj and obj.Parent and data then
            if transparent then
                obj.Transparency = TRANSPARENCY_LEVEL
                obj.CanCollide = false
            else
                obj.Transparency = data.transparency
                obj.CanCollide = data.canCollide
            end
        end
    end
end

local function forcePlayerHeadCollision()
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            head.CanCollide = true
        end
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CanCollide = true
        end
        local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
        if torso then
            torso.CanCollide = true
        end
    end
end

local function enableWallTransparency()
    if wallTransparencyEnabled then return end
    
    wallTransparencyEnabled = true
    comboFloatEnabled = true
    
    storeOriginalTransparencies()
    makeWallsTransparent(true)
    
    comboCurrentPlatform = createComboPlatform()
    comboPlatformUpdateConnection = RunService.Heartbeat:Connect(updateComboPlatformPosition)
    updateComboPlatformPosition()
    
    comboPlayerCollisionConnection = RunService.Heartbeat:Connect(function()
        forcePlayerHeadCollision()
    end)
    
    forcePlayerHeadCollision()

    if not grappleHookConnection then
        grappleHookConnection = task.spawn(function()
            while wallTransparencyEnabled do
                task.wait(1.5)
                equipAndFireGrapple()
                task.wait(0.1)
                unEquipGrappleHook()
            end
        end)
    end
end

local function disableWallTransparency()
    if not wallTransparencyEnabled then return end
    
    wallTransparencyEnabled = false
    comboFloatEnabled = false
    
    makeWallsTransparent(false)
    originalTransparencies = {}
    
    if comboPlatformUpdateConnection then
        comboPlatformUpdateConnection:Disconnect()
        comboPlatformUpdateConnection = nil
    end
    
    if comboCurrentPlatform then
        comboCurrentPlatform:Destroy()
        comboCurrentPlatform = nil
    end
    
    if comboPlayerCollisionConnection then
        comboPlayerCollisionConnection:Disconnect()
        comboPlayerCollisionConnection = nil
    end
    
    if grappleHookConnection then
        task.cancel(grappleHookConnection)
        grappleHookConnection = nil
    end
    
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            head.CanCollide = false
        end
    end
end

local function toggleFloorSteal(state)
    States.FloorSteal = state
    
    if state then
        enableWallTransparency()
        
        WindUI:Notify({
            Title = "Floor Steal Enabled",
            Content = "You can now steal through floors!",
            Duration = 3,
            Icon = "arrow-down-circle",
        })
    else
        disableWallTransparency()
        
        WindUI:Notify({
            Title = "Floor Steal Disabled",
            Content = "Floor steal has been disabled!",
            Duration = 3,
            Icon = "arrow-up-circle",
        })
    end
end

-- ========================================
-- TELEPORT FUNCTIONS
-- ========================================
local function parsePrice(priceText)
    if not priceText or priceText == "" or priceText == "N/A" then
        return 0
    end
    
    local cleanPrice = priceText:gsub("[,$]", ""):upper()
    
    local number = tonumber(cleanPrice:match("%d*%.?%d+"))
    if not number then return 0 end
    
    if cleanPrice:find("T") then
        return number * 1000000000000
    elseif cleanPrice:find("B") then
        return number * 1000000000
    elseif cleanPrice:find("M") then
        return number * 1000000
    elseif cleanPrice:find("K") then
        return number * 1000
    elseif cleanPrice:find("S") then
        return number
    end
    
    return number
end

local function findHighestBrainrot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then 
        warn("Plots folder not found in workspace")
        return nil 
    end
    
    local highestBrainrot = nil
    local highestValue = 0
    
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            local plotName = plot.Name
            
            local animalPodiums = plot:FindFirstChild("AnimalPodiums")
            if animalPodiums then
                for i = 1, 30 do
                    local podium = animalPodiums:FindFirstChild(tostring(i))
                    if podium then
                        local base = podium:FindFirstChild("Base")
                        if base then
                            local spawn = base:FindFirstChild("Spawn")
                            if spawn then
                                local attachment = spawn:FindFirstChild("Attachment")
                                if attachment then
                                    local animalOverhead = attachment:FindFirstChild("AnimalOverhead")
                                    if animalOverhead then
                                        local priceLabel = animalOverhead:FindFirstChild("Generation")
                                        if priceLabel and priceLabel.Text and priceLabel.Text ~= "" and priceLabel.Text ~= "N/A" then
                                            local priceValue = parsePrice(priceLabel.Text)
                                            
                                            if priceValue > highestValue then
                                                local decorations = base:FindFirstChild("Decorations")
                                                if decorations then
                                                    local teleportPart = decorations:FindFirstChild("Part")
                                                    if teleportPart then
                                                        highestValue = priceValue
                                                        highestBrainrot = {
                                                            plot = plot,
                                                            plotName = plotName,
                                                            podiumNumber = i,
                                                            price = priceLabel.Text,
                                                            priceValue = priceValue,
                                                            teleportPart = teleportPart,
                                                            position = teleportPart.Position,
                                                            rarity = animalOverhead:FindFirstChild("Rarity") and animalOverhead.Rarity.Text or "Unknown",
                                                            mutation = animalOverhead:FindFirstChild("Mutation") and animalOverhead.Mutation.Text or "None"
                                                        }
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    if highestBrainrot then
        return highestBrainrot
    else
        warn("No brainrots with valid prices found")
        return nil
    end
end

local function createHighestValueESP(brainrotData)
    if not brainrotData or not brainrotData.teleportPart then return end
    
    -- Clean up existing ESP
    if highestValueESP then
        if highestValueESP.highlight then highestValueESP.highlight:Destroy() end
        if highestValueESP.nameLabel then highestValueESP.nameLabel:Destroy() end
        if highestValueESP.tracer then 
            if highestValueESP.tracer.beam then highestValueESP.tracer.beam:Destroy() end
            if highestValueESP.tracer.attachment0 then highestValueESP.tracer.attachment0:Destroy() end
            if highestValueESP.tracer.attachment1 then highestValueESP.tracer.attachment1:Destroy() end
        end
        if highestValueESP.structureHighlight then highestValueESP.structureHighlight:Destroy() end
    end
    
    local espContainer = {}
    
    -- Create highlight
    local highlight = Instance.new("Highlight")
    highlight.Parent = brainrotData.teleportPart
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    espContainer.highlight = highlight
    
    -- Create billboard GUI
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Parent = brainrotData.teleportPart
    billboardGui.Size = UDim2.new(0, 180, 0, 80)
    billboardGui.StudsOffset = Vector3.new(0, 8, 0)
    billboardGui.AlwaysOnTop = true
    
    local containerFrame = Instance.new("Frame")
    containerFrame.Parent = billboardGui
    containerFrame.Size = UDim2.new(1, 0, 1, 0)
    containerFrame.BackgroundTransparency = 1
    
    local mutationLabel = Instance.new("TextLabel")
    mutationLabel.Parent = containerFrame
    mutationLabel.Size = UDim2.new(1, 0, 0.15, 0)
    mutationLabel.Position = UDim2.new(0, 0, 0, 0)
    mutationLabel.BackgroundTransparency = 1
    mutationLabel.Text = brainrotData.mutation or ""
    mutationLabel.TextColor3 = Color3.new(1, 1, 1)
    mutationLabel.TextStrokeTransparency = 0
    mutationLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    mutationLabel.TextScaled = true
    mutationLabel.TextSize = 8
    mutationLabel.Font = Enum.Font.SourceSans
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = containerFrame
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.Position = UDim2.new(0, 0, 0.15, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "HIGHEST VALUE BRAINROT"
    nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.TextScaled = true
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.SourceSansBold
    
    local moneyLabel = Instance.new("TextLabel")
    moneyLabel.Parent = containerFrame
    moneyLabel.Size = UDim2.new(1, 0, 0.25, 0)
    moneyLabel.Position = UDim2.new(0, 0, 0.55, 0)
    moneyLabel.BackgroundTransparency = 1
    moneyLabel.Text = brainrotData.price or ""
    moneyLabel.TextColor3 = Color3.new(0, 1, 0)
    moneyLabel.TextStrokeTransparency = 0
    moneyLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    moneyLabel.TextScaled = true
    moneyLabel.TextSize = 10
    moneyLabel.Font = Enum.Font.SourceSans
    
    local rarityLabel = Instance.new("TextLabel")
    rarityLabel.Parent = containerFrame
    rarityLabel.Size = UDim2.new(1, 0, 0.2, 0)
    rarityLabel.Position = UDim2.new(0, 0, 0.8, 0)
    rarityLabel.BackgroundTransparency = 1
    rarityLabel.Text = brainrotData.rarity or ""
    rarityLabel.TextScaled = true
    rarityLabel.TextSize = 8
    rarityLabel.Font = Enum.Font.SourceSans
    
    if brainrotData.rarity == "Secret" then
        rarityLabel.TextColor3 = Color3.new(0, 0, 0)
        rarityLabel.TextStrokeTransparency = 0
        rarityLabel.TextStrokeColor3 = Color3.new(1, 1, 1)
    elseif brainrotData.rarity == "Brainrot God" then
        task.spawn(function()
            local hue = 0
            while rarityLabel and rarityLabel.Parent do
                hue = (hue + 0.01) % 1
                rarityLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
                task.wait(0.1)
            end
        end)
        rarityLabel.TextStrokeTransparency = 0
        rarityLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    else
        rarityLabel.TextColor3 = Color3.new(1, 1, 1)
        rarityLabel.TextStrokeTransparency = 0
        rarityLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    end
    
    espContainer.nameLabel = billboardGui
    
    -- Create tracer beam
    local camera = workspace.CurrentCamera
    if camera then
        local attachment0 = Instance.new("Attachment")
        attachment0.Name = "TracerCameraAttachment"
        attachment0.Parent = camera
        attachment0.Position = Vector3.new(0, 0, 0)
        
        local attachment1 = Instance.new("Attachment")
        attachment1.Name = "TracerTargetAttachment"
        attachment1.Parent = brainrotData.teleportPart
        attachment1.Position = Vector3.new(0, 0, 0)
        
        local beam = Instance.new("Beam")
        beam.Name = "HighestBrainrotTracer"
        beam.Parent = workspace.Terrain
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.Width0 = 0.3
        beam.Width1 = 0.3
        beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
        beam.Transparency = NumberSequence.new(0.2)
        beam.FaceCamera = true
        beam.LightEmission = 1
        beam.LightInfluence = 0
        beam.Texture = "rbxasset://textures/ui/VR/LaserBeam.png"
        beam.TextureMode = Enum.TextureMode.Static
        beam.TextureLength = 1
        beam.ZOffset = 0
        
        espContainer.tracer = {
            beam = beam, 
            attachment0 = attachment0, 
            attachment1 = attachment1
        }
    end
    
    -- Highlight structure base
    local structureBaseHome = brainrotData.plot:FindFirstChild("structure base home")
    if structureBaseHome then
        local structureHighlight = Instance.new("Highlight")
        structureHighlight.Parent = structureBaseHome
        structureHighlight.FillColor = Color3.fromRGB(255, 215, 0)
        structureHighlight.OutlineColor = Color3.fromRGB(255, 255, 0)
        structureHighlight.FillTransparency = 0.8
        structureHighlight.OutlineTransparency = 0.2
        structureHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        espContainer.structureHighlight = structureHighlight
    end
    
    highestValueESP = espContainer
    highestValueData = brainrotData
end

local function updateHighestValueESP()
    local newHighestBrainrot = findHighestBrainrot()
    
    if newHighestBrainrot and (not highestValueData or 
        newHighestBrainrot.priceValue > highestValueData.priceValue or
        newHighestBrainrot.plotName ~= highestValueData.plotName or
        newHighestBrainrot.podiumNumber ~= highestValueData.podiumNumber) then
        
        createHighestValueESP(newHighestBrainrot)
    end
end

local function removeHighestValueESP()
    if highestValueESP then
        if highestValueESP.highlight then highestValueESP.highlight:Destroy() end
        if highestValueESP.nameLabel then highestValueESP.nameLabel:Destroy() end
        if highestValueESP.tracer then 
            if highestValueESP.tracer.beam then highestValueESP.tracer.beam:Destroy() end
            if highestValueESP.tracer.attachment0 then highestValueESP.tracer.attachment0:Destroy() end
            if highestValueESP.tracer.attachment1 then highestValueESP.tracer.attachment1:Destroy() end
        end
        if highestValueESP.structureHighlight then highestValueESP.structureHighlight:Destroy() end
        highestValueESP = nil
        highestValueData = nil
    end
end

local function createTeleportOverlay()
    if teleportOverlay then
        teleportOverlay:Destroy()
    end
    
    teleportOverlay = Instance.new("ScreenGui")
    teleportOverlay.Name = "TeleportOverlay"
    teleportOverlay.Parent = playerGui
    teleportOverlay.ResetOnSpawn = false
    
    local overlayFrame = Instance.new("Frame")
    overlayFrame.Size = UDim2.new(1, 0, 1, 0)
    overlayFrame.Position = UDim2.new(0, 0, 0, 0)
    overlayFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlayFrame.BackgroundTransparency = 0.5
    overlayFrame.BorderSizePixel = 0
    overlayFrame.Parent = teleportOverlay
    
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 400, 0, 200)
    loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Parent = overlayFrame
    
    local loadingCorner = Instance.new("UICorner")
    loadingCorner.CornerRadius = UDim.new(0, 12)
    loadingCorner.Parent = loadingFrame
    
    local loadingTitle = Instance.new("TextLabel")
    loadingTitle.Size = UDim2.new(1, -20, 0, 50)
    loadingTitle.Position = UDim2.new(0, 10, 0, 10)
    loadingTitle.BackgroundTransparency = 1
    loadingTitle.Text = "TELEPORTING TO HIGHEST BRAINROT!"
    loadingTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    loadingTitle.TextScaled = true
    loadingTitle.Font = Enum.Font.GothamBold
    loadingTitle.Parent = loadingFrame
    
    local loadingStatus = Instance.new("TextLabel")
    loadingStatus.Size = UDim2.new(1, -20, 0, 30)
    loadingStatus.Position = UDim2.new(0, 10, 0, 70)
    loadingStatus.BackgroundTransparency = 1
    loadingStatus.Text = "Scanning for highest value brainrot..."
    loadingStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingStatus.TextScaled = true
    loadingStatus.Font = Enum.Font.Gotham
    loadingStatus.Parent = loadingFrame
    
    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0.8, 0, 0, 8)
    loadingBar.Position = UDim2.new(0.1, 0, 0, 120)
    loadingBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    loadingBar.BorderSizePixel = 0
    loadingBar.Parent = loadingFrame
    
    local loadingBarCorner = Instance.new("UICorner")
    loadingBarCorner.CornerRadius = UDim.new(0, 4)
    loadingBarCorner.Parent = loadingBar
    
    local loadingProgress = Instance.new("Frame")
    loadingProgress.Size = UDim2.new(0, 0, 1, 0)
    loadingProgress.Position = UDim2.new(0, 0, 0, 0)
    loadingProgress.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    loadingProgress.BorderSizePixel = 0
    loadingProgress.Parent = loadingBar
    
    local loadingProgressCorner = Instance.new("UICorner")
    loadingProgressCorner.CornerRadius = UDim.new(0, 4)
    loadingProgressCorner.Parent = loadingProgress
    
    local brainrotInfo = Instance.new("TextLabel")
    brainrotInfo.Size = UDim2.new(1, -20, 0, 40)
    brainrotInfo.Position = UDim2.new(0, 10, 0, 140)
    brainrotInfo.BackgroundTransparency = 1
    brainrotInfo.Text = ""
    brainrotInfo.TextColor3 = Color3.fromRGB(0, 255, 0)
    brainrotInfo.TextScaled = true
    brainrotInfo.Font = Enum.Font.GothamBold
    brainrotInfo.Parent = loadingFrame
    
    return {
        overlay = teleportOverlay,
        statusLabel = loadingStatus,
        progressBar = loadingProgress,
        brainrotInfo = brainrotInfo
    }
end

local function removeTeleportOverlay()
    if teleportOverlay then
        teleportOverlay:Destroy()
        teleportOverlay = nil
    end
end

local function executeTeleportToHighestBrainrot()
    local currentTime = tick()
    
    if currentTime - lastClickTime < DOUBLE_CLICK_PREVENTION_TIME then
        return
    end
    
    lastClickTime = currentTime
    
    if teleportEnabled then
        teleportEnabled = false
        removeTeleportOverlay()
        return
    end
    
    teleportEnabled = true
    
    local overlay = createTeleportOverlay()
    
    task.spawn(function()
        overlay.statusLabel.Text = "Scanning for highest value brainrot..."
        TweenService:Create(overlay.progressBar, TweenInfo.new(0.5), {Size = UDim2.new(0.2, 0, 1, 0)}):Play()
        
        if not teleportEnabled then
            removeTeleportOverlay()
            return
        end
        
        highestBrainrotData = findHighestBrainrot()
        
        if not highestBrainrotData then
            overlay.statusLabel.Text = "No brainrots found!"
            task.wait(2)
            teleportEnabled = false
            removeTeleportOverlay()
            return
        end
        
        overlay.statusLabel.Text = "Found highest brainrot!"
        overlay.brainrotInfo.Text = "Plot: " .. highestBrainrotData.plotName .. " | Slot: " .. highestBrainrotData.podiumNumber .. "\nPrice: " .. highestBrainrotData.price .. " | Rarity: " .. highestBrainrotData.rarity
        TweenService:Create(overlay.progressBar, TweenInfo.new(0.5), {Size = UDim2.new(0.4, 0, 1, 0)}):Play()
        task.wait(0.5)
            
        if not teleportEnabled then
            removeTeleportOverlay()
            return
        end

        TweenService:Create(overlay.progressBar, TweenInfo.new(0.5), {Size = UDim2.new(0.6, 0, 1, 0)}):Play()
        
        local equipped = equipQuantumCloner()
        if not equipped then
            overlay.statusLabel.Text = "Quantum Cloner not found!"
            task.wait(2)
            teleportEnabled = false
            removeTeleportOverlay()
            return
        end
        
        if not teleportEnabled then
            removeTeleportOverlay()
            return
        end

        overlay.statusLabel.Text = "Teleporting to highest brainrot..."
        TweenService:Create(overlay.progressBar, TweenInfo.new(0.5), {Size = UDim2.new(0.9, 0, 1, 0)}):Play()
        
        if highestBrainrotData.teleportPart then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = highestBrainrotData.teleportPart.Position + Vector3.new(0, 5, 0)

                fireQuantumCloner()

                task.wait(0.05)
                    
                if not teleportEnabled then
                    removeTeleportOverlay()
                    return
                end
        
                -- SPAM TELEPORT SUPER FAST FOR 1 SECOND
                local startTime = tick()
                while tick() - startTime < 0.9 do
                    character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                    RunService.Heartbeat:Wait() -- Fastest possible wait
                end
        
                if not teleportEnabled then
                    removeTeleportOverlay()
                    return
                end

                task.wait(1)
                fireQuantumClonerTeleport()
            end
        else
            overlay.statusLabel.Text = "Teleport position not found!"
            task.wait(2)
        end
        
        overlay.statusLabel.Text = "Teleport completed!"
        TweenService:Create(overlay.progressBar, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(1)
        
        teleportEnabled = false
        removeTeleportOverlay()
    end)
end

-- ========================================
-- ESP FUNCTIONS
-- ========================================
local function createPermanentPlayerESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = player.Character.HumanoidRootPart
    
    local existingHighlight = humanoidRootPart:FindFirstChild("PermanentHighlight")
    if existingHighlight then
        existingHighlight:Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "PermanentHighlight"
    highlight.Parent = humanoidRootPart
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

local function initializePermanentESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createPermanentPlayerESP(player)
        end
    end
end

function createPlayerESP(player, head)
    local existingGui = head:FindFirstChild("PlayerESP")
    if existingGui then
        existingGui:Destroy()
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "PlayerESP"
    billboardGui.Parent = head
    billboardGui.Size = UDim2.new(0, 90, 0, 33)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboardGui
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.DisplayName
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSans
end

local function createPlayerDisplay(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then
        player.CharacterAdded:Connect(function(char)
            character = char
            task.wait(0.5)
            local head = character:FindFirstChild("Head")
            if head then
                createPlayerESP(player, head)
            end
        end)
        return
    end
    
    local head = character:FindFirstChild("Head")
    if head then
        createPlayerESP(player, head)
    else
        character.ChildAdded:Connect(function(child)
            if child.Name == "Head" then
                createPlayerESP(player, child)
            end
        end)
    end
end

local function createOrUpdatePlotDisplay(plot)
    if not plot or not plot.Parent then return end
    
    local plotName = plot.Name
    
    local plotSignText = ""
    local signPath = plot:FindFirstChild("PlotSign")
    if signPath and signPath:FindFirstChild("SurfaceGui") then
        local surfaceGui = signPath.SurfaceGui
        if surfaceGui:FindFirstChild("Frame") and surfaceGui.Frame:FindFirstChild("TextLabel") then
            plotSignText = surfaceGui.Frame.TextLabel.Text
        end
    end
    
    if plotSignText == "Empty Base" or plotSignText == "" or plotSignText == "Empty's Base" then
        if plotDisplays[plotName] and plotDisplays[plotName].gui then
            plotDisplays[plotName].gui:Destroy()
            plotDisplays[plotName] = nil
        end
        return
    end
    
    local plotTimeText = ""
    local purchasesPath = plot:FindFirstChild("Purchases")
    if purchasesPath and purchasesPath:FindFirstChild("PlotBlock") then
        local plotBlock = purchasesPath.PlotBlock
        if plotBlock:FindFirstChild("Main") and plotBlock.Main:FindFirstChild("BillboardGui") then
            local billboardGui = plotBlock.Main.BillboardGui
            if billboardGui:FindFirstChild("RemainingTime") then
                plotTimeText = billboardGui.RemainingTime.Text
            end
        end
    end
    
    if plotSignText == playerBaseName then
        local remainingSeconds = parseTimeToSeconds(plotTimeText)
        
        if remainingSeconds and remainingSeconds <= 10 and remainingSeconds > 0 then
            if not playerBaseTimeWarning then
                createAlertGui()
                playerBaseTimeWarning = true
            end
            updateAlertGui(plotTimeText)
        elseif remainingSeconds and remainingSeconds > 10 then
            if playerBaseTimeWarning then
                removeAlertGui()
            end
        elseif not remainingSeconds or remainingSeconds <= 0 then
            if playerBaseTimeWarning then
                removeAlertGui()
            end
        end
    end
    
    local displayPart = plot:FindFirstChild("PlotSign")
    if not displayPart then
        for _, child in pairs(plot:GetChildren()) do
            if child:IsA("Part") or child:IsA("MeshPart") then
                displayPart = child
                break
            end
        end
    end
    
    if not displayPart then return end
    
    if not plotDisplays[plotName] then
        local existingBillboard = displayPart:FindFirstChild("PlotESP")
        if existingBillboard then
            existingBillboard:Destroy()
        end
        
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "PlotESP"
        billboardGui.Parent = displayPart
        billboardGui.Size = UDim2.new(0, 150, 0, 60)
        billboardGui.StudsOffset = Vector3.new(0, 8, 0)
        billboardGui.AlwaysOnTop = true
        
        local frame = Instance.new("Frame")
        frame.Parent = billboardGui
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.7
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.Parent = frame
        corner.CornerRadius = UDim.new(0, 4)
        
        local signLabel = Instance.new("TextLabel")
        signLabel.Parent = frame
        signLabel.Size = UDim2.new(1, -4, 0.6, 0)
        signLabel.Position = UDim2.new(0, 2, 0, 2)
        signLabel.BackgroundTransparency = 1
        signLabel.Text = plotSignText
        signLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        signLabel.TextScaled = true
        signLabel.TextStrokeTransparency = 0.3
        signLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        signLabel.Font = Enum.Font.SourceSansBold
        
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Parent = frame
        timeLabel.Size = UDim2.new(1, -4, 0.4, 0)
        timeLabel.Position = UDim2.new(0, 2, 0.6, 0)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = plotTimeText
        timeLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        timeLabel.TextScaled = true
        timeLabel.TextStrokeTransparency = 0.3
        timeLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        timeLabel.Font = Enum.Font.SourceSans
        
        plotDisplays[plotName] = {
            gui = billboardGui,
            signLabel = signLabel,
            timeLabel = timeLabel,
            plot = plot
        }
    else
        if plotDisplays[plotName].signLabel then
            plotDisplays[plotName].signLabel.Text = plotSignText
        end
        if plotDisplays[plotName].timeLabel then
            plotDisplays[plotName].timeLabel.Text = plotTimeText
        end
    end
end

local function updateAllPlots()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            pcall(function()
                createOrUpdatePlotDisplay(plot)
            end)
        end
    end
    
    for plotName, display in pairs(plotDisplays) do
        if not plots:FindFirstChild(plotName) then
            if display.gui then
                display.gui:Destroy()
            end
            plotDisplays[plotName] = nil
        end
    end
end

local function parseTimeToSeconds(timeText)
    if not timeText or timeText == "" then return nil end
    
    local minutes, seconds = timeText:match("(%d+):(%d+)")
    if minutes and seconds then
        return tonumber(minutes) * 60 + tonumber(seconds)
    end
    
    local secondsOnly = timeText:match("(%d+)s")
    if secondsOnly then
        return tonumber(secondsOnly)
    end
    
    local minutesOnly = timeText:match("(%d+)m")
    if minutesOnly then
        return tonumber(minutesOnly) * 60
    end
    
    return nil
end

local function createAlertGui()
    if alertGui then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "AlertGui"
    screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(0.5, -150, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 8)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = frame
    textLabel.Size = UDim2.new(1, -10, 1, -10)
    textLabel.Position = UDim2.new(0, 5, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "BASE TIME WARNING"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    
    local tween = TweenService:Create(
        frame,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundColor3 = Color3.fromRGB(150, 0, 0)}
    )
    tween:Play()
    
    alertGui = {
        screenGui = screenGui,
        textLabel = textLabel,
        tween = tween
    }
end

local function updateAlertGui(timeText)
    if not alertGui then return end
    alertGui.textLabel.Text = "BASE UNLOCKING IN " .. timeText
end

local function removeAlertGui()
    if alertGui then
        if alertGui.tween then
            alertGui.tween:Cancel()
        end
        alertGui.screenGui:Destroy()
        alertGui = nil
        playerBaseTimeWarning = false
    end
end

local function toggleESP(state)
    States.ESP = state
    
    if state then
        -- Initialize ESP for all players
        for _, playerObj in pairs(Players:GetPlayers()) do
            if playerObj ~= LocalPlayer then
                createPlayerDisplay(playerObj)
                playerObj.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    createPlayerDisplay(playerObj)
                end)
            end
        end
        
        initializePermanentESP()
        
        Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function(character)
                task.wait(1)
                createPermanentPlayerESP(newPlayer)
            end)
        end)
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                player.CharacterAdded:Connect(function(character)
                    task.wait(1)
                    createPermanentPlayerESP(player)
                end)
            end
        end
        
        Players.PlayerRemoving:Connect(function(leavingPlayer)
            if leavingPlayer.Character then
                local head = leavingPlayer.Character:FindFirstChild("Head")
                local hrp = leavingPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if head then
                    local permanentESP = head:FindFirstChild("PermanentESP")
                    if permanentESP then permanentESP:Destroy() end
                end
                
                if hrp then
                    local permanentHighlight = hrp:FindFirstChild("PermanentHighlight")
                    if permanentHighlight then permanentHighlight:Destroy() end
                end
            end
        end)
        
        Players.PlayerAdded:Connect(function(playerObj)
            if playerObj ~= LocalPlayer then
                createPlayerDisplay(playerObj)
                playerObj.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    createPlayerDisplay(playerObj)
                end)
            end
        end)
        
        updateAllPlots()
        
        local plots = workspace:FindFirstChild("Plots")
        if plots then
            plots.ChildAdded:Connect(function(child)
                if child:IsA("Model") or child:IsA("Folder") then
                    task.wait(0.5)
                    createOrUpdatePlotDisplay(child)
                end
            end)
        end
        
        task.spawn(function()
            while true do
                task.wait(0.5)
                pcall(updateAllPlots)
            end
        end)
        
        task.spawn(function()
            task.wait(1)
            updateHighestValueESP()
            
            espUpdateConnection = task.spawn(function()
                while true do
                    task.wait(20)
                    updateHighestValueESP()
                end
            end)
        end)
        
        WindUI:Notify({
            Title = "ESP Enabled",
            Content = "ESP features have been enabled!",
            Duration = 3,
            Icon = "eye",
        })
    else
        -- Clean up ESP
        for _, playerObj in pairs(Players:GetPlayers()) do
            if playerObj.Character then
                local head = playerObj.Character:FindFirstChild("Head")
                if head then
                    local playerESP = head:FindFirstChild("PlayerESP")
                    if playerESP then playerESP:Destroy() end
                end
                
                local humanoidRootPart = playerObj.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local permanentHighlight = humanoidRootPart:FindFirstChild("PermanentHighlight")
                    if permanentHighlight then permanentHighlight:Destroy() end
                end
            end
        end
        
        removeHighestValueESP()
        
        for plotName, display in pairs(plotDisplays) do
            if display.gui then
                display.gui:Destroy()
            end
        end
        plotDisplays = {}
        
        if espUpdateConnection then
            task.cancel(espUpdateConnection)
            espUpdateConnection = nil
        end
        
        WindUI:Notify({
            Title = "ESP Disabled",
            Content = "ESP features have been disabled!",
            Duration = 3,
            Icon = "eye-off",
        })
    end
end

-- ========================================
-- OPTIMIZATION FUNCTIONS
-- ========================================
local function toggleFullBright(state)
    States.FullBright = state
    
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        
        WindUI:Notify({
            Title = "Full Bright Enabled",
            Content = "Everything is now bright!",
            Duration = 3,
            Icon = "sun",
        })
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        
        WindUI:Notify({
            Title = "Full Bright Disabled",
            Content = "Lighting has been reset to default!",
            Duration = 3,
            Icon = "moon",
        })
    end
end

local function saveOriginalGFX()
    if next(LowGFXStorage.SavedLighting) == nil then
        LowGFXStorage.SavedLighting = {
            GlobalShadows = Lighting.GlobalShadows,
            ShadowSoftness = Lighting.ShadowSoftness,
        }
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        local objId = tostring(obj:GetDebugId())
        
        if not LowGFXStorage.SavedProperties[objId] then
            if obj:IsA("BasePart") then
                LowGFXStorage.SavedProperties[objId] = {
                    Object = obj,
                    Material = obj.Material,
                    CastShadow = obj.CastShadow,
                    Reflectance = obj.Reflectance,
                }
            elseif obj:IsA("MeshPart") then
                LowGFXStorage.SavedProperties[objId] = {
                    Object = obj,
                    Material = obj.Material,
                    TextureID = obj.TextureID,
                    CastShadow = obj.CastShadow,
                }
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                LowGFXStorage.SavedProperties[objId] = {
                    Object = obj,
                    Enabled = obj.Enabled,
                }
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                LowGFXStorage.SavedProperties[objId] = {
                    Object = obj,
                    Transparency = obj.Transparency,
                }
            end
        end
    end
end

local function applyLowGFX()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
            obj.Reflectance = 0
        elseif obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.TextureID = ""
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end
    
    Lighting.GlobalShadows = false
    Lighting.ShadowSoftness = 0
end

local function restoreOriginalGFX()
    for objId, data in pairs(LowGFXStorage.SavedProperties) do
        local obj = data.Object
        
        if obj and obj.Parent then
            pcall(function()
                if obj:IsA("BasePart") then
                    obj.Material = data.Material
                    obj.CastShadow = data.CastShadow
                    obj.Reflectance = data.Reflectance
                elseif obj:IsA("MeshPart") then
                    obj.Material = data.Material
                    obj.TextureID = data.TextureID
                    obj.CastShadow = data.CastShadow
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                    obj.Enabled = data.Enabled
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = data.Transparency
                end
            end)
        end
    end
    
    if LowGFXStorage.SavedLighting.GlobalShadows ~= nil then
        Lighting.GlobalShadows = LowGFXStorage.SavedLighting.GlobalShadows
        Lighting.ShadowSoftness = LowGFXStorage.SavedLighting.ShadowSoftness
    end
    
    LowGFXStorage.SavedProperties = {}
    LowGFXStorage.SavedLighting = {}
end

local function toggleLowGFX(state)
    States.LowGFX = state
    
    if state then
        saveOriginalGFX()
        applyLowGFX()
        
        Connections.LowGFX = Workspace.DescendantAdded:Connect(function(obj)
            if States.LowGFX then
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.CastShadow = false
                    obj.Reflectance = 0
                elseif obj:IsA("MeshPart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.TextureID = ""
                end
            end
        end)
        
        WindUI:Notify({
            Title = "Low GFX Enabled",
            Content = "Graphics optimized! Original settings saved.",
            Duration = 3,
            Icon = "zap",
        })
    else
        if Connections.LowGFX then
            Connections.LowGFX:Disconnect()
            Connections.LowGFX = nil
        end
        
        restoreOriginalGFX()
        
        WindUI:Notify({
            Title = "Low GFX Disabled",
            Content = "Original graphics restored!",
            Duration = 3,
            Icon = "check",
        })
    end
end

local function clearFogs()
    for _, obj in pairs(Lighting:GetDescendants()) do
        if obj:IsA("Atmosphere") then
            obj:Destroy()
        end
    end
    
    Lighting.FogEnd = math.huge
    
    WindUI:Notify({
        Title = "Fogs Cleared",
        Content = "All fog effects have been removed!",
        Duration = 3,
        Icon = "check",
    })
end

local function removeShadows()
    Lighting.GlobalShadows = false
    Lighting.ShadowSoftness = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CastShadow = false
        end
    end
    
    WindUI:Notify({
        Title = "Shadows Removed",
        Content = "All shadows have been disabled!",
        Duration = 3,
        Icon = "check",
    })
end

-- ========================================
-- SERVER HOP FUNCTIONS
-- ========================================
local function getServers(cursor)
    local url = string.format(
        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
        game.PlaceId
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
            task.wait(0.3)
        else
            break
        end
        
    until not cursor or attempts >= 10
    
    return allServers
end

local function hopToSmallestServer()
    WindUI:Notify({
        Title = "Server Hop",
        Content = "Finding smallest server...",
        Duration = 3,
        Icon = "search",
    })
    
    task.spawn(function()
        local servers = getAllServers()
        
        if #servers == 0 then
            WindUI:Notify({
                Title = "Server Hop",
                Content = "No servers found!",
                Duration = 3,
                Icon = "x",
            })
            return
        end
        
        table.sort(servers, function(a, b)
            return a.playing < b.playing
        end)
        
        local targetServer = servers[1]
        
        WindUI:Notify({
            Title = "Server Hop",
            Content = string.format("Hopping to server with %d/%d players...", targetServer.playing, targetServer.maxPlayers),
            Duration = 3,
            Icon = "zap",
        })
        
        task.wait(1)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, LocalPlayer)
    end)
end

local function hopToRandomServer()
    WindUI:Notify({
        Title = "Server Hop",
        Content = "Finding random server...",
        Duration = 3,
        Icon = "search",
    })
    
    task.spawn(function()
        local servers = getAllServers()
        
        if #servers == 0 then
            WindUI:Notify({
                Title = "Server Hop",
                Content = "No servers found!",
                Duration = 3,
                Icon = "x",
            })
            return
        end
        
        local targetServer = servers[math.random(1, #servers)]
        
        WindUI:Notify({
            Title = "Server Hop",
            Content = string.format("Hopping to server with %d/%d players...", targetServer.playing, targetServer.maxPlayers),
            Duration = 3,
            Icon = "zap",
        })
        
        task.wait(1)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, LocalPlayer)
    end)
end

-- ========================================
-- CONFIGURATION FUNCTIONS
-- ========================================
local function saveConfiguration()
    myConfig:Save()
    
    WindUI:Notify({
        Title = "Configuration Saved",
        Content = "Your settings have been saved successfully!",
        Duration = 3,
        Icon = "save",
    })
end

local function loadConfiguration()
    myConfig:Load()
    
    WindUI:Notify({
        Title = "Configuration Loaded",
        Content = "Your settings have been loaded successfully!",
        Duration = 3,
        Icon = "upload",
    })
end

local function changeTheme(themeName)
    WindUI:SetTheme(themeName)
    States.CurrentTheme = themeName
    
    WindUI:Notify({
        Title = "Theme Changed",
        Content = "UI theme has been changed to " .. themeName,
        Duration = 3,
        Icon = "palette",
    })
end

-- ========================================
-- MAIN TAB ELEMENTS
-- ========================================
local AntiRagdollToggle = MainTab:Toggle({
    Title = "Anti-Ragdoll",
    Desc = "Protect yourself from ragdolling!",
    Default = false,
    Callback = function(state)
        toggleAntiRagdoll(state)
    end
})

local FloatToggle = MainTab:Toggle({
    Title = "Float",
    Desc = "Float in the air! Double-tap space to jump higher.",
    Default = false,
    Callback = function(state)
        toggleFloat(state)
    end
})

local FloorStealToggle = MainTab:Toggle({
    Title = "Floor Steal",
    Desc = "Steal through floors and walls!",
    Default = false,
    Callback = function(state)
        toggleFloorSteal(state)
    end
})

local MonitorStealsToggle = MainTab:Toggle({
    Title = "Monitor Steals",
    Desc = "Monitor your steal count and kick when it increases!",
    Default = false,
    Callback = function(state)
        toggleMonitorSteals(state)
    end
})

local TeleportButton = MainTab:Button({
    Title = "Teleport to Highest Brainrot",
    Desc = "Teleport to the highest value brainrot in the game",
    Callback = function()
        executeTeleportToHighestBrainrot()
    end
})

-- ========================================
-- ESP TAB ELEMENTS
-- ========================================
local ESPToggle = ESPTab:Toggle({
    Title = "Enable ESP",
    Desc = "Enable ESP features for players and brainrots",
    Default = false,
    Callback = function(state)
        toggleESP(state)
    end
})

-- ========================================
-- OPTIMIZATIONS TAB ELEMENTS
-- ========================================
local FullBrightToggle = OptimizationsTab:Toggle({
    Title = "Full Bright",
    Desc = "Make everything bright, no more darkness!",
    Default = false,
    Callback = function(state)
        toggleFullBright(state)
    end
})

local LowGFXToggle = OptimizationsTab:Toggle({
    Title = "Low GFX Mode",
    Desc = "Make your GFX low for more fps!",
    Default = false,
    Callback = function(state)
        toggleLowGFX(state)
    end
})

local ClearFogsButton = OptimizationsTab:Button({
    Title = "Clear Fogs",
    Desc = "Remove all fog effects from the game",
    Callback = function()
        clearFogs()
    end
})

local RemoveShadowsButton = OptimizationsTab:Button({
    Title = "Remove Shadows",
    Desc = "Disable all shadows for better performance",
    Callback = function()
        removeShadows()
    end
})

-- ========================================
-- CREDITS TAB ELEMENTS
-- ========================================
local CreditsParagraph = CreditsTab:Paragraph({
    Title = "Scripts Hub X | Official",
    Desc = "Made by PickleTalk and Mhicel. Join our discord server to be always updated with the latest features and scripts!",
    Color = "Red",
    Thumbnail = "rbxassetid://74135635728836",
    ThumbnailSize = 140,
    Buttons = {
        {
            Icon = "users",
            Title = "Discord",
            Callback = function()
                setclipboard("https://discord.gg/bpsNUH5sVb")
                WindUI:Notify({
                    Title = "Discord Link Copied!",
                    Content = "Discord invite link copied to clipboard!",
                    Duration = 3,
                    Icon = "check",
                })
            end,
        }
    }
})

-- ========================================
-- MISC TAB ELEMENTS
-- ========================================
local currentPlayers = #Players:GetPlayers()
local maxPlayers = Players.MaxPlayers or 0

local ServerInfoParagraph = MiscTab:Paragraph({
    Title = "Server Information",
    Desc = string.format(
        "Game: Steal A Brainrot\nPlace ID: %d\nJob ID: %s\nPlayers: %d/%d",
        game.PlaceId or 0,
        tostring(game.JobId or "N/A"),
        currentPlayers,
        maxPlayers
    ),
})

-- Update player count every 5 seconds
task.spawn(function()
    while true do
        task.wait(5)
        local currentPlayers = #Players:GetPlayers()
        local maxPlayers = Players.MaxPlayers or 0
        
        pcall(function()
            ServerInfoParagraph:Set({
                Desc = string.format(
                    "Game: Steal A Brainrot\nPlace ID: %d\nJob ID: %s\nPlayers: %d/%d",
                    game.PlaceId or 0,
                    tostring(game.JobId or "N/A"),
                    currentPlayers,
                    maxPlayers
                )
            })
        end)
    end
end)

local SmallServerHopButton = MiscTab:Button({
    Title = "Hop Small Server",
    Desc = "Teleport to the smallest available server",
    Callback = function()
        hopToSmallestServer()
    end
})

local RandomServerHopButton = MiscTab:Button({
    Title = "Server Hop",
    Desc = "Teleport to a random non-full server",
    Callback = function()
        hopToRandomServer()
    end
})

-- ========================================
-- SETTINGS TAB ELEMENTS
-- ========================================
local SaveConfigButton = SettingsTab:Button({
    Title = "Save Configuration",
    Desc = "Save all current settings to file",
    Callback = function()
        saveConfiguration()
    end
})

local LoadConfigButton = SettingsTab:Button({
    Title = "Load Configuration",
    Desc = "Load your saved settings from file",
    Callback = function()
        loadConfiguration()
    end
})

local ThemeDropdown = SettingsTab:Dropdown({
    Title = "Theme Selector",
    Values = {
        {Title = "Dark", Icon = "moon"},
        {Title = "Light", Icon = "sun"},
        {Title = "Purple Dream", Icon = "sparkles"},
        {Title = "Ocean Blue", Icon = "waves"},
        {Title = "Forest Green", Icon = "tree-deciduous"},
        {Title = "Crimson Red", Icon = "flame"},
        {Title = "Sunset Orange", Icon = "sunset"},
        {Title = "Midnight Purple", Icon = "moon-star"},
        {Title = "Cyan Glow", Icon = "zap"},
        {Title = "Rose Pink", Icon = "heart"},
        {Title = "Golden Hour", Icon = "sun"},
        {Title = "Neon Green", Icon = "zap-off"},
        {Title = "Electric Blue", Icon = "sparkle"},
        {Title = "Custom", Icon = "palette"},
    },
    Value = "Dark",
    Callback = function(option)
        changeTheme(option.Title)
    end
})

local ThemeColorPicker = SettingsTab:Colorpicker({
    Title = "Custom Theme Color",
    Desc = "Select a custom accent color for the UI",
    Default = Color3.fromRGB(255, 15, 123),
    Callback = function(color)
        WindUI:AddTheme({
            Name = "Custom",
            Accent = color,
            Dialog = Color3.fromHex("#161616"),
            Outline = color,
            Text = Color3.fromHex("#FFFFFF"),
            Placeholder = Color3.fromHex("#7a7a7a"),
            Background = Color3.fromHex("#101010"),
            Button = Color3.fromHex("#52525b"),
            Icon = color
        })
        
        WindUI:SetTheme("Custom")
        States.CurrentTheme = "Custom"
    end
})

-- ========================================
-- REGISTER CONFIG ELEMENTS
-- ========================================
myConfig:Register("AntiRagdoll", AntiRagdollToggle)
myConfig:Register("Float", FloatToggle)
myConfig:Register("FloorSteal", FloorStealToggle)
myConfig:Register("MonitorSteals", MonitorStealsToggle)
myConfig:Register("ESP", ESPToggle)
myConfig:Register("FullBright", FullBrightToggle)
myConfig:Register("LowGFX", LowGFXToggle)
myConfig:Register("Theme", ThemeDropdown)
myConfig:Register("ThemeColor", ThemeColorPicker)

-- ========================================
-- EVENT CONNECTIONS AND INITIALIZATION
-- ========================================
player.CharacterRemoving:Connect(function()
    platformEnabled = false
    wallTransparencyEnabled = false
    comboFloatEnabled = false
    teleportEnabled = false
    
    if currentPlatform then currentPlatform:Destroy() end
    if comboCurrentPlatform then comboCurrentPlatform:Destroy() end
    if grappleHookConnection then task.cancel(grappleHookConnection) end
    if teleportGrappleConnection then task.cancel(teleportGrappleConnection) end
    if teleportOverlay then removeTeleportOverlay() end
end)

player.CharacterAdded:Connect(onCharacterAdded)

-- ========================================
-- WELCOME POPUP
-- ========================================
WindUI:Popup({
    Title = "Steal A Brainrot V1.0",
    Icon = "sword",
    Content = "New Update: Added WindUI with multiple themes and better organization!",
    Buttons = {
        {
            Title = "Close",
            Callback = function() end,
            Variant = "Tertiary",
        },
        {
            Title = "Join Discord",
            Icon = "users",
            Callback = function()
                setclipboard("https://discord.gg/bpsNUH5sVb")
                WindUI:Notify({
                    Title = "Link Copied!",
                    Content = "Discord invite copied to clipboard!",
                    Duration = 3,
                    Icon = "check",
                })
            end,
            Variant = "Primary",
        }
    }
})
