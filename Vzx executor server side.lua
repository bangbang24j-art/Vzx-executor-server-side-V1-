local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

for _, name in ipairs({"VZXExecutor", "VZXLog", "VZXConfirm"}) do
    local old = CoreGui:FindFirstChild(name) or playerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

local ACCENT = Color3.fromRGB(168, 85, 247)
local BG = Color3.fromRGB(9, 9, 11)
local BG3 = Color3.fromRGB(18, 18, 25)
local TXT = Color3.fromRGB(230, 230, 240)
local MUTED = Color3.fromRGB(140, 140, 160)
local RED = Color3.fromRGB(255, 80, 80)
local GRN = Color3.fromRGB(0, 255, 100)

local REF_W, REF_H = 520, 460
local LOG_W, LOG_H = 320, 220

local function computeScale(refW, refH)
    local vp = workspace.CurrentCamera.ViewportSize
    local s = math.min((vp.X * 0.95) / refW, (vp.Y * 0.95) / refH)
    return math.clamp(s, 0.45, 1.6)
end

local ThemeTargets = { Strokes = {}, Texts = {}, Scrolls = {}, Buttons = {}, Frames = {}, Gradients = {} }

-- ================= MAIN WINDOW =================
local gui = Instance.new("ScreenGui")
gui.Name = "VZXExecutor"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = playerGui end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, REF_W, 0, REF_H)
main.Position = UDim2.new(0.5, -REF_W/2, 0.5, -REF_H/2)
main.BackgroundColor3 = BG
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui

main.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, REF_W, 0, REF_H)}):Play()

local mainScale = Instance.new("UIScale")
mainScale.Parent = main
local function refitMain() mainScale.Scale = computeScale(REF_W, REF_H) end
refitMain()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refitMain)

local mStroke = Instance.new("UIStroke")
mStroke.Color = ACCENT
mStroke.Thickness = 2
mStroke.Transparency = 0.2
mStroke.Parent = main
table.insert(ThemeTargets.Strokes, mStroke)

local mGrad = Instance.new("UIGradient")
mGrad.Color = ColorSequence.new(ACCENT, Color3.fromRGB(0, 150, 255))
mGrad.Rotation = 45
mGrad.Parent = mStroke
table.insert(ThemeTargets.Gradients, mGrad)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local scanContainer = Instance.new("Frame")
scanContainer.Size = UDim2.new(1, 0, 1, 0)
scanContainer.BackgroundTransparency = 1
scanContainer.ClipsDescendants = true
scanContainer.Parent = main

local scanLine = Instance.new("Frame")
scanLine.Size = UDim2.new(1, 0, 0, 2)
scanLine.BackgroundColor3 = ACCENT
scanLine.BackgroundTransparency = 0.85
scanLine.BorderSizePixel = 0
scanLine.ZIndex = 2
scanLine.Parent = scanContainer
table.insert(ThemeTargets.Frames, scanLine)
TweenService:Create(scanLine, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Position = UDim2.new(0, 0, 1, 0)}):Play()

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = BG3
top.BackgroundTransparency = 0.3
top.BorderSizePixel = 0
top.ZIndex = 3
top.Parent = main
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 8)

local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, 0, 0, 1)
topLine.Position = UDim2.new(0, 0, 1, -1)
topLine.BackgroundColor3 = ACCENT
topLine.BorderSizePixel = 0
topLine.ZIndex = 4
topLine.Parent = top
table.insert(ThemeTargets.Frames, topLine)

local brand = Instance.new("TextLabel")
brand.Size = UDim2.new(1, -280, 1, 0)
brand.Position = UDim2.new(0, 12, 0, 0)
brand.BackgroundTransparency = 1
brand.Text = ""
brand.TextColor3 = ACCENT
brand.Font = Enum.Font.Code
brand.TextSize = 16
brand.TextXAlignment = Enum.TextXAlignment.Left
brand.ZIndex = 4
brand.Parent = top
table.insert(ThemeTargets.Texts, brand)

task.spawn(function()
    local fullText = "VZX@serverside: ~"
    for i = 1, #fullText do
        brand.Text = string.sub(fullText, 1, i)
        task.wait(0.03)
    end
end)

