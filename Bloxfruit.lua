-- Blox Fruits Script Hub
-- Developer: michel
-- Discord: https://discord.gg/kkVnwtfn

-- Main Library and UI Framework
local ScriptHub = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Variables
local CurrentCamera = workspace.CurrentCamera
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
local Drawings = {}
local Connections = {}
local Toggles = {}
local Dropdowns = {}
local Sliders = {}
local Buttons = {}
local Tabs = {}
local CurrentTab = "General"

-- UI Configuration
local UIConfig = {
    MainColor = Color3.fromRGB(0, 0, 0),
    SecondaryColor = Color3.fromRGB(30, 30, 30),
    AccentColor = Color3.fromRGB(0, 255, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    FontSize = 14,
    Transparency = 0.8
}

-- Create Main UI
function ScriptHub:CreateMainUI()
    -- Main ScreenGui
    self.MainGui = Instance.new("ScreenGui")
    self.MainGui.Name = "ScriptHub"
    self.MainGui.ResetOnSpawn = false
    self.MainGui.Parent = game.CoreGui
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 700, 0, 500)
    self.MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    self.MainFrame.BackgroundColor3 = UIConfig.MainColor
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.MainGui
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    
    -- Add corner to main frame
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = self.MainFrame
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = UIConfig.SecondaryColor
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    -- Add corner to title bar
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = self.TitleBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Script Hub"
    Title.TextColor3 = UIConfig.TextColor
    Title.TextSize = 16
    Title.Font = UIConfig.Font
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = self.TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "X"
    CloseButton.TextColor3 = UIConfig.TextColor
    CloseButton.TextSize = 14
    CloseButton.Font = UIConfig.Font
    CloseButton.Parent = self.TitleBar
    
    CloseButton.MouseButton1Click:Connect(function()
        self.MainGui.Enabled = false
    end)
    
    -- Maximize Button
    local MaximizeButton = Instance.new("TextButton")
    MaximizeButton.Name = "MaximizeButton"
    MaximizeButton.Size = UDim2.new(0, 30, 0, 30)
    MaximizeButton.Position = UDim2.new(1, -60, 0, 0)
    MaximizeButton.BackgroundTransparency = 1
    MaximizeButton.Text = "□"
    MaximizeButton.TextColor3 = UIConfig.TextColor
    MaximizeButton.TextSize = 14
    MaximizeButton.Font = UIConfig.Font
    MaximizeButton.Parent = self.TitleBar
    
    MaximizeButton.MouseButton1Click:Connect(function()
        if self.MainFrame.Size == UDim2.new(0, 700, 0, 500) then
            self.MainFrame:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.3, true)
            self.MainFrame.Position = UDim2.new(0, 0, 0, 0)
        else
            self.MainFrame:TweenSize(UDim2.new(0, 700, 0, 500), "Out", "Quad", 0.3, true)
            self.MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
        end
    end)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -90, 0, 0)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Text = "_"
    MinimizeButton.TextColor3 = UIConfig.TextColor
    MinimizeButton.TextSize = 14
    MinimizeButton.Font = UIConfig.Font
    MinimizeButton.Parent = self.TitleBar
    
    MinimizeButton.MouseButton1Click:Connect(function()
        self.MainGui.Enabled = false
        -- Create reopen button
        local ReopenButton = Instance.new("TextButton")
        ReopenButton.Name = "ReopenButton"
        ReopenButton.Size = UDim2.new(0, 50, 0, 50)
        ReopenButton.Position = UDim2.new(0, 10, 0.5, -25)
        ReopenButton.BackgroundColor3 = UIConfig.SecondaryColor
        ReopenButton.BorderSizePixel = 0
        ReopenButton.Text = "📱"
        ReopenButton.TextColor3 = UIConfig.TextColor
        ReopenButton.TextSize = 24
        ReopenButton.Font = UIConfig.Font
        ReopenButton.Parent = self.MainGui
        
        local ReopenCorner = Instance.new("UICorner")
        ReopenCorner.CornerRadius = UDim.new(0, 8)
        ReopenCorner.Parent = ReopenButton
        
        ReopenButton.MouseButton1Click:Connect(function()
            self.MainGui.Enabled = true
            ReopenButton:Destroy()
        end)
    end)
    
    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, 150, 1, -30)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 30)
    self.Sidebar.BackgroundColor3 = UIConfig.SecondaryColor
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.MainFrame
    
    -- Add corner to sidebar
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = self.Sidebar
    
    -- Content Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Size = UDim2.new(1, -150, 1, -30)
    self.ContentArea.Position = UDim2.new(0, 150, 0, 30)
    self.ContentArea.BackgroundColor3 = UIConfig.MainColor
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.Parent = self.MainFrame
    
    -- Add corner to content area
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = self.ContentArea
    
    -- Create Tabs
    self:CreateTabs()
    
    -- Create Tab Content
    self:CreateTabContent()
    
    -- Mobile friendly adjustments
    if UserInputService.TouchEnabled then
        self.MainFrame.Size = UDim2.new(0.9, 0, 0.9, 0)
        self.MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    end
end

-- Create Tabs
function ScriptHub:CreateTabs()
    local tabNames = {
        "Credit", "General", "Quests/Items", "Stats", 
        "Fruits", "Travels", "Shop", "Miscellaneous", "Settings"
    }
    
    local tabIcons = {
        "📋", "⚔️", "📋", "📊", "🍎", "🗺️", "🛒", "⚙️", "🔧"
    }
    
    for i, tabName in ipairs(tabNames) do
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Position = UDim2.new(0, 0, 0, (i-1) * 40)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = tabIcons[i] .. " " .. tabName
        TabButton.TextColor3 = UIConfig.TextColor
        TabButton.TextSize = 12
        TabButton.Font = UIConfig.Font
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = self.Sidebar
        
        -- Add padding
        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.Parent = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            self:SwitchTab(tabName)
        end)
        
        -- Set General as default active tab
        if tabName == "General" then
            TabButton.BackgroundColor3 = UIConfig.AccentColor
            TabButton.BackgroundTransparency = 0.3
        end
        
        Tabs[tabName] = TabButton
    end
end

-- Switch Tab
function ScriptHub:SwitchTab(tabName)
    -- Update tab buttons
    for name, tabButton in pairs(Tabs) do
        if name == tabName then
            tabButton.BackgroundColor3 = UIConfig.AccentColor
            tabButton.BackgroundTransparency = 0.3
        else
            tabButton.BackgroundTransparency = 1
        end
    end
    
    -- Update content area
    for _, contentFrame in pairs(self.ContentArea:GetChildren()) do
        if contentFrame:IsA("Frame") then
            contentFrame.Visible = false
        end
    end
    
    if self.ContentArea:FindFirstChild(tabName .. "Content") then
        self.ContentArea[tabName .. "Content"].Visible = true
    end
    
    CurrentTab = tabName
end

-- Create Tab Content
function ScriptHub:CreateTabContent()
    -- Credit Tab
    self:CreateCreditTab()
    
    -- General Tab
    self:CreateGeneralTab()
    
    -- Quests/Items Tab
    self:CreateQuestsItemsTab()
    
    -- Stats Tab
    self:CreateStatsTab()
    
    -- Fruits Tab
    self:CreateFruitsTab()
    
    -- Travels Tab
    self:CreateTravelsTab()
    
    -- Shop Tab
    self:CreateShopTab()
    
    -- Miscellaneous Tab
    self:CreateMiscellaneousTab()
    
    -- Settings Tab
    self:CreateSettingsTab()
end

-- Create Credit Tab
function ScriptHub:CreateCreditTab()
    local CreditContent = Instance.new("Frame")
    CreditContent.Name = "CreditContent"
    CreditContent.Size = UDim2.new(1, 0, 1, 0)
    CreditContent.Position = UDim2.new(0, 0, 0, 0)
    CreditContent.BackgroundTransparency = 1
    CreditContent.Parent = self.ContentArea
    
    -- Developer Info
    local DeveloperLabel = Instance.new("TextLabel")
    DeveloperLabel.Name = "DeveloperLabel"
    DeveloperLabel.Size = UDim2.new(0, 200, 0, 30)
    DeveloperLabel.Position = UDim2.new(0.5, -100, 0.3, 0)
    DeveloperLabel.BackgroundTransparency = 1
    DeveloperLabel.Text = "Developer: michel"
    DeveloperLabel.TextColor3 = UIConfig.TextColor
    DeveloperLabel.TextSize = 18
    DeveloperLabel.Font = UIConfig.Font
    DeveloperLabel.Parent = CreditContent
    
    -- Discord Button
    local DiscordButton = Instance.new("TextButton")
    DiscordButton.Name = "DiscordButton"
    DiscordButton.Size = UDim2.new(0, 200, 0, 40)
    DiscordButton.Position = UDim2.new(0.5, -100, 0.5, 0)
    DiscordButton.BackgroundColor3 = UIConfig.SecondaryColor
    DiscordButton.BorderSizePixel = 0
    DiscordButton.Text = "Join Discord →"
    DiscordButton.TextColor3 = UIConfig.TextColor
    DiscordButton.TextSize = 16
    DiscordButton.Font = UIConfig.Font
    DiscordButton.Parent = CreditContent
    
    -- Add corner to Discord button
    local DiscordCorner = Instance.new("UICorner")
    DiscordCorner.CornerRadius = UDim.new(0, 6)
    DiscordCorner.Parent = DiscordButton
    
    DiscordButton.MouseButton1Click:Connect(function()
        -- Open Discord link
        local url = "https://discord.gg/kkVnwtfn"
        syn.write_clipboard(url)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Discord Link",
            Text = "Discord link copied to clipboard!",
            Duration = 5
        })
    end)
    
    -- Discord Logo
    local DiscordLogo = Instance.new("ImageLabel")
    DiscordLogo.Name = "DiscordLogo"
    DiscordLogo.Size = UDim2.new(0, 100, 0, 100)
    DiscordLogo.Position = UDim2.new(0.5, -50, 0.1, 0)
    DiscordLogo.BackgroundTransparency = 1
    DiscordLogo.Image = "rbxassetid://113520323335055"
    DiscordLogo.Parent = CreditContent
    
    -- Hide initially since General is the default tab
    CreditContent.Visible = false
end

-- Create General Tab
function ScriptHub:CreateGeneralTab()
    local GeneralContent = Instance.new("ScrollingFrame")
    GeneralContent.Name = "GeneralContent"
    GeneralContent.Size = UDim2.new(1, 0, 1, 0)
    GeneralContent.Position = UDim2.new(0, 0, 0, 0)
    GeneralContent.BackgroundTransparency = 1
    GeneralContent.ScrollBarThickness = 8
    GeneralContent.ScrollBarImageColor3 = UIConfig.AccentColor
    GeneralContent.Parent = self.ContentArea
    
    -- Farming Section
    local FarmingSection = Instance.new("Frame")
    FarmingSection.Name = "FarmingSection"
    FarmingSection.Size = UDim2.new(1, -20, 0, 150)
    FarmingSection.Position = UDim2.new(0, 10, 0, 10)
    FarmingSection.BackgroundColor3 = UIConfig.SecondaryColor
    FarmingSection.BorderSizePixel = 0
    FarmingSection.Parent = GeneralContent
    
    -- Add corner to farming section
    local FarmingCorner = Instance.new("UICorner")
    FarmingCorner.CornerRadius = UDim.new(0, 6)
    FarmingCorner.Parent = FarmingSection
    
    -- Farming Title
    local FarmingTitle = Instance.new("TextLabel")
    FarmingTitle.Name = "FarmingTitle"
    FarmingTitle.Size = UDim2.new(1, 0, 0, 30)
    FarmingTitle.Position = UDim2.new(0, 0, 0, 0)
    FarmingTitle.BackgroundTransparency = 1
    FarmingTitle.Text = "Farming"
    FarmingTitle.TextColor3 = UIConfig.TextColor
    FarmingTitle.TextSize = 16
    FarmingTitle.Font = UIConfig.Font
    FarmingTitle.TextXAlignment = Enum.TextXAlignment.Left
    FarmingTitle.Parent = FarmingSection
    
    -- Add padding to farming title
    local FarmingPadding = Instance.new("UIPadding")
    FarmingPadding.PaddingLeft = UDim.new(0, 10)
    FarmingPadding.Parent = FarmingTitle
    
    -- Auto Farm Level Toggle
    local AutoFarmLevel = self:CreateToggle("Auto Farm Level", UDim2.new(0, 10, 0, 40), FarmingSection)
    Toggles["AutoFarmLevel"] = false
    
    -- Auto Farm Monster Around Toggle
    local AutoFarmMonster = self:CreateToggle("Auto Farm Monster Around", UDim2.new(0, 10, 0, 80), FarmingSection)
    Toggles["AutoFarmMonster"] = false
    
    -- Auto Farm Chest Toggle
    local AutoFarmChest = self:CreateToggle("Auto Farm Chest", UDim2.new(0, 10, 0, 120), FarmingSection)
    Toggles["AutoFarmChest"] = false
    
    -- Bosses Section
    local BossesSection = Instance.new("Frame")
    BossesSection.Name = "BossesSection"
    BossesSection.Size = UDim2.new(1, -20, 0, 200)
    BossesSection.Position = UDim2.new(0, 10, 0, 170)
    BossesSection.BackgroundColor3 = UIConfig.SecondaryColor
    BossesSection.BorderSizePixel = 0
    BossesSection.Parent = GeneralContent
    
    -- Add corner to bosses section
    local BossesCorner = Instance.new("UICorner")
    BossesCorner.CornerRadius = UDim.new(0, 6)
    BossesCorner.Parent = BossesSection
    
    -- Bosses Title
    local BossesTitle = Instance.new("TextLabel")
    BossesTitle.Name = "BossesTitle"
    BossesTitle.Size = UDim2.new(1, 0, 0, 30)
    BossesTitle.Position = UDim2.new(0, 0, 0, 0)
    BossesTitle.BackgroundTransparency = 1
    BossesTitle.Text = "Bosses"
    BossesTitle.TextColor3 = UIConfig.TextColor
    BossesTitle.TextSize = 16
    BossesTitle.Font = UIConfig.Font
    BossesTitle.TextXAlignment = Enum.TextXAlignment.Left
    BossesTitle.Parent = BossesSection
    
    -- Add padding to bosses title
    local BossesPadding = Instance.new("UIPadding")
    BossesPadding.PaddingLeft = UDim.new(0, 10)
    BossesPadding.Parent = BossesTitle
    
    -- Select Boss Dropdown
    local SelectBoss = self:CreateDropdown("Select Boss", {"Dough King", "Cake Prince", "Rip_Indra", "Beautiful Pirate", "Longma", "Soul Reaper", "Smoke Admiral", "Awakened Ice Admiral"}, UDim2.new(0, 10, 0, 40), BossesSection)
    Dropdowns["SelectBoss"] = "Dough King"
    
    -- Auto Farm Boss Toggle
    local AutoFarmBoss = self:CreateToggle("Auto Farm Boss", UDim2.new(0, 10, 0, 80), BossesSection)
    Toggles["AutoFarmBoss"] = false
    
    -- Take Quest Toggle
    local TakeQuest = self:CreateToggle("Take Quest", UDim2.new(0, 10, 0, 120), BossesSection)
    Toggles["TakeQuest"] = false
    
    -- Materials Section
    local MaterialsSection = Instance.new("Frame")
    MaterialsSection.Name = "MaterialsSection"
    MaterialsSection.Size = UDim2.new(1, -20, 0, 150)
    MaterialsSection.Position = UDim2.new(0, 10, 0, 380)
    MaterialsSection.BackgroundColor3 = UIConfig.SecondaryColor
    MaterialsSection.BorderSizePixel = 0
    MaterialsSection.Parent = GeneralContent
    
    -- Add corner to materials section
    local MaterialsCorner = Instance.new("UICorner")
    MaterialsCorner.CornerRadius = UDim.new(0, 6)
    MaterialsCorner.Parent = MaterialsSection
    
    -- Materials Title
    local MaterialsTitle = Instance.new("TextLabel")
    MaterialsTitle.Name = "MaterialsTitle"
    MaterialsTitle.Size = UDim2.new(1, 0, 0, 30)
    MaterialsTitle.Position = UDim2.new(0, 0, 0, 0)
    MaterialsTitle.BackgroundTransparency = 1
    MaterialsTitle.Text = "Materials"
    MaterialsTitle.TextColor3 = UIConfig.TextColor
    MaterialsTitle.TextSize = 16
    MaterialsTitle.Font = UIConfig.Font
    MaterialsTitle.TextXAlignment = Enum.TextXAlignment.Left
    MaterialsTitle.Parent = MaterialsSection
    
    -- Add padding to materials title
    local MaterialsPadding = Instance.new("UIPadding")
    MaterialsPadding.PaddingLeft = UDim.new(0, 10)
    MaterialsPadding.Parent = MaterialsTitle
    
    -- Select Materials Dropdown
    local SelectMaterials = self:CreateDropdown("Select Materials", {"Angel Wings", "Leather", "Scrap Metal", "Magma Ore", "Dragon Scale", "Conjured Cocoa", "Fish Tail", "Mystic Droplet", "Radioactive Material"}, UDim2.new(0, 10, 0, 40), MaterialsSection)
    Dropdowns["SelectMaterials"] = "Angel Wings"
    
    -- Auto Farm Materials Toggle
    local AutoFarmMaterials = self:CreateToggle("Auto Farm Materials", UDim2.new(0, 10, 0, 80), MaterialsSection)
    Toggles["AutoFarmMaterials"] = false
    
    -- Mastery Section
    local MasterySection = Instance.new("Frame")
    MasterySection.Name = "MasterySection"
    MasterySection.Size = UDim2.new(1, -20, 0, 200)
    MasterySection.Position = UDim2.new(0, 10, 0, 540)
    MasterySection.BackgroundColor3 = UIConfig.SecondaryColor
    MasterySection.BorderSizePixel = 0
    MasterySection.Parent = GeneralContent
    
    -- Add corner to mastery section
    local MasteryCorner = Instance.new("UICorner")
    MasteryCorner.CornerRadius = UDim.new(0, 6)
    MasteryCorner.Parent = MasterySection
    
    -- Mastery Title
    local MasteryTitle = Instance.new("TextLabel")
    MasteryTitle.Name = "MasteryTitle"
    MasteryTitle.Size = UDim2.new(1, 0, 0, 30)
    MasteryTitle.Position = UDim2.new(0, 0, 0, 0)
    MasteryTitle.BackgroundTransparency = 1
    MasteryTitle.Text = "Mastery"
    MasteryTitle.TextColor3 = UIConfig.TextColor
    MasteryTitle.TextSize = 16
    MasteryTitle.Font = UIConfig.Font
    MasteryTitle.TextXAlignment = Enum.TextXAlignment.Left
    MasteryTitle.Parent = MasterySection
    
    -- Add padding to mastery title
    local MasteryPadding = Instance.new("UIPadding")
    MasteryPadding.PaddingLeft = UDim.new(0, 10)
    MasteryPadding.Parent = MasteryTitle
    
    -- Auto Mastery Toggle
    local AutoMastery = self:CreateToggle("Auto Mastery", UDim2.new(0, 10, 0, 40), MasterySection)
    Toggles["AutoMastery"] = false
    
    -- Health % Slider
    local HealthSlider = self:CreateSlider("Health %", 0, 100, 25, UDim2.new(0, 10, 0, 80), MasterySection, "last shot enemy with Selected Tool when Enemy Health < Percent")
    Sliders["HealthPercent"] = 25
    
    -- Select Tool Dropdown
    local SelectTool = self:CreateDropdown("Select Tool", {"Blox Fruit", "Sword", "Gun", "Fighting Style"}, UDim2.new(0, 10, 0, 140), MasterySection)
    Dropdowns["SelectTool"] = "Blox Fruit"
    
    -- Set canvas size
    GeneralContent.CanvasSize = UDim2.new(0, 0, 0, 750)
    
    -- Hide initially since General is the default tab
    GeneralContent.Visible = true
