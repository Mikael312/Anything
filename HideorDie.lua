-- Hide or Die - Script Hub X by michel (Final Merged)
-- UI + Notif + Tabs + Close/Minimize + Cookie Button + ESP Players + Server Hop + Rejoin Server
-- Based on Steal a Plane UI with Hide or Die functions

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

--// Player refs (rebinding safe)
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
player.CharacterAdded:Connect(function(chr)
    character = chr
    humanoid = chr:WaitForChild("Humanoid")
    rootPart = chr:WaitForChild("HumanoidRootPart")
end)

--// Remotes for Hide or Die
local recv_role = ReplicatedStorage.Network.match.recv_role
local recv_seeker_queue_pos = ReplicatedStorage.Network.match.recv_seeker_queue_pos
local create_notif = ReplicatedStorage.Events.effects.create_notif

--// Utility ctor
local function new(class, props, parent)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k]=v end
    inst.Parent = parent
    return inst
end

--// ScreenGui
local screenGui = new("ScreenGui",{Name="HideOrDieHub",ResetOnSpawn=false,IgnoreGuiInset=false},player:WaitForChild("PlayerGui"))

--==================================================
-- Notification System (stacking, slide from right)
--==================================================
local NotifContainer = new("Frame",{
    Name="NotifContainer",
    Size=UDim2.new(0,300,0,400),
    Position=UDim2.new(1,-320,0,140),
    BackgroundTransparency=1,
    ZIndex=50
},screenGui)

