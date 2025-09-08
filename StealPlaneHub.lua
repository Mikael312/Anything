-- Steal a Plane - Script Hub X by michel (Merged Full)
-- UI + Notif + Tabs (base from Coding 1)
-- Added: Close/Minimize + Cookie Button, ESP Players, Random Instant Steal, Instant Steal (hook)

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

--// Player refs
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

--// Remotes
local RFAskLock   = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/AskLock"]
local RECollect   = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/Collect"]
local RFStealPlane= ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/StealPlane"]

--// Utility ctor
local function new(class, props, parent)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k]=v end
    inst.Parent = parent
    return inst
end

--// ScreenGui
local screenGui = new("ScreenGui",{Name="StealPlaneHub",ResetOnSpawn=false},player:WaitForChild("PlayerGui"))

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
    label.Text = text
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
            notif:Destroy()
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
},screenGui)
new("UICorner",{CornerRadius=UDim.new(0,12)},mainFrame)
new("UIStroke",{Thickness=1.2,Color=Color3.fromRGB(60,60,65)},mainFrame)

TweenService:Create(mainFrame,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    Size=UDim2.new(0,500,0,460)
}):Play()

-- Auto notif
task.spawn(function()
    task.wait(0.8)
    createNotification("Interface loaded successfully")
    task.wait(1.2)
    createNotification("Stay updated, join us on Discord!")
end)

-- Header
local header = new("Frame",{Size=UDim2.new(1,0,0,44),BackgroundTransparency=1},mainFrame)
new("TextLabel",{
    Text="Steal a Plane",Font=Enum.Font.GothamBold,TextSize=17,
    TextColor3=Color3.fromRGB(255,255,255),
    BackgroundTransparency=1,
    Position=UDim2.new(0,12,0,4),Size=UDim2.new(0.6,0,0.5,0),
    TextXAlignment=Enum.TextXAlignment.Left,
},header)

