--!strict  -- Add this line for better type checking if not already present
print("DEBUG: AxeHandler script file was loaded!")

local tool = script.Parent
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- local animation = humanoid:LoadAnimation(tool.AxeSwingAnimation) -- KEEP THIS COMMENTED OUT FOR NOW

tool.Equipped:Connect(function()
    print("[Client] Axe equipped!")
    -- animation:Play() -- KEEP THIS COMMENTED OUT FOR NOW
end)

tool.Activated:Connect(function()
    print("[Client] Axe swung!")
    -- Simulate hitting an OreNode
    -- This is a placeholder; real hit detection would involve raycasting or magnitude checks
    local oreNode = workspace:FindFirstChild("OreNode") -- Assuming you have an OreNode in Workspace
    if oreNode then
        print("[Client] Hit OreNode!")
        -- You would likely fire a RemoteEvent to the server here
        game.ReplicatedStorage.RemoteEvents.MineResourceEvent:FireServer("Wood", oreNode)
    end
end)