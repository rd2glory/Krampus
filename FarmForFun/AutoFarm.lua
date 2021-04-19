
--// KRAMPUS \\--
-- Da Hood Character Hider Script v1.0
-- obfuscating is for losers

if not shared.KrampusLoader then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/iamtryingtofindname/Krampus/main/loader",true))()
end

shared.KrampusLoader(6598746935,"AutoFarm",function(initTopBarButton,topLeft,topRight,extra)
	local State = Instance.new("TextLabel")

	local _db = false
	local plr = game.Players.LocalPlayer

	local ToggleButton = initTopBarButton(function(self)
		if _db then return end
		_db = true
		if not shared.farm then
			State.Text = "ON"
			-- Finds which farm is yours
			local Plots = workspace.__THINGS.Plots

			local myPlot = nil
			for _,plot in pairs(Plots:GetChildren()) do
				if plot.Sign.Screen.SurfaceGui.Frame.Username.Text == plr.Name.."'s" then
					myPlot = plot
					for _,v in pairs(myPlot.Sign:GetDescendants()) do
						if v:IsA("Part") then
							v.CanCollide = false		
						end
					end
					break
				end
			end
			if not myPlot then
				warn("Plot not found!")
			else
				local squares = myPlot.Plot.Squares:GetChildren()
				local last = 0
				local current = 1
				local db = false
				local grey = Color3.fromRGB(135,135,135)
				local timeDelay = 0.05
				local hb = game:GetService("RunService").Heartbeat
				shared.farm = game:GetService("RunService").RenderStepped:Connect(function(dt)
					if not db and os.clock()-last>=timeDelay and plr.Character then
						db = true
						pcall(function()
							local c = plr.Character
							local root = c.PrimaryPart
							local hum = c.Humanoid
							local c = squares[current]
							local o = #c:GetChildren()
							if o > 0 and not (o == 1 and c:GetChildren()[1]:IsA("Sound")) then -- It is an active square
								last = os.clock()
								local height = 5
								root.CFrame = c.CFrame + Vector3.new(0,height,0)
								local fence = c:FindFirstChild("_fence")
								local model = c:FindFirstChild("_model")
								if fence and c.SquareCost.Price.TextColor3 ~= grey then
									local part = fence.PrimaryPart
									local start = os.clock()
									root.CFrame = part.CFrame * CFrame.new(10,height,0)
									repeat 
										hum:MoveTo(part.Position)
										hb:wait()
									until not fence or not fence:IsDescendantOf(game) or os.clock()-start > 2
								elseif model and c:FindFirstChild("_ReadyParticles") then
									root.CFrame = c.CFrame + Vector3.new(12,height,0)
									local start = os.clock()
									local connect = nil
									local move = nil
									local con = false
									move = hb:Connect(function()
										hum:MoveTo(c.Position + Vector3.new(0,height,0))
										if os.clock()-start > 2 then
											move:Disconnect()
											connect:Disconnect()
											con = true
										end
									end)
									connect = hum.MoveToFinished:Connect(function()
										connect:disconnect()
										move:Disconnect()
										con = true
									end)
									repeat hb:wait() until con
								end
							else
								last = 0
							end
							current = current + 1
							if current > #squares then
								current = 1
							end
						end)
						db = false
					end
				end)
			end
		else
			State.Text = "OFF"
			pcall(function()
				shared.farm:Disconnect()
			end)
			shared.farm = nil
		end
		_db = false
	end) -- Makes a topbar button

	State.Name = "State"
	State.Parent = ToggleButton:WaitForChild("Background")
	State.AnchorPoint = Vector2.new(0.5, 0.5)
	State.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	State.BackgroundTransparency = 1
	State.Position = UDim2.new(0.5, -1, 0.5, 0)
	State.Size = UDim2.new(0.75, 0, 0.75, 0)
	State.Font = Enum.Font.GothamBold
	State.Text = "OFF"
	State.TextColor3 = Color3.fromRGB(255, 255, 255)
	State.TextScaled = true
	State.TextSize = 14
	State.TextWrapped = true

	ToggleButton.Parent = topLeft
end)
