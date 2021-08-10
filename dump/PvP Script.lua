-- For https://www.roblox.com/games/7128097819/Sky-Wars-Pvp? 

local player = game:GetService("Players").LocalPlayer

local afl = player.Backpack:FindFirstChild("AFK") or player.Character:FindFirstChild("AFK")


afl.RemoteEvent:FireServer(false)

local player = game:GetService("Players").LocalPlayer

local swordName = "PvP Sword"
local sword = player.Backpack:FindFirstChild(swordName) or player.Character:FindFirstChild(swordName)

sword.Parent = player.Character

local target = game:GetService("Players").Coruhhptions

while target.Character.Humanoid.Health > 0 do
    firetouchinterest(sword.Handle,target.Character:FindFirstChild("Head"),0)
    wait()
    firetouchinterest(sword.Handle,target.Character:FindFirstChild("Head"),1)
end
