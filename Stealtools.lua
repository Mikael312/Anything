-- Steal Tools -- Scrollable Menu UI
-- Professional compact design with all features

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Remove existing GUI
pcall(function()
    for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        if gui.Name == "ScrollableMenuGUI" then
            gui:Destroy()
        end
    end
end)

-- Protection wrapper
local function protectGui(gui)
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        elseif gethui then
            gui.Parent = gethui()
        end
    end)
end

-- ========================================
-- SCROLLABLE MENU GUI
-- ========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScrollableMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

protectGui(screenGui)
screenGui.Parent = LocalPlayer.PlayerGui

-- Main Frame (Container) - More centered
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 320) -- Increased height to accommodate new button
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 120, 200)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Steal Tools"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Scrolling Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -8, 1, -46)
scrollFrame.Position = UDim2.new(0, 4, 0, 42)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 200)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

-- UIListLayout for auto-sizing
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = scrollFrame

-- Auto-update canvas size
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end)

-- Function to create button with toggle state
local function createButton(text, layoutOrder, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 38)
    button.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.LayoutOrder = layoutOrder
    button.Parent = scrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 120, 220)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = button
    
    -- State tracking
    local isActive = false
    
    -- Update visual state - brighter when ON
    local function updateVisual(active)
        if active then
            button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            stroke.Color = Color3.fromRGB(0, 200, 255)
            stroke.Thickness = 2
            stroke.Transparency = 0
        else
            button.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
            stroke.Color = Color3.fromRGB(0, 120, 220)
            stroke.Thickness = 1
            stroke.Transparency = 0.5
        end
    end
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        if not isActive then
            TweenService:Create(button, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not isActive then
            TweenService:Create(button, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(0, 80, 180)
            }):Play()
        end
    end)
    
    -- Click animation
    button.MouseButton1Click:Connect(function()
        button:TweenSize(
            UDim2.new(0, 195, 0, 35),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Back,
            0.08,
            true
        )
        wait(0.08)
        button:TweenSize(
            UDim2.new(0, 200, 0, 38),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Back,
            0.08,
            true
        )
        
        isActive = not isActive
        updateVisual(isActive)
        
        if callback then
            callback(isActive)
        end
    end)
    
    return button
end

-- ========================================
-- GOD MODE SYSTEM (AUTO ON)
-- ========================================
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(c)
    character = c
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
    
    task.wait(1)
    enableGodMode()
end)

local healthConnection = nil
local stateConnection = nil
local maxHealth = 100

local function enableGodMode()
    maxHealth = humanoid.MaxHealth
    
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    if healthConnection then
        healthConnection:Disconnect()
    end
    
    healthConnection = humanoid.HealthChanged:Connect(function(health)
        if health < math.huge then
            humanoid.Health = math.huge
        end
    end)
    
    if stateConnection then
        stateConnection:Disconnect()
    end
    
    stateConnection = humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Dead then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            humanoid.Health = math.huge
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if humanoid then
            if humanoid.Health < math.huge then
                humanoid.Health = math.huge
            end
            
            if humanoid.MaxHealth < math.huge then
                humanoid.MaxHealth = math.huge
            end
        end
    end)
end

enableGodMode()
print("✅ GOD MODE AUTO ENABLED")

-- ========================================
-- XRAY BASE SYSTEM (FROM CODING 2)
-- ========================================
local xrayBaseEnabled = false
local originalTransparency = {}

local function saveOriginalTransparency()
    -- Clear table first
    originalTransparency = {}
    
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in pairs(plots:GetChildren()) do
            for _, part in pairs(plot:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name:lower():find("base plot") or part.Name:lower():find("base") or part.Name:lower():find("plot")) then
                    -- Save original transparency
                    originalTransparency[part] = part.Transparency
                end
            end
        end
    end
end

local function applyTransparency()
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in pairs(plots:GetChildren()) do
            for _, part in pairs(plot:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name:lower():find("base plot") or part.Name:lower():find("base") or part.Name:lower():find("plot")) then
                    -- If not saved yet, save it first
                    if originalTransparency[part] == nil then
                        originalTransparency[part] = part.Transparency
                    end
                    part.Transparency = 0.5
                end
            end
        end
    end
end

local function restoreTransparency()
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in pairs(plots:GetChildren()) do
            for _, part in pairs(plot:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name:lower():find("base plot") or part.Name:lower():find("base") or part.Name:lower():find("plot")) then
                    -- Restore to original transparency
                    if originalTransparency[part] ~= nil then
                        part.Transparency = originalTransparency[part]
                    end
                end
            end
        end
    end
