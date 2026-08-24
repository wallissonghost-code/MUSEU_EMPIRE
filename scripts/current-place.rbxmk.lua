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

part("Ground", Vector3.new(420,2,360), Vector3.new(25,0,0), Color3.fromRGB(74,88,74), "Grass", world)

local museum = Instance.new("Model")
museum.Name = "StarterMuseum"
museum.Parent = world

part("MuseumFloor", Vector3.new(110,2,90), Vector3.new(0,1,-20), Color3.fromRGB(225,222,215), "Marble", museum)
part("BackWall", Vector3.new(110,24,2), Vector3.new(0,13,-64), Color3.fromRGB(238,236,230), "Concrete", museum)
part("LeftWall", Vector3.new(2,24,90), Vector3.new(-54,13,-20), Color3.fromRGB(238,236,230), "Concrete", museum)
part("RightWallFront", Vector3.new(2,24,37), Vector3.new(54,13,5), Color3.fromRGB(238,236,230), "Concrete", museum)
part("RightWallBack", Vector3.new(2,24,37), Vector3.new(54,13,-45), Color3.fromRGB(238,236,230), "Concrete", museum)
part("FrontLeft", Vector3.new(42,24,2), Vector3.new(-34,13,24), Color3.fromRGB(238,236,230), "Concrete", museum)
part("FrontRight", Vector3.new(42,24,2), Vector3.new(34,13,24), Color3.fromRGB(238,236,230), "Concrete", museum)
part("EntranceCarpet", Vector3.new(18,0.4,40), Vector3.new(0,2.2,16), Color3.fromRGB(110,24,32), "Fabric", museum)
part("Reception", Vector3.new(24,5,6), Vector3.new(0,4.5,-2), Color3.fromRGB(83,60,44), "Wood", museum)

local header = part("MuseumHeader", Vector3.new(26,7,2), Vector3.new(0,21.5,24), Color3.fromRGB(28,31,39), "SmoothPlastic", museum)
local signGui = Instance.new("SurfaceGui")
signGui.Face = "Front"
signGui.CanvasSize = Vector2.new(900,240)
signGui.Parent = header
local signText = Instance.new("TextLabel")
signText.Size = UDim2.new(1,0,1,0)
signText.BackgroundTransparency = 1
signText.Text = "MUSEU EMPIRE"
signText.TextColor3 = Color3.fromRGB(245,208,108)
signText.Font = "GothamBlack"
signText.TextScaled = true
signText.Parent = signGui

local visitorSpawn = part("VisitorSpawn", Vector3.new(4,1,4), Vector3.new(0,2.5,62), Color3.fromRGB(80,120,220), "Neon", world)
visitorSpawn.Transparency = 1
visitorSpawn.CanCollide = false
local visitorExit = part("VisitorExit", Vector3.new(4,1,4), Vector3.new(0,2.5,58), Color3.fromRGB(220,80,80), "Neon", world)
visitorExit.Transparency = 1
visitorExit.CanCollide = false

local exhibitions = Instance.new("Folder")
exhibitions.Name = "Exhibitions"
exhibitions.Parent = museum

