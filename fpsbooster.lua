-- Credits to RIP#6666

if not game:IsLoaded() then game.Loaded:Wait() end

if not _G.Settings then
    _G.Settings = {
        Players = {
            ["Ignore Me"] = true,
            ["Ignore Others"] = true
        },
        Meshes = {
            Destroy = false,
            LowDetail = true
        },
        Images = {
            Invisible = true,
            LowDetail = false,
            Destroy = false
        },
        Other = {
            ["No Particles"] = true,
            ["No Camera Effects"] = true,
            ["No Explosions"] = true,
            ["No Clothes"] = true,
            ["Low Water Graphics"] = true,
            ["No Shadows"] = true,
            ["Low Rendering"] = true,
            ["Low Quality Parts"] = true
        }
    }
end

local Players, Lighting = game:GetService("Players"), game:GetService("Lighting")
local ME = Players.LocalPlayer
local BadInstances = {"DataModelMesh", "FaceInstance", "ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles", "PostEffect", "Explosion", "Clothing", "BasePart"}
local CanBeEnabled = {"ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles", "PostEffect"}

local function PartOfCharacter(Instance)
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character and Instance:IsDescendantOf(v.Character) then
            return true
        end
    end
    return false
end

local function ReturnDescendants()
    local Descendants = {}
    WaitNumber = 5000
    if _G.Settings.Players["Ignore Others"] then
        for i, v in pairs(game:GetDescendants()) do
            if not v:IsDescendantOf(Players) and not PartOfCharacter(v) then
                for _, v2 in pairs(BadInstances) do
                    if v:IsA(v2) then
                        table.insert(Descendants, v)
                    end
                end
            end
            if i == WaitNumber then
                task.wait()
                WaitNumber = WaitNumber + 5000
            end
        end
    elseif _G.Settings.Players["Ignore Me"] then
        for i, v in pairs(game:GetDescendants()) do
            if not v:IsDescendantOf(Players) and not v:IsDescendantOf(ME.Character) then
                for i2, v2 in pairs(BadInstances) do
                    if v:IsA(v2) then
                        table.insert(Descendants, v)
                    end
                end
            end
            if i == WaitNumber then
                task.wait()
                WaitNumber = WaitNumber + 5000
            end
        end
    elseif _G.Settings.Players["Ignore Me"] and _G.Settings.Players["Ignore Others"] then
        for i, v in pairs(game:GetDescendants()) do
            if not v:IsDescendantOf(Players) and not v:IsDescendantOf(ME.Character) and not PartOfCharacter(v) then
                for i2, v2 in pairs(BadInstances) do
                    if v:IsA(v2) then
                        table.insert(Descendants, v)
                    end
                end
            end
            if i == WaitNumber then
                task.wait()
                WaitNumber = WaitNumber + 5000
            end
        end
    else
        for i, v in pairs(game:GetDescendants()) do
            if not v:IsDescendantOf(Players) then
                for i2, v2 in pairs(BadInstances) do
                    if v:IsA(v2) then
                        table.insert(Descendants, v)
                    end
                end
            end
            if i == WaitNumber then
                task.wait()
                WaitNumber = WaitNumber + 5000
            end
        end
    end
    return Descendants
end
local function CheckIfBad(Instance)
    if not Instance:IsDescendantOf(Players) and not PartOfCharacter(Instance) then
        if Instance:IsA("DataModelMesh") then
            if _G.Settings.Meshes.LowDetail then
                --sethiddenproperty(Instance, "LODX", Enum.LevelOfDetailSetting.Low)
                --sethiddenproperty(Instance, "LODY", Enum.LevelOfDetailSetting.Low)
            elseif _G.Settings.Meshes.Destroy then
                Instance:Destroy()
            end
        elseif Instance:IsA("FaceInstance") then
            if _G.Settings.Images.Invisible then
                Instance.Transparency = 1
            elseif _G.Settings.Images.LowDetail then
                Instance.Shiny = 1
            elseif _G.Settings.Images.Destroy then
                Instance:Destroy()
            end
        elseif table.find(CanBeEnabled, Instance.ClassName) then
            if _G.Settings["No Particles"] or (_G.Settings.Other and _G.Settings.Other["No Particles"]) then
                Instance.Enabled = false
            end
        elseif Instance:IsA("PostEffect") and (_G.Settings["No Camera Effects"] or (_G.Settings.Other and _G.Settings.Other["No Camera Effects"])) then
            Instance.Enabled = false
        elseif Instance:IsA("Explosion") then
            if _G.Settings["No Explosions"] or (_G.Settings.Other and _G.Settings.Other["No Explosions"]) then
                Instance.Visible = false
            end
        elseif Instance:IsA("Clothing") then
            if _G.Settings["No Clothes"] or (_G.Settings.Other and _G.Settings.Other["No Clothes"]) then
                Instance:Destroy()
            end
        elseif Instance:IsA("BasePart") then
            if _G.Settings["Low Quality Parts"] or (_G.Settings.Other and _G.Settings.Other["Low Quality Parts"]) then
                Instance.Material = Enum.Material.Plastic
                Instance.Reflectance = 0
            end
        end
    end
end

coroutine.wrap(pcall)(function()
    if (_G.Settings["Low Water Graphics"] or (_G.Settings.Other and _G.Settings.Other["Low Water Graphics"])) then
        if not workspace:FindFirstChildOfClass("Terrain") then
            repeat
                task.wait()
            until workspace:FindFirstChildOfClass("Terrain")
        end
        workspace:FindFirstChildOfClass("Terrain").WaterWaveSize = 0
        workspace:FindFirstChildOfClass("Terrain").WaterWaveSpeed = 0
        workspace:FindFirstChildOfClass("Terrain").WaterReflectance = 0
        workspace:FindFirstChildOfClass("Terrain").WaterTransparency = 0
        sethiddenproperty(workspace:FindFirstChildOfClass("Terrain"), "Decoration", false)
    end
end)
coroutine.wrap(pcall)(function()
    if _G.Settings["No Shadows"] or (_G.Settings.Other and _G.Settings.Other["No Shadows"]) then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        sethiddenproperty(Lighting, "Technology", 2)
    end
end)
coroutine.wrap(pcall)(function()
    if _G.Settings["Low Rendering"] or (_G.Settings.Other and _G.Settings.Other["Low Rendering"]) then
        settings().Rendering.QualityLevel = 1
    end
end)

local Descendants = ReturnDescendants()
local WaitNumber = 500

for i, v in pairs(Descendants) do
    CheckIfBad(v)
    if i == WaitNumber then
        task.wait()
        WaitNumber = WaitNumber + 500
    end
end

game.DescendantAdded:Connect(CheckIfBad)
