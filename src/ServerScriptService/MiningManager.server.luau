--!nocheck
-- This script should be in ServerScriptService
-- Name: MiningManager

print("DEBUG: MiningManager script loaded!")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MineResourceEvent = ReplicatedStorage.RemoteEvents:WaitForChild("MineResourceEvent")

-- Server-side configuration for axe damage
local AXE_DAMAGE_CONFIG = {
    ["AxeTool"] = 25,
    -- Add more axe types here as you implement them
}
local DEFAULT_AXE_DAMAGE = 25 -- Fallback if toolName isn't in config

-- Configuration for resource gain
local RESOURCE_AMOUNT_PER_BREAK = 1 -- How many units of resource are added to inventory

MineResourceEvent.OnServerEvent:Connect(function(player, toolName, oreNode)
    print(string.format("[Server] %s fired MineResourceEvent with '%s' on %s", player.Name, toolName, oreNode.Name))

    -- **SERVER-SIDE VALIDATION**
    if not oreNode or not oreNode:IsA("Model") or not oreNode.Parent == workspace then
        warn(string.format("[Server] Invalid oreNode passed by %s.", player.Name))
        return
    end

    local healthValue = oreNode:FindFirstChild("Health")
    if not healthValue or not healthValue:IsA("NumberValue") then
        warn(string.format("[Server] OreNode '%s' does not have a 'Health' NumberValue.", oreNode.Name))
        return
    end

    local resourceTypeStringValue = oreNode:FindFirstChild("ResourceType")
    if not resourceTypeStringValue or not resourceTypeStringValue:IsA("StringValue") then
        warn(string.format("[Server] OreNode '%s' does not have a 'ResourceType' StringValue. Cannot determine resource to add.", oreNode.Name))
        return -- Cannot proceed without knowing what resource type
    end
    local resourceType = resourceTypeStringValue.Value -- Get the string name of the resource (e.g., "Wood")

    -- Determine damage to apply
    local damageToApply = AXE_DAMAGE_CONFIG[toolName] or DEFAULT_AXE_DAMAGE

    -- Apply damage
    local currentHealth = healthValue.Value
    currentHealth = currentHealth - damageToApply
    healthValue.Value = currentHealth

print(string.format("[Server] %s hit %s with %s. Health remaining: %d (Damage: %d)", player.Name, oreNode.Name, toolName, currentHealth, damageToApply))
    -- Check if the oreNode is broken
    if currentHealth <= 0 then
        print(string.format("[Server] %s has been broken! Adding %d %s to %s's inventory.", oreNode.Name, RESOURCE_AMOUNT_PER_BREAK, resourceType, player.Name))

        -- **AUTOMATIC RESOURCE ADDITION LOGIC**
        -- Find the player's leaderstats folder
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            -- Find the IntValue corresponding to the resource type (e.g., "Wood")
            local resourceStat = leaderstats:FindFirstChild(resourceType) -- This will be the "Wood" IntValue
            if resourceStat and resourceStat:IsA("IntValue") then
                resourceStat.Value = resourceStat.Value + RESOURCE_AMOUNT_PER_BREAK
            else
                warn(string.format("[Server] Player %s does not have a stat named '%s' in leaderstats. Resource not added.", player.Name, resourceType))
            end
        else
            warn(string.format("[Server] Player %s does not have a 'leaderstats' folder. Resource not added.", player.Name))
        end

        -- Destroy the oreNode
        oreNode:Destroy()
    end
end)