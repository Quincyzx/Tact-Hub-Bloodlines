-- Modified Rayfield Library - Heavily Revamped Visual Design
-- This loads Rayfield and then completely overrides its visual styling

local RayfieldSource = game:HttpGet('https://sirius.menu/rayfield')
local Rayfield = loadstring(RayfieldSource)()

-- Wait for Rayfield to initialize
task.wait(0.1)

-- Heavily modify Rayfield's visual appearance
if Rayfield then
    -- Store all original methods to preserve them
    local OriginalCreateWindow = Rayfield.CreateWindow
    local OriginalNotify = Rayfield.Notify
    local OriginalLoadConfiguration = Rayfield.LoadConfiguration
    
    -- Override CreateWindow with heavily customized theme
    function Rayfield:CreateWindow(Options)
        -- Force a completely different visual theme
        Options = Options or {}
        
        -- Completely revamped color scheme - Dark Purple/Blue with Cyan accents
        Options.Theme = {
            TextColor = Color3.fromRGB(255, 255, 255),
            Background = Color3.fromRGB(10, 8, 18),  -- Very dark purple-blue
            Topbar = Color3.fromRGB(20, 15, 35),     -- Dark purple topbar
            Shadow = Color3.fromRGB(0, 0, 0),
            NotificationBackground = Color3.fromRGB(15, 12, 25),
            NotificationActionsBackground = Color3.fromRGB(25, 20, 40),
            TabBackground = Color3.fromRGB(18, 14, 28),
            TabStroke = Color3.fromRGB(40, 30, 60),
            TabBackgroundSelected = Color3.fromRGB(0, 200, 255),  -- Bright cyan selected
            TabTextColor = Color3.fromRGB(180, 180, 200),
            SelectedTabTextColor = Color3.fromRGB(0, 0, 0),  -- Black text on cyan
            ElementBackground = Color3.fromRGB(15, 12, 22),
            ElementBackgroundHover = Color3.fromRGB(25, 20, 35),
            SecondaryElementBackground = Color3.fromRGB(12, 10, 20),
            ElementStroke = Color3.fromRGB(0, 150, 200),  -- Cyan strokes
            SecondaryElementStroke = Color3.fromRGB(0, 180, 220),
            SliderBackground = Color3.fromRGB(20, 15, 30),
            SliderProgress = Color3.fromRGB(0, 200, 255),  -- Bright cyan progress
            SliderStroke = Color3.fromRGB(0, 150, 200),
            ToggleBackground = Color3.fromRGB(18, 14, 28),
            ToggleEnabled = Color3.fromRGB(0, 200, 255),  -- Cyan when enabled
            ToggleDisabled = Color3.fromRGB(30, 25, 40),
            ToggleEnabledStroke = Color3.fromRGB(0, 255, 255),  -- Bright cyan stroke
            ToggleDisabledStroke = Color3.fromRGB(50, 45, 60),
            ToggleEnabledOuterStroke = Color3.fromRGB(0, 220, 255),
            ToggleDisabledOuterStroke = Color3.fromRGB(25, 20, 35),
            DropdownSelected = Color3.fromRGB(0, 180, 220),
            DropdownUnselected = Color3.fromRGB(18, 14, 28),
            InputBackground = Color3.fromRGB(15, 12, 22),
            InputStroke = Color3.fromRGB(0, 150, 200),
            PlaceholderColor = Color3.fromRGB(100, 150, 180)
        }
        
        -- Create window with modified theme
        local Window = OriginalCreateWindow(self, Options)
        
        -- Additional visual modifications after window creation
        task.spawn(function()
            task.wait(0.2)
            
            -- Find and modify the main window frame
            local CoreGui = game:GetService("CoreGui")
            local RayfieldGui = CoreGui:FindFirstChild("Rayfield")
            
            if RayfieldGui then
                -- Modify window appearance
                local MainFrame = RayfieldGui:FindFirstChild("Main")
                if MainFrame then
                    -- Add custom border glow effect
                    local UIGradient = Instance.new("UIGradient")
                    UIGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 50, 200)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
                    })
                    UIGradient.Rotation = 45
                    
                    -- Modify topbar
                    local Topbar = MainFrame:FindFirstChild("Topbar")
                    if Topbar then
                        local TopbarGradient = Instance.new("UIGradient")
                        TopbarGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 200)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 50, 200))
                        })
                        TopbarGradient.Parent = Topbar
                    end
                    
                    -- Add glow to tabs
                    local Tabs = MainFrame:FindFirstChild("Tabs")
                    if Tabs then
                        for _, Tab in pairs(Tabs:GetChildren()) do
                            if Tab:IsA("TextButton") then
                                -- Add glow effect to selected tabs
                                Tab.MouseEnter:Connect(function()
                                    local Glow = Instance.new("UIStroke")
                                    Glow.Color = Color3.fromRGB(0, 200, 255)
                                    Glow.Thickness = 2
                                    Glow.Transparency = 0.5
                                    Glow.Parent = Tab
                                end)
                            end
                        end
                    end
                end
            end
        end)
        
        return Window
    end
    
    -- Ensure Notify method is preserved
    if OriginalNotify then
        Rayfield.Notify = OriginalNotify
    end
    
    -- Ensure LoadConfiguration is preserved
    if OriginalLoadConfiguration then
        Rayfield.LoadConfiguration = OriginalLoadConfiguration
    end
    
    -- Preserve any other methods that might be needed
    -- This ensures all Rayfield functionality remains intact
end

-- Return the modified Rayfield
return Rayfield
