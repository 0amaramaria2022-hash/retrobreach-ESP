-- =====================================================
-- 📦 RAYFIELD / XENO
-- =====================================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Retrobreach ESP",
    LoadingTitle = "By Tiagato",
    LoadingSubtitle = "Rayfield/ALL EXECUTORS",
    ConfigurationSaving = { Enabled = false }
})

-- =====================================================
-- 📌 SERVICES
-- =====================================================
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local Workspace = game:GetService("Workspace")

-- =====================================================
-- 📌 TABS
-- =====================================================
local GunsTab    = Window:CreateTab("Guns", 4483362458)
local KeycardTab = Window:CreateTab("Cards", 4483362458)
local MedkitsTab = Window:CreateTab("Medkits", 4483362458)
local GrenadesTab= Window:CreateTab("Granades", 4483362458)
local ESPTab     = Window:CreateTab("Players", 4483362458)

-- =====================================================
-- 🔫 WEAPONS ESP (nome apenas)
-- =====================================================
local ItemSpawns = Workspace:WaitForChild("ItemSpawns")
local WeaponESPs = {}
local WeaponEnabled = {}

local Weapons = {
    Pistols = {"Desert Eagle","USP","Beretta M9","RSH-12","M1911","G17","Micro Uzi","Five-Seven","MP443","Beretta 93R","Makarov"},
    SubMachines = {"MP9","UMP-45","MAC-10","Kriss Vector","Uzi","MP5","MP7A1","MP5SD","Bizon","P90"},
    Shotguns = {"AA-12","SPAS-12","Saiga-12","M4 Super 90","Double Barrel","USAS-12","KS-23M","UTS-15","Mossberg"},
    AssaultGuns = {"AUG","M4A1","M16","F2000","L85A2","SG-552","AS VAL","Honey Badger","G36","AKM","AK-74","AKS-74U","HK416","FAMAS","SCAR-L","XM8"},
    WarMachines = {"Mk14 EBR","ASh-12","SCAR-H"},
    LightGuns = {"RPK","M249"}
}

local WeaponColors = {
    Pistols = Color3.fromRGB(0,0,0),
    SubMachines = Color3.fromRGB(128,128,128),
    Shotguns = Color3.fromRGB(255,0,0),
    AssaultGuns = Color3.fromRGB(0,0,255),
    WarMachines = Color3.fromRGB(0,255,0),
    LightGuns = Color3.fromRGB(255,255,0)
}

local WeaponLookup = {}
for cat, list in pairs(Weapons) do
    for _, name in ipairs(list) do
        WeaponLookup[name] = cat
    end
end

local function getPart(obj)
    return obj:FindFirstChildWhichIsA("BasePart", true)
end

local function createWeaponESP(model)
    if WeaponESPs[model] then return end
    local part = getPart(model)
    if not part then return end

    local gui = Instance.new("BillboardGui")
    gui.Adornee = part
    gui.Size = UDim2.new(0,120,0,22)
    gui.StudsOffset = Vector3.new(0,2.7,0)
    gui.AlwaysOnTop = true

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.fromScale(1,1)
    txt.BackgroundTransparency = 1
    txt.Text = model.Name
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    txt.TextColor3 = WeaponColors[WeaponLookup[model.Name]] or Color3.new(1,1,1)
    txt.TextStrokeTransparency = 0.3
    txt.Parent = gui

    gui.Parent = part
    WeaponESPs[model] = gui
end

local function removeWeaponESP(model)
    if WeaponESPs[model] then
        WeaponESPs[model]:Destroy()
        WeaponESPs[model] = nil
    end
end

for category in pairs(Weapons) do
    WeaponEnabled[category] = false
    GunsTab:CreateToggle({
        Name = category,
        Callback = function(v)
            WeaponEnabled[category] = v
            for _, obj in ipairs(ItemSpawns:GetChildren()) do
                if obj:IsA("Model") and WeaponLookup[obj.Name] == category then
                    if v then createWeaponESP(obj) else removeWeaponESP(obj) end
                end
            end
        end
    })
