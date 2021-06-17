local plr = game.Players.LocalPlayer

local forward = 8
local up = 0
local side = 0

local key = "T"

pcall(function()
    shared.e:Disconnect()
    shared.j:Disconnect();
end)

shared.j = game.Players.LocalPlayer.CharacterAdded:Connect(function(c)
    root = c.PrimaryPart
end)

shared.e = game:GetService("UserInputService").InputBegan:Connect(function(input,gpe)
    local char = plr.Character
    
    if char and (not gpe) and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode[key] then
        local root = char.PrimaryPart
        root.CFrame = root.CFrame * CFrame.new(side,up,-forward)
    end
end)