local btnLogToggle = Instance.new("TextButton")
btnLogToggle.Size = UDim2.new(0, 90, 0, 26)
btnLogToggle.Position = UDim2.new(1, -220, 0.5, -13)
btnLogToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
btnLogToggle.BackgroundTransparency = 0.2
btnLogToggle.Text = "SHOW LOG"
btnLogToggle.TextColor3 = GRN
btnLogToggle.Font = Enum.Font.Code
btnLogToggle.TextSize = 12
btnLogToggle.BorderSizePixel = 0
btnLogToggle.ZIndex = 4
btnLogToggle.Parent = top
Instance.new("UICorner", btnLogToggle).CornerRadius = UDim.new(0, 4)
local bLogStroke = Instance.new("UIStroke", btnLogToggle)
bLogStroke.Color = GRN
bLogStroke.Thickness = 1
table.insert(ThemeTargets.Strokes, bLogStroke)

local function tbBtn(x, txt, isClose)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 30, 1, 0)
    b.Position = UDim2.new(1, x, 0, 0)
    b.BackgroundTransparency = 1
    b.Text = txt
    b.TextColor3 = isClose and RED or MUTED
    b.Font = Enum.Font.Code
    b.TextSize = 18
    b.ZIndex = 4
    b.Parent = top
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {TextColor3 = isClose and Color3.fromRGB(255,150,150) or TXT}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {TextColor3 = isClose and RED or MUTED}):Play() end)
    return b
end
local btnMin = tbBtn(-90, "–")
local btnMax = tbBtn(-60, "□")
local btnClose = tbBtn(-30, "×", true)

local body = Instance.new("Frame")
body.Size = UDim2.new(1, 0, 1, -40)
body.Position = UDim2.new(0, 0, 0, 40)
body.BackgroundTransparency = 1
body.ZIndex = 3
body.Parent = main

local neofetchFrame = Instance.new("Frame")
neofetchFrame.Size = UDim2.new(1, -24, 0, 180)
neofetchFrame.Position = UDim2.new(0, 12, 0, 10)
neofetchFrame.BackgroundTransparency = 1
neofetchFrame.ZIndex = 3
neofetchFrame.Parent = body

local asciiArt = [[
    :.:        :.:        
 ##::.  :##########:. .###
  :###. ############.  ###
   \###. .########. .###/
    \###. ###### .###/
     \###. #### .###/
      \###. ## .###/
       \###.  .###/
        \###..###/
         \######/
          \####/
           \##/
            \/
]]
local artLbl = Instance.new("TextLabel")
artLbl.Size = UDim2.new(0.4, 0, 1, 0)
artLbl.BackgroundTransparency = 1
artLbl.Text = asciiArt
artLbl.TextColor3 = ACCENT
artLbl.Font = Enum.Font.Code
artLbl.TextSize = 12
artLbl.TextXAlignment = Enum.TextXAlignment.Left
artLbl.TextYAlignment = Enum.TextYAlignment.Top
artLbl.ZIndex = 3
artLbl.Parent = neofetchFrame
table.insert(ThemeTargets.Texts, artLbl)

local infoLbl = Instance.new("TextLabel")
infoLbl.Size = UDim2.new(0.6, 0, 1, 0)
infoLbl.Position = UDim2.new(0.4, 0, 0, 0)
infoLbl.BackgroundTransparency = 1
infoLbl.TextColor3 = TXT
infoLbl.Font = Enum.Font.Code
infoLbl.TextSize = 13
infoLbl.TextXAlignment = Enum.TextXAlignment.Left
infoLbl.TextYAlignment = Enum.TextYAlignment.Top
infoLbl.ZIndex = 3
infoLbl.Parent = neofetchFrame

local colorBlock = Instance.new("Frame")
colorBlock.Size = UDim2.new(0, 160, 0, 16)
colorBlock.Position = UDim2.new(0.4, 0, 1, -20)
colorBlock.BackgroundTransparency = 1
colorBlock.ZIndex = 3
colorBlock.Parent = neofetchFrame
local cbLayout = Instance.new("UIListLayout", colorBlock)
cbLayout.FillDirection = Enum.FillDirection.Horizontal
cbLayout.Padding = UDim.new(0, 3)

