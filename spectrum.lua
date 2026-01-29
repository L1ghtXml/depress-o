local Spectrum = {}
Spectrum.__index = Spectrum

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Colors = {
    Background = Color3.fromRGB(0, 0, 0),
    Secondary = Color3.fromRGB(0, 0, 0),
    Border = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 180),
    Toggle = Color3.fromRGB(255, 255, 255),
    Slider = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(0, 0, 0),
    ButtonHover = Color3.fromRGB(20, 20, 20),
    InputBg = Color3.fromRGB(10, 10, 10)
}

local function Tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local LucideIcons = {
    ["home"] = "rbxassetid://10723434711",
    ["menu"] = "rbxassetid://10723425537",
    ["x"] = "rbxassetid://10747384394",
    ["search"] = "rbxassetid://10734898355",
    ["settings"] = "rbxassetid://10734950309",
    ["cog"] = "rbxassetid://10734950309",
    ["layout-dashboard"] = "rbxassetid://10723407389",
    ["grid"] = "rbxassetid://10723407389",
    ["user"] = "rbxassetid://10734896829",
    ["users"] = "rbxassetid://10747373176",
    ["plus"] = "rbxassetid://10747373176",
    ["check"] = "rbxassetid://10709761530",
    ["circle"] = "rbxassetid://10709761530",
    ["eye"] = "rbxassetid://10747372992",
    ["eye-off"] = "rbxassetid://10747372992",
    ["navigation"] = "rbxassetid://10723434711",
    ["compass"] = "rbxassetid://10723434711",
    ["map"] = "rbxassetid://10723434711",
    ["shield"] = "rbxassetid://10723434711",
    ["star"] = "rbxassetid://10734896829",
    ["heart"] = "rbxassetid://10734896829",
    ["flag"] = "rbxassetid://10723434711",
    ["pointer"] = "rbxassetid://10734896682",
    ["file"] = "rbxassetid://10723369639",
    ["folder"] = "rbxassetid://10723369639",
    ["save"] = "rbxassetid://10734952273",
    ["trash"] = "rbxassetid://10734896920",
    ["edit"] = "rbxassetid://10734943156",
    ["copy"] = "rbxassetid://10734896206",
    ["clipboard"] = "rbxassetid://10734896206",
    ["link"] = "rbxassetid://10734929777",
    ["image"] = "rbxassetid://10723417387",
    ["download"] = "rbxassetid://10734898592",
    ["upload"] = "rbxassetid://10734896920",
}

local function CreateIcon(parent, iconName, size)
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, size or 20, 0, size or 20)
    icon.BackgroundTransparency = 1
    icon.Image = LucideIcons[iconName] or iconName or ""
    icon.ImageColor3 = Colors.Text
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Parent = parent
    
    return icon
end

local function CreateFrame(parent, name, size, position)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Colors.Secondary
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local border = Instance.new("UIStroke")
    border.Color = Colors.Border
    border.Thickness = 1
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Parent = frame
    
    return frame
end

