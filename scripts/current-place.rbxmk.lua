local outputPath = ...
assert(type(outputPath) == "string" and outputPath ~= "", "missing output place path")

local place = Instance.new("DataModel")
place.Name = "Museu Empire"

local players = place:GetService("Players")
local workspace = place:GetService("Workspace")
local lighting = place:GetService("Lighting")
local starterPlayer = place:GetService("StarterPlayer")
local serverScriptService = place:GetService("ServerScriptService")

players.CharacterAutoLoads = true
lighting.Brightness = 2.2
lighting.ClockTime = 14
lighting.Ambient = Color3.fromRGB(130,130,140)
lighting.OutdoorAmbient = Color3.fromRGB(150,150,160)

local function part(name, size, pos, color, material, parent)
  local p = Instance.new("Part")
  p.Name = name
  p.Anchored = true
  p.Size = size
  p.Position = pos
  p.Color = color
  p.Material = material or "SmoothPlastic"
  p.Parent = parent or workspace
  return p
end

local world = Instance.new("Folder")
world.Name = "MuseuEmpireWorld"
world.Parent = workspace

part("Ground", Vector3.new(320,2,320), Vector3.new(0,0,0), Color3.fromRGB(74,88,74), "Grass", world)

local museum = Instance.new("Model")
museum.Name = "StarterMuseum"
museum.Parent = world

part("MuseumFloor", Vector3.new(110,2,90), Vector3.new(0,1,-20), Color3.fromRGB(225,222,215), "Marble", museum)
part("BackWall", Vector3.new(110,24,2), Vector3.new(0,13,-64), Color3.fromRGB(238,236,230), "Concrete", museum)
part("LeftWall", Vector3.new(2,24,90), Vector3.new(-54,13,-20), Color3.fromRGB(238,236,230), "Concrete", museum)
part("RightWall", Vector3.new(2,24,90), Vector3.new(54,13,-20), Color3.fromRGB(238,236,230), "Concrete", museum)
part("FrontLeft", Vector3.new(42,24,2), Vector3.new(-34,13,24), Color3.fromRGB(238,236,230), "Concrete", museum)
part("FrontRight", Vector3.new(42,24,2), Vector3.new(34,13,24), Color3.fromRGB(238,236,230), "Concrete", museum)
part("EntranceCarpet", Vector3.new(18,0.4,40), Vector3.new(0,2.2,16), Color3.fromRGB(110,24,32), "Fabric", museum)
part("Reception", Vector3.new(24,5,6), Vector3.new(0,4.5,-2), Color3.fromRGB(83,60,44), "Wood", museum)

local exhibitions = Instance.new("Folder")
exhibitions.Name = "Exhibitions"
exhibitions.Parent = museum

local function exhibition(index, name, x, price, income, prestige)
  local model = Instance.new("Model")
  model.Name = "Exhibition" .. tostring(index)
  model:SetAttribute("Index", index)
  model:SetAttribute("Price", price)
  model:SetAttribute("Income", income)
  model:SetAttribute("PrestigeReward", prestige)
  model:SetAttribute("Purchased", false)
  model.Parent = exhibitions

  part("DisplayBase", Vector3.new(12,2,12), Vector3.new(x,3,-30), Color3.fromRGB(44,46,52), "Marble", model)
  part("Pedestal", Vector3.new(5,7,5), Vector3.new(x,7.5,-30), Color3.fromRGB(230,230,228), "Marble", model)
  local artifact = part("Artifact", Vector3.new(3.2,5,3.2), Vector3.new(x,13.5,-30), Color3.fromRGB(214,168,70), "Metal", model)
  artifact.Transparency = 1
  artifact.CanCollide = false

  local pad = part("PurchasePad", Vector3.new(10,1,10), Vector3.new(x+14,2.5,-30), Color3.fromRGB(50,180,95), "Neon", model)
  local prompt = Instance.new("ProximityPrompt")
  prompt.Name = "BuyPrompt"
  prompt.ActionText = "Comprar exposição"
  prompt.ObjectText = name .. " · $" .. tostring(price)
  prompt.HoldDuration = 0.2
  prompt.MaxActivationDistance = 12
  prompt.RequiresLineOfSight = false
  prompt.Enabled = index == 1
  prompt.Parent = pad
end

exhibition(1, "Relíquia Antiga", -30, 100, 5, 1)
exhibition(2, "Cristal Imperial", 0, 350, 15, 2)
exhibition(3, "Coroa Dourada", 30, 900, 40, 4)

local spawn = Instance.new("SpawnLocation")
spawn.Name = "MuseumSpawn"
spawn.Anchored = true
spawn.Neutral = true
spawn.Size = Vector3.new(12,1,12)
spawn.Position = Vector3.new(0,3,48)
spawn.Material = "Neon"
spawn.Color = Color3.fromRGB(70,200,120)
spawn.Parent = world

