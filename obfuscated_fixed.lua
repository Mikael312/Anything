-- ================================
-- Scripts Hub X | Official
-- ================================

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")


-- =============================
-- Safe HTTP Request Wrapper (Delta Fix)
-- =============================
local function SafeRequest(options)
    if request then
        return request(options)
    elseif http_request then
        return http_request(options)
    elseif syn and syn.request then
        return syn.request(options)
    else
        warn("⚠️ No request function found in this executor")
        return nil
    end
end


local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

-- UserIds
local OwnerUserId = "2341777244"
local PremiumUsers = {
		"1102633570", -- Pedrojay450 [PERM]
		"8860068952", -- Pedrojay450's alt (assaltanoobsbr) [PERM]
		"799427028", -- Roblox_xvt [PERM]
		"5317421108", -- kolwneje [PERM]
		"1458719572", -- wxckfeen [PERM]
		"8558295467", -- Jerdxbackup [TRIAL]
		"8931026465" -- genderwillnottell [PERM]
	}
local StaffUserId = {
	"3882788546", -- Keanjacob5
    "799427028", -- Roblox_xvt
	"9249886989", -- ALT
	"2726723958" -- mhicel235TOH
}
local BlacklistUsers = {
		"716599904", -- ImRottingInHell [PERM]
		"229691" -- ravyn [PERM]
	}

local KeySystem = true

local TARGET_ANIMATRONICS = {"Radioactive Foxy", "Freddles", "Eclipse"}
local MAX_PLOTS = 8
local MAX_PADS = 27
local STEAL_A_FREDDY_PLACE_ID = 137167142636546

local HIGHLIGHT_COLORS = {
    ["Radioactive Foxy"] = Color3.fromRGB(0, 255, 0),
    ["Freddles"] = Color3.fromRGB(139, 69, 19),
    ["Eclipse"] = Color3.fromRGB(0, 0, 0)
}

local TPS = TeleportService
local Api = "https://games.roblox.com/v1/games/"
local _place, _id = game.PlaceId, game.JobId
local _servers = Api.._place.."/servers/Public?sortOrder=Desc&limit=100"

local webhookUrl = "https://discord.com/api/webhooks/1396650841045209169/Mx_0dcjOVnzp5f5zMhYM2uOBCPGt9SPr908shfLh_FGKZJ5eFc4tMsiiNNp1CGDx_M21"

local keyFileName = "Scripts Hub X OFFICIAL - Key.txt"

local highlightUpdateConnection = nil
local tracerUpdateConnection = nil
local characterRespawnConnection = nil

if game.PlaceId == STEAL_A_FREDDY_PLACE_ID then
    if not _G.AnimatronicsFinder then
        _G.AnimatronicsFinder = {
            enabled = true,
            originalServer = _id,
            executionCount = 0,
            isRunning = false,
            foundAnimatronic = nil,
            scriptLoaded = false,
            highlightedObjects = {},
            tracers = {}
        }
        print("🆕 FIRST RUN: Initializing animatronics finder for Steal a Freddy")
    else
        _G.AnimatronicsFinder.executionCount = _G.AnimatronicsFinder.executionCount + 1
        print("🔄 AUTO-EXECUTE #" .. _G.AnimatronicsFinder.executionCount .. ": Server " .. _id)
    end
end

-- ================================
-- UTILITY FUNCTIONS
-- ================================

local function ListServers(cursor)
    local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
    return HttpService:JSONDecode(Raw)
end

local function notify(title, text)
    spawn(function()
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
        end)
    end)
end

local function findPlayerPlot()
    local workspace = game:GetService("Workspace")
    local plotsFolder = workspace:FindFirstChild("Plots")
    
    if not plotsFolder then
        print("Plots folder not found!")
        return nil
    end
    
    local plotValue = player:FindFirstChild("Plot")
    if not plotValue then
        print("Plot value not found in player!")
        return nil
    end
    
    local plotNumber = plotValue.Value
    print("Looking for plot " .. tostring(plotNumber) .. "...")
    
    local targetPlot = plotsFolder:FindFirstChild(tostring(plotNumber))
    if targetPlot then
        print("Found your plot: " .. tostring(plotNumber))
        return targetPlot, plotNumber
    else
        print("Plot " .. tostring(plotNumber) .. " not found!")
        return nil, plotNumber
    end
end

-- ================================
-- HIGHLIGHTING AND TRACERS FUNCTIONS
-- ================================

local function highlightAnimatronic(animatronicModel, animatronicName)
    if not animatronicModel or not animatronicModel:IsA("Model") then
        return nil
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "AnimatronicHighlight_" .. animatronicName
    highlight.Adornee = animatronicModel

    local color = HIGHLIGHT_COLORS[animatronicName] or HIGHLIGHT_COLORS["Default"]
    highlight.OutlineColor = color

    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0.4
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    highlight.Parent = CoreGui

    return highlight
end