function Spectrum:CreateWindow(config)
    local self = setmetatable({}, Spectrum)
    
    self.Title = config.Title or "Spectrum"
    self.Author = config.Author or "gt"
    self.Icon = config.Icon or nil
    self.Tabs = {}
    self.CurrentTab = nil
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "Spectrum_" .. math.random(1000, 9999)
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    if gethui then
        self.ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
        self.ScreenGui.Parent = CoreGui
    else
        self.ScreenGui.Parent = CoreGui
    end
    
    self.Main = CreateFrame(self.ScreenGui, "Main", UDim2.new(0, 480, 0, 360), UDim2.new(0.5, -240, 0.5, -180))
    self.Main.BackgroundColor3 = Colors.Background
    
    local dragging, dragInput, dragStart, startPos
    
    self.Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local Header = CreateFrame(self.Main, "Header", UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 0))
    Header.BackgroundColor3 = Colors.Background
    
    if self.Icon then
        local IconFrame = CreateIcon(Header, self.Icon, 30)
        IconFrame.Position = UDim2.new(0, 10, 0.5, -15)
    end
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Position = UDim2.new(0, self.Icon and 50 or 10, 0, 5)
    TitleLabel.Size = UDim2.new(0, 200, 0, 25)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    local AuthorLabel = Instance.new("TextLabel")
    AuthorLabel.Name = "Author"
    AuthorLabel.Position = UDim2.new(0, self.Icon and 50 or 10, 0, 28)
    AuthorLabel.Size = UDim2.new(0, 200, 0, 17)
    AuthorLabel.BackgroundTransparency = 1
    AuthorLabel.Text = "by " .. self.Author
    AuthorLabel.TextColor3 = Colors.TextDim
    AuthorLabel.TextSize = 12
    AuthorLabel.Font = Enum.Font.Gotham
    AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
    AuthorLabel.Parent = Header
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -45, 0, 5)
    CloseBtn.BackgroundColor3 = Colors.Secondary
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Colors.Text
    CloseBtn.TextSize = 24
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Header
    
    local CloseBorder = Instance.new("UIStroke")
    CloseBorder.Color = Colors.Border
    CloseBorder.Thickness = 1
    CloseBorder.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)})
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Colors.Secondary})
    end)
    
    self.TabContainer = CreateFrame(self.Main, "TabContainer", UDim2.new(0, 150, 1, -60), UDim2.new(0, 5, 0, 55))
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = self.TabContainer
    
    self.ContentContainer = CreateFrame(self.Main, "ContentContainer", UDim2.new(1, -165, 1, -60), UDim2.new(0, 160, 0, 55))
    
    return self
end

function Spectrum:CreateTab(config)
    local Tab = {}
    Tab.Name = config.Name or "Tab"
    Tab.Icon = config.Icon or nil
    Tab.Elements = {}
    
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = Tab.Name
    Tab.Button.Size = UDim2.new(1, 0, 0, 40)
    Tab.Button.BackgroundColor3 = Colors.Secondary
    Tab.Button.BorderSizePixel = 0
    Tab.Button.Text = ""
    Tab.Button.Parent = self.TabContainer
    
    local TabBorder = Instance.new("UIStroke")
    TabBorder.Color = Colors.Border
    TabBorder.Thickness = 1
    TabBorder.Parent = Tab.Button
    
    if Tab.Icon then
        local TabIcon = CreateIcon(Tab.Button, Tab.Icon, 20)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
    end
    
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Position = UDim2.new(0, Tab.Icon and 40 or 10, 0, 0)
    TabLabel.Size = UDim2.new(1, Tab.Icon and -40 or -10, 1, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = Tab.Name
    TabLabel.TextColor3 = Colors.TextDim
    TabLabel.TextSize = 14
    TabLabel.Font = Enum.Font.Gotham
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = Tab.Button
    
    Tab.Content = Instance.new("ScrollingFrame")
    Tab.Content.Name = Tab.Name .. "Content"
    Tab.Content.Size = UDim2.new(1, 0, 1, 0)
    Tab.Content.BackgroundTransparency = 1
    Tab.Content.BorderSizePixel = 0
    Tab.Content.ScrollBarThickness = 6
    Tab.Content.ScrollBarImageColor3 = Colors.Border
    Tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tab.Content.Visible = false
    Tab.Content.ClipsDescendants = true
    Tab.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Tab.Content.Parent = self.ContentContainer
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 8)
    ContentList.Parent = Tab.Content
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 16)
    ContentPadding.Parent = Tab.Content
    
    Tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
    end)
    
    Tab.Button.MouseEnter:Connect(function()
        if self.CurrentTab ~= Tab then
            Tween(Tab.Button, {BackgroundColor3 = Colors.ButtonHover})
        end
    end)
    
    Tab.Button.MouseLeave:Connect(function()
        if self.CurrentTab ~= Tab then
            Tween(Tab.Button, {BackgroundColor3 = Colors.Secondary})
        end
    end)
    
    table.insert(self.Tabs, Tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(Tab)
    end
    
    return Tab
end

function Spectrum:SelectTab(tab)
    for _, t in pairs(self.Tabs) do
        t.Content.Visible = false
        Tween(t.Button, {BackgroundColor3 = Colors.Secondary})
        t.Button:FindFirstChildOfClass("TextLabel").TextColor3 = Colors.TextDim
    end
    
    tab.Content.Visible = true
    Tween(tab.Button, {BackgroundColor3 = Colors.ButtonHover})
    tab.Button:FindFirstChildOfClass("TextLabel").TextColor3 = Colors.Text
    self.CurrentTab = tab
end

function Spectrum:CreateButton(tab, config)
    local Button = Instance.new("TextButton")
    Button.Name = config.Name or "Button"
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = Colors.Button
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.Parent = tab.Content
    
    local ButtonBorder = Instance.new("UIStroke")
    ButtonBorder.Color = Colors.Border
    ButtonBorder.Thickness = 1
    ButtonBorder.Parent = Button
    
    local ButtonLabel = Instance.new("TextLabel")
    ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
    ButtonLabel.Size = UDim2.new(1, -50, 1, 0)
    ButtonLabel.BackgroundTransparency = 1
    ButtonLabel.Text = config.Text or "Button"
    ButtonLabel.TextColor3 = Colors.Text
    ButtonLabel.TextSize = 14
    ButtonLabel.Font = Enum.Font.Gotham
    ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
    ButtonLabel.Parent = Button
    
    local ClickIcon = CreateIcon(Button, "pointer", 18)
    ClickIcon.Position = UDim2.new(1, -28, 0.5, -9)
    
    Button.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback()
        end
    end)
    
    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = Colors.ButtonHover})
    end)
    
    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = Colors.Button})
    end)
    
    return Button
