--!strict
-- src/server/init.server.luau

print("init.server.luau script started.") -- Debug print

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Reference the 'Server' folder directly within ServerScriptService
local ServerFolder = game:GetService("ServerScriptService"):WaitForChild("Server") 

-- Require our TycoonManager module from within the ServerFolder
local TycoonManager = require(ServerFolder:WaitForChild("TycoonManager")) 

-- Define the RemoteEvents we'll be using
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents") 
local ShowTycoonSelection = RemoteEvents:WaitForChild("ShowTycoonSelection") 

-- Locate the TycoonClaimer part
local TycoonClaimer = Workspace:WaitForChild("TycoonClaimer", 60) 

if not TycoonClaimer then
    warn("TycoonClaimer part not found in Workspace!")
else
    print("TycoonClaimer found. Setting up touch listener.") -- Debug print
    TycoonClaimer.Touched:Connect(function(hit) 
        print("TycoonClaimer was touched!") -- Debug print
        local player = Players:GetPlayerFromCharacter(hit.Parent) 
        if player then
            print(`Player {player.Name} detected from touch.`) -- Debug print
            -- We've detected a player touching the claimer!
            print(`Player {player.Name} touched the TycoonClaimer. Showing selection UI.`)
            -- Fire the RemoteEvent to the specific player, passing the TycoonClaimer part
            ShowTycoonSelection:FireClient(player, TycoonClaimer) 
            print("ShowTycoonSelection event fired to client.") -- Debug print
        else
            print("Touched by something not a player character part.") -- Debug print
        end
    end)
end

print("init.server.luau script finished setup.")