local function updateTracers()
    if not _G.AnimatronicsFinder or not _G.AnimatronicsFinder.tracers then
        return
    end
    
    for i = #_G.AnimatronicsFinder.tracers, 1, -1 do
        local tracerData = _G.AnimatronicsFinder.tracers[i]
        if tracerData and tracerData.beam and tracerData.beam.Parent and tracerData.animatronicModel and tracerData.animatronicModel.Parent then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if tracerData.startAttachment and tracerData.startAttachment.Parent ~= player.Character.HumanoidRootPart then
                    tracerData.startAttachment.Parent = player.Character.HumanoidRootPart
                end
            else
                table.remove(_G.AnimatronicsFinder.tracers, i)
                if tracerData.beam then tracerData.beam:Destroy() end
                if tracerData.startAttachment then tracerData.startAttachment:Destroy() end
                if tracerData.endAttachment then tracerData.endAttachment:Destroy() end
            end
        else
            table.remove(_G.AnimatronicsFinder.tracers, i)
            if tracerData then
                if tracerData.beam then tracerData.beam:Destroy() end
                if tracerData.startAttachment then tracerData.startAttachment:Destroy() end
                if tracerData.endAttachment then tracerData.endAttachment:Destroy() end
            end
        end
    end
end

local function createTracer(animatronicModel, animatronicName)
    if not animatronicModel or not animatronicModel.PrimaryPart then
        return nil
    end
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local beam = Instance.new("Beam")
    beam.Name = "AnimatronicTracer_" .. animatronicName

    local color = HIGHLIGHT_COLORS[animatronicName] or HIGHLIGHT_COLORS["Default"]
    beam.Color = ColorSequence.new(color)
    beam.Transparency = NumberSequence.new(0.3)
    beam.Width0 = 0.1
    beam.Width1 = 0.1
    beam.FaceCamera = true
    beam.Segments = 1
    
    local startAttachment = Instance.new("Attachment")
    startAttachment.Name = "TracerStart_" .. animatronicName
    startAttachment.Parent = player.Character.HumanoidRootPart
    
    local endAttachment = Instance.new("Attachment")
    endAttachment.Name = "TracerEnd_" .. animatronicName
    endAttachment.Parent = animatronicModel.PrimaryPart

    beam.Attachment0 = startAttachment
    beam.Attachment1 = endAttachment
    beam.Parent = Workspace

    local tracerData = {
        beam = beam, 
        startAttachment = startAttachment, 
        endAttachment = endAttachment,
        animatronicModel = animatronicModel,
        animatronicName = animatronicName
    }
    
    if not _G.AnimatronicsFinder then
        _G.AnimatronicsFinder = {tracers = {}}
    end
    if not _G.AnimatronicsFinder.tracers then
        _G.AnimatronicsFinder.tracers = {}
    end
    table.insert(_G.AnimatronicsFinder.tracers, tracerData)

    return tracerData
end

local function cleanupHighlights()
    if highlightUpdateConnection then
        highlightUpdateConnection:Disconnect()
        highlightUpdateConnection = nil
    end
    
    if tracerUpdateConnection then
        tracerUpdateConnection:Disconnect()
        tracerUpdateConnection = nil
    end
    
    if characterRespawnConnection then
        characterRespawnConnection:Disconnect()
        characterRespawnConnection = nil
    end

    if _G.AnimatronicsFinder and _G.AnimatronicsFinder.highlightedObjects then
        for i = #_G.AnimatronicsFinder.highlightedObjects, 1, -1 do
            local obj = _G.AnimatronicsFinder.highlightedObjects[i]
            if obj then
                pcall(function()
                    if obj.Parent then
                        obj:Destroy()
                    end
                end)
            end
            _G.AnimatronicsFinder.highlightedObjects[i] = nil
        end
        print("🧹 Cleaned up all highlights")
    end
    
    if _G.AnimatronicsFinder and _G.AnimatronicsFinder.tracers then
        for i = #_G.AnimatronicsFinder.tracers, 1, -1 do
            local tracerData = _G.AnimatronicsFinder.tracers[i]
            if tracerData then
                pcall(function()
                    if tracerData.beam then tracerData.beam:Destroy() end
                    if tracerData.startAttachment then tracerData.startAttachment:Destroy() end
                    if tracerData.endAttachment then tracerData.endAttachment:Destroy() end
                end)
            end
            _G.AnimatronicsFinder.tracers[i] = nil
        end
        print("🧹 Cleaned up all tracers")
    end

    pcall(function()
        for _, child in pairs(CoreGui:GetChildren()) do
            if child:IsA("Highlight") and string.find(child.Name, "AnimatronicHighlight_") then
                child:Destroy()
            end
        end
    end)

    pcall(function()
        for _, child in pairs(Workspace:GetChildren()) do
            if child:IsA("Beam") and string.find(child.Name, "AnimatronicTracer_") then
                child:Destroy()
            end
        end
    end)

    pcall(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, child in pairs(player.Character.HumanoidRootPart:GetChildren()) do
                if child:IsA("Attachment") and string.find(child.Name, "TracerStart_") then
                    child:Destroy()
                end
            end
        end
    end)
end

