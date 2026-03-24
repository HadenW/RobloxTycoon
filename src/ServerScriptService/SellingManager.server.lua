--!nocheck
-- This script should be in ServerScriptService
-- Name: SellingManager.server.lua

print("DEBUG: SellingManager script loaded!")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SellResourceEvent = ReplicatedStorage.RemoteEvents:WaitForChild("SellResourceEvent")
local SellService = require(script.Parent:WaitForChild("SellService"))

SellResourceEvent.OnServerEvent:Connect(function(player, resourceTypeToSell, amountToSell)
    local success, totalMoneyGained, reason = SellService.sell(player, resourceTypeToSell, amountToSell)
    if not success then
        warn(string.format("[Server] Sell request denied for %s: resource=%s amount=%s reason=%s",
            player.Name, tostring(resourceTypeToSell), tostring(amountToSell), tostring(reason)))
        return
    end

    print(string.format("[Server] %s sold %s x%d for %d Money.",
        player.Name, tostring(resourceTypeToSell), tonumber(amountToSell) or 0, totalMoneyGained))
end)