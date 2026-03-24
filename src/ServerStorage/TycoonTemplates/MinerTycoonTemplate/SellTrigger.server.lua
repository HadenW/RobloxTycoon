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
local Players = game:GetService("Players")
local SellService = require(game:GetService("ServerScriptService"):WaitForChild("SellService"))

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

    local success, totalMoneyGained, reason = SellService.sellAll(player)
    if not success then
        warn(string.format("[Server] Sell pad denied for %s: reason=%s", player.Name, tostring(reason)))
        return
    end

    if totalMoneyGained > 0 then
        print(string.format("[Server] %s sold all resources for %d Money via sell pad.", player.Name, totalMoneyGained))
    end
end)

-- NOTES:
-- You can duplicate this logic per tycoon if each one has its own "SellPoint" part.
-- Or adapt to detect which tycoon a player owns and only sell if they touch *their* pad.