local activeNotifs = {}
local function createNotification(text)
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Size = UDim2.new(0, 280, 0, 44)
    notif.Position = UDim2.new(1, 300, 0, (#activeNotifs * 54))
    notif.BackgroundColor3 = Color3.fromRGB(50,50,50)
    notif.BackgroundTransparency = 0.32
    notif.BorderSizePixel = 1
    notif.BorderColor3 = Color3.fromRGB(255,255,255)
    notif.ClipsDescendants = true
    notif.ZIndex = 51
    notif.Parent = NotifContainer
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0,8)

    local label = Instance.new("TextLabel", notif)  
    label.Size = UDim2.new(1, -10, 1, 0)  
    label.Position = UDim2.new(0, 8, 0, 0)  
    label.BackgroundTransparency = 1  
    label.Text = tostring(text)  
    label.Font = Enum.Font.GothamMedium  
    label.TextSize = 15  
    label.TextColor3 = Color3.fromRGB(255,255,255)  
    label.TextXAlignment = Enum.TextXAlignment.Left  
    label.TextYAlignment = Enum.TextYAlignment.Center  
    label.ZIndex = 52  

    table.insert(activeNotifs, notif)  

    TweenService:Create(notif, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {  
        Position = UDim2.new(0, 0, 0, (#activeNotifs - 1) * 54)  
    }):Play()  

    for i, old in ipairs(activeNotifs) do  
        if old ~= notif then  
            TweenService:Create(old, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {  
                Position = UDim2.new(0, 0, 0, (i - 1) * 54)  
            }):Play()  
        end  
    end  

    task.delay(4, function()  
        local idx = table.find(activeNotifs, notif)  
        if idx then  
            table.remove(activeNotifs, idx)  
            pcall(function()  
                TweenService:Create(notif, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {  
                    Position = UDim2.new(1, 300, 0, notif.Position.Y.Offset),  
                    BackgroundTransparency = 1  
                }):Play()  
                task.wait(0.28)  
            end)  
            if notif then notif:Destroy() end  
            for i, old in ipairs(activeNotifs) do  
                TweenService:Create(old, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {  
                    Position = UDim2.new(0, 0, 0, (i - 1) * 54)  
                }):Play()  
            end  
        end  
    end)
end

--==================================================
-- Main Frame + Header
--==================================================
local mainFrame = new("Frame",{
    AnchorPoint=Vector2.new(0.5,0.5),
    Position=UDim2.new(0.5,0,0.5,0),
    Size=UDim2.new(0,12,0,12),
    BackgroundColor3=Color3.fromRGB(20,20,22),
    BorderSizePixel=0,
    Visible=true
},screenGui)
new("UICorner",{CornerRadius=UDim.new(0,12)},mainFrame)
new("UIStroke",{Thickness=1.2,Color=Color3.fromRGB(60,60,65)},mainFrame)

TweenService:Create(mainFrame,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    Size=UDim2.new(0,500,0,460)
}):Play()

task.spawn(function()
    task.wait(0.8)
    createNotification("Interface loaded successfully")
    task.wait(1.2)
    createNotification("Stay updated, join us on Discord!")
end)

-- Header
local header = new("Frame",{Size=UDim2.new(1,0,0,44),BackgroundTransparency=1},mainFrame)
new("TextLabel",{
    Text="Hide or Die",
    Font=Enum.Font.GothamBold,TextSize=17,
    TextColor3=Color3.fromRGB(255,255,255),
    BackgroundTransparency=1,
    Position=UDim2.new(0,12,0,4),Size=UDim2.new(0.6,0,0.5,0),
    TextXAlignment=Enum.TextXAlignment.Left,
},header)

new("TextLabel",{
    Text="Script Hub X",
    Font=Enum.Font.Gotham,TextSize=13,
    TextColor3=Color3.fromRGB(180,180,185),
    BackgroundTransparency=1,
    Position=UDim2.new(0,12,0.5,-2),Size=UDim2.new(0.6,0,0.5,0),
    TextXAlignment=Enum.TextXAlignment.Left,
},header)

-- Close & Minimize
local closeBtn = new("TextButton",{
    Text="X",Size=UDim2.new(0,32,0,32),Position=UDim2.new(1,-36,0,6),
    BackgroundColor3=Color3.fromRGB(200,50,60),
    Font=Enum.Font.GothamBold,TextSize=16,TextColor3=Color3.new(1,1,1)
},header)
new("UICorner",{CornerRadius=UDim.new(0,8)},closeBtn)

local miniBtn = new("TextButton",{
    Text="-",Size=UDim2.new(0,32,0,32),Position=UDim2.new(1,-72,0,6),
    BackgroundColor3=Color3.fromRGB(90,90,95),
    Font=Enum.Font.GothamBold,TextSize=18,TextColor3=Color3.new(1,1,1)
},header)
new("UICorner",{CornerRadius=UDim.new(0,8)},miniBtn)

-- Cookie Button (toggle UI on/off)
local CookieBtn = Instance.new("ImageButton")
CookieBtn.Size = UDim2.new(0, 40, 0, 40)
CookieBtn.Position = UDim2.new(0.05, 0, 0.75, 0) -- kiri bawah
CookieBtn.BackgroundTransparency = 1
CookieBtn.Image = "rbxassetid://116538605820317" -- cookie image
CookieBtn.Visible = false
CookieBtn.AutoButtonColor = true
CookieBtn.Parent = screenGui

-- Safety: jika UI hidden oleh hal lain, kekalkan cookie visible
local function showCookie()
    CookieBtn.Visible = true
end
local function hideCookie()
    CookieBtn.Visible = false
end

CookieBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    hideCookie()
end)

miniBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    showCookie()
end)

closeBtn.MouseButton1Click:Connect(function()
    -- Kalau betul-betul nak tutup semua
    pcall(function()
        screenGui:Destroy()
    end)
end)

--==================================================
-- Tabs (Main / Credit)
--==================================================
local tabFrame = new("Frame",{
    Size = UDim2.new(1,0,0,32),
    Position = UDim2.new(0,0,0,46),
    BackgroundTransparency=1
},mainFrame)

local underline = new("Frame",{
    Size=UDim2.new(0,60,0,2),
    Position=UDim2.new(0,12,1,0),
    BackgroundColor3=Color3.fromRGB(255,255,255),
    BorderSizePixel=0
},tabFrame)

local tabs = {}
local function createTab(name, order)
    local btn = new("TextButton",{
        Text = name,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(220,220,220),
        BackgroundTransparency=1,
        Size=UDim2.new(0,80,1,0),
        Position=UDim2.new(0,(order-1)*90+10,0,0)
    },tabFrame)
    tabs[name]=btn
    return btn
end

local mainTabBtn   = createTab("Main",1)
local creditTabBtn = createTab("Credit",2)