end

-- Create Quests/Items Tab
function ScriptHub:CreateQuestsItemsTab()
    local QuestsItemsContent = Instance.new("ScrollingFrame")
    QuestsItemsContent.Name = "Quests/ItemsContent"
    QuestsItemsContent.Size = UDim2.new(1, 0, 1, 0)
    QuestsItemsContent.Position = UDim2.new(0, 0, 0, 0)
    QuestsItemsContent.BackgroundTransparency = 1
    QuestsItemsContent.ScrollBarThickness = 8
    QuestsItemsContent.ScrollBarImageColor3 = UIConfig.AccentColor
    QuestsItemsContent.Parent = self.ContentArea
    
    -- Worlds Section
    local WorldsSection = Instance.new("Frame")
    WorldsSection.Name = "WorldsSection"
    WorldsSection.Size = UDim2.new(1, -20, 0, 120)
    WorldsSection.Position = UDim2.new(0, 10, 0, 10)
    WorldsSection.BackgroundColor3 = UIConfig.SecondaryColor
    WorldsSection.BorderSizePixel = 0
    WorldsSection.Parent = QuestsItemsContent
    
    -- Add corner to worlds section
    local WorldsCorner = Instance.new("UICorner")
    WorldsCorner.CornerRadius = UDim.new(0, 6)
    WorldsCorner.Parent = WorldsSection
    
    -- Worlds Title
    local WorldsTitle = Instance.new("TextLabel")
    WorldsTitle.Name = "WorldsTitle"
    WorldsTitle.Size = UDim2.new(1, 0, 0, 30)
    WorldsTitle.Position = UDim2.new(0, 0, 0, 0)
    WorldsTitle.BackgroundTransparency = 1
    WorldsTitle.Text = "Worlds"
    WorldsTitle.TextColor3 = UIConfig.TextColor
    WorldsTitle.TextSize = 16
    WorldsTitle.Font = UIConfig.Font
    WorldsTitle.TextXAlignment = Enum.TextXAlignment.Left
    WorldsTitle.Parent = WorldsSection
    
    -- Add padding to worlds title
    local WorldsPadding = Instance.new("UIPadding")
    WorldsPadding.PaddingLeft = UDim.new(0, 10)
    WorldsPadding.Parent = WorldsTitle
    
    -- Auto Unlock Dressrosa Toggle
    local AutoUnlockDressrosa = self:CreateToggle("Auto Unlock Dressrosa", UDim2.new(0, 10, 0, 40), WorldsSection)
    Toggles["AutoUnlockDressrosa"] = false
    
    -- Auto Unlock Zou Toggle
    local AutoUnlockZou = self:CreateToggle("Auto Unlock Zou", UDim2.new(0, 10, 0, 80), WorldsSection)
    Toggles["AutoUnlockZou"] = false
    
    -- Fighting Styles Section
    local FightingStylesSection = Instance.new("Frame")
    FightingStylesSection.Name = "FightingStylesSection"
    FightingStylesSection.Size = UDim2.new(1, -20, 0, 300)
    FightingStylesSection.Position = UDim2.new(0, 10, 0, 140)
    FightingStylesSection.BackgroundColor3 = UIConfig.SecondaryColor
    FightingStylesSection.BorderSizePixel = 0
    FightingStylesSection.Parent = QuestsItemsContent
    
    -- Add corner to fighting styles section
    local FightingStylesCorner = Instance.new("UICorner")
    FightingStylesCorner.CornerRadius = UDim.new(0, 6)
    FightingStylesCorner.Parent = FightingStylesSection
    
    -- Fighting Styles Title
    local FightingStylesTitle = Instance.new("TextLabel")
    FightingStylesTitle.Name = "FightingStylesTitle"
    FightingStylesTitle.Size = UDim2.new(1, 0, 0, 30)
    FightingStylesTitle.Position = UDim2.new(0, 0, 0, 0)
    FightingStylesTitle.BackgroundTransparency = 1
    FightingStylesTitle.Text = "Fighting Styles"
    FightingStylesTitle.TextColor3 = UIConfig.TextColor
    FightingStylesTitle.TextSize = 16
    FightingStylesTitle.Font = UIConfig.Font
    FightingStylesTitle.TextXAlignment = Enum.TextXAlignment.Left
    FightingStylesTitle.Parent = FightingStylesSection
    
    -- Add padding to fighting styles title
    local FightingStylesPadding = Instance.new("UIPadding")
    FightingStylesPadding.PaddingLeft = UDim.new(0, 10)
    FightingStylesPadding.Parent = FightingStylesTitle
    
    -- Auto Superhuman Toggle
    local AutoSuperhuman = self:CreateToggle("Auto Superhuman", UDim2.new(0, 10, 0, 40), FightingStylesSection)
    Toggles["AutoSuperhuman"] = false
    
    -- Auto Death Step Toggle
    local AutoDeathStep = self:CreateToggle("Auto Death Step", UDim2.new(0, 10, 0, 70), FightingStylesSection)
    Toggles["AutoDeathStep"] = false
    
    -- Auto Sharkman Karate Toggle
    local AutoSharkmanKarate = self:CreateToggle("Auto Sharkman Karate", UDim2.new(0, 10, 0, 100), FightingStylesSection)
    Toggles["AutoSharkmanKarate"] = false
    
    -- Auto Electric Claw Toggle
    local AutoElectricClaw = self:CreateToggle("Auto Electric Claw", UDim2.new(0, 10, 0, 130), FightingStylesSection)
    Toggles["AutoElectricClaw"] = false
    
    -- Auto Dragon Talon Toggle
    local AutoDragonTalon = self:CreateToggle("Auto Dragon Talon", UDim2.new(0, 10, 0, 160), FightingStylesSection)
    Toggles["AutoDragonTalon"] = false
    
    -- Auto Godhuman Toggle
    local AutoGodhuman = self:CreateToggle("Auto Godhuman", UDim2.new(0, 10, 0, 190), FightingStylesSection)
    Toggles["AutoGodhuman"] = false
    
    -- Swords Section
    local SwordsSection = Instance.new("Frame")
    SwordsSection.Name = "SwordsSection"
    SwordsSection.Size = UDim2.new(1, -20, 0, 100)
    SwordsSection.Position = UDim2.new(0, 10, 0, 450)
    SwordsSection.BackgroundColor3 = UIConfig.SecondaryColor
    SwordsSection.BorderSizePixel = 0
    SwordsSection.Parent = QuestsItemsContent
    
    -- Add corner to swords section
    local SwordsCorner = Instance.new("UICorner")
    SwordsCorner.CornerRadius = UDim.new(0, 6)
    SwordsCorner.Parent = SwordsSection
    
    -- Swords Title
    local SwordsTitle = Instance.new("TextLabel")
    SwordsTitle.Name = "SwordsTitle"
    SwordsTitle.Size = UDim2.new(1, 0, 0, 30)
    SwordsTitle.Position = UDim2.new(0, 0, 0, 0)
    SwordsTitle.BackgroundTransparency = 1
    SwordsTitle.Text = "Swords"
    SwordsTitle.TextColor3 = UIConfig.TextColor
    SwordsTitle.TextSize = 16
    SwordsTitle.Font = UIConfig.Font
    SwordsTitle.TextXAlignment = Enum.TextXAlignment.Left
    SwordsTitle.Parent = SwordsSection
    
    -- Add padding to swords title
    local SwordsPadding = Instance.new("UIPadding")
    SwordsPadding.PaddingLeft = UDim.new(0, 10)
    SwordsPadding.Parent = SwordsTitle
    
    -- Auto Saber Toggle
    local AutoSaber = self:CreateToggle("Auto Saber", UDim2.new(0, 10, 0, 40), SwordsSection)
    Toggles["AutoSaber"] = false
    
    -- Auto Pole Toggle
    local AutoPole = self:CreateToggle("Auto Pole (1st Form)", UDim2.new(0, 10, 0, 70), SwordsSection)
    Toggles["AutoPole"] = false
    
    -- Set canvas size
    QuestsItemsContent.CanvasSize = UDim2.new(0, 0, 0, 560)
    
    -- Hide initially since General is the default tab
    QuestsItemsContent.Visible = false
end

-- Create Stats Tab
function ScriptHub:CreateStatsTab()
    local StatsContent = Instance.new("ScrollingFrame")
    StatsContent.Name = "StatsContent"
    StatsContent.Size = UDim2.new(1, 0, 1, 0)
    StatsContent.Position = UDim2.new(0, 0, 0, 0)
    StatsContent.BackgroundTransparency = 1
    StatsContent.ScrollBarThickness = 8
    StatsContent.ScrollBarImageColor3 = UIConfig.AccentColor
    StatsContent.Parent = self.ContentArea
    
    -- Upgrade Section
    local UpgradeSection = Instance.new("Frame")
    UpgradeSection.Name = "UpgradeSection"
    UpgradeSection.Size = UDim2.new(1, -20, 0, 300)
    UpgradeSection.Position = UDim2.new(0, 10, 0, 10)
    UpgradeSection.BackgroundColor3 = UIConfig.SecondaryColor
    UpgradeSection.BorderSizePixel = 0
    UpgradeSection.Parent = StatsContent
    
    -- Add corner to upgrade section
    local UpgradeCorner = Instance.new("UICorner")
    UpgradeCorner.CornerRadius = UDim.new(0, 6)
    UpgradeCorner.Parent = UpgradeSection
    
    -- Upgrade Title
    local UpgradeTitle = Instance.new("TextLabel")
    UpgradeTitle.Name = "UpgradeTitle"
    UpgradeTitle.Size = UDim2.new(1, 0, 0, 30)
    UpgradeTitle.Position = UDim2.new(0, 0, 0, 0)
    UpgradeTitle.BackgroundTransparency = 1
    UpgradeTitle.Text = "Upgrade"
    UpgradeTitle.TextColor3 = UIConfig.TextColor
    UpgradeTitle.TextSize = 16
    UpgradeTitle.Font = UIConfig.Font
    UpgradeTitle.TextXAlignment = Enum.TextXAlignment.Left
    UpgradeTitle.Parent = UpgradeSection
    
    -- Add padding to upgrade title
    local UpgradePadding = Instance.new("UIPadding")
    UpgradePadding.PaddingLeft = UDim.new(0, 10)
    UpgradePadding.Parent = UpgradeTitle
    
    -- Add Stat Melee + Defense Toggle
    local AddStatMeleeDefense = self:CreateToggle("Add Stat Melee + Defense", UDim2.new(0, 10, 0, 40), UpgradeSection)
    Toggles["AddStatMeleeDefense"] = false
    
    -- Add Stat Defense Toggle
    local AddStatDefense = self:CreateToggle("Add Stat Defense", UDim2.new(0, 10, 0, 70), UpgradeSection)
    Toggles["AddStatDefense"] = false
    
    -- Add Stat Demon Fruit Toggle
    local AddStatDemonFruit = self:CreateToggle("Add Stat Demon Fruit", UDim2.new(0, 10, 0, 100), UpgradeSection)
    Toggles["AddStatDemonFruit"] = false
    
    -- Add Stat Gun Toggle
    local AddStatGun = self:CreateToggle("Add Stat Gun", UDim2.new(0, 10, 0, 130), UpgradeSection)
    Toggles["AddStatGun"] = false
    
    -- Add Stat Melee Toggle
    local AddStatMelee = self:CreateToggle("Add Stat Melee", UDim2.new(0, 10, 0, 160), UpgradeSection)
    Toggles["AddStatMelee"] = false
    
    -- Add Stat Sword Toggle
    local AddStatSword = self:CreateToggle("Add Stat Sword", UDim2.new(0, 10, 0, 190), UpgradeSection)
    Toggles["AddStatSword"] = false
    
    -- Set canvas size
    StatsContent.CanvasSize = UDim2.new(0, 0, 0, 320)
    
    -- Hide initially since General is the default tab
    StatsContent.Visible = false
end

