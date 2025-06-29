--!nocheck
-- This script should be in ServerScriptService
-- Name: PlayerStatsHandler.server.lua

print("DEBUG: PlayerStatsHandler script loaded!")

game.Players.PlayerAdded:Connect(function(player)
    print(string.format("PlayerAdded: %s", player.Name))

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats" -- Must be named "leaderstats" for Roblox to display it automatically
    leaderstats.Parent = player

    -- Create IntValue for Wood
    local woodCount = Instance.new("IntValue")
    woodCount.Name = "Wood" -- Displayed as "Wood" on the leaderboard
    woodCount.Value = 0
    woodCount.Parent = leaderstats

    -- Create IntValue for Money
    local moneyCount = Instance.new("IntValue")
    moneyCount.Name = "Money" -- Displayed as "Money" on the leaderboard
    moneyCount.Value = 0 -- Players start with 0 money
    moneyCount.Parent = leaderstats

    -- Add other resources here as needed, e.g.:
    -- local stoneCount = Instance.new("IntValue")
    -- stoneCount.Name = "Stone"
    -- stoneCount.Value = 0
    -- stoneCount.Parent = leaderstats
end)