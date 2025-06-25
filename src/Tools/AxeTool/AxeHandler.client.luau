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

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

local animTrack = animator:LoadAnimation(tool:WaitForChild("AxeSwingAnimation"))

local MAX_HIT_DISTANCE = 10

tool.Equipped:Connect(function()
	print("[Client] Axe equipped!")
	animTrack:Play()
end)

tool.Activated:Connect(function()
	print("[Client] Axe swung!")

	local oreNode = workspace:FindFirstChild("OreNode")
	if oreNode then
		local distance = (tool.Handle.Position - oreNode.Position).Magnitude
		if distance <= MAX_HIT_DISTANCE then
			print("[Client] Hit OreNode!")
			game.ReplicatedStorage.RemoteEvents.MineResourceEvent:FireServer("Wood", oreNode)
		else
			print("[Client] Swung, but no OreNode in range!")
		end
	else
		print("[Client] Swung, but no OreNode found in Workspace!")
	end
end)
