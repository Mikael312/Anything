local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variabel state microstep
local microstepEnabled = false

-- Buat tombol GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MicrostepGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "MicrostepToggle"
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Text = "Microstep: OFF"
toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Parent = screenGui

-- Fungsi toggle microstep
local function toggleMicrostep()
    microstepEnabled = not microstepEnabled
    toggleButton.Text = "Microstep: " .. (microstepEnabled and "ON" or "OFF")
    toggleButton.BackgroundColor3 = microstepEnabled and Color3.new(0, 0.5, 0) or Color3.new(0.2, 0.2, 0.2)
end

toggleButton.MouseButton1Click:Connect(toggleMicrostep)

-- Fungsi microstep yang dimodifikasi
local function microStepMove(targetPosition)
    if not microstepEnabled then return end
    
    local currentPosition = rootPart.Position
    local direction = (targetPosition - currentPosition).Unit
    local distance = (targetPosition - currentPosition).Magnitude
    local stepSize = 0.1  -- Langkah sangat kecil
    local steps = math.ceil(distance / stepSize)
    
    -- Gerakan dalam langkah kecil
    for i = 1, steps do
        local stepPosition = currentPosition + direction * (stepSize * i)
        rootPart.CFrame = CFrame.new(stepPosition)
        RunService.RenderStepped:Wait()
    end
    
    -- Posisi akhir untuk akurasi
    rootPart.CFrame = CFrame.new(targetPosition)
end

-- Hubungkan ke pergerakan karakter (tanpa mengganggu kontrol normal)
humanoid.Running:Connect(function(speed)
    if microstepEnabled and speed > 0 then
        -- Ambil target posisi berikutnya dari pergerakan normal
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            local targetPosition = rootPart.Position + (moveDirection * 0.5) -- Jarak pendek
            microStepMove(targetPosition)
        end
    end
end)

-- Handle lompatan (tetap berfungsi normal)
humanoid.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Jumping and microstepEnabled then
        -- Tetap izinkan lompatan normal
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
