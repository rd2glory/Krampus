local root = game.Players.LocalPlayer.Character.PrimaryPart

local forward = 8
local up = 0
local side = 0

pcall(function()
    shared.e:Disconnect()
end)

shared.e = game:GetService("UserInputService").InputBegan:Connect(function(input,gpe)
    if gpe and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.F8 then
        root.CFrame = root.CFrame * CFrame.new(side,up,-forward)
    end
end)
