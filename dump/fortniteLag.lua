local player = game:GetService("Players").LocalPlayer

local glider = player.Backpack:FindFirstChild("Fortnite Glider") or player.Character:FindFirstChild("Fortnite Glider")
glider.Parent = player.Backpack

local inCharacter = false

game:GetService("RunService").Heartbeat:Connect(function()
    if shared.e then
        if inCharacter then
            glider.Parent = player.Backpack
        else
            glider.Parent = player.Character
        end

        inCharacter = not inCharacter
    end
end)
