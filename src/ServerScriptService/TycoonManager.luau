--!strict
-- src/server/TycoonManager.luau

local TycoonManager = {}

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace") -- Need Workspace to place the cloned tycoon

local TycoonTemplatesFolder = ServerStorage:WaitForChild("TycoonTemplates")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

local ShowTycoonSelection = RemoteEvents:WaitForChild("ShowTycoonSelection")
local TycoonTypeSelected = RemoteEvents:WaitForChild("TycoonTypeSelected")

local claimedTycoons: { [Player]: Model } = {}
local occupiedTycoonClaimers: { [Part]: Player } = {}

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

    -- Attempt to find the correct tycoon template
    local tycoonTemplate = TycoonTemplatesFolder:FindFirstChild(tycoonType .. "TycoonTemplate") -- e.g., "MinerTycoonTemplate"

    if not tycoonTemplate or not tycoonTemplate:IsA("Model") then
        warn(`[TycoonManager] Could not find template for tycoonType: {tycoonType}`)
        return
    end

    -- Clone the tycoon template
    local newTycoon = tycoonTemplate:Clone()
    newTycoon.Name = player.Name .. "'s " .. tycoonType .. " Tycoon" -- Name it for clarity

    -- Position the new tycoon at the TycoonClaimerPart's location (adjust as needed)
    -- You might want to offset this or use a specific spawn point within your template
    newTycoon:SetPrimaryPartCFrame(tycoonClaimerPart.CFrame)

    -- Parent the new tycoon to the Workspace
    newTycoon.Parent = Workspace

    -- Mark the claimer as occupied
    occupiedTycoonClaimers[tycoonClaimerPart] = player
    claimedTycoons[player] = newTycoon -- Store the actual tycoon model

    -- Hide the original TycoonClaimerPart as it's now claimed
    tycoonClaimerPart.Transparency = 1
    tycoonClaimerPart.CanCollide = false
    tycoonClaimerPart.Anchored = true -- Keep it from falling/moving if it was a part

    print(`[TycoonManager] Successfully instantiated {tycoonType} tycoon for {player.Name}!`)
    -- TODO: Add more setup logic here, like setting up Droppers, plot ownership, etc.
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