-- Create Fruits Tab
function ScriptHub:CreateFruitsTab()
    local FruitsContent = Instance.new("ScrollingFrame")
    FruitsContent.Name = "FruitsContent"
    FruitsContent.Size = UDim2.new(1, 0, 1, 0)
    FruitsContent.Position = UDim2.new(0, 0, 0, 0)
    FruitsContent.BackgroundTransparency = 1
    FruitsContent.ScrollBarThickness = 8
    FruitsContent.ScrollBarImageColor3 = UIConfig.AccentColor
    FruitsContent.Parent = self.ContentArea
    
    -- Fruits Section
    local FruitsSection = Instance.new("Frame")
    FruitsSection.Name = "FruitsSection"
    FruitsSection.Size = UDim2.new(1, -20, 0, 180)
    FruitsSection.Position = UDim2.new(0, 10, 0, 10)
    FruitsSection.BackgroundColor3 = UIConfig.SecondaryColor
    FruitsSection.BorderSizePixel = 0
    FruitsSection.Parent = FruitsContent
    
    -- Add corner to fruits section
    local FruitsCorner = Instance.new("UICorner")
    FruitsCorner.CornerRadius = UDim.new(0, 6)
    FruitsCorner.Parent = FruitsSection
    
    -- Fruits Title
    local FruitsTitle = Instance.new("TextLabel")
    FruitsTitle.Name = "FruitsTitle"
    FruitsTitle.Size = UDim2.new(1, 0, 0, 30)
    FruitsTitle.Position = UDim2.new(0, 0, 0, 0)
    FruitsTitle.BackgroundTransparency = 1
    FruitsTitle.Text = "Fruits"
    FruitsTitle.TextColor3 = UIConfig.TextColor
    FruitsTitle.TextSize = 16
    FruitsTitle.Font = UIConfig.Font
    FruitsTitle.TextXAlignment = Enum.TextXAlignment.Left
    FruitsTitle.Parent = FruitsSection
    
    -- Add padding to fruits title
    local FruitsPadding = Instance.new("UIPadding")
    FruitsPadding.PaddingLeft = UDim.new(0, 10)
    FruitsPadding.Parent = FruitsTitle
    
    -- Auto Collect Fruits Toggle
    local AutoCollectFruits = self:CreateToggle("Auto Collect Fruits", UDim2.new(0, 10, 0, 40), FruitsSection)
    Toggles["AutoCollectFruits"] = false
    
    -- Auto Random Fruit Toggle
    local AutoRandomFruit = self:CreateToggle("Auto Random Fruit", UDim2.new(0, 10, 0, 80), FruitsSection, "Requirement: Level 50 and money")
    Toggles["AutoRandomFruit"] = false
    
    -- Auto Store Fruit Toggle
    local AutoStoreFruit = self:CreateToggle("Auto Store Fruit", UDim2.new(0, 10, 0, 120), FruitsSection)
    Toggles["AutoStoreFruit"] = false
    
    -- Berries Section
    local BerriesSection = Instance.new("Frame")
    BerriesSection.Name = "BerriesSection"
    BerriesSection.Size = UDim2.new(1, -20, 0, 100)
    BerriesSection.Position = UDim2.new(0, 10, 0, 200)
    BerriesSection.BackgroundColor3 = UIConfig.SecondaryColor
    BerriesSection.BorderSizePixel = 0
    BerriesSection.Parent = FruitsContent
    
    -- Add corner to berries section
    local BerriesCorner = Instance.new("UICorner")
    BerriesCorner.CornerRadius = UDim.new(0, 6)
    BerriesCorner.Parent = BerriesSection
    
    -- Berries Title
    local BerriesTitle = Instance.new("TextLabel")
    BerriesTitle.Name = "BerriesTitle"
    BerriesTitle.Size = UDim2.new(1, 0, 0, 30)
    BerriesTitle.Position = UDim2.new(0, 0, 0, 0)
    BerriesTitle.BackgroundTransparency = 1
    BerriesTitle.Text = "Berries"
    BerriesTitle.TextColor3 = UIConfig.TextColor
    BerriesTitle.TextSize = 16
    BerriesTitle.Font = UIConfig.Font
    BerriesTitle.TextXAlignment = Enum.TextXAlignment.Left
    BerriesTitle.Parent = BerriesSection
    
    -- Add padding to berries title
    local BerriesPadding = Instance.new("UIPadding")
    BerriesPadding.PaddingLeft = UDim.new(0, 10)
    BerriesPadding.Parent = BerriesTitle
    
    -- Auto Collect Berries Toggle
    local AutoCollectBerries = self:CreateToggle("Auto Collect Berries", UDim2.new(0, 10, 0, 40), BerriesSection)
    Toggles["AutoCollectBerries"] = false
    
    -- Set canvas size
    FruitsContent.CanvasSize = UDim2.new(0, 0, 0, 310)
    
    -- Hide initially since General is the default tab
    FruitsContent.Visible = false
end

-- Create Travels Tab
function ScriptHub:CreateTravelsTab()
    local TravelsContent = Instance.new("ScrollingFrame")
    TravelsContent.Name = "TravelsContent"
    TravelsContent.Size = UDim2.new(1, 0, 1, 0)
    TravelsContent.Position = UDim2.new(0, 0, 0, 0)
    TravelsContent.BackgroundTransparency = 1
    TravelsContent.ScrollBarThickness = 8
    TravelsContent.ScrollBarImageColor3 = UIConfig.AccentColor
    TravelsContent.Parent = self.ContentArea
    
    -- Teleport World To Dropdown
    local TeleportWorld = self:CreateDropdown("Teleport World To", {"Sea 1", "Sea 2", "Sea 3"}, UDim2.new(0, 10, 0, 10), TravelsContent)
    Dropdowns["TeleportWorld"] = "Sea 1"
    
    -- Locations Section
    local LocationsSection = Instance.new("Frame")
    LocationsSection.Name = "LocationsSection"
    LocationsSection.Size = UDim2.new(1, -20, 0, 150)
    LocationsSection.Position = UDim2.new(0, 10, 0, 70)
    LocationsSection.BackgroundColor3 = UIConfig.SecondaryColor
    LocationsSection.BorderSizePixel = 0
    LocationsSection.Parent = TravelsContent
    
    -- Add corner to locations section
    local LocationsCorner = Instance.new("UICorner")
    LocationsCorner.CornerRadius = UDim.new(0, 6)
    LocationsCorner.Parent = LocationsSection
    
    -- Locations Title
    local LocationsTitle = Instance.new("TextLabel")
    LocationsTitle.Name = "LocationsTitle"
    LocationsTitle.Size = UDim2.new(1, 0, 0, 30)
    LocationsTitle.Position = UDim2.new(0, 0, 0, 0)
    LocationsTitle.BackgroundTransparency = 1
    LocationsTitle.Text = "Locations"
    LocationsTitle.TextColor3 = UIConfig.TextColor
    LocationsTitle.TextSize = 16
    LocationsTitle.Font = UIConfig.Font
    LocationsTitle.TextXAlignment = Enum.TextXAlignment.Left
    LocationsTitle.Parent = LocationsSection
    
    -- Add padding to locations title
    local LocationsPadding = Instance.new("UIPadding")
    LocationsPadding.PaddingLeft = UDim.new(0, 10)
    LocationsPadding.Parent = LocationsTitle
    
    -- Location Dropdown
    local LocationDropdown = self:CreateDropdown("Location", {"Start Island", "Jungle", "Pirate Village", "Desert", "Snow Island", "Marine Ford", "Colosseum", "Sky Island", "Fountain City", "Shells Town", "Middle Town", "Kingdom of Rose"}, UDim2.new(0, 10, 0, 40), LocationsSection)
    Dropdowns["Location"] = "Start Island"
    
    -- Start Button
    local StartButton = self:CreateButton("Start", UDim2.new(0, 10, 0, 100), LocationsSection)
    Buttons["StartTeleport"] = StartButton
    
    -- Set canvas size
    TravelsContent.CanvasSize = UDim2.new(0, 0, 0, 230)
    
    -- Hide initially since General is the default tab
    TravelsContent.Visible = false
end

-- Create Shop Tab
function ScriptHub:CreateShopTab()
    local ShopContent = Instance.new("ScrollingFrame")
    ShopContent.Name = "ShopContent"
    ShopContent.Size = UDim2.new(1, 0, 1, 0)
    ShopContent.Position = UDim2.new(0, 0, 0, 0)
    ShopContent.BackgroundTransparency = 1
    ShopContent.ScrollBarThickness = 8
    ShopContent.ScrollBarImageColor3 = UIConfig.AccentColor
    ShopContent.Parent = self.ContentArea
    
    -- Fragments Section
    local FragmentsSection = Instance.new("Frame")
    FragmentsSection.Name = "FragmentsSection"
    FragmentsSection.Size = UDim2.new(1, -20, 0, 100)
    FragmentsSection.Position = UDim2.new(0, 10, 0, 10)
    FragmentsSection.BackgroundColor3 = UIConfig.SecondaryColor
    FragmentsSection.BorderSizePixel = 0
    FragmentsSection.Parent = ShopContent
    
    -- Add corner to fragments section
    local FragmentsCorner = Instance.new("UICorner")
    FragmentsCorner.CornerRadius = UDim.new(0, 6)
    FragmentsCorner.Parent = FragmentsSection
    
    -- Fragments Title
    local FragmentsTitle = Instance.new("TextLabel")
    FragmentsTitle.Name = "FragmentsTitle"
    FragmentsTitle.Size = UDim2.new(1, 0, 0, 30)
    FragmentsTitle.Position = UDim2.new(0, 0, 0, 0)
    FragmentsTitle.BackgroundTransparency = 1
    FragmentsTitle.Text = "Fragments"
    FragmentsTitle.TextColor3 = UIConfig.TextColor
    FragmentsTitle.TextSize = 16
    FragmentsTitle.Font = UIConfig.Font
    FragmentsTitle.TextXAlignment = Enum.TextXAlignment.Left
    FragmentsTitle.Parent = FragmentsSection
    
    -- Add padding to fragments title
    local FragmentsPadding = Instance.new("UIPadding")
    FragmentsPadding.PaddingLeft = UDim.new(0, 10)
    FragmentsPadding.Parent = FragmentsTitle
    
    -- Refund Stats Button
    local RefundStatsButton = self:CreateButton("Refund Stats [ƒ 2.5k] →", UDim2.new(0, 10, 0, 40), FragmentsSection)
    Buttons["RefundStats"] = RefundStatsButton
    
    -- Reroll Race Button
    local RerollRaceButton = self:CreateButton("Reroll Race [ƒ 3k] →", UDim2.new(0, 10, 0, 70), FragmentsSection)
    Buttons["RerollRace"] = RerollRaceButton
    
    -- Abilities Section
    local AbilitiesSection = Instance.new("Frame")
    AbilitiesSection.Name = "AbilitiesSection"
    AbilitiesSection.Size = UDim2.new(1, -20, 0, 200)
    AbilitiesSection.Position = UDim2.new(0, 10, 0, 120)
    AbilitiesSection.BackgroundColor3 = UIConfig.SecondaryColor
    AbilitiesSection.BorderSizePixel = 0
    AbilitiesSection.Parent = ShopContent
    
    -- Add corner to abilities section
    local AbilitiesCorner = Instance.new("UICorner")
    AbilitiesCorner.CornerRadius = UDim.new(0, 6)
    AbilitiesCorner.Parent = AbilitiesSection
    
    -- Abilities Title
    local AbilitiesTitle = Instance.new("TextLabel")
    AbilitiesTitle.Name = "AbilitiesTitle"
    AbilitiesTitle.Size = UDim2.new(1, 0, 0, 30)
    AbilitiesTitle.Position = UDim2.new(0, 0, 0, 0)
    AbilitiesTitle.BackgroundTransparency = 1
    AbilitiesTitle.Text = "Abilities"
    AbilitiesTitle.TextColor3 = UIConfig.TextColor
    AbilitiesTitle.TextSize = 16
    AbilitiesTitle.Font = UIConfig.Font
    AbilitiesTitle.TextXAlignment = Enum.TextXAlignment.Left
    AbilitiesTitle.Parent = AbilitiesSection
    
    -- Add padding to abilities title
    local AbilitiesPadding = Instance.new("UIPadding")
    AbilitiesPadding.PaddingLeft = UDim.new(0, 10)
    AbilitiesPadding.Parent = AbilitiesTitle
    
    -- Geppo Button
    local GeppoButton = self:CreateButton("Geppo (10,000) →", UDim2.new(0, 10, 0, 40), AbilitiesSection)
    Buttons["Geppo"] = GeppoButton
    
    -- Buso Button
    local BusoButton = self:CreateButton("Buso (25,000) →", UDim2.new(0, 10, 0, 70), AbilitiesSection)
    Buttons["Buso"] = BusoButton
    
    -- Soru Button
    local SoruButton = self:CreateButton("Soru (100,000) →", UDim2.new(0, 10, 0, 100), AbilitiesSection)
    Buttons["Soru"] = SoruButton
    
    -- Observation Haki Button
    local ObservationHakiButton = self:CreateButton("Observation Haki (750,000) →", UDim2.new(0, 10, 0, 130), AbilitiesSection)
    Buttons["ObservationHaki"] = ObservationHakiButton
    
    -- Fighting Styles Section
    local FightingStylesSection = Instance.new("Frame")
    FightingStylesSection.Name = "FightingStylesSection"
    FightingStylesSection.Size = UDim2.new(1, -20, 0, 400)
    FightingStylesSection.Position = UDim2.new(0, 10, 0, 330)
    FightingStylesSection.BackgroundColor3 = UIConfig.SecondaryColor
    FightingStylesSection.BorderSizePixel = 0
    FightingStylesSection.Parent = ShopContent
    
    -- Add corner to fighting styles section
    local FightingStylesCorner = Instance.new("UICorner")
    FightingStylesCorner.CornerRadius = UDim.new(0, 6)
    FightingStylesCorner.Parent = FightingStylesSection
    
    -- Fighting Styles Title
    local FightingStylesTitle = Instance.new("TextLabel")
    FightingStylesTitle.Name = "FightingStylesTitle"
    FightingStylesTitle.Size = UDim2.new(1, 0, 0, 30)
    FightingStylesTitle.Position = UDim2.new(0, 0, 0, 0)
    FightingStylesTitle.BackgroundTransparency = 1
    FightingStylesTitle.Text = "Fighting Styles"
    FightingStylesTitle.TextColor3 = UIConfig.TextColor
    FightingStylesTitle.TextSize = 16
    FightingStylesTitle.Font = UIConfig.Font
    FightingStylesTitle.TextXAlignment = Enum.TextXAlignment.Left
    FightingStylesTitle.Parent = FightingStylesSection
    
    -- Add padding to fighting styles title
    local FightingStylesPadding = Instance.new("UIPadding")
    FightingStylesPadding.PaddingLeft = UDim.new(0, 10)
    FightingStylesPadding.Parent = FightingStylesTitle
    
    -- Buy Sanguine Art Button
    local BuySanguineArtButton = self:CreateButton("Buy Sanguine Art →", UDim2.new(0, 10, 0, 40), FightingStylesSection)
    Buttons["BuySanguineArt"] = BuySanguineArtButton
    
    -- Buy Godhuman Button
    local BuyGodhumanButton = self:CreateButton("Buy Godhuman →", UDim2.new(0, 10, 0, 70), FightingStylesSection)
    Buttons["BuyGodhuman"] = BuyGodhumanButton
    
    -- Buy Dragon Talon Button
    local BuyDragonTalonButton = self:CreateButton("Buy Dragon Talon →", UDim2.new(0, 10, 0, 100), FightingStylesSection)
    Buttons["BuyDragonTalon"] = BuyDragonTalonButton
    
    -- Buy Electric Claw Button
    local BuyElectricClawButton = self:CreateButton("Buy Electric Claw →", UDim2.new(0, 10, 0, 130), FightingStylesSection)
    Buttons["BuyElectricClaw"] = BuyElectricClawButton
    
    -- Buy Sharkman Karate Button
    local BuySharkmanKarateButton = self:CreateButton("Buy Sharkman Karate →", UDim2.new(0, 10, 0, 160), FightingStylesSection)
    Buttons["BuySharkmanKarate"] = BuySharkmanKarateButton
    
    -- Buy Death Step Button
    local BuyDeathStepButton = self:CreateButton("Buy Death Step →", UDim2.new(0, 10, 0, 190), FightingStylesSection)
    Buttons["BuyDeathStep"] = BuyDeathStepButton
    
    -- Buy Superhuman Button
    local BuySuperhumanButton = self:CreateButton("Buy Superhuman →", UDim2.new(0, 10, 0, 220), FightingStylesSection)
    Buttons["BuySuperhuman"] = BuySuperhumanButton
    
    -- Buy Dragon Claw Button
    local BuyDragonClawButton = self:CreateButton("Buy Dragon Claw →", UDim2.new(0, 10, 0, 250), FightingStylesSection)
    Buttons["BuyDragonClaw"] = BuyDragonClawButton
    
    -- Buy Fishman Karate Button
    local BuyFishmanKarateButton = self:CreateButton("Buy Fishman Karate →", UDim2.new(0, 10, 0, 280), FightingStylesSection)
    Buttons["BuyFishmanKarate"] = BuyFishmanKarateButton
    
    -- Buy Electro Button
    local BuyElectroButton = self:CreateButton("Buy Electro →", UDim2.new(0, 10, 0, 310), FightingStylesSection)
    Buttons["BuyElectro"] = BuyElectroButton
    
    -- Buy Black Leg Button
    local BuyBlackLegButton = self:CreateButton("Buy Black Leg →", UDim2.new(0, 10, 0, 340), FightingStylesSection)
    Buttons["BuyBlackLeg"] = BuyBlackLegButton
    
    -- Races Section
    local RacesSection = Instance.new("Frame")
    RacesSection.Name = "RacesSection"
    RacesSection.Size = UDim2.new(1, -20, 0, 100)
    RacesSection.Position = UDim2.new(0, 10, 0, 740)
    RacesSection.BackgroundColor3 = UIConfig.SecondaryColor
    RacesSection.BorderSizePixel = 0
    RacesSection.Parent = ShopContent
    
    -- Add corner to races section
    local RacesCorner = Instance.new("UICorner")
    RacesCorner.CornerRadius = UDim.new(0, 6)
    RacesCorner.Parent = RacesSection
    
    -- Races Title
    local RacesTitle = Instance.new("TextLabel")
    RacesTitle.Name = "RacesTitle"
    RacesTitle.Size = UDim2.new(1, 0, 0, 30)
    RacesTitle.Position = UDim2.new(0, 0, 0, 0)
    RacesTitle.BackgroundTransparency = 1
    RacesTitle.Text = "Races"
    RacesTitle.TextColor3 = UIConfig.TextColor
    RacesTitle.TextSize = 16
    RacesTitle.Font = UIConfig.Font
    RacesTitle.TextXAlignment = Enum.TextXAlignment.Left
    RacesTitle.Parent = RacesSection
    
    -- Add padding to races title
    local RacesPadding = Instance.new("UIPadding")
    RacesPadding.PaddingLeft = UDim.new(0, 10)
    RacesPadding.Parent = RacesTitle
    
    -- Cyborg Button
    local CyborgButton = self:CreateButton("Cyborg →", UDim2.new(0, 10, 0, 40), RacesSection)
    Buttons["Cyborg"] = CyborgButton
    
    -- Ghoul Button
    local GhoulButton = self:CreateButton("Ghoul →", UDim2.new(0, 10, 0, 70), RacesSection)
    Buttons["Ghoul"] = GhoulButton
    
    -- Set canvas size
    ShopContent.CanvasSize = UDim2.new(0, 0, 0, 850)
    
    -- Hide initially since General is the default tab
    ShopContent.Visible = false