end

function Spectrum:CreateToggle(tab, config)
    local ToggleFrame = CreateFrame(tab.Content, config.Name or "Toggle", UDim2.new(1, -10, 0, 40))
    ToggleFrame.BackgroundColor3 = Colors.Button
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = config.Text or "Toggle"
    ToggleLabel.TextColor3 = Colors.Text
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.BackgroundColor3 = Colors.Secondary
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleBorder = Instance.new("UIStroke")
    ToggleBorder.Color = Colors.Border
    ToggleBorder.Thickness = 1
    ToggleBorder.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local State = config.Default or false
    
    local function UpdateToggle()
        if State then
            Tween(ToggleButton, {BackgroundColor3 = Colors.Toggle})
            Tween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)})
        else
            Tween(ToggleButton, {BackgroundColor3 = Colors.Secondary})
            Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)})
        end
        
        if config.Callback then
            config.Callback(State)
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        State = not State
        UpdateToggle()
    end)
    
    UpdateToggle()
    
    return {
        SetValue = function(value)
            State = value
            UpdateToggle()
        end
    }
end

function Spectrum:CreateSlider(tab, config)
    local SliderFrame = CreateFrame(tab.Content, config.Name or "Slider", UDim2.new(1, -10, 0, 70))
    SliderFrame.BackgroundColor3 = Colors.Button
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = config.Text or "Slider"
    SliderLabel.TextColor3 = Colors.Text
    SliderLabel.TextSize = 14
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local InputBox = Instance.new("TextBox")
    InputBox.Name = "InputBox"
    InputBox.Position = UDim2.new(1, -60, 0, 5)
    InputBox.Size = UDim2.new(0, 50, 0, 20)
    InputBox.BackgroundColor3 = Colors.Secondary
    InputBox.BorderSizePixel = 0
    InputBox.Text = tostring(config.Default or config.Min or 0)
    InputBox.TextColor3 = Colors.Text
    InputBox.TextSize = 12
    InputBox.Font = Enum.Font.Gotham
    InputBox.ClearTextOnFocus = false
    InputBox.Parent = SliderFrame
    
    local InputBorder = Instance.new("UIStroke")
    InputBorder.Color = Colors.Border
    InputBorder.Thickness = 1
    InputBorder.Parent = InputBox
    
    local SliderTrack = CreateFrame(SliderFrame, "Track", UDim2.new(1, -20, 0, 6), UDim2.new(0, 10, 0, 38))
    SliderTrack.BackgroundColor3 = Colors.Secondary
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = Colors.Slider
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Position = UDim2.new(0, 10, 0, 50)
    ValueLabel.Size = UDim2.new(1, -20, 0, 15)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(config.Default or config.Min or 0)
    ValueLabel.TextColor3 = Colors.TextDim
    ValueLabel.TextSize = 12
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Center
    ValueLabel.Parent = SliderFrame
    
    local Min = config.Min or 0
    local Max = config.Max or 100
    local Increment = config.Increment or 1
    local Value = config.Default or Min
    
    local function Round(num)
        return math.floor(num / Increment + 0.5) * Increment
    end
    
    local function UpdateSlider(value)
        Value = math.clamp(Round(value), Min, Max)
        local percent = (Value - Min) / (Max - Min)
        
        Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)})
        ValueLabel.Text = tostring(Value)
        InputBox.Text = tostring(Value)
        
        if config.Callback then
            config.Callback(Value)
        end
    end
    
    InputBox.FocusLost:Connect(function()
        local inputValue = tonumber(InputBox.Text)
        if inputValue then
            UpdateSlider(inputValue)
        else
            InputBox.Text = tostring(Value)
        end
    end)
    
    local dragging = false
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            
            local function Update()
                local mousePos = UserInputService:GetMouseLocation().X
                local trackPos = SliderTrack.AbsolutePosition.X
                local trackSize = SliderTrack.AbsoluteSize.X
                local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                local value = Min + (percent * (Max - Min))
                UpdateSlider(value)
            end
            
            Update()
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = UserInputService:GetMouseLocation().X
            local trackPos = SliderTrack.AbsolutePosition.X
            local trackSize = SliderTrack.AbsoluteSize.X
            local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
            local value = Min + (percent * (Max - Min))
            UpdateSlider(value)
        end
    end)
    
    UpdateSlider(Value)
    
    return {
        SetValue = function(value)
            UpdateSlider(value)
        end
    }