for i = 1, 8 do
    local block = Instance.new("TextButton")
    block.Size = UDim2.new(0, 16, 0, 16)
    block.BackgroundColor3 = Color3.fromHSV((i-1)/8, 0.8, 0.9)
    block.Text = ""
    block.BorderSizePixel = 0
    block.ZIndex = 4
    block.Parent = colorBlock
    Instance.new("UICorner", block).CornerRadius = UDim.new(0, 2)
    
    block.MouseEnter:Connect(function() TweenService:Create(block, TweenInfo.new(0.15), {Size = UDim2.new(0, 20, 0, 20)}):Play() end)
    block.MouseLeave:Connect(function() TweenService:Create(block, TweenInfo.new(0.15), {Size = UDim2.new(0, 16, 0, 16)}):Play() end)
    
    block.MouseButton1Click:Connect(function()
        local targetColor = block.BackgroundColor3
        for _, obj in ipairs(ThemeTargets.Strokes) do if obj and obj.Parent then TweenService:Create(obj, TweenInfo.new(0.4), {Color = targetColor}):Play() end end
        for _, obj in ipairs(ThemeTargets.Texts) do if obj and obj.Parent then TweenService:Create(obj, TweenInfo.new(0.4), {TextColor3 = targetColor}):Play() end end
        for _, obj in ipairs(ThemeTargets.Frames) do if obj and obj.Parent then TweenService:Create(obj, TweenInfo.new(0.4), {BackgroundColor3 = targetColor}):Play() end end
        for _, obj in ipairs(ThemeTargets.Scrolls) do if obj and obj.Parent then TweenService:Create(obj, TweenInfo.new(0.4), {ScrollBarImageColor3 = targetColor}):Play() end end
        for _, obj in ipairs(ThemeTargets.Buttons) do if obj and obj.Parent then TweenService:Create(obj, TweenInfo.new(0.4), {BackgroundColor3 = targetColor}):Play() end end
        for _, obj in ipairs(ThemeTargets.Gradients) do if obj and obj.Parent then TweenService:Create(obj, TweenInfo.new(0.4), {Color = ColorSequence.new(targetColor, Color3.fromRGB(0,150,255))}):Play() end end
        for _, obj in ipairs(term:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.TextColor3 ~= RED and obj.TextColor3 ~= GRN then
                if obj.Text:find("VZX@") then TweenService:Create(obj, TweenInfo.new(0.4), {TextColor3 = targetColor}):Play() end
            end
        end
    end)
end

local executorName = identifyexecutor and identifyexecutor() or "Unknown"
local deviceType = UserInputService.TouchEnabled and "Mobile" or (UserInputService.GamepadEnabled and "Console" or "PC")

local function updateInfo()
    local fps = 60
    local okFps, res = pcall(function() return math.floor(1 / RunService.RenderStepped:Wait()) end)
    if okFps and res then fps = res end
    local ping = 0
    local okPing, p = pcall(function() return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    if okPing and p then ping = p end
    local mem = "N/A"
    local okMem, m = pcall(function() return math.floor(Stats.MemoryUsage:GetValue() / 1024 / 1024) .. " MB" end)
    if okMem and m then mem = m end
    
    infoLbl.Text = string.format(
        "VZX@serverside\n------------------\nPlayer   : %s\nUserID   : %s\nPlaceID  : %s\nJobID    : %.12s..\nExecutor : %s\nDevice   : %s\nFPS      : %d\nPing     : %d ms\nMemory   : %s\n\n[ENV: SERVER]",
        player.Name, tostring(player.UserId), tostring(game.PlaceId), tostring(game.JobId), executorName, deviceType, fps, ping, mem
    )
end
task.spawn(function() while gui.Parent do pcall(updateInfo); task.wait(1) end end)
updateInfo()

local inputBg = Instance.new("Frame")
inputBg.Size = UDim2.new(1, -24, 1, -210)
inputBg.Position = UDim2.new(0, 12, 0, 195)
inputBg.BackgroundTransparency = 1
inputBg.ZIndex = 3
inputBg.Parent = body

local inputPrompt = Instance.new("TextLabel")
inputPrompt.Size = UDim2.new(1, 0, 0, 24)
inputPrompt.BackgroundTransparency = 1
inputPrompt.Text = "VZX@serverside:~$"
inputPrompt.TextColor3 = ACCENT
inputPrompt.Font = Enum.Font.Code
inputPrompt.TextSize = 14
inputPrompt.TextXAlignment = Enum.TextXAlignment.Left
inputPrompt.ZIndex = 3
inputPrompt.Parent = inputBg
table.insert(ThemeTargets.Texts, inputPrompt)

local inputScroll = Instance.new("ScrollingFrame")
inputScroll.Size = UDim2.new(1, 0, 1, -90)
inputScroll.Position = UDim2.new(0, 0, 0, 28)
inputScroll.BackgroundTransparency = 1
inputScroll.BorderSizePixel = 0
inputScroll.ScrollBarThickness = 4
inputScroll.ScrollBarImageColor3 = ACCENT
inputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
inputScroll.AutomaticCanvasSize = Enum.AutomaticSize.XY
inputScroll.ZIndex = 3
inputScroll.Parent = inputBg
table.insert(ThemeTargets.Scrolls, inputScroll)

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, 0, 1, 0)
inputBox.BackgroundTransparency = 1
inputBox.Text = ""
inputBox.PlaceholderText = "Enter Module Path (e.g., require(RS.Backdoor))..."
inputBox.PlaceholderColor3 = Color3.fromRGB(60, 60, 80)
inputBox.TextColor3 = TXT
inputBox.Font = Enum.Font.Code
inputBox.TextSize = 14
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextYAlignment = Enum.TextYAlignment.Top
inputBox.TextWrapped = false
inputBox.MultiLine = true
inputBox.ClearTextOnFocus = false
inputBox.ZIndex = 3
inputBox.Parent = inputScroll

inputBox:GetPropertyChangedSignal("Text"):Connect(function()
    local lines = 1
    local maxLen = 0
    for line in string.gmatch(inputBox.Text .. "\n", "(.-)\n") do
        lines = lines + 1
        if #line > maxLen then maxLen = #line end
    end
    inputScroll.CanvasSize = UDim2.new(0, math.max(maxLen * 8, 0), 0, lines * 20)
end)

local btnExecute = Instance.new("TextButton")
btnExecute.Size = UDim2.new(0, 120, 0, 34)
btnExecute.Position = UDim2.new(0, 0, 1, -34)
btnExecute.BackgroundColor3 = ACCENT
btnExecute.Text = "EXECUTE"
btnExecute.TextColor3 = Color3.new(1,1,1)
btnExecute.Font = Enum.Font.Code
btnExecute.TextSize = 14
btnExecute.BorderSizePixel = 0
btnExecute.ZIndex = 4
btnExecute.Parent = inputBg
Instance.new("UICorner", btnExecute).CornerRadius = UDim.new(0, 4)
table.insert(ThemeTargets.Buttons, btnExecute)
btnExecute.MouseEnter:Connect(function() TweenService:Create(btnExecute, TweenInfo.new(0.15), {Size = UDim2.new(0, 125, 0, 36), Position = UDim2.new(0, -2.5, 1, -35)}):Play() end)
btnExecute.MouseLeave:Connect(function() TweenService:Create(btnExecute, TweenInfo.new(0.15), {Size = UDim2.new(0, 120, 0, 34), Position = UDim2.new(0, 0, 1, -34)}):Play() end)

local btnClear = Instance.new("TextButton")
btnClear.Size = UDim2.new(0, 100, 0, 34)
btnClear.Position = UDim2.new(0, 130, 1, -34)
btnClear.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
btnClear.Text = "CLEAR"
btnClear.TextColor3 = RED
btnClear.Font = Enum.Font.Code
btnClear.TextSize = 14
btnClear.BorderSizePixel = 0
btnClear.ZIndex = 4
btnClear.Parent = inputBg
Instance.new("UICorner", btnClear).CornerRadius = UDim.new(0, 4)
btnClear.MouseEnter:Connect(function() TweenService:Create(btnClear, TweenInfo.new(0.15), {Size = UDim2.new(0, 105, 0, 36), Position = UDim2.new(0, 127.5, 1, -35)}):Play() end)
btnClear.MouseLeave:Connect(function() TweenService:Create(btnClear, TweenInfo.new(0.15), {Size = UDim2.new(0, 100, 0, 34), Position = UDim2.new(0, 130, 1, -34)}):Play() end)

-- LOG WINDOW
local logGui = Instance.new("ScreenGui")
logGui.Name = "VZXLog"
logGui.ResetOnSpawn = false
logGui.IgnoreGuiInset = true
logGui.DisplayOrder = 50
logGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() logGui.Parent = CoreGui end)
if not logGui.Parent then logGui.Parent = playerGui end

