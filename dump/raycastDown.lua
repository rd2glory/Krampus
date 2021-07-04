local character = game:GetService("Players").LocalPlayer.Character

local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = {character}
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

local function doRaycast()
	local ray = workspace:Raycast(character.PrimaryPart.Position, Vector3.new(0,-100,0),raycastParams)

	if ray and ray.Instance then
		local hit = ray.Instance
		print("Instance found!")
		print(hit.Name.." ("..hit:GetFullName()..")")
	else
		print("No instance found!")
	end

	print("---------------------------")
end

pcall(function()
	shared.z:Disconnect()
end)

local key = "N"

shared.z = game:GetService("UserInputService").InputBegan:Connect(function(input,gpe)
	if not gpe and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode[key] then
		doRaycast()
	end
end)
