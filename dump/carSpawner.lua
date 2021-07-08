local name = "Torpedo"
local shouldWeld = true
local shouldAnchor = false

local vehicle = game:GetService("ReplicatedStorage").Resource.Vehicles:FindFirstChild(name)
local clone = vehicle:Clone()
local root = game:GetService("Players").LocalPlayer.Character.PrimaryPart
local rootCFrame = root.CFrame
local carRoot = clone.PrimaryPart
if shouldWeld then
    for i,v in pairs(clone:GetDescendants()) do
        if v:IsA("BasePart") and v ~= carRoot then
            local weld = Instance.new("WeldConstraint")
            
            weld.Part0 = carRoot
            weld.Part1 = v
            
            weld.Parent = v
        end
    end
end
if not shouldAnchor then
    for i,v in pairs(clone:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Anchored = false
        end
    end
end
clone.Parent = workspace.Vehicles

clone:SetPrimaryPartCFrame(rootCFrame)
root.CFrame = root.CFrame * CFrame.new(0,8,0)

print("Spawned "..name)