-- Containers
local mainContainer = new("ScrollingFrame",{
    Size=UDim2.new(1,-20,1,-90),
    Position=UDim2.new(0,10,0,80),
    BackgroundTransparency=1,
    CanvasSize=UDim2.new(0,0,0,0),
    ScrollBarThickness=6
},mainFrame)
local layout = new("UIListLayout",{Padding=UDim.new(0,10),FillDirection=Enum.FillDirection.Vertical},mainContainer)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    mainContainer.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
end)

local creditContainer = new("Frame",{
    Size=UDim2.new(1,-20,1,-90),
    Position=UDim2.new(0,10,0,80),
    BackgroundTransparency=1,
    Visible=false
},mainFrame)

-- Credit tab UI
new("TextLabel",{
    Text="Made by michel",
    Font=Enum.Font.GothamMedium,TextSize=16,
    TextColor3 = Color3.new(1,1,1),
    BackgroundTransparency=1,
    Size=UDim2.new(1,0,0,24),
    Position=UDim2.new(0,0,0,0)
},creditContainer)

new("ImageLabel",{
    Image="rbxassetid://113520323335055", -- discord icon/logo (ikut ID yang diberi)
    Size=UDim2.new(0,40,0,40),
    Position=UDim2.new(0,10,0,40),
    BackgroundTransparency=1
},creditContainer)

local inviteText = new("TextLabel",{
    Text="Join our community on Discord for updates, scripts & support!",
    Font=Enum.Font.Gotham,TextSize=14,
    TextColor3=Color3.fromRGB(230,230,230),
    BackgroundTransparency=1,
    Size=UDim2.new(1,-70,0,40),
    Position=UDim2.new(0,60,0,42),
    TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextYAlignment=Enum.TextYAlignment.Center
},creditContainer)

local joinBtn = new("TextButton",{
    Text="Join Discord",
    Size=UDim2.new(0,180,0,36),
    Position=UDim2.new(0,10,0,90),
    BackgroundColor3=Color3.fromRGB(36,140,110),
    Font=Enum.Font.GothamBold,TextSize=15,TextColor3=Color3.fromRGB(255,255,255)
},creditContainer)
new("UICorner",{CornerRadius=UDim.new(0,8)},joinBtn)
joinBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://discord.gg/R28RMNSQ") end)
    StarterGui:SetCore("SendNotification", {
        Title = "Discord",
        Text = "Link copied to clipboard!",
        Duration = 3
    })
end)

-- Tab switching
local function switchTab(name)
    if name=="Main" then
        mainContainer.Visible=true
        creditContainer.Visible=false
        TweenService:Create(underline,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
            Position=UDim2.new(0,12,1,0),
            Size=UDim2.new(0,60,0,2)
        }):Play()
    elseif name=="Credit" then
        mainContainer.Visible=false
        creditContainer.Visible=true
        TweenService:Create(underline,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
            Position=UDim2.new(0,102,1,0),
            Size=UDim2.new(0,80,0,2)
        }):Play()
    end
end
mainTabBtn.MouseButton1Click:Connect(function() switchTab("Main") end)
creditTabBtn.MouseButton1Click:Connect(function() switchTab("Credit") end)
switchTab("Main")

--==================================================
-- Section Headers
--==================================================
local function createSectionHeader(name)
    local header = new("Frame",{Size=UDim2.new(1,0,0,30),BackgroundColor3=Color3.fromRGB(40,40,45)},mainContainer)
    new("UICorner",{CornerRadius=UDim.new(0,6)},header)
    new("TextLabel",{Text=name,Font=Enum.Font.GothamBold,TextSize=16,
        BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),
        Position=UDim2.new(0,10,0,0),Size=UDim2.new(1,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Left},header)
    return header
end

