--!strict
-- src/server/TycoonManager.luau

local TycoonManager = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TycoonTemplatesFolder = ServerStorage:WaitForChild("TycoonTemplates")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

-- Define the RemoteEvents we'll be using
local ShowTycoonSelection = RemoteEvents:WaitForChild("ShowTycoonSelection")
local TycoonTypeSelected = RemoteEvents:WaitForChild("TycoonTypeSelected")

-- A table to keep track of claimed tycoons, mapping player to tycoon instance
local claimedTycoons: { [Player]: Model } = {}

-- Corrected line 20: A table to keep track of claimed tycoon IDs, mapping tycoon part to player
local occupiedTycoonClaimers: { [Part]: Player } = {} -- Changed [TycoonClaimerPart: Part] to [Part]

function TycoonManager:AssignTycoon(player: Player, tycoonType: string, tycoonClaimerPart: Part)
    print(`Player {player.Name} is trying to claim a {tycoonType} tycoon from {tycoonClaimerPart.Name}`)

    if occupiedTycoonClaimers[tycoonClaimerPart] then
        warn(`Tycoon claimer {tycoonClaimerPart.Name} is already claimed by {occupiedTycoonClaimers[tycoonClaimerPart].Name}.`)
        return
    end

    if claimedTycoons[player] then
        warn(`Player {player.Name} already has a tycoon.`)
        return
    end

    -- For now, just print a message. We'll add the actual tycoon instantiation later.
    print(`[TycoonManager] Successfully initiated claiming process for {player.Name} for a {tycoonType} tycoon!`)

    -- Mark the claimer as occupied
    occupiedTycoonClaimers[tycoonClaimerPart] = player
    claimedTycoons[player] = nil -- Placeholder for the actual tycoon model once instantiated

    -- TODO: Add logic to clone the tycoon template, place it, and set up ownership
end

-- Connect the TycoonTypeSelected RemoteEvent
TycoonTypeSelected.OnServerEvent:Connect(function(player: Player, tycoonType: string, tycoonClaimerPart: Part)
    -- Validate inputs
    if not player or typeof(tycoonType) ~= "string" or not tycoonClaimerPart or not tycoonClaimerPart:IsA("BasePart") then
        warn("TycoonTypeSelected: Invalid arguments received.")
        return
    end
    TycoonManager:AssignTycoon(player, tycoonType, tycoonClaimerPart)
end)

return TycoonManager