--!strict
-- src/client/init.client.luau

local Constants = require(game:GetService("ReplicatedStorage").Shared.Constants)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local ShowTycoonSelection = RemoteEvents:WaitForChild("ShowTycoonSelection")
local TycoonTypeSelected = RemoteEvents:WaitForChild("TycoonTypeSelected") -- Get the TycoonTypeSelected RemoteEvent

local TycoonSelectionGui = PlayerGui:WaitForChild("TycoonSelectionGui")
local SelectionFrame = TycoonSelectionGui:WaitForChild("SelectionFrame")

-- Get references to the buttons
local MinerButton = SelectionFrame:WaitForChild("MinerButton")
local RefinerButton = SelectionFrame:WaitForChild("RefinerButton")

-- Keep track of the tycoonClaimerPart from the server event
local currentTycoonClaimerPart: Part = nil

ShowTycoonSelection.OnClientEvent:Connect(function(tycoonClaimerPart)
    print(`[Client] Received ShowTycoonSelection event for: {tycoonClaimerPart.Name}`)
    
    currentTycoonClaimerPart = tycoonClaimerPart -- Store the part for later use

    TycoonSelectionGui.Enabled = true
    SelectionFrame.Visible = true

    print("[Client] Tycoon Selection UI should now be visible.")
end)

-- Function to handle button clicks
local function onTycoonTypeSelected(tycoonType: string)
    if not currentTycoonClaimerPart then
        warn("[Client] Cannot select tycoon type: TycoonClaimerPart not set.")
        return
    end

    -- Hide the UI
    TycoonSelectionGui.Enabled = false
    SelectionFrame.Visible = false
    print(`[Client] UI hidden. Player selected: {tycoonType}`)

    -- Fire the event to the server
    TycoonTypeSelected:FireServer(tycoonType, currentTycoonClaimerPart)
    if Constants.DEBUG_MODE then print(`[Client] Fired TycoonTypeSelected event to server for type: {tycoonType}`) end

    currentTycoonClaimerPart = nil -- Clear the stored part after selection
end

-- Connect button click events
MinerButton.MouseButton1Click:Connect(function()
    onTycoonTypeSelected("Miner") -- Pass the string "Miner" as the chosen type
end)

RefinerButton.MouseButton1Click:Connect(function()
    onTycoonTypeSelected("Refiner") -- Pass the string "Refiner" as the chosen type
end)

if Constants.DEBUG_MODE then print("init.client.luau script finished setup.") end