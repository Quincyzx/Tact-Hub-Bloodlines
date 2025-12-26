--[[

 __      __.__    .__  __         .__  .__          __      _________               __                  
/  \    /  \  |__ |__|/  |_  ____ |  | |__| _______/  |_   /   _____/__.__. _______/  |_  ____   _____  
\   \/\/   /  |  \|  \   __\/ __ \|  | |  |/  ___/\   __\  \_____  <   |  |/  ___/\   __\/ __ \ /     \ 
 \        /|   Y  \  ||  | \  ___/|  |_|  |\___ \  |  |    /        \___  |\___ \  |  | \  ___/|  Y Y  \
  \__/\  / |___|  /__||__|  \___  >____/__/____  > |__|   /_______  / ____/____  > |__|  \___  >__|_|  /
       \/       \/              \/             \/                 \/\/         \/            \/      \/ 

--]]

-- Authentication System (HWID Only - No Keys)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

-- Get HWID
local function GetHWID()
    local success, hwid = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if success and hwid then
        return hwid
    end
    -- Fallback HWID generation
    return HttpService:GenerateGUID(false)
end

local HWID = GetHWID()

-- Authentication function - Only checks HWID mappings
local function Authenticate()
    -- Load HWID mappings from GitHub
    local mappingsSuccess, hwidMappings = pcall(function()
        local mappingsUrl = "https://raw.githubusercontent.com/Quincyzx/Tact-Hub-Bloodlines/main/hwid_mappings.lua"
        local mappingsCode = game:HttpGet(mappingsUrl)
        if mappingsCode and mappingsCode ~= "404: Not Found" and not mappingsCode:find("404") then
            return loadstring(mappingsCode)()
        end
        return {} -- Return empty table if file doesn't exist yet
    end)
    
    if not mappingsSuccess then
        hwidMappings = {}
        warn("[Auth] Failed to load HWID mappings")
    end
    
    print("[Auth] Checking HWID:", HWID)
    local mappingCount = 0
    for _ in pairs(hwidMappings) do
        mappingCount = mappingCount + 1
    end
    print("[Auth] Loaded mappings count:", mappingCount)
    
    -- Check if HWID exists in mappings
    if hwidMappings[HWID] then
        local linkedKey = hwidMappings[HWID]
        print("[Auth] HWID authenticated! Linked key:", linkedKey)
        return true
    else
        print("[Auth] HWID not found in mappings")
        return false
    end
end

-- Run initial authentication check
local authResult = Authenticate()
if authResult then
    -- HWID is authorized, continue
    _G.AuthRequired = false
    _G.AuthComplete = true
    print("[Auth] Authentication successful, continuing...")
else
    -- HWID not authorized, kick user
    warn("[Auth] HWID not authorized:", HWID)
    plr:Kick("Your HWID is not authorized. Please contact the admin to get access.\n\nYour HWID: " .. HWID)
    return
end

local queue_on_teleport = queue_on_teleport or syn.queue_on_teleport or fluxus.queue_on_teleport or function(...) return ... end

game.Players.LocalPlayer.OnTeleport:Connect(function(state)
    if state ~= Enum.TeleportState.Started and state ~= Enum.TeleportState.InProgress then return end
    queue_on_teleport([[
        repeat task.wait() until game:IsLoaded()
        if getgenv().Executed then return end
        getgenv().Executed = true
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Quincyzx/Tact-Hub-Bloodlines/main/Main.lua"))()
    ]])
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if game.PlaceId == 5571328985 then
    game:GetService("ReplicatedStorage").Events.DataEvent:FireServer("Teleport")
    return
end

if game.PlaceId ~= 10266164381 then
    warn("wrong game")
    return
end

if not game:IsLoaded() then
    game.Loaded:Wait()
    task.wait(2.5)
end

if not ReplicatedStorage:FindFirstChild("Loaded") then
    ReplicatedStorage:WaitForChild("Loaded")
    task.wait(2.5)
end

local plr = Players.LocalPlayer
if not plr then
    repeat
        task.wait()
        plr = Players.LocalPlayer
    until plr
    task.wait(2.5)
end

if not plr.Name or plr.Name == "" then
    repeat
        task.wait()
    until plr.Name and plr.Name ~= ""
    task.wait(2.5)
end

if not plr:FindFirstChild("PlayerGui") then
    plr:WaitForChild("PlayerGui")
    task.wait(2.5)
end


--[[
__________             .___.__                  __       .__                      .___               
\______   \_____     __| _/|__|_____     ____ _/  |_     |  |    ____ _____     __| _/ ____ _______  
 |       _/\__  \   / __ | |  |\__  \   /    \\   __\    |  |   /  _ \\__  \   / __ |_/ __ \\_  __ \ 
 |    |   \ / __ \_/ /_/ | |  | / __ \_|   |  \|  |      |  |__(  <_> )/ __ \_/ /_/ |\  ___/ |  | \/ 
 |____|_  /(____  /\____ | |__|(____  /|___|  /|__|      |____/ \____/(____  /\____ | \___  >|__|    
        \/      \/      \/          \/      \/                             \/      \/     \/         
                                                                                                     
--]]

-- Load modified Rayfield from GitHub
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Quincyzx/Tact-Hub-Bloodlines/main/lib.lua'))()
local Map = loadstring(game:HttpGet('https://pastebin.com/raw/HspCejNb'))()

--[[

  _____                    __  .__                      
_/ ____\_ __  ____   _____/  |_|__| ____   ____   ______
\   __\  |  \/    \_/ ___\   __\  |/  _ \ /    \ /  ___/
 |  | |  |  /   |  \  \___|  | |  (  <_> )   |  \\___ \ 
 |__| |____/|___|  /\___  >__| |__|\____/|___|  /____  >
                 \/     \/                    \/     \/ 
--]]

local Lighting = game:GetService("Lighting")
local While = game:GetService("RunService")

function Notify(T:String,Text:String,Time:Number,Icon:String)
    Rayfield:Notify({
         Title = T,
         Content = Text,
         Duration = Time,
         Image = Icon,
      })
end

function Tween(object,info,goal)
	local TweenService = game:GetService("TweenService")
	local CustomTween = TweenService:Create(object,info,goal):Play()

	return CustomTween
end

function CameraLock(Multiplier)
    local Speed = Multiplier or 1
     local lighting = game:GetService("Lighting")
     local Camera = workspace.CurrentCamera
 
     CameraLocked = true
    Camera.CameraType = Enum.CameraType.Scriptable
 
     local blurtransition = Instance.new("BlurEffect")
     blurtransition.Name = "RBlur"
     blurtransition.Size = 0
     blurtransition.Parent = lighting
 
     Tween(blurtransition,TweenInfo.new(0.8*Speed,Enum.EasingStyle.Back),{Size = 64})
 end
 
 function CameraUnLock(Multiplier)
    local Speed = Multiplier or 1
     local lighting = game:GetService("Lighting")
     local debris = game:GetService("Debris")
     local Camera = workspace.CurrentCamera
 
    CameraLocked = false
    Camera.CameraType = Enum.CameraType.Custom
 
     local blur = lighting:FindFirstChild("RBlur")
     if blur then
         Tween(blur,TweenInfo.new(0.8*Speed),{Size = 0})
         debris:AddItem(blur,0.8*Speed)
     end
 end

local function induceLag()
    local startTime = tick()
    local lagDuration = math.random(1000, 2000) / 1000

    while tick() - startTime < lagDuration do
        local value = 0
        for i = 1, 50000 do
            value = math.sqrt(math.abs(math.sin(i) * math.cos(i))) * math.tan(i)
        end
    end
end

local function sendmessage(msg)

    if Webhook_URL ~= nil then
        HttpService = game:GetService("HttpService")
        
        local response = request({
            Url = Webhook_URL,
            Method = 'POST',
            Headers = {
                ['Content-Type'] = 'application/json'
            },
            Body = HttpService:JSONEncode({
                ["content"] = "@everyone",
                ["embeds"] = {{
                    ["title"] = "**Tact Hub**",
                    ["description"] = tostring(msg),
                    ["type"] = "rich",
                    ["color"] = tonumber(0xfbfaf),
                }}
            })
        })
    end
end
local function watercrops(crop, times)
    CameraLock()
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")
    local lastPosition = hrp.CFrame

    humanoid.PlatformStand = true

    hrp.CFrame = crop.CFrame * CFrame.Angles(math.rad(180), 0, 0) * CFrame.new(0, 3.2, 0)

    local bodyPos = Instance.new("BodyPosition")
    bodyPos.Name = "FloatControl"
    bodyPos.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bodyPos.P = 1e5
    bodyPos.D = 1000
    bodyPos.Position = hrp.Position
    bodyPos.Parent = hrp

    -- Add BodyGyro to maintain upside-down rotation
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bodyGyro.P = 1e5
    bodyGyro.D = 500
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    task.wait(0.2)
    for b = 1, times,1 do
        game.ReplicatedStorage.Events.DataEvent:FireServer("WaterTheCrops", "Freshwater Bowl")
    end

    task.wait(1)
    humanoid.PlatformStand = false
    bodyPos:Destroy()
    bodyGyro:Destroy()
    task.wait(.1)
    hrp.CFrame = lastPosition
    CameraUnLock()
end

local function ReloadSN()
    local plr = game.Players.LocalPlayer
    local plrGui = plr.PlayerGui

    local SN = plrGui:FindFirstChild("TactNotifier")
    if SN then
        SN:Destroy()
    end
    local BossNot = plrGui:FindFirstChild("BossNotifierUI")
    if BossNot then
        BossNot:Destroy()
    end
    local BlackScreen = plrGui:FindFirstChild("Tact Black Screen")
    if BlackScreen then
        BlackScreen:Destroy()
    end
end
ReloadSN()



game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent").OnClientEvent:Connect(function(eventType, ...)
    if (eventType == 'InDanger') then
        InDanger = true
    elseif (eventType == 'OutOfDanger') then
        InDanger = false
    end;
end)

local BossUI = Instance.new("ScreenGui")
BossUI.Name = "BossNotifierUI"
BossUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
BossUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BossUI.IgnoreGuiInset = false
BossUI.ResetOnSpawn = false

--// Frame Holder
local BossFrame = Instance.new("Frame")
BossFrame.Name = "BossFrame"
BossFrame.Parent = BossUI
BossFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BossFrame.BackgroundTransparency = 1.0
BossFrame.BorderSizePixel = 0
BossFrame.Position = UDim2.new(0.5, 0, 0.25, 0) -- 1/4 from top
BossFrame.Size = UDim2.new(0.8, 0, 0.25, 0)
BossFrame.Visible = false

--// Boss Name Label
local BossTitle = Instance.new("TextLabel")
BossTitle.Name = "BossTitle"
BossTitle.Parent = BossFrame
BossTitle.AnchorPoint = Vector2.new(0.5, 0)
BossTitle.BackgroundTransparency = 1.0
BossTitle.Position = UDim2.new(0.5, 0, 0, 0) -- top of frame
BossTitle.Size = UDim2.new(0.95, 0, 0.4, 0)
BossTitle.ZIndex = 2
BossTitle.Font = Enum.Font.GothamBold
BossTitle.Text = "Current Boss: None"
BossTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BossTitle.TextScaled = false
BossTitle.TextSize = 35
BossTitle.TextWrapped = true

-- Add strokes for boss name
local BossTitleStroke1 = Instance.new("UIStroke")
BossTitleStroke1.Parent = BossTitle
BossTitleStroke1.Color = Color3.fromRGB(0, 0, 0)
BossTitleStroke1.Thickness = 3

local BossTitleStroke2 = Instance.new("UIStroke")
BossTitleStroke2.Parent = BossTitle
BossTitleStroke2.Color = Color3.fromRGB(50, 50, 50)
BossTitleStroke2.Thickness = 2

-- Gradient for boss name
local BossTitleGradient = Instance.new("UIGradient")
BossTitleGradient.Parent = BossTitle
BossTitleGradient.Rotation = 88
BossTitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200,200,200))
})

--// Boss Health Label (very close under title)
local BossHPLabel = Instance.new("TextLabel")
BossHPLabel.Name = "BossHPLabel"
BossHPLabel.Parent = BossFrame
BossHPLabel.AnchorPoint = Vector2.new(0.5, 0)
BossHPLabel.BackgroundTransparency = 1.0
BossHPLabel.Position = UDim2.new(0.5, 0, 0.38, 0) -- moved very close under BossTitle
BossHPLabel.Size = UDim2.new(0.7, 0, 0.25, 0)
BossHPLabel.ZIndex = 2
BossHPLabel.Font = Enum.Font.Code
BossHPLabel.Text = "0/0"
BossHPLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
BossHPLabel.TextScaled = false
BossHPLabel.TextSize = 30
BossHPLabel.TextWrapped = true

-- Add strokes for HP
local BossHPStroke1 = Instance.new("UIStroke")
BossHPStroke1.Parent = BossHPLabel
BossHPStroke1.Color = Color3.fromRGB(100,0,0)
BossHPStroke1.Thickness = 2

local BossHPStroke2 = Instance.new("UIStroke")
BossHPStroke2.Parent = BossHPLabel
BossHPStroke2.Color = Color3.fromRGB(150,0,0)
BossHPStroke2.Thickness = 1

-- Gradient for HP numbers
local BossHPGradient = Instance.new("UIGradient")
BossHPGradient.Parent = BossHPLabel
BossHPGradient.Rotation = 88
BossHPGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,50,50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150,0,0))
})

--// Aspect Ratio Lock
local BossSizeConstraint = Instance.new("UIAspectRatioConstraint")
BossSizeConstraint.Name = "BossSizeConstraint"
BossSizeConstraint.Parent = BossFrame
BossSizeConstraint.AspectRatio = 3.5

local plr = game.Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

local MainUI = Instance.new("ScreenGui")
MainUI.Name = "Tact Black Screen"
MainUI.ResetOnSpawn = false
MainUI.IgnoreGuiInset = true
MainUI.DisplayOrder = 1000
MainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainUI.Parent = playerGui
MainUI.Enabled = false

local BlackFrame = Instance.new("Frame")
BlackFrame.Size = UDim2.new(1, 0, 1, 0)
BlackFrame.Position = UDim2.new(0, 0, 0, 0)
BlackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
BlackFrame.BorderSizePixel = 0
BlackFrame.AnchorPoint = Vector2.new(0, 0)
BlackFrame.Parent = MainUI

local GripFrame = Instance.new("Frame")
GripFrame.Name = "GripFrame"
GripFrame.Parent = MainUI
GripFrame.AnchorPoint = Vector2.new(0.5, 0.5)
GripFrame.BackgroundTransparency = 1
GripFrame.BorderSizePixel = 0
GripFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
GripFrame.Size = UDim2.new(0.5, 0, 0.2, 0)
GripFrame.Visible = true

local GripLabel = Instance.new("TextLabel")
GripLabel.Name = "GripLabel"
GripLabel.Parent = GripFrame
GripLabel.AnchorPoint = Vector2.new(0.5, 0.5)
GripLabel.BackgroundTransparency = 1
GripLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
GripLabel.Size = UDim2.new(0.9, 0, 0.8, 0)
GripLabel.ZIndex = 2
GripLabel.Font = Enum.Font.GothamBold
GripLabel.Text = "[Tact Hub] \n"
GripLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GripLabel.TextScaled = true
GripLabel.TextWrapped = true

local GripStroke1 = Instance.new("UIStroke")
GripStroke1.Parent = GripLabel
GripStroke1.Color = Color3.fromRGB(0, 0, 0)
GripStroke1.Thickness = 3

local GripStroke2 = Instance.new("UIStroke")
GripStroke2.Parent = GripLabel
GripStroke2.Color = Color3.fromRGB(50, 50, 50)
GripStroke2.Thickness = 2

local GripGradient = Instance.new("UIGradient")
GripGradient.Parent = GripLabel
GripGradient.Rotation = 88
GripGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})

local GripSizeConstraint = Instance.new("UIAspectRatioConstraint")
GripSizeConstraint.Name = "GripSizeConstraint"
GripSizeConstraint.Parent = GripFrame
GripSizeConstraint.AspectRatio = 3.5