local function exhibition(index, name, x, z, price, income, prestige, visitorValue, wingRequired, color)
  local model = Instance.new("Model")
  model.Name = "Exhibition" .. tostring(index)
  model:SetAttribute("Index", index)
  model:SetAttribute("DisplayName", name)
  model:SetAttribute("Price", price)
  model:SetAttribute("Income", income)
  model:SetAttribute("PrestigeReward", prestige)
  model:SetAttribute("VisitorValue", visitorValue)
  model:SetAttribute("WingRequired", wingRequired == true)
  model:SetAttribute("Purchased", false)
  model.Parent = exhibitions

  local base = part("DisplayBase", Vector3.new(12,2,12), Vector3.new(x,3,z), Color3.fromRGB(44,46,52), "Marble", model)
  local pedestal = part("Pedestal", Vector3.new(5,7,5), Vector3.new(x,7.5,z), Color3.fromRGB(230,230,228), "Marble", model)
  local artifact = part("Artifact", Vector3.new(3.2,5,3.2), Vector3.new(x,13.5,z), color or Color3.fromRGB(214,168,70), "Metal", model)
  artifact.Transparency = 1
  artifact.CanCollide = false

  local visitPoint = part("VisitPoint", Vector3.new(2,1,2), Vector3.new(x,2.5,z+12), Color3.fromRGB(255,255,255), "SmoothPlastic", model)
  visitPoint.Transparency = 1
  visitPoint.CanCollide = false

  local pad = part("PurchasePad", Vector3.new(10,1,10), Vector3.new(x+14,2.5,z), Color3.fromRGB(50,180,95), "Neon", model)
  local prompt = Instance.new("ProximityPrompt")
  prompt.Name = "BuyPrompt"
  prompt.ActionText = "Comprar exposição"
  prompt.ObjectText = name .. " · $" .. tostring(price)
  prompt.HoldDuration = 0.2
  prompt.MaxActivationDistance = 12
  prompt.RequiresLineOfSight = false
  prompt.Enabled = index == 1
  prompt.Parent = pad

  local gui = Instance.new("BillboardGui")
  gui.Name = "PriceBillboard"
  gui.Size = UDim2.fromOffset(220,66)
  gui.StudsOffset = Vector3.new(0,3.8,0)
  gui.AlwaysOnTop = true
  gui.Parent = pad
  local label = Instance.new("TextLabel")
  label.Name = "Label"
  label.Size = UDim2.new(1,0,1,0)
  label.BackgroundColor3 = Color3.fromRGB(20,24,30)
  label.BackgroundTransparency = 0.1
  label.TextColor3 = Color3.fromRGB(255,255,255)
  label.Text = name .. "\n$" .. tostring(price) .. " · +$" .. tostring(income) .. "/5s"
  label.Font = "GothamBold"
  label.TextScaled = true
  label.Parent = gui

  if wingRequired then
    base.Transparency = 1
    base.CanCollide = false
    pedestal.Transparency = 1
    pedestal.CanCollide = false
    pad.Transparency = 1
    pad.CanCollide = false
    gui.Enabled = false
  end
end

exhibition(1, "Relíquia Antiga", -30, -30, 100, 5, 1, 8, false, Color3.fromRGB(214,168,70))
exhibition(2, "Cristal Imperial", 0, -30, 350, 15, 2, 18, false, Color3.fromRGB(104,174,255))
exhibition(3, "Coroa Dourada", 30, -30, 900, 40, 4, 40, false, Color3.fromRGB(246,205,65))
exhibition(4, "Fóssil Lendário", 88, -10, 2200, 85, 5, 75, true, Color3.fromRGB(206,188,154))
exhibition(5, "Meteorito Real", 88, -42, 5200, 180, 8, 150, true, Color3.fromRGB(110,94,150))

local premiumWing = Instance.new("Model")
premiumWing.Name = "PremiumWing"
premiumWing:SetAttribute("Unlocked", false)
premiumWing.Parent = museum

local function hiddenWingPart(name, size, pos, color, material)
  local p = part(name, size, pos, color, material, premiumWing)
  p.Transparency = 1
  p.CanCollide = false
  return p
end

hiddenWingPart("WingFloor", Vector3.new(70,2,90), Vector3.new(88,1,-20), Color3.fromRGB(210,210,216), "Marble")
hiddenWingPart("WingBackWall", Vector3.new(70,24,2), Vector3.new(88,13,-64), Color3.fromRGB(226,226,232), "Concrete")
hiddenWingPart("WingRightWall", Vector3.new(2,24,90), Vector3.new(122,13,-20), Color3.fromRGB(226,226,232), "Concrete")
hiddenWingPart("WingFrontWall", Vector3.new(70,24,2), Vector3.new(88,13,24), Color3.fromRGB(226,226,232), "Concrete")

