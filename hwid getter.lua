

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer


local function GetHWID()
    local success, hwid = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if success and hwid then
        return hwid
    end

    return HttpService:GenerateGUID(false)
end

local hwid = GetHWID()


if setclipboard then
    setclipboard(hwid)
    print("[HWID] Your HWID has been copied to clipboard!")
    print("[HWID] HWID: " .. hwid)
    warn("HWID copied to clipboard: " .. hwid)
elseif writeclipboard then
    writeclipboard(hwid)
    print("[HWID] Your HWID has been copied to clipboard!")
    print("[HWID] HWID: " .. hwid)
    warn("HWID copied to clipboard: " .. hwid)
else
    print("[HWID] Clipboard function not available. Your HWID is:")
    print("[HWID] " .. hwid)
    warn("HWID: " .. hwid)
    warn("Please manually copy the HWID above")
end


if plr and plr:FindFirstChild("PlayerGui") then
    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCore("SendNotification", {
        Title = "HWID Copied!",
        Text = "HWID: " .. hwid,
        Duration = 5,
        Button1 = "OK"
    })
end

