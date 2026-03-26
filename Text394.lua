repeat task.wait() until game:IsLoaded()



-- 🔥 NORMALIZAR
local function normalize(str)
    return string.gsub(str:lower(), "%s+", "")
end

-- 🔥 TABLA DE TRADUCCIÓN
local translate = {
    -- COMIDA
    ["hamburguesa"]="burger", ["burger"]="burger",
    ["refresco"]="cola", ["cola"]="cola",
    ["pastel"]="cake", ["cake"]="cake",
    ["tarta"]="pie", ["pie"]="pie",
    ["perrocaliente"]="hotdog", ["hotdog"]="hotdog",
    ["jamon"]="ham", ["ham"]="ham",
    ["barraenergia"]="energybar", ["energybar"]="energybar",

    -- CURACIÓN
    ["botiquin"]="medkit", ["medkit"]="medkit",
    ["cura"]="medkit",
    ["vendas"]="bandage", ["bandage"]="bandage",

    -- ARMAS
    ["katana"]="katana", ["espada"]="katana",
    ["sable"]="saber",
    ["machete"]="machette", ["machette"]="machette",

    ["pistola"]="pistol", ["pistol"]="pistol",
    ["rifle"]="ar", ["ar"]="ar",
    ["rifledorado"]="goldar", ["goldar"]="goldar",

    ["escopeta"]="pumpshotgun", ["pumpshotgun"]="pumpshotgun",
    ["escopetachatarra"]="scrappyshotgun", ["scrappyshotgun"]="scrappyshotgun",

    ["subfusil"]="mac10", ["mac10"]="mac10",
    ["smgchatarra"]="scrappysmg", ["scrappysmg"]="scrappysmg",

    ["minigundorada"]="goldminigun", ["goldminigun"]="goldminigun",

    ["armarefresco"]="sodagun", ["sodagun"]="sodagun"
}

-- 🔥 SERVICIOS
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Backpack = LocalPlayer:WaitForChild("Backpack")
local ItemsFolder = Workspace:WaitForChild("Map"):WaitForChild("Util"):WaitForChild("Items")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local PickupRemote = Remotes:WaitForChild("RequestPickupItem")

-- 🔥 NORMALIZAR ITEM
local TARGET = normalize(getgenv().GRAB_ITEM)
for k,v in pairs(translate) do
    if string.find(normalize(k), TARGET) then
        TARGET = normalize(v)
        break
    end
end

-- 🔥 RECOGER ITEM (solo una vez)
local function FindAndGrabItem()
    for _, Item in pairs(ItemsFolder:GetChildren()) do
        if Item:IsA("Tool") then
            local name = normalize(Item.Name)
            if name == TARGET then
                PickupRemote:FireServer(Item)
                repeat task.wait(0.1) until Backpack:FindFirstChild(Item.Name) or Character:FindFirstChild(Item.Name)
                print("✅ Item recogido:", Item.Name)
                break -- solo uno
            end
        end
    end
end

-- Ejecutar
FindAndGrabItem()