end

local function toggleXrayBase(enabled)
    xrayBaseEnabled = enabled
    
    if xrayBaseEnabled then
        -- Save original transparency values first
        saveOriginalTransparency()
        -- Apply transparency
        applyTransparency()
        print("✓ Xray Base: ON")
    else
        -- Restore original transparency
        restoreTransparency()
        print("✗ Xray Base: OFF")
    end
end

-- Monitor for new plots that spawn
local plots = workspace:FindFirstChild("Plots")
if plots then
    plots.ChildAdded:Connect(function(newPlot)
        task.wait(0.5) -- Wait a bit for plot to fully load
        if xrayBaseEnabled then
            -- If toggle is ON, apply transparency to new plot
            for _, part in pairs(newPlot:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name:lower():find("base plot") or part.Name:lower():find("base") or part.Name:lower():find("plot")) then
                    originalTransparency[part] = part.Transparency
                    part.Transparency = 0.5
                end
            end
        else
            -- If toggle is OFF, just save original
            for _, part in pairs(newPlot:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name:lower():find("base plot") or part.Name:lower():find("base") or part.Name:lower():find("plot")) then
                    originalTransparency[part] = part.Transparency
                end
            end
        end
    end)
end

-- ========================================
-- FLOOR STEAL SYSTEM
-- ========================================
local floorStealEnabled = false
local originalTransparencies = {}
local TRANSPARENCY_LEVEL = 0.6
local comboCurrentPlatform = nil
local comboPlatformUpdateConnection = nil
local comboPlayerCollisionConnection = nil
local grappleHookConnection = nil
local COMBO_PLATFORM_OFFSET = 3.7

local function equipGrappleHook()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    
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
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    
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
    pcall(function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem"):FireServer(unpack(args))
    end)
end

local function equipAndFireGrapple()
    fireGrappleHook()
    equipGrappleHook()
end

local function storeOriginalTransparencies()
    originalTransparencies = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent ~= LocalPlayer.Character and obj.Name ~= "PlayerPlatform" and obj.Name ~= "ComboPlayerPlatform" then
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
    if LocalPlayer.Character then
        local head = LocalPlayer.Character:FindFirstChild("Head")
        if head then head.CanCollide = true end
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then humanoidRootPart.CanCollide = true end
        local torso = LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
        if torso then torso.CanCollide = true end
    end
end

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
    if not floorStealEnabled or not comboCurrentPlatform or not LocalPlayer.Character then return end
    
    local character = LocalPlayer.Character
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

local function enableFloorSteal()
    if floorStealEnabled then return end
    
    floorStealEnabled = true
    
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
            while floorStealEnabled do
                task.wait(1.5)
                equipAndFireGrapple()
                task.wait(0.1)
                unEquipGrappleHook()
            end
        end)
    end
    
    print("✓ Floor Steal: ON")
end

local function disableFloorSteal()
    if not floorStealEnabled then return end
    
    floorStealEnabled = false
    
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
    
    if LocalPlayer.Character then
        local head = LocalPlayer.Character:FindFirstChild("Head")
        if head then head.CanCollide = false end
    end
    
    print("✗ Floor Steal: OFF")
end

-- ========================================
-- LASER CAPE SYSTEM
-- ========================================
local autoLaserEnabled = false
local autoLaserThread = nil

local blacklistNames = {
    "alex4eva", "jkxkelu", "BigTulaH", "xxxdedmoth", "JokiTablet",
    "sleepkola", "Aimbot36022", "Djrjdjdk0", "elsodidudujd", 
    "SENSEIIIlSALT", "yaniecky", "ISAAC_EVO", "7xc_ls", "itz_d1egx"
}
local blacklist = {}
for _, name in ipairs(blacklistNames) do
    blacklist[string.lower(name)] = true
end

local function getLaserRemote()
    local remote = nil
    pcall(function()
        if ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net") then
            remote = ReplicatedStorage.Packages.Net:FindFirstChild("RE/UseItem") or ReplicatedStorage.Packages.Net:FindFirstChild("RE"):FindFirstChild("UseItem")
        end
        if not remote then
            remote = ReplicatedStorage:FindFirstChild("RE/UseItem") or ReplicatedStorage:FindFirstChild("UseItem")
        end
    end)
    return remote
