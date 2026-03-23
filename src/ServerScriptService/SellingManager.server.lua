--!nocheck
-- This script should be in ServerScriptService
-- Name: SellingManager.server.lua

print("DEBUG: SellingManager script loaded!")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SellResourceEvent = ReplicatedStorage.RemoteEvents:WaitForChild("SellResourceEvent")
local Players = game:GetService("Players") -- Reference to the Players service

-- Configuration for resource selling prices
local SELL_PRICES = {
    ["Wood"] = 5,   -- 1 Wood sells for 5 Money
    ["Stone"] = 10, -- Example: 1 Stone sells for 10 Money (if you add Stone later)
    -- Add more resource types and their selling prices here
}

-- Configuration for minimum amount to sell at once
local MIN_SELL_AMOUNT = 1

SellResourceEvent.OnServerEvent:Connect(function(player, resourceTypeToSell, amountToSell)
    print(string.format("[Server] %s wants to sell %d %s.", player.Name, amountToSell, resourceTypeToSell))

    -- **SERVER-SIDE VALIDATION** (Crucial for security!)
    -- 1. Check if player exists and has leaderstats (which should be true due to PlayerStatsHandler)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        warn(string.format("[Server] %s does not have leaderstats. Cannot sell.", player.Name))
        return
    end

    -- 2. Check if the resource type is valid and has a defined sell price in our server config
    local pricePerUnit = SELL_PRICES[resourceTypeToSell]
    if not pricePerUnit then
        warn(string.format("[Server] Invalid or unrecognized resource type '%s' requested by %s. Possible exploit attempt.", resourceTypeToSell, player.Name))
        return
    end

    -- 3. Check if amountToSell is a valid number (greater than 0, integer)
    if not typeof(amountToSell) == "number" or amountToSell < MIN_SELL_AMOUNT or math.floor(amountToSell) ~= amountToSell then
        warn(string.format("[Server] Invalid amount to sell (%s) requested by %s for '%s'. Must be a positive integer.", tostring(amountToSell), player.Name, resourceTypeToSell))
        return
    end
    amountToSell = math.floor(amountToSell) -- Ensure it's an integer to prevent decimal exploits

    -- 4. Check if player has enough of the resource to sell
    local resourceStat = leaderstats:FindFirstChild(resourceTypeToSell)
    if not resourceStat or not resourceStat:IsA("IntValue") then
        warn(string.format("[Server] %s does not have a stat named '%s' in leaderstats. Cannot sell.", player.Name, resourceTypeToSell))
        return
    end

    if resourceStat.Value < amountToSell then
        warn(string.format("[Server] %s tried to sell %d %s but only has %d. Transaction denied (insufficient funds).", player.Name, amountToSell, resourceTypeToSell, resourceStat.Value))
        return
    end

    -- 5. Check for the 'Money' stat
    local moneyStat = leaderstats:FindFirstChild("Money")
    if not moneyStat or not moneyStat:IsA("IntValue") then
        warn(string.format("[Server] %s does not have a 'Money' stat in leaderstats. Cannot complete sale.", player.Name))
        return
    end

    -- **Perform the Transaction** (All validations passed)
    local totalMoneyGained = amountToSell * pricePerUnit

    resourceStat.Value = resourceStat.Value - amountToSell -- Deduct resources
    moneyStat.Value = moneyStat.Value + totalMoneyGained    -- Add money

    print(string.format("[Server] %s successfully sold %d %s for %d Money. New %s: %d, New Money: %d",
        player.Name, amountToSell, resourceTypeToSell, totalMoneyGained, resourceTypeToSell, resourceStat.Value, moneyStat.Value))
end)