end

function Spectrum:CreateDropdown(tab, config)
    local Multi = config.Multi or false
    local DropdownFrame = CreateFrame(tab.Content, config.Name or "Dropdown", UDim2.new(1, -10, 0, 40))
    DropdownFrame.BackgroundColor3 = Colors.Button
    DropdownFrame.ClipsDescendants = true
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    DropdownLabel.Size = UDim2.new(1, -40, 0, 40)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = config.Text or "Dropdown"
    DropdownLabel.TextColor3 = Colors.Text
    DropdownLabel.TextSize = 14
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = DropdownFrame
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Position = UDim2.new(1, -30, 0, 0)
    Arrow.Size = UDim2.new(0, 30, 0, 40)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Colors.Text
    Arrow.TextSize = 14
    Arrow.Font = Enum.Font.Gotham
    Arrow.Parent = DropdownFrame
    
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Name = "Options"
    OptionsFrame.Position = UDim2.new(0, 0, 0, 40)
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.BackgroundColor3 = Colors.Secondary
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Parent = DropdownFrame
    
    local OptionsList = Instance.new("UIListLayout")
    OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsList.Parent = OptionsFrame
    
    local Open = false
    local Selected = {}
    
    if Multi then
        if config.Default then
            for _, v in pairs(config.Default) do
                Selected[v] = true
            end
        end
    else
        Selected = config.Default or (config.Options and config.Options[1]) or "None"
    end
    
    local function UpdateLabel()
        if Multi then
            local selectedItems = {}
            for item, _ in pairs(Selected) do
                table.insert(selectedItems, item)
            end
            if #selectedItems > 0 then
                DropdownLabel.Text = (config.Text or "Dropdown") .. ": " .. table.concat(selectedItems, ", ")
            else
                DropdownLabel.Text = config.Text or "Dropdown"
            end
        else
            DropdownLabel.Text = (config.Text or "Dropdown") .. ": " .. Selected
        end
    end
    
    for _, option in ipairs(config.Options or {}) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Name = option
        OptionButton.Size = UDim2.new(1, 0, 0, 35)
        OptionButton.BackgroundColor3 = Colors.Secondary
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = ""
        OptionButton.Parent = OptionsFrame
        
        local OptionBorder = Instance.new("UIStroke")
        OptionBorder.Color = Colors.Border
        OptionBorder.Thickness = 1
        OptionBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        OptionBorder.Parent = OptionButton
        
        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Position = UDim2.new(0, 10, 0, 0)
        OptionLabel.Size = UDim2.new(1, Multi and -40 or -10, 1, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = option
        OptionLabel.TextColor3 = Colors.Text
        OptionLabel.TextSize = 13
        OptionLabel.Font = Enum.Font.Gotham
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.Parent = OptionButton
        
        if Multi then
            local Checkbox = Instance.new("Frame")
            Checkbox.Name = "Checkbox"
            Checkbox.Position = UDim2.new(1, -30, 0.5, -8)
            Checkbox.Size = UDim2.new(0, 16, 0, 16)
            Checkbox.BackgroundColor3 = Colors.Secondary
            Checkbox.BorderSizePixel = 0
            Checkbox.Parent = OptionButton
            
            local CheckboxBorder = Instance.new("UIStroke")
            CheckboxBorder.Color = Colors.Border
            CheckboxBorder.Thickness = 1
            CheckboxBorder.Parent = Checkbox
            
            local Checkmark = Instance.new("TextLabel")
            Checkmark.Size = UDim2.new(1, 0, 1, 0)
            Checkmark.BackgroundTransparency = 1
            Checkmark.Text = "✓"
            Checkmark.TextColor3 = Colors.Text
            Checkmark.TextSize = 14
            Checkmark.Font = Enum.Font.GothamBold
            Checkmark.Visible = Selected[option] or false
            Checkmark.Parent = Checkbox
            
            OptionButton.MouseButton1Click:Connect(function()
                Selected[option] = not Selected[option]
                Checkmark.Visible = Selected[option]
                
                UpdateLabel()
                
                if config.Callback then
                    local selectedList = {}
                    for item, _ in pairs(Selected) do
                        table.insert(selectedList, item)
                    end
                    config.Callback(selectedList)
                end
            end)
        else
            OptionButton.MouseButton1Click:Connect(function()
                Selected = option
                UpdateLabel()
                Open = false
                
                Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 40)})
                Tween(Arrow, {Rotation = 0})
                
                if config.Callback then
                    config.Callback(Selected)
                end
            end)
        end
        
        OptionButton.MouseEnter:Connect(function()
            Tween(OptionButton, {BackgroundColor3 = Colors.ButtonHover})
        end)
        
        OptionButton.MouseLeave:Connect(function()
            Tween(OptionButton, {BackgroundColor3 = Colors.Secondary})
        end)
    end
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 40)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.Parent = DropdownFrame
    
    DropdownButton.MouseButton1Click:Connect(function()
        Open = not Open
        
        if Open then
            local optionCount = #(config.Options or {})
            local height = 40 + (optionCount * 35)
            Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, height)})
            Tween(Arrow, {Rotation = 180})
        else
            Tween(DropdownFrame, {Size = UDim2.new(1, -10, 0, 40)})
            Tween(Arrow, {Rotation = 0})
        end
    end)
    
    UpdateLabel()
    
    return {
        SetValue = function(value)
            if Multi then
                Selected = {}
                for _, v in pairs(value) do
                    Selected[v] = true
                end
            else
                Selected = value
            end
            UpdateLabel()
        end
    }
