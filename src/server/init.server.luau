--!strict
-- src/server/init.server.luau

local Constants = require(game:GetService("ReplicatedStorage").Shared.TycoonConfig.Parent:WaitForChild("Constants")) 

if Constants.DEBUG_MODE then print("init.server.luau script started.") end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerFolder = game:GetService("ServerScriptService"):WaitForChild("Server") 

local TycoonManager = require(ServerFolder:WaitForChild("TycoonManager")) 

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents") 
local ShowTycoonSelection = RemoteEvents:WaitForChild("ShowTycoonSelection") 

local TycoonClaimer = Workspace:WaitForChild("TycoonClaimer", 60) 

if not TycoonClaimer then
    warn("TycoonClaimer part not found in Workspace! This may cause issues.")
else
    if Constants.DEBUG_MODE then print("TycoonClaimer found. Setting up touch listener.") end
    TycoonClaimer.Touched:Connect(function(hit) 
        local player = Players:GetPlayerFromCharacter(hit.Parent) 
        if player then
            -- This print is crucial for confirming player detection
            print(`Player {player.Name} touched the TycoonClaimer.`) 
            ShowTycoonSelection:FireClient(player, TycoonClaimer) 
            if Constants.DEBUG_MODE then print("ShowTycoonSelection event fired to client.") end
        else
            if Constants.DEBUG_MODE then print("Touched by something not a player character part.") end
        end
    end)
end

if Constants.DEBUG_MODE then print("init.server.luau script finished setup.") end