local hb = game:GetService("RunService").Heartbeat

local player = game:GetService("Players").LocalPlayer

local doActivate = false
local resetAtEnd = true

local swordName = "Sword"
local sword = player.Backpack:FindFirstChild(swordName) or player.Character:FindFirstChild(swordName)
local handle = sword.Handle

sword.Parent = player.Character

for _,target in pairs(game:GetService("Players"):GetPlayers()) do
    if target == player then continue end
    if player.Character.Humanoid.Health <= 0 then break end
    print("killing ",target.Name,"!")

    local char = target.Character
    local humanoid = char.Humanoid

    while humanoid.Health > 0 do
        if doActivate then
            sword:Activate()
        end

        local loopParts = {}

        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                table.insert(loopParts,v)
            end
        end

        local i = 1
        while i<=#loopParts and humanoid.Health > 0 do
            pcall(firetouchinterest,handle,loopParts[i],0)
            -- Prepare for next iteration
            i = i+1
            hb:Wait()

            pcall(firetouchinterest,handle,loopParts[i],1)
        end
        hb:Wait()
    end
end

if resetAtEnd then
    player.Character.Humanoid.Health = 0
end
