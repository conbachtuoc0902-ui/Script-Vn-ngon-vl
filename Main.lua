-- 🇻🇳 VIETNAM ADMIN - LOCAL ONLY
-- StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local character, humanoid, root

local function setupCharacter(c)
	character = c
	humanoid = c:WaitForChild("Humanoid")
	root = c:WaitForChild("HumanoidRootPart")
end

setupCharacter(LP.Character or LP.CharacterAdded:Wait())

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "VietnamAdmin"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PG

local scale = Instance.new("UIScale")
scale.Scale = .8
scale.Parent = gui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(320,650)
main.Position = UDim2.new(1,-335,.5,-325)
main.BackgroundColor3 = Color3.fromRGB(210,0,0)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner",main).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,0,50)
title.Position = UDim2.fromOffset(10,0)
title.BackgroundTransparency = 1
title.Text = "🇻🇳 VIETNAM ADMIN"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(40,40)
close.Position = UDim2.new(1,-45,0,5)
close.Text = "✕"
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(150,0,0)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = main

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(55,55)
reopen.Position = UDim2.new(1,-65,.5,-25)
reopen.Text = "🇻🇳"
reopen.TextScaled = true
reopen.BackgroundColor3 = Color3.fromRGB(210,0,0)
reopen.Visible = false
reopen.Parent = gui

close.MouseButton1Click:Connect(function()
	main.Visible = false
	reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
	main.Visible = true
	reopen.Visible = false
end)

--------------------------------------------------
-- BUTTON
--------------------------------------------------

local function makeButton(text,y,h)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,h or 38)
	b.Position = UDim2.fromOffset(10,y)
	b.Text = text
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(165,0,0)
	b.BorderSizePixel = 0
	b.Parent = main

	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)

	return b
end

--------------------------------------------------
-- KÉO UI
--------------------------------------------------

local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
	or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if not dragging then return end

	if input.UserInputType == Enum.UserInputType.Touch
	or input.UserInputType == Enum.UserInputType.MouseMovement then

		local d = input.Position - dragStart

		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+d.X,
			startPos.Y.Scale,
			startPos.Y.Offset+d.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
	or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

--------------------------------------------------
-- STATUS
--------------------------------------------------

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-20,0,35)
status.Position = UDim2.fromOffset(10,600)
status.BackgroundColor3 = Color3.new(0,0,0)
status.BackgroundTransparency = .25
status.Text = "🇻🇳 Sẵn sàng"
status.TextColor3 = Color3.new(1,1,1)
status.TextScaled = true
status.Parent = main

--------------------------------------------------
-- BAY
--------------------------------------------------

local flying = false
local flyVelocity
local flyConnection
local up = false
local down = false
local speed = 50

local flyBtn = makeButton("✈ BAY: OFF",60)
local upBtn = makeButton("▲ LÊN",105)
local downBtn = makeButton("▼ XUỐNG",150)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1,-20,0,35)
speedBox.Position = UDim2.fromOffset(10,195)
speedBox.Text = "50"
speedBox.PlaceholderText = "Tốc độ 10 - 500"
speedBox.TextScaled = true
speedBox.BackgroundColor3 = Color3.new(1,1,1)
speedBox.TextColor3 = Color3.new(0,0,0)
speedBox.Parent = main

local function startFly()
	if not root then return end

	if flyVelocity then
		flyVelocity:Destroy()
	end

	flyVelocity = Instance.new("BodyVelocity")
	flyVelocity.MaxForce = Vector3.new(1e9,1e9,1e9)
	flyVelocity.Parent = root

	if flyConnection then
		flyConnection:Disconnect()
	end

	flyConnection = RunService.Heartbeat:Connect(function()
		if not flying or not root then return end

		local v = humanoid.MoveDirection * speed

		if up then
			v += Vector3.new(0,speed,0)
		end

		if down then
			v += Vector3.new(0,-speed,0)
		end

		flyVelocity.Velocity = v
	end)
end

local function stopFly()
	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end

	if flyVelocity then
		flyVelocity:Destroy()
		flyVelocity = nil
	end
end

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying

	if flying then
		startFly()
		flyBtn.Text = "✈ BAY: ON"
		flyBtn.BackgroundColor3 = Color3.fromRGB(0,140,0)
	else
		stopFly()
		flyBtn.Text = "✈ BAY: OFF"
		flyBtn.BackgroundColor3 = Color3.fromRGB(165,0,0)
	end
end)

local function holdButton(btn,callback)
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then
			callback(true)
		end
	end)

	btn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then
			callback(false)
		end
	end)
end

