local sections = workspace.tower.sections

for i,v in pairs(sections:GetChildren()) do
    if v.Name ~= "start" and v.Name ~= "finish" then
        local killParts = v:FindFirstChild("Killparts") or v:FindFirstChild("killParts")
        if killParts then
            killParts:Destroy()
        end
        for _,d in pairs(v:GetDescendants()) do
            if d.Name == "killPart" or d.Name == "Killpart" then
                d:Destroy()
            end
        end
    end
end

print("e")