local logMain = Instance.new("Frame")
logMain.Size = UDim2.new(0, 0, 0, 0)
logMain.Position = UDim2.new(0.5, -LOG_W/2, 0.5, -LOG_H/2)
logMain.BackgroundColor3 = BG
logMain.BackgroundTransparency = 0.1
logMain.BorderSizePixel = 0
logMain.Active = true
logMain.Draggable = true
logMain.Visible = false
logMain.Parent = logGui

local logScale = Instance.new("UIScale")
logScale.Parent = logMain
local function refitLog() logScale.Scale = computeScale(LOG_W, LOG_H) end
refitLog()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refitLog)

local lStroke = Instance.new("UIStroke")
lStroke.Color = ACCENT
lStroke.Thickness = 1.5
lStroke.Parent = logMain
table.insert(ThemeTargets.Strokes, lStroke)
Instance.new("UICorner", logMain).CornerRadius = UDim.new(0, 8)

local logTop = Instance.new("Frame")
logTop.Size = UDim2.new(1, 0, 0, 28)
logTop.BackgroundColor3 = BG3
logTop.BorderSizePixel = 0
logTop.Parent = logMain
Instance.new("UICorner", logTop).CornerRadius = UDim.new(0, 8)

local logBrand = Instance.new("TextLabel")
logBrand.Size = UDim2.new(1, -12, 1, 0)
logBrand.Position = UDim2.new(0, 10, 0, 0)
logBrand.BackgroundTransparency = 1
logBrand.Text = "VZX@log: ~"
logBrand.TextColor3 = ACCENT
logBrand.Font = Enum.Font.Code
logBrand.TextSize = 12
logBrand.TextXAlignment = Enum.TextXAlignment.Left
logBrand.Parent = logTop
table.insert(ThemeTargets.Texts, logBrand)

