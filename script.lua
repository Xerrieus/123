local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local NL_COLOR = {
    MainBG = Color3.fromRGB(8, 8, 12),
    SideBG = Color3.fromRGB(5, 5, 8),
    SectionBG = Color3.fromRGB(13, 13, 20),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(140, 140, 145)
}

local MASTER_ESP, BOX_ENABLED, NAME_ENABLED, DIST_ENABLED, SNAP_ENABLED = false, true, true, true, false
local ui_visible = true 
local running, espObjects = true, {}

local TOGGLE_KEY = Enum.KeyCode.Delete
local is_binding = false

local function silentRemoveESP(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do obj.Visible = false end
    end
end
Players.PlayerRemoving:Connect(silentRemoveESP)

local espLoop
espLoop = RunService.RenderStepped:Connect(function()
    if not running then 
        for p, _ in pairs(espObjects) do silentRemoveESP(p) end
        espLoop:Disconnect()
        return 
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not espObjects[player] then
                espObjects[player] = {
                    Box = Drawing.new("Square"), BgBar = Drawing.new("Square"), HpBar = Drawing.new("Square"),
                    Name = Drawing.new("Text"), Dist = Drawing.new("Text"), Snap = Drawing.new("Line")
                }
                local o = espObjects[player]
                o.Box.Color = NL_COLOR.Accent; o.Box.Thickness = 1.5; o.Box.Transparency = 1
                o.BgBar.Color = Color3.new(0,0,0); o.BgBar.Filled = true
                o.HpBar.Filled = true
                o.Name.Color = NL_COLOR.Text; o.Name.Size = 13; o.Name.Center = true; o.Name.Outline = true; o.Name.Font = 3
                o.Dist.Color = NL_COLOR.Text; o.Dist.Size = 13; o.Dist.Center = true; o.Dist.Outline = true; o.Dist.Font = 3
                o.Snap.Color = NL_COLOR.Accent; o.Snap.Thickness = 1; o.Snap.Transparency = 0.5
            end
            local o, char = espObjects[player], player.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local isEnemy = (player.Team ~= LocalPlayer.Team)
            if MASTER_ESP and root and isEnemy and hum and hum.Health > 0 then
                local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local fovScale = 70 / Camera.FieldOfView 
                    local size = (2500 / rootPos.Z) * fovScale
                    local boxW, boxH = math.floor(size), math.floor(size * 1.5)
                    local boxX, boxY = math.floor(rootPos.X - boxW/2), math.floor(rootPos.Y - boxH/2)
                    if BOX_ENABLED then
                        o.Box.Size = Vector2.new(boxW, boxH); o.Box.Position = Vector2.new(boxX, boxY); o.Box.Visible = true
                        local hpP = hum.Health / hum.MaxHealth
                        o.BgBar.Size = Vector2.new(4, boxH + 2); o.BgBar.Position = Vector2.new(boxX - 6, boxY - 1); o.BgBar.Visible = true
                        local hpSize = math.floor(boxH * hpP)
                        o.HpBar.Size = Vector2.new(2, hpSize); o.HpBar.Position = Vector2.new(boxX - 5, boxY + boxH - hpSize)
                        o.HpBar.Color = Color3.fromRGB(255 - (hpP * 255), hpP * 255, 0); o.HpBar.Visible = true
                    else o.Box.Visible = false; o.BgBar.Visible = false; o.HpBar.Visible = false end
                    if NAME_ENABLED then o.Name.Text = player.Name; o.Name.Position = Vector2.new(boxX + boxW/2, boxY - 16); o.Name.Visible = true else o.Name.Visible = false end
                    if DIST_ENABLED then o.Dist.Text = math.floor((Camera.CFrame.Position - root.Position).Magnitude) .. "m"; o.Dist.Position = Vector2.new(boxX + boxW/2, boxY + boxH + 2); o.Dist.Visible = true else o.Dist.Visible = false end
                    if SNAP_ENABLED then o.Snap.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); o.Snap.To = Vector2.new(boxX + boxW/2, boxY + boxH); o.Snap.Visible = true else o.Snap.Visible = false end
                else for _, obj in pairs(o) do obj.Visible = false end end
            else for _, obj in pairs(o) do obj.Visible = false end end
        end
    end
end)

local MenuGui = Instance.new("ScreenGui")
MenuGui.ResetOnSpawn = false; MenuGui.DisplayOrder = 9999
pcall(function() MenuGui.Parent = CoreGui end)
if not MenuGui.Parent then MenuGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame", MenuGui)
Main.Size = UDim2.new(0, 480, 0, 320); Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = NL_COLOR.MainBG; Main.BorderSizePixel = 0; Main.Draggable = true; Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 4)