local unlockPad = part("UnlockPremiumWing", Vector3.new(12,1,12), Vector3.new(48,2.5,-20), Color3.fromRGB(160,104,255), "Neon", museum)
unlockPad:SetAttribute("Price", 1800)
unlockPad:SetAttribute("RequiredPrestige", 7)
local unlockPrompt = Instance.new("ProximityPrompt")
unlockPrompt.Name = "UnlockPrompt"
unlockPrompt.ActionText = "Liberar Ala Premium"
unlockPrompt.ObjectText = "$1800 · requer 7★"
unlockPrompt.HoldDuration = 0.35
unlockPrompt.MaxActivationDistance = 12
unlockPrompt.RequiresLineOfSight = false
unlockPrompt.Parent = unlockPad

local unlockGui = Instance.new("BillboardGui")
unlockGui.Size = UDim2.fromOffset(240,72)
unlockGui.StudsOffset = Vector3.new(0,4,0)
unlockGui.AlwaysOnTop = true
unlockGui.Parent = unlockPad
local unlockLabel = Instance.new("TextLabel")
unlockLabel.Size = UDim2.new(1,0,1,0)
unlockLabel.BackgroundColor3 = Color3.fromRGB(35,25,52)
unlockLabel.BackgroundTransparency = 0.08
unlockLabel.TextColor3 = Color3.fromRGB(255,255,255)
unlockLabel.Text = "ALA PREMIUM\n$1800 · 7★"
unlockLabel.Font = "GothamBold"
unlockLabel.TextScaled = true
unlockLabel.Parent = unlockGui

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
local TweenService = game:GetService("TweenService")

local museumWorld = workspace:WaitForChild("MuseuEmpireWorld")
local museum = museumWorld:WaitForChild("StarterMuseum")
local exhibitions = museum:WaitForChild("Exhibitions")
local premiumWing = museum:WaitForChild("PremiumWing")
local unlockPad = museum:WaitForChild("UnlockPremiumWing")
local unlockPrompt = unlockPad:WaitForChild("UnlockPrompt")
local visitorSpawn = museumWorld:WaitForChild("VisitorSpawn")
local visitorExit = museumWorld:WaitForChild("VisitorExit")

local ownerUserId = 0
local totalIncome = 0
local activeVisitors = 0
local maxVisitors = 10

local ordered = exhibitions:GetChildren()
table.sort(ordered, function(a,b)
  return (a:GetAttribute("Index") or 0) < (b:GetAttribute("Index") or 0)
end)

local function setupPlayer(player)
  if player:FindFirstChild("leaderstats") then return end
  local stats = Instance.new("Folder")
  stats.Name = "leaderstats"
  stats.Parent = player

  local cash = Instance.new("IntValue")
  cash.Name = "Cash"
  cash.Value = 250
  cash.Parent = stats

  local prestige = Instance.new("IntValue")
  prestige.Name = "Prestige"
  prestige.Value = 0
  prestige.Parent = stats

  local exhibits = Instance.new("IntValue")
  exhibits.Name = "Exhibits"
  exhibits.Value = 0
  exhibits.Parent = stats

  local visitors = Instance.new("IntValue")
  visitors.Name = "Visitors"
  visitors.Value = 0
  visitors.Parent = stats

  local wing = Instance.new("IntValue")
  wing.Name = "Wing"
  wing.Value = 0
  wing.Parent = stats
end

Players.PlayerAdded:Connect(setupPlayer)
for _,p in ipairs(Players:GetPlayers()) do setupPlayer(p) end

local function ownerStats()
  if ownerUserId == 0 then return nil end
  local owner = Players:GetPlayerByUserId(ownerUserId)
  return owner and owner:FindFirstChild("leaderstats")
end

local function setWingVisible(visible)
  premiumWing:SetAttribute("Unlocked", visible)
  for _,item in ipairs(premiumWing:GetDescendants()) do
    if item:IsA("BasePart") then
      item.Transparency = visible and 0 or 1
      item.CanCollide = visible
    end
  end
  for _,model in ipairs(ordered) do
    if model:GetAttribute("WingRequired") then
      local base = model:FindFirstChild("DisplayBase")
      local pedestal = model:FindFirstChild("Pedestal")
      local pad = model:FindFirstChild("PurchasePad")
      local billboard = pad and pad:FindFirstChild("PriceBillboard")
      if base then base.Transparency = visible and 0 or 1 base.CanCollide = visible end
      if pedestal then pedestal.Transparency = visible and 0 or 1 pedestal.CanCollide = visible end
      if pad then pad.Transparency = visible and 0 or 1 pad.CanCollide = visible end
      if billboard then billboard.Enabled = visible end
    end
  end