end

local function isValidTarget(player)
    if not player or not player.Character or player == Players.LocalPlayer then return false end
    local name = player.Name and string.lower(player.Name) or ""
    if blacklist[name] then return false end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return false end
    if humanoid.Health <= 0 then return false end
    return true
end

local function findNearestAllowed()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    local nearest = nil
    local nearestDist = math.huge
    for _, pl in ipairs(Players:GetPlayers()) do
        if isValidTarget(pl) then
            local targetHRP = pl.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local d = (Vector3.new(targetHRP.Position.X, 0, targetHRP.Position.Z) - Vector3.new(myPos.X, 0, myPos.Z)).Magnitude
                if d < nearestDist then
                    nearestDist = d
                    nearest = pl
                end
            end
        end
    end
    return nearest
end

local function safeFire(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local remote = getLaserRemote()
    local args = {
        [1] = targetHRP.Position,
        [2] = targetHRP
    }
    if remote and remote.FireServer then
        pcall(function()
            remote:FireServer(unpack(args))
        end)
    end
end

local function autoLaserWorker()
    while autoLaserEnabled do
        local target = findNearestAllowed()
        if target then
            safeFire(target)
        end
        local t0 = tick()
        while tick() - t0 < 0.6 do
            if not autoLaserEnabled then break end
            RunService.Heartbeat:Wait()
        end
    end
end

local function toggleAutoLaser(enabled)
    autoLaserEnabled = enabled
    
    if autoLaserEnabled then
        if autoLaserThread then
            task.cancel(autoLaserThread)
        end
        autoLaserThread = task.spawn(autoLaserWorker)
        print("✓ Laser Cape: ON")
    else
        if autoLaserThread then
            task.cancel(autoLaserThread)
            autoLaserThread = nil
        end
        print("✗ Laser Cape: OFF")
    end
end

-- ========================================
-- INFINITE JUMP + SLOW FALL SYSTEM
-- ========================================
local infJumpEnabled = false
local slowFallConnection = nil

local function toggleInfJump(enabled)
    infJumpEnabled = enabled
    
    if infJumpEnabled then
        if slowFallConnection then
            slowFallConnection:Disconnect()
        end
        
        slowFallConnection = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local velocity = humanoidRootPart.Velocity
                    if velocity.Y < 0 then
                        humanoidRootPart.Velocity = Vector3.new(velocity.X, velocity.Y * 0.2, velocity.Z)
                    end
                end
            end
        end)
        
        print("✓ Infinite Jump + Slow Fall: ON")
    else
        if slowFallConnection then
            slowFallConnection:Disconnect()
            slowFallConnection = nil
        end
        print("✗ Infinite Jump + Slow Fall: OFF")
    end
end

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- ========================================
-- DESYNC SYSTEM
-- ========================================
local desyncActive = false

local function enableMobileDesync()
    local success, error = pcall(function()
        local backpack = LocalPlayer:WaitForChild("Backpack")
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        local packages = ReplicatedStorage:WaitForChild("Packages", 5)
        if not packages then warn("❌ Packages não encontrado") return false end
        
        local netFolder = packages:WaitForChild("Net", 5)
        if not netFolder then warn("❌ Net folder não encontrado") return false end
        
        local useItemRemote = netFolder:WaitForChild("RE/UseItem", 5)
        local teleportRemote = netFolder:WaitForChild("RE/QuantumCloner/OnTeleport", 5)
        if not useItemRemote or not teleportRemote then warn("❌ Remotos não encontrados") return false end

        local toolNames = {"Quantum Cloner", "Brainrot", "brainrot"}
        local tool
        for _, toolName in ipairs(toolNames) do
            tool = backpack:FindFirstChild(toolName) or character:FindFirstChild(toolName)
            if tool then break end
        end
        if not tool then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then tool=item break end
            end
        end

        if tool and tool.Parent==backpack then
            humanoid:EquipTool(tool)
            task.wait(0.5)
        end

        if setfflag then setfflag("WorldStepMax", "-9999999999") end
        task.wait(0.2)
        useItemRemote:FireServer()
        task.wait(1)
        teleportRemote:FireServer()
        task.wait(2)
        if setfflag then setfflag("WorldStepMax", "-1") end
        print("✅ Mobile Desync ativado!")
        return true
    end)
    
    if not success then
        warn("❌ Erro ao ativar desync: " .. tostring(error))
        return false
    end
    return success