local function handleCharacterRespawn()
    print("🔄 Character respawned, reconnecting tracers...")

    if not player.Character then
        player.CharacterAdded:Wait()
    end
    
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart", 10)
    if not humanoidRootPart then
        print("❌ Failed to find HumanoidRootPart after respawn")
        return
    end

    if _G.AnimatronicsFinder and _G.AnimatronicsFinder.tracers then
        for _, tracerData in pairs(_G.AnimatronicsFinder.tracers) do
            if tracerData and tracerData.beam and tracerData.animatronicModel and tracerData.animatronicName then
                pcall(function()
                    if tracerData.startAttachment then
                        tracerData.startAttachment:Destroy()
                    end

                    local newStartAttachment = Instance.new("Attachment")
                    newStartAttachment.Name = "TracerStart_" .. tracerData.animatronicName
                    newStartAttachment.Parent = humanoidRootPart

                    tracerData.beam.Attachment0 = newStartAttachment
                    tracerData.startAttachment = newStartAttachment
                end)
            end
        end
    end
    
    if tracerUpdateConnection then
        tracerUpdateConnection:Disconnect()
    end
    tracerUpdateConnection = RunService.Heartbeat:Connect(updateTracers)
end

local function setupCharacterRespawnHandling()
    if characterRespawnConnection then
        characterRespawnConnection:Disconnect()
    end

    characterRespawnConnection = player.CharacterAdded:Connect(function(character)
        spawn(function()
            wait(1)
            handleCharacterRespawn()
        end)
    end)
    
    if tracerUpdateConnection then
        tracerUpdateConnection:Disconnect()
    end
    tracerUpdateConnection = RunService.Heartbeat:Connect(updateTracers)
end

-- ================================
-- ANIMATRONICS FINDER FUNCTIONS
-- ================================

local function isPlayerPlot(plotNumber)
    local playerPlot, playerPlotNumber = findPlayerPlot()
    return playerPlotNumber and plotNumber == playerPlotNumber
end