end

setWingVisible(false)

unlockPrompt.Triggered:Connect(function(player)
  if premiumWing:GetAttribute("Unlocked") then return end
  if ownerUserId ~= 0 and ownerUserId ~= player.UserId then return end

  local stats = player:FindFirstChild("leaderstats")
  local cash = stats and stats:FindFirstChild("Cash")
  local prestige = stats and stats:FindFirstChild("Prestige")
  local exhibits = stats and stats:FindFirstChild("Exhibits")
  local wing = stats and stats:FindFirstChild("Wing")
  if not cash or not prestige or not exhibits or not wing then return end

  local price = unlockPad:GetAttribute("Price") or 1800
  local requiredPrestige = unlockPad:GetAttribute("RequiredPrestige") or 7
  if exhibits.Value < 3 then return end
  if prestige.Value < requiredPrestige then return end
  if cash.Value < price then return end

  cash.Value -= price
  ownerUserId = player.UserId
  wing.Value = 1
  setWingVisible(true)
  unlockPrompt.Enabled = false
  unlockPad.Transparency = 0.65
  unlockPad.Color = Color3.fromRGB(70,70,75)

  local fourth = ordered[4]
  if fourth then
    local prompt = fourth:WaitForChild("PurchasePad"):WaitForChild("BuyPrompt")
    prompt.Enabled = true
  end
end)

for index,model in ipairs(ordered) do
  local pad = model:WaitForChild("PurchasePad")
  local prompt = pad:WaitForChild("BuyPrompt")
  local artifact = model:WaitForChild("Artifact")

  prompt.Triggered:Connect(function(player)
    if model:GetAttribute("Purchased") then return end
    if ownerUserId ~= 0 and ownerUserId ~= player.UserId then return end
    if model:GetAttribute("WingRequired") and not premiumWing:GetAttribute("Unlocked") then return end
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
    pad.Transparency = 0.6
    pad.Color = Color3.fromRGB(80,80,80)

    totalIncome += model:GetAttribute("Income") or 0
    prestige.Value += model:GetAttribute("PrestigeReward") or 0
    exhibits.Value += 1

    local nextModel = ordered[index+1]
    if nextModel and (not nextModel:GetAttribute("WingRequired") or premiumWing:GetAttribute("Unlocked")) then
      local nextPrompt = nextModel:WaitForChild("PurchasePad"):WaitForChild("BuyPrompt")
      nextPrompt.Enabled = true
    end
  end)
end

local function purchasedExhibitions()
  local list = {}
  for _,model in ipairs(ordered) do
    if model:GetAttribute("Purchased") then table.insert(list,model) end
  end
  return list
end

local function createVisitor()
  local model = Instance.new("Model")
  model.Name = "VisitorNPC"

  local root = Instance.new("Part")
  root.Name = "HumanoidRootPart"
  root.Size = Vector3.new(2,2,1)
  root.Position = visitorSpawn.Position + Vector3.new(math.random(-5,5),2.5,math.random(-2,2))
  root.Anchored = true
  root.CanCollide = false
  root.Transparency = 1
  root.Parent = model

  local body = Instance.new("Part")
  body.Name = "Body"
  body.Size = Vector3.new(2.2,3,1.2)
  body.Position = root.Position + Vector3.new(0,0.5,0)
  body.Anchored = true
  body.CanCollide = false
  body.Color = Color3.fromRGB(math.random(80,220),math.random(80,220),math.random(80,220))
  body.Parent = model

  local head = Instance.new("Part")
  head.Name = "Head"
  head.Shape = Enum.PartType.Ball
  head.Size = Vector3.new(1.6,1.6,1.6)
  head.Position = root.Position + Vector3.new(0,2.8,0)
  head.Anchored = true
  head.CanCollide = false
  head.Color = Color3.fromRGB(239,198,160)
  head.Parent = model

  model.PrimaryPart = root
  model.Parent = museumWorld
  return model,root,body,head
