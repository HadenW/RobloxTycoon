--!nocheck
print("DEBUG: AxeHandler script file was loaded!")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Search for the tool in character or backpack
local tool = character:FindFirstChild("AxeTool") or player.Backpack:FindFirstChild("AxeTool")
if not tool then
    warn("❌ AxeTool not found in character or backpack!")
    return
end

local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

local animTrack = animator:LoadAnimation(tool:WaitForChild("AxeSwingAnimation"))
-- Set animation priority for better control
animTrack.Priority = Enum.AnimationPriority.Action

local MAX_HIT_DISTANCE = 10

tool.Equipped:Connect(function()
    print("[Client] Axe equipped!")
end)

tool.Activated:Connect(function()
    print("[Client] Axe swung!")

    animTrack:Play()

    local oreNode = workspace:FindFirstChild("OreNode")
    if oreNode then
        -- Check if OreNode has a PrimaryPart and use its position
        local oreNodePosition = nil
        if oreNode.PrimaryPart then
            oreNodePosition = oreNode.PrimaryPart.Position
        end

        if oreNodePosition then
            local distance = (tool.Handle.Position - oreNodePosition).Magnitude
            if distance <= MAX_HIT_DISTANCE then
                print("[Client] Hit OreNode!")
                game.ReplicatedStorage.RemoteEvents.MineResourceEvent:FireServer("Wood", oreNode)
            else
                print("[Client] Swung, but no OreNode in range!")
            end
        else
            warn("Could not determine position for OreNode. Is it an empty model?")
        end
    else
        print("[Client] Swung, but no OreNode found in Workspace!")
    end
end)