local BindBtn = Instance.new("TextButton", Main)
BindBtn.Size = UDim2.new(0, 100, 0, 25)
BindBtn.Position = UDim2.new(1, -110, 1, -35)
BindBtn.BackgroundColor3 = NL_COLOR.SectionBG
BindBtn.BorderSizePixel = 0
BindBtn.Text = "[" .. TOGGLE_KEY.Name .. "]"
BindBtn.TextColor3 = NL_COLOR.TextDark
BindBtn.Font = "GothamSemibold"; BindBtn.TextSize = 11
Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

local BindLabel = Instance.new("TextLabel", Main)
BindLabel.Size = UDim2.new(0, 100, 0, 15)
BindLabel.Position = UDim2.new(1, -110, 1, -50)
BindLabel.BackgroundTransparency = 1
BindLabel.Text = "Menu Keybind"
BindLabel.TextColor3 = NL_COLOR.TextDark
BindLabel.Font = "GothamBold"; BindLabel.TextSize = 10; BindLabel.TextXAlignment = "Center"

BindBtn.MouseButton1Click:Connect(function()
    is_binding = true
    BindBtn.Text = "..."
    BindBtn.TextColor3 = NL_COLOR.Accent
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if is_binding then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            TOGGLE_KEY = input.KeyCode
            BindBtn.Text = "[" .. TOGGLE_KEY.Name .. "]"
            BindBtn.TextColor3 = NL_COLOR.TextDark
            is_binding = false
        end
        return
    end
    if not gpe and input.KeyCode == TOGGLE_KEY then
        ui_visible = not ui_visible
        Main.Visible = ui_visible
    end
end)

local LogoContainer = Instance.new("Frame", Main)
LogoContainer.Size = UDim2.new(0, 100, 0, 35); LogoContainer.BackgroundTransparency = 1
local TopLine = Instance.new("Frame", LogoContainer)
TopLine.Size = UDim2.new(1, 0, 0, 2); TopLine.BackgroundColor3 = NL_COLOR.Accent; TopLine.BorderSizePixel = 0
Instance.new("UICorner", TopLine).CornerRadius = UDim.new(0, 4)
local LogoText = Instance.new("TextLabel", LogoContainer)
LogoText.Size = UDim2.new(1, 0, 1, 0); LogoText.Position = UDim2.new(0, 10, 0, 2); LogoText.BackgroundTransparency = 1; LogoText.Text = "NEVERLOSE.CC"; LogoText.TextColor3 = NL_COLOR.Text; LogoText.Font = "GothamBold"; LogoText.TextSize = 13; LogoText.TextXAlignment = "Left"

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 100, 1, -35); Sidebar.Position = UDim2.new(0, 0, 0, 35); Sidebar.BackgroundColor3 = NL_COLOR.SideBG; Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 4)
local TabHolder = Instance.new("Frame", Sidebar); TabHolder.Size = UDim2.new(1, 0, 1, 0); TabHolder.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout", TabHolder); TabLayout.HorizontalAlignment = "Center"; TabLayout.Padding = UDim.new(0, 5)
Instance.new("UIPadding", TabHolder).PaddingTop = UDim.new(0, 10)

local function createTab(name, active)
    local t = Instance.new("TextButton", TabHolder)
    t.Size = UDim2.new(1, -20, 0, 30); t.BackgroundTransparency = 1; t.Text = name; t.Font = "GothamSemibold"; t.TextSize = 13; t.TextColor3 = active and NL_COLOR.Accent or NL_COLOR.TextDark; t.TextXAlignment = "Left"
    return t
end
local tVisuals = createTab("Visuals", true); local tMisc = createTab("Misc", false)

local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -115, 1, -45); Pages.Position = UDim2.new(0, 110, 0, 40); Pages.BackgroundTransparency = 1
local VisualsPage = Instance.new("ScrollingFrame", Pages); VisualsPage.Size = UDim2.new(1, 0, 1, 0); VisualsPage.BackgroundTransparency = 1; VisualsPage.ScrollBarThickness = 0
local MiscPage = Instance.new("Frame", Pages); MiscPage.Size = UDim2.new(1, 0, 1, 0); MiscPage.BackgroundTransparency = 1; MiscPage.Visible = false