end

-- Create Miscellaneous Tab
function ScriptHub:CreateMiscellaneousTab()
    local MiscellaneousContent = Instance.new("ScrollingFrame")
    MiscellaneousContent.Name = "MiscellaneousContent"
    MiscellaneousContent.Size = UDim2.new(1, 0, 1, 0)
    MiscellaneousContent.Position = UDim2.new(0, 0, 0, 0)
    MiscellaneousContent.BackgroundTransparency = 1
    MiscellaneousContent.ScrollBarThickness = 8
    MiscellaneousContent.ScrollBarImageColor3 = UIConfig.AccentColor
    MiscellaneousContent.Parent = self.ContentArea
    
    -- Walk On Water Toggle (enabled by default)
    local WalkOnWater = self:CreateToggle("Walk On Water", UDim2.new(0, 10, 0, 10), MiscellaneousContent)
    Toggles["WalkOnWater"] = true
    WalkOnWater.Toggle.BackgroundColor3 = UIConfig.AccentColor
    WalkOnWater.Toggle.Position = UDim2.new(0, 0, 0.5, -10)
    
    -- Redeem All Codes Button
    local RedeemAllCodesButton = self:CreateButton("Redeem All Codes →", UDim2.new(0, 10, 0, 60), MiscellaneousContent)
    Buttons["RedeemAllCodes"] = RedeemAllCodesButton
    
    -- Server Section
    local ServerSection = Instance.new("Frame")
    ServerSection.Name = "ServerSection"
    ServerSection.Size = UDim2.new(1, -20, 0, 120)
    ServerSection.Position = UDim2.new(0, 10, 0, 110)
    ServerSection.BackgroundColor3 = UIConfig.SecondaryColor
    ServerSection.BorderSizePixel = 0
    ServerSection.Parent = MiscellaneousContent
    
    -- Add corner to server section
    local ServerCorner = Instance.new("UICorner")
    ServerCorner.CornerRadius = UDim.new(0, 6)
    ServerCorner.Parent = ServerSection
    
    -- Server Title
    local ServerTitle = Instance.new("TextLabel")
    ServerTitle.Name = "ServerTitle"
    ServerTitle.Size = UDim2.new(1, 0, 0, 30)
    ServerTitle.Position = UDim2.new(0, 0, 0, 0)
    ServerTitle.BackgroundTransparency = 1
    ServerTitle.Text = "Server"
    ServerTitle.TextColor3 = UIConfig.TextColor
    ServerTitle.TextSize = 16
    ServerTitle.Font = UIConfig.Font
    ServerTitle.TextXAlignment = Enum.TextXAlignment.Left
    ServerTitle.Parent = ServerSection
    
    -- Add padding to server title
    local ServerPadding = Instance.new("UIPadding")
    ServerPadding.PaddingLeft = UDim.new(0, 10)
    ServerPadding.Parent = ServerTitle
    
    -- Rejoin Server Button
    local RejoinServerButton = self:CreateButton("Rejoin Server →", UDim2.new(0, 10, 0, 40), ServerSection)
    Buttons["RejoinServer"] = RejoinServerButton
    
    -- Hop Server Button
    local HopServerButton = self:CreateButton("Hop Server →", UDim2.new(0, 10, 0, 70), ServerSection)
    Buttons["HopServer"] = HopServerButton
    
    -- Set canvas size
    MiscellaneousContent.CanvasSize = UDim2.new(0, 0, 0, 240)
    
    -- Hide initially since General is the default tab
    MiscellaneousContent.Visible = false
end

-- Create Settings Tab
function ScriptHub:CreateSettingsTab()
    local SettingsContent = Instance.new("ScrollingFrame")
    SettingsContent.Name = "SettingsContent"
    SettingsContent.Size = UDim2.new(1, 0, 1, 0)
    SettingsContent.Position = UDim2.new(0, 0, 0, 0)
    SettingsContent.BackgroundTransparency = 1
    SettingsContent.ScrollBarThickness = 8
    SettingsContent.ScrollBarImageColor3 = UIConfig.AccentColor
    SettingsContent.Parent = self.ContentArea
    
    -- Configurations Section
    local ConfigurationsSection = Instance.new("Frame")
    ConfigurationsSection.Name = "ConfigurationsSection"
    ConfigurationsSection.Size = UDim2.new(1, -20, 0, 150)
    ConfigurationsSection.Position = UDim2.new(0, 10, 0, 10)
    ConfigurationsSection.BackgroundColor3 = UIConfig.SecondaryColor
    ConfigurationsSection.BorderSizePixel = 0
    ConfigurationsSection.Parent = SettingsContent
    
    -- Add corner to configurations section
    local ConfigurationsCorner = Instance.new("UICorner")
    ConfigurationsCorner.CornerRadius = UDim.new(0, 6)
    ConfigurationsCorner.Parent = ConfigurationsSection
    
    -- Configurations Title
    local ConfigurationsTitle = Instance.new("TextLabel")
    ConfigurationsTitle.Name = "ConfigurationsTitle"
    ConfigurationsTitle.Size = UDim2.new(1, 0, 0, 30)
    ConfigurationsTitle.Position = UDim2.new(0, 0, 0, 0)
    ConfigurationsTitle.BackgroundTransparency = 1
    ConfigurationsTitle.Text = "Configurations"
    ConfigurationsTitle.TextColor3 = UIConfig.TextColor
    ConfigurationsTitle.TextSize = 16
    ConfigurationsTitle.Font = UIConfig.Font
    ConfigurationsTitle.TextXAlignment = Enum.TextXAlignment.Left
    ConfigurationsTitle.Parent = ConfigurationsSection
    
    -- Add padding to configurations title
    local ConfigurationsPadding = Instance.new("UIPadding")
    ConfigurationsPadding.PaddingLeft = UDim.new(0, 10)
    ConfigurationsPadding.Parent = ConfigurationsTitle
    
    -- Primary Weapon Dropdown
    local PrimaryWeapon = self:CreateDropdown("Primary Weapon", {"Melee", "Sword", "Gun", "Blox Fruit"}, UDim2.new(0, 10, 0, 40), ConfigurationsSection)
    Dropdowns["PrimaryWeapon"] = "Melee"
    
    -- Auto Active Aura Toggle (enabled by default)
    local AutoActiveAura = self:CreateToggle("Auto Active Aura", UDim2.new(0, 10, 0, 80), ConfigurationsSection)
    Toggles["AutoActiveAura"] = true
    AutoActiveAura.Toggle.BackgroundColor3 = UIConfig.AccentColor
    AutoActiveAura.Toggle.Position = UDim2.new(0, 0, 0.5, -10)
    
    -- Performance Section
    local PerformanceSection = Instance.new("Frame")
    PerformanceSection.Name = "PerformanceSection"
    PerformanceSection.Size = UDim2.new(1, -20, 0, 120)
    PerformanceSection.Position = UDim2.new(0, 10, 0, 170)
    PerformanceSection.BackgroundColor3 = UIConfig.SecondaryColor
    PerformanceSection.BorderSizePixel = 0
    PerformanceSection.Parent = SettingsContent
    
    -- Add corner to performance section
    local PerformanceCorner = Instance.new("UICorner")
    PerformanceCorner.CornerRadius = UDim.new(0, 6)
    PerformanceCorner.Parent = PerformanceSection
    
    -- Performance Title
    local PerformanceTitle = Instance.new("TextLabel")
    PerformanceTitle.Name = "PerformanceTitle"
    PerformanceTitle.Size = UDim2.new(1, 0, 0, 30)
    PerformanceTitle.Position = UDim2.new(0, 0, 0, 0)
    PerformanceTitle.BackgroundTransparency = 1
    PerformanceTitle.Text = "Performance"
    PerformanceTitle.TextColor3 = UIConfig.TextColor
    PerformanceTitle.TextSize = 16
    PerformanceTitle.Font = UIConfig.Font
    PerformanceTitle.TextXAlignment = Enum.TextXAlignment.Left
    PerformanceTitle.Parent = PerformanceSection
    
    -- Add padding to performance title
    local PerformancePadding = Instance.new("UIPadding")
    PerformancePadding.PaddingLeft = UDim.new(0, 10)
    PerformancePadding.Parent = PerformanceTitle
    
    -- Disabled Notification Toggle
    local DisabledNotification = self:CreateToggle("Disabled Notification", UDim2.new(0, 10, 0, 40), PerformanceSection)
    Toggles["DisabledNotification"] = false
    
    -- Disabled Damage Indicator Toggle
    local DisabledDamageIndicator = self:CreateToggle("Disabled Damage Indicator", UDim2.new(0, 10, 0, 80), PerformanceSection)
    Toggles["DisabledDamageIndicator"] = false
    
    -- General Settings Section
    local GeneralSettingsSection = Instance.new("Frame")
    GeneralSettingsSection.Name = "GeneralSettingsSection"
    GeneralSettingsSection.Size = UDim2.new(1, -20, 0, 100)
    GeneralSettingsSection.Position = UDim2.new(0, 10, 0, 300)
    GeneralSettingsSection.BackgroundColor3 = UIConfig.SecondaryColor
    GeneralSettingsSection.BorderSizePixel = 0
    GeneralSettingsSection.Parent = SettingsContent
    
    -- Add corner to general settings section
    local GeneralSettingsCorner = Instance.new("UICorner")
    GeneralSettingsCorner.CornerRadius = UDim.new(0, 6)
    GeneralSettingsCorner.Parent = GeneralSettingsSection
    
    -- General Settings Title
    local GeneralSettingsTitle = Instance.new("TextLabel")
    GeneralSettingsTitle.Name = "GeneralSettingsTitle"
    GeneralSettingsTitle.Size = UDim2.new(1, 0, 0, 30)
    GeneralSettingsTitle.Position = UDim2.new(0, 0, 0, 0)
    GeneralSettingsTitle.BackgroundTransparency = 1
    GeneralSettingsTitle.Text = "General Settings"
    GeneralSettingsTitle.TextColor3 = UIConfig.TextColor
    GeneralSettingsTitle.TextSize = 16
    GeneralSettingsTitle.Font = UIConfig.Font
    GeneralSettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
    GeneralSettingsTitle.Parent = GeneralSettingsSection
    
    -- Add padding to general settings title
    local GeneralSettingsPadding = Instance.new("UIPadding")
    GeneralSettingsPadding.PaddingLeft = UDim.new(0, 10)
    GeneralSettingsPadding.Parent = GeneralSettingsTitle
    
    -- Anti Idle Kick Toggle (enabled by default)
    local AntiIdleKick = self:CreateToggle("Anti Idle Kick", UDim2.new(0, 10, 0, 40), GeneralSettingsSection)
    Toggles["AntiIdleKick"] = true
    AntiIdleKick.Toggle.BackgroundColor3 = UIConfig.AccentColor
    AntiIdleKick.Toggle.Position = UDim2.new(0, 0, 0.5, -10)
    
    -- Interface Section
    local InterfaceSection = Instance.new("Frame")
    InterfaceSection.Name = "InterfaceSection"
    InterfaceSection.Size = UDim2.new(1, -20, 0, 180)
    InterfaceSection.Position = UDim2.new(0, 10, 0, 410)
    InterfaceSection.BackgroundColor3 = UIConfig.SecondaryColor
    InterfaceSection.BorderSizePixel = 0
    InterfaceSection.Parent = SettingsContent
    
    -- Add corner to interface section
    local InterfaceCorner = Instance.new("UICorner")
    InterfaceCorner.CornerRadius = UDim.new(0, 6)
    InterfaceCorner.Parent = InterfaceSection
    
    -- Interface Title
    local InterfaceTitle = Instance.new("TextLabel")
    InterfaceTitle.Name = "InterfaceTitle"
    InterfaceTitle.Size = UDim2.new(1, 0, 0, 30)
    InterfaceTitle.Position = UDim2.new(0, 0, 0, 0)
    InterfaceTitle.BackgroundTransparency = 1
    InterfaceTitle.Text = "Interface"
    InterfaceTitle.TextColor3 = UIConfig.TextColor
    InterfaceTitle.TextSize = 16
    InterfaceTitle.Font = UIConfig.Font
    InterfaceTitle.TextXAlignment = Enum.TextXAlignment.Left
    InterfaceTitle.Parent = InterfaceSection
    
    -- Add padding to interface title
    local InterfacePadding = Instance.new("UIPadding")
    InterfacePadding.PaddingLeft = UDim.new(0, 10)
    InterfacePadding.Parent = InterfaceTitle
    
    -- Theme Dropdown
    local Theme = self:CreateDropdown("Theme", {"Vynixu", "Default", "Dark", "Light"}, UDim2.new(0, 10, 0, 40), InterfaceSection)
    Dropdowns["Theme"] = "Vynixu"
    
    -- Transparency Toggle (enabled by default)
    local Transparency = self:CreateToggle("Transparency", UDim2.new(0, 10, 0, 80), InterfaceSection, "Makes the interface transparent")
    Toggles["Transparency"] = true
    Transparency.Toggle.BackgroundColor3 = UIConfig.AccentColor
    Transparency.Toggle.Position = UDim2.new(0, 0, 0.5, -10)
    
    -- Minimize Bind Label
    local MinimizeBindLabel = Instance.new("TextLabel")
    MinimizeBindLabel.Name = "MinimizeBindLabel"
    MinimizeBindLabel.Size = UDim2.new(1, -20, 0, 30)
    MinimizeBindLabel.Position = UDim2.new(0, 10, 0, 120)
    MinimizeBindLabel.BackgroundTransparency = 1
    MinimizeBindLabel.Text = "Minimize Bind: M"
    MinimizeBindLabel.TextColor3 = UIConfig.TextColor
    MinimizeBindLabel.TextSize = 14
    MinimizeBindLabel.Font = UIConfig.Font
    MinimizeBindLabel.TextXAlignment = Enum.TextXAlignment.Left
    MinimizeBindLabel.Parent = InterfaceSection
    
    -- Set canvas size
    SettingsContent.CanvasSize = UDim2.new(0, 0, 0, 600)
    
    -- Hide initially since General is the default tab
    SettingsContent.Visible = false
end

-- Create Toggle
function ScriptHub:CreateToggle(text, position, parent, description)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text .. "Frame"
    ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
    ToggleFrame.Position = position
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    -- Toggle Label
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "ToggleLabel"
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = UIConfig.TextColor
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = UIConfig.Font
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.TextYAlignment = Enum.TextYAlignment.Center
    ToggleLabel.Parent = ToggleFrame
    
    -- Toggle Button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Toggle"
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -40, 0.5, -10)
    ToggleButton.BackgroundColor3 = UIConfig.SecondaryColor
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    -- Add corner to toggle button
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleButton
    
    -- Toggle Indicator
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Name = "Indicator"
    ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
    ToggleIndicator.BackgroundColor3 = UIConfig.TextColor
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Parent = ToggleButton
    
    -- Add corner to toggle indicator
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(0, 8)
    IndicatorCorner.Parent = ToggleIndicator
    
    -- Description
    if description then
        local DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Size = UDim2.new(1, -50, 0, 15)
        DescriptionLabel.Position = UDim2.new(0, 0, 1, 0)
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Text = description
        DescriptionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        DescriptionLabel.TextSize = 10
        DescriptionLabel.Font = UIConfig.Font
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
        DescriptionLabel.TextTransparency = 0.5
        DescriptionLabel.Parent = ToggleFrame
    end
    
    -- Toggle functionality
    local toggled = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        Toggles[text] = toggled
        
        if toggled then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = UIConfig.AccentColor}):Play()
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -18, 0, 2)}):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = UIConfig.SecondaryColor}):Play()
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0, 2)}):Play()
        end
    end)
    
    return ToggleFrame
end

