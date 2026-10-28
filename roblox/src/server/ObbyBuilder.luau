local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local ObbyBuilder = {}

local STAGE_COLORS = { Config.Colors.StageA, Config.Colors.StageB, Config.Colors.StageC }

local function newPart(props)
	local part = Instance.new("Part")
	part.Anchored = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Material = Enum.Material.SmoothPlastic
	for property, value in props do
		part[property] = value
	end
	if props.Parent == nil then
		part.Parent = workspace
	end
	return part
end

local function addSign(parent, text, textColor)
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.CanvasSize = Vector2.new(800, 200)
	gui.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
	label.Text = text
	label.Parent = gui

	return gui
end

local function clearTemplate()
	for _, name in ipairs({ "Baseplate", "SpawnLocation" }) do
		local found = workspace:FindFirstChild(name)
		if found then
			found:Destroy()
		end
	end
end

local function buildPlaza(world)
	newPart({
		Name = "Plaza",
		Size = Config.Plaza.Size,
		CFrame = CFrame.new(0, -1, 0),
		Color = Config.Plaza.FloorColor,
		Parent = world,
	})

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "EggSpawn"
	spawn.Size = Vector3.new(10, 1, 10)
	spawn.CFrame = CFrame.lookAt(Config.Plaza.SpawnPosition, Config.Plaza.SpawnPosition + Vector3.new(0, 0, -20))
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Duration = 0
	spawn.TopSurface = Enum.SurfaceType.Smooth
	spawn.BottomSurface = Enum.SurfaceType.Smooth
	spawn.Color = Color3.fromRGB(255, 255, 255)
	spawn.Parent = world

	local banner = newPart({
		Name = "Cartel",
		Size = Vector3.new(56, 16, 1),
		CFrame = CFrame.lookAt(Vector3.new(0, 14, 33), Vector3.new(0, 14, 0)),
		Color = Color3.fromRGB(72, 52, 104),
		Parent = world,
	})
	addSign(banner, "BEBÉ HUEVO TRISTE\nOBBy DE 3 ETAPAS", Color3.fromRGB(255, 236, 160))

	local notes = newPart({
		Name = "Instrucciones",
		Size = Vector3.new(16, 8, 1),
		CFrame = CFrame.lookAt(Vector3.new(-30, 5, 16), Vector3.new(0, 5, 8)),
		Color = Color3.fromRGB(58, 44, 86),
		Parent = world,
	})
	addSign(notes, "WASD para moverte\nESPACIO para saltar\n🛒 Compra cáscaras aquí", Color3.fromRGB(240, 240, 255))

	local decorations = {
		{ offset = Vector3.new(-34, 2, -24), color = Color3.fromRGB(255, 138, 158), scale = 2.4 },
		{ offset = Vector3.new(34, 2, -24), color = Color3.fromRGB(146, 230, 190), scale = 2.0 },
		{ offset = Vector3.new(-34, 2, 22), color = Color3.fromRGB(255, 214, 130), scale = 1.8 },
		{ offset = Vector3.new(34, 2, 22), color = Color3.fromRGB(126, 120, 255), scale = 2.6 },
	}
	for index, decoration in ipairs(decorations) do
		newPart({
			Name = "HuevoDecoracion" .. index,
			Shape = Enum.PartType.Ball,
			Size = Vector3.new(3, 4, 3) * decoration.scale,
			CFrame = CFrame.new(decoration.offset),
			Color = decoration.color,
			Parent = world,
		})
	end
end

