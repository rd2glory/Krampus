local function update()
    for i,v in pairs(game:GetService("Workspace").tower:GetDescendants()) do
        if v:IsA("BoolValue") and v.Name == "kills" then
            v.Parent:Destroy()
        end
    end
end

workspace.DescendantAdded:Connect(update)
workspace.DescendantRemoved:Connect(update)

update()

print("all done")