-- Create Dropdown
function ScriptHub:CreateDropdown(text, options, position, parent)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = text .. "Dropdown"
    DropdownFrame.Size = UDim2.new(1, -20, 0, 30)
    DropdownFrame.Position = position
    DropdownFrame.BackgroundColor3 = UIConfig.SecondaryColor
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = parent
    
    -- Add corner to dropdown frame
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = DropdownFrame
    
    -- Dropdown Label
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Name = "DropdownLabel"
    DropdownLabel.Size = UDim2.new(0, 150, 1, 0)
    DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = text
    DropdownLabel.TextColor3 = UIConfig.TextColor
    DropdownLabel.TextSize = 14
    DropdownLabel.Font = UIConfig.Font
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.TextYAlignment = Enum.TextYAlignment.Center
    DropdownLabel.Parent = DropdownFrame
    
    -- Dropdown Button
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "DropdownButton"
    DropdownButton.Size = UDim2.new(1, -160, 1, 0)
    DropdownButton.Position = UDim2.new(0, 160, 0, 0)
    DropdownButton.BackgroundColor3 = UIConfig.MainColor
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = options[1]
    DropdownButton.TextColor3 = UIConfig.TextColor
    DropdownButton.TextSize = 14
    DropdownButton.Font = UIConfig.Font
    DropdownButton.Parent = DropdownFrame
    
    -- Add corner to dropdown button
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = DropdownButton
    
    -- Dropdown Arrow
    local DropdownArrow = Instance.new("TextLabel")
    DropdownArrow.Name = "DropdownArrow"
    DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
    DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
    DropdownArrow.BackgroundTransparency = 1
    DropdownArrow.Text = "▼"
    DropdownArrow.TextColor3 = UIConfig.TextColor
    DropdownArrow.TextSize = 14
    DropdownArrow.Font = UIConfig.Font
    DropdownArrow.TextXAlignment = Enum.TextXAlignment.Center
    DropdownArrow.TextYAlignment = Enum.TextYAlignment.Center
    DropdownArrow.Parent = DropdownButton
    
    -- Options Container
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Name = "OptionsContainer"
    OptionsContainer.Size = UDim2.new(1, -160, 0, 0)
    OptionsContainer.Position = UDim2.new(0, 160, 1, 0)
    OptionsContainer.BackgroundColor3 = UIConfig.MainColor
    OptionsContainer.BorderSizePixel = 0
    OptionsContainer.Visible = false
    OptionsContainer.Parent = DropdownFrame
    
    -- Add corner to options container
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 4)
    OptionsCorner.Parent = OptionsContainer
    
    -- Create options
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Name = "Option" .. i
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        OptionButton.BackgroundColor3 = UIConfig.MainColor
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = option
        OptionButton.TextColor3 = UIConfig.TextColor
        OptionButton.TextSize = 14
        OptionButton.Font = UIConfig.Font
        OptionButton.Parent = OptionsContainer
        
        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = option
            Dropdowns[text] = option
            OptionsContainer.Visible = false
            DropdownArrow.Text = "▼"
        end)
        
        OptionButton.MouseEnter:Connect(function()
            OptionButton.BackgroundColor3 = UIConfig.SecondaryColor
        end)
        
        OptionButton.MouseLeave:Connect(function()
            OptionButton.BackgroundColor3 = UIConfig.MainColor
        end)
    end
    
    -- Dropdown functionality
    local isOpen = false
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            OptionsContainer.Visible = true
            OptionsContainer:TweenSize(UDim2.new(1, -160, 0, #options * 30), "Out", "Quad", 0.2, true)
            DropdownArrow.Text = "▲"
        else
            OptionsContainer:TweenSize(UDim2.new(1, -160, 0, 0), "Out", "Quad", 0.2, true)
            DropdownArrow.Text = "▼"
            wait(0.2)
            OptionsContainer.Visible = false
        end
    end)
    
    return DropdownFrame
end

-- Create Slider
function ScriptHub:CreateSlider(text, min, max, default, position, parent, description)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = text .. "Slider"
    SliderFrame.Size = UDim2.new(1, -20, 0, 60)
    SliderFrame.Position = position
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent
    
    -- Slider Label
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "SliderLabel"
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.Position = UDim2.new(0, 0, 0, 0)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = text .. ": " .. default
    SliderLabel.TextColor3 = UIConfig.TextColor
    SliderLabel.TextSize = 14
    SliderLabel.Font = UIConfig.Font
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.TextYAlignment = Enum.TextYAlignment.Top
    SliderLabel.Parent = SliderFrame
    
    -- Slider Track
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "SliderTrack"
    SliderTrack.Size = UDim2.new(1, 0, 0, 10)
    SliderTrack.Position = UDim2.new(0, 0, 0, 25)
    SliderTrack.BackgroundColor3 = UIConfig.SecondaryColor
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderFrame
    
    -- Add corner to slider track
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 5)
    TrackCorner.Parent = SliderTrack
    
    -- Slider Fill
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    SliderFill.BackgroundColor3 = UIConfig.AccentColor
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    
    -- Add corner to slider fill
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 5)
    FillCorner.Parent = SliderFill
    
    -- Slider Button
    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "SliderButton"
    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -10, 0, -5)
    SliderButton.BackgroundColor3 = UIConfig.AccentColor
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.ZIndex = 2
    SliderButton.Parent = SliderTrack
    
    -- Add corner to slider button
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = SliderButton
    
    -- Description
    if description then
        local DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Size = UDim2.new(1, 0, 0, 15)
        DescriptionLabel.Position = UDim2.new(0, 0, 1, 0)
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Text = description
        DescriptionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        DescriptionLabel.TextSize = 10
        DescriptionLabel.Font = UIConfig.Font
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
        DescriptionLabel.TextTransparency = 0.5
        DescriptionLabel.Parent = SliderFrame
    end
    
    -- Slider functionality
    local dragging = false
    local value = default
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = SliderTrack.AbsolutePosition
            local trackSize = SliderTrack.AbsoluteSize
            
            local percent = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            value = math.floor(min + percent * (max - min))
            
            SliderFill:TweenSize(UDim2.new(percent, 0, 1, 0), "Out", "Quad", 0.1, true)
            SliderButton:TweenPosition(UDim2.new(percent, -10, 0, -5), "Out", "Quad", 0.1, true)
            SliderLabel.Text = text .. ": " .. value
            
            Sliders[text] = value
        end
    end)
    
    return SliderFrame
end

-- Create Button
function ScriptHub:CreateButton(text, position, parent)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = text .. "Button"
    ButtonFrame.Size = UDim2.new(1, -20, 0, 30)
    ButtonFrame.Position = position
    ButtonFrame.BackgroundColor3 = UIConfig.SecondaryColor
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = parent
    
    -- Add corner to button frame
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ButtonFrame
    
    -- Button
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Position = UDim2.new(0, 0, 0, 0)
    Button.BackgroundColor3 = UIConfig.AccentColor
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = UIConfig.TextColor
    Button.TextSize = 14
    Button.Font = UIConfig.Font
    Button.Parent = ButtonFrame
    
    -- Add corner to button
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    -- Button hover effect
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = UIConfig.AccentColor}):Play()
    end)
    
    return ButtonFrame
end

