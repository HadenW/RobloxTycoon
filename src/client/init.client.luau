--!strict
-- src/client/init.client.luau

local Constants = require(game:GetService("ReplicatedStorage").Shared.TycoonConfig.Parent:WaitForChild("Constants"))

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players", 60).LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local ShowTycoonSelection = RemoteEvents:WaitForChild("ShowTycoonSelection")

local TycoonSelectionGui = PlayerGui:WaitForChild("TycoonSelectionGui")
local SelectionFrame = TycoonSelectionGui:WaitForChild("SelectionFrame")

ShowTycoonSelection.OnClientEvent:Connect(function(tycoonClaimerPart)
    -- This print is crucial for confirming client event reception
    print(`[Client] Received ShowTycoonSelection event for: {tycoonClaimerPart.Name}`)
    -- We'll add UI display logic here next.
end)

if Constants.DEBUG_MODE then print("init.client.luau script finished setup.") end