end

function Spectrum:CreateTextbox(tab, config)
    local TextboxFrame = CreateFrame(tab.Content, config.Name or "Textbox", UDim2.new(1, -10, 0, 40))
    TextboxFrame.BackgroundColor3 = Colors.Button
    
    local TextboxLabel = Instance.new("TextLabel")
    TextboxLabel.Position = UDim2.new(0, 10, 0, 0)
    TextboxLabel.Size = UDim2.new(0.4, -10, 1, 0)
    TextboxLabel.BackgroundTransparency = 1
    TextboxLabel.Text = config.Text or "Textbox"
    TextboxLabel.TextColor3 = Colors.Text
    TextboxLabel.TextSize = 14
    TextboxLabel.Font = Enum.Font.Gotham
    TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextboxLabel.Parent = TextboxFrame
    
    local Textbox = Instance.new("TextBox")
    Textbox.Name = "Textbox"
    Textbox.Position = UDim2.new(0.4, 5, 0.5, -15)
    Textbox.Size = UDim2.new(0.6, -15, 0, 30)
    Textbox.BackgroundColor3 = Colors.InputBg
    Textbox.BorderSizePixel = 0
    Textbox.Text = config.Default or ""
    Textbox.PlaceholderText = config.Placeholder or "Enter text..."
    Textbox.TextColor3 = Colors.Text
    Textbox.PlaceholderColor3 = Colors.TextDim
    Textbox.TextSize = 13
    Textbox.Font = Enum.Font.Gotham
    Textbox.ClearTextOnFocus = false
    Textbox.Parent = TextboxFrame
    
    local TextboxBorder = Instance.new("UIStroke")
    TextboxBorder.Color = Colors.Border
    TextboxBorder.Thickness = 1
    TextboxBorder.Parent = Textbox
    
    Textbox.FocusLost:Connect(function(enter)
        if config.Callback then
            config.Callback(Textbox.Text)
        end
    end)
    
    return {
        SetValue = function(text)
            Textbox.Text = text
        end
    }