holdButton(upBtn,function(v) up=v end)
holdButton(downBtn,function(v) down=v end)

speedBox.FocusLost:Connect(function()
	local n = tonumber(speedBox.Text)

	if n then
		speed = math.clamp(n,10,500)
	end

	speedBox.Text = tostring(speed)
end)

LP.CharacterAdded:Connect(function(c)
	setupCharacter(c)

	if flying then
		task.wait(.3)
		startFly()
	end
end)

--------------------------------------------------
-- RADAR
--------------------------------------------------

local function getPart(obj)
	if obj:IsA("BasePart") then
		return obj
	end

	if obj:IsA("Model") then
		return obj.PrimaryPart
			or obj:FindFirstChildWhichIsA("BasePart",true)
	end

	if obj:IsA("Tool") then
		return obj:FindFirstChild("Handle")
	end
end

local function clearRadar()
	for _,obj in ipairs(workspace:GetDescendants()) do
		local marker = obj:FindFirstChild("VietnamRadar")

		if marker then
			marker:Destroy()
		end
	end
end

local function mark(part,text)
	if not part then return end

	local old = part:FindFirstChild("VietnamRadar")
	if old then old:Destroy() end

	local bill = Instance.new("BillboardGui")
	bill.Name = "VietnamRadar"
	bill.Size = UDim2.fromOffset(160,35)
	bill.StudsOffset = Vector3.new(0,4,0)
	bill.AlwaysOnTop = true
	bill.MaxDistance = 10000
	bill.Parent = part

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1,1)
	label.BackgroundColor3 = Color3.new(0,0,0)
	label.BackgroundTransparency = .3
	label.TextColor3 = Color3.fromRGB(255,255,0)
	label.Text = text
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = bill
end

--------------------------------------------------
-- TÌM NGƯỜI
--------------------------------------------------

local search = Instance.new("TextBox")
search.Size = UDim2.new(1,-80,0,35)
search.Position = UDim2.fromOffset(10,245)
search.PlaceholderText = "Tên người chơi..."
search.TextScaled = true
search.BackgroundColor3 = Color3.new(1,1,1)
search.TextColor3 = Color3.new(0,0,0)
search.Parent = main

local find = Instance.new("TextButton")
find.Size = UDim2.fromOffset(60,35)
find.Position = UDim2.new(1,-70,0,245)
find.Text = "🔎"
find.TextScaled = true
find.Parent = main

find.MouseButton1Click:Connect(function()
	clearRadar()

	local q = string.lower(search.Text)

	if q == "" then
		status.Text = "❌ Nhập tên trước"
		return
	end

	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then

			local name = string.lower(p.Name)
			local display = string.lower(p.DisplayName)

			if string.find(name,q,1,true)
			or string.find(display,q,1,true) then

				mark(getPart(p.Character),"🎯 "..p.DisplayName)
				status.Text = "🎯 "..p.DisplayName
				return
			end
		end
	end

	status.Text = "❌ Không tìm thấy"
end)

--------------------------------------------------
-- RADAR PLAYERS
--------------------------------------------------

local playersBtn = makeButton("👥 RADAR PLAYERS",295)

playersBtn.MouseButton1Click:Connect(function()
	clearRadar()

	local count = 0

	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then

			local part = getPart(p.Character)

			if part then
				mark(part,"👤 "..p.DisplayName)
				count += 1
			end
		end
	end

	status.Text = "👥 "..count.." người"
end)

--------------------------------------------------
-- RADAR ITEMS
--------------------------------------------------

local itemsBtn = makeButton("📦 RADAR ITEMS",340)

local keywords = {
	"item","fruit","chest","treasure",
	"weapon","sword","drop","loot",
	"coin","gem","ore","key","tool"
}

local function isItem(obj)

	if obj:IsA("Tool") then
		return true
	end

	if obj:GetAttribute("IsItem") == true
	or obj:GetAttribute("Item") == true then
		return true
	end

	local n = string.lower(obj.Name)

	for _,word in ipairs(keywords) do
		if string.find(n,word,1,true) then
			return true
		end
	end

	return false
end

itemsBtn.MouseButton1Click:Connect(function()
	clearRadar()

	local count = 0

	for _,obj in ipairs(workspace:GetDescendants()) do
		if isItem(obj) then

			local part = getPart(obj)

			if part then
				mark(part,"📦 "..obj.Name)
				count += 1
			end
		end
	end

	status.Text = "📦 "..count.." item"
end)

--------------------------------------------------
-- FIX LAG
--------------------------------------------------

local lagBtn = makeButton("⚡ FIX LAG",385)

