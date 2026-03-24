--!nocheck

local SellService = {}

local SELL_PRICES = {
    Wood = 5,
    Stone = 10,
}

local MIN_SELL_AMOUNT = 1

local function getLeaderstats(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        return nil, "missing_leaderstats"
    end

    local moneyStat = leaderstats:FindFirstChild("Money")
    if not moneyStat or not moneyStat:IsA("IntValue") then
        return nil, "missing_money_stat"
    end

    return leaderstats, nil
end

function SellService.sell(player, resourceTypeToSell, amountToSell)
    local leaderstats, statsError = getLeaderstats(player)
    if not leaderstats then
        return false, 0, statsError
    end

    local pricePerUnit = SELL_PRICES[resourceTypeToSell]
    if not pricePerUnit then
        return false, 0, "invalid_resource_type"
    end

    if typeof(amountToSell) ~= "number" or amountToSell < MIN_SELL_AMOUNT or math.floor(amountToSell) ~= amountToSell then
        return false, 0, "invalid_amount"
    end
    amountToSell = math.floor(amountToSell)

    local resourceStat = leaderstats:FindFirstChild(resourceTypeToSell)
    if not resourceStat or not resourceStat:IsA("IntValue") then
        return false, 0, "missing_resource_stat"
    end

    if resourceStat.Value < amountToSell then
        return false, 0, "insufficient_resource"
    end

    local totalMoneyGained = amountToSell * pricePerUnit
    local moneyStat = leaderstats:FindFirstChild("Money")

    resourceStat.Value = resourceStat.Value - amountToSell
    moneyStat.Value = moneyStat.Value + totalMoneyGained

    return true, totalMoneyGained, nil
end

function SellService.sellAll(player)
    local leaderstats, statsError = getLeaderstats(player)
    if not leaderstats then
        return false, 0, statsError
    end

    local totalMoneyGained = 0
    local soldAny = false
    local moneyStat = leaderstats:FindFirstChild("Money")

    for resourceType, pricePerUnit in pairs(SELL_PRICES) do
        local resourceStat = leaderstats:FindFirstChild(resourceType)
        if resourceStat and resourceStat:IsA("IntValue") and resourceStat.Value > 0 then
            local amountToSell = resourceStat.Value
            resourceStat.Value = 0
            totalMoneyGained = totalMoneyGained + (amountToSell * pricePerUnit)
            soldAny = true
        end
    end

    if soldAny then
        moneyStat.Value = moneyStat.Value + totalMoneyGained
    end

    return true, totalMoneyGained, nil
end

return SellService
