-- Steps to Enable Resource Selling When Player Touches the Sell Pad

--[1] ASSUMPTIONS:
-- - The part the player stands on to sell is named "SellPoint".
-- - It is located somewhere accessible in the workspace (or inside the tycoon model).
-- - We want to trigger the resource sale when a player touches it.
-- - We'll use the existing "SellResourceEvent" in ReplicatedStorage to invoke the server.

--[2] Create a Script in ServerScriptService or inside each Tycoon if unique per player

-- Example Script: SellTrigger.server.lua
print("DEBUG: SellTrigger script inside tycoon is running!")

local SellPad = script.Parent:WaitForChild("SellPoint")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SellResourceEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("SellResourceEvent")

local Players = game:GetService("Players")

local COOLDOWN_TIME = 2 -- seconds between allowed sell attempts
local cooldowns = {}

local function getPlayerFromPart(part)
    local character = part:FindFirstAncestorOfClass("Model")
    if character then
        return Players:GetPlayerFromCharacter(character)
    end
end

SellPad.Touched:Connect(function(hit)
    print("DEBUG: SellPoint touched by", hit:GetFullName())

    local player = getPlayerFromPart(hit)
    if not player then return end

    -- cooldown logic
    if cooldowns[player] and tick() - cooldowns[player] < COOLDOWN_TIME then
        return
    end
    cooldowns[player] = tick()

    -- Sell all valid resource types defined in SELL_PRICES
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    for _, stat in ipairs(leaderstats:GetChildren()) do
        if stat:IsA("IntValue") and stat.Name ~= "Money" and stat.Value > 0 then
            SellResourceEvent:FireServer(stat.Name, stat.Value)
        end
    end
end)

-- NOTES:
-- You can duplicate this logic per tycoon if each one has its own "SellPoint" part.
-- Or adapt to detect which tycoon a player owns and only sell if they touch *their* pad.