--==================================================
-- Toggle Template (parent: mainContainer)
--==================================================
local function createToggle(name, callback)
    local frame = new("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=Color3.fromRGB(30,30,35)},mainContainer)
    new("UICorner",{CornerRadius=UDim.new(0,8)},frame)
    new("TextLabel",{Text=name,Font=Enum.Font.Gotham,TextSize=15,
        BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),
        Position=UDim2.new(0,10,0,0),Size=UDim2.new(0.7,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Left},frame)
    local btn = new("TextButton",{Text="OFF",Size=UDim2.new(0,60,1,0),Position=UDim2.new(1,-70,0,0),
        BackgroundColor3=Color3.fromRGB(100,100,105),
        Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Color3.new(1,1,1)},frame)
    new("UICorner",{CornerRadius=UDim.new(0,6)},btn)
    local state=false
    btn.MouseButton1Click:Connect(function()
        state=not state
        btn.Text= state and "ON" or "OFF"
        btn.BackgroundColor3= state and Color3.fromRGB(36,140,110) or Color3.fromRGB(100,100,105)
        callback(state,frame)
    end)
    return frame
end

--==================================================
-- Button Template (parent: mainContainer)
--==================================================
local function createButton(name, callback)
    local frame = new("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=Color3.fromRGB(30,30,35)},mainContainer)
    new("UICorner",{CornerRadius=UDim.new(0,8)},frame)
    local btn = new("TextButton",{Text=name,Font=Enum.Font.GothamBold,TextSize=15,
        BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),
        Position=UDim2.new(0,10,0,0),Size=UDim2.new(1,-20,1,0),
        TextXAlignment=Enum.TextXAlignment.Center},frame)
    btn.MouseButton1Click:Connect(callback)
    return frame
end

--==================================================
-- SECTIONS AND TOGGLES
--==================================================

-- Server Hop Section
createSectionHeader("Server")

-- Server Hop Button
createButton("Server Hop", function()
    TeleportService:Teleport(game.PlaceId, player)
    createNotification("Hopping to a new server...")
end)

-- Rejoin Server Button
createButton("Rejoin Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    createNotification("Rejoining current server...")
end)

-- Seeker Section
createSectionHeader("Seeker")

-- Auto Catch
local autoCatchEnabled=false
local function getAliveHiders()
    local hiders = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and
           p.Character.Humanoid.Health > 0 then
            -- Check if player is a hider by looking for a hider tag or checking team
            local isHider = false
            if p.Character:FindFirstChild("IsHider") then
                isHider = true
            elseif p.Team and p.Team.Name == "Hider" then
                isHider = true
            end
            
            if isHider then
                table.insert(hiders, p)
            end
        end
    end
    return hiders
end

local function autoCatch()
    if not autoCatchEnabled then return end
    
    local hiders = getAliveHiders()
    if #hiders == 0 then return end
    
    -- Find nearest hider
    local nearestHider = nil
    local minDistance = math.huge
    
    for _, hider in pairs(hiders) do
        if hider.Character and hider.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (rootPart.Position - hider.Character.HumanoidRootPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                nearestHider = hider
            end
        end
    end
    
    if nearestHider and nearestHider.Character and nearestHider.Character:FindFirstChild("HumanoidRootPart") then
        -- Teleport to hider with improved precision
        local targetCFrame = nearestHider.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        rootPart.CFrame = targetCFrame
        
        -- Wait for hider to die or move away
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not nearestHider.Character or not nearestHider.Character:FindFirstChild("Humanoid") or 
               nearestHider.Character.Humanoid.Health <= 0 then
                connection:Disconnect()
                -- Wait a moment before finding next hider
                task.wait(0.5)
                autoCatch() -- Move to next hider
            elseif (rootPart.Position - nearestHider.Character.HumanoidRootPart.Position).Magnitude > 20 then
                connection:Disconnect()
                -- Wait a moment before finding next hider
                task.wait(0.5)
                autoCatch() -- Hider escaped, find new target
            end
        end)
    end
end

createToggle("Auto Catch", function(v)
    autoCatchEnabled = v
    if v then
        autoCatch()
    end
end)

-- Auto Aim
local autoAimEnabled=false
local function autoAim()
    if not autoAimEnabled then return end
    
    local hiders = getAliveHiders()
    if #hiders == 0 then return end
    
    -- Find nearest hider
    local nearestHider = nil
    local minDistance = math.huge
    
    for _, hider in pairs(hiders) do
        if hider.Character and hider.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (rootPart.Position - hider.Character.HumanoidRootPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                nearestHider = hider
            end
        end
    end
    
    if nearestHider and nearestHider.Character and nearestHider.Character:FindFirstChild("Head") then
        -- Aim at hider's head
        local targetPos = nearestHider.Character.Head.Position
        
        -- Calculate the direction to the target
        local direction = (targetPos - rootPart.Position).Unit
        
        -- Set the CFrame to look at the target
        rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + direction)
        
        -- Also adjust camera to aim at the target
        Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetPos)
    end
end