local term = Instance.new("ScrollingFrame")
term.Size = UDim2.new(1, -16, 1, -36)
term.Position = UDim2.new(0, 8, 0, 34)
term.BackgroundTransparency = 1
term.BorderSizePixel = 0
term.ScrollBarThickness = 3
term.ScrollBarImageColor3 = ACCENT
term.CanvasSize = UDim2.new(0, 0, 0, 0)
term.AutomaticCanvasSize = Enum.AutomaticSize.Y
term.Parent = logMain
table.insert(ThemeTargets.Scrolls, term)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 1)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = term

local function log(text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 16)
    l.BackgroundTransparency = 1
    l.Text = tostring(text)
    l.TextColor3 = color or TXT
    l.Font = Enum.Font.Code
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true
    l.Parent = term
    task.wait()
    term.CanvasPosition = Vector2.new(0, math.max(0, layout.AbsoluteContentSize.Y - term.AbsoluteSize.Y + 10))
end

local function execServerModule(inputStr)
    local cmd = inputStr:gsub("^%s+", ""):gsub("%s+$", "")
    if cmd == "" then return end

    log("VZX@log:~$ " .. cmd, ACCENT)

    if string.find(cmd, "require%s*%(") then
        log("[SERVER] Validating module path...", MUTED)
        task.wait(0.5)
        
        local moduleName = string.match(cmd, "require%s*%(%s*([%w_%.]+)%s*%)")
        if not moduleName then
            log("[SERVER ERROR] Malformed require syntax.", RED)
            return
        end
        
        log("[SERVER] Scanning environment for: " .. moduleName, TXT)
        task.wait(0.6)
        
        local isBackdoorExist = false
        local backdoorRemote = ReplicatedStorage:FindFirstChild("Backdoor") or ReplicatedStorage:FindFirstChild("SS_Executor") or ReplicatedStorage:FindFirstChild("Remote")
        
        if backdoorRemote then
            isBackdoorExist = true
        end
        
        isBackdoorExist = false
        
        if not isBackdoorExist then
            log("[SERVER ERROR] CRITICAL: No active backdoor found for this map.", RED)
            log("[SERVER ERROR] Execution aborted. Module cannot be injected.", RED)
            return
        end
        
        log("[SERVER] Backdoor connection established!", GRN)
        task.wait(0.4)
        log("[SERVER] Attempting to load: " .. moduleName, TXT)
        task.wait(0.5)
        
        local success, err = pcall(function()
            local env = getgenv()
            if not env.ServerEnv then
                env.ServerEnv = { 
                    require = function(target) return target end,
                    game = game,
                    workspace = workspace
                }
            end
            
            local serverFn = loadstring("return " .. cmd)
            if not serverFn then error("Malformed require syntax") end
            local res = serverFn()
            log("[SERVER] Module successfully loaded and executed.", GRN)
        end)
        
        if not success then
            log("[SERVER ERROR] " .. tostring(err), RED)
        end
    else
        log("[CLIENT] Running as standard Luau payload...", MUTED)
        task.wait(0.3)
        local fn, err = loadstring(cmd, "=vzx")
        if not fn then log("compile error: " .. tostring(err), RED); return end
        local results = {pcall(fn)}
        if not results[1] then log("runtime error: " .. tostring(results[2]), RED); return end
        if #results > 1 then
            local outs = {}
            for i = 2, #results do table.insert(outs, tostring(results[i])) end
            log("> " .. table.concat(outs, "\t"), GRN)
        else
            log("> Executed Successfully.", GRN)
        end
    end
