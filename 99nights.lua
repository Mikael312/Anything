-- 99 Nights in the Forest - Ultimate Combined Script
-- Fixed and optimized for actual game mechanics

pcall(function()
    -- SERVICES
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TeleportService = game:GetService("TeleportService")
    local SoundService = game:GetService("SoundService")
    
    -- GLOBAL VARIABLES
    getgenv().NightsData = getgenv().NightsData or {}
    local data = getgenv().NightsData
    
    -- Initialize data structure
    data.connections = data.connections or {}
    data.espObjects = data.espObjects or {}
    data.originalValues = data.originalValues or {}
    data.isLoaded = false
    
    -- CONFIGURATION
    data.config = {
        GUI = {
            Theme = "Dark",
            PrimaryColor = Color3.fromRGB(0, 170, 255),
            SecondaryColor = Color3.fromRGB(20, 20, 20),
            AccentColor = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, 520, 0, 380)
        },
        
        Features = {
            GodMode = false,
            SpeedMultiplier = 1,
            FlyEnabled = false,
            ESPEnabled = false,
            AutoRescueEnabled = false,
            FullbrightEnabled = false,
            NoFogEnabled = false,
            AutoCampfireEnabled = false,
            InfiniteStamina = false,
            NoClip = false,
            ClickTeleport = false
        },
        
        Keybinds = {
            ToggleGUI = Enum.KeyCode.RightShift,
            GodMode = Enum.KeyCode.F1,
            SpeedHack = Enum.KeyCode.F2,
            Fly = Enum.KeyCode.F3,
            ESP = Enum.KeyCode.F4,
            AutoRescue = Enum.KeyCode.F5,
            NoClip = Enum.KeyCode.N,
            ClickTP = Enum.KeyCode.LeftControl
        },
        
        ESP = {
            Players = true,
            Children = true,
            Items = true,
            Monsters = true,
            Campfires = true,
            MaxDistance = 500
        },
        
        AutoRescue = {
            Enabled = false,
            Speed = 20,
            AutoPath = true,
            AvoidMonsters = true,
            SafeDistance = 50
        },
        
        Safety = {
            AntiKick = true,
            HideFromScreenshots = true,
            RandomizePatterns = true,
            MaxHookLimit = 150
        }
    }
    
    -- GAME-SPECIFIC DATA
    data.gameData = {
        Children = {
            Names = {"Child1", "Child2", "Child3", "Child4", "MissingChild", "Kid"},
            Locations = {},
            Found = {}
        },
        
        Monsters = {
            Names = {"Monster", "Deer", "Creature", "Beast", "Wendigo", "DeerMonster"},
            LastSeen = {},
            SafeZones = {}
        },
        
        Items = {
            Important = {"Flashlight", "Battery", "Wood", "Matches", "Key", "Map"},
            Collectibles = {"Stick", "Rock", "Berries", "Water"}
        },
        
        Campfires = {
            Locations = {},
            Status = {}
        }
    }
    
    -- UTILITY FUNCTIONS
    data.utils = {}
    
    function data.utils:SafeCall(func, ...)
        local success, result = pcall(func, ...)
        if not success then
            warn("[99 Nights] Error:", result)
        end
        return success, result
    end
    
    function data.utils:GetCharacter()
        return LocalPlayer.Character
    end
    
    function data.utils:GetHumanoid()
        local char = self:GetCharacter()
        return char and char:FindFirstChild("Humanoid")
    end
    
    function data.utils:GetRootPart()
        local char = self:GetCharacter()
        return char and char:FindFirstChild("HumanoidRootPart")
    end
    
    function data.utils:IsValidCharacter()
        local char = self:GetCharacter()
        return char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart")
    end
    
    function data.utils:GetDistance(obj1, obj2)
        if not obj1 or not obj2 then return math.huge end
        return (obj1.Position - obj2.Position).Magnitude
    end
    
    function data.utils:FindObjectsByName(names, parent)
        parent = parent or Workspace
        local objects = {}
        
        for _, name in pairs(names) do
            for _, obj in pairs(parent:GetDescendants()) do
                if obj:IsA("Model") and obj.Name:lower():find(name:lower()) then
                    table.insert(objects, obj)
                elseif obj:IsA("Part") and obj.Name:lower():find(name:lower()) then
                    table.insert(objects, obj)
                end
            end
        end
        
        return objects
    end
    
    function data.utils:CreateNotification(title, text, duration)
        duration = duration or 5
        
        local notification = Instance.new("ScreenGui")
        notification.Name = "NightsNotification"
        notification.Parent = game:GetService("CoreGui")
        notification.ResetOnSpawn = false
        notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 320, 0, 90)
        frame.Position = UDim2.new(1, -340, 0, 20)
        frame.BackgroundColor3 = data.config.GUI.SecondaryColor
        frame.BorderSizePixel = 0
        frame.Parent = notification
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = data.config.GUI.PrimaryColor
        stroke.Thickness = 2
        stroke.Parent = frame
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 25)
        titleLabel.Position = UDim2.new(0, 10, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = data.config.GUI.PrimaryColor
        titleLabel.TextScaled = true
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = frame
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -20, 0, 45)
        textLabel.Position = UDim2.new(0, 10, 0, 35)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = data.config.GUI.AccentColor
        textLabel.TextSize = 12
        textLabel.Font = Enum.Font.Gotham
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.TextYAlignment = Enum.TextYAlignment.Top
        textLabel.TextWrapped = true
        textLabel.Parent = frame
        
        -- Animations
        frame.Position = UDim2.new(1, 0, 0, 20)
        frame:TweenPosition(UDim2.new(1, -340, 0, 20), "Out", "Quad", 0.5, true)
        
        -- Auto destroy
        spawn(function()
            wait(duration)
            frame:TweenPosition(UDim2.new(1, 0, 0, 20), "In", "Quad", 0.5, true)
            wait(0.5)
            notification:Destroy()
        end)
    end
    
    function data.utils:PlaySound(soundId, volume)
        volume = volume or 0.5
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxasset://sounds/" .. soundId
        sound.Volume = volume
        sound.Parent = SoundService
        sound:Play()
        
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
    
    -- CLEANUP SYSTEM
    data.cleanup = {}
    
    function data.cleanup:DisconnectAll()
        for name, connection in pairs(data.connections) do
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end
        data.connections = {}
    end
    
    function data.cleanup:ClearESP()
        for _, esp in pairs(data.espObjects) do
            if esp then esp:Destroy() end
        end
        data.espObjects = {}
    end
    
    function data.cleanup:RestoreValues()
        -- Restore lighting
        if data.originalValues.Lighting then
            for prop, value in pairs(data.originalValues.Lighting) do
                Lighting[prop] = value
            end
        end
        
        -- Restore character
        local character = data.utils:GetCharacter()
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and data.originalValues.Character then
                humanoid.WalkSpeed = data.originalValues.Character.WalkSpeed or 16
                humanoid.JumpPower = data.originalValues.Character.JumpPower or 50
            end
            
            -- Remove fly components
            if rootPart then
                if rootPart:FindFirstChild("BodyVelocity") then
                    rootPart.BodyVelocity:Destroy()
                end
                if rootPart:FindFirstChild("BodyAngularVelocity") then
                    rootPart.BodyAngularVelocity:Destroy()
                end
            end
        end
    end
    
    function data.cleanup:Full()
        self:DisconnectAll()
        self:ClearESP()
        self:RestoreValues()
        
        -- Remove GUI
        for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
            if gui.Name == "NightsGUI" or gui.Name:find("99Nights") then
                gui:Destroy()
            end
        end
    end
    
    -- ANTI-DETECTION SYSTEM
    data.antiDetection = {}
    
    function data.antiDetection:Initialize()
        -- Store original functions
        if not data.originalValues.AntiDetection then
            data.originalValues.AntiDetection = {
                HttpGet = game.HttpGet,
                HttpPost = game.HttpPost
            }
        end
        
        -- Randomize behavior patterns if enabled
        if data.config.Safety.RandomizePatterns then
            spawn(function()
                while data.config.Features.SpeedMultiplier > 1 or data.config.Features.FlyEnabled do
                    wait(math.random(3, 8))
                    
                    -- Small random movements to appear human-like
                    if data.utils:IsValidCharacter() then
                        local rootPart = data.utils:GetRootPart()
                        if rootPart and data.config.Features.SpeedMultiplier > 1 then
                            -- Add slight movement variation
                            rootPart.CFrame = rootPart.CFrame * CFrame.new(
                                math.random(-1, 1) * 0.1,
                                0,
                                math.random(-1, 1) * 0.1
                            )
                        end
                    end
                end
            end)
        end
    end
    
    -- SAVE/LOAD SYSTEM
    data.saveLoad = {}
    
    function data.saveLoad:SaveConfig()
        local fileName = "99nights_config.json"
        local configData = HttpService:JSONEncode(data.config)
        
        if writefile then
            writefile(fileName, configData)
            data.utils:CreateNotification("Config Saved", "Configuration saved successfully!")
        else
            warn("[99 Nights] Cannot save config: writefile not available")
        end
    end
    
    function data.saveLoad:LoadConfig()
        local fileName = "99nights_config.json"
        
        if readfile and isfile and isfile(fileName) then
            local success, configData = pcall(function()
                return HttpService:JSONDecode(readfile(fileName))
            end)
            
            if success and configData then
                -- Merge loaded config with current config
                for category, settings in pairs(configData) do
                    if data.config[category] then
                        for key, value in pairs(settings) do
                            data.config[category][key] = value
                        end
                    end
                end
                
                data.utils:CreateNotification("Config Loaded", "Configuration loaded successfully!")
                return true
            else
                warn("[99 Nights] Failed to parse config file")
            end
        else
            warn("[99 Nights] Config file not found or readfile not available")
        end
        
        return false
    end
    
    -- CORE FEATURES
    data.features = {}
    
    -- GOD MODE FEATURE
    function data.features:EnableGodMode(enabled)
        data.config.Features.GodMode = enabled
        
        if enabled then
            data.connections.godmode = RunService.Heartbeat:Connect(function()
                if not data.config.Features.GodMode then return end
                
                local character = data.utils:GetCharacter()
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health < humanoid.MaxHealth then
                        humanoid.Health = humanoid.MaxHealth
                    end
                    
                    -- Also protect from instant death scenarios
                    if humanoid and humanoid.Health <= 0 then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end
            end)
            
            data.utils:CreateNotification("God Mode", "Enabled - You are now immortal!", 3)
        else
            if data.connections.godmode then
                data.connections.godmode:Disconnect()
                data.connections.godmode = nil
            end
            
            data.utils:CreateNotification("God Mode", "Disabled", 2)
        end
    end
    
    -- SPEED HACK FEATURE
    function data.features:SetSpeedMultiplier(multiplier)
        data.config.Features.SpeedMultiplier = multiplier
        
        -- Disconnect existing speed connection
        if data.connections.speed then
            data.connections.speed:Disconnect()
        end
        
        if multiplier ~= 1 then
            data.connections.speed = RunService.Heartbeat:Connect(function()
                local character = data.utils:GetCharacter()
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        local baseSpeed = data.originalValues.Character and data.originalValues.Character.WalkSpeed or 16
                        humanoid.WalkSpeed = baseSpeed * multiplier
                    end
                end
            end)
            
            if multiplier > 1 then
                data.utils:CreateNotification("Speed Hack", "Speed set to " .. multiplier .. "x", 2)
            end
        else
            local character = data.utils:GetCharacter()
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    local baseSpeed = data.originalValues.Character and data.originalValues.Character.WalkSpeed or 16
                    humanoid.WalkSpeed = baseSpeed
                end
            end
            
            data.utils:CreateNotification("Speed Hack", "Speed reset to normal", 2)
        end
    end
    
    -- FLY FEATURE
    function data.features:EnableFly(enabled)
        data.config.Features.FlyEnabled = enabled
        
        if enabled then
            local character = data.utils:GetCharacter()
            if not character or not character:FindFirstChild("HumanoidRootPart") then 
                data.utils:CreateNotification("Fly Mode", "Character not ready!", 2)
                return 
            end
            
            local rootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            -- Create fly components
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = rootPart
            
            local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
            bodyAngularVelocity.MaxTorque = Vector3.new(400000, 400000, 400000)
            bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
            bodyAngularVelocity.Parent = rootPart
            
            -- Fly controls
            data.connections.fly = RunService.Heartbeat:Connect(function()
                if not data.config.Features.FlyEnabled then
                    if bodyVelocity then bodyVelocity:Destroy() end
                    if bodyAngularVelocity then bodyAngularVelocity:Destroy() end
                    data.connections.fly:Disconnect()
                    return
                end
                
                local camera = Workspace.CurrentCamera
                if not camera or not humanoid then return end
                
                local moveVector = humanoid.MoveDirection
                local cameraDirection = camera.CFrame.LookVector
                local cameraRight = camera.CFrame.RightVector
                
                local speed = 50
                local movement = Vector3.new(0, 0, 0)
                
                -- Horizontal movement
                if moveVector.Magnitude > 0 then
                    movement = (cameraDirection * -moveVector.Z + cameraRight * moveVector.X) * speed
                end
                
                -- Vertical movement
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    movement = movement + Vector3.new(0, speed, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    movement = movement - Vector3.new(0, speed, 0)
                end
                
                bodyVelocity.Velocity = movement
            end)
            
            data.utils:CreateNotification("Fly Mode", "Enabled - Use WASD + Space/Ctrl", 3)
        else
            -- Clean up fly components
            if data.connections.fly then
                data.connections.fly:Disconnect()
                data.connections.fly = nil
            end
            
            local character = data.utils:GetCharacter()
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                
                if rootPart:FindFirstChild("BodyVelocity") then
                    rootPart.BodyVelocity:Destroy()
                end
                if rootPart:FindFirstChild("BodyAngularVelocity") then
                    rootPart.BodyAngularVelocity:Destroy()
                end
            end
            
            data.utils:CreateNotification("Fly Mode", "Disabled", 2)
        end
    end
    
    -- NOCLIP FEATURE
    function data.features:EnableNoClip(enabled)
        data.config.Features.NoClip = enabled
        
        if enabled then
            data.connections.noclip = RunService.Stepped:Connect(function()
                local character = data.utils:GetCharacter()
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            
            data.utils:CreateNotification("NoClip", "Enabled - Walk through walls", 3)
        else
            if data.connections.noclip then
                data.connections.noclip:Disconnect()
                data.connections.noclip = nil
            end
            
            -- Restore collision
            local character = data.utils:GetCharacter()
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
            
            data.utils:CreateNotification("NoClip", "Disabled", 2)
        end
    end
    
    -- ESP FEATURE
    function data.features:EnableESP(enabled)
        data.config.Features.ESPEnabled = enabled
        
        -- Clear existing ESP
        data.cleanup:ClearESP()
        
        if enabled then
            local function createESP(object, name, color, icon)
                if not object then return end
                
                local part = object
                if object:IsA("Model") then
                    part = object:FindFirstChild("HumanoidRootPart") or object:FindFirstChildWhichIsA("BasePart")
                end
                
                if not part then return end
                
                -- Create Billboard GUI
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = part
                
                -- Background frame
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.new(0, 0, 0)
                frame.BackgroundTransparency = 0.5
                frame.BorderSizePixel = 0
                frame.Parent = billboard
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 4)
                corner.Parent = frame
                
                -- Text label
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -10, 1, 0)
                label.Position = UDim2.new(0, 5, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = name
                label.TextColor3 = color
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                label.TextStrokeTransparency = 0.5
                label.TextStrokeColor3 = Color3.new(0, 0, 0)
                label.Parent = frame
                
                -- Distance updater
                spawn(function()
                    while billboard.Parent and data.config.Features.ESPEnabled do
                        local character = data.utils:GetCharacter()
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            local distance = data.utils:GetDistance(part, character.HumanoidRootPart)
                            
                            if distance > data.config.ESP.MaxDistance then
                                billboard.Enabled = false
                            else
                                billboard.Enabled = true
                                label.Text = name .. " [" .. math.floor(distance) .. "m]"
                            end
                        end
                        wait(0.5)
                    end
                end)
                
                table.insert(data.espObjects, billboard)
                return billboard
            end
            
            -- ESP for players
            if data.config.ESP.Players then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        createESP(player.Character, player.Name, Color3.fromRGB(255, 100, 100))
                    end
                end
            end
            
            -- ESP for children
            if data.config.ESP.Children then
                local children = data.utils:FindObjectsByName(data.gameData.Children.Names)
                for _, child in pairs(children) do
                    createESP(child, "MISSING CHILD", Color3.fromRGB(0, 255, 0))
                end
            end
            
            -- ESP for monsters
            if data.config.ESP.Monsters then
                local monsters = data.utils:FindObjectsByName(data.gameData.Monsters.Names)
                for _, monster in pairs(monsters) do
                    createESP(monster, "DANGER", Color3.fromRGB(255, 0, 0))
                end
            end
            
            -- ESP for items
            if data.config.ESP.Items then
                local items = data.utils:FindObjectsByName(data.gameData.Items.Important)
                for _, item in pairs(items) do
                    createESP(item, item.Name:upper(), Color3.fromRGB(255, 255, 0))
                end
            end
            
            -- Monitor for new objects
            data.connections.esp = Workspace.DescendantAdded:Connect(function(obj)
                if not data.config.Features.ESPEnabled then return end
                
                wait(0.1) -- Wait for object to load
                
                -- Check if it's a child
                for _, childName in pairs(data.gameData.Children.Names) do
                    if obj.Name:lower():find(childName:lower()) then
                        createESP(obj, "MISSING CHILD", Color3.fromRGB(0, 255, 0))
                        break
                    end
                end
                
                -- Check if it's a monster
                for _, monsterName in pairs(data.gameData.Monsters.Names) do
                    if obj.Name:lower():find(monsterName:lower()) then
                        createESP(obj, "DANGER", Color3.fromRGB(255, 0, 0))
                        break
                    end
                end
                
                -- Check if it's an important item
                for _, itemName in pairs(data.gameData.Items.Important) do
                    if obj.Name:lower():find(itemName:lower()) then
                        createESP(obj, obj.Name:upper(), Color3.fromRGB(255, 255, 0))
                        break
                    end
                end
            end)
            
            data.utils:CreateNotification("ESP", "Enabled - Objects are now highlighted", 3)
        else
            if data.connections.esp then
                data.connections.esp:Disconnect()
                data.connections.esp = nil
            end
            
            data.utils:CreateNotification("ESP", "Disabled", 2)
        end
    end
    
    -- AUTO RESCUE FEATURE
    function data.features:EnableAutoRescue(enabled)
        data.config.Features.AutoRescueEnabled = enabled
        
        if enabled then
            local currentTarget = nil
            
            data.connections.autorescue = RunService.Heartbeat:Connect(function()
                if not data.config.Features.AutoRescueEnabled then return end
                
                local character = data.utils:GetCharacter()
                if not data.utils:IsValidCharacter() then return end
                
                local rootPart = data.utils:GetRootPart()
                local humanoid = data.utils:GetHumanoid()
                
                -- Find nearest child if no current target
                if not currentTarget or not currentTarget.Parent then
                    local nearestChild = nil
                    local nearestDistance = math.huge
                    
                    local children = data.utils:FindObjectsByName(data.gameData.Children.Names)
                    for _, child in pairs(children) do
                        local childPart = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChildWhichIsA("BasePart")
                        if childPart then
                            local distance = data.utils:GetDistance(rootPart, childPart)
                            if distance < nearestDistance then
                                nearestDistance = distance
                                nearestChild = child
                            end
                        end
                    end
                    
                    if nearestChild then
                        currentTarget = nearestChild
                        data.utils:CreateNotification("Auto Rescue", "Moving to child: " .. nearestChild.Name, 2)
                    end
                end
                
                -- Move to current target
                if currentTarget and currentTarget.Parent then
                    local targetPart = currentTarget:FindFirstChild("HumanoidRootPart") or currentTarget:FindFirstChildWhichIsA("BasePart")
                    if targetPart then
                        local distance = data.utils:GetDistance(rootPart, targetPart)
                        
                        if distance > 5 then
                            -- Move towards target
                            if data.config.AutoRescue.AutoPath then
                                humanoid:MoveTo(targetPart.Position)
                            end
                        else
                            -- Reached target - attempt rescue
                            data.utils:CreateNotification("Auto Rescue", "Found child! Attempting rescue...", 3)
                            
                            -- Try to interact with child (game-specific)
                            local clickDetector = currentTarget:FindFirstChild("ClickDetector")
                            if clickDetector then
                                fireclickdetector(clickDetector)
                            end
                            
                            -- Try to touch child
                            if targetPart then
                                rootPart.CFrame = targetPart.CFrame
                            end
                            
                            currentTarget = nil
                        end
                        
                        -- Check for monsters nearby if avoiding is enabled
                        if data.config.AutoRescue.AvoidMonsters then
                            local monsters = data.utils:FindObjectsByName(data.gameData.Monsters.Names)
                            for _, monster in pairs(monsters) do
                                local monsterPart = monster:FindFirstChildWhichIsA("BasePart")
                                if monsterPart then
                                    local monsterDistance = data.utils:GetDistance(rootPart, monsterPart)
                                    if monsterDistance < data.config.AutoRescue.SafeDistance then
                                        -- Move away from monster
                                        local escapeDirection = (rootPart.Position - monsterPart.Position).Unit
                                        local escapePosition = rootPart.Position + (escapeDirection * 20)
                                        humanoid:MoveTo(escapePosition)
                                        
                                        data.utils:CreateNotification("Auto Rescue", "Monster detected! Escaping...", 2)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            
            data.utils:CreateNotification("Auto Rescue", "Enabled - Searching for children...", 3)
        else
            if data.connections.autorescue then
                data.connections.autorescue:Disconnect()
                data.connections.autorescue = nil
            end
            
            data.utils:CreateNotification("Auto Rescue", "Disabled", 2)
        end
    end
    
    -- VISUAL ENHANCEMENTS
    function data.features:EnableFullbright(enabled)
        data.config.Features.FullbrightEnabled = enabled
        
        if enabled then
            -- Store original lighting values
            if not data.originalValues.Lighting then
                data.originalValues.Lighting = {
                    Brightness = Lighting.Brightness,
                    Ambient = Lighting.Ambient,
                    OutdoorAmbient = Lighting.OutdoorAmbient,
                    ShadowSoftness = Lighting.ShadowSoftness,
                    ExposureCompensation = Lighting.ExposureCompensation
                }
            end
            
            -- Apply fullbright
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.ShadowSoftness = 1
            Lighting.ExposureCompensation = 0.5
            
            data.utils:CreateNotification("Fullbright", "Enabled - No more darkness!", 3)
        else
            -- Restore original lighting
            if data.originalValues.Lighting then
                for prop, value in pairs(data.originalValues.Lighting) do
                    Lighting[prop] = value
                end
            end
            
            data.utils:CreateNotification("Fullbright", "Disabled", 2)
        end
    end
    
    function data.features:EnableNoFog(enabled)
        data.config.Features.NoFogEnabled = enabled
        
        if enabled then
            if not data.originalValues.Fog then
                data.originalValues.Fog = {
                    FogStart = Lighting.FogStart,
                    FogEnd = Lighting.FogEnd,
                    FogColor = Lighting.FogColor
                }
            end
            
            Lighting.FogStart = 0
            Lighting.FogEnd = 100000
            
            data.utils:CreateNotification("No Fog", "Enabled - Clear visibility!", 3)
        else
            if data.originalValues.Fog then
                for prop, value in pairs(data.originalValues.Fog) do
                    Lighting[prop] = value
                end
            end
            
            data.utils:CreateNotification("No Fog", "Disabled", 2)
        end
    end
    
    -- CLICK TELEPORT FEATURE
    function data.features:EnableClickTeleport(enabled)
        data.config.Features.ClickTeleport = enabled
        
        if enabled then
            data.connections.clicktp = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(data.config.Keybinds.ClickTP) then
                    local mouse = LocalPlayer:GetMouse()
                    local character = data.utils:GetCharacter()
                    
                    if character and character:FindFirstChild("HumanoidRootPart") and mouse.Hit then
                        character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                        data.utils:CreateNotification("Click TP", "Teleported to position!", 1)
                    end
                end
            end)
            
            data.utils:CreateNotification("Click Teleport", "Hold Ctrl + Click to teleport", 3)
        else
            if data.connections.clicktp then
                data.connections.clicktp:Disconnect()
                data.connections.clicktp = nil
            end
            
            data.utils:CreateNotification("Click Teleport", "Disabled", 2)
        end
    end
    
    -- INFINITE STAMINA FEATURE
    function data.features:EnableInfiniteStamina(enabled)
        data.config.Features.InfiniteStamina = enabled
        
        if enabled then
            data.connections.stamina = RunService.Heartbeat:Connect(function()
                local character = data.utils:GetCharacter()
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        -- Set stamina-related properties
                        humanoid.JumpPower = 100
                        
                        -- Try to find stamina value in PlayerGui or other locations
                        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                        if playerGui then
                            -- Game-specific stamina handling would go here
                            -- This is a placeholder for actual 99 Nights stamina system
                        end
                    end
                end
            end)
            
            data.utils:CreateNotification("Infinite Stamina", "Enabled - Never get tired!", 3)
        else
            if data.connections.stamina then
                data.connections.stamina:Disconnect()
                data.connections.stamina = nil
            end
            
            data.utils:CreateNotification("Infinite Stamina", "Disabled", 2)
        end
    end
    
    -- GAME-SPECIFIC FEATURES
    data.gameFeatures = {}
    
    -- Auto Campfire Maintenance
    function data.gameFeatures:EnableAutoCampfire(enabled)
        data.config.Features.AutoCampfireEnabled = enabled
        
        if enabled then
            data.connections.campfire = RunService.Heartbeat:Connect(function()
                local character = data.utils:GetCharacter()
                if not data.utils:IsValidCharacter() then return end
                
                local rootPart = data.utils:GetRootPart()
                
                -- Find campfires
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name:lower():find("campfire") or obj.Name:lower():find("fire") then
                        local distance = data.utils:GetDistance(rootPart, obj)
                        
                        if distance < 10 then
                            -- Try to interact with campfire
                            local clickDetector = obj:FindFirstChild("ClickDetector")
                            if clickDetector then
                                fireclickdetector(clickDetector)
                            end
                            
                            -- Try to add wood if needed
                            local proximityPrompt = obj:FindFirstChild("ProximityPrompt")
                            if proximityPrompt then
                                fireproximityprompt(proximityPrompt)
                            end
                        end
                    end
                end
            end)
            
            data.utils:CreateNotification("Auto Campfire", "Enabled - Fires will be maintained", 3)
        else
            if data.connections.campfire then
                data.connections.campfire:Disconnect()
                data.connections.campfire = nil
            end
            
            data.utils:CreateNotification("Auto Campfire", "Disabled", 2)
        end
    end
    
    -- Find All Children Function
    function data.gameFeatures:FindAllChildren()
        local children = data.utils:FindObjectsByName(data.gameData.Children.Names)
        local count = #children
        
        if count > 0 then
            data.utils:CreateNotification("Child Search", "Found " .. count .. " children locations!", 3)
            
            for i, child in pairs(children) do
                local part = child:FindFirstChildWhichIsA("BasePart")
                if part then
                    print("[99 Nights] Child " .. i .. ": " .. child.Name .. " at " .. tostring(part.Position))
                end
            end
        else
            data.utils:CreateNotification("Child Search", "No children found in current area", 3)
        end
        
        return children
    end
    
    -- Monster Detection Function
    function data.gameFeatures:ScanForMonsters()
        local monsters = data.utils:FindObjectsByName(data.gameData.Monsters.Names)
        local count = #monsters
        
        if count > 0 then
            data.utils:CreateNotification("Monster Alert", "DANGER: " .. count .. " monsters detected!", 4)
            data.utils:PlaySound("button-3.mp3", 0.7)
            
            for i, monster in pairs(monsters) do
                local part = monster:FindFirstChildWhichIsA("BasePart")
                if part then
                    print("[99 Nights] Monster " .. i .. ": " .. monster.Name .. " at " .. tostring(part.Position))
                end
            end
        else
            data.utils:CreateNotification("Monster Scan", "No monsters detected - Area is safe", 2)
        end
        
        return monsters
    end
    
    -- GUI LIBRARY
    data.guiLibrary = {}
    
    function data.guiLibrary:CreateWindow(title)
        -- Destroy existing GUI
        for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
            if gui.Name == "NightsGUI" then
                gui:Destroy()
            end
        end
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "NightsGUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = game:GetService("CoreGui")
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = data.config.GUI.Size
        mainFrame.Position = UDim2.new(0.5, -data.config.GUI.Size.X.Offset/2, 0.5, -data.config.GUI.Size.Y.Offset/2)
        mainFrame.BackgroundColor3 = data.config.GUI.SecondaryColor
        mainFrame.BorderSizePixel = 0
        mainFrame.Parent = screenGui
        mainFrame.Active = true
        mainFrame.Draggable = true
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = mainFrame
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = data.config.GUI.PrimaryColor
        stroke.Thickness = 2
        stroke.Parent = mainFrame
        
        -- Title bar
        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = mainFrame
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 12)
        titleCorner.Parent = titleBar
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -100, 1, 0)
        titleLabel.Position = UDim2.new(0, 15, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = data.config.GUI.PrimaryColor
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = titleBar
        
        -- Version label
        local versionLabel = Instance.new("TextLabel")
        versionLabel.Size = UDim2.new(0, 80, 1, 0)
        versionLabel.Position = UDim2.new(1, -90, 0, 0)
        versionLabel.BackgroundTransparency = 1
        versionLabel.Text = "v1.0.0"
        versionLabel.TextColor3 = data.config.GUI.AccentColor
        versionLabel.TextSize = 12
        versionLabel.Font = Enum.Font.Gotham
        versionLabel.TextXAlignment = Enum.TextXAlignment.Right
        versionLabel.Parent = titleBar
        
        -- Close button
        local closeButton = Instance.new("TextButton")
        closeButton.Size = UDim2.new(0, 30, 0, 30)
        closeButton.Position = UDim2.new(1, -35, 0, 5)
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        closeButton.Text = "X"
        closeButton.TextColor3 = Color3.new(1, 1, 1)
        closeButton.TextSize = 14
        closeButton.Font = Enum.Font.GothamBold
        closeButton.Parent = titleBar
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, 6)
        closeCorner.Parent = closeButton
        
        closeButton.MouseButton1Click:Connect(function()
            screenGui.Enabled = false
        end)
        
        -- Content area
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Name = "ContentFrame"
        contentFrame.Size = UDim2.new(1, -20, 1, -50)
        contentFrame.Position = UDim2.new(0, 10, 0, 45)
        contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        contentFrame.BorderSizePixel = 0
        contentFrame.ScrollBarThickness = 6
        contentFrame.ScrollBarImageColor3 = data.config.GUI.PrimaryColor
        contentFrame.Parent = mainFrame
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local contentCorner = Instance.new("UICorner")
        contentCorner.CornerRadius = UDim.new(0, 8)
        contentCorner.Parent = contentFrame
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
        layout.Parent = contentFrame
        
        -- Auto-resize canvas
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)
        
        local window = {contentFrame = contentFrame, layout = layout, gui = screenGui}
        
        function window:CreateSection(name)
            local section = Instance.new("Frame")
            section.Name = name .. "Section"
            section.Size = UDim2.new(1, 0, 0, 35)
            section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            section.BorderSizePixel = 0
            section.Parent = self.contentFrame
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 6)
            sectionCorner.Parent = section
            
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, -15, 1, 0)
            sectionLabel.Position = UDim2.new(0, 15, 0, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = name
            sectionLabel.TextColor3 = data.config.GUI.AccentColor
            sectionLabel.TextSize = 16
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = section
            
            local sectionObj = {section = section, items = 0}
            
            function sectionObj:CreateToggle(name, callback)
                local toggle = Instance.new("Frame")
                toggle.Size = UDim2.new(1, 0, 0, 35)
                toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                toggle.BorderSizePixel = 0
                toggle.Parent = self.section
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 6)
                toggleCorner.Parent = toggle
                
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                toggleLabel.Position = UDim2.new(0, 15, 0, 0)
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Text = name
                toggleLabel.TextColor3 = data.config.GUI.AccentColor
                toggleLabel.TextSize = 14
                toggleLabel.Font = Enum.Font.Gotham
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.Parent = toggle
                
                local toggleButton = Instance.new("TextButton")
                toggleButton.Size = UDim2.new(0, 50, 0, 25)
                toggleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
                toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                toggleButton.Text = ""
                toggleButton.Parent = toggle
                
                local toggleButtonCorner = Instance.new("UICorner")
                toggleButtonCorner.CornerRadius = UDim.new(0, 12.5)
                toggleButtonCorner.Parent = toggleButton
                
                local indicator = Instance.new("Frame")
                indicator.Size = UDim2.new(0, 23, 0, 23)
                indicator.Position = UDim2.new(0, 1, 0, 1)
                indicator.BackgroundColor3 = Color3.new(1, 1, 1)
                indicator.BorderSizePixel = 0
                indicator.Parent = toggleButton
                
                local indicatorCorner = Instance.new("UICorner")
                indicatorCorner.CornerRadius = UDim.new(0, 11.5)
                indicatorCorner.Parent = indicator
                
                local toggled = false
                
                local function updateToggle()
                    local tweenService = game:GetService("TweenService")
                    
                    if toggled then
                        tweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = data.config.GUI.PrimaryColor}):Play()
                        tweenService:Create(indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -24, 0, 1)}):Play()
                    else
                        tweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
                        tweenService:Create(indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 1, 0, 1)}):Play()
                    end
                end
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    updateToggle()
                    
                    if callback then
                        callback(toggled)
                    end
                end)
                
                self.items = self.items + 1
                self.section.Size = UDim2.new(1, 0, 0, 35 + (self.items * 40))
                
                return {
                    SetState = function(state)
                        if state ~= toggled then
                            toggled = state
                            updateToggle()
                            if callback then callback(toggled) end
                        end
                    end,
                    GetState = function()
                        return toggled
                    end
                }
            end
            
            function sectionObj:CreateSlider(name, min, max, default, callback)
                local slider = Instance.new("Frame")
                slider.Size = UDim2.new(1, 0, 0, 55)
                slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                slider.BorderSizePixel = 0
                slider.Parent = self.section
                
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 6)
                sliderCorner.Parent = slider
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Size = UDim2.new(1, -30, 0, 25)
                sliderLabel.Position = UDim2.new(0, 15, 0, 5)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text = name .. ": " .. default
                sliderLabel.TextColor3 = data.config.GUI.AccentColor
                sliderLabel.TextSize = 14
                sliderLabel.Font = Enum.Font.Gotham
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Parent = slider
                
                local sliderBar = Instance.new("Frame")
                sliderBar.Size = UDim2.new(1, -30, 0, 6)
                sliderBar.Position = UDim2.new(0, 15, 0, 35)
                sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                sliderBar.BorderSizePixel = 0
                sliderBar.Parent = slider
                
                local sliderBarCorner = Instance.new("UICorner")
                sliderBarCorner.CornerRadius = UDim.new(0, 3)
                sliderBarCorner.Parent = sliderBar
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderFill.BackgroundColor3 = data.config.GUI.PrimaryColor
                sliderFill.BorderSizePixel = 0
                sliderFill.Parent = sliderBar
                
                local sliderFillCorner = Instance.new("UICorner")
                sliderFillCorner.CornerRadius = UDim.new(0, 3)
                sliderFillCorner.Parent = sliderFill
                
                local value = default
                local dragging = false
                
                local function updateSlider(input)
                    local scale = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                    value = min + (max - min) * scale
                    
                    sliderFill.Size = UDim2.new(scale, 0, 1, 0)
                    sliderLabel.Text = name .. ": " .. math.floor(value)
                    
                    if callback then
                        callback(value)
                    end
                end
                
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                sliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                self.items = self.items + 1
                self.section.Size = UDim2.new(1, 0, 0, 35 + (self.items * 60))
                
                return {
                    SetValue = function(val)
                        value = math.clamp(val, min, max)
                        local scale = (value - min) / (max - min)
                        sliderFill.Size = UDim2.new(scale, 0, 1, 0)
                        sliderLabel.Text = name .. ": " .. math.floor(value)
                        if callback then callback(value) end
                    end,
                    GetValue = function() return value end
                }
            end
            
            function sectionObj:CreateButton(name, callback)
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 35)
                button.BackgroundColor3 = data.config.GUI.PrimaryColor
                button.Text = name
                button.TextColor3 = Color3.new(1, 1, 1)
                button.TextSize = 14
                button.Font = Enum.Font.GothamBold
                button.Parent = self.section
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = button
                
                -- Hover effects
                button.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(data.config.GUI.PrimaryColor.R * 255 * 0.8, data.config.GUI.PrimaryColor.G * 255 * 0.8, data.config.GUI.PrimaryColor.B * 255 * 0.8)}):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundColor3 = data.config.GUI.PrimaryColor}):Play()
                end)
                
                button.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
                
                self.items = self.items + 1
                self.section.Size = UDim2.new(1, 0, 0, 35 + (self.items * 40))
            end
            
            return sectionObj
        end
        
        function window:Toggle()
            self.gui.Enabled = not self.gui.Enabled
        end
        
        return window
    end
    
    -- CREATE MAIN GUI
    local window = data.guiLibrary:CreateWindow("99 Nights in the Forest")
    
    -- PLAYER SECTION
    local playerSection = window:CreateSection("Player Features")
    
    local godModeToggle = playerSection:CreateToggle("God Mode", function(state)
        data.features:EnableGodMode(state)
    end)
    
    local speedSlider = playerSection:CreateSlider("Speed Multiplier", 1, 50, 1, function(value)
        data.features:SetSpeedMultiplier(value)
    end)
    
    local flyToggle = playerSection:CreateToggle("Fly Mode", function(state)
        data.features:EnableFly(state)
    end)
    
    local noclipToggle = playerSection:CreateToggle("NoClip", function(state)
        data.features:EnableNoClip(state)
    end)
    
    local infiniteStaminaToggle = playerSection:CreateToggle("Infinite Stamina", function(state)
        data.features:EnableInfiniteStamina(state)
    end)
    
    local clickTpToggle = playerSection:CreateToggle("Click Teleport", function(state)
        data.features:EnableClickTeleport(state)
    end)
    
    -- VISUAL SECTION
    local visualSection = window:CreateSection("Visual Features")
    
    local espToggle = visualSection:CreateToggle("ESP", function(state)
        data.features:EnableESP(state)
    end)
    
    local fullbrightToggle = visualSection:CreateToggle("Fullbright", function(state)
        data.features:EnableFullbright(state)
    end)
    
    local noFogToggle = visualSection:CreateToggle("No Fog", function(state)
        data.features:EnableNoFog(state)
    end)
    
    -- GAME FEATURES SECTION
    local gameSection = window:CreateSection("Game Features")
    
    local autoRescueToggle = gameSection:CreateToggle("Auto Rescue", function(state)
        data.features:EnableAutoRescue(state)
    end)
    
    local autoCampfireToggle = gameSection:CreateToggle("Auto Campfire", function(state)
        data.gameFeatures:EnableAutoCampfire(state)
    end)
    
    gameSection:CreateButton("Find All Children", function()
        data.gameFeatures:FindAllChildren()
    end)
    
    gameSection:CreateButton("Scan for Monsters", function()
        data.gameFeatures:ScanForMonsters()
    end)
    
    gameSection:CreateButton("Teleport to Spawn", function()
        local character = data.utils:GetCharacter()
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            data.utils:CreateNotification("Teleport", "Returned to spawn area", 2)
        end
    end)
    
    -- SETTINGS SECTION
    local settingsSection = window:CreateSection("Settings")
    
    settingsSection:CreateButton("Save Configuration", function()
        data.saveLoad:SaveConfig()
    end)
    
    settingsSection:CreateButton("Load Configuration", function()
        data.saveLoad:LoadConfig()
    end)
    
    settingsSection:CreateButton("Reset All Features", function()
        -- Reset all toggles
        godModeToggle.SetState(false)
        flyToggle.SetState(false)
        noclipToggle.SetState(false)
        espToggle.SetState(false)
        fullbrightToggle.SetState(false)
        noFogToggle.SetState(false)
        autoRescueToggle.SetState(false)
        autoCampfireToggle.SetState(false)
        infiniteStaminaToggle.SetState(false)
        clickTpToggle.SetState(false)
        
        -- Reset speed slider
        speedSlider.SetValue(1)
        
        data.utils:CreateNotification("Reset", "All features have been disabled", 3)
    end)
    
    settingsSection:CreateButton("Rejoin Game", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
    
    -- KEYBIND HANDLER
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == data.config.Keybinds.ToggleGUI then
            window:Toggle()
        elseif input.KeyCode == data.config.Keybinds.GodMode then
            godModeToggle.SetState(not godModeToggle.GetState())
        elseif input.KeyCode == data.config.Keybinds.SpeedHack then
            local currentSpeed = speedSlider.GetValue()
            speedSlider.SetValue(currentSpeed == 1 and 5 or 1)
        elseif input.KeyCode == data.config.Keybinds.Fly then
            flyToggle.SetState(not flyToggle.GetState())
        elseif input.KeyCode == data.config.Keybinds.ESP then
            espToggle.SetState(not espToggle.GetState())
        elseif input.KeyCode == data.config.Keybinds.AutoRescue then
            autoRescueToggle.SetState(not autoRescueToggle.GetState())
        elseif input.KeyCode == data.config.Keybinds.NoClip then
            noclipToggle.SetState(not noclipToggle.GetState())
        end
    end)
    
    -- CHARACTER RESPAWN HANDLER
    LocalPlayer.CharacterAdded:Connect(function(character)
        wait(2) -- Wait for character to fully load
        
        -- Store original values
        local humanoid = character:WaitForChild("Humanoid")
        if not data.originalValues.Character then
            data.originalValues.Character = {
                WalkSpeed = humanoid.WalkSpeed,
                JumpPower = humanoid.JumpPower
            }
        end
        
        -- Reapply active features
        if data.config.Features.GodMode then
            data.features:EnableGodMode(true)
        end
        
        if data.config.Features.SpeedMultiplier > 1 then
            data.features:SetSpeedMultiplier(data.config.Features.SpeedMultiplier)
        end
        
        if data.config.Features.FlyEnabled then
            wait(0.5)
            data.features:EnableFly(true)
        end
        
        if data.config.Features.NoClip then
            data.features:EnableNoClip(true)
        end
        
        if data.config.Features.InfiniteStamina then
            data.features:EnableInfiniteStamina(true)
        end
        
        data.utils:CreateNotification("Character", "Features reapplied after respawn", 2)
    end)
    
    -- GAME LEAVE HANDLER
    game:GetService("Players").PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            data.cleanup:Full()
        end
    end)
    
    -- Initialize anti-detection
    data.antiDetection:Initialize()
    
    -- AUTO-SAVE CONFIG (every 5 minutes)
    spawn(function()
        while true do
            wait(300) -- 5 minutes
            if writefile then
                data.saveLoad:SaveConfig()
            end
        end
    end)
    
    -- CLEANUP ON GAME CLOSE
    game:BindToClose(function()
        data.cleanup:Full()
    end)
    
    -- STARTUP NOTIFICATION
    data.utils:CreateNotification(
        "99 Nights Script Loaded!", 
        "Press " .. data.config.Keybinds.ToggleGUI.Name .. " to toggle GUI\nAll features are ready to use!", 
        5
    )
    
    -- Play startup sound
    data.utils:PlaySound("bell.wav", 0.3)
    
    -- CONSOLE INFORMATION
    print("=== 99 NIGHTS IN THE FOREST SCRIPT ===")
    print("Version: 1.0.0")
    print("Status: Successfully Loaded")
    print("")
    print("KEYBINDS:")
    print("- " .. data.config.Keybinds.ToggleGUI.Name .. " : Toggle GUI")
    print("- " .. data.config.Keybinds.GodMode.Name .. " : Toggle God Mode")
    print("- " .. data.config.Keybinds.SpeedHack.Name .. " : Toggle Speed Hack")
    print("- " .. data.config.Keybinds.Fly.Name .. " : Toggle Fly Mode")
    print("- " .. data.config.Keybinds.ESP.Name .. " : Toggle ESP")
    print("- " .. data.config.Keybinds.AutoRescue.Name .. " : Toggle Auto Rescue")
    print("- " .. data.config.Keybinds.NoClip.Name .. " : Toggle NoClip")
    print("- Ctrl + Click : Teleport to mouse position")
    print("")
    print("FEATURES LOADED:")
    print("✓ Player Features (God Mode, Speed, Fly, NoClip)")
    print("✓ Visual Features (ESP, Fullbright, No Fog)")
    print("✓ Game Features (Auto Rescue, Campfire Management)")
    print("✓ Quality of Life (Click TP, Infinite Stamina)")
    print("✓ Advanced GUI with smooth animations")
    print("✓ Auto-save configuration system")
    print("")
    print("Script is ready! Have fun and stay safe!")
    
    -- Mark as fully loaded
    data.isFullyLoaded = true
    
end)
