local plr = game:GetService("Players").LocalPlayer

game:GetService("RunService").RenderStepped:Connect(function()
    local gui = plr.PlayerGui
    if gui then
        local context = gui:FindFirstChild("ContextMessageGui")
        if context then
            context.Enabled = false
        end
    end
end)
