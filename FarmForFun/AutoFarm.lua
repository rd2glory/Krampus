local plr = game.Players.LocalPlayer
if not shared.farm then
    -- Finds which farm is yours
    local Plots = workspace.__THINGS.Plots
    
    local myPlot = nil
    for _,plot in pairs(Plots:GetChildren()) do
        if plot.Sign.Screen.SurfaceGui.Frame.Username.Text == plr.Name.."'s" then
            myPlot = plot
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
        local timeDelay = wait()
        local hb = game:GetService("RunService").Heartbeat
        shared.farm = game:GetService("RunService").RenderStepped:Connect(function(dt)
            if not db and os.clock()-last>=timeDelay and plr.Character then
                db = true
                last = os.clock()
                local c = plr.Character
                local root = c.PrimaryPart
                local hum = c.Humanoid
                root.Anchored = true
                local c = squares[current]
                if #c:GetChildren() > 0 then -- It is an active square
                    local o = #c:GetChildren()
                    root.CFrame = c.CFrame + Vector3.new(0,4,0)
                    local fence = c:FindFirstChild("_fence")
                    local model = c:FindFirstChild("_model")
                    if fence and c.SquareCost.Price.TextColor3 ~= grey then
                        local part = fence.fence
                        local start = os.clock()
                        root.Anchored = false
                        root.CFrame = part.CFrame * CFrame.new(10,0,0)
                        repeat 
                            hum:MoveTo(part.CFrame.Position)
                            hb:wait()
                        until not fence or not fence:IsDescendantOf(game) or os.clock()-start > 2
                        root.Anchored = true
                    elseif model then
                        root.CFrame = c.CFrame + Vector3.new(15,4,0)
                        local start = os.clock()
                        root.Anchored = false
                        local connect = nil
                        local move = nil 
                        move = hb:Connect(function()
                            hum:MoveTo(c.Position + Vector3.new(0,4,0))
                            if #c:GetChildren() ~= o or os.clock()-start > 2 then
                                move:Disconnect()
                                connect:Disconnect()
                            end
                        end)
                        connect = hum.MoveToFinished:Connect(function()
                            connect:disconnect()
                            move:Disconnect()
                        end)
                        
                    end
                end
                current = current + 1
                if current > #squares then
                    current = 1
                end
                db = false
            end
        end)
    end
else
    pcall(function()
        shared.farm:Disconnect()
    end)
    pcall(function()
        plr.Character.PrimaryPart.Anchored = false
    end)
    shared.farm = nil
end