end

local function disableMobileDesync()
    pcall(function()
        if setfflag then setfflag("WorldStepMax", "-1") end
        print("❌ Mobile Desync desativado!")
    end)
end

-- ========================================
-- TWEEN TO BASE SYSTEM
-- ========================================
local function buyAndEquipSpeedCoil()
    local success, err = pcall(function()
        local remote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/CoinsShopService/RequestBuy")
        remote:InvokeServer("Speed Coil")
    end)
    
    if success then
        task.delay(0.5, function()
            local backpack = LocalPlayer:WaitForChild("Backpack", 5)
            local tool = backpack and backpack:FindFirstChild("Speed Coil")
            if tool then
                local char = LocalPlayer.Character
                if char then
                    tool.Parent = char
                    task.wait(0.25)
                    tool.Parent = backpack
                end
            end
        end)
    end
end

local function getBasePosition()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        local base = plot:FindFirstChild("DeliveryHitbox")
        if sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled and base then
            return base.Position
        end
    end
    return nil
end

local Y_OFFSET = 9
local STOP_DISTANCE = 5
local currentTween
local active = false
local walkThread

local function tweenWalkTo(position)
    if currentTween then currentTween:Cancel() end

    local startPos = hrp.Position
    local targetPos = Vector3.new(position.X, position.Y + Y_OFFSET, position.Z)
    local distance = (targetPos - startPos).Magnitude
    local speed = math.max(humanoid.WalkSpeed, 24)
    local duration = distance / speed
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)

    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    currentTween:Play()

    humanoid:ChangeState(Enum.HumanoidStateType.Running)

    currentTween.Completed:Wait()
end

local function isAtBase(basePos)
    if not basePos then return false end
    local dist = (hrp.Position - basePos).Magnitude
    return dist <= STOP_DISTANCE
end

local function walkToBase()
    while active do
        local target = getBasePosition()
        if not target then
            warn("Base Not Found")
            break
        end

        if isAtBase(target) then
            warn("Reached Base")
            stopTweenToBase()
            break
        end

        local path = PathfindingService:CreatePath()
        path:ComputeAsync(hrp.Position, target)

        if path.Status == Enum.PathStatus.Success then
            for _, waypoint in ipairs(path:GetWaypoints()) do
                if not active then return end
                if isAtBase(target) then
                    stopTweenToBase()
                    return
                end
                tweenWalkTo(waypoint.Position)
            end
        else
            tweenWalkTo(target)
        end

        task.wait(1.5)
    end
end

function startTweenToBase()
    if active then return end
    active = true
    humanoid.WalkSpeed = 24

    walkThread = task.spawn(function()
        while active do
            walkToBase()
            task.wait(1)
        end
    end)
end

function stopTweenToBase()
    if not active then return end
    active = false
    if currentTween then currentTween:Cancel() end
    if walkThread then task.cancel(walkThread) end
    humanoid.WalkSpeed = 24
end

buyAndEquipSpeedCoil()

-- ========================================
-- CREATE BUTTONS
-- ========================================

createButton("DESYNC", 1, function(isActive)
    if isActive then
        local success = enableMobileDesync()
        if success then
            desyncActive = true
            print("✓ Desync: ON")
        else
            desyncActive = false
            print("✗ Desync: FAILED")
        end
    else
        disableMobileDesync()
        desyncActive = false
        print("✗ Desync: OFF")
    end
end)

createButton("TWEEN TO BASE", 2, function(isActive)
    if isActive then
        startTweenToBase()
        print("✓ Tween to Base: ON")
    else
        stopTweenToBase()
        print("✗ Tween to Base: OFF")
    end
end)

createButton("INFINITE JUMP", 3, function(isActive)
    toggleInfJump(isActive)
end)

createButton("LASER CAPE", 4, function(isActive)
    toggleAutoLaser(isActive)
end)

createButton("FLOOR STEAL", 5, function(isActive)
    if isActive then
        enableFloorSteal()
    else
        disableFloorSteal()
    end
end)

-- NEW XRAY BASE BUTTON
createButton("XRAY BASE", 6, function(isActive)
    toggleXrayBase(isActive)
end)

print("╔═══════════════════════════════╗")
print("║   STEAL TOOLS LOADED          ║")
print("║   God Mode: AUTO ON           ║")
print("║   Drag to move                ║")
print("╚═══════════════════════════════╝")
