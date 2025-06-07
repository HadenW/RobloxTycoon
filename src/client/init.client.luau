--!strict
-- src/client/init.client.luau

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Define the RemoteEvents we'll be using
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local ShowTycoonSelection = RemoteEvents:WaitForChild("ShowTycoonSelection")

-- Locate the TycoonSelectionGui
local TycoonSelectionGui = PlayerGui:WaitForChild("TycoonSelectionGui")
local SelectionFrame = TycoonSelectionGui:WaitForChild("SelectionFrame")

-- Temporary: Listen for the ShowTycoonSelection event and print a message
ShowTycoonSelection.OnClientEvent:Connect(function(tycoonClaimerPart)
    print(`[Client] Received ShowTycoonSelection event! TycoonClaimer part received: {tycoonClaimerPart.Name}`)
    -- For now, we're just printing. We'll add UI display logic next.
end)

print("init.client.luau script finished setup.")