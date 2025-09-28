-- Create main GUI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloatUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create draggable frame with background
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(68, 68, 68)  -- #444444
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Add rounded corners (25px)
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 25)
frameCorner.Parent = mainFrame

-- Create title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 200, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Tower of Hell"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

-- Create subtitle label
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(0, 200, 0, 20)
subtitleLabel.Position = UDim2.new(0, 0, 0, 35)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Script Hub X"
subtitleLabel.TextColor3 = Color3.fromRGB(136, 136, 136)  -- #888888
subtitleLabel.Font = Enum.Font.SourceSans
subtitleLabel.TextSize = 14
subtitleLabel.Parent = mainFrame

-- Create toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "Toggle"
toggleButton.Size = UDim2.new(0, 120, 0, 30)
toggleButton.Position = UDim2.new(0, 15, 0, 60)
toggleButton.BackgroundColor3 = Color3.fromRGB(190, 190, 190)  -- #BEBEBE
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Float: OFF"
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 14
toggleButton.Parent = mainFrame

-- Add rounded corners to toggle button
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 15)
toggleCorner.Parent = toggleButton

-- Create close button (X)
local closeButton = Instance.new("TextButton")
closeButton.Name = "Close"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(0, 165, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(136, 136, 136)  -- #888888
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

-- Float functionality
local floatEnabled = false
local platform = nil
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Function to create invisible platform
local function createPlatform()
    if platform then return end
    
    platform = Instance.new("Part")
    platform.Name = "FloatPlatform"
    platform.Size = Vector3.new(8, 0.5, 8)
    platform.Transparency = 1
    platform.Anchored = true
    platform.CanCollide = true
    platform.Parent = workspace
    
    -- Position platform under player
    platform.Position = humanoidRootPart.Position - Vector3.new(0, 3, 0)
end

-- Function to remove platform
local function removePlatform()
    if platform then
        platform:Destroy()
        platform = nil
    end
end

-- Function to toggle float feature
local function toggleFloat()
    floatEnabled = not floatEnabled
    toggleButton.Text = floatEnabled and "Float: ON" or "Float: OFF"
    
    -- Change button color when active
    if floatEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)  -- Green when ON
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(190, 190, 190)  -- #BEBEBE when OFF
    end
    
    if not floatEnabled then
        removePlatform()
    end
end

-- Track player state
local lastState = humanoid:GetState()

-- Function to handle state changes
local function onStateChanged(oldState, newState)
    -- Create platform when entering freefall state
    if floatEnabled and newState == Enum.HumanoidStateType.Freefall then
        createPlatform()
    end
    
    -- Remove platform when landing
    if newState == Enum.HumanoidStateType.Landed then
        removePlatform()
    end
    
    lastState = newState
end

-- Connect state changed event
humanoid.StateChanged:Connect(onStateChanged)

-- Button connections
toggleButton.MouseButton1Click:Connect(toggleFloat)

closeButton.MouseButton1Click:Connect(function()
    removePlatform()
    screenGui:Destroy()
end)

-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reconnect state changed event for new character
    humanoid.StateChanged:Connect(onStateChanged)
    
    -- Update last state
    lastState = humanoid:GetState()
end)

-- Update platform position and apply slow fall effect
game:GetService("RunService").Heartbeat:Connect(function()
    if floatEnabled and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        -- Apply slow fall effect
        local currentVelocity = humanoidRootPart.Velocity
        -- Cap downward velocity to create slow fall effect
        humanoidRootPart.Velocity = Vector3.new(
            currentVelocity.X, 
            math.max(currentVelocity.Y, -10),  -- Slow fall speed
            currentVelocity.Z
        )
        
        -- Update platform position if it exists
        if platform then
            platform.Position = humanoidRootPart.Position - Vector3.new(0, 3, 0)
        end
    end
end)

-- Make UI draggable
local dragging
local dragInput
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
