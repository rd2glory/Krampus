local root = game.Players.LocalPlayer.Character.PrimaryPart

local forward = 8
local up = 0
local side = 0

pcall(function()
    shared.e:Disconnect()
    shared.j:Disconnect();
end)

shared.j = game.Players.LocalPlayer.CharacterAdded:Connect(function(c)
    root = c.PrimaryPart
end)

shared.e = game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.F8 then
        root.CFrame = root.CFrame * CFrame.new(side,up,-forward)
    end
end)