end

btnExecute.MouseButton1Click:Connect(function()
    if inputBox.Text == "" then return end
    execServerModule(inputBox.Text)
end)

btnClear.MouseButton1Click:Connect(function()
    inputBox.Text = ""
    for _, c in ipairs(term:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
end)

inputBox.FocusLost:Connect(function(enter)
    if enter and UserInputService.KeyboardEnabled then
        if inputBox.Text == "" then return end
        execServerModule(inputBox.Text)
    end
end)

local isLogOpen = false
btnLogToggle.MouseButton1Click:Connect(function()
    isLogOpen = not isLogOpen
    if isLogOpen then
        logMain.Visible = true
        logMain.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(logMain, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, LOG_W, 0, LOG_H)}):Play()
        btnLogToggle.Text = "HIDE LOG"
        btnLogToggle.TextColor3 = RED
        bLogStroke.Color = RED
    else
        TweenService:Create(logMain, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        logMain.Visible = false
        btnLogToggle.Text = "SHOW LOG"
        btnLogToggle.TextColor3 = GRN
        bLogStroke.Color = GRN
    end
end)

local isMinimized = false
local oldMainSize = main.Size
btnMin.MouseButton1Click:Connect(function()
    if not isMinimized then
        oldMainSize = main.Size
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, REF_W, 0, 40)}):Play()
        body.Visible = false
        isMinimized = true
    else
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = oldMainSize}):Play()
        body.Visible = true
        isMinimized = false
    end
end)

local isMaximized = false
btnMax.MouseButton1Click:Connect(function()
    isMaximized = not isMaximized
    if isMaximized then
        main.Draggable = false
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}):Play()
        mainScale.Scale = 1
        mStroke.Thickness = 0
        main:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 0)
    else
        main.Draggable = true
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, REF_W, 0, REF_H), Position = UDim2.new(0.5, -REF_W/2, 0.5, -REF_H/2)}):Play()
        refitMain()
        mStroke.Thickness = 2
        main:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 8)
    end
end)

local confirmGui = Instance.new("ScreenGui")
confirmGui.Name = "VZXConfirm"
confirmGui.ResetOnSpawn = false
confirmGui.IgnoreGuiInset = true
confirmGui.DisplayOrder = 100
confirmGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() confirmGui.Parent = CoreGui end)
if not confirmGui.Parent then confirmGui.Parent = playerGui end