createToggle("Auto Aim", function(v)
    autoAimEnabled = v
end)

-- ESP Hider
local espHiderEnabled=false
local espObjects = {}

local function createEsp(target, color)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.Parent = target
    highlight.Adornee = target
    
    local billboard = Instance.new("BillboardGui")  
    billboard.Size = UDim2.new(0, 100, 0, 50)  
    billboard.StudsOffset = Vector3.new(0, 2, 0)  
    billboard.AlwaysOnTop = true  
    billboard.Parent = target  
    
    local label = Instance.new("TextLabel")  
    label.Size = UDim2.new(1, 0, 1, 0)  
    label.Text = target.Name  
    label.TextColor3 = color  
    label.TextScaled = true  
    label.BackgroundTransparency = 1  
    label.Parent = billboard  
    
    return highlight, billboard
end

local function removeEsp(target)
    if espObjects[target] then
        for _, obj in pairs(espObjects[target]) do
            obj:Destroy()
        end
        espObjects[target] = nil
    end
end

local function updateESP()
    -- Update ESP for hiders
    if espHiderEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                -- Check if player is a hider
                local isHider = false
                if p.Character:FindFirstChild("IsHider") then
                    isHider = true
                elseif p.Team and p.Team.Name == "Hider" then
                    isHider = true
                end
                
                if isHider and not espObjects[p.Character] then
                    espObjects[p.Character] = {createEsp(p.Character, Color3.fromRGB(255, 0, 0))}
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                -- Check if player is a hider
                local isHider = false
                if p.Character:FindFirstChild("IsHider") then
                    isHider = true
                elseif p.Team and p.Team.Name == "Hider" then
                    isHider = true
                end
                
                if isHider then
                    removeEsp(p.Character)
                end
            end
        end
    end
    
    -- Update ESP for seekers
    if espSeekerEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                -- Check if player is a seeker
                local isSeeker = false
                if p.Character:FindFirstChild("IsSeeker") then
                    isSeeker = true
                elseif p.Team and p.Team.Name == "Seeker" then
                    isSeeker = true
                end
                
                if isSeeker and not espObjects[p.Character] then
                    espObjects[p.Character] = {createEsp(p.Character, Color3.fromRGB(0, 0, 255))}
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                -- Check if player is a seeker
                local isSeeker = false
                if p.Character:FindFirstChild("IsSeeker") then
                    isSeeker = true
                elseif p.Team and p.Team.Name == "Seeker" then
                    isSeeker = true
                end
                
                if isSeeker then
                    removeEsp(p.Character)
                end
            end
        end
    end
end

createToggle("ESP Hider", function(v)
    espHiderEnabled = v
    updateESP()
end)

-- Hider Section
createSectionHeader("Hider")

-- Auto Dodge
local autoDodgeEnabled=false
local function getAliveSeekers()
    local seekers = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and
           p.Character.Humanoid.Health > 0 then
            -- Check if player is a seeker by looking for a seeker tag or checking team
            local isSeeker = false
            if p.Character:FindFirstChild("IsSeeker") then
                isSeeker = true
            elseif p.Team and p.Team.Name == "Seeker" then
                isSeeker = true
            end
            
            if isSeeker then
                table.insert(seekers, p)
            end
        end
    end
    return seekers
end

local function isPositionSafe(position)
    local seekers = getAliveSeekers()
    for _, seeker in pairs(seekers) do
        if seeker.Character and seeker.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (position - seeker.Character.HumanoidRootPart.Position).Magnitude
            if distance < 30 then -- Safe distance threshold
                return false
            end
        end
    end
    return true
end

local function hasFloor(position)
    -- Raycast downward to check for floor
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character}
    
    local result = Workspace:Raycast(position, Vector3.new(0, -10, 0), raycastParams)  
    return result ~= nil
end

local function findSafePosition()
    local attempts = 0
    local maxAttempts = 20
    
    while attempts < maxAttempts do  
        -- Generate random position around current location  
        local randomOffset = Vector3.new(  
            math.random(-50, 50),  
            0,  
            math.random(-50, 50)  
        )  
        local testPosition = rootPart.Position + randomOffset  
          
        -- Check if position is safe and has floor  
        if isPositionSafe(testPosition) and hasFloor(testPosition) then  
            return testPosition  
        end  
          
        attempts = attempts + 1  
        task.wait(0.1)  
    end  
  
    -- If no safe position found, return current position  
    return rootPart.Position