lagBtn.MouseButton1Click:Connect(function()

	for _,obj in ipairs(workspace:GetDescendants()) do

		if obj:IsA("BasePart") then
			obj.Material = Enum.Material.SmoothPlastic
			obj.CastShadow = false

		elseif obj:IsA("ParticleEmitter")
		or obj:IsA("Trail")
		or obj:IsA("Beam")
		or obj:IsA("Smoke")
		or obj:IsA("Fire")
		or obj:IsA("Sparkles") then

			obj.Enabled = false

		elseif obj:IsA("Decal")
		or obj:IsA("Texture") then

			obj.Transparency = 1
		end
	end

	for _,obj in ipairs(Lighting:GetChildren()) do
		if obj:IsA("PostEffect") then
			obj.Enabled = false
		end
	end

	lagBtn.Text = "⚡ FIX LAG: ON"
	lagBtn.BackgroundColor3 = Color3.fromRGB(0,140,0)
	status.Text = "⚡ Đã giảm hiệu ứng"
end)

--------------------------------------------------
-- TÀNG HÌNH LOCAL
--------------------------------------------------

local invisBtn = makeButton("👻 TÀNG HÌNH: OFF",430)
local invisible = false

local function setInvisible(on)
	if not character then return end

	for _,obj in ipairs(character:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.LocalTransparencyModifier = on and 1 or 0

		elseif obj:IsA("Decal")
		or obj:IsA("Texture") then
			obj.Transparency = on and 1 or 0
		end
	end
end

invisBtn.MouseButton1Click:Connect(function()

	invisible = not invisible
	setInvisible(invisible)

	if invisible then
		invisBtn.Text = "👻 TÀNG HÌNH: ON"
		invisBtn.BackgroundColor3 = Color3.fromRGB(0,140,0)
		status.Text = "👻 Tàng hình LOCAL"
	else
		invisBtn.Text = "👻 TÀNG HÌNH: OFF"
		invisBtn.BackgroundColor3 = Color3.fromRGB(165,0,0)
		status.Text = "👻 Đã hiện hình"
	end
end)

--------------------------------------------------
-- BẢO VỆ LOCAL
--------------------------------------------------

local protectBtn = makeButton("🛡️ BẢO VỆ: OFF",475)
local protection = false
local savedHealth = 100

protectBtn.MouseButton1Click:Connect(function()

	protection = not protection

	if protection then
		savedHealth = humanoid.Health

		protectBtn.Text = "🛡️ BẢO VỆ: ON"
		protectBtn.BackgroundColor3 = Color3.fromRGB(0,140,0)
		status.Text = "🛡️ Bảo vệ LOCAL"

	else
		protectBtn.Text = "🛡️ BẢO VỆ: OFF"
		protectBtn.BackgroundColor3 = Color3.fromRGB(165,0,0)
		status.Text = "🛡️ Bảo vệ OFF"
	end
end)

RunService.Heartbeat:Connect(function()

	if protection and humanoid and humanoid.Health > 0 then
		if humanoid.Health < savedHealth then
			humanoid.Health = savedHealth
		end
	else
		if humanoid then
			savedHealth = math.max(savedHealth,humanoid.Health)
		end
	end

	if invisible then
		setInvisible(true)
	end
end)

--------------------------------------------------
-- AUTO BLOCK LOCAL
--------------------------------------------------

local blockBtn = makeButton("🚫 AUTO BLOCK: OFF",520)
local autoBlock = false

blockBtn.MouseButton1Click:Connect(function()

	autoBlock = not autoBlock

	if autoBlock then
		blockBtn.Text = "🚫 AUTO BLOCK: ON"
		blockBtn.BackgroundColor3 = Color3.fromRGB(0,140,0)
		status.Text = "🚫 Auto Block LOCAL"
	else
		blockBtn.Text = "🚫 AUTO BLOCK: OFF"
		blockBtn.BackgroundColor3 = Color3.fromRGB(165,0,0)
		status.Text = "🚫 Auto Block OFF"
	end
end)

--------------------------------------------------
-- SIZE
--------------------------------------------------

local small = makeButton("➖ NHỎ",565,30)
local big = makeButton("➕ LỚN",600,30)

small.Size = UDim2.new(.45,-5,0,30)

big.Size = UDim2.new(.45,-5,0,30)
big.Position = UDim2.new(.55,0,0,600)

small.MouseButton1Click:Connect(function()
	scale.Scale = math.clamp(scale.Scale-.1,.4,1.4)
end)

big.MouseButton1Click:Connect(function()
	scale.Scale = math.clamp(scale.Scale+.1,.4,1.4)
end)

print("🇻🇳 Vietnam Admin Local đã chạy!")