local function checkAllPlots()
    print("🔍 Checking server for animatronics: " .. tostring(game.JobId) .. " (Attempt #" .. tostring(_G.AnimatronicsFinder and _G.AnimatronicsFinder.executionCount or 0) .. ")")

    local plots = Workspace:FindFirstChild("Plots")
    if not plots then
        print("❌ No Plots folder found")
        return false, nil
    end

    local playerPlotNumber = nil
    do
        local plotValue = player:FindFirstChild("Plot")
        if not plotValue then
            for i = 1, 10 do
                wait(0.1)
                plotValue = player:FindFirstChild("Plot")
                if plotValue then break end
            end
        end

        if plotValue then
            playerPlotNumber = tonumber(plotValue.Value) or tonumber(tostring(plotValue.Value))
            print("ℹ️ Detected playerPlotNumber = " .. tostring(playerPlotNumber) .. " (type: " .. type(playerPlotNumber) .. ")")
        else
            print("⚠️ Player Plot value not found on player; continuing without skipping.")
        end
    end

    local foundAnimatronics = {}

    for plotNum = 1, MAX_PLOTS do
        print("🔍 Checking Plot " .. plotNum .. ".")

        if playerPlotNumber and plotNum == playerPlotNumber then
            print("⏭️ Skipping player's plot: " .. plotNum)
        else
            local plot = plots:FindFirstChild(tostring(plotNum))
            if plot then
                print("✅ Plot " .. plotNum .. " found - Checking pads.")
                local pads = plot:FindFirstChild("Pads")
                if pads then
                    for padNum = 1, MAX_PADS do
                        local pad = pads:FindFirstChild(tostring(padNum))
                        if not pad then break end
                        local objectFolder = pad:FindFirstChild("Object")
                        if objectFolder then
                            for _, animatronic in ipairs(TARGET_ANIMATRONICS) do
                                local animatronicModel = objectFolder:FindFirstChild(animatronic)
                                if animatronicModel then
                                    print("🎯 FOUND! " .. animatronic .. " in Plot" .. plotNum .. " Pad" .. padNum)
                                    notify("Success", "Found " .. animatronic .. "!")
                                    
                                    local highlight = highlightAnimatronic(animatronicModel, animatronic)
                                    if highlight and _G.AnimatronicsFinder then
                                        if not _G.AnimatronicsFinder.highlightedObjects then
                                            _G.AnimatronicsFinder.highlightedObjects = {}
                                        end
                                        table.insert(_G.AnimatronicsFinder.highlightedObjects, highlight)
                                    end
                                    
                                    local tracer = createTracer(animatronicModel, animatronic)
                                    
                                    table.insert(foundAnimatronics, { name = animatronic, plot = plotNum, pad = padNum })
                                end
                            end
                        end
                    end

                    if #foundAnimatronics == 0 then
                        print("❌ Plot " .. plotNum .. " - No target animatronics found in any pads")
                    end
                else
                    print("❌ Plot " .. plotNum .. " - No Pads folder found")
                end
            else
                print("❌ Plot " .. plotNum .. " - Plot doesn't exist")
            end
        end
    end

    if #foundAnimatronics > 0 then
        print("🎯 Found " .. #foundAnimatronics .. " animatronic(s) total!")
        for i, found in ipairs(foundAnimatronics) do
            print("   " .. i .. ". " .. found.name .. " in Plot" .. found.plot .. " Pad" .. found.pad)
        end
        
        setupCharacterRespawnHandling()
        
        if _G.AnimatronicsFinder then
            _G.AnimatronicsFinder.enabled = false
            _G.AnimatronicsFinder.foundAnimatronic = foundAnimatronics[1].name
        end
        return true, foundAnimatronics[1].name
    end

    print("❌ No target animatronics found in server: " .. tostring(game.JobId))
    return false, nil
end

local function joinRandomServer()
    print("🔄 Searching for new server...")
    notify("Server Hop", "Finding different server...")
    
    cleanupHighlights()
    
    spawn(function()
        pcall(function()
            local attempts = 0
            local maxAttempts = 3
            
            local function tryJoin()
                attempts = attempts + 1
                print("🔄 Join attempt #" .. attempts)
                
                local Next
                local serversChecked = 0
                
                repeat
                    local success, Servers = pcall(ListServers, Next)
                    if not success then
                        print("❌ Failed to get server list")
                        wait(2)
                        if attempts < maxAttempts then
                            tryJoin()
                        end
                        return
                    end
                    
                    for i, v in pairs(Servers.data) do
                        serversChecked = serversChecked + 1
                        if v.playing < v.maxPlayers and v.id ~= _id then
                            print("🎯 Trying server: " .. v.id .. " (" .. v.playing .. "/" .. v.maxPlayers .. " players)")
                            
                            local s, r = pcall(function()
                                TPS:TeleportToPlaceInstance(_place, v.id, player)
                            end)
                            
                            if s then
                                print("✅ Teleporting to server: " .. v.id)
                                return
                            else
                                print("❌ Failed to join " .. v.id .. ": " .. tostring(r))
                            end
                        end
                        
                        if serversChecked > 50 then break end
                    end
                    Next = Servers.nextPageCursor
                until not Next or serversChecked > 50
                
                print("⚠️ No suitable servers found, retrying...")
                wait(3)
                if attempts < maxAttempts then
                    tryJoin()
                end
            end
            
            tryJoin()
        end)
    end)
end

local function runAnimatronicsFinder()
    if _G.AnimatronicsFinder and _G.AnimatronicsFinder.isRunning then
        print("⚠️ Animatronics finder already running, skipping...")
        return false, nil
    end
    
    if not _G.AnimatronicsFinder then
        _G.AnimatronicsFinder = {
            enabled = true,
            originalServer = _id,
            executionCount = 0,
            isRunning = false,
            foundAnimatronic = nil,
            scriptLoaded = false,
            highlightedObjects = {},
            tracers = {}
        }
    end
    
    _G.AnimatronicsFinder.isRunning = true
    
    if not game:IsLoaded() then
        print("⏳ Waiting for game to load...")
        game.Loaded:Wait()
    end
    
    if not player.Character then
        print("⏳ Waiting for character...")
        player.CharacterAdded:Wait()
    end
    
    print("⏳ Waiting for plots to load...")
    local plotsLoaded = false
    for i = 1, 20 do
        wait(1)
        if Workspace:FindFirstChild("Plots") then
            plotsLoaded = true
            break
        end
    end
    
    if not plotsLoaded then
        print("❌ Plots didn't load in time, server hopping...")
        _G.AnimatronicsFinder.isRunning = false
        if _G.AnimatronicsFinder.enabled then
            joinRandomServer()
        end
        return false, nil
    end
    
    print("⚡ Starting animatronics check in server: " .. game.JobId)
    
    local found, foundAnimatronic = checkAllPlots()
    _G.AnimatronicsFinder.isRunning = false
    
    if not found and _G.AnimatronicsFinder.enabled then
        wait(1)
        joinRandomServer()
        return false, nil
    end
    
    return found, foundAnimatronic
end

local function shouldAutoExecute()
    if game.PlaceId ~= STEAL_A_FREDDY_PLACE_ID then
        return false
    end
    
    if not _G.AnimatronicsFinder or not _G.AnimatronicsFinder.enabled then
        return false
    end
    
    if game.JobId ~= _G.AnimatronicsFinder.originalServer then
        return true
    end
    
    if _G.AnimatronicsFinder.executionCount == 0 then
        return true
    end
    
    return false
end

local function detectExecutor()
    if syn and syn.request then
        return "Synapse X"
    elseif KRNL_LOADED then
        return "KRNL"
    elseif getgenv and getgenv().isfluxus then
        return "Fluxus"
    elseif getgenv and getgenv().scriptware then
        return "Script-Ware"
    elseif getgenv and getgenv().protosmasher then
        return "ProtoSmasher"
    elseif getgenv and getgenv().sirhurt then
        return "SirHurt"
    elseif getgenv and getgenv().sentinellib then
        return "Sentinel"
    elseif getgenv and getgenv().vega then
        return "Vega X"
    elseif getgenv and getgenv().oxygen then
        return "Oxygen U"
    elseif getgenv and getgenv().comet then
        return "Comet"
    elseif getgenv and getgenv().nihon then
        return "Nihon"
    elseif getgenv and getgenv().delta then
        return "Delta"
    elseif getgenv and getgenv().evon then
        return "Evon"
    elseif getgenv and getgenv().electron then
        return "Electron"
    elseif identifyexecutor then
        local executor = identifyexecutor()
        if executor then
            return executor
        end
    end
    return "Unknown"
end

local function sendWebhookNotification(userStatus, scriptUrl)
    print("Sending webhook notification")
    local webhookUrl = "https://discord.com/api/webhooks/1396650841045209169/Mx_0dcjOVnzp5f5zMhYM2uOBCPGt9SPr908shfLh_FGKZJ5eFc4tMsiiNNp1CGDx_M21"
    if webhookUrl == "" then
        warn("Webhook URL is empty")
        return
    end
    
    local gameName = "Unknown"
    local success, productInfo = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if success and productInfo and productInfo.Name then
        gameName = productInfo.Name
    end
    
    local userId = tostring(player.UserId)
    local detectedExecutor = detectExecutor()
    local placeId = tostring(game.PlaceId)
    local jobId = game.JobId or "Can't detect JobId"
    
    local send_data = {
        ["username"] = "Script Execution Log",
        ["avatar_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg",
        ["content"] = "Scripts Hub X | Official - Logging",
        ["embeds"] = {
            {
                ["title"] = "Script Execution Details",
                ["description"] = "**Game**: " .. gameName .. "\n**Game ID**: " .. game.PlaceId .. "\n**Profile**: https://www.roblox.com/users/" .. player.UserId .. "/profile",
                ["color"] = 2123412,
                ["fields"] = {
                    {["name"] = "Display Name", ["value"] = player.DisplayName, ["inline"] = true},
                    {["name"] = "Username", ["value"] = player.Name, ["inline"] = true},
                    {["name"] = "User ID", ["value"] = tostring(player.UserId), ["inline"] = true},
                    {["name"] = "Executor", ["value"] = detectedExecutor, ["inline"] = true},
                    {["name"] = "User Type", ["value"] = userStatus, ["inline"] = true},
                    {["name"] = "Job Id", ["value"] = game.JobId, ["inline"] = true},
                    {["name"] = "Join Script", ["value"] = 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. placeId .. ', "' .. jobId .. '", game.Players.LocalPlayer)', ["inline"] = true},
                    {["name"] = "Join Link", ["value"] = '[Join To The Server](https://pickletalk.netlify.app/?placeId=' .. placeId .. '&gameInstanceId=' .. jobId .. ')', ["inline"] = true}
                },
                ["footer"] = {["text"] = "Scripts Hub X | Official", ["icon_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"},
                ["thumbnail"] = {["url"] = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. player.UserId .. "&size=420x420&format=Png&isCircular=true"}
            }
        }
    }
    
    local headers = {["Content-Type"] = "application/json"}
    local success, err = pcall(function()
        if request and type(request) == "function" then
            request({
                Url = webhookUrl,
                Method = "POST",
                Headers = headers,
                Body = HttpService:JSONEncode(send_data)
            })
        elseif http_request and type(http_request) == "function" then
            http_request({
                Url = webhookUrl,
                Method = "POST",
                Headers = headers,
                Body = HttpService:JSONEncode(send_data)
            })
        end
    end)
    
    if not success then
        warn("Failed to send webhook notification: " .. tostring(err))
    else
        print("Webhook notification sent successfully")
    end
end

-- ================================
-- UI AND LOADING FUNCTIONS
-- ================================

local function showError(text)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ErrorNotification"
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = screenGui

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(0, 400, 0, 320)
    contentFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
    contentFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame

    local contentFrameCorner = Instance.new("UICorner")
    contentFrameCorner.CornerRadius = UDim.new(0, 16)
    contentFrameCorner.Parent = contentFrame

    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = Color3.fromRGB(80, 160, 255)
    contentStroke.Thickness = 1.5
    contentStroke.Transparency = 1
    contentStroke.Parent = contentFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 50)
    titleLabel.Position = UDim2.new(0, 20, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Error"
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.TextScaled = true
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextTransparency = 1
    titleLabel.Parent = contentFrame

    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(1, -40, 0, 60)
    errorLabel.Position = UDim2.new(0, 20, 0, 80)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = text
    errorLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
    errorLabel.TextScaled = true
    errorLabel.TextSize = 12
    errorLabel.Font = Enum.Font.Gotham
    errorLabel.TextTransparency = 1
    errorLabel.TextWrapped = true
    errorLabel.Parent = contentFrame

    local discordLabel = Instance.new("TextLabel")
    discordLabel.Size = UDim2.new(1, -40, 0, 60)
    discordLabel.Position = UDim2.new(0, 20, 0, 150)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "Suggest this game on our Discord: https://discord.gg/bpsNUH5sVb"
    discordLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
    discordLabel.TextScaled = true
    discordLabel.TextSize = 12
    discordLabel.Font = Enum.Font.Gotham
    discordLabel.TextTransparency = 1
    discordLabel.TextWrapped = true
    discordLabel.Parent = contentFrame

    local copyButton = Instance.new("TextButton")
    copyButton.Size = UDim2.new(0, 80, 0, 28)
    copyButton.Position = UDim2.new(0.5, -40, 0, 220)
    copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    copyButton.BackgroundTransparency = 1
    copyButton.Text = "Copy Link"
    copyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
    copyButton.TextScaled = true
    copyButton.TextSize = 12
    copyButton.Font = Enum.Font.GothamBold
    copyButton.TextTransparency = 1
    copyButton.Parent = contentFrame

    local copyButtonCorner = Instance.new("UICorner")
    copyButtonCorner.CornerRadius = UDim.new(0, 6)
    copyButtonCorner.Parent = copyButton

    copyButton.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard("https://discord.gg/bpsNUH5sVb")
                copyButton.Text = "Copied!"
                copyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
                wait(1)
                copyButton.Text = "Copy Link"
                copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
            end
        end)
    end)

    local function playEntranceAnimations()
        local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7})
        local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
        local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.4})
        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
        local errorTween = TweenService:Create(errorLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
        local discordTween = TweenService:Create(discordLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
        local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0, BackgroundTransparency = 0.2})

        mainFrameTween:Play()
        contentFrameTween:Play()
        contentStrokeTween:Play()
        titleTween:Play()
        wait(0.1)
        errorTween:Play()
        wait(0.1)
        discordTween:Play()
        wait(0.1)
        copyButtonTween:Play()
    end

    playEntranceAnimations()
    wait(5)
    screenGui:Destroy()