local function buildShop(world)
	local stands = {}
	local spacing = 11
	local startX = -((#Config.Shop.Shells - 1) * spacing) / 2

	for index, shell in ipairs(Config.Shop.Shells) do
		local x = startX + (index - 1) * spacing

		local pedestal = newPart({
			Name = "Vitrina" .. index,
			Size = Vector3.new(7, 1.5, 7),
			CFrame = CFrame.new(x, 0.75, Config.Plaza.ShopZ),
			Color = Color3.fromRGB(255, 250, 240),
			Parent = world,
		})

		newPart({
			Name = "Muestra" .. index,
			Shape = Enum.PartType.Ball,
			Size = Vector3.new(2.4, 3.2, 2.4),
			CFrame = CFrame.new(x, 3.4, Config.Plaza.ShopZ),
			Color = shell.color,
			CanCollide = false,
			Parent = world,
		})

		local prompt = Instance.new("ProximityPrompt")
		prompt.ActionText = if shell.price > 0 then "Comprar" else "Usar"
		prompt.ObjectText = string.format("%s (%d monedas)", shell.name, shell.price)
		prompt.HoldDuration = 0.3
		prompt.MaxActivationDistance = 8
		prompt.RequiresLineOfSight = false
		prompt.Parent = pedestal

		table.insert(stands, { prompt = prompt, item = shell })
	end

	return stands
end

local function makeCoin(world, position, spinners)
	local tilt = CFrame.Angles(0, 0, math.rad(90))
	local coin = newPart({
		Name = "Moneda",
		Shape = Enum.PartType.Cylinder,
		Size = Vector3.new(0.4, 2.4, 2.4),
		CFrame = CFrame.new(position) * tilt,
		Color = Config.Colors.Coin,
		Material = Enum.Material.Neon,
		CanCollide = false,
		Parent = world,
	})

	table.insert(spinners, { part = coin, position = position, tilt = tilt, speed = 2.5 })

	return coin
end

local function applyPattern(platform, pattern, spinners)
	if pattern == "vanish" then
		local busy = false
		platform.Touched:Connect(function(hit)
			if busy or not platform.CanCollide then
				return
			end
			local character = hit.Parent
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return
			end
			busy = true
			task.delay(0.6, function()
				platform.CanCollide = false
				platform.Transparency = 0.7
				task.wait(2.5)
				if platform.Parent then
					platform.CanCollide = true
					platform.Transparency = 0
				end
				busy = false
			end)
		end)
	elseif pattern == "conveyor" then
		platform.Material = Enum.Material.DiamondPlate
		platform.AssemblyLinearVelocity = Vector3.new(0, 0, 12)
	elseif pattern == "spinner" then
		local length = math.max(12, platform.Size.X * 1.6)
		local bar = newPart({
			Name = "Aspa",
			Size = Vector3.new(1.4, 1, length),
			CFrame = CFrame.new(platform.Position + Vector3.new(0, 1, 0)),
			Color = Config.Colors.Danger,
			Material = Enum.Material.Neon,
			Parent = platform.Parent,
		})
		table.insert(spinners, {
			part = bar,
			position = bar.Position,
			tilt = CFrame.new(),
			speed = 1.8,
		})
	end
end

local function buildObby(world)
	local checkpoints = {}
	local coins = {}
	local spinners = {}
	local z = -Config.Plaza.Size.Z / 2 - 6
	local x = 0
	local previousDepth = 0

	for stageIndex, stage in ipairs(Config.Stages) do
		local rng = Random.new(stage.seed)
		local color = STAGE_COLORS[stageIndex] or Config.Colors.StageA

		for platformIndex = 1, stage.platforms do
			local pattern = if platformIndex == 1
				then "plain"
				else stage.patterns[rng:NextInteger(1, #stage.patterns)]

			local size = Vector3.new(stage.width, 1, stage.width * 0.8)
			if pattern == "small" then
				size *= 0.6
			end

			local gap = rng:NextNumber(stage.gapMin, stage.gapMax)
			z -= gap + (previousDepth + size.Z) / 2
			previousDepth = size.Z

			x = math.clamp(x + rng:NextNumber(-stage.drift, stage.drift), -16, 16)

			local y = stage.baseY + rng:NextNumber(-1, 1)
			local platform = newPart({
				Name = string.format("Etapa%d_Plataforma%d", stageIndex, platformIndex),
				Size = size,
				CFrame = CFrame.new(x, y, z),
				Color = color,
				Parent = world,
			})
			applyPattern(platform, pattern, spinners)

			if rng:NextNumber() < Config.Coins.Chance then
				table.insert(coins, makeCoin(world, Vector3.new(x, y + 2.6, z), spinners))
			end
		end

		local checkpointY = stage.baseY + 1
		z -= previousDepth / 2 + 3 + 6
		previousDepth = 12

		local pad = newPart({
			Name = "Checkpoint" .. stageIndex,
			Size = Vector3.new(16, 1, 12),
			CFrame = CFrame.new(x, checkpointY, z),
			Color = Config.Colors.Checkpoint,
			Material = Enum.Material.Neon,
			Parent = world,
		})

		table.insert(checkpoints, {
			stage = stageIndex,
			pad = pad,
			spawn = CFrame.new(x, checkpointY + 4, z),
		})
	end

	local finishY = Config.Stages[#Config.Stages].baseY + 1
	z -= previousDepth / 2 + 3 + 8

	local finishPad = newPart({
		Name = "Meta",
		Size = Vector3.new(22, 1, 16),
		CFrame = CFrame.new(x, finishY, z),
		Color = Color3.fromRGB(255, 214, 130),
		Material = Enum.Material.Neon,
		Parent = world,
	})

	for _, side in ipairs({ -11, 11 }) do
		newPart({
			Name = "ArcoPilar",
			Size = Vector3.new(2, 20, 2),
			CFrame = CFrame.new(x + side, finishY + 10, z - 6),
			Color = Color3.fromRGB(72, 52, 104),
			Parent = world,
		})
	end
	local archTop = newPart({
		Name = "ArcoCartel",
		Size = Vector3.new(24, 6, 1),
		CFrame = CFrame.lookAt(Vector3.new(x, finishY + 20, z - 6), Vector3.new(x, finishY + 20, z)),
		Color = Color3.fromRGB(72, 52, 104),
		Parent = world,
	})
	addSign(archTop, "META", Color3.fromRGB(255, 236, 160))

	return {
		checkpoints = checkpoints,
		coins = coins,
		finishPad = finishPad,
		spinners = spinners,
	}
end

local function animate(spinners)
	RunService.Heartbeat:Connect(function()
		local now = os.clock()
		for index = #spinners, 1, -1 do
			local entry = spinners[index]
			if entry.part.Parent == nil then
				table.remove(spinners, index)
			else
				entry.part.CFrame = CFrame.new(entry.position)
					* CFrame.Angles(0, now * entry.speed, 0)
					* entry.tilt
			end
		end
	end)
end

function ObbyBuilder.build()
	clearTemplate()

	local world = Instance.new("Folder")
	world.Name = "ObbyWorld"
	world.Parent = workspace

	buildPlaza(world)
	local stands = buildShop(world)
	local obby = buildObby(world)
	animate(obby.spinners)

	return {
		Folder = world,
		Checkpoints = obby.checkpoints,
		Coins = obby.coins,
		FinishPad = obby.finishPad,
		ShopStands = stands,
	}
end

return ObbyBuilder