--[[
_________ .__            __                      _________                              _______          __  .__  _____.__              
\_   ___ \|  |__ _____  |  | ______________     /   _____/ ____   ____   ______ ____    \      \   _____/  |_|__|/ ____\__| ___________ 
/    \  \/|  |  \\__  \ |  |/ /\_  __ \__  \    \_____  \_/ __ \ /    \ /  ___// __ \   /   |   \ /  _ \   __\  \   __\|  |/ __ \_  __ \
\     \___|   Y  \/ __ \|    <  |  | \// __ \_  /        \  ___/|   |  \\___ \\  ___/  /    |    (  <_> )  | |  ||  |  |  \  ___/|  | \/
 \______  /___|  (____  /__|_ \ |__|  (____  / /_______  /\___  >___|  /____  >\___  > \____|__  /\____/|__| |__||__|  |__|\___  >__|   
        \/     \/     \/     \/            \/          \/     \/     \/     \/     \/          \/                              \/       
--]]

local SenseNotifier = Instance.new("ScreenGui")
SenseNotifier.Name = "TactNotifier"
SenseNotifier.Parent = game.Players.LocalPlayer.PlayerGui
SenseNotifier.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SenseNotifier.IgnoreGuiInset = false
SenseNotifier.ResetOnSpawn = false

local Scaler = Instance.new("Frame")
Scaler.Visible = true
Scaler.Name = "Scaler"
Scaler.Parent = SenseNotifier
Scaler.AnchorPoint = Vector2.new(0.5, 0.5)
Scaler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Scaler.BackgroundTransparency = 1.000
Scaler.BorderColor3 = Color3.fromRGB(0,0, 0)
Scaler.BorderSizePixel = 0
Scaler.Position = UDim2.new(0.5, 0, -0.025, 0)
Scaler.Size = UDim2.new(0.126000002, 0, 0.0329999998, 0)

local CurrentPlayersLabel = Instance.new("TextLabel")
CurrentPlayersLabel.Name = "CurrentPlayersLabel"
CurrentPlayersLabel.Parent = Scaler
CurrentPlayersLabel.AnchorPoint = Vector2.new(0.5, 0.5)
CurrentPlayersLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CurrentPlayersLabel.BackgroundTransparency = 1.000
CurrentPlayersLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
CurrentPlayersLabel.BorderSizePixel = 0
CurrentPlayersLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
CurrentPlayersLabel.Size = UDim2.new(0.9, 0, 0.9, 0)
CurrentPlayersLabel.ZIndex = 2
CurrentPlayersLabel.Font = Enum.Font.Ubuntu
CurrentPlayersLabel.Text = "Sense Players: 0"
CurrentPlayersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CurrentPlayersLabel.TextScaled = true
CurrentPlayersLabel.TextSize = 14.000
CurrentPlayersLabel.TextWrapped = true

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Visible = true
Shadow.Parent = Scaler
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Shadow.BackgroundTransparency = 1.000
Shadow.BorderColor3 = Color3.fromRGB(27, 42, 53)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(-1.15225446, 0, -2.26755214, 0)
Shadow.Image = "rbxassetid://9140300475"
Shadow.ImageTransparency = 0.27
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(283, 357, 304, 434)

local SizeFix = Instance.new("UIAspectRatioConstraint")
SizeFix.Name = "SizeFix"
SizeFix.Parent = Scaler
SizeFix.AspectRatio = 6.384

local folder = workspace.Parent:GetService("ReplicatedStorage").Cooldowns
local amount = Instance.new("IntValue",nil)
local counter = 0
local NoFallDammage = Instance.new("BoolValue")
NoFallDammage.Value = false
NoFallDammage.Name = "NoFallDamage"
playerNames = {}

local CSNotifier_Label = CurrentPlayersLabel
local CSNotifier_Enabled = true
local CSNotifier_EmergencyResetting = false

CSNotifier_Label.Text = "Sense Players: " .. tostring(amount.Value)

local function childremove(child)
    if child.Name == "Chakra Sense" then
        amount.Value = amount.Value - 1
    end
end

local function childadd(child)
    if child.Name == "Chakra Sense" then
        amount.Value = amount.Value + 1

        local sensePlayer = game.Players:FindFirstChild(child.Parent.Name)
        local sensePlayerCharacter = sensePlayer.Character
        local sensePlayerHumanoid = sensePlayerCharacter:FindFirstChildOfClass("Humanoid")

        local ingamename = sensePlayerHumanoid.DisplayName
            
        Notify(child.Parent.Name.." has chakra sense.","Ingame Name: "..ingamename,2.5,"eye")
     end
end

for i, v in pairs(folder:getChildren()) do
    if v:IsA("Folder") then
       v.ChildAdded:Connect(childadd)
        v.ChildRemoved:Connect(childremove)
    end
end

folder.ChildAdded:Connect(function(plrfolder)
    if plrfolder:IsA("Folder") then
        plrfolder.ChildAdded:Connect(childadd)
        plrfolder.ChildRemoved:Connect(childremove)
    end
end)

folder.ChildRemoved:Connect(function(plrfolder)
    for i, v in pairs(plrfolder:getChildren()) do
        if v.Name == "Chakra Sense" then
            Notify(plrfolder.Name,"has left.",2.5,"eye")
            amount.Value -= 1
       end
    end
end)

for _, player in pairs(game.Players:GetPlayers()) do
    table.insert(playerNames, player.Name)
end

for i, v in pairs(folder:getDescendants()) do
    if v.Name == "Chakra Sense" then
        if table.find(playerNames, v.Parent.Name) then
            amount.Value = amount.Value + 1

            local sensePlayer = game.Players:FindFirstChild(v.Parent.Name)
            local sensePlayerCharacter = sensePlayer.Character
            local sensePlayerHumanoid = sensePlayerCharacter:FindFirstChildOfClass("Humanoid")

            local ingamename = sensePlayerHumanoid.DisplayName

            Notify(v.Parent.Name.." has chakra sense.","Ingame Name: "..ingamename,2.5,"eye")
        end
    end
end

While.Heartbeat:Connect(function()
    if CSNotifier_Enabled then
        SenseNotifier.Enabled = false
    else
        SenseNotifier.Enabled = true
    end

    CSNotifier_Label.Text = "Sense Players: " .. tostring(amount.Value)
    counter = amount.Value
end)

--[[
__________.__                                _________      .__                 __  .__                .____    .__          __   
\______   \  | _____  ___.__. ___________   /   _____/ ____ |  |   ____   _____/  |_|__| ____   ____   |    |   |__| _______/  |_ 
 |     ___/  | \__  \<   |  |/ __ \_  __ \  \_____  \_/ __ \|  | _/ __ \_/ ___\   __\  |/  _ \ /    \  |    |   |  |/  ___/\   __\
 |    |   |  |__/ __ \\___  \  ___/|  | \/  /        \  ___/|  |_\  ___/\  \___|  | |  (  <_> )   |  \ |    |___|  |\___ \  |  |  
 |____|   |____(____  / ____|\___  >__|    /_______  /\___  >____/\___  >\___  >__| |__|\____/|___|  / |_______ \__/____  > |__|  
                    \/\/         \/                \/     \/          \/     \/                    \/          \/       \/        

--]]

local TargetPlayer = nil --//Select Player//
local ActiveSelector = false

local ActualSize = UDim2.new(0.2853598, 0, 0.515075386, 0)
local TransitionSize = UDim2.new(0.2453598, 0, 0.255075386, 0)

local Selector = Instance.new("ScreenGui")
Selector.Name = "Selector"
Selector.Parent = game.CoreGui
Selector.Enabled = false

local Shadow = Instance.new("Frame",Selector)
Shadow.Name = "Shadow"
Shadow.Active = true
Shadow.AnchorPoint = Vector2.new(0.5,0.5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 1
Shadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BorderSizePixel = 0
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(0.2853598, 0, 0.515075386, 0)

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.Parent = Shadow
ShadowCorner.CornerRadius = UDim.new(0.05,0)

local Selection = Instance.new("ScrollingFrame")
Selection.Name = "Selection"
Selection.Parent = Selector
Selection.Active = true
Selection.AnchorPoint = Vector2.new(0.5,0.5)
Selection.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Selection.BackgroundTransparency = 1
Selection.BorderColor3 = Color3.fromRGB(0, 0, 0)
Selection.BorderSizePixel = 0
Selection.Position = UDim2.new(0.5, 0, 0.5, 0)
Selection.Size = UDim2.new(0.2853598, 0, 0.515075386, 0)
Selection.CanvasSize = UDim2.new(0, 0, 3, 0)
Selection.ScrollBarThickness = 0
Selection.AutomaticCanvasSize = Enum.AutomaticSize.Y
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Selection
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Template = Instance.new("TextButton")
Template.Name = "Template"
Template.Parent = Selection
Template.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Template.BackgroundTransparency = 1.000
Template.BorderColor3 = Color3.fromRGB(0, 0, 0)
Template.BorderSizePixel = 0
Template.Size = UDim2.new(1, 0, 0.1, 0)
Template.AutoButtonColor = false
Template.FontFace = Font.new("rbxassetid://12187607287")
Template.Text = "Template"
Template.TextColor3 = Color3.fromRGB(255, 255, 255)
Template.TextSize = 30
Template.TextWrapped = true
Template.TextTransparency = 1
Template.TextStrokeTransparency = 1
Template.RichText = true

local UICorner = Instance.new("UICorner")
UICorner.Parent = Template
UICorner.CornerRadius = UDim.new(0.2,0)

local RealTemplate = Template:Clone()
Template:Destroy()

--[[

________   __  .__                         
\_____  \_/  |_|  |__   ___________  ______
 /   |   \   __\  |  \_/ __ \_  __ \/  ___/
/    |    \  | |   Y  \  ___/|  | \/\___ \ 
\_______  /__| |___|  /\___  >__|  /____  >
        \/          \/     \/           \/ 

--]]

local NPCs = {}

for i, v in pairs(workspace:GetDescendants()) do
    if v.Name == "NPC" then
        if v.Value == "Dialog" then
            if v.Parent:FindFirstChild("HumanoidRootPart") then
                if not v.Parent:FindFirstChild("WorldBoss") then
                    table.insert(NPCs,tostring(v.Parent))
                end
            end
        end
    end
end

local ChakraPoints = {}
for i, v in pairs(workspace.ChakraPoints:GetDescendants()) do
    if v.Name == "PointName" then
        table.insert(ChakraPoints, v.Value)
    end
end

local SafeSpots = {CFrame.new(3146.66, 403.62, -1155.48), CFrame.new(-3700.56, -406.67, -3533.17), CFrame.new(-2217.98, 219.35, -1377.97),CFrame.new(-1952.43, 51.5, 841.98)}
local RunService = game:GetService("RunService")
local TS = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local plr = game.Players.LocalPlayer
local user = plr.Name
local settingsfolder = RS.Settings:FindFirstChild(user) or RS.Settings:WaitForChild(user)

local lagtoggle = true
local InDanger = false
local busy = false
local falldmgdisabled
local teleporting = false
local firstTeleport = true
local choosingWaypoint = false
local ChakraSenseAlerter = false

local selectedhaircolors = {}
local selectednames = {}
local selectedMissionTypes = {}
local teleportedfruitIDs = {}

--[[ STEALTH VARIABLES FOR FARMS]]--

local treehopping = Instance.new("BoolValue")
treehopping.Name = "treehopping"
treehopping.Value = false

local bossfarmactive = Instance.new("BoolValue")
bossfarmactive.Name = "bossfarmactive"
bossfarmactive.Value = false

local voidbossfarmactive = Instance.new("BoolValue")
voidbossfarmactive.Name = "voidbossfarmactive"
voidbossfarmactive.Value = false

local Ryofarming = Instance.new("BoolValue")
Ryofarming.Name = "Ryofarming"
Ryofarming.Value = false

local Activationfarm = Instance.new("BoolValue")
Activationfarm.Name = "Activationfarm"
Activationfarm.Value = false

local loopwiping = Instance.new("BoolValue")
loopwiping.Name = "loopwiping"
loopwiping.Value = false

local christmasfarmactive = Instance.new("BoolValue")
christmasfarmactive.Name = "christmasfarmactive"
christmasfarmactive.Value = false

local Devilactive = Instance.new("BoolValue")
Devilactive.Name = "Devilactive"
Devilactive.Value = false

local Gripsactive = Instance.new("BoolValue")
Gripsactive.Name = "Gripsactive"
Gripsactive.Value = false

local GiveKnock = Instance.new("BoolValue")
GiveKnock.Name = "GiveKnock"
GiveKnock.Value = false

local missionfarmactive = Instance.new("BoolValue")
missionfarmactive.Name = "missionfarmactive"
missionfarmactive.Value = false

local missionautoequip = false
local missionautom1 = false

local stealthmodeactive = Instance.new("BoolValue")
stealthmodeactive.Name = "stealthmodeactive"
stealthmodeactive.Value = false

local spawningarticnpc = Instance.new("BoolValue")
spawningarticnpc.Name = "spawningarticnpc"
spawningarticnpc.Value = false

local farminggrips = Instance.new("BoolValue")
farminggrips.Name = "farminggrips"
farminggrips.Value = false

local givegrip = Instance.new("BoolValue")
givegrip.Name = "givegrip"
givegrip.Value = false

-- Candy farming removed

local stealthfeatures = {}

--[[ STEALTH VARIABLES FOR FARMS]]--

local features = {}

--[[

   _____         .__         ___________            __                         .____    .__          __   
  /     \ _____  |__| ____   \_   _____/___ _____ _/  |_ __ _________   ____   |    |   |__| _______/  |_ 
 /  \ /  \\__  \ |  |/    \   |    __)/ __ \\__  \\   __\  |  \_  __ \_/ __ \  |    |   |  |/  ___/\   __\
/    Y    \/ __ \|  |   |  \  |     \\  ___/ / __ \|  | |  |  /|  | \/\  ___/  |    |___|  |\___ \  |  |  
\____|__  (____  /__|___|  /  \___  / \___  >____  /__| |____/ |__|    \___  > |_______ \__/____  > |__|  
        \/     \/        \/       \/      \/     \/                        \/          \/       \/        
--]]

local function Teleport(place, bypassStealth, noteleport)
    local safeDistance = stealthneardistance or 120
    local targetCFrame

    if typeof(place) == "CFrame" then
        targetCFrame = place
    elseif typeof(place) == "Vector3" then
        targetCFrame = CFrame.new(place)
    else
        return false
    end

    local function checkSafety(position)
        for _, otherPlr in ipairs(game.Players:GetPlayers()) do
            if otherPlr ~= plr and otherPlr.Character and otherPlr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (otherPlr.Character.HumanoidRootPart.Position - position).Magnitude
                if dist <= safeDistance then
                    return false
                end
            end
        end
        return true
    end

    if stealthmodeactive.Value == true and not bypassStealth then
        if not checkSafety(targetCFrame.Position) then
            if not noteleport then
                Notify("Danger!","Player is nearby.",2,"info")
            end

            return false
        end
    end
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        if not noteleport then
            plr.Character.HumanoidRootPart.CFrame = targetCFrame
        end
        return true
    end

    return false
end

features.LoadESP = function()
    local plrs = game:GetService("Players")
    local plr = plrs.LocalPlayer

    --//Esp Configuration//
    ESP_Enabled = false
    ESP_ShowBox = true
    ESP_ShowName = true
    ESP_ShowStuds = true
    ESP_ShowHealth = true
    ESP_ShowHealthBar = true
    ESP_ShowChakra = true
    ESP_ShowChakraBar = false
    ESP_ShowBloodline = false
    ESP_ShowWeapon = false
    ESP_ShowKnocked = true
    ESP_ShowChakraSense = false
    ESP_ShowTracer = false
    ESP_ShowFreshie = true
    ESP_BoxColor = Color3.fromRGB(255, 0, 0)
    ESP_TextColor = Color3.fromRGB(255, 255, 255)
    ESP_HealthBarColor = Color3.fromRGB(80, 255, 80)
    ESP_MaxDistance = 1000
    ESP_BoxThickness = 2
    ESP_TextSize = 14
    
    --//Mob ESP Configuration//
    MobESP_Enabled = false
    MobESP_ShowBox = true
    MobESP_ShowName = true
    MobESP_ShowStuds = true
    MobESP_ShowHealth = true
    MobESP_ShowHealthBar = true
    MobESP_BoxColor = Color3.fromRGB(255, 165, 0)
    MobESP_TextColor = Color3.fromRGB(255, 255, 255)
    MobESP_MaxDistance = 1000

    local Refresh = 0.1

    local function addESPController(chr)
        local chrHead = chr:FindFirstChild("Head")
        local hasESP = chr:FindFirstChild("ESP")

        if hasESP then
            return
        end
        
        if chr.Parent == nil then
            return
        end
        
        if chr:GetChildren()[1] == nil then
            return
        end

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.OutlineColor = ESP_BoxColor
        highlight.FillColor = ESP_BoxColor
        highlight.FillTransparency = 0.9
        highlight.Enabled = false

        -- Box ESP using SelectionBox
        local box = Instance.new("SelectionBox")
        box.Name = "ESPBox"
        box.Adornee = chr:FindFirstChild("HumanoidRootPart")
        box.Color3 = ESP_BoxColor
        box.Transparency = 0.5
        box.LineThickness = ESP_BoxThickness / 10
        box.Visible = false
        if chr:FindFirstChild("HumanoidRootPart") then
            box.Parent = chr:FindFirstChild("HumanoidRootPart")
        end

        -- Tracer line (using Drawing API if available)
        local tracer = nil
        local hasDrawing = pcall(function() return Drawing ~= nil end)
        if hasDrawing and Drawing then
            tracer = Drawing.new("Line")
            tracer.Visible = false
            tracer.Color = ESP_BoxColor
            tracer.Thickness = 1
            tracer.Transparency = 1
        end

        local sign = Instance.new("BillboardGui")
        sign.Name = "ESP"
        sign.AlwaysOnTop = true
        sign.Enabled = false
        sign.Adornee = chrHead
        sign.Size = UDim2.new(0,200,0,100)
        sign.SizeOffset = Vector2.new(0,0.5)
        sign.StudsOffset = Vector3.new(0,3,0)
        sign.LightInfluence = 0

        --//Show Name//

        local nameDisplay = Instance.new("TextLabel",sign)
        nameDisplay.Name =  "NameDisplay"
        nameDisplay.TextColor3 = ESP_TextColor
        nameDisplay.BackgroundTransparency = 1
        nameDisplay.TextSize = ESP_TextSize
        nameDisplay.Size = UDim2.new(1,0,0,20)
        nameDisplay.TextWrapped = true
        nameDisplay.Position = UDim2.new(0, 0, 0, 0)
        nameDisplay.Text = chr.Name
        nameDisplay.FontFace = Font.new("rbxasset://fonts/families/Nunito.json",Enum.FontWeight.Bold)
        nameDisplay.Visible = ESP_ShowName

        local nameDisplayOutline = Instance.new("UIStroke",nameDisplay)
        nameDisplayOutline.Thickness = 2
        nameDisplayOutline.Color = Color3.new(0,0,0)

        --//Show HealthBar//

        local Bar = Instance.new("Frame")
        Bar.Name = "Bar"
        Bar.Parent = sign
        Bar.AnchorPoint = Vector2.new(0.5, 0)
        Bar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Bar.BorderSizePixel = 0
        Bar.Position = UDim2.new(0.5, 0, 0.999, 0)
        Bar.Size = UDim2.new(0.5, 0, 0.150000006, 0)

        local BarOutline = Instance.new("UIStroke",Bar)
        BarOutline.Name = "BarOutline"
        BarOutline.Thickness = 2

        local Shadow = Instance.new("Frame")
        Shadow.Name = "Shadow"
        Shadow.Parent = Bar
        Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Shadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Shadow.BorderSizePixel = 0
        Shadow.Size = UDim2.new(1, 0, 1, 0)
        Shadow.ZIndex = 2

        local ShadowCorner = Instance.new("UICorner")
        ShadowCorner.CornerRadius = UDim.new(1, 0)
        ShadowCorner.Name = "ShadowCorner"
        ShadowCorner.Parent = Shadow

        local ShadowE = Instance.new("UIGradient")
        ShadowE.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.52), NumberSequenceKeypoint.new(0.15, 0.74), NumberSequenceKeypoint.new(0.51, 1.00), NumberSequenceKeypoint.new(0.84, 0.76), NumberSequenceKeypoint.new(1.00, 0.48)}
        ShadowE.Name = "ShadowE"
        ShadowE.Parent = Shadow

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Name = "BarCorner"
        BarCorner.Parent = Bar

        local Fill = Instance.new("Frame")
        Fill.Name = "Fill"
        Fill.Parent = Bar
        Fill.BackgroundColor3 = ESP_HealthBarColor
        Fill.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Fill.BorderSizePixel = 0
        Fill.Size = UDim2.new(1, 0, 1, 0)
        Fill.Visible = ESP_ShowHealthBar

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Name = "FillCorner"
        FillCorner.Parent = Fill

        local espHumanoid = chr:FindFirstChildOfClass("Humanoid")
        local HealthBarController
        HealthBarController = espHumanoid.HealthChanged:Connect(function()
            local percentage = espHumanoid.Health/espHumanoid.MaxHealth
            Fill.Size = UDim2.new(percentage,0,1,0)
        end)
        

        --//Show Info

        local Info = Instance.new("TextLabel")
        Info.Name = "Info"
        Info.Parent = sign
        Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Info.BackgroundTransparency = 1.000
        Info.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Info.BorderSizePixel = 0
        Info.Position = UDim2.new(0.5, 0, -0.95, 0)
        Info.Size = UDim2.new(0.8, 0, 1, 0)
        Info.FontFace = Font.new("rbxasset://fonts/families/Jura.json",Enum.FontWeight.Bold)
        Info.Text = ""
        Info.TextColor3 = Color3.fromRGB(255, 255, 255)
        Info.TextScaled = true
        Info.TextSize = 30.000
        Info.TextWrapped = true
        Info.AnchorPoint = Vector2.new(0.5,0)

        local InfoOutline = Instance.new("UIStroke")
        InfoOutline.Name = "Outline"
        InfoOutline.Thickness = 3
        InfoOutline.Parent = Info

        highlight.Parent = chr
        sign.Parent = chr

        local function AutoRefresh()
            while wait(Refresh) do
                if highlight.Parent ~= chr then
                    warn("ESP Loop Broken.")
                    break
                end
                if sign.Parent ~= chr then
                    warn("ESP Loop broken.")
                    break
                end

                local autoassign = pcall(function()
                    local plrChr = plr.Character
                    local plrRoot = plrChr:FindFirstChild("HumanoidRootPart")
                    local plrHumanoid = plr:FindFirstChildOfClass("Humanoid")

                    local espHumanoid = chr:FindFirstChildOfClass("Humanoid")
                    local espRoot = chr:FindFirstChild("HumanoidRootPart")

                    local distance = (plrRoot.Position-espRoot.Position).Magnitude
                    local health = espHumanoid.Health
                    local maxHealth = espHumanoid.MaxHealth

                    -- Distance check
                    if distance > ESP_MaxDistance then
                        if sign then sign.Enabled = false end
                        if highlight then highlight.Enabled = false end
                        if box then box.Visible = false end
                        if tracer then tracer.Visible = false end
                        return
                    end

                    if ESP_Enabled then
                        highlight.OutlineColor = ESP_BoxColor
                        highlight.FillColor = ESP_BoxColor
                        espHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        
                        sign.Enabled = true
                        highlight.Enabled = true
                    else
                        espHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                        sign.Enabled = false
                        highlight.Enabled = false
                    end		

                    if ESP_ShowHealthBar then
                        Bar.Visible = true
                    else
                        Bar.Visible = false
                    end

                    -- Check if freshie (less than 2 traits = freshie)
                    local isFreshie = false
                    local Traits = chr:FindFirstChild("Traits")
                    if Traits then
                        local traitCount = #Traits:GetChildren()
                        isFreshie = traitCount < 2
                    end

                    -- Info text
                    local infoText = ""
                    if ESP_ShowBloodline then
                        local bloodline = ""
                        local settings = RS.Settings:FindFirstChild(chr.Name)
                        if settings and settings:FindFirstChild("Bloodline") then
                            bloodline = settings.Bloodline.Value
                        end
                        if bloodline ~= "" then
                            infoText = infoText .. bloodline .. "\n"
                        end
                    end

                    if ESP_ShowFreshie and isFreshie then
                        infoText = infoText .. "[Freshie]\n"
                    end
                    
                    -- Show Chakra Link percentage if available
                    if Traits then
                        local CLink = #Traits:GetChildren() * 25
                        if CLink > 0 then
                            infoText = infoText .. CLink .. "% Chakra Link\n"
                        end
                    end

                    if ESP_ShowWeapon then
                        local settings = RS.Settings:FindFirstChild(chr.Name)
                        if settings and settings:FindFirstChild("CurrentWeapon") then
                            infoText = infoText .. "Weapon: " .. settings.CurrentWeapon.Value .. "\n"
                        end
                    end

                    if ESP_ShowKnocked then
                        local settings = RS.Settings:FindFirstChild(chr.Name)
                        if settings and settings:FindFirstChild("Knocked") and settings.Knocked.Value then
                            infoText = infoText .. "KNOCKED\n"
                        end
                    end

                    if ESP_ShowChakraSense then
                        local cooldowns = RS.Cooldowns:FindFirstChild(chr.Name)
                        if cooldowns and cooldowns:FindFirstChild("Chakra Sense") then
                            infoText = infoText .. "Chakra Sense\n"
                        end
                    end

                    if ESP_ShowStuds and not ESP_ShowHealth then
                        infoText = infoText .. math.floor(distance) .. " studs"
                    elseif ESP_ShowHealth and not ESP_ShowStuds then
                        infoText = infoText .. math.floor(health) .. " HP"
                    elseif ESP_ShowStuds and ESP_ShowHealth then
                        infoText = infoText .. math.floor(distance) .. " studs | " .. math.floor(health) .. " HP"
                    end

                    Info.Text = infoText
                    Info.TextColor3 = ESP_TextColor
                    
                    -- Name display
                    if nameDisplay then
                        nameDisplay.Visible = ESP_ShowName
                        nameDisplay.TextColor3 = ESP_TextColor
                    end

                    -- Health bar with color coding
                    if Bar then
                        Bar.Visible = ESP_ShowHealthBar
                    end
                    if Fill then
                        Fill.Visible = ESP_ShowHealthBar
                        local percentage = health / maxHealth
                        Fill.Size = UDim2.new(percentage, 0, 1, 0)
                        -- Color based on health
                        if percentage > 0.6 then
                            Fill.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
                        elseif percentage > 0.3 then
                            Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                        else
                            Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                    
                    -- Box ESP
                    if box and ESP_ShowBox and ESP_Enabled then
                        box.Visible = true
                        box.Color3 = ESP_BoxColor
                        box.LineThickness = ESP_BoxThickness / 10
                    elseif box then
                        box.Visible = false
                    end
                    
                    -- Tracer
                    if tracer and ESP_ShowTracer and ESP_Enabled and hasDrawing then
                        local camera = workspace.CurrentCamera
                        local rootPos = espRoot.Position
                        local screenPoint, onScreen = camera:WorldToViewportPoint(rootPos)
                        if onScreen then
                            tracer.Visible = true
                            tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            tracer.To = Vector2.new(screenPoint.X, screenPoint.Y)
                            tracer.Color = ESP_BoxColor
                        else
                            tracer.Visible = false
                        end
                    elseif tracer then
                        tracer.Visible = false
                    end
                    
                    -- Distance check
                    if distance > ESP_MaxDistance then
                        sign.Enabled = false
                        highlight.Enabled = false
                        if box then box.Visible = false end
                        if tracer then tracer.Visible = false end
                    end
                end)

            end
        end

        task.spawn(AutoRefresh)
    end

    for _,xplayer in pairs(plrs:GetPlayers()) do
        if xplayer == plr then
            continue
        end

        local targetchr = xplayer.Character
        addESPController(targetchr)
        xplayer.CharacterAdded:Connect(function(xchr)
            local targetChrHumanoid
            local targetChrRoot
            targetChrHumanoid = xchr:WaitForChild("Humanoid")
            targetChrRoot = xchr:WaitForChild("HumanoidRootPart")

            addESPController(xchr)
        end)
    end

    plrs.PlayerAdded:Connect(function(xplayer)
        xplayer.CharacterAdded:Connect(function(xchr)
            local targetChrHumanoid
            local targetChrRoot
            targetChrHumanoid = xchr:WaitForChild("Humanoid")
            targetChrRoot = xchr:WaitForChild("HumanoidRootPart")

            addESPController(xchr)
        end)
    end)
    
    -- Mob ESP System
    local function addMobESP(mob)
        if not mob or not mob:FindFirstChild("Humanoid") or not mob:FindFirstChild("Head") then return end
        if mob:FindFirstChild("MobESP") then return end
        
        local mobHead = mob:FindFirstChild("Head")
        local mobHumanoid = mob:FindFirstChild("Humanoid")
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "MobESP"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.OutlineColor = Color3.fromRGB(255, 165, 0)
        highlight.FillColor = Color3.fromRGB(255, 165, 0)
        highlight.FillTransparency = 0.9
        highlight.Enabled = false
        
        local sign = Instance.new("BillboardGui")
        sign.Name = "MobESP"
        sign.AlwaysOnTop = true
        sign.Enabled = false
        sign.Adornee = mobHead
        sign.Size = UDim2.new(0, 200, 0, 30)
        sign.SizeOffset = Vector2.new(0, 0.5)
        sign.StudsOffset = Vector3.new(0, 3, 0)
        sign.LightInfluence = 0
        
        local nameDisplay = Instance.new("TextLabel", sign)
        nameDisplay.Name = "NameDisplay"
        nameDisplay.TextColor3 = Color3.fromRGB(255, 165, 0)
        nameDisplay.BackgroundTransparency = 1
        nameDisplay.TextScaled = true
        nameDisplay.Size = UDim2.new(1, 0, 1, 0)
        nameDisplay.TextWrapped = true
        nameDisplay.Position = UDim2.new(0, 0, 0, 0)
        nameDisplay.Text = mob.Name
        nameDisplay.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold)
        
        local nameDisplayOutline = Instance.new("UIStroke", nameDisplay)
        nameDisplayOutline.Thickness = 3
        
        local Info = Instance.new("TextLabel")
        Info.Name = "Info"
        Info.Parent = sign
        Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Info.BackgroundTransparency = 1.000
        Info.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Info.BorderSizePixel = 0
        Info.Position = UDim2.new(0.5, 0, -0.95, 0)
        Info.Size = UDim2.new(0.8, 0, 1, 0)
        Info.FontFace = Font.new("rbxasset://fonts/families/Jura.json", Enum.FontWeight.Bold)
        Info.Text = ""
        Info.TextColor3 = Color3.fromRGB(255, 165, 0)
        Info.TextScaled = true
        Info.TextSize = 30.000
        Info.TextWrapped = true
        Info.AnchorPoint = Vector2.new(0.5, 0)
        
        local InfoOutline = Instance.new("UIStroke")
        InfoOutline.Name = "Outline"
        InfoOutline.Thickness = 3
        InfoOutline.Parent = Info
        
        highlight.Parent = mob
        sign.Parent = mob
        
        local function AutoRefresh()
            while wait(Refresh) do
                if highlight.Parent ~= mob or sign.Parent ~= mob then
                    break
                end
                
                local autoassign = pcall(function()
                    local plrChr = plr.Character
                    if not plrChr then return end
                    local plrRoot = plrChr:FindFirstChild("HumanoidRootPart")
                    if not plrRoot then return end
                    
                    local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                    if not mobRoot then return end
                    
                    local distance = (plrRoot.Position - mobRoot.Position).Magnitude
                    local health = mobHumanoid.Health
                    
                    if MobESP_Enabled then
                        sign.Enabled = true
                        highlight.Enabled = true
                    else
                        sign.Enabled = false
                        highlight.Enabled = false
                    end
                    
                    if MobESP_ShowStuds and not MobESP_ShowHealth then
                        Info.Text = math.floor(distance) .. " studs"
                    elseif MobESP_ShowHealth and not MobESP_ShowStuds then
                        Info.Text = math.floor(health) .. " HP"
                    elseif MobESP_ShowStuds and MobESP_ShowHealth then
                        Info.Text = math.floor(distance) .. " studs | " .. math.floor(health) .. " HP"
                    else
                        Info.Text = ""
                    end
                end)
            end
        end
        
        task.spawn(AutoRefresh)
    end
    
    -- Helper function to check if model is a valid combat mob
    local function isValidMob(model)
        -- Must have Humanoid and Head
        if not model:FindFirstChild("Humanoid") or not model:FindFirstChild("Head") then
            return false
        end

        -- Exclude players
        if game.Players:GetPlayerFromCharacter(model) then
            return false
        end

        -- Only include NPCs with "Combat" value (actual hostile mobs)
        local npcValue = model:FindFirstChild("NPC")
        if not npcValue or npcValue.Value ~= "Combat" then
            return false
        end

        return true
    end

    -- Add ESP to existing mobs
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and isValidMob(v) then
            addMobESP(v)
        end
    end

    -- Add ESP to new mobs
    workspace.ChildAdded:Connect(function(child)
        if child:IsA("Model") then
            task.wait(0.1)
            if isValidMob(child) then
                addMobESP(child)
            end
        end
    end)
end

features.StartTeleport = function()
    if busy then
        return
    end
    busy = true

   local MapFrame = Map:FindFirstChild("Map")
   local BG = MapFrame:FindFirstChild("BG")
   local Shadow = MapFrame:FindFirstChild("Shadow")

   local Locations = {}
    for _,location in pairs(MapFrame:GetChildren()) do
        if location:isA("ImageButton") then
            location.BackgroundTransparency = 1

            local Marker = location:FindFirstChild("Marker")
            local LocName = location:FindFirstChild("LocationName")

            Marker.ImageTransparency = 1
            LocName.TextTransparency = 1

            table.insert(Locations,location)
        end
    end

    BG.ImageTransparency = 1
    Shadow.ImageTransparency = 1

    if not Map.Enabled then
        task.wait(0.1)
        Map.Enabled = true
    end

    local blurTransition = Instance.new("BlurEffect",Lighting)
    blurTransition.Name = "Transition"
    blurTransition.Size = 24
    Tween(blurTransition,TweenInfo.new(0.4),{Size = 24})

    Notify("Select a waypoint","to teleport to...","2","map-pinned")

    local BaseSize = UDim2.new(0.61145997, 0, 0.711886287, 0)
    local AnimSize = UDim2.new(0.31145997, 0, 0.351886287, 0)

    MapFrame.Size = AnimSize
    Tween(MapFrame,TweenInfo.new(0.45),{Size = BaseSize})
    Tween(BG,TweenInfo.new(0.6),{ImageTransparency = 0})
    Tween(Shadow,TweenInfo.new(0.6),{ImageTransparency = 0.330})

    if firstTeleport then
        task.wait(0.6)
    else
        task.wait(0.15) 
    end

    for _,location in pairs(Locations) do
        location.Visible = true
        local Marker = location:FindFirstChild("Marker")
        local LocName = location:FindFirstChild("LocationName")

        Tween(Marker,TweenInfo.new(0.45),{ImageTransparency = 0})
        Tween(LocName,TweenInfo.new(0.45),{TextTransparency = 0})

        if firstTeleport then
            task.wait(0.1)
        end
    end

    busy = false
    firstTeleport = false
end

features.EndTeleport = function(Location)
    if teleporting or busy then
        return
    end

    teleporting = true
    Notify("Teleported","to your destination.","3","map-pinned")

    local MapFrame = Map:FindFirstChild("Map")
    local BG = MapFrame:FindFirstChild("BG")
    local Shadow = MapFrame:FindFirstChild("Shadow")

    local Locations = {}
    for _,location in pairs(MapFrame:GetChildren()) do
        if location:isA("ImageButton") then
            table.insert(Locations,location)
        end
    end
    
    local BaseSize = UDim2.new(0.61145997, 0, 0.711886287, 0)
    local AnimSize = UDim2.new(0.31145997, 0, 0.351886287, 0)

    local foundLocation = MapFrame:FindFirstChild(Location)
    local LocationMarker = foundLocation:FindFirstChild("Marker")

    Tween(BG,TweenInfo.new(0.4),{ImageTransparency = 1})
    Tween(Shadow,TweenInfo.new(0.4),{ImageTransparency = 1})
    Tween(MapFrame,TweenInfo.new(0.4),{Size = BaseSize})

    for _,location in pairs(Locations) do
        local Marker = location:FindFirstChild("Marker")
        local LocName = location:FindFirstChild("LocationName")

        Tween(Marker,TweenInfo.new(0.3),{ImageTransparency = 1})
        Tween(LocName,TweenInfo.new(0.3),{TextTransparency = 1})

        task.spawn(function()
            task.wait(0.3)
            location.Visible = false
        end)
    end
    
    local transitionBlur = Lighting:FindFirstChild("Transition")
    if transitionBlur then
        Tween(transitionBlur,TweenInfo.new(0.4),{Size = 0})
    end

    for i, v in pairs(workspace.ChakraPoints:GetDescendants()) do
        if v.Name == "PointName" then
            if v.Value == Location then
                Teleport(v.Parent.Main.CFrame * CFrame.new(0,0,4))
            end
        end
    end

    task.wait(0.4)
    if transitionBlur.Parent ~= nil then
        transitionBlur:Destroy()
    end
    
    --//Fallback Fusion Blur Removal//
    for _,v in pairs(game.Lighting:GetChildren()) do
        if v.Name == "Transition" then
            v:Destroy()
        end
    end
    teleporting = false
    busy = false
end

features.RenderMap = function()
    local Preloader = game:GetService("ContentProvider")
    Preloader:PreloadAsync(Map:GetDescendants())
    local MapFrame = Map:FindFirstChild("Map")
    for _,location in pairs(MapFrame:GetChildren()) do
        if location:IsA("ImageButton") then
            location.MouseButton1Click:Connect(function()
                features.EndTeleport(location.Name)
            end)
            location.Visible = false
        end
    end
end

features.CSA = function()
    local plr = game:GetService("Players").LocalPlayer
    local rs = game:GetService("ReplicatedStorage")

    local function BindCSA(Object)
        if ChakraSenseAlerter == false then
            return
        end

        if Object.Parent:GetAttribute("observed") == true then
            return
        end

        if Object.Name == "BeingObservedBy" then
            --Being Watched!
            local AlertPing = Instance.new("Sound",plr.PlayerGui)
            AlertPing.SoundId = "rbxassetid://644569388"
            AlertPing.PlayOnRemove = true
            AlertPing:Destroy()

            local totalsensers = {}
            for _,player in pairs(game.Players:GetPlayers()) do
                local plrCharacter = player.Character
                local inChakraSense = plrCharacter:FindFirstChild("ChakraSense",true)

                if inChakraSense then
                    table.insert(totalsensers,plrCharacter)
                end
            end

            if #totalsensers > 1 then
                Notify("You're being observed!","Someone is observing you.",5,"shield-alert")
                wait(0.8)
                Object.Parent:SetAttribute("observed", false)
            else
                local senserHumanoid = totalsensers[1]:FindFirstChildOfClass("Humanoid")
                local senserName = senserHumanoid.DisplayName

                Notify("You're being observed!",senserName.." is observing you.",5,"shield-alert")
                Object.Parent:SetAttribute("observed", true)
                wait(0.8)
                Object.Parent:SetAttribute("observed", false)
            end
        end
    end

    local Settings = RS:WaitForChild("Settings")
    Settings.ChildAdded:Connect(function(Object)
        if Object.Name == plr.Name then
            Object.ChildAdded:Connect(BindCSA)
        end
    end)

    local plrSettings = Settings:FindFirstChild(plr.Name)
    plrSettings.ChildAdded:Connect(BindCSA)
end

local flightSpeed
features.toggleFlight = function()

    local plr = game.Players.LocalPlayer
    local plrCharacter = plr.Character or plr.CharacterAdded:Wait()
    
    local plrRoot = plrCharacter:FindFirstChild("HumanoidRootPart")
    local plrHumanoid = plrCharacter:FindFirstChildOfClass("Humanoid")

    local foundVelocity = plrRoot:FindFirstChild("FlightV")
    local foundGyro = plrRoot:FindFirstChild("FlightG")

    if foundVelocity and foundGyro then
        foundVelocity:Destroy()
        foundGyro:Destroy()
        return
    end

    local V = Instance.new("BodyVelocity")
    local G = Instance.new("BodyGyro")

    V.Name = "FlightV"
    V.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    V.Velocity = Vector3.new(0, 0, 0)
    V.P = 10000
    V.Parent = plrRoot

    G.Name = "FlightG"
    G.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    G.CFrame = plrRoot.CFrame
    G.P = 10000
    G.Parent = plrRoot
    
    local userInputService = game:GetService("UserInputService")

    local FlightControl
    FlightControl = While.Heartbeat:Connect(function()
        local speed = flightSpeed or 100

        if V.Parent == nil or G.Parent == nil then
            FlightControl:Disconnect()
            return
        end

        local moveDirection = Vector3.new(0, 0, 0)
        local fast = false

        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            fast = true
        end
        if fast then
            V.Velocity = moveDirection * speed * 2.5
        else
            V.Velocity = moveDirection * speed
        end

        G.CFrame = CFrame.new(plrRoot.Position, plrRoot.Position + workspace.CurrentCamera.CFrame.LookVector)
    end)
end

features.SelectPlayer = function()

    if ActiveSelector then
       return
    end
 
    Notify("Select a Player...","","2","user-round")
 
    ActiveSelector = true
 
    for i,v in pairs(Selection:GetChildren()) do
       if v:IsA("TextButton") then
          v:Destroy()
       end
    end
 
    local lighting = game:GetService("Lighting")
 
    local blurtransition = Instance.new("BlurEffect")
    blurtransition.Name = "SelectionBlur"
    blurtransition.Size = 0
    blurtransition.Parent = lighting
 
    Tween(blurtransition,TweenInfo.new(0.4,Enum.EasingStyle.Back),{Size = 18})
    
    Selector.Enabled = true
 
    -- Refresh
    for i,v in pairs(game.Players:GetPlayers()) do
       local NewButton = RealTemplate:Clone()
       NewButton.Name = v.Name
       NewButton.Text = v.Name
 
       if v == game.Players.LocalPlayer then
          NewButton.Text = NewButton.Text.." ".."<font color='rgb(255, 215, 0)'>[You]</font>"
       end
 
       local vChr = v.Character
       if vChr ~= nil then
          local Root = vChr:FindFirstChild("HumanoidRootPart")
       end
 
       NewButton.MouseEnter:Connect(function()
         Tween(NewButton,TweenInfo.new(0.2,Enum.EasingStyle.Sine),{TextSize = 48})
         Tween(NewButton,TweenInfo.new(0.3,Enum.EasingStyle.Linear),{BackgroundTransparency = 0.9})
      end)

      NewButton.MouseLeave:Connect(function()
        task.wait(0.1)
         Tween(NewButton,TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{TextSize = 30})
         Tween(NewButton,TweenInfo.new(0.3,Enum.EasingStyle.Linear),{BackgroundTransparency = 1})
      end)
 
       NewButton.MouseButton1Click:Connect(function()
         local Targetted = game.Players:FindFirstChild(NewButton.Name)
         if Targetted then
          TargetPlayer = Targetted
          warn(TargetPlayer)
         end
         Tween(blurtransition,TweenInfo.new(0.8,Enum.EasingStyle.Back),{Size = 0})
         Selector.Enabled = false
         ActiveSelector = false
         Shadow.BackgroundTransparency = 1
       end)
       NewButton.Parent = Selection
    end

    --//Transition Effect//--

    Selection.Size = TransitionSize
    local FlyIn = TweenService:Create(Selection,TweenInfo.new(0.6,Enum.EasingStyle.Back),{Size = ActualSize})
    FlyIn:Play()

    for _,Element in pairs(Selection:GetChildren()) do
        if Element:IsA("TextButton") then
            local FadeIn = TweenService:Create(Element,TweenInfo.new(0.6),{TextTransparency = 0})
            FadeIn:Play()

            Shadow.Size = TransitionSize
            local ShadowFadeIn = TweenService:Create(Shadow,TweenInfo.new(0.6),{BackgroundTransparency = 0.9})
            local ShadowFlyIn = TweenService:Create(Shadow,TweenInfo.new(0.6,Enum.EasingStyle.Back),{Size = ActualSize})
            ShadowFadeIn:Play()
            ShadowFlyIn:Play()

            local TextFadeIn = TweenService:Create(Element,TweenInfo.new(0.5,Enum.EasingStyle.Back),{TextSize = 30})
            TextFadeIn:Play()

        end
    end
 end

walkspeed_enabled = false
walkspeed_modified = 100
features.Walkspeed = function()
    While.Heartbeat:Connect(function()
        if walkspeed_enabled then
            local Character = plr.Character
            local Humanoid = Character:WaitForChild("Humanoid")

            Humanoid.WalkSpeed = walkspeed_modified
        end
    end)
end

local newplayerguiconn
features.ClickToView = function()
    local RSLoaded = RS.Loaded:FindFirstChild(user)

    if not RSLoaded then 
        repeat
            wait()
        until RS.Loaded:FindFirstChild(user)
    end

    local clientguis = game:GetService("Players").LocalPlayer.PlayerGui.ClientGui

    local function ResetCamera()
        local cam = workspace.Camera
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            cam.CameraSubject = plr.Character.Humanoid

            -- Chakra Point Viewing
            if game:GetService("Lighting"):FindFirstChild("PointBlur") then
                game:GetService("Lighting"):FindFirstChild("PointBlur").Enabled = false
                plr.PlayerGui.ClientGui.Mainframe.Rest.TitleImage.Visible = true
                plr.PlayerGui.ClientGui.Mainframe.Rest.BackDrop.Visible = true
                plr.PlayerGui.ClientGui.Mainframe.Rest.MainMenuFrame.Visible = true
            end
        end
    end

    local function View(Button)
        local cam = workspace.Camera
        local eplr = game.Players:FindFirstChild(Button.PlayerName.Text)
        if eplr then
            if eplr.Character and eplr.Character.Humanoid then
                cam.CameraSubject = eplr.Character.Humanoid
                
                -- Chakra Point Viewing
                if game:GetService("Lighting"):FindFirstChild("PointBlur") then
                    if eplr.Name ~= plr.Name then
                        game:GetService("Lighting"):FindFirstChild("PointBlur").Enabled = false
                        plr.PlayerGui.ClientGui.Mainframe.Rest.TitleImage.Visible = false
                        plr.PlayerGui.ClientGui.Mainframe.Rest.BackDrop.Visible = false
                        plr.PlayerGui.ClientGui.Mainframe.Rest.MainMenuFrame.Visible = false
                    else
                        game:GetService("Lighting"):FindFirstChild("PointBlur").Enabled = false
                        plr.PlayerGui.ClientGui.Mainframe.Rest.TitleImage.Visible = true
                        plr.PlayerGui.ClientGui.Mainframe.Rest.BackDrop.Visible = true
                        plr.PlayerGui.ClientGui.Mainframe.Rest.MainMenuFrame.Visible = true
                    end
                end
            end
        end
    end

    local function assignbutton()

        newplayerguiconn = plr.PlayerGui.ClientGui.Mainframe.PlayerList.List.ChildAdded:Connect(function(guichi)
            if guichi.Name == "PlayerTemplate" then
                guichi.MouseButton1Click:Connect(function()
                    View(guichi)
                end)
                guichi.MouseButton2Click:Connect(function()
                    ResetCamera()
                end)
            end
        end)
        for _,plrbutton in pairs(plr.PlayerGui.ClientGui.Mainframe.PlayerList.List:GetChildren()) do
            if plrbutton.Name == "PlayerTemplate" then
                plrbutton.MouseButton1Click:Connect(function()
                    View(plrbutton)
                end)
                plrbutton.MouseButton2Click:Connect(function()
                    ResetCamera()
                end)
            end
        end
    end

    plr.PlayerGui.ChildRemoved:Connect(function(removed)
        if removed.Name == "ClientGui" then
            plr:WaitForChild("PlayerGui")
            plr.PlayerGui:WaitForChild("ClientGui")
            plr.PlayerGui.ClientGui:WaitForChild("Mainframe")
            if newplayerguiconn then
                newplayerguiconn:Disconnect()
            end
            wait()
            assignbutton()
        end
    end)
    assignbutton()
end


local cheatcheckversions = {
    [745] = 14,
	[750] = 14,
	[757] = 18,
    [784] = 18,
    [788] = 18
}

features.TeleportRandomServer = function()
    local players = game:GetService("Players")
    local LocalPlayer = players.LocalPlayer
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")

    features.HandleNotLoadedIn()

    local triedServers = {}

    local function waitForNoCombat()
        local data = remote:InvokeServer("GetData")
        while data["InDanger"] == true do
            task.wait(0.5)
            data = remote:InvokeServer("GetData")
        end
    end

    local function getServerList()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
        local clientGui = playerGui:WaitForChild("ClientGui", 5)

        local list
        local mainframe = clientGui:FindFirstChild("Mainframe")
        if mainframe then
            local rest = mainframe:FindFirstChild("Rest")
            if rest then
                local serverList = rest:FindFirstChild("ServerList")
                if serverList then
                    local backdrop = serverList:FindFirstChild("BackDrop")
                    if backdrop then
                        list = backdrop:FindFirstChild("List")
                    end
                end
            end
        end

        if not list or #list:GetChildren() == 0 then
            local menuScreen = clientGui:FindFirstChild("MenuScreen")
            if menuScreen then
                local serverList = menuScreen:FindFirstChild("ServerList")
                if serverList then
                    local backdrop = serverList:FindFirstChild("BackDrop")
                    if backdrop then
                        list = backdrop:FindFirstChild("List")
                    end
                end
            end
        end

        return list
    end

    local function forceClick(button)
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        if button.Activated then
            for _, c in ipairs(getconnections(button.Activated)) do c:Fire() end
        end
        if button.MouseButton1Click then
            for _, c in ipairs(getconnections(button.MouseButton1Click)) do c:Fire() end
        end
        if button.MouseButton1Down then
            for _, c in ipairs(getconnections(button.MouseButton1Down)) do c:Fire() end
        end
        if button.TouchTap then
            for _, c in ipairs(getconnections(button.TouchTap)) do c:Fire() end
        end
    end

    local function attemptServerHop()
        waitForNoCombat()

        local list = getServerList()
        if not list then return end

        local validServers = {}
        for _, frame in ipairs(list:GetChildren()) do
            if frame:IsA("Frame") and frame.Name == "ServerTemplate" then
                local playersLabel = frame:FindFirstChild("Players")
                local joinButton = frame:FindFirstChild("JoinButton")
                local regionLabel = frame:FindFirstChild("ServerRegion")
                local regionValue = "?"
                if regionLabel and regionLabel:IsA("TextLabel") then
                    regionValue = regionLabel.Text:match("Region%s*:%s*(.+)") or "?"
                end

                if playersLabel and joinButton and joinButton:IsA("TextButton") then
                    local playerCount = tonumber(playersLabel.Text:match("%d+")) or 0

                    local regionOk = true
                    if selectedregions and #selectedregions > 1 then
                        regionOk = false
                        for _, allowed in ipairs(selectedregions) do
                            if regionValue == allowed then
                                regionOk = true
                                break
                            end
                        end
                    end

                    if playerCount > 0 and regionOk and not triedServers[frame.Name] then
                        table.insert(validServers, {
                            frame = frame,
                            button = joinButton,
                            playerCount = playerCount,
                            region = regionValue
                        })
                    end
                end
            end
        end

        if #validServers == 0 then
            triedServers = {}
            return
        end

        local selectedServer = validServers[math.random(1, #validServers)]
        triedServers[selectedServer.frame.Name] = true

        task.wait(0.1)
        local success, err = pcall(function()
            forceClick(selectedServer.button)
        end)
        if not success then
            pcall(function()
                firesignal(selectedServer.button.MouseButton1Click)
            end)
        end
    end

    while true do
        attemptServerHop()
        task.wait(1)
    end
end


features.TeleportLeastActive = function()
    local players = game:GetService("Players")
    local LocalPlayer = players.LocalPlayer
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")

    features.HandleNotLoadedIn()

    local triedServers = {}

    local function waitForNoCombat()
        local data = remote:InvokeServer("GetData")
        while data["InDanger"] == true do
            task.wait(0.5)
            data = remote:InvokeServer("GetData")
        end
    end

    local function getServerList()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
        local clientGui = playerGui:WaitForChild("ClientGui", 5)

        local list
        local mainframe = clientGui:FindFirstChild("Mainframe")
        if mainframe then
            local rest = mainframe:FindFirstChild("Rest")
            if rest then
                local serverList = rest:FindFirstChild("ServerList")
                if serverList then
                    local backdrop = serverList:FindFirstChild("BackDrop")
                    if backdrop then
                        list = backdrop:FindFirstChild("List")
                    end
                end
            end
        end

        if not list or #list:GetChildren() == 0 then
            local menuScreen = clientGui:FindFirstChild("MenuScreen")
            if menuScreen then
                local serverList = menuScreen:FindFirstChild("ServerList")
                if serverList then
                    local backdrop = serverList:FindFirstChild("BackDrop")
                    if backdrop then
                        list = backdrop:FindFirstChild("List")
                    end
                end
            end
        end

        return list
    end

    local function forceClick(button)
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        if button.Activated then
            for _, c in ipairs(getconnections(button.Activated)) do c:Fire() end
        end
        if button.MouseButton1Click then
            for _, c in ipairs(getconnections(button.MouseButton1Click)) do c:Fire() end
        end
        if button.MouseButton1Down then
            for _, c in ipairs(getconnections(button.MouseButton1Down)) do c:Fire() end
        end
        if button.TouchTap then
            for _, c in ipairs(getconnections(button.TouchTap)) do c:Fire() end
        end
    end

    local function attemptServerHop()
        waitForNoCombat()

        local list = getServerList()
        if not list then return end

        local validServers = {}
        for _, frame in ipairs(list:GetChildren()) do
            if frame:IsA("Frame") and frame.Name == "ServerTemplate" then
                local playersLabel = frame:FindFirstChild("Players")
                local joinButton = frame:FindFirstChild("JoinButton")
                local regionLabel = frame:FindFirstChild("ServerRegion")
                local regionValue = "?"
                if regionLabel and regionLabel:IsA("TextLabel") then
                    regionValue = regionLabel.Text:match("Region%s*:%s*(.+)") or "?"
                end

                if playersLabel and joinButton and joinButton:IsA("TextButton") then
                    local playerCount = tonumber(playersLabel.Text:match("%d+")) or 0

                    local regionOk = true
                    if selectedregions and #selectedregions > 1 then
                        regionOk = false
                        for _, allowed in ipairs(selectedregions) do
                            if regionValue == allowed then
                                regionOk = true
                                break
                            end
                        end
                    end

                    if playerCount > 8 and regionOk and not triedServers[frame.Name] then
                        table.insert(validServers, {
                            frame = frame,
                            button = joinButton,
                            playerCount = playerCount,
                            region = regionValue
                        })
                    end
                end
            end
        end

        if #validServers == 0 then
            triedServers = {}
            return
        end

        table.sort(validServers, function(a, b)
            return a.playerCount < b.playerCount
        end)

        local selectedServer = validServers[1]
        triedServers[selectedServer.frame.Name] = true

        task.wait(0.1)
        local success, err = pcall(function()
            forceClick(selectedServer.button)
        end)
        if not success then
            pcall(function()
                firesignal(selectedServer.button.MouseButton1Click)
            end)
        end
    end

    while true do
        attemptServerHop()
        task.wait(1)
    end
end



NoFog= false
features.NoFogPassive = function()
    local Lighting = game:GetService("Lighting")
    While.Heartbeat:Connect(function()
        if NoFog then
            Lighting.FogEnd = 50000
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            if workspace.Debris:FindFirstChild("InvertedSphere") then
                workspace.Debris.InvertedSphere.Transparency = 1
            end
            if RS:FindFirstChild("Raining") then
                RS:FindFirstChild("Raining").Value = ""
            end
        end
    end)
end

features.AntiAFK = function()
    local VirtualUser = game:GetService("VirtualUser")

    plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end

features.AutoSellGems = function()
    if sellinggems then
        local function determinegemsamount()
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")
            local playerdata,region,servername = remote:InvokeServer("GetData")
            local totalGemAmount = 0

            local function checkforgem(location)
                for _, itemData in pairs(location) do
                    if string.find(itemData.Item, "Gem") then
                        local quantity = itemData.Quantity or 1
                        totalGemAmount = totalGemAmount + quantity
                    end
                end
            end

            checkforgem(playerdata["Inventory"])
            checkforgem(playerdata["Loadout"])
            return totalGemAmount
        end     
        
        local function sellthegems(gemamount)
            local args = {
                [1] = "SellingBulk",
                [2] = gemamount * 10,
                [3] = "Gem",
                [5] = workspace:WaitForChild("TorchMesh")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
        end

        while sellinggems do
            local gemsamount = determinegemsamount()
            if gemsamount > 0 then
                sellthegems(gemsamount)
            end
            wait(5)
        end
    end
end


features.NoFallDamage = function()
    local antifalldmg
    antifalldmg = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if tostring(self) == "DataEvent" and method == "FireServer" then
            if args[1] == "TakeDamage" then
                if args[2] > 0.1 and NoFallDammage.Value == true and args[3] ~= "yes" and args[3] == nil then
                    return nil
                end
            end
        end

        return antifalldmg(self, unpack(args))
    end)
end

local noclipenabled = false

features.Noclip = function()
   if noclipenabled then
        local function nocliploop()
            for i, v in pairs(plr.Character:GetChildren()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
        noclipping = RunService.Stepped:Connect(nocliploop)
   else
        if noclipping then
            noclipping:Disconnect()
        end
        
        for i, v in pairs(plr.Character:GetChildren()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = true
            end
        end
    end
end

local infinitestamina = false
features.InfiniteStamina = function()
    local infjumps
    infjumps = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if tostring(self) == "DataEvent" and method == "FireServer" then
            if args[1] == "Jump" and infinitestamina == true then
                return nil
            end
        end

        return infjumps(self, unpack(args))
    end)

end

features.Reset = function()
    if plr.Character and plr.Character.Parent ~= nil and plr.Character.Humanoid then
        local char = plr.Character
        local hum = plr.Character.Humanoid
        local hrp = plr.Character.HumanoidRootPart
        hum:ChangeState(Enum.HumanoidStateType.Dead)
        if plr.Character:FindFirstChild("Head") then
            plr.Character.Head.Name = ""
        end
    end
end

features.infinitem1 = function()
    if infinitem1ing then
        local weapontoautoequip = nil
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")
        local playerdata = remote:InvokeServer("GetData")
        weapontoautoequip = playerdata["CurrentWeapon"]

        while infinitem1ing do
            task.wait()

            if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("CombatCount") then
                if RS.Settings[user].CombatCount.Value > 3 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("Item", "Selected", weapontoautoequip)
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("Item", "Unselected", weapontoautoequip)
                end
            end
        end
    end
end


features.gotosafespot = function(dontteleport,shortloop)
    if safespotcf == nil then
        Notify("Missing Safe Spot CFrame", "Check Settings Tab", 3, "info")
        return false
    end

    if dontteleport then
        return true
    end

    if not shortloop then
        Teleport(safespotcf)
    else
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local startTime = tick()
            while tick() - startTime < 0.5 do
                hrp.CFrame = safespotcf
                task.wait()
            end
        end
    end
    return true
end

features.HandleNotLoadedIn = function()
    if not RS.Loaded:FindFirstChild(user) then
        if workspace.CurrentCamera.CameraType == Enum.CameraType.Custom then
            task.spawn(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("LoadedIn")
            end)

            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("LoadedIn")

            wait()
            plr.PlayerGui.ClientGui.MenuScreen.Visible = false
            plr.SoundPlaylist:FindFirstChild("MenuTrack").Playing = false

            local loadingFunction = nil
            local memory = getgc(true)

            for i,v in pairs(memory) do
                if type(v) == "function" and debug.getinfo(v).name == "LoadIntoGame" then
                    loadingFunction = v
                end
            end

            if loadingFunction then
                loadingFunction()
            end

            if plr.Character and plr.Character.HumanoidRootPart then
                features.gotosafespot()
            end
            wait(2)
        else
            local loadingFunction = nil
            local memory = getgc(true)

            for i,v in pairs(memory) do
                if type(v) == "function" and debug.getinfo(v).name == "LoadIntoGame" then
                    loadingFunction = v
                end
            end

            if loadingFunction then
                loadingFunction()
            end
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("LoadedIn")
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("LoadedIn")
            wait()
            if plr.Character and plr.Character.HumanoidRootPart then
                Teleport(CFrame.new(-2974.29443, 345.182709, 646.613159, -0.99941802, -2.79689978e-08, 0.0341118388, -2.78877685e-08, 1, 2.85709167e-09, -0.0341118388, 1.90412597e-09, -0.99941802))
            end
        end
    end
end

features.AntiBan = function()

    local antiban
    antiban = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if tostring(self) == "DataEvent" and method == "FireServer" then
            if args[1] == "BanMe" then
                return nil
            end
        end
        return antiban(self, unpack(args))
    end)
end

features.LockCamera = function()
    if lockingcamera then
        if TargetPlayer ~= nil then
            lockingcameraconn = game:GetService("RunService").RenderStepped:Connect(function()
                local cam = workspace.CurrentCamera
                local myChar = game.Players.LocalPlayer.Character
                local targetChar = TargetPlayer.Character

                if cam and myChar and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                    -- preserve current camera distance
                    local camPos = cam.CFrame.Position
                    local targetPos = targetChar.HumanoidRootPart.Position

                    -- only rotate camera to face target (don't overwrite offset/zoom)
                    cam.CFrame = CFrame.lookAt(camPos, targetPos)
                end
            end)
        end
    else
        if lockingcameraconn then
            lockingcameraconn:Disconnect()
            lockingcameraconn = nil
        end
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end

features.FarmPlayer = function()
    if farmingplayer and TargetPlayer then
        if farmteleportconn then
            farmteleportconn:Disconnect()
        end

        farmteleportconn = RunService.RenderStepped:Connect(function()
            local myChar = plr.Character
            local targetChar = TargetPlayer.Character

            if myChar and targetChar then
                local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

                if myHRP and targetHRP then
                    local belowTarget = targetHRP.Position + Vector3.new(0, -9, 0)
                    local lookDirection = (targetHRP.Position - myHRP.Position).Unit
                    local cframeLook = CFrame.new(belowTarget, belowTarget + lookDirection)

                    myHRP.CFrame = cframeLook
                end
            end
        end)
    else
        if farmteleportconn then
            farmteleportconn:Disconnect()
            farmteleportconn = nil
        end
    end
end

features.AutoSealMatatabi = function()
    if not autosealingmatatabi then return end
    
    local RunService = game:GetService("RunService")
    local RS = game:GetService("ReplicatedStorage")
    
    local sealConnection
    sealConnection = RunService.Heartbeat:Connect(function()
        if not autosealingmatatabi then
            if sealConnection then
                sealConnection:Disconnect()
            end
            return
        end
        
        -- Find Matatabi in workspace
        local matatabi = workspace:FindFirstChild("Matatabi")
        if not matatabi then return end
        
        local matatabiHumanoid = matatabi:FindFirstChild("Humanoid")
        local matatabiHRP = matatabi:FindFirstChild("HumanoidRootPart")
        
        if not (matatabiHumanoid and matatabiHRP) then return end
        
        -- Check if health is 1 or less
        if matatabiHumanoid.Health <= 1 then
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = matatabiHRP.Position
                
                -- Teleport to Matatabi's position with Y = -147
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.X, -147, targetPos.Z)
                
                -- Start the Binding Seal skill at the player's position
                local skillPos = Vector3.new(targetPos.X, -147, targetPos.Z)
                RS.Events.DataEvent:FireServer("startSkill", "Binding Seal", skillPos, true)
                
                -- Spam ReleaseSkill
                RS.Events.DataEvent:FireServer("ReleaseSkill")
            end
        end
    end)
end

features.StealthMode = function()

    local function takemeasurement(reason)
        if stealthmodeactive.Value == false then return end

        if reason == "[Tact Hub]: Someone got near you." and stealthfeatures[givegrip] == true then return end
        if stealthmeasurement == "Kick" then
            for i, v in pairs(stealthfeatures) do
                if i.Value == true then
                    features.CheckNotiAndSend("Stealth Mode triggered",reason)
                    plr:Kick(reason)
                    return
                end
            end
        elseif stealthmeasurement == "Stop Farm + Reset" then
            for bool, func in pairs(stealthfeatures) do
                if bool.Value == true then
                    bool.Value = false
                    features.CheckNotiAndSend("Stealth Mode triggered",reason)
                    func()
                    features.Reset()
                end
            end
        elseif stealthmeasurement == "Stop Farm" then
            for bool, func in pairs(stealthfeatures) do
                if bool.Value == true then
                    bool.Value = false
                    func()
                    features.CheckNotiAndSend("Stealth Mode triggered",reason)
                end
            end
        elseif stealthmeasurement == "Stop Farm + Safe Spot" then
            for bool, func in pairs(stealthfeatures) do
                if bool.Value == true then
                    bool.Value = false
                    func()
                    features.CheckNotiAndSend("Stealth Mode triggered",reason)
                    spawn(function()
                        features.gotosafespot(false,true)
                    end)
                end
            end
        elseif stealthmeasurement == "Safe Spot + Serverhop" then
            for bool, func in pairs(stealthfeatures) do
                if bool.Value == true then
                    bool.Value = false
                    func()
                    features.CheckNotiAndSend("Stealth Mode triggered",reason)
                    spawn(function()
                        features.gotosafespot(false,true)
                    end)
                    features.TeleportRandomServer()
                end
            end
        end
    end

    -- Someone new with Chakra uses

    local startedchakraamount = amount.Value


    spawn(function() 
        local startTime = tick()

        while tick() - startTime < 9 do
            if stealthshopifsensethere == true then
                if startedchakraamount > 0 then
                    if shopdelay ~= nil then
                        wait(shopdelay)
                    end

                    features.TeleportRandomServer()
                    return
                end
                return
            else
                task.wait()
            end
        end
    end)

    -- monitor surrounding people

    local lastCheck = 0
    local checkInterval = 0.2

    local function checkPeopleNear()
        if not plr.Character then return end
        local playerhrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if not playerhrp then return end
        local stealthneardistance = stealthneardistance or 200

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= plr then
                local character = player.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = (playerhrp.Position - hrp.Position).Magnitude
                        if distance <= stealthneardistance then
                            -- exception for loopwipe and treehop
                            if not RS.Loaded:FindFirstChild(user) then
                                local wiperoomdistance = (playerhrp.Position - workspace:FindFirstChild("Arkoromo"):FindFirstChild("HumanoidRootPart").Position).Magnitude
                                if wiperoomdistance <= 250 then
                                    takemeasurement("[Tact Hub]: Someone was in Wipe Room.")
                                end
                            elseif treehopping.Value == true or Ryofarming.Value == true then
                                return
                            else
                                -- for every other feature                      
                                takemeasurement("[Tact Hub]: Someone got near you.")
                            end
                        end
                    end
                end
            end
        end
    end
        
    checkingnearpeople = RunService.Heartbeat:Connect(function(dt)
        lastCheck += dt
        if lastCheck >= checkInterval then
            checkPeopleNear()
            lastCheck = 0
        end
    end)

    -- monitoring people using sense

    local Players = game:GetService("Players")

    local function checkCharacter(char)
        local torso = char:WaitForChild("Torso", 5)
        if not torso then return end

        local function handleSense(part)
            if part.Name ~= "ChakraSense" then return end
            takemeasurement("[Tact Hub]: Someone is using Sense")

            coroutine.wrap(function()
                while part:IsDescendantOf(workspace) do
                    wait(0.5)
                    takemeasurement("[Tact Hub]: Someone is using Sense")
                end
            end)()
        end

        local existing = torso:FindFirstChild("ChakraSense")
        if existing then
            handleSense(existing)
        end

        torso.ChildAdded:Connect(handleSense)
    end

    local function onPlayerAdded(player)
        if player == plr then return end
        if player.Character then
            checkCharacter(player.Character)
        end
        player.CharacterAdded:Connect(checkCharacter)
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr then
            onPlayerAdded(player)
        end
    end

    Players.PlayerAdded:Connect(onPlayerAdded)

    -- check for mods

    for _, player in ipairs(game.Players:GetPlayers()) do
        local suc, rank = pcall(function()
            return player:GetRankInGroup(7450839)
        end)

        if not suc then
            warn("Failed to get rank for", player.Name)
            continue
        end

        if rank ~= 0 then
            takemeasurement("[Tact Hub]: A mod was in your server.")
        end
    end

end

features.Killboss = function()
    if bossfarmactive.Value then
        features.HandleNotLoadedIn()

        if selectedbosses == nil or features.gotosafespot(true,false) == false then
            return
        end

        -- Global dangerous animation monitor - checks ALL nearby mobs/bosses for the dangerous animation
        local dangerousAnimId = "137738911755203" -- The Ringed Samurai's super dangerous animation
        
        if not getgenv().DangerousAnimMonitorActive then
            getgenv().DangerousAnimMonitorActive = true
            
            print("[Danger Monitor] Starting global dangerous animation monitor...")
            print("[Danger Monitor] Looking for animation ID:", dangerousAnimId)
            
            getgenv().DangerousAnimMonitor = game:GetService("RunService").Heartbeat:Connect(function()
                local success, err = pcall(function()
                    if not bossfarmactive.Value then
                        if getgenv().DangerousAnimMonitor then
                            getgenv().DangerousAnimMonitor:Disconnect()
                            getgenv().DangerousAnimMonitor = nil
                        end
                        getgenv().DangerousAnimMonitorActive = false
                        print("[Danger Monitor] Stopped - boss farm inactive")
                        return
                    end
                    
                    if getgenv().RingedSamuraiDodging then 
                        return 
                    end
                    
                    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then 
                        return 
                    end
                    
                    local myPosition = plr.Character.HumanoidRootPart.Position
                    local MaxDistance = 200 -- Check mobs within 200 studs
                    
                    -- Check all nearby models for the dangerous animation
                    for _, obj in pairs(workspace:GetChildren()) do
                        if obj:IsA("Model") and obj ~= plr.Character then
                            local mobHrp = obj:FindFirstChild("HumanoidRootPart")
                            local humanoid = obj:FindFirstChildOfClass("Humanoid")
                            
                            if mobHrp and humanoid then
                                local distance = (mobHrp.Position - myPosition).Magnitude
                                
                                if distance <= MaxDistance then
                                    local animator = humanoid:FindFirstChildOfClass("Animator")
                                    if animator then
                                        -- Check all currently playing animations
                                        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                                            if track.Animation and track.IsPlaying then
                                                local animId = track.Animation.AnimationId
                                                -- Extract the ID number from "rbxassetid://123456" or "http://www.roblox.com/asset/?id=123456"
                                                local id = string.match(tostring(animId), "%d+")
                                                
                                                -- Debug logging for long animation IDs (likely the one we're looking for)
                                                if id and string.len(id) >= 10 then
                                                    -- Uncomment for verbose debugging:
                                                    -- print("[Danger Monitor] Checking:", obj.Name, "| ID:", id, "| Target:", dangerousAnimId, "| Match:", id == dangerousAnimId)
                                                end
                                                
                                                -- Check if this is the dangerous animation
                                                if id and id == dangerousAnimId then
                                                    print("[Danger Monitor] ========== DANGEROUS ANIMATION DETECTED! ==========")
                                                    print("[Danger Monitor] Mob Name:", obj.Name)
                                                    print("[Danger Monitor] Animation ID:", id)
                                                    print("[Danger Monitor] Full Animation ID:", animId)
                                                    print("[Danger Monitor] Time Position:", track.TimePosition)
                                                    print("[Danger Monitor] Is Playing:", track.IsPlaying)
                                                    
                                                    -- React immediately when detected (no time threshold needed for super dangerous animation)
                                                    print("[Danger Monitor] Animation is playing, triggering teleport immediately...")
                                                    -- Dangerous animation detected from ANY mob/boss!
                                                    getgenv().RingedSamuraiDodging = true
                                                    
                                                    task.spawn(function()
                                                        local teleportSuccess, teleportErr = pcall(function()
                                                            print("[Danger Monitor] Starting teleport sequence...")
                                                            
                                                            local originalPosition = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart.CFrame
                                                            
                                                            if not originalPosition then
                                                                warn("[Danger Monitor] ERROR: Could not get original position!")
                                                                getgenv().RingedSamuraiDodging = false
                                                                return
                                                            end
                                                            
                                                            if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                                                                warn("[Danger Monitor] ERROR: Character or HRP not found!")
                                                                getgenv().RingedSamuraiDodging = false
                                                                return
                                                            end
                                                            
                                                            print("[Danger Monitor] Teleporting 500 studs up...")
                                                            -- Teleport high up in the air (500 studs above)
                                                            local highPosition = originalPosition * CFrame.new(0, 500, 0)
                                                            local hrp = plr.Character.HumanoidRootPart
                                                            hrp.CFrame = highPosition
                                                            
                                                            -- Create BodyVelocity to keep character floating in place
                                                            local bodyVelocity = Instance.new("BodyVelocity")
                                                            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                                                            bodyVelocity.Velocity = Vector3.new(0, 0, 0) -- Zero velocity to stay in place
                                                            bodyVelocity.Parent = hrp
                                                            
                                                            print("[Danger Monitor] Waiting 2 seconds...")
                                                            -- Wait 2 seconds
                                                            task.wait(2)
                                                            
                                                            print("[Danger Monitor] Returning to original position...")
                                                            -- Clean up BodyVelocity before returning
                                                            if bodyVelocity and bodyVelocity.Parent then
                                                                bodyVelocity:Destroy()
                                                            end
                                                            
                                                            -- Return to original farming position
                                                            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and originalPosition then
                                                                plr.Character.HumanoidRootPart.CFrame = originalPosition
                                                                print("[Danger Monitor] Successfully returned to farming position")
                                                            else
                                                                warn("[Danger Monitor] ERROR: Could not return - character/position invalid")
                                                            end
                                                            
                                                            getgenv().RingedSamuraiDodging = false
                                                            print("[Danger Monitor] ========== Danger reaction complete ==========")
                                                        end)
                                                        
                                                        if not teleportSuccess then
                                                            warn("[Danger Monitor] ERROR in teleport function:", teleportErr)
                                                            getgenv().RingedSamuraiDodging = false
                                                        end
                                                    end)
                                                    
                                                    return -- Exit early after detecting
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                
                if not success then
                    warn("[Danger Monitor] ERROR in monitor loop:", err)
                end
            end)
            
            print("[Danger Monitor] Monitor started successfully")
        else
            print("[Danger Monitor] Monitor already active, skipping...")
        end

        if laststandactive == true then
            local playerdata = game:GetService("ReplicatedStorage")
                :WaitForChild("Events")
                :WaitForChild("DataFunction")
                :InvokeServer("GetData")
            
            local metreqs = false

            for i,v in pairs(playerdata["Traits"]) do
                if v == "Last Stand" then
                    metreqs = true
                end
            end

            if metreqs == false then
                Notify("Missing requirements..","You need to have Last Stand Trait", 2.5,"info")
                return
            end
        end

        NoFallDammage.Value = true

        local bosses = {
            ["Tairock"] = {
                rewards = "TairockRewards",
                rewardspos = CFrame.new(-121.222282, -215.594009, -1074.45251, 0.999605715, -4.95959385e-10, 0.0280780215, 7.73429029e-11, 1, 1.49101318e-08, -0.0280780215, -1.49020813e-08, 0.999605715),
                offset = 9
            },
            ["Chakra Knight"] = {
                rewards = "ChakraKnightRewards",
                rewardspos = CFrame.new(2831.09229, -123.500015, -1153.08569, -0.999299586, -1.25896638e-09, -0.0374205671, -1.16711085e-09, 1, -2.47652543e-09, 0.0374205671, -2.43111686e-09, -0.999299586),
                offset = 14,
                dangeranim = "rbxassetid://10141233349",
                seconddangeranim = "rbxassetid://10229183096",
                dangertime = 0.2
            },
            ["Lavarossa"] = {
                rewards = "LavarossaRewards",
                rewardspos = CFrame.new(-500.209869, -312.065948, -193.457336, -0.00906983018, 7.53408287e-08, 0.999958873, 7.59981873e-08, 1, -7.46546078e-08, -0.999958873, 7.53179563e-08, -0.00906983018),
                argument = "activateLavarossa",
                bosspos = CFrame.new(-536.194763, -314.055023, -201.574188, -0.159694523, 4.51376314e-09, 0.987166464, 4.54713767e-11, 1, -4.56508786e-09, -0.987166464, -6.84131751e-10, -0.159694523),
                offset = 11,
                dangeranim = "rbxassetid://6038040720",
                dangertime = 0.55
            },

            ["Barbarit The Rose"] = {
                rewards = "BarbaritRewards",
                rewardspos = CFrame.new(-1032.42004, 262.756836, -1413.35388, -0.999958932, 5.12125879e-08, -0.00906013697, 5.05472855e-08, 1, 7.36610488e-08, 0.00906013697, 7.32000629e-08, -0.999958932),
                argument = "activateBarbarit",
                bosspos = CFrame.new(-1031.22461, 260.756836, -1631.61987, 0.50503391, 2.51075054e-08, 0.863099515, -3.28260157e-08, 1, -9.88212268e-09, -0.863099515, -2.33413111e-08, 0.50503391),
                offset = 12.5,
                dangeranim = "rbxassetid://9656290960",
                dangertime = 0.5
            },

                ["The Ringed Samurai"] = {
                    rewards = "SamuraiRewards",
                    rewardspos = CFrame.new(1605.684326171875, -484.36712646484375, -555.8062744140625, 0.0041049327701330185, -3.282757887745902e-08, 0.9999915957450867, 8.549213248443266e-08, 1, 3.2476911826506694e-08, -0.9999915957450867, 8.535809570275887e-08, 0.0041049327701330185),
                    argument = "activateSamurai",
                    bosspos = CFrame.new(1353.6343994140625, -477.6519775390625, -592.4925537109375, -0.8328624367713928, -1.4850641605335113e-08, 0.5534800291061401, -1.6331934915569946e-08, 1, 2.255520881178086e-09, -0.5534800291061401, -7.160861681398956e-09, -0.8328624367713928),
                    offset = 12.5,
                    dangeranim = "rbxassetid://137738911755203", -- Super dangerous animation - teleports player high up
                    dangertime = 0.1
            },
            ["Manda"] = {
                rewards = "MandaRewards",
                rewardspos = CFrame.new(1526.77515, -534.000061, 726.881836, -0.999981165, -1.28677238e-08, -0.00613576965, -1.29080728e-08, 1, 6.53631593e-09, 0.00613576965, 6.61539401e-09, -0.999981165),
                argument = "activateManda",
                bosspos = CFrame.new(1566.04309, -536.000488, 694.507812, -0.957136989, -9.88222837e-08, 0.289635658, -8.50688906e-08, 1, 6.00744414e-08, -0.289635658, 3.28604877e-08, -0.957136989),
                offset = 35,
                dangeranim = "rbxassetid://9954909571",
                dangertime = 0.4
            },
            ["Lava Snake"] = {
                rewards = "LavaSnakeRewards",
                rewardspos = CFrame.new(-576.7991333007812, -548.97705078125, -1486.1002197265625, 1, -1.688240658381801e-08, -3.6780813312577154e-15, 1.688240658381801e-08, 1, 4.487672100594864e-08, 2.920454405652001e-15, -4.487672100594864e-08, 1),
                argument = "activateLavaSnake", -- TODO: Verify this is the correct activation argument
                bosspos = CFrame.new(-611.9110717773438, -548.97705078125, -1296.79638671875, 0.9991236925125122, -2.4931788189519466e-08, -0.04185566306114197, 2.8076847513602843e-08, 1, 7.455273021150788e-08, 0.04185566306114197, -7.566256954305572e-08, 0.9991236925125122),
                offset = 35,
                dangeranim = "rbxassetid://9954909571",
                dangertime = 0.4
            },
            ["Wooden Golem"] = {
                rewards = "WoodenGolemRewards",
                rewardspos = CFrame.new(-4705.57959, 336.919739, -2947.58691, -0.0247377306, -8.55055404e-09, 0.99969399, 5.33501918e-08, 1, 9.8733377e-09, -0.99969399, 5.35781126e-08, -0.0247377306),
                dangeranim = "rbxassetid://116907126244057",
                seconddangeranim = "rbxassetid://120758909308511",
                offset = 12,
                dangertime = 0.95
            },
            ["Shukaku"] = {
                rewards = "ShukakuRewards",
                rewardspos = CFrame.new(1947.83374, -125.386833, -1214.7688, 0.999622822, -1.17530725e-07, -0.0274633951, 1.18851858e-07, 1, 4.64730512e-08, 0.0274633951, -4.97195991e-08, 0.999622822),
                offset = 36,
                dangeranim = "rbxassetid://114433999627506",
                dangertime = 0.4
            },
            ["Matatabi"] = {
                rewards = "MatabiRewards",
                rewardspos = CFrame.new(1331.77, -536.00, 292.88, -0.999981165, -1.28677238e-08, -0.00613576965, -1.29080728e-08, 1, 6.53631593e-09, 0.00613576965, 6.61539401e-09, -0.999981165),
                offset = 35,
                dangeranim = "rbxassetid://9954909571",
                dangertime = 0.4
            },
            ["Hyuga Boss"] = {
                rewards = "Hyuga BossRewards",
                rewardspos = CFrame.new(-673.371765, -359.864746, -732.643982, 0.999200761, -7.67889397e-09, 0.0399733, 7.69931052e-09, 1, -3.56805974e-10, -0.0399733, 6.64287625e-10, 0.999200761),
                offset = 8,
                dangeranim = "rbxassetid://8580099842",
                seconddangeranim = "rbxassetid://8699113073",
                dangertime = 0.25
            },
        }

        local function bossguiconfig(action, name, health)
            if action == "disable" then
                BossFrame.Visible = false
            else
                BossFrame.Visible = true
            end

            if action == "killboss" then
                BossTitle.Text = "Current Boss: "..name
                BossHPLabel.Text = health
            else
                BossHPLabel.Text = ""
            end

            if action == "pickingup" then
                BossTitle.Text = "Picking Up Loot.."
            elseif action == "waiting" then
                BossTitle.Text = "Waiting for Bosses.."
            elseif action == "spawning" then
                BossTitle.Text = "Spawning Boss: "..name.. ".."
            end
        end

        local heavyweapon = nil
        
        local function renamehallowbosses()
            for _, hallow in pairs(game.workspace:GetChildren()) do
                if hallow.Name == "Hallowed Tairock" then
                    hallow.Name = "Tairock"
                    hallow:SetAttribute("hallow", true)
                elseif hallow.Name == "Hallowed Lavarossa" then
                    hallow.Name = "Lavarossa"
                    hallow:SetAttribute("hallow", true)
                    hallow:SetAttribute("hallow")
                elseif hallow.Name == "Barbarit The Hallowed" then
                    hallow.Name = "Barbarit The Rose"
                    hallow:SetAttribute("hallow", true)
                elseif hallow.Name == "Hallowed Chakra Knight" then
                    hallow.Name = "Chakra Knight"
                    hallow:SetAttribute("hallow", true)
                end
            end
        end
        
        -- determine weapon to autoequip
        local weapontoautoequip = nil
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")
        local playerdata,region,servername = remote:InvokeServer("GetData")

        weapontoautoequip = playerdata["CurrentWeapon"]


        local function lookforweapon()
            local possibleweapons = {"Golden Zabunagi","Silver Zabunagi","Onyx Zabunagi", "Samehada", "Executioner's Blade"}
            if weapontoautoequip ~= nil then
                for _,name in pairs(possibleweapons) do
                    if weapontoautoequip == name then
                        return weapontoautoequip
                    end
                end
            end

            return nil
        end

        spawn(function()
            -- prevent chakra loss
            local DataEvent = RS:WaitForChild("Events"):WaitForChild("DataEvent")
            local subCooldownValue = RS.Settings[user]:FindFirstChild("SubCooldown")
            local cooldown = 8.5
            local lastSubChangeTime = tick()

            local subcdConnection = subCooldownValue.Changed:Connect(function(newVal)
                lastSubChangeTime = tick()
            end)

            local function bossbuffchakra()

                local chakra = plr.Backpack:FindFirstChild("chakra")
                local startval = chakra.Value
                            
                bosscbuffing = chakra.Changed:Connect(function(newval)

                    if newval < startval then
                        local lostamount = startval - newval                      
                        local newchakra = chakra.Value + lostamount
                        if newval + lostamount <= plr.Backpack.maxChakra.Value then
                            local args = {
                                [1] = "TakeChakra",
                                [2] = lostamount * -1
                            }
                                    
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                            chakra.Value = newchakra
                        end

                        startval = newval

                        if chakra.Value > plr.Backpack.maxChakra.Value then
                            chakra.Value = plr.Backpack.maxChakra.Value
                        end
                    else
                        startval = newval
                    end
                end)
            end

            bossbuffchakra()

            respawningbosschakra = plr.CharacterAdded:Connect(function()
                bosscbuffing:Disconnect()
                wait(1.3)
                bossbuffchakra()
            end)

            -- Hide Animations and Play Chakra Sense animation
            local track

            local function hideanim()
                local character = plr.Character or plr.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")
                local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://9864206537"

                track = animator:LoadAnimation(anim)
                track.Priority = Enum.AnimationPriority.Core
                track.Looped = true
                track:Play()

                stoppinganim = animator.AnimationPlayed:Connect(function(newTrack)
                    if newTrack ~= track then
                        newTrack:Stop()
                    end
                end)

                stoppingburn = character.HumanoidRootPart.FireAilment.Played:Connect(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("RemoveFireAilment")
                end)
            end

            hideanim()

            respawninganimhide = plr.CharacterAdded:Connect(function()
                stoppinganim:Disconnect()
                wait(1.3)
                hideanim()
            end)

            task.spawn(function()
                while bossfarmactive.Value do 
                    task.wait()

                    local userSettings = RS.Settings:FindFirstChild(user)
                    if not userSettings then continue end

                    local meleeCooldown = userSettings:WaitForChild("MeleeCooldown")

                    if plr.Character and plr.Character:FindFirstChild("FakeHead") and plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI") and autoequipweapon and weapontoautoequip then
                        if plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI").skillName.Text ~= weapontoautoequip then
                            wait(0.4)
                            RS.Events.DataEvent:FireServer("Item", "Unselected", plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI").skillName.Text)
                            RS.Events.DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                        end
                    end

                    if meleeCooldown then
                        local args = { [1] = "CheckMeleeHit", [3] = "NormalAttack", [4] = false }
                        RS.Events.DataEvent:FireServer(unpack(args))
                        task.wait(0.15)
                    else
                        task.wait()
                    end
                end
            end)

            while bossfarmactive.Value == true do 
                wait(0.2)
                if tick() - lastSubChangeTime >= cooldown then
                    if plr.Character and plr.Character.HumanoidRootPart then
                        DataEvent:FireServer("TakeDamage", 0.000000001)
                        DataEvent:FireServer("Dash", "Sub", plr.Character.HumanoidRootPart.Position)
                    end
                end

                if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("Blocking") then
                    if RS.Settings[user]:FindFirstChild("Blocking").Value == false then
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack({"Block"}))
                    end
                end

                local args = {
                    "Charging"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            end


            -- clean up sub loop and respawn chakra apply and current chakra apply and animation hide

            if respawninganimhide then
                respawninganimhide:Disconnect()
            end

            if stoppinganim then
                stoppinganim:Disconnect()
            end

            if stoppingburn then
                stoppingburn:Disconnect()
            end

            if track then
                track:Stop() -- stop your animation when ending the loop
            end

            if subcdConnection then
                subcdConnection:Disconnect()
            end

            if bosscbuffing then
                bosscbuffing:Disconnect()
            end

            if respawningbosschakra then
                respawningbosschakra:Disconnect()
            end
        end)

        if nocooldownm1 then
            heavyweapon = lookforweapon()
            if heavyweapon == nil then
                Notify("Missing requirements.","You need a Heavy Weapon for inf M1.",2,"info")
                return
            else

                local DataEvent = RS:WaitForChild("Events"):WaitForChild("DataEvent")

                spawn(function()

                    while bossfarmactive.Value do
                        -- spam sub to reset stun and stack m1
                        wait()

                        if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("CombatCount") then
                            if RS.Settings[user]:FindFirstChild("CurrentWeapon") then
                                if RS.Settings[user]:FindFirstChild("CurrentWeapon").Value ~= "Fist" and RS.Settings[user]:FindFirstChild("CurrentWeapon").Value ~= "Tai" then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("Item","Unselected", weapontoautoequip)
                                end
                            end

                            if RS.Settings[user].CombatCount.Value > 3 then
                                DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                                DataEvent:FireServer("Item", "Unselected", weapontoautoequip)
                            end
                        end
                    end
                end)
            end
        end

        local function checkbossstatus(selectedboss)

            bossguiconfig("waiting")

            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == selectedboss then
                    if v:FindFirstChild("HumanoidRootPart") then
                        if not v:FindFirstChild("WorldEvent") and not v:FindFirstChild("npcImmuneTag") and Teleport(v:FindFirstChild("HumanoidRootPart").CFrame,false,true) == true then
                            return true, v:FindFirstChild("HumanoidRootPart")
                        end
                    end
                end
            end

            if selectedboss == "Lavarossa" or selectedboss == "Barbarit The Rose" or selectedboss == "Manda" or selectedboss == "Lava Snake" or selectedboss == "The Ringed Samurai" then
                if workspace:FindFirstChild(bosses[selectedboss].rewards):FindFirstChild("Part").Transparency == 0 then
                    return false
                end
                
                if Teleport(bosses[selectedboss].bosspos) == false then return end
                    bossguiconfig("spawning", selectedboss)

                wait(0.25)

                local args = {
                    [1] = bosses[selectedboss].argument
                }
                    
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                plr.Character.Humanoid.Jump = true
                wait(0.3)
            end

            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == selectedboss then
                    if v:FindFirstChild("HumanoidRootPart") then
                        if not v:FindFirstChild("WorldEvent") and not v:FindFirstChild("npcImmuneTag") and Teleport(v:FindFirstChild("HumanoidRootPart").CFrame,false,true) == true then
                            return true, v:FindFirstChild("HumanoidRootPart")
                        end
                    end
                end
            end
        end

        local function finishboss(bosshrp, selectedboss)
            local killing = true
            local bossishallowed = false

            if bosshrp.Parent:GetAttribute("hallow") ~= nil then
                bossishallowed = true
            end
            
            local function tpandreacttoboss(bosshumanoidrootpart)
                local extraoffset = 0
                local firstdodge = false

                if sliderbossoffset ~= nil then
                    extraoffset = extraoffset + sliderbossoffset
                end

                if selectedboss ~= "Tairock" and selectedboss ~= "Lavarossa" then
                    local animator = bosshumanoidrootpart.Parent.Humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            if track.Animation.AnimationId == bosses[selectedboss].dangeranim then
                                if track.TimePosition > bosses[selectedboss].dangertime then
                                    if selectedboss == "Chakra Knight" then
                                        if track.TimePosition < 0.8 then
                                            extraoffset = 30
                                            firstdodge = true
                                        end
                                    elseif selectedboss == "Barbarit The Rose" then
                                        extraoffset = 2
                                        firstdodge = true
                                    elseif selectedboss == "Wooden Golem" then
                                        extraoffset = 200
                                        firstdodge = true
                                    elseif selectedboss == "Manda" or selectedboss == "Lava Snake" then
                                        if track.TimePosition < 2.7 then
                                            extraoffset = 30
                                            firstdodge = true


                                        end
                                    elseif selectedboss == "Hyuga Boss" then
                                        extraoffset = 12
                                        firstdodge = true
                                    end
                                end
                            end
                        end
                        if firstdodge == false then
                            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                if track.Animation.AnimationId == bosses[selectedboss].seconddangeranim then
                                    if track.TimePosition > bosses[selectedboss].dangertime then
                                        if selectedboss == "Wooden Golem" then
                                            extraoffset = -137
                                        elseif selectedboss == "Chakra Knight" then
                                            extraoffset = 5
                                        elseif selectedboss == "Shukaku" then
                                            extraoffset = 2
                                        elseif selectedboss == "Hyuga Boss" then
                                            extraoffset = 20
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                local abovePos = bosshrp.Position + Vector3.new(0, bosses[selectedboss].offset + extraoffset, 0)
                local lookDown = CFrame.new(abovePos, bosshrp.Position)

                plr.Character.HumanoidRootPart.CFrame = lookDown
            end

            -- check safety
            local tweening = nil
            wait(0.5)

            tweening = game:GetService("RunService").Heartbeat:Connect(function()
                if bossfarmactive.Value == false then
                    warn("boss farm is disabled")
                    killing = false
                    return
                end

                -- Skip position updates if we're dodging a dangerous animation
                if getgenv().RingedSamuraiDodging then
                    return
                end

                if bosshrp and bosshrp.Parent ~= nil and bosshrp.Parent:FindFirstChild("Humanoid") then
                    -- goto boss
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("Knocked") then
                            if RS.Settings[user]:FindFirstChild("Knocked").Value == true then
                                if plr.Character.HumanoidRootPart then
                                    features.gotosafespot()
                                end
                            else
                                tpandreacttoboss(bosshrp)
                            end
                        end
                    end
                    
                    -- Damage Display for GUI
                        local hp = bosshrp.Parent.Humanoid.Health // 10 * 10
                        local maxhp = bosshrp.Parent.Humanoid.MaxHealth // 10 * 10

                        local tag = "HP: "..hp.."/"..maxhp
                        if tag ~= BossHPLabel.Text then
                            bossguiconfig("killboss", selectedboss, tag)
                        end

                    --grip boss/ dodge lava attack while grip
                    if selectedboss == "Lavarossa" or selectedboss == "Barbarit The Rose" or selectedboss == "Tairock" then
                        if bosshrp.Parent:FindFirstChild("Settings"):FindFirstChild("Knocked").Value == true then
                            if selectedboss == "Lavarossa" then
                                if bosshrp.Parent.LavaRightArm.Transparency == 1 and bosshrp.Parent.LavaLeftArm.Transparency == 1 and bosshrp.Parent.LavaRightLeg.Transparency == 1 and bosshrp.Parent.LavaLeftLeg.Transparency == 1 then
                                    plr.Character.HumanoidRootPart.CFrame = bosshrp.CFrame
                                    local args = {
                                        [1] = "Grip"
                                    }
                                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                                end
                            else
                                plr.Character.HumanoidRootPart.CFrame = bosshrp.CFrame
                                local args = {
                                    [1] = "Grip"
                                }
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                            end
                        end
                    end
                else
                    warn("bosshrp or humanoid")
                    killing = false
                end
            end)
            
            -- Last Stand Trigger/keep function running
            if laststandactive == true then
                warn("start killing boss")
                local targethp = plr.Character.Humanoid.MaxHealth / 5
                local cooldown = false
                while killing == true do
                    wait()
                    if plr.Character then
                        if plr.Character.Humanoid then
                            if plr.Character.Humanoid.Health > targethp and cooldown == false then
                                local args = {
                                    [1] = "TakeDamage",
                                    [2] = plr.Character.Humanoid.Health - targethp + 2,
                                    [3] = "yes"
                                }
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                                cooldown = true
                                spawn(function()
                                    wait(1)
                                    cooldown = false
                                end)
                            end
                        end
                    end
                end
            else
                warn("start killing boss")
                while killing == true do
                    wait()
                end
            end
            
            if tweening then             
                tweening:Disconnect()
                warn("tween disconnect")
            end
            warn("killing boss done")
            if bossfarmactive.Value == false then return end

            local rewardsplace = workspace:FindFirstChild(bosses[selectedboss].rewards)
            if rewardsplace:FindFirstChild("TrinketSpawn1") then
                if not rewardsplace["TrinketSpawn1"]:FindFirstChild("Occupied") then
                    features.gotosafespot()
                    wait()
                    return
                end
            end

            if bossfarmactive.Value == false then return end

            plr.Character.HumanoidRootPart.CFrame = bosses[selectedboss].rewardspos

            local bosspickuptable = {}
            local dropsthere = false

            bossguiconfig("pickingup")

            local lootdropwait
            lootdropwait = game.Workspace.ChildAdded:Connect(function(newthing)
                local idObject = newthing:FindFirstChild("ID") or newthing:FindFirstChildWhichIsA("StringValue", true)
                
                if not idObject then
                    for _, desc in pairs(newthing:GetDescendants()) do
                        if desc.Name == "ID" then
                            idObject = desc
                            break
                        end
                    end
                end

                if idObject then
                    table.insert(bosspickuptable, {object = newthing, id = idObject})
                    dropsthere = true
                    wait(0.125)
                end
            end)

            repeat
                task.wait()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    plr.Character.HumanoidRootPart.CFrame = bosses[selectedboss].rewardspos
                end
            until dropsthere or not bossfarmactive.Value

            task.wait(3)

            if dropsthere then
                for i = #bosspickuptable, 1, -1 do
                    local entry = bosspickuptable[i]
                    local v, idObject = entry.object, entry.id

                    if v and v:IsDescendantOf(workspace) and idObject then
                        local targetCFrame

                        if v:IsA("BasePart") then
                            targetCFrame = v.CFrame * CFrame.new(0, 1, 0)
                        else
                            for _, part in pairs(v:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    targetCFrame = part.CFrame * CFrame.new(0, 1, 0)
                                    break
                                end
                            end
                        end

                        if targetCFrame and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            plr.Character.HumanoidRootPart.CFrame = targetCFrame
                        end

                        local startTime = tick()
                        while v and v:IsDescendantOf(workspace) and (tick() - startTime < 2) do
                            game.ReplicatedStorage.Events.DataEvent:FireServer("PickUp", idObject.Value)
                            task.wait()
                        end

                        table.remove(bosspickuptable, i)
                    end
                end
            end

            task.wait(1)

            if lootdropwait then
                lootdropwait:Disconnect()
            end

            if bossishallowed == true then
                for _, values in pairs(workspace:GetChildren()) do
                    if values.Name == "Candy" and values:FindFirstChild(user) then
                        while values and values:IsDescendantOf(workspace) and bossfarmactive.Value do
                            wait()
                            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                plr.Character.HumanoidRootPart.CFrame = values.CFrame
                            end
                            task.spawn(function()
                                wait(0.1)
                                for _, children in pairs(values:GetChildren()) do
                                    if children:IsA("ClickDetector") then
                                        fireclickdetector(children)
                                    end
                                end
                            end)
                        end
                    end
                end
            end

            features.gotosafespot()
        end

        local bossthere = false
        local bosshrp

        local lookingforbosscounter = 0

        -- MAIN PART
        -- renaming the bosses

        renamechildconn = game.workspace.ChildAdded:Connect(function(chi)
            if chi.Name == "Hallowed Tairock"
            or chi.Name == "Hallowed Lavarossa"
            or chi.Name == "Barbarit The Hallowed"
            or chi.Name == "Hallowed Chakra Knight" then
                renamehallowbosses()
            end
        end)
        
        renamehallowbosses()

        while bossfarmactive.Value do
            for i, v in selectedbosses do
                if bossfarmactive.Value then
                    if plr.Character then
                        if plr.Character.HumanoidRootPart then
                            bossthere, bosshrp = checkbossstatus(v)
                        end
                    end
                end
                if bossthere then
                    if bossfarmactive.Value then
                        lookingforbosscounter = 0
                        finishboss(bosshrp, v)
                    end
                elseif serverhopnoboss == true then
                    lookingforbosscounter += 1
                    if lookingforbosscounter > 10 then
                        features.TeleportRandomServer()
                        return
                    end
                end
                wait()
                bossthere = false
                bosshrp = nil
            end
            wait()
        end


        -- DISABLING
    else

        NoFallDammage.Value = false
        BossFrame.Visible = false

        if renamechildconn then
            renamechildconn:Disconnect()
            renamechildconn = nil
        end

        if tweening then
            tweening:Disconnect()
            tweening = nil
        end

        if lootdropwait then
            lootdropwait:Disconnect()
            lootdropwait = nil
        end

        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack({"EndBlock"}))
        bossthere = false
        bosshrp = nil
        task.spawn(function()
            wait(0.1)
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack({"EndBlock"}))
        end)
    end
end

features.ChristmasFarm = function()
    if christmasfarmactive.Value then
        features.HandleNotLoadedIn()

        if features.gotosafespot(true,false) == false then
            return
        end

        NoFallDammage.Value = true

        local selectedboss = "Frosted The Rose"
        local bossconfig = {
            rewards = "BarbaritRewards",
            rewardspos = CFrame.new(-1032.42004, 262.756836, -1413.35388, -0.999958932, 5.12125879e-08, -0.00906013697, 5.05472855e-08, 1, 7.36610488e-08, 0.00906013697, 7.32000629e-08, -0.999958932),
            argument = "activateBarbarit",
            bosspos = CFrame.new(-1031.22461, 260.756836, -1631.61987, 0.50503391, 2.51075054e-08, 0.863099515, -3.28260157e-08, 1, -9.88212268e-09, -0.863099515, -2.33413111e-08, 0.50503391),
            offset = 12.5,
            dangeranim = "rbxassetid://9656290960",
            dangertime = 0.5
        }

        -- determine weapon to autoequip
        local weapontoautoequip = nil
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")
        local playerdata,region,servername = remote:InvokeServer("GetData")

        weapontoautoequip = playerdata["CurrentWeapon"]

        local function lookforweapon()
            local possibleweapons = {"Golden Zabunagi","Silver Zabunagi","Onyx Zabunagi", "Samehada", "Executioner's Blade"}
            if weapontoautoequip ~= nil then
                for _,name in pairs(possibleweapons) do
                    if weapontoautoequip == name then
                        return weapontoautoequip
                    end
                end
            end

            return nil
        end

        -- Track existing Candy Canes before boss death (to ignore old ones)
        print("[Christmas Farm] Tracking existing Candy Canes...")
        local existingCandyCanes = {}
        local existingCount = 0
        for _, v in pairs(workspace:GetDescendants()) do
            if v and v.Name == "Candy Cane" then
                existingCandyCanes[v] = true
                existingCount = existingCount + 1
            end
        end
        print("[Christmas Farm] Found", existingCount, "existing Candy Canes to ignore")
        
        -- Table to track new Candy Canes that spawn after boss death
        local newCandyCanes = {}
        local candypickupconnection = nil

        spawn(function()
            -- prevent chakra loss
            local DataEvent = RS:WaitForChild("Events"):WaitForChild("DataEvent")
            local subCooldownValue = RS.Settings[user]:FindFirstChild("SubCooldown")
            local cooldown = 8.5
            local lastSubChangeTime = tick()

            local subcdConnection = subCooldownValue.Changed:Connect(function(newVal)
                lastSubChangeTime = tick()
            end)

            local function bossbuffchakra()
                local chakra = plr.Backpack:FindFirstChild("chakra")
                local startval = chakra.Value
                            
                local bosscbuffing = chakra.Changed:Connect(function(newval)
                    if newval < startval then
                        local lostamount = startval - newval                      
                        local newchakra = chakra.Value + lostamount
                        if newval + lostamount <= plr.Backpack.maxChakra.Value then
                            local args = {
                                [1] = "TakeChakra",
                                [2] = lostamount * -1
                            }
                                    
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                            chakra.Value = newchakra
                        end

                        startval = newval

                        if chakra.Value > plr.Backpack.maxChakra.Value then
                            chakra.Value = plr.Backpack.maxChakra.Value
                        end
                    else
                        startval = newval
                    end
                end)
                
                return bosscbuffing
            end

            local bosscbuffing = bossbuffchakra()

            local respawningbosschakra = plr.CharacterAdded:Connect(function()
                if bosscbuffing then bosscbuffing:Disconnect() end
                wait(1.3)
                bosscbuffing = bossbuffchakra()
            end)

            -- Hide Animations and Play Chakra Sense animation
            local track

            local function hideanim()
                local character = plr.Character or plr.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")
                local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://9864206537"

                track = animator:LoadAnimation(anim)
                track.Priority = Enum.AnimationPriority.Core
                track.Looped = true
                track:Play()

                local stoppinganim = animator.AnimationPlayed:Connect(function(newTrack)
                    if newTrack ~= track then
                        newTrack:Stop()
                    end
                end)

                local stoppingburn = character.HumanoidRootPart.FireAilment.Played:Connect(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("RemoveFireAilment")
                end)
                
                return stoppinganim, stoppingburn
            end

            local stoppinganim, stoppingburn = hideanim()

            local respawninganimhide = plr.CharacterAdded:Connect(function()
                if stoppinganim then stoppinganim:Disconnect() end
                if stoppingburn then stoppingburn:Disconnect() end
                wait(1.3)
                stoppinganim, stoppingburn = hideanim()
            end)

            task.spawn(function()
                while christmasfarmactive.Value do 
                    task.wait()

                    local userSettings = RS.Settings:FindFirstChild(user)
                    if not userSettings then continue end

                    local meleeCooldown = userSettings:WaitForChild("MeleeCooldown")

                    if plr.Character and plr.Character:FindFirstChild("FakeHead") and plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI") and autoequipweapon and weapontoautoequip then
                        if plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI").skillName.Text ~= weapontoautoequip then
                            wait(0.4)
                            RS.Events.DataEvent:FireServer("Item", "Unselected", plr.Character:FindFirstChild("FakeHead"):FindFirstChild("skillGUI").skillName.Text)
                            RS.Events.DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                        end
                    end

                    if meleeCooldown then
                        local args = { [1] = "CheckMeleeHit", [3] = "NormalAttack", [4] = false }
                        RS.Events.DataEvent:FireServer(unpack(args))
                        task.wait(0.15)
                    else
                        task.wait()
                    end
                end
            end)

            while christmasfarmactive.Value == true do 
                wait(0.2)
                if tick() - lastSubChangeTime >= cooldown then
                    if plr.Character and plr.Character.HumanoidRootPart then
                        DataEvent:FireServer("TakeDamage", 0.000000001)
                        DataEvent:FireServer("Dash", "Sub", plr.Character.HumanoidRootPart.Position)
                    end
                end

                if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("Blocking") then
                    if RS.Settings[user]:FindFirstChild("Blocking").Value == false then
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack({"Block"}))
                    end
                end

                local args = {
                    "Charging"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            end

            -- Cleanup
            if respawninganimhide then respawninganimhide:Disconnect() end
            if stoppinganim then stoppinganim:Disconnect() end
            if stoppingburn then stoppingburn:Disconnect() end
            if track then track:Stop() end
            if subcdConnection then subcdConnection:Disconnect() end
            if bosscbuffing then bosscbuffing:Disconnect() end
            if respawningbosschakra then respawningbosschakra:Disconnect() end
        end)

        if nocooldownm1 then
            local heavyweapon = lookforweapon()
            if heavyweapon == nil then
                Notify("Missing requirements.","You need a Heavy Weapon for inf M1.",2,"info")
                return
            else
                local DataEvent = RS:WaitForChild("Events"):WaitForChild("DataEvent")

                spawn(function()
                    while christmasfarmactive.Value do
                        wait()

                        if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("CombatCount") then
                            if RS.Settings[user]:FindFirstChild("CurrentWeapon") then
                                if RS.Settings[user]:FindFirstChild("CurrentWeapon").Value ~= "Fist" and RS.Settings[user]:FindFirstChild("CurrentWeapon").Value ~= "Tai" then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("Item","Unselected", weapontoautoequip)
                                end
                            end

                            if RS.Settings[user].CombatCount.Value > 3 then
                                DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                                DataEvent:FireServer("Item", "Unselected", weapontoautoequip)
                            end
                        end
                    end
                end)
            end
        end

        local function checkbossstatus()
            -- Check for Frosted The Rose boss in workspace (80% chance)
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "Frosted The Rose" then
                    if v:FindFirstChild("HumanoidRootPart") then
                        if not v:FindFirstChild("WorldEvent") and not v:FindFirstChild("npcImmuneTag") and Teleport(v:FindFirstChild("HumanoidRootPart").CFrame,false,true) == true then
                            return true, v:FindFirstChild("HumanoidRootPart"), "Frosted The Rose"
                        end
                    end
                end
            end

            -- Check for Barbarit The Rose boss in workspace (20% chance - original)
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "Barbarit The Rose" then
                    if v:FindFirstChild("HumanoidRootPart") then
                        if not v:FindFirstChild("WorldEvent") and not v:FindFirstChild("npcImmuneTag") then
                            -- If serverhop is enabled, serverhop immediately
                            if serverhopnoboss then
                                features.TeleportRandomServer()
                                return false, nil, nil
                            else
                                -- Otherwise, kill the original Barbarit The Rose
                                if Teleport(v:FindFirstChild("HumanoidRootPart").CFrame,false,true) == true then
                                    return true, v:FindFirstChild("HumanoidRootPart"), "Barbarit The Rose"
                                end
                            end
                        end
                    end
                end
            end

            -- Check if rewards are available (boss not spawned yet)
            if workspace:FindFirstChild(bossconfig.rewards) then
                if workspace:FindFirstChild(bossconfig.rewards):FindFirstChild("Part") and workspace:FindFirstChild(bossconfig.rewards):FindFirstChild("Part").Transparency == 0 then
                    return false, nil, nil
                end
            end
            
            -- Try to spawn the boss - teleport to the boss position
            if Teleport(bossconfig.bosspos) == false then return false, nil, nil end

            wait(0.25)

            local args = {
                [1] = bossconfig.argument
            }
                
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            plr.Character.Humanoid.Jump = true
            wait(0.3)

            -- Wait for boss to spawn (check multiple times)
            local spawnTimeout = tick() + 5
            while tick() < spawnTimeout and christmasfarmactive.Value do
                -- Check for Frosted The Rose first (preferred)
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Frosted The Rose" then
                        if v:FindFirstChild("HumanoidRootPart") then
                            if not v:FindFirstChild("WorldEvent") and not v:FindFirstChild("npcImmuneTag") and Teleport(v:FindFirstChild("HumanoidRootPart").CFrame,false,true) == true then
                                return true, v:FindFirstChild("HumanoidRootPart"), "Frosted The Rose"
                            end
                        end
                    end
                end
                
                -- Check for Barbarit The Rose (20% chance)
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Barbarit The Rose" then
                        if v:FindFirstChild("HumanoidRootPart") then
                            if not v:FindFirstChild("WorldEvent") and not v:FindFirstChild("npcImmuneTag") then
                                -- If serverhop is enabled, serverhop immediately
                                if serverhopnoboss then
                                    features.TeleportRandomServer()
                                    return false, nil, nil
                                else
                                    -- Otherwise, kill the original Barbarit The Rose
                                    if Teleport(v:FindFirstChild("HumanoidRootPart").CFrame,false,true) == true then
                                        return true, v:FindFirstChild("HumanoidRootPart"), "Barbarit The Rose"
                                    end
                                end
                            end
                        end
                    end
                end
                wait(0.1)
            end
            
            return false, nil, nil
        end

        local function finishboss(bosshrp)
            local killing = true
            
            local function tpandreacttoboss(bosshumanoidrootpart)
                local extraoffset = 0
                local firstdodge = false

                local animator = bosshumanoidrootpart.Parent.Humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        if track.Animation.AnimationId == bossconfig.dangeranim then
                            if track.TimePosition > bossconfig.dangertime then
                                extraoffset = 2
                                firstdodge = true
                            end
                        end
                    end
                end

                local abovePos = bosshrp.Position + Vector3.new(0, bossconfig.offset + extraoffset, 0)
                local lookDown = CFrame.new(abovePos, bosshrp.Position)

                plr.Character.HumanoidRootPart.CFrame = lookDown
            end

            wait(0.5)

            -- Track boss HP to detect if damage is being dealt
            local lastBossHP = nil
            local lastHPChangeTime = tick()
            local hpCheckInterval = 5 -- Check HP every 5 seconds
            local lastHPCheckTime = tick()

            local tweening = game:GetService("RunService").Heartbeat:Connect(function()
                if christmasfarmactive.Value == false then
                    killing = false
                    return
                end

                if bosshrp and bosshrp.Parent ~= nil and bosshrp.Parent:FindFirstChild("Humanoid") then
                    local bossHumanoid = bosshrp.Parent:FindFirstChild("Humanoid")
                    
                    -- Track boss HP
                    if bossHumanoid then
                        local currentHP = bossHumanoid.Health
                        
                        -- Check HP every 5 seconds
                        if tick() - lastHPCheckTime >= hpCheckInterval then
                            lastHPCheckTime = tick()
                            
                            if lastBossHP then
                                local hpChange = lastBossHP - currentHP
                                
                                -- If HP decreased, reset the timer
                                if hpChange > 0 then
                                    lastHPChangeTime = tick()
                                    print("[Christmas Farm] Boss taking damage! HP:", math.floor(currentHP), "/", math.floor(bossHumanoid.MaxHealth), "(-" .. math.floor(hpChange) .. ")")
                                else
                                    -- HP hasn't decreased, check how long
                                    local timeSinceHPChange = tick() - lastHPChangeTime
                                    if timeSinceHPChange > 15 then
                                        warn("[Christmas Farm] ========== BOSS HP NOT DECREASING ==========")
                                        warn("[Christmas Farm] Boss HP hasn't changed for", math.floor(timeSinceHPChange), "seconds!")
                                        warn("[Christmas Farm] Current HP:", math.floor(currentHP), "/", math.floor(bossHumanoid.MaxHealth))
                                        warn("[Christmas Farm] Serverhopping...")
                                        killing = false
                                        if tweening then tweening:Disconnect() end
                                        features.TeleportRandomServer()
                                        return
                                    else
                                        print("[Christmas Farm] Boss HP not decreasing (", math.floor(timeSinceHPChange), "seconds). Current HP:", math.floor(currentHP))
                                    end
                                end
                            end
                            
                            lastBossHP = currentHP
                        end
                    end
                    
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("Knocked") then
                            if RS.Settings[user]:FindFirstChild("Knocked").Value == true then
                                if plr.Character.HumanoidRootPart then
                                    features.gotosafespot()
                                end
                            else
                                tpandreacttoboss(bosshrp)
                            end
                        end
                    end
                    
                    -- Grip boss when knocked
                    if bosshrp.Parent:FindFirstChild("Settings"):FindFirstChild("Knocked").Value == true then
                        plr.Character.HumanoidRootPart.CFrame = bosshrp.CFrame
                        local args = {
                            [1] = "Grip"
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    end
                else
                    killing = false
                end
            end)
            
            while killing == true do
                wait()
            end
            
            if tweening then             
                tweening:Disconnect()
            end

            print("[Christmas Farm] ========== BOSS DIED ==========")
            print("[Christmas Farm] Boss HumanoidRootPart:", bosshrp)
            print("[Christmas Farm] Boss Parent:", bosshrp and bosshrp.Parent or "nil")
            if bosshrp and bosshrp.Parent then
                print("[Christmas Farm] Boss Name:", bosshrp.Parent.Name)
            end
            
            if christmasfarmactive.Value == false then 
                print("[Christmas Farm] Farm disabled, skipping Candy Cane pickup")
                return 
            end

            print("[Christmas Farm] Setting up Candy Cane pickup...")

            -- Listen for NEW Candy Canes that spawn after boss death
            if candypickupconnection then
                print("[Christmas Farm] Disconnecting old connection")
                candypickupconnection:Disconnect()
            end
            
            print("[Christmas Farm] Setting up ChildAdded connection for Candy Canes")
            candypickupconnection = workspace.ChildAdded:Connect(function(newthing)
                local success, err = pcall(function()
                    if not newthing then 
                        print("[Christmas Farm] ChildAdded: newthing is nil")
                        return 
                    end
                    
                    print("[Christmas Farm] ChildAdded detected:", newthing.Name, "| Type:", newthing.ClassName)
                    
                    -- Check if it's a new Candy Cane (not in existing list)
                    if newthing.Name == "Candy Cane" then
                        print("[Christmas Farm] Found Candy Cane! Checking if it's new...")
                        if existingCandyCanes[newthing] then
                            print("[Christmas Farm] Candy Cane is OLD (in existing list), ignoring")
                            return
                        end
                        
                        print("[Christmas Farm] Candy Cane is NEW! Checking for ItemDetector...")
                        local itemDetector = newthing:FindFirstChild("ItemDetector")
                        if itemDetector then
                            print("[Christmas Farm] Found ItemDetector! Adding to pickup list")
                            if not table.find(newCandyCanes, newthing) then
                                table.insert(newCandyCanes, newthing)
                                print("[Christmas Farm] Added Candy Cane to list. Total new Candy Canes:", #newCandyCanes)
                            else
                                print("[Christmas Farm] Candy Cane already in list, skipping")
                            end
                        else
                            print("[Christmas Farm] WARNING: Candy Cane has NO ItemDetector!")
                            -- Check what children it has
                            local children = {}
                            for _, child in pairs(newthing:GetChildren()) do
                                table.insert(children, child.Name .. " (" .. child.ClassName .. ")")
                            end
                            print("[Christmas Farm] Candy Cane children:", table.concat(children, ", "))
                        end
                    end
                end)
                
                if not success then
                    warn("[Christmas Farm] ERROR in ChildAdded callback:", err)
                end
            end)
            print("[Christmas Farm] ChildAdded connection set up successfully")

            -- Wait a moment for Candy Canes to spawn
            print("[Christmas Farm] Waiting 1.5 seconds for Candy Canes to spawn...")
            wait(1.5)
            
            -- Also check for any Candy Canes that already spawned
            print("[Christmas Farm] Checking workspace for already-spawned Candy Canes...")
            local foundCount = 0
            for _, v in pairs(workspace:GetChildren()) do
                if v and v.Name == "Candy Cane" then
                    if existingCandyCanes[v] then
                        print("[Christmas Farm] Found existing Candy Cane (old), ignoring")
                    else
                        print("[Christmas Farm] Found new Candy Cane in workspace!")
                        local itemDetector = v:FindFirstChild("ItemDetector")
                        if itemDetector then
                            print("[Christmas Farm] Has ItemDetector, adding to list")
                            if not table.find(newCandyCanes, v) then
                                table.insert(newCandyCanes, v)
                                foundCount = foundCount + 1
                            end
                        else
                            print("[Christmas Farm] WARNING: No ItemDetector found!")
                            local children = {}
                            for _, child in pairs(v:GetChildren()) do
                                table.insert(children, child.Name .. " (" .. child.ClassName .. ")")
                            end
                            print("[Christmas Farm] Children:", table.concat(children, ", "))
                        end
                    end
                end
            end
            print("[Christmas Farm] Found", foundCount, "new Candy Canes in workspace check")
            print("[Christmas Farm] Total new Candy Canes to pickup:", #newCandyCanes)

            if #newCandyCanes == 0 then
                warn("[Christmas Farm] WARNING: No new Candy Canes found! Checking all Candy Canes in workspace...")
                local allCandyCanes = {}
                for _, v in pairs(workspace:GetDescendants()) do
                    if v and v.Name == "Candy Cane" then
                        table.insert(allCandyCanes, v)
                    end
                end
                print("[Christmas Farm] Total Candy Canes in workspace:", #allCandyCanes)
                for i, v in ipairs(allCandyCanes) do
                    print("[Christmas Farm] Candy Cane", i, ":", v, "| Parent:", v.Parent and v.Parent.Name or "nil")
                    local itemDetector = v:FindFirstChild("ItemDetector")
                    print("[Christmas Farm]   - Has ItemDetector:", itemDetector ~= nil)
                    if itemDetector then
                        print("[Christmas Farm]   - ItemDetector MaxActivationDistance:", itemDetector.MaxActivationDistance)
                    end
                end
            end

            -- Pickup loop for NEW Candy Canes
            local clickedCandyCanes = {}
            local startTime = tick()
            print("[Christmas Farm] Starting pickup loop for", #newCandyCanes, "Candy Canes...")
            
            while (tick() - startTime < 15) and christmasfarmactive.Value do
                if #newCandyCanes == 0 then
                    print("[Christmas Farm] No more Candy Canes to pickup!")
                    break
                end
                
                for i = #newCandyCanes, 1, -1 do
                    local candyCane = newCandyCanes[i]
                    
                    -- Skip if already clicked or doesn't exist
                    if clickedCandyCanes[candyCane] then
                        print("[Christmas Farm] Candy Cane already clicked, removing from list")
                        table.remove(newCandyCanes, i)
                    elseif not candyCane then
                        print("[Christmas Farm] Candy Cane is nil, removing from list")
                        table.remove(newCandyCanes, i)
                    elseif not candyCane:IsDescendantOf(workspace) then
                        print("[Christmas Farm] Candy Cane no longer in workspace, removing from list")
                        table.remove(newCandyCanes, i)
                    else
                        local itemDetector = candyCane:FindFirstChild("ItemDetector")
                        if not itemDetector then
                            warn("[Christmas Farm] WARNING: Candy Cane has no ItemDetector! Removing from list")
                            table.remove(newCandyCanes, i)
                        else
                            -- Teleport close to the Candy Cane (within 12 studs for ItemDetector)
                            if not plr.Character then
                                warn("[Christmas Farm] ERROR: Player character is nil!")
                            elseif not plr.Character:FindFirstChild("HumanoidRootPart") then
                                warn("[Christmas Farm] ERROR: HumanoidRootPart not found!")
                            else
                                -- Try multiple methods to get the position
                                local candyPos = nil
                                local candyCFrame = nil
                                
                                -- Method 1: Check if Candy Cane itself is a BasePart
                                if candyCane:IsA("BasePart") then
                                    candyPos = candyCane
                                    candyCFrame = candyCane.CFrame
                                    print("[Christmas Farm] Candy Cane is a BasePart")
                                -- Method 2: Check if it's a Model with PrimaryPart
                                elseif candyCane:IsA("Model") then
                                    if candyCane.PrimaryPart then
                                        candyPos = candyCane.PrimaryPart
                                        candyCFrame = candyCane:GetPrimaryPartCFrame()
                                        print("[Christmas Farm] Using Model PrimaryPart")
                                    else
                                        -- Method 3: Find first BasePart in the model
                                        candyPos = candyCane:FindFirstChildOfClass("BasePart")
                                        if candyPos then
                                            candyCFrame = candyPos.CFrame
                                            print("[Christmas Farm] Using first BasePart in Model")
                                        end
                                    end
                                -- Method 4: ItemDetector's parent might be the part
                                elseif itemDetector.Parent and itemDetector.Parent:IsA("BasePart") then
                                    candyPos = itemDetector.Parent
                                    candyCFrame = itemDetector.Parent.CFrame
                                    print("[Christmas Farm] Using ItemDetector's parent BasePart")
                                end
                                
                                if not candyPos or not candyCFrame then
                                    warn("[Christmas Farm] ERROR: Could not find position for Candy Cane!")
                                    print("[Christmas Farm] Candy Cane type:", candyCane.ClassName)
                                    print("[Christmas Farm] Candy Cane children:")
                                    for _, child in pairs(candyCane:GetChildren()) do
                                        print("[Christmas Farm]   -", child.Name, "(" .. child.ClassName .. ")")
                                    end
                                    table.remove(newCandyCanes, i)
                                else
                                    local distance = (plr.Character.HumanoidRootPart.Position - candyPos.Position).Magnitude
                                    print("[Christmas Farm] Candy Cane distance:", math.floor(distance), "studs")
                                    
                                    -- If too far, teleport closer (within 10 studs to be safe)
                                    if distance > 10 then
                                        print("[Christmas Farm] Too far! Teleporting closer...")
                                        local teleportCFrame = candyCFrame * CFrame.new(0, 0, -8)
                                        plr.Character.HumanoidRootPart.CFrame = teleportCFrame
                                        task.wait(0.2)
                                        -- Recalculate distance
                                        distance = (plr.Character.HumanoidRootPart.Position - candyPos.Position).Magnitude
                                        print("[Christmas Farm] New distance after teleport:", math.floor(distance), "studs")
                                    end
                                    
                                    if distance <= 12 then
                                        print("[Christmas Farm] Within range! Clicking ItemDetector...")
                                        local success, err = pcall(function()
                                            fireclickdetector(itemDetector)
                                        end)
                                        
                                        if success then
                                            print("[Christmas Farm] Successfully clicked ItemDetector!")
                                            clickedCandyCanes[candyCane] = true
                                            table.remove(newCandyCanes, i)
                                        else
                                            warn("[Christmas Farm] ERROR clicking ItemDetector:", err)
                                        end
                                        task.wait(0.1)
                                    else
                                        print("[Christmas Farm] Still too far after teleport:", math.floor(distance), "studs (max 12)")
                                    end
                                end
                            end
                        end
                    end
                end
                
                -- If all new Candy Canes are clicked, we're done
                if #newCandyCanes == 0 then
                    print("[Christmas Farm] All Candy Canes picked up!")
                    break
                end
                
                task.wait(0.1)
            end
            
            print("[Christmas Farm] Pickup loop finished. Remaining Candy Canes:", #newCandyCanes)
            
            -- Disconnect the connection after pickup is done
            if candypickupconnection then
                print("[Christmas Farm] Disconnecting ChildAdded connection")
                candypickupconnection:Disconnect()
                candypickupconnection = nil
            end

            -- Check if all candies are picked up and serverhop if enabled and not in combat
            if #newCandyCanes == 0 and serverhopnoboss then
                print("[Christmas Farm] All candies picked up! Checking combat status...")
                
                -- Check if player is in combat
                local inCombat = false
                if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("CombatCount") then
                    if RS.Settings[user].CombatCount.Value > 3 then
                        inCombat = true
                        print("[Christmas Farm] Player is in combat (CombatCount:", RS.Settings[user].CombatCount.Value, "), skipping serverhop")
                    else
                        print("[Christmas Farm] Player is NOT in combat (CombatCount:", RS.Settings[user].CombatCount.Value, ")")
                    end
                else
                    print("[Christmas Farm] CombatCount not found, assuming not in combat")
                end
                
                if not inCombat then
                    print("[Christmas Farm] Serverhopping immediately after candy pickup...")
                    features.TeleportRandomServer()
                    return
                end
            end

            features.gotosafespot()
        end

        -- Main farm loop
        local lookingforbosscounter = 0
        local playerDetected = false -- Flag to stop farming when player detected
        
        -- Continuous player detection in separate thread
        spawn(function()
            while christmasfarmactive.Value and not playerDetected do
                task.wait(0.5) -- Check every 0.5 seconds
                
                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                    -- Skip if character not loaded
                    continue
                end
                
                local hrp = plr.Character.HumanoidRootPart
                local playerPos = hrp.Position
                
                -- Check for nearby players (within 100 studs)
                local nearbyPlayer = false
                local nearbyPlayerName = nil
                local nearbyPlayerDistance = nil
                
                local success, err = pcall(function()
                    local allPlayers = Players:GetPlayers()
                    
                    for _, otherPlayer in pairs(allPlayers) do
                        if otherPlayer ~= plr then
                            if not otherPlayer.Character then
                                continue
                            elseif not otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                continue
                            else
                                local otherHrp = otherPlayer.Character.HumanoidRootPart
                                local distance = (playerPos - otherHrp.Position).Magnitude
                                
                                if distance <= 100 then
                                    nearbyPlayer = true
                                    nearbyPlayerName = otherPlayer.Name
                                    nearbyPlayerDistance = distance
                                    print("[Christmas Farm] *** PLAYER DETECTED WITHIN 100 STUDS ***")
                                    print("[Christmas Farm] Player:", otherPlayer.Name, "Distance:", math.floor(distance), "studs")
                                    break
                                end
                            end
                        end
                    end
                end)
                
                if not success then
                    warn("[Christmas Farm] ERROR checking for nearby players:", err)
                end
                
                -- If nearby player detected, teleport to safe spot immediately
                if nearbyPlayer then
                    playerDetected = true -- Stop main loop from continuing
                    
                    print("[Christmas Farm] ========== PLAYER DETECTED ==========")
                    print("[Christmas Farm] Player Name:", nearbyPlayerName)
                    print("[Christmas Farm] Distance:", math.floor(nearbyPlayerDistance), "studs")
                    print("[Christmas Farm] Stopping farm and teleporting to safe spot...")
                    
                    local teleportSuccess, teleportErr = pcall(function()
                        features.gotosafespot()
                    end)
                    
                    if not teleportSuccess then
                        warn("[Christmas Farm] ERROR teleporting to safe spot:", teleportErr)
                    else
                        print("[Christmas Farm] Successfully teleported to safe spot")
                    end
                    
                    -- Wait until out of combat before server hopping
                    print("[Christmas Farm] Waiting to be out of combat before serverhopping...")
                    local waitStartTime = tick()
                    local maxWaitTime = 30 -- Maximum 30 seconds wait
                    
                    while tick() - waitStartTime < maxWaitTime and christmasfarmactive.Value do
                        local outOfCombat = false
                        local combatCheckSuccess, combatCheckErr = pcall(function()
                            if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("CombatCount") then
                                local combatCount = RS.Settings[user].CombatCount.Value
                                if combatCount <= 3 then
                                    outOfCombat = true
                                end
                            else
                                -- If CombatCount doesn't exist, assume out of combat
                                outOfCombat = true
                            end
                        end)
                        
                        if not combatCheckSuccess then
                            warn("[Christmas Farm] ERROR checking combat status:", combatCheckErr)
                            -- Assume out of combat on error
                            outOfCombat = true
                        end
                        
                        if outOfCombat then
                            print("[Christmas Farm] Out of combat! Serverhopping...")
                            task.wait(0.5)
                            
                            local hopSuccess, hopErr = pcall(function()
                                features.TeleportRandomServer()
                            end)
                            
                            if not hopSuccess then
                                warn("[Christmas Farm] ERROR serverhopping:", hopErr)
                            else
                                print("[Christmas Farm] Serverhopping...")
                            end
                            
                            return
                        end
                        
                        task.wait(0.5)
                    end
                    
                    -- If we've waited too long, server hop anyway
                    warn("[Christmas Farm] Waited too long for combat to end, serverhopping anyway...")
                    local hopSuccess, hopErr = pcall(function()
                        features.TeleportRandomServer()
                    end)
                    
                    if not hopSuccess then
                        warn("[Christmas Farm] ERROR serverhopping after timeout:", hopErr)
                    end
                    
                    return
                end
            end
        end)
        
        while christmasfarmactive.Value and not playerDetected do
            wait()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local bossthere, bosshrp, bossname = checkbossstatus()
                if bossthere and bosshrp then
                    lookingforbosscounter = 0
                    finishboss(bosshrp)
                elseif serverhopnoboss == true then
                    lookingforbosscounter = lookingforbosscounter + 1
                    if lookingforbosscounter > 10 then
                        print("[Christmas Farm] No boss found after 10 attempts, serverhopping...")
                        features.TeleportRandomServer()
                        return
                    end
                end
            end
        end
        
        -- If player was detected, the detection thread handles teleport/serverhop
        if playerDetected then
            print("[Christmas Farm] Farm stopped due to nearby player detection")
            return
        end

        -- Cleanup
        if candypickupconnection then
            candypickupconnection:Disconnect()
        end

        NoFallDammage.Value = false
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack({"EndBlock"}))
    end
end

features.CheckNotiAndSend = function(reason, message)
    if selectednotis ~= nil and Webhook_URL ~= nil then
        for i, v in pairs(selectednotis) do
            if v == reason then
                sendmessage(message)
            end
        end
    end
end

features.Treehop = function()
    if treehopping.Value then
        features.HandleNotLoadedIn()
        local char = plr.Character
        local spawned = false
        local pickuptable = {}

        NoFallDammage.Value = true

        waiting = workspace.ChildAdded:Connect(function(newchild)
            if newchild:FindFirstChild("ID") then
                spawned = true
                print(newchild.Name)
                for i, v in selectedfruits do
                    if v == "All" then
                        if newchild.Name == "Chakra Fruit" or newchild.Name == "Life Up Fruit" or newchild.Name == "Fruit Of Forgetfulness" or newchild.Name == "Alluring Apple" or newchild.Name == "Apple" or newchild.Name == "Orange" or newchild.Name == "Banana" or newchild.Name == "Pear" or newchild.Name == "Mango" then
                            table.insert(pickuptable,newchild)
                        end
                    elseif v == "Life / Forgetfulness Fruit" then
                        if newchild.Name == "Life Up Fruit" or newchild.Name == "Fruit Of Forgetfulness" then
                            table.insert(pickuptable, newchild)
                        end
                    elseif newchild.Name == v then
                        table.insert(pickuptable, newchild)
                    end
                end
            end
        end)

        local function nocliploop()
            for i, v in pairs(plr.Character:GetChildren()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
        noclippinghop = RunService.Stepped:Connect(nocliploop)

        while treehopping.Value do
            wait()
            if selectedfruits[1] == nil then continue end
            for i ,v in pairs(workspace:GetDescendants()) do
                if v.Name == "FruitType" then
                    if treehopping.Value then
                        if onlyhopselectedfruittypes then
                            local found = false
                            for _, frtype in pairs(selectedfruits) do
                                if v.Value == frtype then
                                    found = true
                                    break
                                end
                            end
                            if not found then
                                continue
                            end
                        end

                        if v:GetAttribute("check") and v:GetAttribute("check") == true then
                        else


                            char.HumanoidRootPart.CFrame = v.Parent:FindFirstChild("MainBranch").CFrame

                            local startTime = os.clock()

                            while os.clock() - startTime < 12 and spawned == false and treehopping.Value == true do --timeout
                                wait()
                            end

                            if spawned == false then
                                continue
                            end
                            
                            if next(pickuptable) ~= nil and treehopping.Value == true then
                                local bv = Instance.new("BodyVelocity")
                                bv.Velocity = Vector3.new(0, 0, 0)
                                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                                bv.Parent = plr.Character:FindFirstChild("HumanoidRootPart")

                                for ind, val in pickuptable do
                                    if val:FindFirstChild("ID") then
                                        if val:FindFirstChild("ID").Value then
                                            plr.Character.HumanoidRootPart.CFrame = val.CFrame * CFrame.new(0,-6,0) -- go below fruit

                                            while val and val:IsDescendantOf(workspace) do
                                                local args = {
                                                    [1] = "PickUp",
                                                    [2] = val:FindFirstChild("ID").Value
                                                }
                                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                                            wait()
                                            end
                                        end
                                    end
                                end
                                table.clear(pickuptable)
                                bv:Destroy()
                                wait()
                            end

                            v:SetAttribute("check",true)
                            spawned = false
                        end
                    else
                        break
                    end
                end
            end
            if treehopping.Value then
                for i,v in pairs(workspace:GetDescendants()) do
                    if v.Name == "FruitType" then
                        if v:GetAttribute("check") then
                            v:SetAttribute("check", false)
                        end
                    end
                end
            end
            wait()
        end
        noclippinghop:Disconnect()
        waiting:Disconnect()
        NoFallDammage.Value = false
    end
end

features.StealDroppedItems = function()
    if stealingitems then

        local function pickupitem(item)
            local startTime = tick()
            local duration = 30
            local tries = 0

            local function doTouch()
                if item:IsDescendantOf(workspace) then
                    firetouchinterest(plr.Character.HumanoidRootPart, item, true)
                end
                if item:IsDescendantOf(workspace) then
                    firetouchinterest(plr.Character.HumanoidRootPart, item, false)
                end
            end

            repeat
                wait()
            until item:FindFirstChild("ItemTouch")
            local itemcf = item.CFrame

            local heartbeatConnection
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                if not item or item.Parent ~= workspace or (tick() - startTime) >= duration then
                    if heartbeatConnection then
                        heartbeatConnection:Disconnect()
                    end
                    return
                end

                if stealingitemswithtp then
                    Teleport(item.CFrame + Vector3.new(0, 23, 0),true)
                    wait(0.18)
                    doTouch()
                    warn("touched")
                else
                    doTouch()
                    warn("2nd touched")
                end

                tries += 1
            end)
        end

        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "ItemOwner" then
                local gui = v.Parent:FindFirstChild("GUI")
                local itemText = gui and gui:FindFirstChild("ItemName")
                local ryoText = gui and gui:FindFirstChild("Ryo")
                local itemname = itemText and itemText.Text ~= "" and itemText.Text or (ryoText and ryoText.Text .. " Ryo" or "Unknown")

                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and v.Parent:WaitForChild(user,1) then
                    pickupitem(v.Parent)
                    Notify(itemname, "was stolen.", 2, "venetian-mask")
                end

                wait()
            end
        end

        stealconnect = workspace.ChildAdded:Connect(function(chi)
            wait(0.15)
            if chi:FindFirstChild("ItemOwner") and chi:FindFirstChild("GUI") then
                local gui = chi:FindFirstChild("GUI")
                local itemText = gui:FindFirstChild("ItemName")
                local ryoText = gui:FindFirstChild("Ryo")
                local itemname = itemText and itemText.Text ~= "" and itemText.Text or (ryoText and ryoText.Text .. " Ryo" or "Unknown")
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and chi:WaitForChild(user,1) then
                    pickupitem(chi)
                    Notify(itemname, "was stolen.", 2, "venetian-mask")
                end
            end
        end)

    else
        if stealconnect and stealconnect.Connected then
            stealconnect:Disconnect()
        end
    end
end

local startrobcf = nil

features.StealDroppedItemsAdv = function()

    if stealingitemsadv then

        if TargetPlayer == nil then
            Notify("Missing requirements..", "Select Target in Main Tab", 3, "info")
            return
        end

        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            startrobcf = plr.Character.HumanoidRootPart.CFrame
        end

        targetstealconn = RunService.RenderStepped:Connect(function()
            local myChar = plr.Character
            local targetChar = TargetPlayer and TargetPlayer.Character

            if myChar and targetChar then
                local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

                if myHRP and targetHRP then
                    myHRP.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, -23.2, 0))
                end
            end
        end)

    else

        if targetstealconn and targetstealconn.Connected then
            targetstealconn:Disconnect()
        end

        if startrobcf then
            Teleport(startrobcf)
        end
    end
end

features.HitboxExtend = function()
    if not hitboxextending then return end

    local extendingMoves = {
        "Lion's Barrage",
        "Cleave Rush",
        "Dynamic Entry",
        "Rasengan",
        "Rasengan Barrage",
        "Fire Seal",
        "Thrusting Strike",
        "Water Prison",
        "Chidori",
        "Primary Lotus",
        "Wood Seal"
    }

    local heartbeatConn
    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not hitboxextending then
            heartbeatConn:Disconnect()
            return
        end

        if not plr.Character then return end
        local plrHRP = plr.Character:FindFirstChild("HumanoidRootPart")
        if not plrHRP then return end

        local hitradius = hitboxstud or 8
        if RS.Settings and RS.Settings[user] and RS.Settings[user].CurrentSkill then
            local currentSkill = RS.Settings[user].CurrentSkill.Value

            local validMove = false
            for _, move in pairs(extendingMoves) do
                if move == currentSkill then
                    validMove = true
                    break
                end
            end
            if not validMove then return end
            local usedMove = currentSkill

            if usedMove == "Lion's Barrage" or usedMove == "Dynamic Entry" or usedMove == "Thrusting Strike" or usedMove == "Primary Lotus" or usedMove == "Cleave Rush" then
                for _, v in pairs(game.Workspace.Debris:GetChildren()) do
                    if usedMove ~= RS.Settings[user].CurrentSkill.Value then break end
                    if v.Name == "Hitbox" and v:FindFirstChild("TouchInterest") then
                        for _, otherplr in pairs(game.Players:GetPlayers()) do
                            if usedMove ~= RS.Settings[user].CurrentSkill.Value then break end
                            if otherplr ~= plr and otherplr.Character then
                                local otherHRP = otherplr.Character:FindFirstChild("HumanoidRootPart")
                                if otherHRP then
                                    local distance = (plrHRP.Position - otherHRP.Position).Magnitude
                                    if distance <= hitradius then
                                        firetouchinterest(v, otherHRP, true)
                                        firetouchinterest(v, otherHRP, false)
                                    end
                                end
                            end
                        end
                    end
                end
            else
                for _, xotherplr in pairs(game.Players:GetPlayers()) do
                    if usedMove ~= RS.Settings[user].CurrentSkill.Value then break end
                    if xotherplr ~= plr and xotherplr.Character then
                        local otherHRP = xotherplr.Character:FindFirstChild("HumanoidRootPart")
                        if otherHRP then
                            local distance = (plrHRP.Position - otherHRP.Position).Magnitude
                            if distance <= hitradius then
                                if usedMove ~= "Rasengan Barrage" then
                                    if plr.Character:FindFirstChild(usedMove) then
                                        firetouchinterest(plr.Character[usedMove], otherHRP, true)
                                        firetouchinterest(plr.Character[usedMove], otherHRP, false)
                                    end
                                else
                                    if plr.Character:FindFirstChild("RasenganLeft") then
                                        firetouchinterest(plr.Character.RasenganLeft, otherHRP, true)
                                        firetouchinterest(plr.Character.RasenganLeft, otherHRP, false)
                                    end
                                    if plr.Character:FindFirstChild("RasenganRight") then
                                        firetouchinterest(plr.Character.RasenganRight, otherHRP, true)
                                        firetouchinterest(plr.Character.RasenganRight, otherHRP, false)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

features.UseBasket = function()
    while AutoUsingBasket do
        local playerdata = game:GetService("ReplicatedStorage")
            :WaitForChild("Events")
            :WaitForChild("DataFunction")
            :InvokeServer("GetData")

        local foundbasket = false
        local candyamount = 0

        for _, entry in pairs(playerdata.Inventory or {}) do
            if entry.Item == "Treat Basket" then
                foundbasket = true
                candyamount = entry.Data and entry.Data.Candies or 0
                break
            end
        end

        for _, entry in pairs(playerdata.Loadout or {}) do
            if entry.Item == "Treat Basket" then
                foundbasket = true
                candyamount = entry.Data and entry.Data.Candies or 0
                break
            end
        end

        if foundbasket and candyamount < 8 then
            local ind = 1
            repeat
                if workspace:FindFirstChild(NPCs[ind]) and workspace:FindFirstChild(NPCs[ind]):FindFirstChild("HumanoidRootPart") then
                    local args = {
                        "trickOrTreat",
                        workspace:FindFirstChild(NPCs[ind]).HumanoidRootPart
                    }
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Events")
                        :WaitForChild("DataFunction")
                        :InvokeServer(unpack(args))
                end

                ind += 1
                task.wait(0.2)

                local playerdata = game:GetService("ReplicatedStorage")
                    :WaitForChild("Events")
                    :WaitForChild("DataFunction")
                    :InvokeServer("GetData")

                for _, entry in pairs(playerdata.Inventory or {}) do
                    if entry.Item == "Treat Basket" then
                        candyamount = entry.Data and entry.Data.Candies or 0
                        break
                    end
                end

            until candyamount >= 8 or ind > #NPCs
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack({"Item","Selected","Treat Basket"}))
            wait(0.1)
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack({"Consumed","Treat Basket"}))
        elseif foundbasket and candyamount >= 8 then
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack({"Item","Selected","Treat Basket"}))
            wait(0.1)
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack({"Consumed","Treat Basket"}))
        end


        task.wait(5)
    end
end


-- Candy farming feature removed
features.FarmCandy = function()
    return -- Disabled
end

-- Auto Missions System
features.AutoMissions = function()
    if not missionfarmactive.Value then
        return
    end
    
    features.HandleNotLoadedIn()
    
    -- Get player's village and weapon
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remote = replicatedStorage:WaitForChild("Events"):WaitForChild("DataFunction")
    local playerdata = remote:InvokeServer("GetData")
    local playerVillage = playerdata["Village"]
    local weapontoautoequip = playerdata["CurrentWeapon"]
    
    if not playerVillage then
        warn("[Auto Missions] Could not get player village")
        return
    end
    
    -- Find Mission Board for player's village
    local missionBoards = workspace:FindFirstChild("Mission Boards")
    if not missionBoards then
        warn("[Auto Missions] Mission Boards not found")
        return
    end
    
    local villageMissionBoard = nil
    for _, board in pairs(missionBoards:GetChildren()) do
        if board.Name == "Mission Board" and board:GetAttribute("Village") == playerVillage then
            villageMissionBoard = board
            break
        end
    end
    
    if not villageMissionBoard then
        warn("[Auto Missions] Mission Board for village", playerVillage, "not found")
        return
    end
    
    -- Find available missions matching selected types
    local availableMissions = {}
    for _, mission in pairs(villageMissionBoard:GetChildren()) do
        if mission.Name == "Mission" then
            -- Try different possible attribute names
            local missionType = mission:GetAttribute("MissionType") or 
                               mission:GetAttribute("Type") or 
                               mission:GetAttribute("Mission") or
                               mission:GetAttribute("Name")
            
            -- Also check if mission type is in the mission's name or other properties
            if not missionType then
                -- Check all attributes
                for attrName, attrValue in pairs(mission:GetAttributes()) do
                    if type(attrValue) == "string" and (attrName:lower():find("mission") or attrName:lower():find("type")) then
                        missionType = attrValue
                        break
                    end
                end
            end
            
            if missionType and #selectedMissionTypes > 0 then
                -- Check if mission type matches any selected type (case-insensitive partial match)
                for _, selectedType in pairs(selectedMissionTypes) do
                    if missionType:lower():find(selectedType:lower()) or selectedType:lower():find(missionType:lower()) then
                        table.insert(availableMissions, mission)
                        break
                    end
                end
            end
        end
    end
    
    if #availableMissions == 0 then
        warn("[Auto Missions] No available missions of selected types")
        task.wait(2)
        return
    end
    
    -- Select a random mission from available ones
    local selectedMission = availableMissions[math.random(1, #availableMissions)]
    local missionType = selectedMission:GetAttribute("MissionType") or 
                       selectedMission:GetAttribute("Type") or 
                       selectedMission:GetAttribute("Mission") or
                       selectedMission:GetAttribute("Name")
    
    -- Teleport to mission board before clicking (ClickDetectors have range)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        -- Try to find a part close to the selected mission
        local missionPart = selectedMission:FindFirstChildOfClass("BasePart")
        if not missionPart then
            -- If mission has no part, find the closest part on the board
            local boardParts = {}
            for _, part in pairs(villageMissionBoard:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(boardParts, part)
                end
            end
            if #boardParts > 0 then
                missionPart = boardParts[1]
            end
        end
        
        if missionPart then
            -- Teleport close to the mission (a few studs in front)
            local teleportCFrame = missionPart.CFrame * CFrame.new(0, 0, -5)
            Teleport(teleportCFrame)
            print("[Auto Missions] Teleported to mission board near mission")
            task.wait(0.5)
        else
            warn("[Auto Missions] Could not find part to teleport to on mission board")
        end
    end
    
    -- Click the mission's ClickDetector
    local clickDetector = selectedMission:FindFirstChildOfClass("ClickDetector")
    if not clickDetector then
        warn("[Auto Missions] No ClickDetector found on mission")
        task.wait(2)
        return
    end
    
    -- Fire the ClickDetector
    fireclickdetector(clickDetector)
    print("[Auto Missions] Claimed mission:", missionType)
    task.wait(1)
    
    -- Remember our position before claiming mission to find our spawner
    local myPositionBeforeClaim = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart.Position
    
    -- Check if this is a Corrupted Point mission
    local isCorruptedPoint = false
    if missionType and (missionType:lower():find("corrupted") or missionType:lower():find("point")) then
        isCorruptedPoint = true
    end
    
    -- Setup auto M1 and auto equip weapon (only if toggles are enabled)
    local DataEvent = RS:WaitForChild("Events"):WaitForChild("DataEvent")
    local autoM1Connection = nil
    
    if (missionautoequip or missionautom1) and weapontoautoequip then
        autoM1Connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not missionfarmactive.Value then
                if autoM1Connection then
                    autoM1Connection:Disconnect()
                    autoM1Connection = nil
                end
                return
            end
            
            if RS.Settings:FindFirstChild(user) and RS.Settings[user]:FindFirstChild("CombatCount") then
                if missionautoequip then
                    if RS.Settings[user]:FindFirstChild("CurrentWeapon") then
                        if RS.Settings[user]:FindFirstChild("CurrentWeapon").Value ~= "Fist" and RS.Settings[user]:FindFirstChild("CurrentWeapon").Value ~= "Tai" then
                            DataEvent:FireServer("Item","Unselected", weapontoautoequip)
                        end
                    end
                end
                
                if missionautom1 and RS.Settings[user].CombatCount.Value > 3 then
                    DataEvent:FireServer("Item", "Selected", weapontoautoequip)
                    DataEvent:FireServer("Item", "Unselected", weapontoautoequip)
                end
            end
        end)
    end
    
    -- Handle Corrupted Point mission
    if isCorruptedPoint then
        print("[Auto Missions] Corrupted Point mission - waiting for spawn...")
        
        -- Wait for CorruptedPoint to spawn
        local corruptedPoint = nil
        local maxWaitTime = 30
        local waitTime = 0
        
        while waitTime < maxWaitTime and missionfarmactive.Value do
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name == "CorruptedPoint" then
                    corruptedPoint = obj
                    break
                end
            end
            
            if corruptedPoint then
                break
            end
            
            task.wait(0.5)
            waitTime = waitTime + 0.5
        end
        
        if not corruptedPoint then
            warn("[Auto Missions] CorruptedPoint did not spawn in time")
            if autoM1Connection then
                autoM1Connection:Disconnect()
            end
            task.wait(2)
            return
        end
        
        print("[Auto Missions] Found CorruptedPoint - farming under map")
        
        -- Farm CorruptedPoint under the map
        local corruptedMain = corruptedPoint:FindFirstChild("Main")
        if corruptedMain then
            while missionfarmactive.Value and corruptedPoint and corruptedPoint.Parent do
                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                    task.wait(1)
                    return
                end
                
                local targetPos = corruptedMain.Position
                -- Teleport under the map at Y = -147
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.X, -147, targetPos.Z)
                
                task.wait()
            end
        end
        
        print("[Auto Missions] CorruptedPoint destroyed, mission complete")
        if autoM1Connection then
            autoM1Connection:Disconnect()
        end
        task.wait(2)
        return
    end
    
    -- For other missions, find the spawner location
    local missionLocations = workspace:FindFirstChild("Debris")
    if not missionLocations then
        warn("[Auto Missions] Debris not found")
        if autoM1Connection then
            autoM1Connection:Disconnect()
        end
        return
    end
    
    local missionLocationsFolder = missionLocations:FindFirstChild("Mission Locations")
    if not missionLocationsFolder then
        warn("[Auto Missions] Mission Locations not found")
        if autoM1Connection then
            autoM1Connection:Disconnect()
        end
        return
    end
    
    local villageSpawners = missionLocationsFolder:FindFirstChild(playerVillage)
    if not villageSpawners then
        warn("[Auto Missions] Spawners for village", playerVillage, "not found")
        if autoM1Connection then
            autoM1Connection:Disconnect()
        end
        return
    end
    
    local spawnersFolder = villageSpawners:FindFirstChild("Spawners")
    if not spawnersFolder then
        warn("[Auto Missions] Spawners folder not found")
        if autoM1Connection then
            autoM1Connection:Disconnect()
        end
        return
    end
    
    -- Wait for spawner to appear after claiming mission (spawners are created after quest is claimed)
    local targetSpawner = nil
    local maxSpawnerWaitTime = 10
    local spawnerWaitTime = 0
    
    print("[Auto Missions] Waiting for spawner to appear after claiming mission...")
    while spawnerWaitTime < maxSpawnerWaitTime and missionfarmactive.Value do
        -- Find the spawner with MissionMarker that's closest to where we were when we claimed
        local closestSpawner = nil
        local closestDistance = math.huge
        
        for _, spawner in pairs(spawnersFolder:GetChildren()) do
            if spawner:IsA("BasePart") and spawner:FindFirstChild("MissionMarker") then
                -- If we have our position before claim, find the closest one
                if myPositionBeforeClaim then
                    local distance = (spawner.Position - myPositionBeforeClaim).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestSpawner = spawner
                    end
                else
                    -- If no position, just use the first one found
                    closestSpawner = spawner
                    break
                end
            end
        end
        
        if closestSpawner then
            targetSpawner = closestSpawner
            print("[Auto Missions] Found spawner at distance:", closestDistance)
            break
        end
        
        task.wait(0.5)
        spawnerWaitTime = spawnerWaitTime + 0.5
    end
    
    if not targetSpawner then
        warn("[Auto Missions] No spawner with MissionMarker found after waiting")
        if autoM1Connection then
            autoM1Connection:Disconnect()
        end
        task.wait(2)
        return
    end
    
    -- Teleport to spawner (NPCs spawn after teleporting to spawner)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        Teleport(targetSpawner.CFrame)
        print("[Auto Missions] Teleported to spawner - waiting for NPCs to spawn...")
        task.wait(2)
    end
    
    -- Wait for NPCs to spawn after teleporting to spawner (NPCs are created after teleporting)
    local spawnedNPCs = {}
    local maxWaitTime = 30
    local waitTime = 0
    
    while waitTime < maxWaitTime and missionfarmactive.Value do
        -- Check for spawned NPCs near the spawner (only check NPCs that belong to our mission)
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj ~= plr.Character then
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                local humanoid = obj:FindFirstChildOfClass("Humanoid")
                
                if hrp and humanoid and (hrp.Position - targetSpawner.Position).Magnitude < 50 then
                    local npcName = obj.Name
                    
                    -- Check if it's a mission NPC we should farm
                    if npcName:find("Manda") or npcName:find("Barbarit") or npcName:find("Bandit") or npcName:find("Cratos") or npcName:find("Boss") then
                        -- Check if we already have this NPC
                        local alreadyAdded = false
                        for _, existingNPC in pairs(spawnedNPCs) do
                            if existingNPC == obj then
                                alreadyAdded = true
                                break
                            end
                        end
                        
                        if not alreadyAdded then
                            table.insert(spawnedNPCs, obj)
                            print("[Auto Missions] Found NPC:", npcName)
                        end
                    end
                end
            end
        end
        
        if #spawnedNPCs > 0 then
            break
        end
        
        task.wait(0.5)
        waitTime = waitTime + 0.5
    end
    
    if #spawnedNPCs == 0 then
        warn("[Auto Missions] No NPCs spawned in time")
        if autoM1Connection then
            autoM1Connection:Disconnect()
        end
        task.wait(2)
        return
    end
    
    print("[Auto Missions] Starting to farm", #spawnedNPCs, "NPC(s)")
    
    -- Farm loop - continue until all NPCs are dead
    while missionfarmactive.Value do
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            task.wait(1)
            return
        end
        
        -- Remove dead NPCs from list
        for i = #spawnedNPCs, 1, -1 do
            local npc = spawnedNPCs[i]
            if not npc or not npc.Parent or not npc:FindFirstChild("Humanoid") or npc:FindFirstChild("Humanoid").Health <= 0 then
                table.remove(spawnedNPCs, i)
            end
        end
        
        -- Check if all NPCs are dead
        if #spawnedNPCs == 0 then
            print("[Auto Missions] All NPCs defeated, mission complete")
            break
        end
        
        -- Farm the first alive NPC
        local targetNPC = spawnedNPCs[1]
        if targetNPC and targetNPC.Parent and targetNPC:FindFirstChild("HumanoidRootPart") then
            local npcHrp = targetNPC:FindFirstChild("HumanoidRootPart")
            local npcName = targetNPC.Name
            
            -- For Manda, use same logic as boss farm (offset 35, with danger anim check)
            if npcName:find("Manda") then
                local extraoffset = 0
                local animator = targetNPC:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        -- Check for Manda's danger anim (same as boss farm)
                        if track.Animation.AnimationId == "rbxassetid://9954909571" then
                            if track.TimePosition > 0.4 and track.TimePosition < 2.7 then
                                extraoffset = 30
                                break
                            end
                        end
                    end
                end
                local abovePos = npcHrp.Position + Vector3.new(0, 35 + extraoffset, 0)
                local lookDown = CFrame.new(abovePos, npcHrp.Position)
                plr.Character.HumanoidRootPart.CFrame = lookDown
            elseif npcName:find("Barbarit") then
                -- Barbarit uses offset 12.5
                local abovePos = npcHrp.Position + Vector3.new(0, 12.5, 0)
                local lookDown = CFrame.new(abovePos, npcHrp.Position)
                plr.Character.HumanoidRootPart.CFrame = lookDown
            else
                -- For bandits, cratos, and bosses, hover lower (5 studs) so we can actually hit them
                local abovePos = npcHrp.Position + Vector3.new(0, 5, 0)
                local lookDown = CFrame.new(abovePos, npcHrp.Position)
                plr.Character.HumanoidRootPart.CFrame = lookDown
            end
        end
        
        task.wait()
    end
    
    -- Cleanup
    if autoM1Connection then
        autoM1Connection:Disconnect()
    end
    
    print("[Auto Missions] Mission complete, waiting before next mission...")
    task.wait(3)
end

features.EventNotify = function()
    local workspacespawn

    if EventNotifyactive then
        local GameNotifyCooldown = false

        local function GameNotify(Message)
            local guitemplate = plr.PlayerGui.ClientGui.Mainframe.Notification.LongMessageTemplate:Clone()
            guitemplate.Name = "Tact Event Notify"
            local guimessage = guitemplate:FindFirstChild("Message")

            guitemplate.Parent = plr.PlayerGui.ClientGui.Mainframe.Notification
            guimessage.TextColor3 = Color3.fromRGB(225, 225, 175)
            guimessage.Text = Message

            guimessage.TextTransparency = 0
            guitemplate.ImageTransparency = 0

            task.wait(4)

            guitemplate:Destroy()
            GameNotifyCooldown = false
        end

        local function GenerateMessage(object)
            local spawnlocations = {
                ["Permafrost Valley"]      = { Location = Vector3.new(-2984.0097, 12.5237, -2318.1809) },
                ["Sorythia"]               = { Location = Vector3.new(319.25, -22.1499, 64.5) },
                ["The Expanse"]            = { Location = Vector3.new(-273.3134, 27.3150, -1456.4433) },
                ["Windy Plains 1"]         = { Location = Vector3.new(-444.6890, -106.9384, -78.1904) },
                ["Permafrost Valley Gate"] = { Location = Vector3.new(-2938.8754, 45.9911, -3346.3627) },
                ["Artic Cove"]             = { Location = Vector3.new(-2369.5444, -141.2430, -2450.8283) },
                ["Fort Mello"]             = { Location = Vector3.new(-272.5840, 89.9466, -2252.1049) },
                ["Permafrost Valley Pit"]  = { Location = Vector3.new(-3693.1904, -11.8126, -2855.5026) },
                ["Chakra's Edge"]          = { Location = Vector3.new(2881.6650, -111.4496, -529.8105) },
                ["Durana Town"]            = { Location = Vector3.new(1689.4022, -130.8196, 963.8192) },
            }

            local nearestlocation = {Name = "", Magnitude = math.huge}

            if object.Name == "CorruptedPoint" then
                local innerPool = object:WaitForChild("InnerPool")
                for locationName, data in pairs(spawnlocations) do
                    local distance = (innerPool.Position - data.Location).Magnitude
                    if distance < nearestlocation.Magnitude then
                        nearestlocation.Name = locationName
                        nearestlocation.Magnitude = distance
                    end
                end
                return "A Corrupted Point spawned near " .. nearestlocation.Name

            else
                local npchrp = object:FindFirstChild("HumanoidRootPart")
                if not npchrp then 
                    return "An Event has started" 
                end

                for locationName, data in pairs(spawnlocations) do
                    local distance = (npchrp.Position - data.Location).Magnitude
                    if distance < nearestlocation.Magnitude then
                        nearestlocation.Name = locationName
                        nearestlocation.Magnitude = distance
                    end
                end
                return "An Event has started near " .. nearestlocation.Name
            end
        end

        workspacespawn = workspace.ChildAdded:Connect(function(obj)
            if obj.Name == "CorruptedPoint" then
                if ignorepoints then return end
                if GameNotifyCooldown then return end

                GameNotifyCooldown = true
                GameNotify(GenerateMessage(obj))

            else
                task.wait(1)
                if obj:FindFirstChild("WorldEvent") then
                    if obj:FindFirstChild("HumanoidRootPart") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "highlightevent"
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.OutlineColor = Color3.fromRGB(224, 57, 99)
                        highlight.FillColor = Color3.fromRGB(224, 57, 99)
                        highlight.FillTransparency = 0.7
                        highlight.Parent = obj
                    end

                    if GameNotifyCooldown then return end
                    GameNotifyCooldown = true
                    GameNotify(GenerateMessage(obj))
                end
            end
        end)
    else
        if workspacespawn then
            workspacespawn:Disconnect()
        end

        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "highlightevent" then
                v:Destroy()
            end
        end
    end
end

features.AutoParry = function()
    local RS = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Events = RS:WaitForChild("Events"):WaitForChild("DataFunction")

    local plr = Players.LocalPlayer
    local user = tostring(plr.UserId)
    local radius = 15
    local pingOffset = 0.1
    local globalParryCooldown = 0.25
    local lastParryTime = 0

    features._trackedCharacters = features._trackedCharacters or {}
    features._connections = features._connections or {}

    if autoparrying then

        local animationparrys = {
            ["rbxassetid://11330795390"] = {
                TimeLenghtDang = 0.47,
            },
        }

        local function triggerblock()
            local settingsplr = RS:WaitForChild("Settings"):FindFirstChild(user)
            local blockingValue = settingsplr:WaitForChild("Blocking")
            local canPerfectBlockValue = settingsplr:WaitForChild("canPerfectBlock")

            if settingsplr.MeleeCooldown.Value == false and settingsplr.Stunned.Value == false then
                Events:InvokeServer("Block")
                if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    plr.Character.Humanoid.WalkSpeed = 5
                end
            else
                return
            end

            while not blockingValue.Value do
                blockingValue.Changed:Wait()
            end

            while not canPerfectBlockValue.Value do
                canPerfectBlockValue.Changed:Wait()
            end

            while canPerfectBlockValue.Value do
                canPerfectBlockValue.Changed:Wait()
            end

            Events:InvokeServer("EndBlock")
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = 16
            end
        end

        local function trackCharacterAnimations(character)
            if features._trackedCharacters[character] then return end

            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end

            local connections = {}

            local function setupAnimator(animator)
                local animConn = animator.AnimationPlayed:Connect(function(track)
                    local animData = animationparrys[track.Animation.AnimationId]
                    if animData then
                        local triggered = false
                        local timeConn = track:GetPropertyChangedSignal("TimePosition"):Connect(function()
                            if not triggered and track.TimePosition >= animData.TimeLenghtDang - pingOffset then
                                if tick() - lastParryTime >= globalParryCooldown then
                                    triggered = true
                                    lastParryTime = tick()
                                    triggerblock()
                                end
                            end
                        end)

                        local stopConn = track.Stopped:Connect(function()
                            if timeConn then timeConn:Disconnect() end
                        end)

                        table.insert(connections, timeConn)
                        table.insert(connections, stopConn)
                    end
                end)

                table.insert(connections, animConn)
            end

            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                setupAnimator(animator)
            else
                local animatorConn = humanoid.ChildAdded:Connect(function(child)
                    if child:IsA("Animator") then
                        setupAnimator(child)
                    end
                end)
                table.insert(connections, animatorConn)
            end

            features._trackedCharacters[character] = {
                Connections = connections
            }
        end

        local function untrackCharacter(character)
            local info = features._trackedCharacters[character]
            if info then
                for _, conn in ipairs(info.Connections) do
                    if conn then conn:Disconnect() end
                end
                features._trackedCharacters[character] = nil
            end
        end

        local heartbeatConn = RunService.Heartbeat:Connect(function()
            if not autoparrying then return end

            local char = plr.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            local myPos = char.HumanoidRootPart.Position
            local currentlyInRadius = {}

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = player.Character.HumanoidRootPart.Position
                    local distance = (myPos - targetPos).Magnitude

                    if distance <= radius then
                        currentlyInRadius[player.Character] = true
                        trackCharacterAnimations(player.Character)
                    end
                end
            end

            for character in pairs(features._trackedCharacters) do
                if not currentlyInRadius[character] then
                    untrackCharacter(character)
                end
            end
        end)

        table.insert(features._connections, heartbeatConn)


    else

        for char, info in pairs(features._trackedCharacters) do
            for _, conn in ipairs(info.Connections or {}) do
                if conn then conn:Disconnect() end
            end
        end

        for _, conn in ipairs(features._connections) do
            if conn then conn:Disconnect() end
        end

        features._trackedCharacters = {}
        features._connections = {}

    end
end

features.Loopwipe = function()
    if not loopwiping.Value then 
        if plr.PlayerGui:FindFirstChild("NameDisplayUI") then
            plr.PlayerGui:FindFirstChild("NameDisplayUI").Enabled = false
        end

        local gui = plr:FindFirstChild("PlayerGui")
        if gui then
            local clientGui = gui:FindFirstChild("ClientGui")
            if clientGui then
                clientGui.Enabled = true
            end
        end

        local camera = workspace.CurrentCamera
        if camera then
            camera.CameraType = Enum.CameraType.Custom
            if plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    camera.CFrame = CFrame.new(hrp.Position, hrp.Position)
                end
            end
        end

        if wiperemoveloop then
            wiperemoveloop:Disconnect()
            wiperemoveloop = nil
        end

        return 
    end
    
    if Gender == nil then
        Notify("Incorrect Set Up.", "Select a Gender.", 2.5, "info")
        return
    end

    local RSLoaded = RS.Loaded:FindFirstChild(user)
    
    local function removeguiandfixcam()
        plr.PlayerGui:WaitForChild("ClientGui").Enabled = false
        local character = plr.Character or plr.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Scriptable
        local frontOffset = Vector3.new(0, 3, -5)
        wait(0.2)
        plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,20,0)
        for i = 1, 6 do
            wait(0.5)
            camera.CFrame = CFrame.new(hrp.Position + frontOffset, hrp.Position)
        end
        plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,20,0)
    end

    if not RSLoaded then
        if plr.PlayerGui:FindFirstChild("NameDisplayUI") then
            plr.PlayerGui:FindFirstChild("NameDisplayUI").Enabled = true
            plr.PlayerGui:FindFirstChild("NameDisplayUI"):FindFirstChild("BossFrame"):FindFirstChild("BossTitle").Text = "Current Name: "
        else
            local NameGui = plr.PlayerGui.BossNotifierUI:Clone()
            NameGui.Name = "NameDisplayUI"
            NameGui.Parent = plr.PlayerGui
            local NameFrame = NameGui:FindFirstChild("BossFrame")
            local NameText = NameFrame:FindFirstChild("BossTitle")

            NameFrame:FindFirstChild("BossHPLabel"):Destroy()

            NameFrame.AnchorPoint = Vector2.new(0.5, 1) 
            NameFrame.Position = UDim2.new(0.5, 0, 0.875, 0)

            NameText.TextColor3 = Color3.fromRGB(255, 188, 52)
            NameText.Text = "Current Name: "
            NameFrame.Visible = true
            NameGui.Enabled = true
        end

        wiperemoveloop = plr.PlayerGui.ChildAdded:Connect(function(addedgui)
            if  addedgui.Name == "ClientGui" then
                removeguiandfixcam()
            end
        end)
    end

    local function lookforcolor()
        local character = plr.Character
        if not character then return end
        for _, v in ipairs(character:GetChildren()) do
            if v.Name:sub(1, 4) == "Hair" then
                for _, color in pairs(selectedhaircolors) do
                    if tostring(v.BrickColor) == color then
                        gotcolor = true
                        return
                    end
                end
            end
        end
    end

    local function getFirstRealName(name)
        local ignore = {["chief"]=true, ["king"]=true, ["queen"]=true} 
        local words = {}

        if type(name) ~= "string" then
            return ""
        end

        for word in name:gmatch("%a+") do
            table.insert(words, word)
        end

        for _, w in ipairs(words) do
            if not ignore[w:lower()] then
                return w 
            end
        end

        return words[1] or ""
    end



    local function lookforname()
        local character = plr.Character or plr.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local currentname = humanoid.DisplayName or ""
        local trimmedname = currentname:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")

        local pickedName = getFirstRealName(trimmedname)

        if not RSLoaded and pickedName ~= "" then
            local nameUI = plr.PlayerGui:FindFirstChild("NameDisplayUI")
            if nameUI then
                local bossFrame = nameUI:FindFirstChild("BossFrame")
                if bossFrame then
                    local bossTitle = bossFrame:FindFirstChild("BossTitle")
                    if bossTitle then
                        bossTitle.Text = "Current Name: " .. pickedName
                    end
                end
            end
        end

        if pickedName ~= "" then
            local lowerPicked = pickedName:lower()
            for _, name in pairs(selectednames) do
                if lowerPicked == name:lower() then
                    gotname = true
                    break
                end
            end
        end
    end

    while loopwiping.Value do
        task.wait()

        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("NewGame")
        task.wait(0.16)
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("RequestReincarnation", tostring(Gender))
        task.wait(0.3)

        lookforcolor()
        lookforname()

        if twodesires then
            if gotname and gotcolor then
                Notify("Wipe Finished", "Found matching Character.", 2, "info")
                loopwiping.Value = false
            end
        else
            if gotname then
                Notify("Wipe Finished", "Found matching Name.", 2, "info")
                loopwiping.Value = false
            elseif gotcolor then
                Notify("Wipe Finished", "Found matching Color.", 2, "info")
                loopwiping.Value = false
            end
        end

        gotname = false
        gotcolor = false
    end

    if wiperemoveloop then
        wiperemoveloop:Disconnect()
    end
end

features.Autopick = function()
    if autopickupenabled then
        
        local function pickupLoop()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if not char then return end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local parts = workspace:GetPartBoundsInBox(
                hrp.CFrame,
                Vector3.new(50,50,50),
                params
            )

            for _, v in ipairs(parts) do
                local distance = (v.Position - hrp.Position).Magnitude
                if distance > 25 then
                    continue
                end

                if v:FindFirstChild("SpawnTime") and v:FindFirstChild("ItemDetector") then
                    fireclickdetector(v.ItemDetector)
                elseif v:FindFirstChild("Pickupable") and v:FindFirstChild("ID",true) then
                    if not v:FindFirstChild("ItemDetector") and distance > 15 then
                        continue
                    end
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("PickUp", v:FindFirstChild("ID",true).Value)
                end
            end
        end

        autopickup_connection = RunService.Heartbeat:Connect(pickupLoop)

    else
        if autopickup_connection then
            autopickup_connection:Disconnect()
            autopickup_connection = nil
        end
    end
end

features.Chakranotifi = function()
    if chakraguithere then
		CSNotifier_Enabled = false
        
        for i, v in pairs(folder:getDescendants()) do
            if v.Name == "Chakra Sense" then
                local sensePlayer = game.Players:FindFirstChild(v.Parent.Name)
                local sensePlayerCharacter = sensePlayer.Character
                local sensePlayerHumanoid = sensePlayerCharacter:FindFirstChildOfClass("Humanoid")

                local ingamename = sensePlayerHumanoid.DisplayName

                Notify(v.Parent.Name.." has chakra sense.","Ingame Name: "..ingamename,2.5,"eye")
            end
        end

	else
		CSNotifier_Enabled = true
	end
end

features.Disabledvoid = function()
    if voiddisabled then
        for i, v in pairs(game.workspace:GetDescendants()) do
            if v.Name == "LavarossaVoid" or v.Name == "Void" then
                if v:IsA("BasePart") then
                    if v.CanTouch then
                        v.CanTouch = false
                    end
                end
            end
        end
    else
        for i, v in pairs(game.workspace:GetDescendants()) do
            if v.Name == "LavarossaVoid" or v.Name == "Void" then
                if v:IsA("BasePart") then
                    if not v.CanTouch then
                        v.CanTouch = true
                    end
                end
            end
        end
    end
end

features.Disableblind = function()
    local RSLoaded = RS.Loaded:FindFirstChild(user)

    if not RSLoaded and plr.PlayerGui then
        repeat
            wait()
        until RS.Loaded:FindFirstChild(user) and plr:FindFirstChild("PlayerGui")
    end

    wait(1)

    if blindremoved == true then
        local function removeblind()
            for i, v in pairs(plr.PlayerGui.ClientGui:getChildren()) do
                if v.Name == "Blindness1" then
                    v.Visible = false
                end
                if v.Name == "Blindness2" then
                    v.Visible = false
                end
            end
        end
        removeloop = plr.PlayerGui.ChildRemoved:Connect(function(removed)
            if removed.Name == "ClientGui" then
                plr.PlayerGui:WaitForChild("ClientGui")
                plr.PlayerGui.ClientGui:WaitForChild("Mainframe")
                wait(1)
                removeblind()
            end
        end)
        removeblind()
    else
        if removeloop then
            removeloop:Disconnect()
        end

        for i, v in pairs(plr.PlayerGui.ClientGui:getChildren()) do
            if v.Name == "Blindness1" then
                v.Visible = true
            end
            if v.Name == "Blindness2" then
                v.Visible = true
            end
        end
    end
end

features.Nostun = function()
    if disabledstun then
        nostunloop = RunService.Heartbeat:Connect(function()
            local stunsetting = RS:WaitForChild("Settings"):FindFirstChild(user).Stunned
            stunsetting.Value = true
            stunsetting.Value = false
        end)
    else
        if nostunloop then
            nostunloop:Disconnect()
        end
    end
end

features.PurchaseItem = function()
    if itemtopurchase then
        local quantity = (purchasenumber and purchasenumber > 1) and purchasenumber or 1
        local args = {
            [1] = "Pay",
            [2] = 0,
            [3] = itemtopurchase,
            [4] = quantity,
            [5] = workspace:WaitForChild("TorchMesh")
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
    else
        Notify("Missing Item Name", "", 1.5, "info")
    end
end

features.PickUpClickDetectors = function()
    for i, v in pairs(game.workspace:GetDescendants()) do
        if v:IsA("ClickDetector") then
            if v.Parent.Name ~= "Sealing Bells" and v.Parent.Name ~= "Training Bells" and v.Parent.Name ~= "Mission" and v.Parent.Name ~= "Wedge" and v.Parent.Name ~= "Seaweed" and v.Parent.Name ~= "Gloweed" then
                if Teleport(v.Parent.CFrame) == true then return end
            end
        end
    end
end

features.AutoDevilsDeal = function()
    if Devilactive.Value then
        features.HandleNotLoadedIn()

        local playerdata = game:GetService("ReplicatedStorage")
                :WaitForChild("Events")
                :WaitForChild("DataFunction")
                :InvokeServer("GetData")
        
        local metreqs = false

        for i,v in pairs(playerdata["Traits"]) do
            if v == "A Devil's Deal" then
                metreqs = true
            end
        end

        if metreqs == false then
            Notify("Missing requirements..","You need to have Devil's Deal Trait", 2.5,"info")
            return
        end

        local function waitforcarry()
            local character = plr.Character or plr.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            hrp.CFrame = CFrame.new(-2974.29443, 326.182709, 646.613159, -0.99941802, -2.79689978e-08, 0.0341118388, -2.78877685e-08, 1, 2.85709167e-09, -0.0341118388, 1.90412597e-09, -0.99941802)
            wait(0.5)
            settingsfolder = game:GetService("ReplicatedStorage").Settings:WaitForChild(user)

            if hrp then
                wait(0.2)
                while wait() do
                    if Devilactive.Value == false then return end
                    hrp.CFrame = CFrame.new(-2974.29443, 326.182709, 646.613159, -0.99941802, -2.79689978e-08, 0.0341118388, -2.78877685e-08, 1, 2.85709167e-09, -0.0341118388, 1.90412597e-09, -0.99941802)
                    local args = {"Carry"}
                    RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    wait(0.1)
                    if settingsfolder:FindFirstChild("Carrying") then
                        if settingsfolder:FindFirstChild("Carrying").Value ~= nil then
                            break
                        end
                    end
                end
            end
        end
        
        local function whitevoidincombat()
            if Devilactive.Value == false then return end

            local character = plr.Character or plr.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)

            local args = {"InflictFire"}
            RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
        
            repeat
                wait()
            until settingsfolder:FindFirstChild("RecentDamage").Value == 2.5

            local character = plr.Character or plr.CharacterAdded:Wait()
            hrp = character:WaitForChild("HumanoidRootPart", 2)
    
            if hrp then
                hrp.CFrame = CFrame.new(0, -698, 0)
            end
        end
        
        waitforcarry()
        whitevoidincombat()
        
        devilloop = plr.CharacterAdded:Connect(function(character)
            wait(0.5)
            waitforcarry()
            whitevoidincombat()
        end)

    else
        if devilloop then
            devilloop:Disconnect()
        end
    end
end

features.JoinNotification = function()
    if joinnotienabled then
        loopingjoin = game.Players.PlayerAdded:Connect(function(plr)
            Notify("A Player has joined.", plr.Name .. " has joined", 2, "info")
        end)
    else
        if loopingjoin then
            loopingjoin:Disconnect()
            loopingjoin = nil
        end
    end
end

features.AgileTrait = function()
    if agiletraitenabled then
        local function applyModifier(chr)
            local hrp = chr:WaitForChild("HumanoidRootPart")

            buffingdash = hrp.ChildAdded:Connect(function(origBV)
                if origBV.Name == "DashBV" and origBV:IsA("BodyPosition") then
                    print("Original DashBV detected, creating modified copy.")

                    -- Clone the original to preserve all properties
                    local modBV = origBV:Clone()
                    modBV.Name = "DashBV_Agile"

                    -- Apply multiplier
                    local SpeedDiff = 1.5
                    modBV.P = origBV.P * SpeedDiff
                    modBV.MaxForce = origBV.MaxForce * SpeedDiff
                    local dir = (origBV.Position - hrp.Position).Unit
                    local dist = (origBV.Position - hrp.Position).Magnitude
                    modBV.Position = hrp.Position + dir * (dist * SpeedDiff)

                    modBV.Parent = hrp

                    -- Disable original AFTER clone is active
                    origBV.MaxForce = Vector3.new(0,0,0)
                    origBV.P = 0

                    -- Remove copy when original is removed
                    local conn
                    conn = origBV.AncestryChanged:Connect(function(_, parent)
                        if not parent then
                            if modBV then
                                modBV:Destroy()
                                modBV = nil
                                print("Original DashBV removed, copy deleted.")
                            end
                            conn:Disconnect()
                        end
                    end)
                end
            end)
        end

        waitingforrespawn = plr.CharacterAdded:Connect(function(character)
            applyModifier(character)
        end)

        if plr.Character then
            applyModifier(plr.Character)
        end
    else
        -- Disable effect
        if waitingforrespawn then
            waitingforrespawn:Disconnect()
            waitingforrespawn = nil
        end
        if buffingdash then
            buffingdash:Disconnect()
            buffingdash = nil
        end
        print("AgileTrait disabled")
    end
end


features.ShowSkillTree = function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local gui = player:WaitForChild("PlayerGui"):WaitForChild("ClientGui").Mainframe.Rest
    local skillView = gui:WaitForChild("SkillView")
    local changeddescription = false

    local skillsFrame = gui:FindFirstChild("SkillsFrame")
    local buyButton = skillView:FindFirstChild("Unlock")
    local skillDesc = skillView:FindFirstChild("Back")
    local headerBack = skillView:FindFirstChild("HeaderBack")
    local header = headerBack and headerBack:FindFirstChild("Header")

    local gameManager = require(game.ReplicatedStorage:WaitForChild("GameManager"))
    local allSkills = gameManager.Skills
    local settings = gameManager:getSettings(character)
    local unlockedSkills = settings and settings:FindFirstChild("UnlockedSkills")

    if not skillsFrame then warn("SkillsFrame not found!") end
    if not buyButton then warn("Unlock button not found!") end
    if not skillDesc then warn("UnlockMsg not found!") end
    if not header then warn("Header label not found!") end

    local buyConn

    local function hasSkill(skillName)
        return gameManager:hasSkill(settings, skillName)
    end

    if skillDesc and skillDesc.Description then
        clickedbuttoncon = skillDesc.Description.Changed:Connect(function(property)
            if property == "Text" then
                changeddescription = true
            end
        end)
    end

    for skillName, skillInfo in pairs(allSkills) do
        if skillInfo.GUIName and skillInfo.GUIName ~= "" then
            local button = skillsFrame and skillsFrame:FindFirstChild(skillInfo.GUIName)
            if not button then
            else
                button.Visible = true
                button.SlotText.Text = skillName

                if skillInfo.ID and skillInfo.ID ~= "" then
                    button.Image = "rbxassetid://" .. skillInfo.ID
                    button.SlotText.TextTransparency = 1
                else
                    button.SlotText.TextTransparency = 0
                end

                button.SlotBorder.Image = "rbxassetid://" .. gameManager.UI.StandardBorder

                -- On click
                button.MouseButton1Click:Connect(function()
                    local function removeinfo()
                        if skillDesc then
                            local costText = "--"
                            skillDesc.Description.Text = costText
                            skillDesc.Required1.Text = ""
                            skillDesc.Required2.Text = ""
                            skillDesc.Required3.Text = ""
                            skillDesc.Required1Image.Image = ""
                            skillDesc.Required2Image.Image = ""
                            skillDesc.Required3Image.Image = ""
                        end
                    end

                    if header then
                        header.Text = skillName
                    end

                    if buyButton then

                        skillView.Visible = true
                        buyButton.Visible = true
                        skillDesc.Visible = true
                        headerBack.Visible = true

                        buyConn = buyButton.MouseButton1Click:Connect(function()
                            game.ReplicatedStorage.Events.DataEvent:FireServer("buySkill", skillName)
                        end)

                        wait(0.2)
                        if changeddescription == true then
                            changeddescription = false
                        else
                            removeinfo()
                        end
                    end
                end)
            end
        end
    end
end

features.Buffchakraregen = function()
    if buffingchakra then
        local function buffchakra()

            local cooldown = false
            local chakra = plr.Backpack:FindFirstChild("chakra")
            local startval = chakra.Value
            
            buffing = chakra.Changed:Connect(function(newval)
                if newval > startval then
                    
                    if cooldown == true then
                        return
                    end
                    
                    cooldown = true
                    
                    local newchakra = chakra.Value + chakrabuffamount
                
                    if newchakra < plr.Backpack.maxChakra.Value then
                        local args = {
                            [1] = "TakeChakra",
                            [2] = chakrabuffamount * -1
                        }
                        
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        chakra.Value = chakra.Value + chakrabuffamount
                    end

                    startval = newval

                    wait(0.9)
                    cooldown = false

                elseif startval > newval then
                    startval = newval
                end
            end)
        end

        buffchakra()

        respawning = plr.CharacterAdded:Connect(function()
            buffing:Disconnect()
            wait(1.3)
            buffchakra()
        end)
    else
        if buffing then
            buffing:Disconnect()
        end
        if respawning then
            respawning:Disconnect()
        end
    end
end

features.SearchObj = function()
    if searchingforobj then
        wait(0.2)
        if selectedsearchobject ~= nil then
            if workspace:FindFirstChild(selectedsearchobject) then
                searchingforobj = false
                Notify(selectedsearchobject.. " has been found!", "Server Hopping stopped",3,"info")
                features.CheckNotiAndSend("Object/NPC found", "Object/NPC has been found: "..tostring(selectedsearchobject))
                return
            else
                Notify("Object/NPC not found", "Starting Server Hop..", 2, "info")

                if shopdelay ~= nil then
                    wait(shopdelay)
                end

                features.TeleportRandomServer()
                return
            end
        end
    end
end

features.GiveGripsFrags = function()
    if GiveKnock.Value then
        features.HandleNotLoadedIn()
        while GiveKnock.Value do
            local character = plr.Character or plr.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 2)
        
            if hrp then
                hrp.CFrame = CFrame.new(-2974.29443, 326.182709, 646.613159, -0.99941802, -2.79689978e-08, 0.0341118388, -2.78877685e-08, 1, 2.85709167e-09, -0.0341118388, 1.90412597e-09, -0.99941802)
        
                local args = {
                    [1] = "TakeDamage",
                    [2] = 10000,
                    [3] = "yes"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            end
            wait()
        end        
    end
end

features.InstantVoid = function()
    if not (plr.Character and TargetPlayer and TargetPlayer.Character) then return end

    local function hasChakraZone()
        for _, v in pairs(plr.PlayerGui.ClientGui.Mainframe.Loadout:GetDescendants()) do
            if v.Name == "SlotText" and v.Text == "Chakra Zone" then return true end
        end
        return false
    end

    if not hasChakraZone() then
        Notify("Missing requirements..", "You need to have Chakra Zone", 2.5, "info")
        return
    end

    local childFound = plr.Character:FindFirstChild("SasukeSusanoo") or plr.Character:FindFirstChild("SasukeArmouredSusanoo")

    if not childFound then
        RS.Events.DataEvent:FireServer("startSkill","Purple Susanoo Summon",Vector3.new(-727.0325927734375,-192,-457.90167236328125),true)
        RS.Events.DataEvent:FireServer("startSkill","Purple Armoured Susanoo Summon",Vector3.new(-727.0325927734375,-192,-457.90167236328125),true)
        
        local done = false
        local function onChildAdded(newChild)
            if newChild.Name=="SasukeSusanoo" or newChild.Name=="SasukeArmouredSusanoo" then
                childFound=newChild
                done=true
            end
        end
        local connection = plr.Character.ChildAdded:Connect(onChildAdded)
        task.delay(2,function() done=true end)
        while not done do task.wait() end
        connection:Disconnect()
    end

    if not childFound then
        Notify("Missing requirements..", "Missing Susanoo", 2.5, "info")
        return
    end

    local function unsummon(susanoo)
        if susanoo and susanoo.Parent then
            local skill = susanoo.Name == "SasukeSusanoo" and "Purple Susanoo Summon" or "Purple Armoured Susanoo Summon"
            local currentSkill = settingsfolder:WaitForChild("CurrentSkill")

            local startTime = tick()
            while currentSkill.Value ~= "" and tick() - startTime < 2 do
                task.wait(0.05)
            end

            RS.Events.DataEvent:FireServer("startSkill", skill, Vector3.new(-727.0325927734375,-192,-457.90167236328125), true)
        end
    end

    local hrp = plr.Character:WaitForChild("HumanoidRootPart")
    local startCF = hrp.CFrame
    local voidCF = CFrame.new(1144.74707,-270,-946.274597,0.0208230875,0,-0.999783158,0,1,0,0.999783158,0,-0.0208230875)

    for _,v in pairs(workspace:GetDescendants()) do
        if (v.Name=="LavarossaVoid" or v.Name=="Void") and v:IsA("BasePart") then v.CanTouch=false end
    end

    local noclip = true
    local noclipConn
    noclipConn = RunService.Heartbeat:Connect(function()
        if plr.Character and noclip then
            for _,v in pairs(plr.Character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide=false end
            end
        else noclipConn:Disconnect() end
    end)

    task.wait(0.1)
    hrp.CFrame = voidCF
    
    local settingsfolder = RS.Settings:FindFirstChild(user) or RS.Settings:WaitForChild(user)

    if settingsfolder:FindFirstChild("CurrentSkill").Value ~= "" then
        local currentSkill = settingsfolder:WaitForChild("CurrentSkill")
        local startTime = tick()

        while currentSkill.Value ~= "" and tick() - startTime < 2 do
            task.wait(0.05)
        end
    end

    RS.Events.DataEvent:FireServer("startSkill","Chakra Zone",Vector3.new(-684,-206.094,-512.374),true)
    RS.Events.DataEvent:FireServer("ReleaseSkill")

    local chakraZone = workspace:WaitForChild("ChakraZone"..plr.Name,2.5)
    if not chakraZone then
        noclip=false
        hrp.CFrame=startCF
        unsummon(childFound)
        return
    end

    RS.Events.DataEvent:FireServer("DeactivateSkill")
    task.wait(0.05)
    RS.Events.DataEvent:FireServer("startSkill","Purple Susanoo Grab",Vector3.new(-703.598,-209.78,-572),true)
    RS.Events.DataEvent:FireServer("ReleaseSkill")

    local targetHRP = TargetPlayer.Character:WaitForChild("HumanoidRootPart")
    local offset = CFrame.new(-10.5,0,11)
    local grabbed, timeout = false, false

    local grabConn
    grabConn = RunService.Heartbeat:Connect(function()
        if targetHRP and hrp and hrp.Parent and not grabbed and not timeout then
            hrp.CFrame=targetHRP.CFrame*offset
            if targetHRP:FindFirstChild("HasMass") then grabbed=true end
        else grabConn:Disconnect() end
    end)

    task.delay(1,function() if not grabbed then timeout=true end end)
    while not grabbed and not timeout do task.wait() end
    if grabConn then grabConn:Disconnect() end

    if grabbed then
        local tiltConn
        tiltConn = RunService.Heartbeat:Connect(function()
            if hrp and hrp.Parent and targetHRP:FindFirstChild("HasMass") then
                hrp.CFrame=voidCF*CFrame.new(0,-8.2,0)*CFrame.Angles(math.rad(160),0,0)
            end
        end)
        while targetHRP:FindFirstChild("HasMass") do task.wait() end
        if tiltConn then tiltConn:Disconnect() end
    end

    noclip=false
    hrp.CFrame=startCF
    unsummon(childFound)
end

features.TPChakraFruit = function()
    for i, v in pairs(workspace:GetChildren()) do
        if v.Name == "Chakra Fruit" then
            Teleport(v.CFrame)
            return
        end
    end
    for i, v in pairs(RS:GetChildren()) do
        if v.Name == "Chakra Fruit" then
            if table.find(teleportedfruitIDs, v.ID.Value) then
                continue
            else
                if Teleport(v.CFrame) == false then continue end
                table.insert(teleportedfruitIDs,v.ID.Value)
                return
            end
        end
    end
    Notify("No Chakra Fruit found.","",1.5,"info")
end

features.TPFruit = function()
    for i, v in pairs(workspace:GetChildren()) do
        if v.Name == "Life Up Fruit" or v.Name == "Fruit Of Forgetfulness" then
            Teleport(v.CFrame)
            return
        end
    end
    for i, v in pairs(RS:GetChildren()) do
        if v.Name == "Life Up Fruit" or v.Name == "Fruit Of Forgetfulness" then
            if table.find(teleportedfruitIDs, v.ID.Value) then
                continue
            else
                if Teleport(v.CFrame) == false then continue end
                table.insert(teleportedfruitIDs,v.ID.Value)
                return
            end
        end
    end
    Notify("No LF/FOF Found.","",1.5,"info")
end

features.FarmGrips = function()
    if farminggrips.Value == false then return end
    features.HandleNotLoadedIn()

    if features.gotosafespot(true,false) == false then
        return
    end

    local function updateGrips(action)
        if action == "enable" then
            MainUI.Enabled = true
        elseif action == "grips" then
            local playerdata = game:GetService("ReplicatedStorage")
                :WaitForChild("Events")
                :WaitForChild("DataFunction")
                :InvokeServer("GetData")
            local gripamount = playerdata["Grips"] or 0
            GripLabel.Text = "[Tact Hub] \n Grips: "..gripamount
        elseif action == "disable" then
            MainUI.Enabled = false
        end
    end

    if farminggrips.Value then
        updateGrips("enable")
        while farminggrips.Value do
            local userSettings = RS:WaitForChild("Settings"):FindFirstChild(user)
            if userSettings and userSettings:FindFirstChild("Gripping").Value == "None" then
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    features.gotosafespot()
                    local args = {"Grip"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    wait(0.2)
                    updateGrips("grips")
                end
            else
                updateGrips("grips")
                wait()
            end
            wait()
        end
        updateGrips("disable")
    else
        updateGrips("disable")
        wait(0.2)
        updateGrips("disable")
    end
end

features.GiveGrips = function()
    if not givegrip.Value then return end
    features.HandleNotLoadedIn()

    if features.gotosafespot(true,false) == false then
        return
    end

    local function updateGrips(action)
        if action == "enable" then
            MainUI.Enabled = true
        elseif action == "grips" then
            GripLabel.Text = "[Tact Hub] \n Giving Grips"
        elseif action == "disable" then
            MainUI.Enabled = false
        end
    end

    if givegrip.Value then
        updateGrips("enable")
        updateGrips("grips")

        while givegrip.Value do
            local character = plr.Character or plr.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 2)
            
            if hrp and givegrip.Value then

                local playerdata = game:GetService("ReplicatedStorage")
                :WaitForChild("Events")
                :WaitForChild("DataFunction")
                :InvokeServer("GetData")

                if playerdata["Village"] ~= "Rogue" then
                    game:GetService("ReplicatedStorage").Events.DataFunction:InvokeServer("JoinVillage", "Rogue")
                end

                if playerdata["LifeForce"] == 0 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("NewGame")
                    task.wait(0.16)
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("RequestReincarnation", "Male")
                end

                features.gotosafespot()
                
                local args = {
                    [1] = "TakeDamage",
                    [2] = 10000,
                    [3] = "yes"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            end
            wait()
        end
        updateGrips("disable")  
    else
        updateGrips("disable")
        wait(0.2)
        updateGrips("disable")
    end
end

features.TPPoints = function()
    local CFrame = nil
    for i, v in pairs(game.workspace.ChakraPoints:GetDescendants()) do
        if v.Name == "Unlocked" then
            if v.Value == false then
                if v.Parent.Main.Transparency == 0 then
                    TPing = true
                    CFrame = v.Parent.Main.CFrame 
                    if Teleport(CFrame) == false then 
                        continue 
                    else
                        break
                    end
                end
            end
        end
    end
end

features.TPPumpkinPoints = function()
    for i, v in pairs(game.workspace:GetChildren()) do
        if v.Name == "PumpkinPoint" then
            if v:FindFirstChild("Destroyed").Value == false then
                if Teleport((v:FindFirstChild("Main").CFrame * CFrame.new(0,6,0))) == false then 
                    continue 
                else
                    return
                end
            end
        end
    end
    Notify("Try again later", "No Pumpkin Point detected.",2.5,"info")
end

features.TPHallowedPortal = function()
    for i, v in pairs(workspace.Debris:GetChildren()) do
        if v.Name == "Infernal Sasuke Portal" then
            if Teleport(workspace.Debris:FindFirstChild("Infernal Sasuke Portal").CFrame) == false then
                continue
            else
                return
            end
        end
    end
    Notify("Try again later", "No Hallowed Portal detected.",2.5,"info")
end

-- Candy teleport feature removed
features.TPCandy = function()
    Notify("Feature Removed", "Candy features have been removed.",2.5,"info")
end

features.RyoFarm = function()
	if not Ryofarming.Value then return end
    features.HandleNotLoadedIn()
	local char = plr.Character or plr.CharacterAdded:Wait()
	local RunService = game:GetService("RunService")
    local isWatering = false

	local function checkforcrops()
		for _, v in ipairs(workspace:GetChildren()) do
			if v.Name == "Crops" then
				return true
			end
		end
		return false
	end

    
	task.spawn(function()
		while Ryofarming.Value do
			local orangethere, bowlthere = false, false

			for _, v in pairs(plr.PlayerGui.ClientGui.Mainframe.Loadout:GetDescendants()) do
				if v.Name == "SlotText" and v.Text == "Orange" then
					local numStr = v.Parent.ItemNumber.Number.Text
					local num = tonumber(string.sub(numStr, 2))
					if num and num > 2 then
						orangethere = true
						break
					end
				end
			end

			for _, v in pairs(plr.PlayerGui.ClientGui.Mainframe.Loadout:GetDescendants()) do
				if v.Name == "SlotText" and v.Text == "Bowl" then
					bowlthere = true
				end
			end

			wait()

			if not orangethere then
				game.ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", "Tangerina Fruit Bowl")
				game.ReplicatedStorage.Events.DataFunction:InvokeServer("SellFood", "Tangerina Fruit Bowl", 15)
			else
				if not bowlthere then
					if checkforcrops() then
                        for i, v in pairs(workspace:GetChildren()) do
                            if v.Name == "Crops" and v.Transparency == 0 then
                                isWatering = true
                                watercrops(v,100)
                                wait(0.2)
                                isWatering = false
                                break
                            end
                        end
					else
						game.ReplicatedStorage.Events.DataFunction:InvokeServer("Pay", nil, "Bowl", 1)
					end
				end

				local BowlHolder = workspace:WaitForChild("BowlHolderHallow")
				game.ReplicatedStorage.Events.DataEvent:FireServer("PlaceBowl", BowlHolder)
				game.ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", "Tangerina Fruit Bowl")

				local Cooker = workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater")
				for _ = 1, 3 do
					wait(0.1)
					game.ReplicatedStorage.Events.DataEvent:FireServer("AddFruit", Cooker, "Orange")
				end

				game.ReplicatedStorage.Events.DataFunction:InvokeServer("SellFood", "Tangerina Fruit Bowl", 15)
				wait(0.1)
				game.ReplicatedStorage.Events.DataEvent:FireServer("BowlFinish", BowlHolder:WaitForChild("BowlFinish"))
			end
		end
	end)

	-- Check for crops once
	if not checkforcrops() then
		local ryoAmount = tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text)
		if ryoAmount and ryoAmount < 3 then
			spawn(function()
				wait(13)
				for _ = 1, 2 do
					game.ReplicatedStorage.Events.DataEvent:FireServer("Item", "Selected", "Orange")
					game.ReplicatedStorage.Events.DataFunction:InvokeServer("SellFood", "Orange", 2)
					wait(0.2)
				end
			end)
		end
	end

	local spawned = false
	local pickuptable = {}

	NoFallDammage.Value = true

	waiting = workspace.ChildAdded:Connect(function(newchild)
		if newchild:FindFirstChild("ID") then
			spawned = true
			if newchild.Name == "Orange" then
				table.insert(pickuptable, newchild)
			end
		end
	end)

	local function nocliploop()
		for _, v in pairs(plr.Character:GetChildren()) do
			if v:IsA("BasePart") and v.CanCollide then
				v.CanCollide = false
			end
		end
	end

	noclippinghop = RunService.Stepped:Connect(nocliploop)

	task.spawn(function()
        while Ryofarming.Value do
            task.wait()

            for _, v in pairs(workspace:GetDescendants()) do
                if not Ryofarming.Value then break end

                -- Wait here until watering is done
                if isWatering then
                    while isWatering do
                        if not Ryofarming.Value then break end
                        wait()
                    end
                end

                if not Ryofarming.Value then break end

                if v.Name == "FruitType" and v.Value == "Orange" and not v:GetAttribute("orange") then
                    char.HumanoidRootPart.CFrame = v.Parent:FindFirstChild("MainBranch").CFrame

                    local timeout = os.clock() + 12
                    while os.clock() < timeout and not spawned do
                        if not Ryofarming.Value then break end
                        wait()
                    end

                    if not spawned then
                        -- Just wait and retry next iteration
                        wait()
                    else
                        if #pickuptable > 0 then
                            local bv = Instance.new("BodyVelocity")
                            bv.Velocity = Vector3.new(0, 0, 0)
                            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                            bv.Parent = char:FindFirstChild("HumanoidRootPart")

                            for _, fruit in ipairs(pickuptable) do
                                if not Ryofarming.Value then break end
                                if fruit:FindFirstChild("ID") then
                                    char.HumanoidRootPart.CFrame = fruit.CFrame * CFrame.new(0, -6, 0)
                                    while fruit and fruit:IsDescendantOf(workspace) do
                                        if not Ryofarming.Value then break end
                                        game.ReplicatedStorage.Events.DataEvent:FireServer("PickUp", fruit.ID.Value)
                                        wait()
                                    end
                                end
                            end

                            table.clear(pickuptable)
                            bv:Destroy()
                            wait()
                            v:SetAttribute("orange", true)
                            spawned = false
                        end

                        -- RYO check
                        if desiredRyoamount and type(desiredRyoamount) == "number" then
                            local currentRyo = tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text)
                            if currentRyo and currentRyo >= desiredRyoamount then
                                Ryofarming.Value = false
                                Notify("Farming complete.", "You reached the Ryo Amount.", 2.5, "info")
                            end
                        end
                    end
                end
            end

            for _, v in pairs(workspace:GetDescendants()) do
                if not Ryofarming.Value then break end
                if v.Name == "FruitType" and v.Value == "Orange" and v:GetAttribute("orange") then
                    v:SetAttribute("orange", false)
                end
            end
        end

        if noclippinghop then noclippinghop:Disconnect() end
        if waiting then waiting:Disconnect() end
        NoFallDammage.Value = false
    end)
end

local toolbarnamechange
local cornernamechange
local removenameloop

features.HideName = function()

    local function removename()
        if not plr or not plr.Parent then return end
        local pg = plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui", 10)
        if not pg then return end

        local clientgui = pg:FindFirstChild("ClientGui")
        local topbar = pg:FindFirstChild("TopbarStandard")
        if not clientgui or not topbar then return end
        if not clientgui:FindFirstChild("Mainframe") then return end
        if not clientgui.Mainframe:FindFirstChild("Loadout") then return end
        if not clientgui.Mainframe.Loadout:FindFirstChild("HUD") then return end

        local nametoolbar = clientgui.Mainframe.Loadout.HUD:FindFirstChild("PlayerName")
        if not nametoolbar then return end

        local top = topbar.Holders
        if not top or not top.Left or not top.Left.Widget then return end
        local btn = top.Left.Widget.IconButton
        if not btn or not btn.Menu or not btn.Menu.IconSpot then return end
        local contents = btn.Menu.IconSpot.Contents
        if not contents or not contents.IconLabelContainer then return end
        local nametopleftcorner = contents.IconLabelContainer:FindFirstChild("IconLabel")
        if not nametopleftcorner then return end

        nametoolbar.Text = "You"
        nametopleftcorner.Text = ""

        toolbarnamechange = nametoolbar.Changed:Connect(function(property)
            if property == "Text" and nametoolbar then
                nametoolbar.Text = "You"
            end
        end)

        cornernamechange = nametopleftcorner.Changed:Connect(function(property)
            if property == "Text" and nametopleftcorner then
                nametopleftcorner.Text = ""
            end
        end)
    end

    if hidingname == true then
        removenameloop = plr.CharacterAdded:Connect(function()
            task.wait(1)
            removename()
        end)
        removename()
    else
        if removenameloop then
            removenameloop:Disconnect()
        end
        if cornernamechange then
            cornernamechange:Disconnect()
        end
        if toolbarnamechange then
            toolbarnamechange:Disconnect()
        end

        local pg = plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui", 10)
        if not pg then return end

        local clientgui = pg:FindFirstChild("ClientGui")
        local topbar = pg:FindFirstChild("TopbarStandard")
        if not clientgui or not topbar then return end
        if not clientgui:FindFirstChild("Mainframe") then return end
        if not clientgui.Mainframe:FindFirstChild("Loadout") then return end
        if not clientgui.Mainframe.Loadout:FindFirstChild("HUD") then return end

        local nametoolbar = clientgui.Mainframe.Loadout.HUD:FindFirstChild("PlayerName")
        local top = topbar.Holders
        if not top or not top.Left or not top.Left.Widget then return end
        local btn = top.Left.Widget.IconButton
        if not btn or not btn.Menu or not btn.Menu.IconSpot then return end
        local contents = btn.Menu.IconSpot.Contents
        if not contents or not contents.IconLabelContainer then return end
        local nametopleftcorner = contents.IconLabelContainer:FindFirstChild("IconLabel")
        if not nametoolbar or not nametopleftcorner then return end

        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            nametoolbar.Text = plr.Character.Humanoid.DisplayName
        end
        nametopleftcorner.Text = plr.Name .. " | " .. plr.UserId
    end
end

features.Activationsfarm = function()
    if Activationfarm.Value then
        features.HandleNotLoadedIn()
        local modes = {"Sharingan [Stage 1]","Sharingan [Stage 2]","Sharingan [Stage 3]","Obito's Mangekyo","Obito's Eternal Mangekyo",
        "Itachi's Mangekyo","Itachi's Eternal Mangekyo","Sasuke's Mangekyo","Sasuke's Eternal Mangekyo","Pain's Rinnegan","Byakugan [Stage 1]"
        ,"Byakugan [Stage 2]","Byakugan [Stage 3]","Byakugan [Stage 4]","Adamantine Sealing Chains", "Hundred Healings", "Green Gates",
        "Ketsuryugan [Stage 3]","Ketsuryugan [Stage 2]","Ketsuryugan [Stage 1]", "Blue Gates"}
        local mode = false

        for i,v in modes do
            if insertedjutsumode == v then
                mode = true
            end
        end

        if mode == true then
            if AutoModeNoReset == false then

                if features.gotosafespot(true,false) == false then
                    return
                end

                local function usemodeandwhitevoid()
                    task.wait(0.1)
                    local char = plr.Character or plr.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart", 10)
                    if not hrp then return end
                    
                    if Activationfarm.Value == false then
                        return
                    end

                    repeat 
                        task.wait() 
                        features.gotosafespot()
                    until not char:FindFirstChild("ForceField") or char.Parent == nil or Activationfarm.Value == false

                    if Activationfarm.Value == false then
                        return
                    end

                    if char and char.Parent and hrp and hrp.Parent then
                        local args = {
                            "Awaken",
                            insertedjutsumode
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                        plr.Character.Head:Destroy()
                    end
                end

                modeloop = plr.CharacterAdded:Connect(function(character)
                    task.spawn(usemodeandwhitevoid)
                end)

                if plr.Character then
                    task.spawn(usemodeandwhitevoid)
                end
            else
                while Activationfarm.Value do
                    local args = {
                        "Awaken",
                        insertedjutsumode
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                    
                    wait(1.5)
                end
            end
        else
            while Activationfarm.Value do
                local args = {
                    "startSkill",
                    insertedjutsumode,
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                
                wait()

                local args = {
                    "ReleaseSkill"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                
                wait()
            end
        end
    else
        if modeloop then
            modeloop:Disconnect()
        end
    end

end

features.AutoSpawnArticNPC = function()
    if spawningarticnpc.Value then
        features.HandleNotLoadedIn()
        local activationfloors = {workspace.SnowActivationFloor4,workspace.SnowActivationFloor6,workspace.SnowActivationFloor7}
        local spawncooldown = false
        local waitingspot = CFrame.new(-2268.02148, 81.1951981, -3024.97119)

        local function bodyforceconf(boolean)
            if boolean == true then
                if not plr.Character.HumanoidRootPart:FindFirstChild("SpawnerVel") then
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    bv.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
                    bv.Name = "SpawnerVel"
                end
            else
                for i, v in pairs(plr.Character.HumanoidRootPart:GetChildren()) do
                    if v.Name == "SpawnerVel" then
                        v:Destroy()
                    end
                end
            end
        end

        local function spawntheNPCs()
            for i, v in pairs(activationfloors) do
                if spawningarticnpc.Value == false then return end
                bodyforceconf(false)

                Teleport(v.CFrame)
                        
                wait(0.25)

                local args = {
                    "ActivateSecretStepPlate",
                    v
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                plr.Character.Humanoid.Jump = true
                wait(0.2)
                Teleport(waitingspot)
                wait(0.3)
            end
            spawncooldown = true
        end

        while spawningarticnpc.Value == true do
            wait()
            if spawncooldown == false then
                spawntheNPCs()
                task.spawn(function()
                    for i = 60, 1, -1 do
                        print("Time remaining:", i)
                        task.wait(1)
                    end
                    spawncooldown = false
                end)
                wait(0.1)
                Teleport(waitingspot)
                bodyforceconf(true)
            end
            if workspace:FindFirstChild("Frozen Relic") and workspace:FindFirstChild("Frozen Relic").Transparency == 0 then
                Teleport(workspace["Frozen Relic"].CFrame)
                local timeout = 1.5
                local startTime = tick()
                local relic = workspace:FindFirstChild("Frozen Relic")

                while relic and relic.Parent and tick() - startTime < timeout do
                    task.wait()
                    if relic.Transparency ~= 0 then
                        break
                    end
                    local args = {
                        "Relic",
                        "Frozen Relic"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                end
            end
            Teleport(waitingspot)
            bodyforceconf(true)
        end
        if plr.Character.HumanoidRootPart:FindFirstChild("SpawnerVel") then
            plr.Character.HumanoidRootPart:FindFirstChild("SpawnerVel"):Destroy()
        end
    end
end

features.DoQuest = function()
    if selectedquest ~= nil and plr.Character then
        local startpos = plr.Character.HumanoidRootPart.CFrame
        if selectedquest == "Passageway" then
            local args = {
                "StartQuest",
                "Hostage Retrieval"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Hostage" then
                    if v:FindFirstChild("Settings"):FindFirstChild("BeingCarried").Value == "None" then
                        repeat 
                            plr.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,1.5)
                            wait()

                            local args = {"Carry"}
                            RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                            wait(0.1)
                        until RS:WaitForChild("Settings"):FindFirstChild(user):FindFirstChild("Carrying").Value ~= nil
                        local args = {
                                "GetQuestProgress",
                                "Hostage Retrieval",
                                "DontComplete"
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                        wait(0.2)
                        local args = {"Carry"}
                        RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        
                        wait(0.1)
                        plr.Character.HumanoidRootPart.CFrame = startpos
                        return
                    end
                end
            end

            wait()
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
            
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(2142.51807, -207.585144, -773.712219, 0.00978908874, 0.036685016, -0.999278903, -4.71484007e-08, 0.999326825, 0.0366867706, 0.999952078, -0.000359082944, 0.00978250057)

            local args = {
                "ActivateSecretStepPlate",
                workspace:WaitForChild("BanditActivationFloor")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            local objectname = "Hostage"
            local timeout = 0.8
            local startTime = tick()
            local hostage = nil

            repeat
                hostage = workspace:FindFirstChild(objectname)
                task.wait()
            until hostage or (tick() - startTime) >= timeout

            wait(0.2)

            bv:Destroy()
            
            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Hostage" then
                    if v:FindFirstChild("Settings"):FindFirstChild("BeingCarried").Value == "None" then
                        repeat 
                            plr.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
                            wait()

                            local args = {"Carry"}
                            RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                            wait(0.5)
                        until RS:WaitForChild("Settings"):FindFirstChild(user):FindFirstChild("Carrying").Value ~= nil

                        local args = {
                                "GetQuestProgress",
                                "Hostage Retrieval",
                                "DontComplete"
                            }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                        wait(0.2)
                        local args = {"Carry"}
                        RS:WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        
                        wait(0.1)
                        plr.Character.HumanoidRootPart.CFrame = startpos
                        return
                    end
                end
            end
            Notify("No Hostage found.","",1.5,"info")
            plr.Character.HumanoidRootPart.CFrame = startpos
        
        elseif selectedquest == "Flower Bouquet" then
            local args = {
                "GetQuestProgress",
                "Flower Bouquet"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                "StartQuest",
                "Flower Bouquet"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.2)
            local args = {
                "PlaceFlowerBouquet",
                workspace:WaitForChild("Blue Stone")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            wait(0.2)

            local args = {
                "GetQuestProgress",
                "Flower Bouquet"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

        elseif selectedquest == "Crate Delivery" then
            
            local hascrate = false

            for _, child in ipairs(plr.Character:GetChildren()) do
                if string.match(child.Name, "^Crate") then
                    hascrate = true
                    break
                end
            end

            if hascrate == false then
                Notify("Missing Crate", "You need to accept a Crate Mission", 2.5, "info")
                return
            end

            for i, v in pairs(workspace.Debris["Mission Locations"]:GetDescendants()) do
                if v:IsA("StringValue") then
                    for _, npcs in pairs(workspace:GetChildren()) do
                        if npcs.Name == v.Name then
                            if npcs:FindFirstChild("MissionMarker") and npcs:FindFirstChild("MissionMarker").Enabled == true then
                                Teleport(npcs.HumanoidRootPart.CFrame)
                                return
                            end
                        end
                    end
                end
            end

        elseif selectedquest == "Bells" then
            if workspace:FindFirstChild("Training Bells") then
                Teleport(workspace:FindFirstChild("Training Bells").CFrame)

                wait(0.1)

                local args = {
                    "StartQuest",
                    "Parkour Training"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                wait(0.1)

                local args = {
                    "GetQuestProgress",
                    "Parkour Training",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            else
                local args = {
                    "GetQuestProgress",
                    "Parkour Training",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                Notify("Not possible", "No Training Bells found.",2.5,"info")
            end
        elseif selectedquest == "Shark Girl" then

            local args = {
                [1] = "StartQuest",
                [2] = "A Run For Your Life"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            if workspace:FindFirstChild("The Scarlet Slowcoach") then
                if plr.Character.HumanoidRootPart then
                    for i, v in pairs(plr.Character:GetChildren()) do
                        if v:IsA("BasePart") and v.CanCollide == true then
                            v.CanCollide = false
                        end
                    end

                    wait(0.05)
                    if workspace.RiverGearsActivation.Activated.Value == true then
                        plr.Character.HumanoidRootPart.CFrame = CFrame.new(212.77771, -53.8684158, -814.37439, -0.99941355, 5.63199869e-08, -0.0342424773, 5.71334766e-08, 1, -2.27783321e-08, 0.0342424773, -2.47213645e-08, -0.99941355)

                        wait(0.05)

                        local args = {
                            [1] = "PlayerEvent",
                            [2] = "TheDeadRunner"
                        }

                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                        wait(0.5)

                        local args = {
                            [1] = "PlayerEvent",
                            [2] = "TheDeadRunner"
                        }

                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    else
                        plr.Character.HumanoidRootPart.CFrame = CFrame.new(372.524658, 27.1627274, -1027.24524, -0.0282121263, -6.83527546e-08, 0.99960196, 7.51098881e-08, 1, 7.04998229e-08, -0.99960196, 7.70689397e-08, -0.0282121263)

                        wait(0.2)

                        local args = {
                            "ActivateButton",
                            workspace:WaitForChild("RiverGearsActivation")
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        wait(0.4)
                    end

                    plr.Character.HumanoidRootPart.CFrame = startpos
                end
            else
                Notify("The Quest", "has already been completed.", 2, "info")
            end


        elseif selectedquest == "Golem" then
            if tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text) < 120 then
                Notify("Requirements not met.", "You need to have at least 120 Ryo",2.5,"info")
                return
            end

            local args = {
                "StartQuest",
                "Search For A Flaming Heart"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)

            local args = {
                [1] = "Pay",
                [2] = 0,
                [3] = "Flaming Heart",
                [4] = 1,
                [5] = workspace:WaitForChild("Medic"):WaitForChild("HumanoidRootPart")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)
            
            local args = {
                "GetQuestProgress",
                "Search For A Flaming Heart"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))


        elseif selectedquest == "Oasis" then

            local mangothere = false

            if tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text) < 15 then
                Notify("Requirements not met.", "You need to have at least 15 Ryo",2.5,"info")
                return
            end

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Mango" then
                    local mangostr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    local mangoint =  tonumber(string.sub(mangostr, 2))
                    if mangoint then
                        if  mangoint > 2 then
                            mangothere = true
                            break
                        end
                    end
                end
            end

            if mangothere == false then
                Notify("Requirements not met.", "You need to have at least 3 Mangos",2.5,"info")
                return
            end

            
            local args = {
                [1] = "Pay",
                [3] = "Chicken",
                [4] = 2
            }
                        
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))


            local args = {
                "StartQuest",
                "An Extravagant Dish"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                [1] = "Pay",
                [3] = "Bowl",
                [4] = 1
            }
                        
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            wait(0.1)

            local args = {
                "PlaceBowl",
                workspace:WaitForChild("BowlHolderHallow")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Mango"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            wait(0.1)

            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Mango"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            wait(0.1)
            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Mango"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            wait(0.1)
            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Chicken"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            wait(0.1)
            
            local args = {
                "AddFruit",
                workspace:WaitForChild("FruitCookerHallow"):WaitForChild("CookingWater"),
                "Chicken"
                }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

            wait(0.1)

            local args = {
                "BowlFinish",
                workspace:WaitForChild("BowlHolderHallow"):WaitForChild("BowlFinish")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
            
            local args = {
                "GetQuestProgress",
                "An Extravagant Dish",
                "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
        elseif selectedquest == "Pickpocket" then
            -- Incase player already has mask in inventory

            local args = {
                "StartQuest",
                "Relic Retrieval"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                "GetQuestProgress",
                "Relic Retrieval",
                "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            if plr.Character.HumanoidRootPart then
                if workspace["Biyo Relic"] and workspace["Biyo Relic"].Transparency == 0 then
                    startpos = plr.Character.HumanoidRootPart.CFrame
                    local args = {
                        "StartQuest",
                        "Relic Retrieval"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                    
                    plr.Character.HumanoidRootPart.CFrame = CFrame.new(-607.182617, -188.449982, -549.910706, 0.99977237, 1.22664998e-08, -0.0213369261, -1.12036309e-08, 1, 4.9933135e-08, 0.0213369261, -4.96827148e-08, 0.99977237)
                    
                    local args = {
                        "Relic",
                        "Biyo Relic"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                    local mask = workspace["Biyo Relic"]
                    local timeout = 1.5
                    local startTime = tick()

                    while mask and mask.Transparency == 0 and tick() - startTime < timeout do
                        task.wait()
                        local args = {
                            "Relic",
                            "Biyo Relic"
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                        
                    end

                    plr.Character.HumanoidRootPart.CFrame = startpos

                    local args = {
                        "GetQuestProgress",
                        "Relic Retrieval",
                        "DontComplete"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                    plr.Character.HumanoidRootPart.CFrame = startpos
                else
                    Notify("Mask not found","",1.5,"info")
                end
            end

        elseif selectedquest == "Lavarossa" then
            -- if the player already has the horns
            local args = {
                "StartQuest",
                "Humbling Lavarossa"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                "GetQuestProgress",
                "Humbling Lavarossa",
                "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local pickpocketinventory = false

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Pickpocket" then
                    pickpocketinventory = true
                    break
                end
            end

            local function TakeHorns()
                for i, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Lavarossa" and v:FindFirstChild("Horns").Transparency == 0 and v:FindFirstChild("Head") then
                        while workspace.Lavarossa.Horns.Transparency == 0 and plr.Character do
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Lavarossa.Head.CFrame

                            local args = {
                                "startSkill",
                                "Pickpocket",
                                vector.create(-730.5443115234375, -210.14356994628906, -553),
                                true
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                            local args = {
                                "ReleaseSkill"
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                            wait()
                        end
                        break
                    end
                end

                local args = {
                    "GetQuestProgress",
                    "Humbling Lavarossa",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                plr.Character.HumanoidRootPart.CFrame = startpos
            end

            if pickpocketinventory == true then
                if workspace:FindFirstChild("Lavarossa") and workspace.Lavarossa:FindFirstChild("Head") then
                    if workspace.Lavarossa.Horns.Transparency == 1 then
                        Notify("Boss doesn't have any horns.","",1.5,"info")
                        return
                    else
                        TakeHorns()
                    end
                else
                    -- Spawning the Boss
                    if workspace.LavarossaRewards.Part.Transparency == 1 then
                        if Teleport(CFrame.new(-536.194763, -314.055023, -201.574188, -0.159694523, 4.51376314e-09, 0.987166464, 4.54713767e-11, 1, -4.56508786e-09, -0.987166464, -6.84131751e-10, -0.159694523)) == false then return end
                        
                        wait(0.25)

                        local args = {
                            [1] = "activateLavarossa"
                        }
                            
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))

                        plr.Character.Humanoid.Jump = true

                        wait(0.5)

                        plr.Character.HumanoidRootPart.CFrame = CFrame.new(-18.8846588, -278.715057, -482.883179, 0.000202000956, 1.24929542e-07, 1, 4.71037964e-09, 1, -1.24930494e-07, -1, 4.73561546e-09, 0.000202000956)
                        
                        wait(1.5)

                        TakeHorns()

                        plr.Character.HumanoidRootPart.CFrame = startpos
                    else
                        Notify("Boss has already been killed.", "Try again later.",2,"info")
                    end
                end
            else 
                Notify("Missing Requirements.", "You need to have Pickpocket.",2,"info")
            end

        elseif selectedquest == "Bolive Crops" then
            local args = {
                "StartQuest",
                "Bolive Retrieval"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)


            -- Check if 5 crops in inventory
            local bolivethere = false
            local orangeint = 0

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Bolive Crops" then
                    local orangestr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    orangeint = tonumber(string.sub(orangestr, 2))
                    if orangeint > 4 then
                        bolivethere = true
                        break
                    end
                end
            end

            if bolivethere then
                local args = {
                    "GetQuestProgress",
                    "Bolive Retrieval",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                return
            end

            -- Check for available crops
            local bolivecropscounter = 0

            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Bolive Crops" and v.Transparency == 0 then
                    bolivecropscounter += 1
                end
            end

            local neededcrops = 5 - orangeint
            if bolivecropscounter < neededcrops then
                Notify("Missing requirements", "No Bolive Crops Available.", 2.5, "info")
                return
            end

            local function nocliploop()
                for i, v in pairs(plr.Character:GetChildren()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false
                    end
                end
            end

            noclippingcrop = RunService.Stepped:Connect(nocliploop)

            local pickedCropsCount = 0


            -- Water crops until enough obtained
            for i, v in pairs(workspace:GetChildren()) do
                if neededcrops <= 0 then break end
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Bolive Crops" and v.Transparency == 0 then
                    watercrops(v, 1)
                    neededcrops -= 1
                    wait()
                end
            end

            -- Disconnect noclip loop immediately after watering
            if noclippingcrop then
                noclippingcrop:Disconnect()
            end

            -- Wait until picked enough crops or timeout after 20 seconds
            local timeout = tick() + 20
            repeat
                wait(0.5)
            until pickedCropsCount >= (5 - orangeint) or tick() > timeout

            -- Final quest progress update
            wait(0.2)

            game:GetService("ReplicatedStorage").Events.DataFunction:InvokeServer("GetQuestProgress", "Bolive Retrieval", "DontComplete")


        elseif selectedquest == "Chakra Crops" then

            local args = {
                "StartQuest",
                "Search For The Chakra Crops"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            wait(0.1)

            -- Check if 5 crops in inventory
            local chakrathere = false
            local chakraint = 0

            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Chakra Crops" then
                    local chakrastr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    chakraint = tonumber(string.sub(chakrastr, 2))
                    if chakraint > 4 then
                        chakrathere = true
                        break
                    end
                end
            end

            if chakrathere then
                local args = {
                    "GetQuestProgress",
                    "Search For The Chakra Crops",
                    "DontComplete"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                return
            end

            -- Check available crops
            local chakracropscounter = 0

            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Chakra Crops" and v.Transparency == 0 then
                    chakracropscounter += 1
                end
            end

            local neededcrops = 5 - chakraint
            if chakracropscounter < neededcrops then
                Notify("Missing requirements", "No Chakra Crops Available.", 2.5, "info")
                return
            end

            local function nocliploop()
                for i, v in pairs(plr.Character:GetChildren()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false
                    end
                end
            end

            noclippingcrop = RunService.Stepped:Connect(nocliploop)

            local pickedCropsCount = 0


            -- Water crops until enough obtained
            for i, v in pairs(workspace:GetChildren()) do
                if neededcrops <= 0 then break end
                if v.Name == "Crops" and v:FindFirstChild("CropType") and v.CropType.Value == "Chakra Crops" and v.Transparency == 0 then
                    watercrops(v, 1)
                    neededcrops -= 1
                    wait()
                end
            end

            -- Disconnect noclip loop after watering
            if noclippingcrop then
                noclippingcrop:Disconnect()
                noclippingcrop = nil
            end

            -- Wait until picked enough crops or timeout after 20 seconds
            local timeout = tick() + 20
            repeat
                wait(0.5)
            until pickedCropsCount >= (5 - chakraint) or tick() > timeout
            -- Final quest progress update
            game:GetService("ReplicatedStorage").Events.DataFunction:InvokeServer("GetQuestProgress", "Search For The Chakra Crops", "DontComplete")


        elseif selectedquest == "Thirsty Hoshi" then
            local waterbowlthere = false
            local orangeint = 0
            
            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Freshwater Bowl" then
                    local orangestr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    orangeint =  tonumber(string.sub(orangestr, 2))
                    if orangeint > 0 then
                        waterbowlthere = true
                        break
                    end
                end
            end

            if waterbowlthere then
                    local args = {
                    [1] = "StartQuest",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                local args = {
                    [1] = "GetQuestProgress",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                return
            end

            local bowlthere = false
            local orangeint = 0
            
            for i, v in pairs(plr:FindFirstChild("PlayerGui").ClientGui.Mainframe.Loadout:GetDescendants()) do
                if v.Name == "SlotText" and v.Text == "Bowl" then
                    local orangestr = v.Parent:FindFirstChild("ItemNumber"):FindFirstChild("Number").Text
                    orangeint =  tonumber(string.sub(orangestr, 2))
                    if orangeint > 0 then
                        bowlthere = true
                        break
                    end
                end
            end
            
            local function usebowl()
                local args = {
                    "Item",
                    "Selected",
                    "Bowl"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer(unpack(args))
                    
                wait(0.2)
                
                local args = {
                    "FreshwaterBowl"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
                
                wait(0.2)

                local args = {
                    [1] = "StartQuest",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                local args = {
                    [1] = "GetQuestProgress",
                    [2] = "Quenching Thirst"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            end
            
            if bowlthere then
                usebowl()
            else
                if tonumber(plr.PlayerGui.ClientGui.Mainframe.Ryo.Amount.Text) < 3 then
                    Notify("Missing requirements", "Missing 3 Ryo",2,"info")
                    return
                else
                    local args = {
                        [1] = "Pay",
                        [2] = 0,
                        [3] = "Bowl",
                        [4] = 1,
                        [5] = workspace:WaitForChild("TorchMesh")
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

                    wait(0.3)

                    usebowl()
                end
            end
        elseif selectedquest == "Mail" then
            Teleport(CFrame.new(-668.973816, -194.109985, -268.560547, 0.0070860046, 2.33984299e-08, -0.999974906, -2.25259669e-08, 1, 2.32393944e-08, 0.999974906, 2.23607266e-08, 0.0070860046), true)

            local args = {
                [1] = "StartQuest",
                [2] = "InnKeeper's Reunion"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                [1] = "GetQuestProgress",
                [2] = "InnKeeper's Reunion",
                [3] = "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            wait(0.5)

            Teleport(CFrame.new(-36.1317406, -189.715057, -206.712875, 0.030850267, 9.54886659e-08, -0.999523997, 3.90593513e-08, 1, 9.67396971e-08, 0.999523997, -4.20252029e-08, 0.030850267), true)

            local args = {
                [1] = "StartQuest",
                [2] = "InnKeeper's Reunion"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))

            local args = {
                [1] = "GetQuestProgress",
                [2] = "InnKeeper's Reunion",
                [3] = "DontComplete"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
            
            wait(0.5)

            Teleport(startpos, true)
        end
    end
end

features.ReturnMenu = function()
    TS:Teleport(5571328985)
end




--[[

__________                 _____.__       .__       .___   ________                 ____ 
\______   \_____  ___.__._/ ____\__| ____ |  |    __| _/  /  _____/  ____   ____   /_   |
 |       _/\__  \<   |  |\   __\|  |/ __ \|  |   / __ |  /   \  ____/ __ \ /    \   |   |
 |    |   \ / __ \\___  | |  |  |  \  ___/|  |__/ /_/ |  \    \_\  \  ___/|   |  \  |   |
 |____|_  /(____  / ____| |__|  |__|\___  >____/\____ |   \______  /\___  >___|  /  |___|
        \/      \/\/                    \/           \/          \/     \/     \/        

--]]

local Window = Rayfield:CreateWindow({
    Name = "Tact Bloodlines",
    Icon = 0,
    LoadingTitle = "Tact Bloodlines",
    LoadingSubtitle = "",
    Theme = {
        TextColor = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(15, 15, 25),
        Topbar = Color3.fromRGB(30, 20, 45),
        Shadow = Color3.fromRGB(0, 0, 0),
        NotificationBackground = Color3.fromRGB(30, 20, 45),
        NotificationActionsBackground = Color3.fromRGB(40, 30, 55),
        TabBackground = Color3.fromRGB(25, 15, 35),
        TabStroke = Color3.fromRGB(60, 40, 80),
        TabBackgroundSelected = Color3.fromRGB(100, 60, 150),
        TabTextColor = Color3.fromRGB(200, 180, 220),
        SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(20, 12, 30),
        ElementBackgroundHover = Color3.fromRGB(35, 25, 50),
        SecondaryElementBackground = Color3.fromRGB(25, 18, 35),
        ElementStroke = Color3.fromRGB(60, 40, 80),
        SecondaryElementStroke = Color3.fromRGB(70, 50, 90),
        SliderBackground = Color3.fromRGB(40, 30, 55),
        SliderProgress = Color3.fromRGB(120, 70, 180),
        SliderStroke = Color3.fromRGB(80, 50, 120),
        ToggleBackground = Color3.fromRGB(25, 15, 35),
        ToggleEnabled = Color3.fromRGB(100, 60, 150),
        ToggleDisabled = Color3.fromRGB(40, 30, 50),
        ToggleEnabledStroke = Color3.fromRGB(120, 80, 170),
        ToggleDisabledStroke = Color3.fromRGB(50, 40, 60),
        ToggleEnabledOuterStroke = Color3.fromRGB(140, 100, 190),
        ToggleDisabledOuterStroke = Color3.fromRGB(30, 25, 40),
        DropdownSelected = Color3.fromRGB(100, 60, 150),
        DropdownUnselected = Color3.fromRGB(25, 15, 35),
        InputBackground = Color3.fromRGB(20, 12, 30),
        InputStroke = Color3.fromRGB(60, 40, 80),
        PlaceholderColor = Color3.fromRGB(150, 130, 170)
    },

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "TactHub",
      FileName = "Configs_" .. plr.Name
   },

   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = false
   },

   KeySystem = false
})

local MainTab = Window:CreateTab("Main","layout-grid")
local MiscTab = Window:CreateTab("Misc","toggle-right")
local AutoTab = Window:CreateTab("Auto","trending-up")
local TeleportsTab = Window:CreateTab("Teleports","map-pinned")
local FarmsTab = Window:CreateTab("Farms","wheat")
local ESPTab = Window:CreateTab("ESP","eye")
local SecurityTab = Window:CreateTab("Security","shield")
local Settings = Window:CreateTab("Settings","cog")

-- compatibility alias for existing code references
local ProgTab = AutoTab

--[[

               .__         ___________     ___.    
  _____ _____  |__| ____   \__    ___/____ \_ |__  
 /     \\__  \ |  |/    \    |    |  \__  \ | __ \ 
|  Y Y  \/ __ \|  |   |  \   |    |   / __ \| \_\ \
|__|_|  (____  /__|___|  /   |____|  (____  /___  /
      \/     \/        \/                 \/    \/ 
--]]
-----------------------
MainTab:CreateSection("Movement")
-----------------------

MainTab:CreateToggle({
    Name = "Search for Object/NPC",
    CurrentValue = false,
    Flag = "Search for NPC/Object", 
    Callback = function(Value)
        searchingforobj = Value
        spawn(function()
            features.SearchObj()
        end)
    end,
})

MainTab:CreateDropdown({
     Name = "Select Object/NPC to search for",
     Options = {"Shukaku", "Thunderstorm", "Beast Tamer", "Matatabi"},
     CurrentOption = {"None"},
     MultipleOptions = false,
     Flag = "SelectedSearchObj",
     Callback = function(CurrentValue)
         selectedsearchobject = CurrentValue[1]
     end,
})

MainTab:CreateToggle({
    Name = "Enable Noclip",
    CurrentValue = false,
    Callback = function(Value)
       noclipenabled = Value
       features.Noclip()
    end,
 })

MainTab:CreateToggle({
   Name = "Enable WalkSpeed",
   CurrentValue = false,
   Callback = function(Value)
        walkspeed_enabled = Value
       if Value == false then
            local plr = game.Players.LocalPlayer
            local plrCharacter = plr.Character
            local plrHumanoid = plrCharacter:FindFirstChildOfClass("Humanoid")
            plrHumanoid.WalkSpeed = 16
       end
   end,
})

MainTab:CreateToggle({
    Name = "Enable Flight",
    CurrentValue = false,
    Callback = function(Value)
        features.toggleFlight()
    end,
 })

-----------------------
MainTab:CreateDivider()
-----------------------

MainTab:CreateSlider({
    Name = "Set WalkSpeed",
    Range = {0, 300},
    Increment = 1,
    Suffix = "",
    CurrentValue = 100,
    Flag = "WalkSpeedAmount",
    Callback = function(Value)
        walkspeed_modified = Value
    end,
 })
 
MainTab:CreateSlider({
    Name = "Set Flight Speed",
   Range = {0, 300},
   Increment = 1,
   Suffix = "",
   CurrentValue = 100,
   Flag = "FlySpeedAmount", 
   Callback = function(Value)
        flightSpeed = Value
   end,
})

-----------------------
MainTab:CreateSection("Combat")
-----------------------

--[[
MainTab:CreateToggle({
    Name = "Auto Parry",
    CurrentValue = false,
    Flag = "Toogle5", 
    Callback = function(Value)
     autoparrying = Value
     features.AutoParry()
    end,
 })
]]--

 MainTab:CreateToggle({
    Name = "Chakra Regen Boost",
    CurrentValue = false,
    Flag = "BossChakraToggle", 
    Callback = function(Value)
        buffingchakra = Value
        features.Buffchakraregen()
    end,
 })

MainTab:CreateSlider({
    Name = "Select Buff Stage",
   Range = {1,3},
   Increment = 1,
   Suffix = "",
   CurrentValue = 0,
   Flag = "ChakraBuffAmount", 
   Callback = function(Value)
        chakrabuffamount = Value
   end,
})

-----------------------
MainTab:CreateDivider()
-----------------------

MainTab:CreateToggle({
    Name = "Extend Certain Hitboxes",
    CurrentValue = false,
    Flag = "ExtendHitboxToggle", 
    Callback = function(Value)
     hitboxextending = Value
     features.HitboxExtend()
    end,
 })

MainTab:CreateSlider({
    Name = "Hitbox Size [Studs]",
   Range = {8, 18},
   Increment = 1,
   Suffix = "",
   CurrentValue = 0,
   Flag = "HitboxSizeAmount",
   Callback = function(Value)
        hitboxstud = Value
   end,
})

MainTab:CreateButton({
    Name = "Replicate Hitbox",
     Callback = function()
        local hbsize = 0
        if hitboxstud == nil then
            hbsize = 16
        else
            hbsize = hitboxstud * 2
        end

        if plr.Character and plr.Character.HumanoidRootPart then

            local hitbox = Instance.new("Part")
            hitbox.Name = "Hitbox"
            hitbox.Material = Enum.Material.SmoothPlastic
            hitbox.BrickColor = BrickColor.new("Really red")
            hitbox.Size = Vector3.new(hbsize,hbsize,hbsize)
            hitbox.Transparency = 0.5
            hitbox.Anchored = false
            hitbox.CanCollide = false
            hitbox.Shape = Enum.PartType.Ball
            hitbox.CFrame = plr.Character.HumanoidRootPart.CFrame
            hitbox.Parent = workspace
            hitbox.CanTouch = false
            hitbox.Anchored = true

            game:GetService("Debris"):AddItem(hitbox, 5)
        end
    end
})

-----------------------
MainTab:CreateDivider()
-----------------------
--[[
MainTab:CreateToggle({
    Name = "Enable Agile Dash",
    CurrentValue = false,
    Flag = "Toogle5", 
    Callback = function(Value)
     agiletraitenabled = Value
     features.AgileTrait()
    end,
 })
--]]

MainTab:CreateToggle({
    Name = "Remove Blindness",
    CurrentValue = false,
    Flag = "BlindnessToggle", 
    Callback = function(Value)
        blindremoved = Value
        features.Disableblind()
    end,
 })

MainTab:CreateToggle({
    Name = "Disable Client Stun",
    CurrentValue = false,
    Flag = "ClientStunToggle", 
    Callback = function(Value)
        disabledstun = Value
        features.Nostun()
    end,
 })


--[[

        .__                ___________     ___.    
  _____ |__| ______ ____   \__    ___/____ \_ |__  
 /     \|  |/  ___// ___\    |    |  \__  \ | __ \ 
|  Y Y  \  |\___ \\  \___    |    |   / __ \| \_\ \
|__|_|  /__/____  >\___  >   |____|  (____  /___  /
      \/        \/     \/                 \/    \/ 
--]]

MiscTab:CreateSection("Miscellanious")

MiscTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Flag = "AntiVoidToggle",
   Callback = function(Value)
    voiddisabled = Value
    features.Disabledvoid()
   end,
})

MiscTab:CreateToggle({
    Name = "No Fall Damage",
    CurrentValue = false,
    Flag = "NoFallDamageToggle", 
    Callback = function(Value)
        if Value == true then
            NoFallDammage.Value = true
            falldamageundisable = NoFallDammage.Changed:Connect(function()
                if NoFallDammage.Value == false then
                    NoFallDammage.Value = true
                end
            end)
        else
            if falldamageundisable then
                falldamageundisable:Disconnect()
            end
            NoFallDammage.Value = false
        end
    end,
 })

MiscTab:CreateToggle({
    Name = "No Visual Effects/Rain",
    CurrentValue = false,
    Flag = "NoVisualEffectToggle", 
    Callback = function(Value)
     NoFog = Value
    end,
 })

MiscTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "InfStaminaToggle", 
    Callback = function(Value)
        infinitestamina = Value
    end,
 })

MiscTab:CreateToggle({
    Name = "Auto Collect Items",
    CurrentValue = false,
    Flag = "AutoCollectItemsToggle", 
    Callback = function(Value)
     autopickupenabled = Value
     features.Autopick()
    end,
 })

MiscTab:CreateToggle({
    Name = "Auto Sell Gems",
    CurrentValue = false,
    Flag = "AutoSellGemsToggle", 
    Callback = function(Value)
     sellinggems = Value
        spawn(function()
        features.AutoSellGems()
        end)
    end,
 })

if game:GetService("RbxAnalyticsService"):GetClientId() == "7DC20B8F-319A-460D-AFE3-8E62FA20CB27" then
    MiscTab:CreateToggle({
    Name = "Infinite M1ing",
    CurrentValue = false,
    Flag = "InfM1PassiveToggle", 
    Callback = function(Value)
     infinitem1ing = Value
        spawn(function()
            features.infinitem1()
        end)
    end,
    })
end

 -----------------------
MiscTab:CreateDivider()
 -----------------------

MiscTab:CreateButton({
    Name = "Goto Clickable Item",
     Callback = function()
        features.PickUpClickDetectors()
    end
})

MiscTab:CreateButton({
    Name = "Reset Sins",
     Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack({"Pay",0,"Sins",1}))
    end
 })

MiscTab:CreateButton({
    Name = "Purchase Random Accessory",
     Callback = function()
        local args = {
            [1] = "Pay",
            [2] = 0,
            [3] = "NewAccessory",
            [4] = 1,
            [5] = workspace:WaitForChild("TorchMesh")

        }
                
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
    end
 })

MiscTab:CreateButton({
    Name = "Unlock Burrow",
     Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("UnlockSkill", "Burrow")
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("UnlockSkill", "Burrow Teleport")
    end
 })


MiscTab:CreateButton({
    Name = "Instant Reset",
     Callback = function()
        features.Reset()
    end
 })

 -----------------------
MiscTab:CreateSection("Stealing")
 -----------------------

MiscTab:CreateToggle({
    Name = "Steal Dropped Items Aura",
    CurrentValue = false,
    Flag = "StealDroppedItemsToggle", 
    Callback = function(Value)
        stealingitems = Value
        features.StealDroppedItems()
    end,
 })

MiscTab:CreateToggle({
    Name = "Teleport to detected Item",
    CurrentValue = false,
    Flag = "StealDroppedItemsTPToggle", 
    Callback = function(Value)
        stealingitemswithtp = Value
    end,
 })

 -----------------------
MiscTab:CreateDivider()
 -----------------------

MiscTab:CreateToggle({
    Name = "Ambush Target Player Items",
    CurrentValue = false,
    Flag = "AmbushDroppedItemsToggle", 
    Callback = function(Value)
        stealingitemsadv = Value
        spawn(function()
            features.StealDroppedItemsAdv()
        end)
    end,
 })

 -----------------------
MiscTab:CreateSection("Events")
 -----------------------

MiscTab:CreateToggle({
    Name = "Event Notifier",
    CurrentValue = false,
    Flag = "EventNotifierToggle", 
    Callback = function(Value)
    EventNotifyactive = Value
     features.EventNotify()
    end,
 })

MiscTab:CreateToggle({
    Name = "Ignore Chakra Points",
    CurrentValue = false,
    Flag = "IgnoreChakraPointsToggle", 
    Callback = function(Value)
        ignorepoints = Value
    end,
})

MiscTab:CreateSection("")

--[[
___________                           __    __             .___ _________               ___.           __ 
\__    ___/____ _______  ____   _____/  |__/  |_  ____   __| _/ \_   ___ \  ____   _____\_ |__ _____ _/  |
  |    |  \__  \\_  __ \/ ___\_/ __ \   __\   __\/ __ \ / __ |  /    \  \/ /  _ \ /     \| __ \\__  \\   __\
  |    |   / __ \|  | \/ /_/  >  ___/|  |  |  | \  ___// /_/ |  \     \___(  <_> )  Y Y  \ \_\ \/ __ \|  |
  |____|  (____  /__|  \___  / \___  >__|  |__|  \___  >____ |   \______  /\____/|__|_|  /___  (____  /__|
               \/     /_____/      \/                \/     \/          \/             \/    \/     \/                 
--]]

 -----------------------
MainTab:CreateSection("Targetted Combat")
-----------------------

local TargetInformation = MainTab:CreateParagraph({Title = "Selected: None", Content = ""})

MainTab:CreateButton({
    Name = "Select Player",
     Callback = function(Text)
        features.SelectPlayer()
    end
 })
 
While.Heartbeat:Connect(function()
    if TargetPlayer ~= nil and TargetPlayer.Parent ~= nil then

        if TargetPlayer.Parent == nil then
            TargetPlayer = nil
        end

        local data = game:GetService("ReplicatedStorage").Settings:FindFirstChild(TargetPlayer.Name)
        local cooldowns = game:GetService("ReplicatedStorage").Cooldowns

        local targetplrCooldowns = cooldowns:FindFirstChild(TargetPlayer.Name)
        local TargetChr = TargetPlayer.Character
        local TargetHumanoid= TargetChr:FindFirstChildOfClass("Humanoid")

        local health = "Unknown"
        local hasChakraSense = false
        local knocked = data:FindFirstChild("Knocked")
        local currentWeapon = data:FindFirstChild("CurrentWeapon")

        local BloodlinesName = TargetHumanoid.DisplayName

        if targetplrCooldowns:FindFirstChild("Chakra Sense") then
            hasChakraSense = true
        else
            hasChakraSense = false
        end

        local infotext = ""
        local Traits = TargetChr:FindFirstChild("Traits")
        local Clan = data:FindFirstChild("Bloodline")
        local CLink = #Traits:GetChildren() * 25

        if Clan then
            infotext = infotext.."<font color='rgb(255, 221, 28)'>" .. Clan.Value .. "</font>"
        end

        if Traits then
            if #Traits:GetChildren() < 2 then
                infotext = infotext .. "\n<font color='rgb(0, 204, 255)'>" .. CLink .. "% Chakra Link </font>" .. "<font color='rgb(59, 255, 216)'>[Freshie]</font>"
            else
                infotext = infotext.."\n<font color='rgb(0, 204, 255)'>" .. CLink .."% Chakra Link </font>"
            end
        end

        local Humanoid = TargetChr:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            health = "\n<font color='rgb(80, 255, 80)'>" .. math.floor(Humanoid.Health) .. " HP</font>"
        end

        infotext = infotext..health

        if currentWeapon then
            infotext = infotext.."\n<font color='rgb(199, 199, 199)'>Weapon: "..currentWeapon.Value.."</font>"
        end
        if hasChakraSense then
            infotext = infotext.."\n<font color='rgb(108, 74, 136)'>Chakra Sense</font>"
        end
        if knocked.Value then
            infotext = infotext.."\n<font color='rgb(255, 25, 25)'>Knocked</font>"
        end

        if CLink > 0 then
            local traitsList = {}
            infotext = infotext.. "\n<font color='rgb(255, 182, 135)'>Traits: </font>"
            for _, trait in pairs(Traits:GetChildren()) do
                table.insert(traitsList, "<font color='rgb(255, 182, 135)'>" .. tostring(trait.Name) .. "</font>")
            end
            infotext = infotext .. table.concat(traitsList, ", ")
        end

        TargetInformation:Set({Title = BloodlinesName.." | "..TargetPlayer.Name, Content = infotext})
    else
        TargetInformation:Set({Title = "Selected: None", Content = "N/A"})
    end
end)

-----------------------
MainTab:CreateDivider()
-----------------------

MainTab:CreateButton({
    Name = "Goto",
     Callback = function()
        if plr.Character and plr.Character.HumanoidRootPart then
            plr.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
 })

MainTab:CreateButton({
    Name = "Instant Void",
     Callback = function()
        features.InstantVoid()
    end
 })

MainTab:CreateToggle({
    Name = "Lock Camera",
    CurrentValue = false,
    Flag = "Toogle7", 
    Callback = function(Value)
        lockingcamera = Value
        features.LockCamera()
    end,
 })

if game:GetService("RbxAnalyticsService"):GetClientId() == "349CF459-DC15-45C4-901B-A65F91ED2344" or game:GetService("RbxAnalyticsService"):GetClientId() == "8128D4F5-E2ED-46FE-8A56-91C3AE7D3B27" or game:GetService("RbxAnalyticsService"):GetClientId() == "7DC20B8F-319A-460D-AFE3-8E62FA20CB27" then
    MainTab:CreateToggle({
        Name = "Farm Player",
        CurrentValue = false,
        Flag = "farmplayer toggle", 
        Callback = function(Value)
            farmingplayer = Value
            features.FarmPlayer()
        end,
    })
end

MainTab:CreateSection("")

 --[[

___________                             ___________     ___.    
\_   _____/____ _______  _____   ______ \__    ___/____ \_ |__  
 |    __) \__  \\_  __ \/     \ /  ___/   |    |  \__  \ | __ \ 
 |     \   / __ \|  | \/  Y Y  \\___ \    |    |   / __ \| \_\ \
 \___  /  (____  /__|  |__|_|  /____  >   |____|  (____  /___  /
     \/        \/            \/     \/                 \/    \/ 

--]]

--------------------------------
FarmsTab:CreateSection("Bosses")
--------------------------------

FarmsTab:CreateToggle({
    Name = "Farm Bosses 🔹",
    CurrentValue = false,
    Flag = "FarmBossesToggle", 
    Callback = function(Value)
        bossfarmactive.Value = Value
        spawn(function()
            features.Killboss()
        end)
    end,
 })

FarmsTab:CreateDropdown({
    Name = "Select Bosses",
    Options = {"Wooden Golem","Hyuga Boss", "Shukaku","Matatabi","Tairock","Chakra Knight","Lavarossa","Manda","Lava Snake", "The Ringed Samurai", "Barbarit The Rose"},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "SelectedBossesTable",
    Callback = function(CurrentValue)
        selectedbosses = CurrentValue
    end,
 })
 
FarmsTab:CreateToggle({
    Name = "Infinite M1s (only Tai/Fist)",
    CurrentValue = false,
    Flag = "InfiniteM1sToggle", 
    Callback = function(Value)
        nocooldownm1 = Value
    end,
 })

FarmsTab:CreateToggle({
    Name = "Auto Equip Weapon",
    CurrentValue = false,
    Flag = "AutoEquipWeapon",
    Callback = function(Value)
        autoequipweapon = Value
    end,
 })

FarmsTab:CreateToggle({
    Name = "Trigger Last Stand Trait",
    CurrentValue = false,
    Flag = "TriggerLastStandTraitToggle",
    Callback = function(Value)
        laststandactive = Value
    end,
 })

FarmsTab:CreateToggle({
    Name = "Serverhop when Bosses dead",
    CurrentValue = false,
    Flag = "Hop if no Boss",
    Callback = function(Value)
        serverhopnoboss = Value
    end,
 })

-----------------------
FarmsTab:CreateSection("Christmas Event")
-----------------------

FarmsTab:CreateToggle({
    Name = "Christmas Farm (Frosted The Rose) 🔹",
    CurrentValue = false,
    Flag = "ChristmasFarmToggle", 
    Callback = function(Value)
        christmasfarmactive.Value = Value
        spawn(function()
            features.ChristmasFarm()
        end)
    end,
 })

FarmsTab:CreateToggle({
    Name = "Infinite M1s (only Tai/Fist)",
    CurrentValue = false,
    Flag = "ChristmasInfiniteM1sToggle", 
    Callback = function(Value)
        nocooldownm1 = Value
    end,
 })

FarmsTab:CreateToggle({
    Name = "Auto Equip Weapon",
    CurrentValue = false,
    Flag = "ChristmasAutoEquipWeapon",
    Callback = function(Value)
        autoequipweapon = Value
    end,
 })

FarmsTab:CreateToggle({
    Name = "Serverhop when Bosses dead",
    CurrentValue = false,
    Flag = "ChristmasHopIfNoBoss",
    Callback = function(Value)
        serverhopnoboss = Value
    end,
 })

-----------------------
FarmsTab:CreateSection("Tree Hopping")
-----------------------

FarmsTab:CreateToggle({
     Name = "Enable Tree Hopping 🔹",
     CurrentValue = false,
     Flag = "TreeHoppingToggle", 
      Callback = function(Value)
        treehopping.Value = Value
        spawn(function()
            features.Treehop()
        end)
     end
  })

FarmsTab:CreateToggle({
     Name = "Only Hop Selected Fruit Type Trees",
     CurrentValue = false,
     Flag = "OnlyHopFruitTypesToggle", 
      Callback = function(Value)
        onlyhopselectedfruittypes = Value
     end
  })

FarmsTab:CreateDropdown({
     Name = "Whitelisted Fruits",
     Options = {"All","Life / Forgetfulness Fruit","Chakra Fruit","Orange","Alluring Apple","Apple", "Mango", "Banana", "Pear"},
     CurrentOption = {"None"},
     MultipleOptions = true,
     Flag = "WhitelistedFruitsTable",
     Callback = function(CurrentValue)
         selectedfruits = CurrentValue
     end,
  })

--------------------------------
FarmsTab:CreateSection("Ryo")
--------------------------------

FarmsTab:CreateToggle({
    Name = "Auto Farm Ryo 🔹",
    CurrentValue = false,
    Flag = "AutoFarmRyoToggle", 
    Callback = function(Value)
        Ryofarming.Value = Value
        spawn(function()
            features.RyoFarm()
        end)
    end,
})

FarmsTab:CreateInput({
    Name = "Stop At Selected Amount",
    CurrentValue = "",
    PlaceholderText = "Ryo",
    RemoveTextAfterFocusLost = false,
    Flag = "StopSelectedRyoAmount",
    Callback = function(Text)
        desiredRyoamount = tonumber(Text)
    end,
 })

 --[[
--------------------------------
FarmsTab:CreateSection("Acumen")
--------------------------------

FarmsTab:CreateToggle({
    Name = "Farm Acumen",
    CurrentValue = false,
    Flag = "", 
    Callback = function(Value)
        acumenfarming = Value
        features.AcumenFarm()
    end,
})

FarmsTab:CreateToggle({
    Name = "Infinite M1s",
    CurrentValue = false,
    Flag = "", 
    Callback = function(Value)
        nocooldownm1acumen = Value
    end,
})

]]--

--------------------------------
FarmsTab:CreateSection("Jinchuriki")
--------------------------------

FarmsTab:CreateToggle({
    Name = "Auto Seal Matatabi",
    CurrentValue = false,
    Flag = "AutoSealMatabiToggle", 
    Callback = function(Value)
        autosealingmatatabi = Value
        spawn(function()
            features.AutoSealMatatabi()
        end)
    end,
})

--------------------------------
FarmsTab:CreateSection("Activations")
--------------------------------

FarmsTab:CreateToggle({
    Name = "Auto Farm Activations 🔹",
    CurrentValue = false,
    Flag = "AutoActivationsFarmToggle", 
    Callback = function(Value)
        Activationfarm.Value = Value
        spawn(function()
            features.Activationsfarm()
        end)
    end,
})

FarmsTab:CreateInput({
    Name = "Insert Mode/Skill",
    CurrentValue = "",
    PlaceholderText = "Jutsu|Mode",
    RemoveTextAfterFocusLost = false,
    Flag = "InsertedSkillString",
    Callback = function(Text)
        insertedjutsumode = Text
    end,
 })

FarmsTab:CreateToggle({
    Name = "No Reset for Mode",
    CurrentValue = false,
    Flag = "AutoModeNoReset", 
    Callback = function(Value)
        AutoModeNoReset = Value
    end,
})

FarmsTab:CreateSection("")

-----------------------
ProgTab:CreateSection("Progression")
-----------------------

ProgTab:CreateButton({
    Name = "Complete Quest",
     Callback = function()
        features.DoQuest()
    end
 })

ProgTab:CreateDropdown({
    Name = "Select Quest",
    Options = {"Chakra Crops","Passageway", "Crate Delivery", "Flower Bouquet", "Pickpocket","Lavarossa","Oasis","Bolive Crops","Thirsty Hoshi","Bells","Shark Girl","Mail","Golem"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "SelectedQuestString",
    Callback = function(CurrentValue)
    selectedquest = CurrentValue[1]
    end,
 })

-----------------------
ProgTab:CreateSection("Other Stuff")
-----------------------

ProgTab:CreateButton({
    Name = "Goto Missing Point",
     Callback = function()
        features.TPPoints()
    end
 })

ProgTab:CreateButton({
    Name = "Reroll Haircut",
     Callback = function()
        if plr.Character then
            if plr.Character.Traits:FindFirstChild("Stylish") then
                 game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataEvent"):FireServer("FreeHair","NewHair")
            else
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("Pay", 1, "NewHair", 1)
            end
        end
    end
 })

ProgTab:CreateButton({
    Name = "Reroll Hair Color",
     Callback = function()
        if plr.Character then
            local args = {
                "Pay",
                15,
                "NewHairColor",
                1,
                workspace:WaitForChild("TorchMesh")
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer(unpack(args))
        end
    end
 })

ProgTab:CreateButton({
    Name = "Reroll Traits",
     Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("DataFunction"):InvokeServer("TraitReshuffle")
    end
 })

 -----------------------
ProgTab:CreateSection("Character Information")
-----------------------

local datadisplayer = ProgTab:CreateParagraph({
    Title = "Data Inspector",
    Content = "The data you want to view will be displayed here. \n"
})

ProgTab:CreateButton({
    Name = "Display Data",
    Callback = function()
        if selecteddata and #selecteddata > 0 then

            local function nestedTableToString(tbl, indent)
                indent = indent or ""
                local str = ""
                for key, value in pairs(tbl) do
                    if type(value) == "table" then
                        str = str .. indent .. tostring(key) .. ":\n"
                        str = str .. nestedTableToString(value, indent .. "  ")
                    else
                        str = str .. indent .. tostring(key) .. " = " .. tostring(value) .. "\n"
                    end
                end
                return str
            end

            local playerdata = game:GetService("ReplicatedStorage")
                :WaitForChild("Events")
                :WaitForChild("DataFunction")
                :InvokeServer("GetData")

            local datastring = ""
            for _, datatype in ipairs(selecteddata) do
                if datatype ~= "None" then
                    local datavalue = playerdata[datatype]

                    if typeof(datavalue) == "table" then
                        datastring = datastring .. datatype .. ":\n"
                        datastring = datastring .. nestedTableToString(datavalue, "  ") .. "\n"
                    else
                        datastring = datastring .. datatype .. ": " .. tostring(datavalue) .. "\n"
                    end
                end
            end

            datadisplayer:Set({
                Title = "Data Inspector",
                Content = datastring ~= "" and datastring or "Please select at least one data type. \n"
            })
        else
            datadisplayer:Set({
                Title = "Data Inspector",
                Content = "Please select at least one data type. \n"
            })
        end
    end
})

ProgTab:CreateDropdown({
    Name = "Select Data Types",
    Options = {"M1s","Blocks", "Knocks", "BloodExplosions","OppenheimerCount","Grips","PB","Reputation","UsedSkills","WoodXP","WaterXP","EarthXP","ByakuganUsage","MangekyoUsage","SharinganUsage","JinchurikiUsage","GreenGatesUsage","BlueGatesUsage","KetsuryuganUsage","RinneganXP","BugPunches"},
    CurrentOption = "None",
    MultipleOptions = true,
    Flag = "SelectedDataTable",
    Callback = function(CurrentValue)
        selecteddata = CurrentValue
    end,
})

-----------------------
ProgTab:CreateSection("2+ Players needed")
-----------------------

ProgTab:CreateToggle({
    Name = "Infinite Grips 🔹",
    CurrentValue = false,
    Flag = "InfGripsToggle", 
    Callback = function(Value)
        farminggrips.Value = Value
        spawn(function()
            features.FarmGrips()
        end)
    end,
})

ProgTab:CreateToggle({
    Name = "Give the Grips 🔹",
    CurrentValue = false,
    Flag = "GiveGripsToggle", 
    Callback = function(Value)
        givegrip.Value = Value
        spawn(function()
            features.GiveGrips()
        end)
    end,
})

-----------------------
ProgTab:CreateSection("Auto Wipe")
 -----------------------

ProgTab:CreateToggle({
    Name = "Loop Wipe 🔹",
    CurrentValue = false,
    Flag = "AutoWipeToggle", 
    Callback = function(Value)
     loopwiping.Value = Value
     spawn(function()
        features.Loopwipe()
     end)
    end,
})

ProgTab:CreateInput({
    Name = "Insert Name",
    CurrentValue = "",
    PlaceholderText = "Names",
    RemoveTextAfterFocusLost = false,
    Flag = "NameString",
    Callback = function(Text)
        table.clear(selectednames)
        selectedstrings = Text
        for name in string.gmatch(selectedstrings, '([^,]+)') do
            table.insert(selectednames, name:match("^%s*(.-)%s*$"))
        end
    end,
 })

ProgTab:CreateInput({
    Name = "Insert Hair Colour",
    CurrentValue = "",
    PlaceholderText = "BrickColors",
    RemoveTextAfterFocusLost = false,
    Flag = "HairColourTable",
    Callback = function(Text)
        table.clear(selectedhaircolors)
        selectedcolors = Text
        for name in string.gmatch(selectedcolors, '([^,]+)') do
            table.insert(selectedhaircolors, name:match("^%s*(.-)%s*$"))
        end
    end,
 })


------------------------
ProgTab:CreateSection("Wipe Settings")
------------------------

ProgTab:CreateToggle({
    Name = "Wipe until both obtained",
    CurrentValue = false,
    Flag = "WipeBothOptainedToggle", 
    Callback = function(Value)
        twodesires = Value
    end,
 })

ProgTab:CreateDropdown({
    Name = "Select Gender",
    Options = {"Male","Female"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "SelectedGenderString",
    Callback = function(CurrentValue)
        Gender = CurrentValue[1]
    end,
})

ProgTab:CreateSection("")

-----------------------
ProgTab:CreateSection("Auto Missions")
-----------------------

ProgTab:CreateToggle({
    Name = "Auto Missions 🔹",
    CurrentValue = false,
    Flag = "AutoMissionsToggle",
    Callback = function(Value)
        missionfarmactive.Value = Value
        spawn(function()
            while missionfarmactive.Value do
                features.AutoMissions()
                task.wait(1)
            end
        end)
    end,
})

ProgTab:CreateDropdown({
    Name = "Select Mission Types",
    Options = {"Defeat a Bandit", "Crate Delivery", "Bandit Camp", "Corrupted Point", "Defeat a Boss", "Capture Manda", "Cratos"},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "SelectedMissionTypes",
    Callback = function(CurrentValue)
        selectedMissionTypes = {}
        for _, value in pairs(CurrentValue) do
            table.insert(selectedMissionTypes, value)
        end
    end,
})

ProgTab:CreateToggle({
    Name = "Auto Equip Weapon",
    CurrentValue = false,
    Flag = "MissionAutoEquipToggle",
    Callback = function(Value)
        missionautoequip = Value
    end,
})

ProgTab:CreateToggle({
    Name = "Auto M1",
    CurrentValue = false,
    Flag = "MissionAutoM1Toggle",
    Callback = function(Value)
        missionautom1 = Value
    end,
})

-----------------------
TeleportsTab:CreateSection("Teleports")
-----------------------

TeleportsTab:CreateButton({
    Name = "to ChakraPoint",
    Callback = function()
        features.StartTeleport()
    end
 })

TeleportsTab:CreateButton({
    Name = "to SafeSpot",
     Callback = function()
        features.gotosafespot(false,false)
    end
 })

TeleportsTab:CreateButton({
    Name = "to Trinket Merchant",
     Callback = function()
        if plr.Character.HumanoidRootPart then
            for i, v in pairs(workspace:GetChildren()) do
                if v.Name == "Merchant" then
                    if Teleport(v:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(2.5,0,0)) == false then
                        continue
                    else
                        return
                    end
                end
            end
        end
    end
 })

TeleportsTab:CreateButton({
    Name = "to Fruit Merchant",
     Callback = function()
        if plr.Character.HumanoidRootPart then
            if plr.Character.HumanoidRootPart then
                for i, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Food Merchant" then
                        if Teleport(v:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(2.5,0,0)) == false then
                            continue
                        else
                            return
                        end
                    end
                end
            end
        end
    end
 })

-----------------------
TeleportsTab:CreateDivider()
-----------------------

TeleportsTab:CreateButton({
     Name = "Check for ChakraFruit",
      Callback = function()
        local chakrafruitamount = {}
        for i, v in game.ReplicatedStorage:GetDescendants() do
            if v.Name == "Chakra Fruit" then
                if table.find(chakrafruitamount,v.CFrame) or table.find(teleportedfruitIDs,v.ID.Value) then
                else
                    table.insert(chakrafruitamount,v.CFrame)
                end
             end
         end
 
         local chakrafruitcounter = 0
 
         for i, v in chakrafruitamount do
             chakrafruitcounter += 1
         end
 
         if chakrafruitcounter > 0 then
             Notify(chakrafruitcounter.." possible Chakra Fruit/s detected.","",1.5,"info")
         else
             Notify("No Chakra Fruit detected.","",1.5,"info")
         end
     end
  })

TeleportsTab:CreateButton({
     Name = "Check for Life/Forget Fruit",
      Callback = function()
        local chakrafruitamount = {}
        for i, v in game.ReplicatedStorage:GetDescendants() do
            if v.Name == "Life Up Fruit" or v.Name == "Fruit Of Forgetfulness" then
                if table.find(chakrafruitamount,v.CFrame) or table.find(teleportedfruitIDs,v.ID.Value) then
                else
                    table.insert(chakrafruitamount,v.CFrame)
                end
             end
         end
 
         local chakrafruitcounter = 0
 
         for i, v in chakrafruitamount do
             chakrafruitcounter += 1
         end
 
         if chakrafruitcounter > 0 then
             Notify(chakrafruitcounter.." possible LF/FOFs detected.","",1.5,"info")
         else
             Notify("No LF/FOFs detected.","",1.5,"info")
         end
     end
  })

TeleportsTab:CreateButton({
    Name = "Goto ChakraFruit",
     Callback = function()
         features.TPChakraFruit()
    end
 })
 
TeleportsTab:CreateButton({
    Name = "Goto LifeFruit",
     Callback = function()
         features.TPFruit()
    end
 })

-----------------------
TeleportsTab:CreateSection("Buy")
-----------------------

TeleportsTab:CreateButton({
    Name = "Purchase Item",
     Callback = function()
        features.PurchaseItem()
    end
 })

itempurchase = TeleportsTab:CreateInput({
    Name = "Insert Item Name",
    CurrentValue = "",
    PlaceholderText = "String",
    RemoveTextAfterFocusLost = false,
    Flag = "ItemPurchaseString",
    Callback = function(Text)
        itemtopurchase = Text
    end,
 })

itemamount = TeleportsTab:CreateInput({
    Name = "Insert Amount",
    CurrentValue = "",
    PlaceholderText = "Number",
    RemoveTextAfterFocusLost = false,
    Flag = "ItemPurchaseAmount",
    Callback = function(Text)
        purchasenumber = tonumber(Text)
    end,
 })

-----------------------
TeleportsTab:CreateSection("Search")
-----------------------



-----------------------
TeleportsTab:CreateSection("NPCs")
-----------------------

TeleportsTab:CreateButton({
    Name = "Goto NPC",
     Callback = function()
        if plr.Character then
            if plr.Character.HumanoidRootPart then
                Teleport(workspace:FindFirstChild(selectedNPC).HumanoidRootPart.CFrame * CFrame.new(3, 0, 0))
            end
        end
    end
 })

TeleportsTab:CreateDropdown({
     Name = "Select NPC",
     Options = NPCs,
     CurrentOption = {"None"},
     MultipleOptions = false,
     Flag = "SelectedNPCString",
     Callback = function(CurrentValue)
         selectedNPC = CurrentValue[1]
     end,
  })

-----------------------
TeleportsTab:CreateDivider()
-----------------------

TeleportsTab:CreateButton({
    Name = "Goto Corrupted Point",
     Callback = function()
        if plr.Character then
            if plr.Character.HumanoidRootPart then
                for i, v in pairs(game.workspace:GetChildren()) do
                    if v.Name == "CorruptedPoint" then
                        if Teleport(v:FindFirstChild("Main").CFrame) == true then
                            return
                        end
                    end
                end
            end
        end
    end
 })

TeleportsTab:CreateButton({
    Name = "Goto SwitchPowder",
     Callback = function()
        if plr.Character then
            if plr.Character.HumanoidRootPart then
                Teleport(workspace:FindFirstChild("DesortoidActivationFloor").CFrame)
            end
        end
    end
 })

 TeleportsTab:CreateButton({
    Name = "Goto Artic Mask",
     Callback = function()
        if plr.Character then
            if plr.Character.HumanoidRootPart then
                Teleport(CFrame.new(-2181.33154, -32.0918045, -3299.38062, -1, 0, -0, 0, 0, -1, 0, -1, -0))
            end
        end
    end
 })

TeleportsTab:CreateToggle({
    Name = "Auto Spawn Artic NPCs 🔹",
    CurrentValue = false,
    Flag = "AutoSpawnArticToggle", 
    Callback = function(Value)
        spawningarticnpc.Value = Value
        spawn(function()        
            features.AutoSpawnArticNPC()
        end)
    end,
})

-----------------------
TeleportsTab:CreateSection("")
-----------------------

 --[[

  _________                          .__  __           ___________     ___.    
 /   _____/ ____   ____  __ _________|__|/  |_ ___.__. \__    ___/____ \_ |__  
 \_____  \_/ __ \_/ ___\|  |  \_  __ \  \   __<   |  |   |    |  \__  \ | __ \ 
 /        \  ___/\  \___|  |  /|  | \/  ||  |  \___  |   |    |   / __ \| \_\ \
/_______  /\___  >\___  >____/ |__|  |__||__|  / ____|   |____|  (____  /___  /
        \/     \/     \/                       \/                     \/    \/ 

 --]]

-----------------------
ESPTab:CreateSection("Player ESP")
-----------------------

ESPTab:CreateToggle({
   Name = "Enable ESP",
   CurrentValue = false,
   Flag = "ESPToggle", 
   Callback = function(Value)
        ESP_Enabled = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Show Box",
   CurrentValue = true,
   Flag = "ESPBoxToggle", 
   Callback = function(Value)
        ESP_ShowBox = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Show Name",
   CurrentValue = true,
   Flag = "ESPNameToggle", 
   Callback = function(Value)
        ESP_ShowName = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Show Distance",
   CurrentValue = true,
   Flag = "ShowDistanceToggle", 
   Callback = function(Value)
        ESP_ShowStuds = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Show Health",
   CurrentValue = true,
   Flag = "ShowHealthToggle", 
   Callback = function(Value)
        ESP_ShowHealth = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Show Health Bar",
   CurrentValue = true,
   Flag = "ShowHealthBarToggle", 
   Callback = function(Value)
        ESP_ShowHealthBar = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Show Tracer",
   CurrentValue = false,
   Flag = "ESPTracerToggle", 
   Callback = function(Value)
        ESP_ShowTracer = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Show Freshie Status",
   CurrentValue = true,
   Flag = "ESPFreshieToggle", 
   Callback = function(Value)
        ESP_ShowFreshie = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Show Clan/Bloodline",
   CurrentValue = false,
   Flag = "ShowBloodlineToggle", 
   Callback = function(Value)
        ESP_ShowBloodline = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Show Weapon",
   CurrentValue = false,
   Flag = "ESPWeaponToggle", 
   Callback = function(Value)
        ESP_ShowWeapon = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Show Knocked Status",
   CurrentValue = true,
   Flag = "ESPKnockedToggle", 
   Callback = function(Value)
        ESP_ShowKnocked = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Show Chakra Sense",
   CurrentValue = false,
   Flag = "ESPChakraSenseToggle", 
   Callback = function(Value)
        ESP_ShowChakraSense = Value
   end,
})

ESPTab:CreateSlider({
   Name = "Max Distance",
   Range = {0, 5000},
   Increment = 50,
   Suffix = " studs",
   CurrentValue = 1000,
   Flag = "ESPMaxDistance", 
   Callback = function(Value)
        ESP_MaxDistance = Value
   end,
})

ESPTab:CreateSlider({
   Name = "Box Thickness",
   Range = {1, 10},
   Increment = 1,
   Suffix = "",
   CurrentValue = 2,
   Flag = "ESPBoxThickness", 
   Callback = function(Value)
        ESP_BoxThickness = Value
   end,
})

ESPTab:CreateSlider({
   Name = "Text Size",
   Range = {8, 24},
   Increment = 1,
   Suffix = "",
   CurrentValue = 14,
   Flag = "ESPTextSize", 
   Callback = function(Value)
        ESP_TextSize = Value
   end,
})

ESPTab:CreateDivider()

-----------------------
ESPTab:CreateSection("Mob ESP")
-----------------------

ESPTab:CreateToggle({
   Name = "Enable Mob ESP",
   CurrentValue = false,
   Flag = "MobESPToggle", 
   Callback = function(Value)
        MobESP_Enabled = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Mob ESP - Show Box",
   CurrentValue = true,
   Flag = "MobESPBoxToggle", 
   Callback = function(Value)
        MobESP_ShowBox = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Mob ESP - Show Name",
   CurrentValue = true,
   Flag = "MobESPNameToggle", 
   Callback = function(Value)
        MobESP_ShowName = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Mob ESP - Show Distance",
   CurrentValue = true,
   Flag = "MobShowDistanceToggle", 
   Callback = function(Value)
        MobESP_ShowStuds = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Mob ESP - Show Health",
   CurrentValue = true,
   Flag = "MobShowHealthToggle", 
   Callback = function(Value)
        MobESP_ShowHealth = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Mob ESP - Show Health Bar",
   CurrentValue = true,
   Flag = "MobESPHealthBarToggle", 
   Callback = function(Value)
        MobESP_ShowHealthBar = Value
   end,
})

ESPTab:CreateSlider({
   Name = "Mob ESP Max Distance",
   Range = {0, 5000},
   Increment = 50,
   Suffix = " studs",
   CurrentValue = 1000,
   Flag = "MobESPMaxDistance", 
   Callback = function(Value)
        MobESP_MaxDistance = Value
   end,
})

-----------------------
SecurityTab:CreateSection("Security")
-----------------------

SecurityTab:CreateToggle({
    Name = "Chakra Sense Notifier",
    CurrentValue = false,
    Flag = "ChakraSenseNotiToggle", 
    Callback = function(Value)
    chakraguithere = Value
    features.Chakranotifi()
    end,
 })

SecurityTab:CreateToggle({
    Name = "Observeration Alerts",
    CurrentValue = false,
    Flag = "ObservationAlertsToggle", 
    Callback = function(Value)
        ChakraSenseAlerter = Value
        if Value == true then
            Notify("Observation Alerter","running...",2,"shield-check")
        end
    end,
 })

 SecurityTab:CreateToggle({
    Name = "Join Notifications",
    CurrentValue = false,
    Flag = "JoinNotificationToggle", 
    Callback = function(Value)
        joinnotienabled = Value
        features.JoinNotification()
    end,
 })

  SecurityTab:CreateToggle({ -- todo
    Name = "[Client] Hide Name",
    CurrentValue = false,
    Flag = "HideNameToggle", 
    Callback = function(Value)
        hidingname = Value
        features.HideName()
    end,
 })

-----------------------
SecurityTab:CreateSection("Max Security")
-----------------------

SecurityTab:CreateParagraph({
    Title = "Stealth Mode",
    Content = "When using features marked with 🔹, Stealth Mode activates advanced anti-detection measures for maximum safety. These protections prevent detection by nearby players, Chakra Sense, or moderators. Teleportation features also perform a safety check before teleporting to ensure no one is within line of sight."
})


stealthfeatures = {
    [treehopping] = features.Treehop,
    [bossfarmactive] = features.Killboss,
    [Ryofarming] = features.RyoFarm,
    [Activationfarm] = features.Activationsfarm,
    [loopwiping] = features.Loopwipe,
    [Devilactive] = features.AutoDevilsDeal,
    [GiveKnock] = features.GiveGripsFrags,
    [spawningarticnpc] = features.AutoSpawnArticNPC,
    [givegrip] = features.GiveGrips,
    [farminggrips] = features.FarmGrips
}

SecurityTab:CreateToggle({
    Name = "Stealth Mode",
    CurrentValue = false,
    Flag = "StealthModeToggle", 
    Callback = function(Value)
        stealthmodeactive.Value = Value
    end,
 })

-----------------------
SecurityTab:CreateSection("Stealth Configurations")
-----------------------

SecurityTab:CreateDropdown({
    Name = "Select Danger Reaction",
    Options = {"Kick", "Stop Farm", "Stop Farm + Reset", "Stop Farm + Safe Spot", "Safe Spot + Serverhop"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "DangerReactionString",
    Callback = function(CurrentValue)
        stealthmeasurement = CurrentValue[1]
    end,
 })

SecurityTab:CreateSlider({
    Name = "Custom Distance Check [Studs]",
   Range = {120, 250},
   Increment = 5,
   Suffix = "",
   CurrentValue = 120,
   Flag = "CustomDistanceCheckAmount", 
   Callback = function(Value)
        stealthneardistance = Value
   end,
})

SecurityTab:CreateToggle({
    Name = "ServerHop if someone has Sense",
    CurrentValue = false,
    Flag = "SHOPifsensethere", 
    Callback = function(Value)
        stealthshopifsensethere = Value
    end,
 })

SecurityTab:CreateSection("")

--[[

               __    __  .__                         __        ___.    
  ______ _____/  |__/  |_|__| ____    ____  ______ _/  |______ \_ |__  
 /  ___// __ \   __\   __\  |/    \  / ___\/  ___/ \   __\__  \ | __ \ 
 \___ \\  ___/|  |  |  | |  |   |  \/ /_/  >___ \   |  |  / __ \| \_\ \
/____  >\___  >__|  |__| |__|___|  /\___  /____  >  |__| (____  /___  /
     \/     \/                   \//_____/     \/             \/    \/ 

--]]

-----------------------
Settings:CreateSection("Server Hopping")
-----------------------

Settings:CreateButton({
   Name = "Hop to MainMenu",
    Callback = function()
    features.ReturnMenu()
   end
})

Settings:CreateButton({
   Name = "Hop to Random Server",
    Callback = function()
    features.TeleportRandomServer()
   end
})

Settings:CreateButton({
   Name = "Hop to Lowest Server",
    Callback = function()
    features.TeleportLeastActive()
   end
})

-----------------------
Settings:CreateDivider()
-----------------------

Settings:CreateDropdown({
     Name = "Select Server Regions",
     Options = {"Germany", "United States", "Netherlands", "Ireland", "Singapore", "Brazil"},
     CurrentOption = {"None"},
     MultipleOptions = true,
     Flag = "SelectedServerRegion",
     Callback = function(CurrentValue)
        selectedregions = CurrentValue
     end,
  })

Settings:CreateSlider({
    Name = "Serverhop Delay for Farms",
   Range = {0,5},
   Increment = 1,
   Suffix = "",
   CurrentValue = 0,
   Flag = "ServerHopDelayNumber", 
   Callback = function(Value)
        shopdelay = Value
   end,
})

-----------------------
Settings:CreateSection("Notification")
-----------------------

Settings:CreateInput({
   Name = "Webhook URL",
   CurrentValue = "",
   PlaceholderText = "https://discord.com/api/webhooks/..",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
        Webhook_URL= Text
   end,
})

Settings:CreateDropdown({
     Name = "Select What to Notify",
     Options = {"Stealth Mode triggered", "Object/NPC found"},
     CurrentOption = {"None"},
     MultipleOptions = true,
     Flag = "SelectedNotifications",
     Callback = function(CurrentValue)
        selectednotis = CurrentValue
     end,
  })

-----------------------
Settings:CreateSection("Configurations")
-----------------------

Settings:CreateButton({
   Name = "Get Current Location (clipboard)",
    Callback = function()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local pos = hrp.Position
        setclipboard(math.floor(pos.X)..","..math.floor(pos.Y)..","..math.floor(pos.Z))
   end
})

Settings:CreateInput({
   Name = "Set Safe Spot Location",
   CurrentValue = "",
   PlaceholderText = "CFrame",
   RemoveTextAfterFocusLost = false,
   Flag = "SafeSpotCFrame",
   Callback = function(Text)
        local unformattedText = Text
        local xStr, yStr, zStr = unformattedText:gsub("%s+", ""):match("([^,]+),([^,]+),([^,]+)")
        local x, y, z = tonumber(xStr), tonumber(yStr), tonumber(zStr)
        if x and y and z then
            safespotcf = CFrame.new(x, y, z)
        else
            safespotcf = nil
        end
   end,
})

Settings:CreateSlider({
    Name = "Set Additional Boss Offset",
   Range = {-15, 15},
   Increment = 1,
   Suffix = "",
   CurrentValue = 0,
   Flag = "BossOffsetAmount", 
   Callback = function(Value)
        sliderbossoffset = Value
   end,
})

-- Candy offset removed

-----------------------
Settings:CreateDivider()
-----------------------

local FlyKey = Settings:CreateKeybind({
   Name = "Fly Keybind",
   CurrentKeybind = "World0",
   HoldToInteract = false,
   Flag = "FlyKeybind", 
   Callback = function(Keybind)
        spawn(function()
            features.toggleFlight()
        end)
   end,
})

local WSKey = Settings:CreateKeybind({
   Name = "Walkspeed Keybind",
   CurrentKeybind = "World0",
   HoldToInteract = false,
   Flag = "WalkSpeedKeybind", 
   Callback = function(Keybind)
        spawn(function()
            if walkspeed_enabled then
                walkspeed_enabled = false
                if plr.Character and plr.Character.Humanoid then
                    plr.Character.Humanoid.WalkSpeed = 16
                end
            else
                walkspeed_enabled = true
            end
        end)
   end,
})

local NCKey = Settings:CreateKeybind({
   Name = "Noclip Keybind",
   CurrentKeybind = "World0",
   HoldToInteract = false,
   Flag = "Noclip Keybind", 
   Callback = function(Keybind)
        spawn(function()
            if noclipenabled then
                noclipenabled = false
            else
                noclipenabled = true
            end
            features.Noclip()
        end)
   end,
})

Settings:CreateButton({
   Name = "Reset Keybinds",
    Callback = function()
        FlyKey:Set("World0")
        NCKey:Set("World0")
        WSKey:Set("World0")
   end
})

Settings:CreateSection("")

-- Event tab removed - candy features removed


--[[

__________                               __   
\______   \_______   ____   ______ _____/  |_ 
 |     ___/\_  __ \_/ __ \ /  ___// __ \   __\
 |    |     |  | \/\  ___/ \___ \\  ___/|  |  
 |____|     |__|    \___  >____  >\___  >__|  
                        \/     \/     \/      

--]]



--[[

  _________ __                 __                
 /   _____//  |______ ________/  |_ __ ________  
 \_____  \\   __\__  \\_  __ \   __\  |  \____ \ 
 /        \|  |  / __ \|  | \/|  | |  |  /  |_> >
/_______  /|__| (____  /__|   |__| |____/|   __/ 
        \/           \/                  |__|    


--]]

if not plr:FindFirstChild("PlayerGui") then
    repeat
        wait()
    until plr:FindFirstChild("PlayerGui")
end

features.AntiBan()
features.StealthMode()
features.AntiAFK()
features.NoFallDamage()
features.InfiniteStamina()
features.CSA()
features.Walkspeed() 
features.RenderMap()
features.NoFogPassive()
features.LoadESP()

spawn(function()
    features.ClickToView()
end)

wait()
Rayfield:LoadConfiguration()
Rayfield:LoadConfiguration()
