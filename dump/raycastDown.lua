local character = game:GetService("Players").LocalPlayer.Character

local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = {character}
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

local ray = workspace:Raycast(character.PrimaryPart.Position, Vector3.new(0,-100,0),raycastParams)

if ray and ray.Instance then
    local hit = ray.Instance
    print("Instance found!")
    print(hit.Name.." ("..hit:GetFullName()..")")
else
    print("No instance found!")
end

print("---------------------------")