-- ESP System
function ScriptHub:CreateESP()
    local ESPContainer = Instance.new("Folder")
    ESPContainer.Name = "ESPContainer"
    ESPContainer.Parent = game.CoreGui
    
    -- Player ESP
    local function CreatePlayerESP(player)
        if player == LocalPlayer then return end
        
        local Character = player.Character or player.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not Humanoid or not HumanoidRootPart then return end
        
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = player.Name .. "ESP"
        BillboardGui.Adornee = HumanoidRootPart
        BillboardGui.Size = UDim2.new(0, 100, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Parent = ESPContainer
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "PlayerInfo"
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = player.Name .. " [" .. player.Data.Level.Value .. "]"
        TextLabel.TextColor3 = Color3.new(1, 1, 1)
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        TextLabel.TextScaled = true
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Parent = BillboardGui
        
        -- Highlight
        local Highlight = Instance.new("Highlight")
        Highlight.Name = player.Name .. "Highlight"
        Highlight.Adornee = Character
        Highlight.FillColor = Color3.new(0, 1, 0)
        Highlight.FillTransparency = 0.5
        Highlight.OutlineColor = Color3.new(0, 1, 0)
        Highlight.OutlineTransparency = 0
        Highlight.Parent = ESPContainer
        
        return BillboardGui, Highlight
    end
    
    -- Fruit ESP
    local function CreateFruitESP(fruit)
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = fruit.Name .. "ESP"
        BillboardGui.Adornee = fruit
        BillboardGui.Size = UDim2.new(0, 100, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Parent = ESPContainer
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "FruitInfo"
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = fruit.Name
        TextLabel.TextColor3 = Color3.new(1, 0.5, 0)
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        TextLabel.TextScaled = true
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Parent = BillboardGui
        
        -- Highlight
        local Highlight = Instance.new("Highlight")
        Highlight.Name = fruit.Name .. "Highlight"
        Highlight.Adornee = fruit
        Highlight.FillColor = Color3.new(1, 0.5, 0)
        Highlight.FillTransparency = 0.5
        Highlight.OutlineColor = Color3.new(1, 0.5, 0)
        Highlight.OutlineTransparency = 0
        Highlight.Parent = ESPContainer
        
        return BillboardGui, Highlight
    end
    
    -- Enemy ESP
    local function CreateEnemyESP(enemy)
        local Humanoid = enemy:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = enemy:FindFirstChild("HumanoidRootPart")
        
        if not Humanoid or not HumanoidRootPart then return end
        
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = enemy.Name .. "ESP"
        BillboardGui.Adornee = HumanoidRootPart
        BillboardGui.Size = UDim2.new(0, 100, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Parent = ESPContainer
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "EnemyInfo"
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = enemy.Name .. " [" .. math.floor(Humanoid.Health) .. "/" .. math.floor(Humanoid.MaxHealth) .. "]"
        TextLabel.TextColor3 = Color3.new(1, 0, 0)
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        TextLabel.TextScaled = true
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Parent = BillboardGui
        
        -- Health Bar
        local HealthBar = Instance.new("Frame")
        HealthBar.Name = "HealthBar"
        HealthBar.Size = UDim2.new(1, 0, 0, 10)
        HealthBar.Position = UDim2.new(0, 0, 1, 0)
        HealthBar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        HealthBar.BorderSizePixel = 0
        HealthBar.Parent = TextLabel
        
        local HealthFill = Instance.new("Frame")
        HealthFill.Name = "HealthFill"
        HealthFill.Size = UDim2.new(Humanoid.Health / Humanoid.MaxHealth, 0, 1, 0)
        HealthFill.Position = UDim2.new(0, 0, 0, 0)
        HealthFill.BackgroundColor3 = Color3.new(1, 0, 0)
        HealthFill.BorderSizePixel = 0
        HealthFill.Parent = HealthBar
        
        -- Highlight
        local Highlight = Instance.new("Highlight")
        Highlight.Name = enemy.Name .. "Highlight"
        Highlight.Adornee = enemy
        Highlight.FillColor = Color3.new(1, 0, 0)
        Highlight.FillTransparency = 0.5
        Highlight.OutlineColor = Color3.new(1, 0, 0)
        Highlight.OutlineTransparency = 0
        Highlight.Parent = ESPContainer
        
        -- Update health bar
        local function UpdateHealth()
            if Humanoid and HealthFill then
                HealthFill:TweenSize(UDim2.new(Humanoid.Health / Humanoid.MaxHealth, 0, 1, 0), "Out", "Quad", 0.1, true)
            end
        end
        
        Humanoid.HealthChanged:Connect(UpdateHealth)
        
        return BillboardGui, Highlight
    end
    
    -- Quest Giver ESP
    local function CreateQuestGiverESP(questGiver)
        local HumanoidRootPart = questGiver:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = questGiver.Name .. "ESP"
        BillboardGui.Adornee = HumanoidRootPart
        BillboardGui.Size = UDim2.new(0, 100, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Parent = ESPContainer
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "QuestGiverInfo"
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = "Quest: " .. questGiver.Name
        TextLabel.TextColor3 = Color3.new(0, 1, 1)
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        TextLabel.TextScaled = true
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Parent = BillboardGui
        
        -- Highlight
        local Highlight = Instance.new("Highlight")
        Highlight.Name = questGiver.Name .. "Highlight"
        Highlight.Adornee = questGiver
        Highlight.FillColor = Color3.new(0, 1, 1)
        Highlight.FillTransparency = 0.5
        Highlight.OutlineColor = Color3.new(0, 1, 1)
        Highlight.OutlineTransparency = 0
        Highlight.Parent = ESPContainer
        
        return BillboardGui, Highlight
    end
    
    -- Chest ESP
    local function CreateChestESP(chest)
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = chest.Name .. "ESP"
        BillboardGui.Adornee = chest
        BillboardGui.Size = UDim2.new(0, 100, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Parent = ESPContainer
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "ChestInfo"
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = "Chest"
        TextLabel.TextColor3 = Color3.new(1, 1, 0)
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        TextLabel.TextScaled = true
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Parent = BillboardGui
        
        -- Highlight
        local Highlight = Instance.new("Highlight")
        Highlight.Name = chest.Name .. "Highlight"
        Highlight.Adornee = chest
        Highlight.FillColor = Color3.new(1, 1, 0)
        Highlight.FillTransparency = 0.5
        Highlight.OutlineColor = Color3.new(1, 1, 0)
        Highlight.OutlineTransparency = 0
        Highlight.Parent = ESPContainer
        
        return BillboardGui, Highlight
    end
    
    -- Material ESP
    local function CreateMaterialESP(material)
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = material.Name .. "ESP"
        BillboardGui.Adornee = material
        BillboardGui.Size = UDim2.new(0, 100, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Parent = ESPContainer
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "MaterialInfo"
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = material.Name
        TextLabel.TextColor3 = Color3.new(0.5, 0, 1)
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        TextLabel.TextScaled = true
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Parent = BillboardGui
        
        -- Highlight
        local Highlight = Instance.new("Highlight")
        Highlight.Name = material.Name .. "Highlight"
        Highlight.Adornee = material
        Highlight.FillColor = Color3.new(0.5, 0, 1)
        Highlight.FillTransparency = 0.5
        Highlight.OutlineColor = Color3.new(0.5, 0, 1)
        Highlight.OutlineTransparency = 0
        Highlight.Parent = ESPContainer
        
        return BillboardGui, Highlight
    end
    
    -- Toggle ESP
    local function ToggleESP(enable)
        if enable then
            -- Player ESP
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    CreatePlayerESP(player)
                end
            end
            
            Players.PlayerAdded:Connect(function(player)
                if player ~= LocalPlayer then
                    CreatePlayerESP(player)
                end
            end)
            
            -- Fruit ESP
            for _, fruit in ipairs(workspace:GetChildren()) do
                if fruit:FindFirstChild("Fruit") then
                    CreateFruitESP(fruit)
                end
            end
            
            workspace.ChildAdded:Connect(function(child)
                if child:FindFirstChild("Fruit") then
                    CreateFruitESP(child)
                end
            end)
            
            -- Enemy ESP
            for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
                CreateEnemyESP(enemy)
            end
            
            workspace.Enemies.ChildAdded:Connect(function(enemy)
                CreateEnemyESP(enemy)
            end)
            
            -- Quest Giver ESP
            for _, questGiver in ipairs(workspace.NPC:GetChildren()) do
                if questGiver:FindFirstChild("Quest") then
                    CreateQuestGiverESP(questGiver)
                end
            end
            
            workspace.NPC.ChildAdded:Connect(function(questGiver)
                if questGiver:FindFirstChild("Quest") then
                    CreateQuestGiverESP(questGiver)
                end
            end)
            
            -- Chest ESP
            for _, chest in ipairs(workspace:GetChildren()) do
                if chest.Name:find("Chest") then
                    CreateChestESP(chest)
                end
            end
            
            workspace.ChildAdded:Connect(function(child)
                if child.Name:find("Chest") then
                    CreateChestESP(child)
                end
            end)
            
            -- Material ESP
            for _, material in ipairs(workspace:GetChildren()) do
                if material.Name:find("Material") then
                    CreateMaterialESP(material)
                end
            end
            
            workspace.ChildAdded:Connect(function(child)
                if child.Name:find("Material") then
                    CreateMaterialESP(child)
                end
            end)
        else
            ESPContainer:ClearAllChildren()
        end
    end
    
    return ToggleESP
end

-- Movement Features
function ScriptHub:CreateMovementFeatures()
    local flyEnabled = false
    local flySpeed = 50
    local noclipEnabled = false
    local walkSpeedEnabled = false
    local originalWalkSpeed = 16
    
    -- Fly Mode
    local function ToggleFly(enable)
        flyEnabled = enable
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not Humanoid or not HumanoidRootPart then return end
        
        if enable then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.P = 5000
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = HumanoidRootPart
            
            local bg = Instance.new("BodyGyro")
            bg.Name = "FlyGyro"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 5000
            bg.CFrame = HumanoidRootPart.CFrame
            bg.Parent = HumanoidRootPart
            
            local flyConnection
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyEnabled then
                    flyConnection:Disconnect()
                    return
                end
                
                local moveDirection = Humanoid.MoveDirection
                bv.Velocity = moveDirection * flySpeed
                
                if UserInputService:GetFocusedTextBox() then return end
                
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    bv.Velocity = Vector3.new(0, flySpeed, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    bv.Velocity = Vector3.new(0, -flySpeed, 0)
                end
            end)
        else
            if HumanoidRootPart:FindFirstChild("FlyVelocity") then
                HumanoidRootPart.FlyVelocity:Destroy()
            end
            
            if HumanoidRootPart:FindFirstChild("FlyGyro") then
                HumanoidRootPart.FlyGyro:Destroy()
            end
        end
    end
    
    -- Noclip Mode
    local function ToggleNoclip(enable)
        noclipEnabled = enable
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        
        if enable then
            local noclipConnection
            noclipConnection = RunService.Stepped:Connect(function()
                if not noclipEnabled then
                    noclipConnection:Disconnect()
                    return
                end
                
                for _, part in ipairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end)
        else
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
    
    -- Walk Speed
    local function ToggleWalkSpeed(enable, speed)
        walkSpeedEnabled = enable
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        
        if not Humanoid then return end
        
        if enable then
            originalWalkSpeed = Humanoid.WalkSpeed
            Humanoid.WalkSpeed = speed
        else
            Humanoid.WalkSpeed = originalWalkSpeed
        end
    end
    
    -- Smart Farm Fly
    local function ToggleSmartFarmFly(enable)
        if enable and Toggles["AutoFarmLevel"] then
            ToggleFly(true)
        else
            ToggleFly(false)
        end
    end
    
    return {
        ToggleFly = ToggleFly,
        ToggleNoclip = ToggleNoclip,
        ToggleWalkSpeed = ToggleWalkSpeed,
        ToggleSmartFarmFly = ToggleSmartFarmFly
    }
end

-- Auto Features
function ScriptHub:CreateAutoFeatures()
    -- Auto Eat/Store Fruits
    local function AutoFruit()
        if not Toggles["AutoStoreFruit"] and not Toggles["AutoRandomFruit"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Backpack = LocalPlayer.Backpack
        
        -- Check for fruits in inventory
        for _, item in ipairs(Backpack:GetChildren()) do
            if item:FindFirstChild("Fruit") then
                if Toggles["AutoStoreFruit"] then
                    -- Store fruit
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", item.Name)
                elseif Toggles["AutoRandomFruit"] and LocalPlayer.Data.Level.Value >= 50 then
                    -- Eat fruit
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EatFruit", item.Name)
                end
            end
        end
    end
    
    -- Auto Stat Point Distribution
    local function AutoStats()
        local stats = {
            ["AddStatMeleeDefense"] = {"Melee", "Defense"},
            ["AddStatDefense"] = {"Defense"},
            ["AddStatDemonFruit"] = {"Demon Fruit"},
            ["AddStatGun"] = {"Gun"},
            ["AddStatMelee"] = {"Melee"},
            ["AddStatSword"] = {"Sword"}
        }
        
        for toggleName, statNames in pairs(stats) do
            if Toggles[toggleName] then
                for _, statName in ipairs(statNames) do
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", statName, 1)
                end
            end
        end
    end
    
    -- Auto Fruit Collection
    local function AutoCollectFruits()
        if not Toggles["AutoCollectFruits"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        for _, fruit in ipairs(workspace:GetChildren()) do
            if fruit:FindFirstChild("Fruit") then
                HumanoidRootPart.CFrame = fruit.CFrame
                wait(0.5)
                firetouchinterest(HumanoidRootPart, fruit, 0)
                firetouchinterest(HumanoidRootPart, fruit, 1)
            end
        end
    end
    
    -- Auto Berry Collection
    local function AutoCollectBerries()
        if not Toggles["AutoCollectBerries"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        for _, berry in ipairs(workspace:GetChildren()) do
            if berry.Name:find("Berry") then
                HumanoidRootPart.CFrame = berry.CFrame
                wait(0.5)
                firetouchinterest(HumanoidRootPart, berry, 0)
                firetouchinterest(HumanoidRootPart, berry, 1)
            end
        end
    end
    
    -- Auto Code Redemption
    local function RedeemAllCodes()
        local codes = {
            "UPD16",
            "FUDD10",
            "BIGNEWS",
            "STRAWHATMAINE",
            "TANTAIING",
            "SUB2GAMERROBOT_EXP1",
            "StrawHatMaine",
            "Sub2OfficialNoobie",
            "SUB2NOOBMASTER123",
            "Sub2Daigrock",
            "Axiore",
            "TantaiGaming",
            "STRAWHATMAINE"
        }
        
        for _, code in ipairs(codes) do
            game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
            wait(1)
        end
    end
    
    -- Auto Farm Level
    local function AutoFarmLevel()
        if not Toggles["AutoFarmLevel"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not Humanoid or not HumanoidRootPart then return end
        
        -- Find nearest enemy
        local nearestEnemy = nil
        local nearestDistance = math.huge
        
        for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
            local enemyHumanoid = enemy:FindFirstChildOfClass("Humanoid")
            local enemyHumanoidRootPart = enemy:FindFirstChild("HumanoidRootPart")
            
            if enemyHumanoid and enemyHumanoidRootPart and enemyHumanoid.Health > 0 then
                local distance = (HumanoidRootPart.Position - enemyHumanoidRootPart.Position).Magnitude
                
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestEnemy = enemy
                end
            end
        end
        
        if nearestEnemy then
            -- Move to enemy
            HumanoidRootPart.CFrame = nearestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            
            -- Attack enemy
            if nearestDistance < 20 then
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
                wait(0.1)
                game:GetService("VirtualUser"):Button1Up(Vector2.new(0, 0))
            end
        end
    end
    
    -- Auto Farm Boss
    local function AutoFarmBoss()
        if not Toggles["AutoFarmBoss"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not Humanoid or not HumanoidRootPart then return end
        
        -- Find selected boss
        local bossName = Dropdowns["SelectBoss"]
        local boss = workspace.Enemies:FindFirstChild(bossName)
        
        if boss then
            local bossHumanoid = boss:FindFirstChildOfClass("Humanoid")
            local bossHumanoidRootPart = boss:FindFirstChild("HumanoidRootPart")
            
            if bossHumanoid and bossHumanoidRootPart and bossHumanoid.Health > 0 then
                -- Move to boss
                HumanoidRootPart.CFrame = bossHumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                
                -- Attack boss
                local distance = (HumanoidRootPart.Position - bossHumanoidRootPart.Position).Magnitude
                if distance < 20 then
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
                    wait(0.1)
                    game:GetService("VirtualUser"):Button1Up(Vector2.new(0, 0))
                end
            end
        end
    end
    
    -- Auto Farm Materials
    local function AutoFarmMaterials()
        if not Toggles["AutoFarmMaterials"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Find selected material
        local materialName = Dropdowns["SelectMaterials"]
        
        for _, material in ipairs(workspace:GetChildren()) do
            if material.Name == materialName then
                HumanoidRootPart.CFrame = material.CFrame
                wait(0.5)
                firetouchinterest(HumanoidRootPart, material, 0)
                firetouchinterest(HumanoidRootPart, material, 1)
            end
        end
    end
    
    -- Auto Farm Chest
    local function AutoFarmChest()
        if not Toggles["AutoFarmChest"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        for _, chest in ipairs(workspace:GetChildren()) do
            if chest.Name:find("Chest") then
                HumanoidRootPart.CFrame = chest.CFrame
                wait(0.5)
                firetouchinterest(HumanoidRootPart, chest, 0)
                firetouchinterest(HumanoidRootPart, chest, 1)
            end
        end
    end
    
    -- Auto Mastery
    local function AutoMastery()
        if not Toggles["AutoMastery"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not Humanoid or not HumanoidRootPart then return end
        
        -- Find nearest enemy with low health
        local nearestEnemy = nil
        local nearestDistance = math.huge
        local healthPercent = Sliders["HealthPercent"] or 25
        
        for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
            local enemyHumanoid = enemy:FindFirstChildOfClass("Humanoid")
            local enemyHumanoidRootPart = enemy:FindFirstChild("HumanoidRootPart")
            
            if enemyHumanoid and enemyHumanoidRootPart and enemyHumanoid.Health > 0 then
                local currentHealthPercent = (enemyHumanoid.Health / enemyHumanoid.MaxHealth) * 100
                
                if currentHealthPercent < healthPercent then
                    local distance = (HumanoidRootPart.Position - enemyHumanoidRootPart.Position).Magnitude
                    
                    if distance < nearestDistance then
                        nearestDistance = distance
                        nearestEnemy = enemy
                    end
                end
            end
        end
        
        if nearestEnemy then
            -- Move to enemy
            HumanoidRootPart.CFrame = nearestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            
            -- Attack enemy with selected tool
            if nearestDistance < 20 then
                local toolName = Dropdowns["SelectTool"] or "Blox Fruit"
                
                if toolName == "Blox Fruit" then
                    -- Use fruit skills
                    game:GetService("VirtualUser"):KeyPress(Enum.KeyCode.Z)
                    wait(0.5)
                    game:GetService("VirtualUser"):KeyRelease(Enum.KeyCode.Z)
                elseif toolName == "Sword" then
                    -- Use sword skills
                    game:GetService("VirtualUser"):KeyPress(Enum.KeyCode.Z)
                    wait(0.5)
                    game:GetService("VirtualUser"):KeyRelease(Enum.KeyCode.Z)
                elseif toolName == "Gun" then
                    -- Use gun skills
                    game:GetService("VirtualUser"):KeyPress(Enum.KeyCode.Z)
                    wait(0.5)
                    game:GetService("VirtualUser"):KeyRelease(Enum.KeyCode.Z)
                elseif toolName == "Fighting Style" then
                    -- Use fighting style skills
                    game:GetService("VirtualUser"):KeyPress(Enum.KeyCode.Z)
                    wait(0.5)
                    game:GetService("VirtualUser"):KeyRelease(Enum.KeyCode.Z)
                end
            end
        end
    end
    
    -- Auto Unlock Dressrosa
    local function AutoUnlockDressrosa()
        if not Toggles["AutoUnlockDressrosa"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Teleport to Dressrosa unlock location
        HumanoidRootPart.CFrame = CFrame.new(-4462.98, 19.99, -2730.47)
        
        -- Interact with NPC
        local npc = workspace.NPC:FindFirstChild("Military Detective")
        if npc then
            HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            wait(0.5)
            fireclickdetector(npc.ClickDetector)
        end
    end
    
    -- Auto Unlock Zou
    local function AutoUnlockZou()
        if not Toggles["AutoUnlockZou"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Teleport to Zou unlock location
        HumanoidRootPart.CFrame = CFrame.new(-5113.72, 314.74, -2851.99)
        
        -- Interact with NPC
        local npc = workspace.NPC:FindFirstChild("Zou NPC")
        if npc then
            HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            wait(0.5)
            fireclickdetector(npc.ClickDetector)
        end
    end
    
    -- Auto Superhuman
    local function AutoSuperhuman()
        if not Toggles["AutoSuperhuman"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Check if player has required fighting styles
        local hasBlackLeg = LocalPlayer.Backpack:FindFirstChild("Black Leg") or Character:FindFirstChild("Black Leg")
        local hasElectro = LocalPlayer.Backpack:FindFirstChild("Electro") or Character:FindFirstChild("Electro")
        local hasFishmanKarate = LocalPlayer.Backpack:FindFirstChild("Fishman Karate") or Character:FindFirstChild("Fishman Karate")
        local hasDragonClaw = LocalPlayer.Backpack:FindFirstChild("Dragon Claw") or Character:FindFirstChild("Dragon Claw")
        
        if hasBlackLeg and hasElectro and hasFishmanKarate and hasDragonClaw then
            -- Teleport to Snoop
            HumanoidRootPart.CFrame = CFrame.new(-5321.32, 12.27, -831.81)
            
            -- Interact with Snoop
            local snoop = workspace.NPC:FindFirstChild("Snoop")
            if snoop then
                HumanoidRootPart.CFrame = snoop.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                wait(0.5)
                fireclickdetector(snoop.ClickDetector)
                
                -- Buy Superhuman
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonClaw")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
            end
        end
    end
    
    -- Auto Death Step
    local function AutoDeathStep()
        if not Toggles["AutoDeathStep"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Check if player has Black Leg
        local hasBlackLeg = LocalPlayer.Backpack:FindFirstChild("Black Leg") or Character:FindFirstChild("Black Leg")
        
        if hasBlackLeg then
            -- Teleport to Dark Leg Teacher
            HumanoidRootPart.CFrame = CFrame.new(959.07, 6.6, 1426.66)
            
            -- Interact with Dark Leg Teacher
            local teacher = workspace.NPC:FindFirstChild("Dark Leg Teacher")
            if teacher then
                HumanoidRootPart.CFrame = teacher.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                wait(0.5)
                fireclickdetector(teacher.ClickDetector)
                
                -- Buy Death Step
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
            end
        end
    end
    
    -- Auto Sharkman Karate
    local function AutoSharkmanKarate()
        if not Toggles["AutoSharkmanKarate"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Check if player has Fishman Karate
        local hasFishmanKarate = LocalPlayer.Backpack:FindFirstChild("Fishman Karate") or Character:FindFirstChild("Fishman Karate")
        
        if hasFishmanKarate then
            -- Teleport to Daigrock
            HumanoidRootPart.CFrame = CFrame.new(-4462.98, 19.99, -2730.47)
            
            -- Interact with Daigrock
            local daigrock = workspace.NPC:FindFirstChild("Daigrock")
            if daigrock then
                HumanoidRootPart.CFrame = daigrock.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                wait(0.5)
                fireclickdetector(daigrock.ClickDetector)
                
                -- Buy Sharkman Karate
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
            end
        end
    end
    
    -- Auto Electric Claw
    local function AutoElectricClaw()
        if not Toggles["AutoElectricClaw"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Check if player has Electro
        local hasElectro = LocalPlayer.Backpack:FindFirstChild("Electro") or Character:FindFirstChild("Electro")
        
        if hasElectro then
            -- Teleport to NPC
            HumanoidRootPart.CFrame = CFrame.new(-1039.59, 15.16, 1117.59)
            
            -- Interact with NPC
            local npc = workspace.NPC:FindFirstChild("Electric Claw Teacher")
            if npc then
                HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                wait(0.5)
                fireclickdetector(npc.ClickDetector)
                
                -- Buy Electric Claw
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
            end
        end
    end
    
    -- Auto Dragon Talon
    local function AutoDragonTalon()
        if not Toggles["AutoDragonTalon"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Check if player has Dragon Claw
        local hasDragonClaw = LocalPlayer.Backpack:FindFirstChild("Dragon Claw") or Character:FindFirstChild("Dragon Claw")
        
        if hasDragonClaw then
            -- Teleport to NPC
            HumanoidRootPart.CFrame = CFrame.new(-5113.72, 314.74, -2851.99)
            
            -- Interact with NPC
            local npc = workspace.NPC:FindFirstChild("Dragon Talon Teacher")
            if npc then
                HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                wait(0.5)
                fireclickdetector(npc.ClickDetector)
                
                -- Buy Dragon Talon
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
            end
        end
    end
    
    -- Auto Godhuman
    local function AutoGodhuman()
        if not Toggles["AutoGodhuman"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Check if player has required fighting styles
        local hasSuperhuman = LocalPlayer.Backpack:FindFirstChild("Superhuman") or Character:FindFirstChild("Superhuman")
        local hasDeathStep = LocalPlayer.Backpack:FindFirstChild("Death Step") or Character:FindFirstChild("Death Step")
        local hasSharkmanKarate = LocalPlayer.Backpack:FindFirstChild("Sharkman Karate") or Character:FindFirstChild("Sharkman Karate")
        local hasElectricClaw = LocalPlayer.Backpack:FindFirstChild("Electric Claw") or Character:FindFirstChild("Electric Claw")
        local hasDragonTalon = LocalPlayer.Backpack:FindFirstChild("Dragon Talon") or Character:FindFirstChild("Dragon Talon")
        
        if hasSuperhuman and hasDeathStep and hasSharkmanKarate and hasElectricClaw and hasDragonTalon then
            -- Teleport to NPC
            HumanoidRootPart.CFrame = CFrame.new(-5113.72, 314.74, -2851.99)
            
            -- Interact with NPC
            local npc = workspace.NPC:FindFirstChild("Godhuman Teacher")
            if npc then
                HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                wait(0.5)
                fireclickdetector(npc.ClickDetector)
                
                -- Buy Godhuman
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
            end
        end
    end
    
    -- Auto Saber
    local function AutoSaber()
        if not Toggles["AutoSaber"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Teleport to Saber Expert
        HumanoidRootPart.CFrame = CFrame.new(-1451.59, 29.88, -51.69)
        
        -- Interact with Saber Expert
        local expert = workspace.NPC:FindFirstChild("Saber Expert")
        if expert then
            HumanoidRootPart.CFrame = expert.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            wait(0.5)
            fireclickdetector(expert.ClickDetector)
            
            -- Complete Saber puzzle
            -- This is a simplified version, actual implementation would need to solve the puzzle
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SaberProgress")
        end
    end
    
    -- Auto Pole
    local function AutoPole()
        if not Toggles["AutoPole"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Teleport to Master of Enhancement
        HumanoidRootPart.CFrame = CFrame.new(-12463.87, 375.65, -7554.15)
        
        -- Interact with Master of Enhancement
        local master = workspace.NPC:FindFirstChild("Master of Enhancement")
        if master then
            HumanoidRootPart.CFrame = master.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            wait(0.5)
            fireclickdetector(master.ClickDetector)
            
            -- Buy Pole
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Pole")
        end
    end
    
    -- Walk On Water
    local function ToggleWalkOnWater(enable)
        if not enable then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        -- Create water walk part
        local waterWalkPart = Instance.new("Part")
        waterWalkPart.Name = "WaterWalkPart"
        waterWalkPart.Size = Vector3.new(5, 1, 5)
        waterWalkPart.Transparency = 1
        waterWalkPart.Anchored = true
        waterWalkPart.CanCollide = false
        waterWalkPart.Parent = Character
        
        local waterWalkConnection
        waterWalkConnection = RunService.Heartbeat:Connect(function()
            if not Toggles["WalkOnWater"] then
                waterWalkConnection:Disconnect()
                waterWalkPart:Destroy()
                return
            end
            
            -- Check if player is above water
            local ray = Ray.new(HumanoidRootPart.Position, Vector3.new(0, -10, 0))
            local part, position = workspace:FindPartOnRayWithIgnoreList(ray, {Character})
            
            if part and part.Name == "Water" then
                waterWalkPart.Position = Vector3.new(HumanoidRootPart.Position.X, position.Y + 2, HumanoidRootPart.Position.Z)
                waterWalkPart.CanCollide = true
            else
                waterWalkPart.CanCollide = false
            end
        end)
    end
    
    -- Rejoin Server
    local function RejoinServer()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
    
    -- Hop Server
    local function HopServer()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        
        local servers = {}
        local req = {
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Method = "GET",
            Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        }
        
        local response = request(req)
        local data = HttpService:JSONDecode(response.Body)
        
        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    break
                end
            end
        end
    end
    
    -- Anti Idle Kick
    local function AntiIdleKick()
        if not Toggles["AntiIdleKick"] then return end
        
        local VirtualInputManager = game:GetService("VirtualInputManager")
        
        local idleConnection
        idleConnection = RunService.Stepped:Connect(function()
            if not Toggles["AntiIdleKick"] then
                idleConnection:Disconnect()
                return
            end
            
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        end)
    end
    
    -- Auto Active Aura
    local function AutoActiveAura()
        if not Toggles["AutoActiveAura"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        
        -- Check if player has Aura
        local hasAura = LocalPlayer.Backpack:FindFirstChild("Aura") or Character:FindFirstChild("Aura")
        
        if hasAura then
            -- Equip Aura
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EquipAura", true)
        end
    end
    
    -- Teleport to Location
    local function TeleportToLocation(locationName)
        local locations = {
            ["Start Island"] = CFrame.new(1071.28, 16.26, 1426.69),
            ["Jungle"] = CFrame.new(-12463.87, 375.65, -7554.15),
            ["Pirate Village"] = CFrame.new(-1189.73, 4.75, 3804.6),
            ["Desert"] = CFrame.new(1093.34, 6.19, 4192.88),
            ["Snow Island"] = CFrame.new(1347.81, 104.67, -1319.09),
            ["Marine Ford"] = CFrame.new(-4914.88, 50.96, 4304.58),
            ["Colosseum"] = CFrame.new(-12463.87, 375.65, -7554.15),
            ["Sky Island"] = CFrame.new(-4970.22, 317.86, -2623.35),
            ["Fountain City"] = CFrame.new(5127.13, 7.45, 4050.29),
            ["Shells Town"] = CFrame.new(1066.27, 16.26, 1546.79),
            ["Middle Town"] = CFrame.new(-643.87, 7.89, 1438.35),
            ["Kingdom of Rose"] = CFrame.new(-5113.72, 314.74, -2851.99)
        }
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not HumanoidRootPart then return end
        
        if locations[locationName] then
            HumanoidRootPart.CFrame = locations[locationName]
        end
    end
    
    -- Buy Abilities
    local function BuyAbility(abilityName)
        local abilities = {
            ["Geppo"] = {cost = 10000, remote = "BuyGeppo"},
            ["Buso"] = {cost = 25000, remote = "BuyHaki"},
            ["Soru"] = {cost = 100000, remote = "BuySoru"},
            ["Observation Haki"] = {cost = 750000, remote = "BuyObservationHaki"}
        }
        
        if abilities[abilityName] then
            local ability = abilities[abilityName]
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(ability.remote)
        end
    end
    
    -- Buy Fighting Styles
    local function BuyFightingStyle(styleName)
        local styles = {
            ["Sanguine Art"] = "BuySanguineArt",
            ["Godhuman"] = "BuyGodhuman",
            ["Dragon Talon"] = "BuyDragonTalon",
            ["Electric Claw"] = "BuyElectricClaw",
            ["Sharkman Karate"] = "BuySharkmanKarate",
            ["Death Step"] = "BuyDeathStep",
            ["Superhuman"] = "BuySuperhuman",
            ["Dragon Claw"] = "BuyDragonClaw",
            ["Fishman Karate"] = "BuyFishmanKarate",
            ["Electro"] = "BuyElectro",
            ["Black Leg"] = "BuyBlackLeg"
        }
        
        if styles[styleName] then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(styles[styleName])
        end
    end
    
    -- Buy Races
    local function BuyRace(raceName)
        local races = {
            ["Cyborg"] = "BuyCyborg",
            ["Ghoul"] = "BuyGhoul"
        }
        
        if races[raceName] then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(races[raceName])
        end
    end
    
    -- Refund Stats
    local function RefundStats()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RefundStats")
    end
    
    -- Reroll Race
    local function RerollRace()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RerollRace")
    end
    
    -- Connect button clicks
    Buttons["StartTeleport"].Button.MouseButton1Click:Connect(function()
        TeleportToLocation(Dropdowns["Location"])
    end)
    
    Buttons["RedeemAllCodes"].Button.MouseButton1Click:Connect(function()
        RedeemAllCodes()
    end)
    
    Buttons["RejoinServer"].Button.MouseButton1Click:Connect(function()
        RejoinServer()
    end)
    
    Buttons["HopServer"].Button.MouseButton1Click:Connect(function()
        HopServer()
    end)
    
    Buttons["RefundStats"].Button.MouseButton1Click:Connect(function()
        RefundStats()
    end)
    
    Buttons["RerollRace"].Button.MouseButton1Click:Connect(function()
        RerollRace()
    end)
    
    Buttons["Geppo"].Button.MouseButton1Click:Connect(function()
        BuyAbility("Geppo")
    end)
    
    Buttons["Buso"].Button.MouseButton1Click:Connect(function()
        BuyAbility("Buso")
    end)
    
    Buttons["Soru"].Button.MouseButton1Click:Connect(function()
        BuyAbility("Soru")
    end)
    
    Buttons["ObservationHaki"].Button.MouseButton1Click:Connect(function()
        BuyAbility("Observation Haki")
    end)
    
    Buttons["BuySanguineArt"].Button.MouseButton1Click:Connect(function()
        BuyFightingStyle("Sanguine Art")
    end)
    
    Buttons["BuyGodhuman"].Button.MouseButton1Click:Connect(function()
        BuyFightingStyle("Godhuman")
    end)
    
    Buttons["BuyDragonTalon"].Button.MouseButton1Click:Connect(function()
        BuyFightingStyle("Dragon Talon")
    end)
    
    Buttons["BuyElectricClaw"].Button.MouseButton1Click:Connect(function()
        BuyFightingStyle("Electric Claw")
    end)
    
    Buttons["BuySharkmanKarate"].Button.MouseButton1Click:Connect(function()
        BuyFightingStyle("Sharkman Karate")
    end)
    
    Buttons["BuyDeathStep"].Button.MouseButton1Click:Connect(function()
        BuyFightingStyle("Death Step")
    end)
    
    Buttons["BuySuperhuman"].Button.MouseButton1Click:Connect(function()
        BuyFightingStyle("Superhuman")
    end)
    
    Buttons["BuyDragonClaw"].Button.MouseButton1Click:Connect(function()
        BuyFightingStyle("Dragon Claw")
    end)
    
    Buttons["BuyFishmanKarate"].Button.MouseButton1Click:Connect(function()
        BuyFightingStyle("Fishman Karate")
    end)
    
    Buttons["BuyElectro"].Button.MouseButton1Click:Connect(function()
        BuyFightingStyle("Electro")
    end)
    
    Buttons["BuyBlackLeg"].Button.MouseButton1Click:Connect(function()
        BuyFightingStyle("Black Leg")
    end)
    
    Buttons["Cyborg"].Button.MouseButton1Click:Connect(function()
        BuyRace("Cyborg")
    end)
    
    Buttons["Ghoul"].Button.MouseButton1Click:Connect(function()
        BuyRace("Ghoul")
    end)
    
    -- Main auto features loop
    local autoFeaturesConnection
    autoFeaturesConnection = RunService.Heartbeat:Connect(function()
        AutoFruit()
        AutoStats()
        AutoCollectFruits()
        AutoCollectBerries()
        AutoFarmLevel()
        AutoFarmBoss()
        AutoFarmMaterials()
        AutoFarmChest()
        AutoMastery()
        AutoUnlockDressrosa()
        AutoUnlockZou()
        AutoSuperhuman()
        AutoDeathStep()
        AutoSharkmanKarate()
        AutoElectricClaw()
        AutoDragonTalon()
        AutoGodhuman()
        AutoSaber()
        AutoPole()
        ToggleWalkOnWater(Toggles["WalkOnWater"])
        AntiIdleKick()
        AutoActiveAura()
    end)
    
    return autoFeaturesConnection
end

-- Pain Update Support
function ScriptHub:CreatePainUpdateSupport()
    -- Pain Meter Counter
    local function TrackPainMeter()
        if not workspace.Enemies:FindFirstChild("Cake Prince") then return end
        
        local cakePrince = workspace.Enemies["Cake Prince"]
        local painMeter = cakePrince:FindFirstChild("PainMeter")
        
        if painMeter then
            local painValue = painMeter.Value
            local maxPain = 100
            
            -- Create pain meter UI
            local painMeterGui = Instance.new("BillboardGui")
            painMeterGui.Name = "PainMeterGui"
            painMeterGui.Adornee = cakePrince.HumanoidRootPart
            painMeterGui.Size = UDim2.new(0, 200, 0, 50)
            painMeterGui.StudsOffset = Vector3.new(0, 5, 0)
            painMeterGui.AlwaysOnTop = true
            painMeterGui.Parent = game.CoreGui
            
            local painMeterFrame = Instance.new("Frame")
            painMeterFrame.Name = "PainMeterFrame"
            painMeterFrame.Size = UDim2.new(1, 0, 0, 20)
            painMeterFrame.Position = UDim2.new(0, 0, 0, 0)
            painMeterFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            painMeterFrame.BorderSizePixel = 0
            painMeterFrame.Parent = painMeterGui
            
            local painMeterFill = Instance.new("Frame")
            painMeterFill.Name = "PainMeterFill"
            painMeterFill.Size = UDim2.new(painValue / maxPain, 0, 1, 0)
            painMeterFill.Position = UDim2.new(0, 0, 0, 0)
            painMeterFill.BackgroundColor3 = Color3.new(1, 0, 0)
            painMeterFill.BorderSizePixel = 0
            painMeterFill.Parent = painMeterFrame
            
            local painMeterLabel = Instance.new("TextLabel")
            painMeterLabel.Name = "PainMeterLabel"
            painMeterLabel.Size = UDim2.new(1, 0, 1, 0)
            painMeterLabel.Position = UDim2.new(0, 0, 1, 0)
            painMeterLabel.BackgroundTransparency = 1
            painMeterLabel.Text = "Pain: " .. painValue .. "/" .. maxPain
            painMeterLabel.TextColor3 = Color3.new(1, 1, 1)
            painMeterLabel.TextStrokeTransparency = 0
            painMeterLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            painMeterLabel.TextScaled = true
            painMeterLabel.Font = Enum.Font.GothamBold
            painMeterLabel.Parent = painMeterGui
            
            -- Update pain meter
            local function UpdatePainMeter()
                if painMeter and painMeterFill and painMeterLabel then
                    painMeterFill:TweenSize(UDim2.new(painMeter.Value / maxPain, 0, 1, 0), "Out", "Quad", 0.1, true)
                    painMeterLabel.Text = "Pain: " .. painMeter.Value .. "/" .. maxPain
                end
            end
            
            painMeter.Changed:Connect(UpdatePainMeter)
        end
    end
    
    -- Boss Corruption Detection
    local function DetectBossCorruption()
        local bosses = {"Cake Prince", "Dough King", "Rip_Indra"}
        
        for _, bossName in ipairs(bosses) do
            if workspace.Enemies:FindFirstChild(bossName) then
                local boss = workspace.Enemies[bossName]
                local bossHumanoid = boss:FindFirstChildOfClass("Humanoid")
                
                if bossHumanoid then
                    -- Check for corruption indicators
                    if boss:FindFirstChild("Corruption") or boss:FindFirstChild("DarkAura") then
                        -- Boss is corrupted
                        local corruptionGui = Instance.new("BillboardGui")
                        corruptionGui.Name = "CorruptionGui"
                        corruptionGui.Adornee = boss.HumanoidRootPart
                        corruptionGui.Size = UDim2.new(0, 200, 0, 50)
                        corruptionGui.StudsOffset = Vector3.new(0, 7, 0)
                        corruptionGui.AlwaysOnTop = true
                        corruptionGui.Parent = game.CoreGui
                        
                        local corruptionLabel = Instance.new("TextLabel")
                        corruptionLabel.Name = "CorruptionLabel"
                        corruptionLabel.Size = UDim2.new(1, 0, 1, 0)
                        corruptionLabel.BackgroundTransparency = 1
                        corruptionLabel.Text = "CORRUPTED"
                        corruptionLabel.TextColor3 = Color3.new(1, 0, 0)
                        corruptionLabel.TextStrokeTransparency = 0
                        corruptionLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                        corruptionLabel.TextScaled = true
                        corruptionLabel.Font = Enum.Font.GothamBold
                        corruptionLabel.Parent = corruptionGui
                    end
                end
            end
        end
    end
    
    -- Awakened Form Handling
    local function HandleAwakenedForm()
        local bosses = {"Cake Prince", "Dough King", "Rip_Indra"}
        
        for _, bossName in ipairs(bosses) do
            if workspace.Enemies:FindFirstChild(bossName) then
                local boss = workspace.Enemies[bossName]
                local bossHumanoid = boss:FindFirstChildOfClass("Humanoid")
                
                if bossHumanoid then
                    -- Check for "Last Stand" phase (40-60% HP)
                    local healthPercent = (bossHumanoid.Health / bossHumanoid.MaxHealth) * 100
                    
                    if healthPercent >= 40 and healthPercent <= 60 then
                        -- Boss is in "Last Stand" phase
                        local lastStandGui = Instance.new("BillboardGui")
                        lastStandGui.Name = "LastStandGui"
                        lastStandGui.Adornee = boss.HumanoidRootPart
                        lastStandGui.Size = UDim2.new(0, 200, 0, 50)
                        lastStandGui.StudsOffset = Vector3.new(0, 9, 0)
                        lastStandGui.AlwaysOnTop = true
                        lastStandGui.Parent = game.CoreGui
                        
                        local lastStandLabel = Instance.new("TextLabel")
                        lastStandLabel.Name = "LastStandLabel"
                        lastStandLabel.Size = UDim2.new(1, 0, 1, 0)
                        lastStandLabel.BackgroundTransparency = 1
                        lastStandLabel.Text = "LAST STAND"
                        lastStandLabel.TextColor3 = Color3.new(1, 1, 0)
                        lastStandLabel.TextStrokeTransparency = 0
                        lastStandLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                        lastStandLabel.TextScaled = true
                        lastStandLabel.Font = Enum.Font.GothamBold
                        lastStandLabel.Parent = lastStandGui
                        
                        -- Increase boss stats
                        bossHumanoid.MaxHealth = bossHumanoid.MaxHealth * 1.3
                        bossHumanoid.Health = bossHumanoid.MaxHealth
                        bossHumanoid.WalkSpeed = bossHumanoid.WalkSpeed * 1.2
                    end
                end
            end
        end
    end
    
    -- Pain Boss Skills Detection
    local function DetectPainBossSkills()
        if not workspace.Enemies:FindFirstChild("Cake Prince") then return end
        
        local cakePrince = workspace.Enemies["Cake Prince"]
        local cakePrinceHumanoid = cakePrince:FindFirstChildOfClass("Humanoid")
        
        if not cakePrinceHumanoid then return end
        
        -- Painful Burst (Z/Tap): AOE explosion avoidance
        if cakePrince:FindFirstChild("PainfulBurst") then
            -- Create warning UI
            local painfulBurstGui = Instance.new("BillboardGui")
            painfulBurstGui.Name = "PainfulBurstGui"
            painfulBurstGui.Adornee = cakePrince.HumanoidRootPart
            painfulBurstGui.Size = UDim2.new(0, 200, 0, 50)
            painfulBurstGui.StudsOffset = Vector3.new(0, 11, 0)
            painfulBurstGui.AlwaysOnTop = true
            painfulBurstGui.Parent = game.CoreGui
            
            local painfulBurstLabel = Instance.new("TextLabel")
            painfulBurstLabel.Name = "PainfulBurstLabel"
            painfulBurstLabel.Size = UDim2.new(1, 0, 1, 0)
            painfulBurstLabel.BackgroundTransparency = 1
            painfulBurstLabel.Text = "PAINFUL BURST!"
            painfulBurstLabel.TextColor3 = Color3.new(1, 0, 0)
            painfulBurstLabel.TextStrokeTransparency = 0
            painfulBurstLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            painfulBurstLabel.TextScaled = true
            painfulBurstLabel.Font = Enum.Font.GothamBold
            painfulBurstLabel.Parent = painfulBurstGui
            
            -- Dodge the attack
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            
            if HumanoidRootPart then
                local dodgePosition = cakePrince.HumanoidRootPart.CFrame * CFrame.new(0, 0, 30)
                HumanoidRootPart.CFrame = dodgePosition
            end
            
            -- Remove warning after 2 seconds
            game:GetService("Debris"):AddItem(painfulBurstGui, 2)
        end
        
        -- Torment Wave (X/Held): Purple wave attack dodge
        if cakePrince:FindFirstChild("TormentWave") then
            -- Create warning UI
            local tormentWaveGui = Instance.new("BillboardGui")
            tormentWaveGui.Name = "TormentWaveGui"
            tormentWaveGui.Adornee = cakePrince.HumanoidRootPart
            tormentWaveGui.Size = UDim2.new(0, 200, 0, 50)
            tormentWaveGui.StudsOffset = Vector3.new(0, 11, 0)
            tormentWaveGui.AlwaysOnTop = true
            tormentWaveGui.Parent = game.CoreGui
            
            local tormentWaveLabel = Instance.new("TextLabel")
            tormentWaveLabel.Name = "TormentWaveLabel"
            tormentWaveLabel.Size = UDim2.new(1, 0, 1, 0)
            tormentWaveLabel.BackgroundTransparency = 1
            tormentWaveLabel.Text = "TORMENT WAVE!"
            tormentWaveLabel.TextColor3 = Color3.new(0.5, 0, 1)
            tormentWaveLabel.TextStrokeTransparency = 0
            tormentWaveLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            tormentWaveLabel.TextScaled = true
            tormentWaveLabel.Font = Enum.Font.GothamBold
            tormentWaveLabel.Parent = tormentWaveGui
            
            -- Dodge the attack
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            
            if HumanoidRootPart then
                local dodgePosition = cakePrince.HumanoidRootPart.CFrame * CFrame.new(30, 0, 0)
                HumanoidRootPart.CFrame = dodgePosition
            end
            
            -- Remove warning after 2 seconds
            game:GetService("Debris"):AddItem(tormentWaveGui, 2)
        end
        
        -- Spectral Spears (C): Pain ghost projectile evasion
        if cakePrince:FindFirstChild("SpectralSpears") then
            -- Create warning UI
            local spectralSpearsGui = Instance.new("BillboardGui")
            spectralSpearsGui.Name = "SpectralSpearsGui"
            spectralSpearsGui.Adornee = cakePrince.HumanoidRootPart
            spectralSpearsGui.Size = UDim2.new(0, 200, 0, 50)
            spectralSpearsGui.StudsOffset = Vector3.new(0, 11, 0)
            spectralSpearsGui.AlwaysOnTop = true
            spectralSpearsGui.Parent = game.CoreGui
            
            local spectralSpearsLabel = Instance.new("TextLabel")
            spectralSpearsLabel.Name = "SpectralSpearsLabel"
            spectralSpearsLabel.Size = UDim2.new(1, 0, 1, 0)
            spectralSpearsLabel.BackgroundTransparency = 1
            spectralSpearsLabel.Text = "SPECTRAL SPEARS!"
            spectralSpearsLabel.TextColor3 = Color3.new(0, 1, 1)
            spectralSpearsLabel.TextStrokeTransparency = 0
            spectralSpearsLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            spectralSpearsLabel.TextScaled = true
            spectralSpearsLabel.Font = Enum.Font.GothamBold
            spectralSpearsLabel.Parent = spectralSpearsGui
            
            -- Dodge the attack
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            
            if HumanoidRootPart then
                local dodgePosition = cakePrince.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                HumanoidRootPart.CFrame = dodgePosition
            end
            
            -- Remove warning after 2 seconds
            game:GetService("Debris"):AddItem(spectralSpearsGui, 2)
        end
        
        -- Agony Slam (V/Held): Ground slam area detection
        if cakePrince:FindFirstChild("AgonySlam") then
            -- Create warning UI
            local agonySlamGui = Instance.new("BillboardGui")
            agonySlamGui.Name = "AgonySlamGui"
            agonySlamGui.Adornee = cakePrince.HumanoidRootPart
            agonySlamGui.Size = UDim2.new(0, 200, 0, 50)
            agonySlamGui.StudsOffset = Vector3.new(0, 11, 0)
            agonySlamGui.AlwaysOnTop = true
            agonySlamGui.Parent = game.CoreGui
            
            local agonySlamLabel = Instance.new("TextLabel")
            agonySlamLabel.Name = "AgonySlamLabel"
            agonySlamLabel.Size = UDim2.new(1, 0, 1, 0)
            agonySlamLabel.BackgroundTransparency = 1
            agonySlamLabel.Text = "AGONY SLAM!"
            agonySlamLabel.TextColor3 = Color3.new(1, 0.5, 0)
            agonySlamLabel.TextStrokeTransparency = 0
            agonySlamLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            agonySlamLabel.TextScaled = true
            agonySlamLabel.Font = Enum.Font.GothamBold
            agonySlamLabel.Parent = agonySlamGui
            
            -- Dodge the attack
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            
            if HumanoidRootPart then
                local dodgePosition = cakePrince.HumanoidRootPart.CFrame * CFrame.new(0, 0, -30)
                HumanoidRootPart.CFrame = dodgePosition
            end
            
            -- Remove warning after 2 seconds
            game:GetService("Debris"):AddItem(agonySlamGui, 2)
        end
        
        -- Shadow Dash (F): I-frame dash tracking
        if cakePrince:FindFirstChild("ShadowDash") then
            -- Create warning UI
            local shadowDashGui = Instance.new("BillboardGui")
            shadowDashGui.Name = "ShadowDashGui"
            shadowDashGui.Adornee = cakePrince.HumanoidRootPart
            shadowDashGui.Size = UDim2.new(0, 200, 0, 50)
            shadowDashGui.StudsOffset = Vector3.new(0, 11, 0)
            shadowDashGui.AlwaysOnTop = true
            shadowDashGui.Parent = game.CoreGui
            
            local shadowDashLabel = Instance.new("TextLabel")
            shadowDashLabel.Name = "ShadowDashLabel"
            shadowDashLabel.Size = UDim2.new(1, 0, 1, 0)
            shadowDashLabel.BackgroundTransparency = 1
            shadowDashLabel.Text = "SHADOW DASH!"
            shadowDashLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
            shadowDashLabel.TextStrokeTransparency = 0
            shadowDashLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            shadowDashLabel.TextScaled = true
            shadowDashLabel.Font = Enum.Font.GothamBold
            shadowDashLabel.Parent = shadowDashGui
            
            -- Track boss position during dash
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            
            if HumanoidRootPart then
                -- Keep distance from boss during dash
                local distance = (HumanoidRootPart.Position - cakePrince.HumanoidRootPart.Position).Magnitude
                
                if distance < 20 then
                    local dodgePosition = cakePrince.HumanoidRootPart.CFrame * CFrame.new(0, 0, 30)
                    HumanoidRootPart.CFrame = dodgePosition
                end
            end
            
            -- Remove warning after 2 seconds
            game:GetService("Debris"):AddItem(shadowDashGui, 2)
        end
    end
    
    -- Smart Combat AI
    local function SmartCombatAI()
        if not Toggles["AutoFarmBoss"] then return end
        
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        if not Humanoid or not HumanoidRootPart then return end
        
        -- Find selected boss
        local bossName = Dropdowns["SelectBoss"]
        local boss = workspace.Enemies:FindFirstChild(bossName)
        
        if boss then
            local bossHumanoid = boss:FindFirstChildOfClass("Humanoid")
            local bossHumanoidRootPart = boss:FindFirstChild("HumanoidRootPart")
            
            if bossHumanoid and bossHumanoidRootPart and bossHumanoid.Health > 0 then
                -- Check if boss is using an area skill
                if boss:FindFirstChild("PainfulBurst") or boss:FindFirstChild("TormentWave") or boss:FindFirstChild("AgonySlam") then
                    -- Dodge the attack
                    local dodgePosition = bossHumanoidRootPart.CFrame * CFrame.new(0, 0, 30)
                    HumanoidRootPart.CFrame = dodgePosition
                else
                    -- Normal attack
                    local distance = (HumanoidRootPart.Position - bossHumanoidRootPart.Position).Magnitude
                    
                    if distance < 20 then
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
                        wait(0.1)
                        game:GetService("VirtualUser"):Button1Up(Vector2.new(0, 0))
                    else
                        -- Move to boss
                        HumanoidRootPart.CFrame = bossHumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                    end
                end
                
                -- Check if player is stunned
                if Humanoid:FindFirstChild("Stunned") then
                    -- Use ability to escape stun
                    game:GetService("VirtualUser"):KeyPress(Enum.KeyCode.V)
                    wait(0.5)
                    game:GetService("VirtualUser"):KeyRelease(Enum.KeyCode.V)
                end
            end
        end
    end
    
    -- Main Pain Update Support loop
    local painUpdateConnection
    painUpdateConnection = RunService.Heartbeat:Connect(function()
        TrackPainMeter()
        DetectBossCorruption()
        HandleAwakenedForm()
        DetectPainBossSkills()
        SmartCombatAI()
    end)
    
    return painUpdateConnection
end

-- Keybind System
function ScriptHub:CreateKeybindSystem()
    -- F1: Start/Stop all automation
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F1 then
            -- Toggle all automation
            local allEnabled = true
            
            for _, toggle in pairs(Toggles) do
                if not toggle then
                    allEnabled = false
                    break
                end
            end
            
            for toggleName, _ in pairs(Toggles) do
                Toggles[toggleName] = not allEnabled
            end
            
            -- Update UI
            for _, tabContent in pairs(self.ContentArea:GetChildren()) do
                if tabContent:IsA("ScrollingFrame") then
                    for _, toggleFrame in pairs(tabContent:GetChildren()) do
                        if toggleFrame:IsA("Frame") and toggleFrame.Name:find("Frame") then
                            local toggleButton = toggleFrame:FindFirstChild("Toggle")
                            if toggleButton then
                                local toggleIndicator = toggleButton:FindFirstChild("Indicator")
                                if toggleIndicator then
                                    if allEnabled then
                                        TweenService:Create(toggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = UIConfig.SecondaryColor}):Play()
                                        TweenService:Create(toggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0, 2)}):Play()
                                    else
                                        TweenService:Create(toggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = UIConfig.AccentColor}):Play()
                                        TweenService:Create(toggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -18, 0, 2)}):Play()
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- Show notification
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Automation",
                Text = allEnabled and "All automation stopped" or "All automation started",
                Duration = 3
            })
        end
    end)
    
    -- F2: Toggle auto farm
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F2 then
            -- Toggle auto farm
            Toggles["AutoFarmLevel"] = not Toggles["AutoFarmLevel"]
            
            -- Update UI
            for _, tabContent in pairs(self.ContentArea:GetChildren()) do
                if tabContent:IsA("ScrollingFrame") and tabContent.Name == "GeneralContent" then
                    for _, toggleFrame in pairs(tabContent:GetChildren()) do
                        if toggleFrame:IsA("Frame") and toggleFrame.Name == "Auto Farm LevelFrame" then
                            local toggleButton = toggleFrame:FindFirstChild("Toggle")
                            if toggleButton then
                                local toggleIndicator = toggleButton:FindFirstChild("Indicator")
                                if toggleIndicator then
                                    if Toggles["AutoFarmLevel"] then
                                        TweenService:Create(toggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = UIConfig.AccentColor}):Play()
                                        TweenService:Create(toggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -18, 0, 2)}):Play()
                                    else
                                        TweenService:Create(toggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = UIConfig.SecondaryColor}):Play()
                                        TweenService:Create(toggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0, 2)}):Play()
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- Show notification
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Auto Farm",
                Text = Toggles["AutoFarmLevel"] and "Auto farm enabled" or "Auto farm disabled",
                Duration = 3
            })
        end
    end)
    
    -- F3: Toggle ESP features
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F3 then
            -- Toggle ESP
            local espEnabled = false
            
            if game.CoreGui:FindFirstChild("ESPContainer") and #game.CoreGui.ESPContainer:GetChildren() > 0 then
                espEnabled = true
            end
            
            if espEnabled then
                game.CoreGui.ESPContainer:ClearAllChildren()
            else
                ToggleESP(true)
            end
            
            -- Show notification
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "ESP",
                Text = espEnabled and "ESP disabled" or "ESP enabled",
                Duration = 3
            })
        end
    end)
    
    -- F4: Toggle fly mode
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F4 then
            -- Toggle fly mode
            local flyEnabled = false
            
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            
            if HumanoidRootPart and HumanoidRootPart:FindFirstChild("FlyVelocity") then
                flyEnabled = true
            end
            
            ToggleFly(not flyEnabled)
            
            -- Show notification
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly Mode",
                Text = flyEnabled and "Fly mode disabled" or "Fly mode enabled",
                Duration = 3
            })
        end
    end)
    
    -- M: Minimize interface
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.M then
            -- Minimize interface
            self.MainGui.Enabled = not self.MainGui.Enabled
            
            -- Create reopen button if minimized
            if not self.MainGui.Enabled then
                local ReopenButton = Instance.new("TextButton")
                ReopenButton.Name = "ReopenButton"
                ReopenButton.Size = UDim2.new(0, 50, 0, 50)
                ReopenButton.Position = UDim2.new(0, 10, 0.5, -25)
                ReopenButton.BackgroundColor3 = UIConfig.SecondaryColor
                ReopenButton.BorderSizePixel = 0
                ReopenButton.Text = "📱"
                ReopenButton.TextColor3 = UIConfig.TextColor
                ReopenButton.TextSize = 24
                ReopenButton.Font = UIConfig.Font
                ReopenButton.Parent = self.MainGui
                
                local ReopenCorner = Instance.new("UICorner")
                ReopenCorner.CornerRadius = UDim.new(0, 8)
                ReopenCorner.Parent = ReopenButton
                
                ReopenButton.MouseButton1Click:Connect(function()
                    self.MainGui.Enabled = true
                    ReopenButton:Destroy()
                end)
            end
        end
    end)
end

-- Initialize Script Hub
function ScriptHub:Initialize()
    -- Create UI
    self:CreateMainUI()
    
    -- Create ESP System
    ToggleESP = self:CreateESP()
    
    -- Create Movement Features
    MovementFeatures = self:CreateMovementFeatures()
    
    -- Create Auto Features
    AutoFeaturesConnection = self:CreateAutoFeatures()
    
    -- Create Pain Update Support
    PainUpdateConnection = self:CreatePainUpdateSupport()
    
    -- Create Keybind System
    self:CreateKeybindSystem()
    
    -- Show notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Hub",
        Text = "Successfully loaded! Press M to minimize.",
        Duration = 5
    })
    
    -- Add transparency if enabled
    if Toggles["Transparency"] then
        self.MainFrame.BackgroundTransparency = UIConfig.Transparency
    end
end

-- Start Script Hub
ScriptHub:Initialize()