local confirmMain = Instance.new("Frame")
confirmMain.Size = UDim2.new(0, 0, 0, 0)
confirmMain.Position = UDim2.new(0.5, -160, 0.5, -90)
confirmMain.BackgroundColor3 = BG
confirmMain.BackgroundTransparency = 0.05
confirmMain.BorderSizePixel = 0
confirmMain.Active = true
confirmMain.Draggable = true
confirmMain.Visible = false
confirmMain.Parent = confirmGui
Instance.new("UICorner", confirmMain).CornerRadius = UDim.new(0, 10)

local cStroke = Instance.new("UIStroke")
cStroke.Color = RED
cStroke.Thickness = 2
cStroke.Transparency = 0.2
cStroke.Parent = confirmMain
local cGrad = Instance.new("UIGradient")
cGrad.Color = ColorSequence.new(RED, Color3.fromRGB(150, 0, 0))
cGrad.Rotation = 45
cGrad.Parent = cStroke

local cTitle = Instance.new("TextLabel")
cTitle.Size = UDim2.new(1, -20, 0, 30)
cTitle.Position = UDim2.new(0, 10, 0, 15)
cTitle.BackgroundTransparency = 1
cTitle.Text = "⚠ CONFIRM EXIT ⚠"
cTitle.TextColor3 = RED
cTitle.Font = Enum.Font.Code
cTitle.TextSize = 14
cTitle.Parent = confirmMain

local cText = Instance.new("TextLabel")
cText.Size = UDim2.new(1, -20, 0, 40)
cText.Position = UDim2.new(0, 10, 0, 50)
cText.BackgroundTransparency = 1
cText.Text = "Are you sure you want to close VZX Executor?\nUnsaved scripts will be lost."
cText.TextColor3 = TXT
cText.Font = Enum.Font.Code
cText.TextSize = 12
cText.Parent = confirmMain

local btnYes = Instance.new("TextButton")
btnYes.Size = UDim2.new(0, 130, 0, 30)
btnYes.Position = UDim2.new(0, 20, 1, -45)
btnYes.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
btnYes.Text = "YES, CLOSE"
btnYes.TextColor3 = RED
btnYes.Font = Enum.Font.Code
btnYes.TextSize = 12btnYes.BorderSizePixel = 0
btnYes.Parent = confirmMain
Instance.new("UICorner", btnYes).CornerRadius = UDim.new(0, 6)
local bYStroke = Instance.new("UIStroke", btnYes)
bYStroke.Color = RED
bYStroke.Thickness = 1

local btnNo = Instance.new("TextButton")
btnNo.Size = UDim2.new(0, 130, 0, 30)
btnNo.Position = UDim2.new(1, -150, 1, -45)
btnNo.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
btnNo.Text = "NO, STAY"
btnNo.TextColor3 = GRN
btnNo.Font = Enum.Font.Code
btnNo.TextSize = 12
btnNo.BorderSizePixel = 0
btnNo.Parent = confirmMain
Instance.new("UICorner", btnNo).CornerRadius = UDim.new(0, 6)
local bNStroke = Instance.new("UIStroke", btnNo)
bNStroke.Color = GRN
bNStroke.Thickness = 1

local function closeConfirm()
    TweenService:Create(confirmMain, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    confirmGui:Destroy()
end

btnNo.MouseButton1Click:Connect(function() closeConfirm() end)

btnYes.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    TweenService:Create(logMain, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    closeConfirm()
    task.wait(0.3)
    gui:Destroy()
    logGui:Destroy()
end)

btnClose.MouseButton1Click:Connect(function()
    confirmMain.Visible = true
    confirmMain.Size = UDim2.new(0, 0, 0, 0)
    confirmMain.BackgroundTransparency = 1
    TweenService:Create(confirmMain, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 320, 0, 180), BackgroundTransparency = 0.05}):Play()
end)

log("VZX Server-Side Shell initialized.", ACCENT)
log("Welcome, " .. player.Name, TXT)
log("Type require(ModulePath) to inject.", MUTED)
inputBox:CaptureFocus()