end

local function autoDodge()
    if not autoDodgeEnabled then return end
    
    -- Check if any seeker is aiming at player  
    local seekers = getAliveSeekers()  
    for _, seeker in pairs(seekers) do  
        if seeker.Character and seeker.Character:FindFirstChild("HumanoidRootPart") then  
            local seekerPos = seeker.Character.HumanoidRootPart.Position  
            local direction = (rootPart.Position - seekerPos).Unit  
              
            -- Check if seeker is looking at player (simplified)  
            if seeker.Character:FindFirstChild("Humanoid") then  
                local lookVector = seeker.Character.HumanoidRootPart.CFrame.LookVector  
                local dotProduct = lookVector:Dot(direction)  
              
                -- If seeker is looking towards player (dot product > 0.7 means roughly within 45 degrees)  
                if dotProduct > 0.7 then  
                    -- Find safe position and teleport  
                    local safePos = findSafePosition()  
                    if safePos then  
                        rootPart.CFrame = CFrame.new(safePos)  
                          
                        -- Wait a moment before checking again  
                        task.wait(1)  
                    end  
                end  
            end  
        end  
    end
end

createToggle("Auto Dodge", function(v)
    autoDodgeEnabled = v
end)

-- ESP Seeker
local espSeekerEnabled=false

createToggle("ESP Seeker", function(v)
    espSeekerEnabled = v
    updateESP()
end)

-- Auto Walk
local autoWalkEnabled=false
local function autoWalk()
    if not autoWalkEnabled then return end
    
    -- Move forward to gain studs  
    humanoid:Move(Vector3.new(0, 0, -1))  
    
    -- Randomly change direction occasionally  
    if math.random() < 0.01 then  
        humanoid:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)))  
    end
end

createToggle("Auto Walk (MVP)", function(v)
    autoWalkEnabled = v
end)

-- Void Protection
local voidProtectionEnabled=true

createToggle("Void Protection", function(v)
    voidProtectionEnabled = v
end)

--==================================================
-- MAIN LOOP
--==================================================
RunService.Heartbeat:Connect(function()
    -- Update ESP
    updateESP()
    
    -- Role-based features  
    local playerRole = nil  
    
    -- Check player role  
    if character:FindFirstChild("IsSeeker") then  
        playerRole = "Seeker"  
    elseif character:FindFirstChild("IsHider") then  
        playerRole = "Hider"  
    elseif player.Team then  
        if player.Team.Name == "Seeker" then  
            playerRole = "Seeker"  
        elseif player.Team.Name == "Hider" then  
            playerRole = "Hider"  
        end  
    end  
    
    if playerRole == "Seeker" then  
        autoCatch()  
        autoAim()  
    elseif playerRole == "Hider" then  
        autoDodge()  
        autoWalk()  
        
        -- Check if void protection is enabled and we're near a void  
        if voidProtectionEnabled then  
            -- Check if there's floor below  
            if not hasFloor(rootPart.Position + Vector3.new(0, -5, 0)) then  
                -- Turn around to avoid void  
                humanoid:Move(Vector3.new(0, 0, 1))  
            end  
        end  
    end
end)

--==================================================
-- Smooth Dragging (header area)
--==================================================
local dragging,dragInput,dragStart,startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true;dragStart=input.Position;startPos=mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
        dragInput=input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input==dragInput and dragging then
        local delta=input.Position-dragStart
        local newPos=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        TweenService:Create(mainFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos}):Play()
    end
end)

--==================================================
-- Optional: Draggable Cookie (kecil & snap)
--==================================================
do
    local c_drag=false; local c_dragStart; local c_startPos
    CookieBtn.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            c_drag=true; c_dragStart=input.Position; c_startPos=CookieBtn.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then c_drag=false end end)
        end
    end)
    CookieBtn.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            dragInput=input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input==dragInput and c_drag then
            local delta=input.Position - c_dragStart
            local newPos=UDim2.new(c_startPos.X.Scale, c_startPos.X.Offset+delta.X, c_startPos.Y.Scale, c_startPos.Y.Offset+delta.Y)
            CookieBtn.Position = newPos
        end
    end)
end

--==================================================
-- End
--==================================================