end

ItemSpawns.ChildAdded:Connect(function(obj)
    if WeaponLookup[obj.Name] and WeaponEnabled[WeaponLookup[obj.Name]] then
        createWeaponESP(obj)
    end
end)
ItemSpawns.ChildRemoved:Connect(removeWeaponESP)

-- =====================================================
-- 🪪 CARDS ESP
-- =====================================================
local CardESPs = {}
local CardEnabled = {}
local CardData = {
    ["01"] = {"Janitor Card"},
    ["02"] = {"Doctor Card","Engineer Card","Scientist Card"},
    ["03"] = {"Containment Engineer Card","Major Scientist Card","Medical Specialist Card","Zone Manager Card","Facility Manager Card","Guard Card"},
    ["04"] = {"Commander Card","Hacking Device","Lieutenant Card","MTF Operative Card"},
    ["05"] = {"O5 Council Card"}
}
local CardColors = {
    ["01"] = Color3.fromRGB(255,255,255),
    ["02"] = Color3.fromRGB(128,128,128),
    ["03"] = Color3.fromRGB(255,165,0),
    ["04"] = Color3.fromRGB(255,0,0),
    ["05"] = Color3.fromRGB(0,0,0)
}

local function createCardESP(model, cardNum)
    if CardESPs[model] then return end
    local part = getPart(model)
    if not part then return end

    local gui = Instance.new("BillboardGui")
    gui.Adornee = part
    gui.Size = UDim2.new(0,80,0,20)
    gui.StudsOffset = Vector3.new(0,2.5,0)
    gui.AlwaysOnTop = true

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.fromScale(1,1)
    txt.BackgroundTransparency = 1
    txt.Text = cardNum
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    txt.TextColor3 = CardColors[cardNum]
    txt.TextStrokeTransparency = 0.3
    txt.Parent = gui

    gui.Parent = part
    CardESPs[model] = gui
end

local function removeCardESP(model)
    if CardESPs[model] then
        CardESPs[model]:Destroy()
        CardESPs[model] = nil
    end
end

for num, list in pairs(CardData) do
    CardEnabled[num] = false
    KeycardTab:CreateToggle({
        Name = "Card "..num,
        Callback = function(v)
            CardEnabled[num] = v
            for _, obj in ipairs(ItemSpawns:GetChildren()) do
                for _, name in ipairs(list) do
                    if obj.Name == name then
                        if v then createCardESP(obj,num) else removeCardESP(obj) end
                    end
                end
            end
        end
    })
end

ItemSpawns.ChildAdded:Connect(function(obj)
    for num, list in pairs(CardData) do
        for _, name in ipairs(list) do
            if obj.Name == name and CardEnabled[num] then
                createCardESP(obj,num)
            end
        end
    end
end)

ItemSpawns.ChildRemoved:Connect(removeCardESP)

-- =====================================================
-- 💊 MEDKITS ESP
-- =====================================================
local MedkitESPs = {}
local MedkitEnabled = {}
local Medkits = {"Bandage","Medkit","SCP-500-D"}
local MedkitColors = {Bandage=Color3.fromRGB(128,128,128), Medkit=Color3.fromRGB(255,0,0), ["SCP-500-D"]=Color3.fromRGB(255,105,180)}

for _, name in ipairs(Medkits) do
    MedkitEnabled[name] = false
    MedkitsTab:CreateToggle({
        Name = name,
        Callback = function(v)
            MedkitEnabled[name] = v
            for _, obj in ipairs(ItemSpawns:GetChildren()) do
                if obj.Name == name then
                    if v then createWeaponESP(obj) else removeWeaponESP(obj) end
                end
            end
        end
    })
end

ItemSpawns.ChildAdded:Connect(function(obj)
    if MedkitEnabled[obj.Name] then createWeaponESP(obj) end
end)
ItemSpawns.ChildRemoved:Connect(removeWeaponESP)