new("TextLabel",{
    Text="Script hub X by michel",Font=Enum.Font.Gotham,TextSize=13,
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
CookieBtn.Size = UDim2.new(0, 36, 0, 36)
CookieBtn.Position = UDim2.new(0, 20, 0.5, -18)
CookieBtn.BackgroundTransparency = 1
CookieBtn.Image = "rbxassetid://116538605820317" -- 🍪 cookie image
CookieBtn.Visible = false
CookieBtn.Parent = screenGui

CookieBtn.MouseButton1Click:Connect(function()
    CookieBtn.Visible = false
    mainFrame.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    CookieBtn.Visible = true
end)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

--==================================================
-- Tabs (Main / Credit) + underline
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
    Image="rbxassetid://80076712708225", -- 💬 Discord logo
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
    setclipboard("https://discord.gg/R28RMNSQ")
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
-- TOGGLES: From Coding 1 (Noclip, InfJump, Speed, AutoLock, AutoCollect)
--==================================================

-- Noclip
local noclipConn
local function setNoclip(enabled)
    if enabled then
        noclipConn=RunService.Stepped:Connect(function()
            for _,v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide=false
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
        for _,v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=true end
        end
    end
end
createToggle("Noclip",function(v) setNoclip(v) end)

-- Infinite Jump
local infJump=false
UserInputService.JumpRequest:Connect(function()
    if infJump and humanoid then humanoid:ChangeState("Jumping") end
end)
createToggle("Infinite Jump",function(v) infJump=v end)

-- Speed
local normalSpeed=humanoid.WalkSpeed
local fastSpeed=60
createToggle("Speed",function(v,frame)
    if not frame:FindFirstChild("SpeedBox") then
        local box=new("TextBox",{
            Name="SpeedBox",Size=UDim2.new(0,60,1,0),
            Position=UDim2.new(1,-140,0,0),
            BackgroundColor3=Color3.fromRGB(50,50,55),
            Text=tostring(fastSpeed),
            Font=Enum.Font.Gotham,TextSize=14,
            TextColor3=Color3.new(1,1,1),
            ClearTextOnFocus=false
        },frame)
        new("UICorner",{CornerRadius=UDim.new(0,6)},box)
        box.FocusLost:Connect(function()
            local val=tonumber(box.Text)
            if val and val>0 then fastSpeed=val end
            if v then humanoid.WalkSpeed=fastSpeed end
        end)
    end
    humanoid.WalkSpeed= v and fastSpeed or normalSpeed
end)

-- Auto Lock
local autoLockEnabled=false
local function setAutoLock(enabled)
    autoLockEnabled=enabled
    if enabled then
        task.spawn(function()
            while autoLockEnabled do
                pcall(function() RFAskLock:InvokeServer() end)
                task.wait(2)
            end
        end)
    end
end
createToggle("Auto Lock",function(v) setAutoLock(v) end)

-- Auto Collect (Slot1 - Slot40)
local autoCollectEnabled=false
local function setAutoCollect(enabled)
    autoCollectEnabled=enabled
    if enabled then
        task.spawn(function()
            while autoCollectEnabled do
                pcall(function()
                    for i=1,40 do
                        RECollect:FireServer("Slot"..i)
                    end
                end)
                task.wait(2)
            end
        end)
    end
end
createToggle("Auto Collect",function(v) setAutoCollect(v) end)

--==================================================
-- EXTRA FEATURES from Coding 2
--==================================================

-- ESP Players
local function highlight(obj,color)
    local hl=Instance.new("Highlight")
    hl.FillTransparency=1
    hl.OutlineColor=color
    hl.Parent=obj
end
local espConnAdded, espConnChar
local function setESP(enabled)
    if enabled then
        -- existing players
        for _,plr in pairs(Players:GetPlayers()) do
            if plr~=player and plr.Character then
                highlight(plr.Character,Color3.fromRGB(0,255,0))
            end
        end
        -- future players
        espConnAdded = Players.PlayerAdded:Connect(function(plr)
            espConnChar = plr.CharacterAdded:Connect(function(char)
                highlight(char,Color3.fromRGB(0,255,0))
            end)
        end)
    else
        if espConnAdded then pcall(function() espConnAdded:Disconnect() end) end
        if espConnChar  then pcall(function() espConnChar:Disconnect()  end) end
        for _,h in pairs(Workspace:GetDescendants()) do
            if h:IsA("Highlight") then h:Destroy() end
        end
    end
end
createToggle("ESP Players",function(v) setESP(v) end)

-- Random Instant Steal
local function getTargetBases()
    local bases = {}
    local basesFolder = Workspace:FindFirstChild("Bases")
    if not basesFolder then return bases end
    for _, base in ipairs(basesFolder:GetChildren()) do
        if base.Name ~= player.Name then
            table.insert(bases, base)
        end
    end
    return bases
end

local function getPlanesFromBase(baseFolder)
    local planes = {}
    if not baseFolder then return planes end
    local planesFolder = baseFolder:FindFirstChild("Planes") or baseFolder:FindFirstChild("vehicles")
    if planesFolder then
        for _, plane in ipairs(planesFolder:GetChildren()) do
            if plane:IsA("Model") or plane:IsA("Part") then
                table.insert(planes, plane)
            end
        end
    end
    return planes
end

local function stealRandomPlane()
    local targets = getTargetBases()
    if #targets == 0 then return end
    local randomBase = targets[math.random(1, #targets)]
    local planes = getPlanesFromBase(randomBase)
    if #planes == 0 then return end
    local targetPlane = planes[math.random(1, #planes)]
    pcall(function()
        RFStealPlane:InvokeServer(targetPlane)
        createNotification(("Random steal attempted: %s/%s"):format(randomBase.Name, targetPlane.Name or "Plane"))
    end)
end

local randomStealEnabled=false
local function setRandomSteal(enabled)
    randomStealEnabled=enabled
    if enabled then
        task.spawn(function()
            while randomStealEnabled do
                stealRandomPlane()
                task.wait(math.random(3,6))
            end
        end)
    end
end
createToggle("Random Instant Steal",function(v) setRandomSteal(v) end)

-- Instant Steal (hook RFStealPlane -> teleport to CollectZone)
local instantStealEnabled = false
createToggle("Instant Steal", function(state)
    instantStealEnabled = state
end)

local function getMyCollectZone()
    local bases = Workspace:FindFirstChild("Bases")
    if not bases then return nil end
    local myBase = bases:FindFirstChild(player.Name)
    if not myBase then return nil end
    local decor = myBase:FindFirstChild("Decors")
    if not decor then return nil end
    local rest = decor:FindFirstChild("Rest")
    if not rest then return nil end
    return rest:FindFirstChild("CollectZone")
end

local function teleportToCollectZone()
    local zone = getMyCollectZone()
    if not zone then return end
    pcall(function()
        local oldCFrame = rootPart.CFrame
        rootPart.CFrame = zone.CFrame + Vector3.new(0, 5, 0)
        task.wait(1.5)
        rootPart.CFrame = oldCFrame
    end)
end

-- namecall hook (protected with pcall; only if exploit env provides)
do
    local ok, mt = pcall(function() return getrawmetatable(game) end)
    if ok and mt then
        local old = mt.__namecall
        pcall(function() setreadonly(mt, false) end)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod and getnamecallmethod() or nil
            local args = {...}
            if instantStealEnabled and self == RFStealPlane and method == "InvokeServer" then
                -- after server accepts steal, hop to CollectZone briefly
                task.delay(0.1, function()
                    pcall(teleportToCollectZone)
                end)
            end
            return old(self, unpack(args))
        end)
        pcall(function() setreadonly(mt, true) end)
    else
        createNotification("Executor doesn't support metatable hook; Instant Steal hook disabled.")
    end
end

--==================================================
-- Dragging (header area)
--==================================================
local dragging,dragInput,dragStart,startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true;dragStart=input.Position;startPos=mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input==dragInput and dragging then
        local delta=input.Position-dragStart
        mainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)