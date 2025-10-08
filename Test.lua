-- Rayfield UI Library Loader (Official Source)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = "Delta Hub",
    LoadingTitle = "Delta Hub",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- Create a tab
local Tab = Window:CreateTab("Main", nil)

-- State variables for our toggles
local instantInteractEnabled = false
local noClipEnabled = false
local advancedDesyncEnabled = false

-- ==================== INSTANT INTERACT LOGIC ====================
spawn(function()
    while wait(0.5) do
        if instantInteractEnabled then
            for _, prompt in ipairs(game:GetService("Workspace"):GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0
                    prompt.MaxActivationDistance = 25
                end
            end
        end
    end
end)

-- ==================== SIMPLE NO-CLIP LOGIC ====================
local function setCharacterCollision(state)
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = state
            end
        end
    end
end

spawn(function()
    while wait(0.1) do
        if noClipEnabled then
            setCharacterCollision(false)
        end
    end
end)

-- ==================== ADVANCED DESYNC LOGIC (UPDATED METHOD) ====================
-- This function now uses Network Ownership, which is more reliable.
local function setNetworkOwnership(state)
    local character = game.Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if rootPart then
        -- state = true to take control (desync), false to give control back (sync)
        if state then
            -- Take manual control of the network ownership.
            -- The server will no longer automatically correct your position.
            sethiddenproperty(rootPart, "NetworkOwnershipRule", Enum.NetworkOwnership.Manual)
        else
            -- Give control back to the server. It will now resync your position.
            sethiddenproperty(rootPart, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
        end
    end
end

-- Handle respawning: if the player respawns while a toggle is on, re-apply the effect
game.Players.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    wait(1) -- Wait for character to fully load
    if noClipEnabled then
        setCharacterCollision(false)
        Rayfield:Notify({Title = "No-Clip Re-applied", Content = "No-Clip was re-applied on respawn.", Duration = 3})
    end
    if advancedDesyncEnabled then
        setNetworkOwnership(true) -- Use the new function
        Rayfield:Notify({Title = "Desync Re-applied", Content = "Advanced Desync was re-applied on respawn.", Duration = 3})
    end
end)


-- ==================== UI ELEMENTS ====================

Tab:CreateSection("World")

Tab:CreateToggle({
    Name = "Instant Interact",
    CurrentValue = false,
    Flag = "InstantInteractToggle1",
    Callback = function(Value)
        instantInteractEnabled = Value
        Rayfield:Notify({Title = "Instant Interact", Content = Value and "Enabled" or "Disabled", Duration = 2})
    end,
})

Tab:CreateSection("Player")

Tab:CreateToggle({
    Name = "Desync (No-Clip)",
    CurrentValue = false,
    Flag = "NoClipToggle1",
    Callback = function(Value)
        noClipEnabled = Value
        if Value then
            setCharacterCollision(false)
        else
            setCharacterCollision(true)
        end
        Rayfield:Notify({Title = "No-Clip", Content = Value and "Enabled" or "Disabled", Duration = 2})
    end,
})

Tab:CreateToggle({
    Name = "Advanced Desync (Freeze)",
    CurrentValue = false,
    Flag = "AdvancedDesyncToggle1",
    Callback = function(Value)
        advancedDesyncEnabled = Value
        if Value then
            -- Take control of your character's physics from the server
            setNetworkOwnership(true)
            Rayfield:Notify({Title = "Advanced Desync: ON", Content = "You are frozen on the server. Move, then turn OFF to teleport.", Duration = 5})
        else
            -- Give control back to the server, causing a resync
            setNetworkOwnership(false)
            Rayfield:Notify({Title = "Advanced Desync: OFF", Content = "Re-syncing with the server...", Duration = 3})
        end
    end,
})