-- =====================================================
-- 💣 GRENADES ESP
-- =====================================================
local GrenadeESPs = {}
local GrenadeEnabled = {}
local Grenades = {"Flashbang","Frag Grenade","Incendiary Grenade","Smoke Grenade"}
local GrenadeColors = {["Flashbang"]=Color3.fromRGB(255,255,255),["Frag Grenade"]=Color3.fromRGB(0,255,0),["Incendiary Grenade"]=Color3.fromRGB(255,0,0),["Smoke Grenade"]=Color3.fromRGB(128,128,128)}

for _, name in ipairs(Grenades) do
    GrenadeEnabled[name] = false
    GrenadesTab:CreateToggle({
        Name = name,
        Callback = function(v)
            GrenadeEnabled[name] = v
            for _, obj in ipairs(ItemSpawns:GetChildren()) do
                if obj.Name == name then
                    if v then createWeaponESP(obj) else removeWeaponESP(obj) end
                end
            end
        end
    })
end

ItemSpawns.ChildAdded:Connect(function(obj)
    if GrenadeEnabled[obj.Name] then createWeaponESP(obj) end
end)
ItemSpawns.ChildRemoved:Connect(removeWeaponESP)

-- =====================================================
-- 👁️ PLAYERS ESP (nome + HP)
-- =====================================================
local TeamESPEnabled = false
local TeamESPs = {}

local TeamConfig = {
    ["SCP"] = { Text = "SCP", Color = Color3.fromRGB(255,105,180) },
    ["Class-D"] = { Text = "Class-D", Color = Color3.fromRGB(255,140,0) },
    ["Chaos Insurgency"] = { Text = "Chaos", Color = Color3.fromRGB(0,200,0) },
    ["Mobile Task Forces"] = { Text = "MTF", Color = Color3.fromRGB(0,60,180) },
    ["Security Department"] = { Text = "Security", Color = Color3.fromRGB(255,255,255) },
    ["Foundation Personnel"] = { Text = "Foundation", Color = Color3.fromRGB(160,160,160) },
    ["Global Occult Coalition"] = { Text = "GOC", Color = Color3.fromRGB(0,200,200) },
    ["Serpents Hand"] = { Text = "Serpents", Color = Color3.fromRGB(200,0,0) },
    ["Lobby"] = { Text = "Lobby", Color = Color3.fromRGB(128,128,128) },
    ["FFA"] = { Text = "FFA", Color = Color3.fromRGB(200,200,200) }
}

local function clearPlayerESP(player)
    if TeamESPs[player] then
        TeamESPs[player]:Destroy()
        TeamESPs[player] = nil
    end
end

local function createPlayerESP(player)
    if not player.Character or not player.Team then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local hum = player.Character:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not hum then return end

    if TeamESPs[player] then TeamESPs[player]:Destroy() end

    local gui = Instance.new("BillboardGui")
    gui.Adornee = hrp
    gui.Size = UDim2.new(0,160,0,24)
    gui.StudsOffset = Vector3.new(0,3,0)
    gui.AlwaysOnTop = true

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.fromScale(1,1)
    txt.BackgroundTransparency = 1
    txt.Text = string.format("[%s] %s | HP %d", player.Team.Name, player.Name, math.floor(hum.Health))
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    txt.TextColor3 = TeamConfig[player.Team.Name] and TeamConfig[player.Team.Name].Color or Color3.new(1,1,1)
    txt.TextStrokeTransparency = 0.3
    txt.Parent = gui

    gui.Parent = hrp
    TeamESPs[player] = gui
end

-- Atualização periódica a cada 1 segundo
task.spawn(function()
    while true do
        task.wait(1)
        if TeamESPEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                createPlayerESP(plr)
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if TeamESPEnabled then createPlayerESP(plr) end
    end)
end)

Players.PlayerRemoving:Connect(clearPlayerESP)

ESPTab:CreateToggle({
    Name = "Players ESP",
    Callback = function(v)
        TeamESPEnabled = v
        if not v then
            for p in pairs(TeamESPs) do clearPlayerESP(p) end
        end
    end
})
