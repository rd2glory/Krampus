local plr = game.Players.LocalPlayer

local forward = 8
local up = 16

local key = "T"
local key2 = "Y"

pcall(function()
    shared.e:Disconnect()
    shared.u:Disconnect()
    shared.j:Disconnect()
end)

shared.j = game.Players.LocalPlayer.CharacterAdded:Connect(function(c)
    root = c.PrimaryPart
end)

shared.e = game:GetService("UserInputService").InputBegan:Connect(function(input,gpe)
    local char = plr.Character
    
    if char and (not gpe) and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode[key] then
        local root = char.PrimaryPart
        root.CFrame = root.CFrame * CFrame.new(0,0,-forward)
    end
end)

shared.u = game:GetService("UserInputService").InputBegan:Connect(function(input,gpe)
    local char = plr.Character
    
    if char and (not gpe) and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode[key2] then
        local root = char.PrimaryPart
        root.CFrame = root.CFrame * CFrame.new(0,up,0)
    end
end)