-- [ESP Sections]
local function createNLSection(parent, title)
    local sect = Instance.new("Frame", parent); sect.Size = UDim2.new(1, 0, 0, 40); sect.BackgroundColor3 = NL_COLOR.SectionBG; sect.BorderSizePixel = 0
    Instance.new("UICorner", sect).CornerRadius = UDim.new(0, 4)
    local top = Instance.new("Frame", sect); top.Size = UDim2.new(1, 0, 0, 40); top.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", top); label.Size = UDim2.new(1, -60, 1, 0); label.Position = UDim2.new(0, 12, 0, 0); label.BackgroundTransparency = 1; label.Text = title:upper(); label.TextColor3 = NL_COLOR.Text; label.Font = "GothamBold"; label.TextSize = 11; label.TextXAlignment = "Left"
    local sw = Instance.new("TextButton", top); sw.Size = UDim2.new(0, 28, 0, 14); sw.Position = UDim2.new(1, -40, 0, 13); sw.BackgroundColor3 = Color3.fromRGB(35, 35, 45); sw.Text = ""; Instance.new("UICorner", sw)
    local d = Instance.new("Frame", sw); d.Size = UDim2.new(0, 10, 0, 10); d.Position = UDim2.new(0, 2, 0, 2); d.BackgroundColor3 = Color3.fromRGB(90, 90, 95); Instance.new("UICorner", d)
    local isExpanded, content = false, Instance.new("Frame", sect); content.Size = UDim2.new(1, 0, 0, 140); content.Position = UDim2.new(0, 0, 0, 40); content.Visible = false; content.BackgroundTransparency = 1
    sw.MouseButton1Click:Connect(function() MASTER_ESP = not MASTER_ESP; d:TweenPosition(MASTER_ESP and UDim2.new(0, 16, 0, 2) or UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.1, true); d.BackgroundColor3 = MASTER_ESP and NL_COLOR.Accent or Color3.fromRGB(90, 90, 95) end)
    top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isExpanded = not isExpanded; sect.Size = isExpanded and UDim2.new(1, 0, 0, 180) or UDim2.new(1, 0, 0, 40); content.Visible = isExpanded end end)
    return content
end
local espSect = createNLSection(VisualsPage, "Enemy ESP")

local function addNLToggle(parent, text, y, default, callback)
    local t = Instance.new("TextButton", parent); t.Size = UDim2.new(1, 0, 0, 30); t.Position = UDim2.new(0, 12, 0, y); t.BackgroundTransparency = 1; t.Text = text; t.TextColor3 = default and NL_COLOR.Text or NL_COLOR.TextDark; t.Font = "GothamSemibold"; t.TextSize = 12; t.TextXAlignment = "Left"
    local b = Instance.new("Frame", t); b.Size = UDim2.new(0, 12, 0, 12); b.Position = UDim2.new(1, -40, 0, 9); b.BackgroundColor3 = default and NL_COLOR.Accent or Color3.fromRGB(30, 30, 40); Instance.new("UICorner", b)
    t.MouseButton1Click:Connect(function() default = not default; callback(default); b.BackgroundColor3 = default and NL_COLOR.Accent or Color3.fromRGB(30, 30, 40); t.TextColor3 = default and NL_COLOR.Text or NL_COLOR.TextDark end)
end
addNLToggle(espSect, "Box ESP", 5, true, function(s) BOX_ENABLED = s end); addNLToggle(espSect, "Name ESP", 35, true, function(s) NAME_ENABLED = s end); addNLToggle(espSect, "Distance", 65, true, function(s) DIST_ENABLED = s end); addNLToggle(espSect, "Snaplines", 95, false, function(s) SNAP_ENABLED = s end)

-- [Misc Page - Safe Exit]
local unl = Instance.new("TextButton", MiscPage)
unl.Size = UDim2.new(1, 0, 0, 40); unl.Position = UDim2.new(0,0,0,10); unl.BackgroundColor3 = NL_COLOR.SectionBG; unl.Text = "Silent Unload"; unl.TextColor3 = Color3.new(1, 0.3, 0.3); unl.Font = "GothamBold"; Instance.new("UICorner", unl)
unl.MouseButton1Click:Connect(function() running = false; MASTER_ESP = false; Main.Visible = false; MenuGui.Enabled = false end)

tVisuals.MouseButton1Click:Connect(function() VisualsPage.Visible = true; MiscPage.Visible = false; tVisuals.TextColor3 = NL_COLOR.Accent; tMisc.TextColor3 = NL_COLOR.TextDark end)
tMisc.MouseButton1Click:Connect(function() VisualsPage.Visible = false; MiscPage.Visible = true; tVisuals.TextColor3 = NL_COLOR.TextDark; tMisc.TextColor3 = NL_COLOR.Accent end)