local server = Instance.new("Script")
server.Name = "MuseumGameServer"
server.Source = [=[
local Players = game:GetService("Players")
local museum = workspace:WaitForChild("MuseuEmpireWorld"):WaitForChild("StarterMuseum")
local exhibitions = museum:WaitForChild("Exhibitions")

local ownerUserId = 0
local totalIncome = 0
local ordered = exhibitions:GetChildren()
table.sort(ordered, function(a,b) return (a:GetAttribute("Index") or 0) < (b:GetAttribute("Index") or 0) end)

local function setupPlayer(player)
  if player:FindFirstChild("leaderstats") then return end
  local stats = Instance.new("Folder")
  stats.Name = "leaderstats"
  stats.Parent = player
  local cash = Instance.new("IntValue") cash.Name = "Cash" cash.Value = 250 cash.Parent = stats
  local prestige = Instance.new("IntValue") prestige.Name = "Prestige" prestige.Value = 0 prestige.Parent = stats
  local exhibits = Instance.new("IntValue") exhibits.Name = "Exhibits" exhibits.Value = 0 exhibits.Parent = stats
end

Players.PlayerAdded:Connect(setupPlayer)
for _,p in ipairs(Players:GetPlayers()) do setupPlayer(p) end

for index,model in ipairs(ordered) do
  local pad = model:WaitForChild("PurchasePad")
  local prompt = pad:WaitForChild("BuyPrompt")
  local artifact = model:WaitForChild("Artifact")
  prompt.Triggered:Connect(function(player)
    if model:GetAttribute("Purchased") then return end
    if ownerUserId ~= 0 and ownerUserId ~= player.UserId then return end
    if index > 1 and not ordered[index-1]:GetAttribute("Purchased") then return end
    local stats = player:FindFirstChild("leaderstats")
    local cash = stats and stats:FindFirstChild("Cash")
    local prestige = stats and stats:FindFirstChild("Prestige")
    local exhibits = stats and stats:FindFirstChild("Exhibits")
    if not cash or not prestige or not exhibits then return end
    local price = model:GetAttribute("Price") or 0
    if cash.Value < price then return end
    cash.Value -= price
    ownerUserId = player.UserId
    model:SetAttribute("Purchased", true)
    artifact.Transparency = 0
    artifact.CanCollide = true
    prompt.Enabled = false
    totalIncome += model:GetAttribute("Income") or 0
    prestige.Value += model:GetAttribute("PrestigeReward") or 0
    exhibits.Value += 1
    local nextModel = ordered[index+1]
    if nextModel then
      local nextPrompt = nextModel:WaitForChild("PurchasePad"):WaitForChild("BuyPrompt")
      nextPrompt.Enabled = true
    end
  end)
end

task.spawn(function()
  while true do
    task.wait(5)
    if ownerUserId ~= 0 and totalIncome > 0 then
      local owner = Players:GetPlayerByUserId(ownerUserId)
      local stats = owner and owner:FindFirstChild("leaderstats")
      local cash = stats and stats:FindFirstChild("Cash")
      if cash then cash.Value += totalIncome end
    end
  end
end)
]=]
server.Parent = serverScriptService

local starterPlayerScripts = starterPlayer:FindFirstChild("StarterPlayerScripts")
if not starterPlayerScripts then
  starterPlayerScripts = Instance.new("StarterPlayerScripts")
  starterPlayerScripts.Name = "StarterPlayerScripts"
  starterPlayerScripts.Parent = starterPlayer
end

local client = Instance.new("LocalScript")
client.Name = "MuseuEmpireUI"
client.Source = [=[
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MuseuEmpireHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("TextLabel")
panel.Position = UDim2.fromOffset(14,14)
panel.Size = UDim2.fromOffset(280,100)
panel.BackgroundColor3 = Color3.fromRGB(18,22,28)
panel.BackgroundTransparency = 0.08
panel.TextColor3 = Color3.fromRGB(255,255,255)
panel.Font = Enum.Font.GothamBold
panel.TextSize = 16
panel.TextWrapped = true
panel.Parent = gui

local stats = player:WaitForChild("leaderstats")
local cash = stats:WaitForChild("Cash")
local prestige = stats:WaitForChild("Prestige")
local exhibits = stats:WaitForChild("Exhibits")

local function update()
  panel.Text = "MUSEU EMPIRE\n$ "..cash.Value.."   ★ "..prestige.Value.."\nExposições: "..exhibits.Value.."/3"
end
cash:GetPropertyChangedSignal("Value"):Connect(update)
prestige:GetPropertyChangedSignal("Value"):Connect(update)
exhibits:GetPropertyChangedSignal("Value"):Connect(update)
update()
]=]
client.Parent = starterPlayerScripts

fs.write(outputPath, place)
print("[Museu Empire] clean playable build prepared")