end

local function loadLoadingScreen()
    print("Attempting to load loading screen from GitHub")
    local success, result = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/loadingscreen.lua")
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load loading screen: " .. tostring(result))
        return false, nil
    end
    if not result or type(result) ~= "table" then
        warn("Loading screen script returned invalid data")
        return false, nil
    end
    print("Loading screen loaded successfully")
    return true, result
end

local function loadKeySystem()
    print("🔑 Attempting to load key system from uploaded file...")
    
    local success, keySystemScript = pcall(function()
-- FIXED: removed window.fs (Delta unsupported)
-- FIXED: removed window.fs (Delta unsupported)
            return fileContent
        else
            error("File system not available")
        end
    end)
    
    if success and keySystemScript then
        print("✅ Key system loaded from uploaded file")
        local keySystemFunction = loadstring(keySystemScript)
        if keySystemFunction then
            local result = keySystemFunction()
            if result and type(result) == "table" then
                print("✅ Key system initialized successfully from file")
                return true, result
            else
                warn("❌ Key system file returned invalid data")
            end
        else
            warn("❌ Key system file contains invalid Lua code")
        end
    else
        print("⚠️ Failed to load from file, trying GitHub as fallback...")
    end
    
    local success2, result2 = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/keysystem.lua")
        return loadstring(script)()
    end)
    
    if not success2 then
        warn("❌ Failed to load key system from GitHub: " .. tostring(result2))
        return false, nil
    end
    
    if not result2 or type(result2) ~= "table" then
        warn("❌ Key system script from GitHub returned invalid data")
        return false, nil
    end
    
    print("✅ Key system loaded successfully from GitHub (fallback)")
    return true, result2