end

local function moveVisitor(root,body,head,target,duration)
  local deltaBody = body.Position - root.Position
  local deltaHead = head.Position - root.Position
  local info = TweenInfo.new(duration,Enum.EasingStyle.Linear)
  local rootTween = TweenService:Create(root,info,{Position=target})
  local bodyTween = TweenService:Create(body,info,{Position=target+deltaBody})
  local headTween = TweenService:Create(head,info,{Position=target+deltaHead})
  rootTween:Play()
  bodyTween:Play()
  headTween:Play()
  rootTween.Completed:Wait()
end

local function runVisitor()
  if activeVisitors >= maxVisitors then return end
  local available = purchasedExhibitions()
  if #available == 0 then return end

  activeVisitors += 1
  local model,root,body,head = createVisitor()
  local chosen = available[math.random(1,#available)]
  local visitPoint = chosen:FindFirstChild("VisitPoint")

  moveVisitor(root,body,head,Vector3.new(0,4,10),2.5)
  if visitPoint then
    moveVisitor(root,body,head,visitPoint.Position + Vector3.new(math.random(-3,3),1.5,math.random(-2,2)),2.7)
  end

  task.wait(math.random(2,5))

  local stats = ownerStats()
  if stats then
    local cash = stats:FindFirstChild("Cash")
    local visitors = stats:FindFirstChild("Visitors")
    local prestige = stats:FindFirstChild("Prestige")
    if cash and visitors and prestige then
      local baseValue = chosen:GetAttribute("VisitorValue") or 5
      local bonus = math.floor(prestige.Value * 0.5)
      cash.Value += baseValue + bonus
      visitors.Value += 1
    end
  end

  moveVisitor(root,body,head,visitorExit.Position + Vector3.new(0,2.5,0),3)
  model:Destroy()
  activeVisitors -= 1
end

task.spawn(function()
  while true do
    local stats = ownerStats()
    local prestige = stats and stats:FindFirstChild("Prestige")
    local prestigeValue = prestige and prestige.Value or 0
    local interval = math.max(2.5,10 - math.floor(prestigeValue * 0.45))
    task.wait(interval)
    if ownerUserId ~= 0 then task.spawn(runVisitor) end
  end
end)

task.spawn(function()
  while true do
    task.wait(5)
    if ownerUserId ~= 0 and totalIncome > 0 then
      local stats = ownerStats()
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
panel.Size = UDim2.fromOffset(320,150)
panel.BackgroundColor3 = Color3.fromRGB(18,22,28)
panel.BackgroundTransparency = 0.08
panel.TextColor3 = Color3.fromRGB(255,255,255)
panel.Font = Enum.Font.GothamBold
panel.TextSize = 16
panel.TextWrapped = true
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,14)
corner.Parent = panel

local stats = player:WaitForChild("leaderstats")
local cash = stats:WaitForChild("Cash")
local prestige = stats:WaitForChild("Prestige")
local exhibits = stats:WaitForChild("Exhibits")
local visitors = stats:WaitForChild("Visitors")
local wing = stats:WaitForChild("Wing")

local function update()
  local wingText = wing.Value == 1 and "ALA PREMIUM: LIBERADA" or "ALA PREMIUM: BLOQUEADA ($1800 · 7★)"
  panel.Text = "MUSEU EMPIRE\n$ "..cash.Value.."   ★ "..prestige.Value.."\nExposições: "..exhibits.Value.."/5\nVisitantes: "..visitors.Value.."\n"..wingText
end

cash:GetPropertyChangedSignal("Value"):Connect(update)
prestige:GetPropertyChangedSignal("Value"):Connect(update)
exhibits:GetPropertyChangedSignal("Value"):Connect(update)
visitors:GetPropertyChangedSignal("Value"):Connect(update)
wing:GetPropertyChangedSignal("Value"):Connect(update)
update()
]=]
client.Parent = starterPlayerScripts

fs.write(outputPath, place)
print("[Museu Empire] premium expansion build prepared")
