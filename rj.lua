local Players = game:GetService("Players")
local TS = game:GetService("TeleportService")

local PlaceId = game.PlaceId
local JobId = game.JobId
local Player = Players.LocalPlayer

print("Teleporting...")

if (#Players:GetPlayers() <= 1) then
	TS:Teleport(PlaceId, Player);
else
	TS:TeleportToPlaceInstance(PlaceId, JobId, Player);
end