end

function Spectrum:CreateKeybind(tab, config)
    local KeybindFrame = CreateFrame(tab.Content, config.Name or "Keybind", UDim2.new(1, -10, 0, 40))
    KeybindFrame.BackgroundColor3 = Colors.Button
    
    local KeybindLabel = Instance.new("TextLabel")
    KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
    KeybindLabel.Size = UDim2.new(1, -110, 1, 0)
    KeybindLabel.BackgroundTransparency = 1
    KeybindLabel.Text = config.Text or "Keybind"
    KeybindLabel.TextColor3 = Colors.Text
    KeybindLabel.TextSize = 14
    KeybindLabel.Font = Enum.Font.Gotham
    KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    KeybindLabel.Parent = KeybindFrame
    
    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Name = "KeybindButton"
    KeybindButton.Position = UDim2.new(1, -100, 0.5, -15)
    KeybindButton.Size = UDim2.new(0, 90, 0, 30)
    KeybindButton.BackgroundColor3 = Colors.Secondary
    KeybindButton.BorderSizePixel = 0
    KeybindButton.Text = config.Default or "None"
    KeybindButton.TextColor3 = Colors.Text
    KeybindButton.TextSize = 13
    KeybindButton.Font = Enum.Font.Gotham
    KeybindButton.Parent = KeybindFrame
    
    local KeybindBorder = Instance.new("UIStroke")
    KeybindBorder.Color = Colors.Border
    KeybindBorder.Thickness = 1
    KeybindBorder.Parent = KeybindButton
    
    local CurrentKey = config.Default or "None"
    local Binding = false
    
    KeybindButton.MouseButton1Click:Connect(function()
        Binding = true
        KeybindButton.Text = "..."
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if Binding then
                if input.KeyCode ~= Enum.KeyCode.Unknown then
                    CurrentKey = input.KeyCode.Name
                    KeybindButton.Text = CurrentKey
                    Binding = false
                    connection:Disconnect()
                    
                    if config.Callback then
                        config.Callback(CurrentKey)
                    end
                end
            end
        end)
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode.Name == CurrentKey and config.Callback then
            config.Callback(CurrentKey)
        end
    end)
    
    return {
        SetValue = function(key)
            CurrentKey = key
            KeybindButton.Text = key
        end
    }
end

function Spectrum:CreateColorPicker(tab, config)
    local ColorFrame = CreateFrame(tab.Content, config.Name or "ColorPicker", UDim2.new(1, -10, 0, 40))
    ColorFrame.BackgroundColor3 = Colors.Button
    
    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Position = UDim2.new(0, 10, 0, 0)
    ColorLabel.Size = UDim2.new(1, -60, 1, 0)
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Text = config.Text or "Color Picker"
    ColorLabel.TextColor3 = Colors.Text
    ColorLabel.TextSize = 14
    ColorLabel.Font = Enum.Font.Gotham
    ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    ColorLabel.Parent = ColorFrame
    
    local ColorDisplay = Instance.new("TextButton")
    ColorDisplay.Name = "ColorDisplay"
    ColorDisplay.Position = UDim2.new(1, -45, 0.5, -12.5)
    ColorDisplay.Size = UDim2.new(0, 35, 0, 25)
    ColorDisplay.BackgroundColor3 = config.Default or Color3.fromRGB(255, 255, 255)
    ColorDisplay.BorderSizePixel = 0
    ColorDisplay.Text = ""
    ColorDisplay.Parent = ColorFrame
    
    local ColorBorder = Instance.new("UIStroke")
    ColorBorder.Color = Colors.Border
    ColorBorder.Thickness = 1
    ColorBorder.Parent = ColorDisplay
    
    local CurrentColor = config.Default or Color3.fromRGB(255, 255, 255)
    
    ColorDisplay.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback(CurrentColor)
        end
    end)
    
    return {
        SetValue = function(color)
            CurrentColor = color
            ColorDisplay.BackgroundColor3 = color
            if config.Callback then
                config.Callback(color)
            end
        end
    }