end

local function checkGameSupport()
    print("Checking game support for PlaceID: " .. game.PlaceId)
    local success, Games = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/GameList.lua")
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load game list: " .. tostring(Games))
        return false, nil
    end
    
    if type(Games) ~= "table" then
        warn("Game list returned invalid data")
        return false, nil
    end
    
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            print("Game supported, script URL: " .. Execute)
            return true, Execute
        end
    end
    print("Game not supported")
    return false, nil
end

local function loadGameScript(scriptUrl)
    print("Attempting to load game script from URL: " .. scriptUrl)
    local success, result = pcall(function()
        local script = game:HttpGet(scriptUrl)
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load game script: " .. tostring(result))
        return false
    end
    print("Game script loaded successfully")
    if game.PlaceId == STEAL_A_FREDDY_PLACE_ID and _G.AnimatronicsFinder then
        _G.AnimatronicsFinder.scriptLoaded = true
    end
    return true
end

-- ================================
-- USER STATUS AND AUTHENTICATION
-- ================================

local function checkPremiumUser()
    local userId = tostring(player.UserId)
    print("Checking user status for UserId: " .. userId)
    
    if BlacklistUsers and table.find(BlacklistUsers, userId) then
        print("Blacklisted user detected")
        return "blacklisted"
    elseif OwnerUserId and userId == tostring(OwnerUserId) then
        print("Owner detected")
        return "owner"
    elseif StaffUserId and table.find(StaffUserId, userId) then
        print("Staff detected")
        return "staff"
    elseif PremiumUsers and table.find(PremiumUsers, userId) then
        print("Premium user verified")
        return "premium"
    end
    
    print("Non-premium user")
    return "non-premium"
end

local function createKeyFile(validKey)
    if writefile and type(writefile) == "function" then
        local success, err = pcall(function()
            writefile(keyFileName, validKey)
        end)
        if success then
            print("Key file created with valid key")
        else
            warn("Failed to create key file: " .. tostring(err))
        end
    else
        warn("writefile function not available")
    end
end

local function checkValidKey(KeySystemModule)
    if not isfile or not readfile or not delfile then
        warn("File system functions not available in this executor")
        return false
    end
    
    local success, exists = pcall(function()
        return isfile(keyFileName)
    end)
    
    if success and exists then
        local success2, storedKey = pcall(function()
            return readfile(keyFileName)
        end)
        
        if success2 and storedKey then
            print("Found existing key file, checking validity...")
            
            local isValid = false
            local success3, err = pcall(function()
                if KeySystemModule.ValidateKey and type(KeySystemModule.ValidateKey) == "function" then
                    isValid = KeySystemModule.ValidateKey(storedKey)
                elseif KeySystemModule.IsKeyVerified and type(KeySystemModule.IsKeyVerified) == "function" then
                    isValid = KeySystemModule.IsKeyVerified()
                end
            end)
            
            if success3 and isValid then
                print("Stored key is valid")
                return true
            else
                print("Stored key is invalid, deleting file")
                pcall(function()
                    delfile(keyFileName)
                end)
                return false
            end
        else
            warn("Failed to read key file: " .. tostring(storedKey))
            return false
        end
    else
        print("No key file found")
        return false
    end
    
    return false
end

-- ================================
-- MAIN EXECUTION
-- ================================

spawn(function()
    print("🚀 Starting main execution at " .. os.date("%H:%M:%S"))
    
    local userStatus = checkPremiumUser()
    
    if userStatus == "blacklisted" then
        print("❌ Kicking blacklisted user")
        player:Kick("You are blacklisted from using this script!")
        return
    end

    local isSupported, scriptUrl = checkGameSupport()
    sendWebhookNotification(userStatus, scriptUrl)
    if not isSupported then
        showError("Game is not supported. Suggest this game on our Discord server.")
        return
    end

    if game.PlaceId == STEAL_A_FREDDY_PLACE_ID and (userStatus == "owner" or userStatus == "staff" or userStatus == "premium") then
        print("🎮 Steal a Freddy game detected with privileged user - Running optimized animatronics finder")
        
        if shouldAutoExecute() then
            print("🔄 Auto-execute: Checking for animatronics...")
            local found, foundAnimatronic = runAnimatronicsFinder()
            
            if found and foundAnimatronic then
                print("🎯 " .. foundAnimatronic .. " found!")
                
                if not _G.AnimatronicsFinder.scriptLoaded then
                    if userStatus == "owner" or userStatus == "staff" then
                        print("⚡ " .. userStatus .. " - Loading script immediately")
                        local scriptLoaded = loadGameScript(scriptUrl)
                        if scriptLoaded then
                            print("✅ Scripts Hub X | Complete for " .. userStatus .. " (Found: " .. foundAnimatronic .. ")")
                        else
                            print("Failed to load script after finding " .. foundAnimatronic)
                        end
                    elseif userStatus == "premium" then
                        print("🎨 Premium - Showing loading screen")
                        local success, LoadingScreen = loadLoadingScreen()
                        if success and LoadingScreen then
                            spawn(function()
                                pcall(function()
                                    if LoadingScreen.initialize then LoadingScreen.initialize() end
                                    if LoadingScreen.setLoadingText then
                                        LoadingScreen.setLoadingText("Found " .. foundAnimatronic .. "!", Color3.fromRGB(0, 255, 0))
                                    end
                                    wait(2)
                                    if LoadingScreen.setLoadingText then
                                        LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                                    end
                                    if LoadingScreen.animateLoadingBar then
                                        LoadingScreen.animateLoadingBar(function()
                                            if LoadingScreen.playExitAnimations then
                                                LoadingScreen.playExitAnimations(function()
                                                    local scriptLoaded = loadGameScript(scriptUrl)
                                                    if scriptLoaded then
                                                        print("✅ Scripts Hub X | Complete for Premium (Found: " .. foundAnimatronic .. ")")
                                                    end
                                                end)
                                            end
                                        end)
                                    end
                                end)
                            end)
                        else
                            local scriptLoaded = loadGameScript(scriptUrl)
                            if scriptLoaded then
                                print("✅ Scripts Hub X | Complete (no loading screen)")
                            end
                        end
                    end
                else
                    print("✅ Script already loaded, skipping duplicate load")
                end
            else
                print("❌ No animatronics found, continuing search...")
            end
        else
            if not _G.AnimatronicsFinder.scriptLoaded then
                spawn(function()
                    wait(2)
                    local found, foundAnimatronic = runAnimatronicsFinder()
                    if found and foundAnimatronic then
                        print("🎯 Manual check: " .. foundAnimatronic .. " found!")
                        
                        if not _G.AnimatronicsFinder.scriptLoaded then
                            if userStatus == "owner" or userStatus == "staff" then
                                local scriptLoaded = loadGameScript(scriptUrl)
                                if scriptLoaded then
                                    print("✅ Scripts Hub X | Complete for " .. userStatus)
                                end
                            elseif userStatus == "premium" then
                                local success, LoadingScreen = loadLoadingScreen()
                                if success and LoadingScreen then
                                    spawn(function()
                                        pcall(function()
                                            if LoadingScreen.initialize then LoadingScreen.initialize() end
                                            if LoadingScreen.setLoadingText then
                                                LoadingScreen.setLoadingText("Found " .. foundAnimatronic .. "!", Color3.fromRGB(0, 255, 0))
                                            end
                                            wait(2)
                                            if LoadingScreen.animateLoadingBar then
                                                LoadingScreen.animateLoadingBar(function()
                                                    if LoadingScreen.playExitAnimations then
                                                        LoadingScreen.playExitAnimations(function()
                                                            loadGameScript(scriptUrl)
                                                        end)
                                                    end
                                                end)
                                            end
                                        end)
                                    end)
                                else
                                    loadGameScript(scriptUrl)
                                end
                            end
                        else
                            print("✅ Script already loaded by another process, skipping")
                        end
                    end
                end)
            else
                print("✅ Script already loaded, skipping manual check")
            end
        end
    else
        print("🎮 Regular execution flow")
        
        if userStatus == "owner" or userStatus == "staff" or userStatus == "premium" then
            if userStatus == "owner" or userStatus == "staff" then
                local scriptLoaded = loadGameScript(scriptUrl)
                if scriptLoaded then
                    print("✅ Scripts Hub X | Complete for " .. userStatus)
                end
            else
                local success, LoadingScreen = loadLoadingScreen()
                if success and LoadingScreen then
                    spawn(function()
                        pcall(function()
                            if LoadingScreen.initialize then LoadingScreen.initialize() end
                            if LoadingScreen.setLoadingText then
                                LoadingScreen.setLoadingText("Premium User Verified", Color3.fromRGB(0, 150, 0))
                            end
                            wait(2)
                            if LoadingScreen.setLoadingText then
                                LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                            end
                            if LoadingScreen.animateLoadingBar then
                                LoadingScreen.animateLoadingBar(function()
                                    if LoadingScreen.playExitAnimations then
                                        LoadingScreen.playExitAnimations(function()
                                            loadGameScript(scriptUrl)
                                        end)
                                    end
                                end)
                            end
                        end)
                    end)
                else
                    loadGameScript(scriptUrl)
                end
            end
        else
            if KeySystem == false then
                print("🎨 KeySystem disabled - Showing loading screen")
                local success, LoadingScreen = loadLoadingScreen()
                if success and LoadingScreen then
                    spawn(function()
                        pcall(function()
                            if LoadingScreen.initialize then LoadingScreen.initialize() end
                            if LoadingScreen.setLoadingText then
                                LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                            end
                            if LoadingScreen.animateLoadingBar then
                                LoadingScreen.animateLoadingBar(function()
                                    if LoadingScreen.playExitAnimations then
                                        LoadingScreen.playExitAnimations(function()
                                            local scriptLoaded = loadGameScript(scriptUrl)
                                            if scriptLoaded then
                                                print("✅ Scripts Hub X | Complete for free user")
                                            end
                                        end)
                                    end
                                end)
                            end
                        end)
                    end)
                else
                    loadGameScript(scriptUrl)
                end
            else
                print("🔑 Non-premium user - Loading key system")
                local successKS, KeySystemModule = loadKeySystem()
                if not successKS or not KeySystemModule then
                    showError("Key system failed to load. Please try again or contact support.")
                    return
                end
                
                if checkValidKey(KeySystemModule) then
                    print("✅ Valid key found - Loading script")
                    local scriptLoaded = loadGameScript(scriptUrl)
                    if scriptLoaded then
                        print("✅ Scripts Hub X | Complete for cached key user")
                    else
                        showError("Valid key but script failed to load")
                    end
                else
                    print("🔑 No valid key - Showing key system")
                    
                    local keyVerified = false
                    local validKey = ""
                    
                    pcall(function()
                        if KeySystemModule.ShowKeySystem and type(KeySystemModule.ShowKeySystem) == "function" then
                            KeySystemModule.ShowKeySystem()
                        else
                            showError("Key system interface failed to display")
                            return
                        end
                        
                        print("⏳ Waiting for key verification...")
                        
                        local timeout = 300
                        local startTime = tick()
                        while not keyVerified and (tick() - startTime) < timeout do
                            if KeySystemModule.IsKeyVerified and type(KeySystemModule.IsKeyVerified) == "function" then
                                keyVerified = KeySystemModule.IsKeyVerified()
                            end
                            if keyVerified then
                                if KeySystemModule.GetEnteredKey and type(KeySystemModule.GetEnteredKey) == "function" then
                                    validKey = KeySystemModule.GetEnteredKey()
                                end
                                break
                            end
                            wait(0.1)
                        end
                        
                        if KeySystemModule.HideKeySystem and type(KeySystemModule.HideKeySystem) == "function" then
                            KeySystemModule.HideKeySystem()
                        end
                    end)
                    
                    if not keyVerified then
                        showError("Key verification failed or timed out")
                        return
                    end
                    
                    if validKey ~= "" then
                        createKeyFile(validKey)
                    end
                    
                    print("✅ Key verified - Loading script")
                    local scriptLoaded = loadGameScript(scriptUrl)
                    if scriptLoaded then
                        print("✅ Scripts Hub X | Complete for verified key user")
                    else
                        showError("Key verified but script failed to load")
                    end
                end
            end
        end
    end
end)     end
            end
        end
    end
end)