end

function Spectrum:CreateParagraph(tab, config)
    local ParagraphFrame = CreateFrame(tab.Content, "Paragraph", UDim2.new(1, -10, 0, 0))
    ParagraphFrame.BackgroundColor3 = Colors.Button
    ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    if config.Title then
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Position = UDim2.new(0, 10, 0, 8)
        TitleLabel.Size = UDim2.new(1, -20, 0, 20)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = config.Title
        TitleLabel.TextColor3 = Colors.Text
        TitleLabel.TextSize = 14
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.TextYAlignment = Enum.TextYAlignment.Top
        TitleLabel.Parent = ParagraphFrame
    end
    
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Position = UDim2.new(0, 10, 0, config.Title and 32 or 8)
    ContentLabel.Size = UDim2.new(1, -20, 0, 0)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = config.Content or ""
    ContentLabel.TextColor3 = Colors.TextDim
    ContentLabel.TextSize = 13
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    ContentLabel.TextWrapped = true
    ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    ContentLabel.Parent = ParagraphFrame
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 8)
    Padding.Parent = ParagraphFrame
    
    return ParagraphFrame
end

function Spectrum:CreateDivider(tab)
    local Divider = Instance.new("Frame")
    Divider.Name = "Divider"
    Divider.Size = UDim2.new(1, -10, 0, 1)
    Divider.BackgroundColor3 = Colors.Border
    Divider.BorderSizePixel = 0
    Divider.Parent = tab.Content
    
    return Divider
end

function Spectrum:CreateLabel(tab, text)
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -10, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = text or "Label"
    Label.TextColor3 = Colors.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = tab.Content
    
    return Label
end

function Spectrum:CreateUIToggle(config)
    local UIToggle = Instance.new("TextButton")
    UIToggle.Name = "UIToggle"
    UIToggle.Size = UDim2.new(0, 60, 0, 60)
    UIToggle.Position = config.Position or UDim2.new(0, 10, 0.5, -30)
    UIToggle.BackgroundColor3 = Colors.Background
    UIToggle.BorderSizePixel = 0
    UIToggle.Text = ""
    UIToggle.ZIndex = 1000
    UIToggle.Parent = self.ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = UIToggle
    
    local Border = Instance.new("UIStroke")
    Border.Color = Colors.Border
    Border.Thickness = 2
    Border.Parent = UIToggle
    
    if config.Icon then
        local Icon = CreateIcon(UIToggle, config.Icon, 35)
        Icon.Position = UDim2.new(0.5, -17.5, 0.5, -17.5)
    end
    
    local Visible = true
    local dragging = false
    local dragInput, dragStart, startPos
    local clickStart = 0
    
    UIToggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            clickStart = tick()
            dragStart = input.Position
            startPos = UIToggle.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    local clickDuration = tick() - clickStart
                    
                    if not dragging and clickDuration < 0.2 then
                        Visible = not Visible
                        self.Main.Visible = Visible
                        
                        local targetSize = Visible and UDim2.new(0, 60, 0, 60) or UDim2.new(0, 55, 0, 55)
                        Tween(UIToggle, {Size = targetSize})
                        
                        if config.Callback then
                            config.Callback(Visible)
                        end
                    end
                    
                    dragging = false
                end
            end)
        end
    end)
    
    UIToggle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragStart then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                dragging = true
                UIToggle.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    
    UIToggle.MouseEnter:Connect(function()
        Tween(UIToggle, {Size = UDim2.new(0, 65, 0, 65)})
        Tween(Border, {Thickness = 3})
    end)
    
    UIToggle.MouseLeave:Connect(function()
        Tween(UIToggle, {Size = UDim2.new(0, 60, 0, 60)})
        Tween(Border, {Thickness = 2})
    end)
    
    return UIToggle
end

return Spectrum
