local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local EggCharacter = {}

local shellByPlayer = {}

local function hideOriginalBody(character)
	for _, descendant in ipairs(character:GetDescendants()) do
		if descendant:FindFirstAncestor("HuevoVisual") == nil then
			if descendant:IsA("Accessory") or descendant:IsA("Accoutrement") or descendant:IsA("Decal") then
				descendant:Destroy()
			elseif descendant:IsA("BasePart") then
				descendant.Transparency = 1
			end
		end
	end
end

-- Devuelve el punto exacto sobre la superficie del huevo para pegar un rasgo.
local function onEggSurface(x, y, push)
	local halfWidth = Config.Egg.ShellSize.X / 2
	local halfHeight = Config.Egg.ShellSize.Y / 2
	local ratio = math.min(0.9, (x / halfWidth) ^ 2 + (y / halfHeight) ^ 2)
	local depth = -halfWidth * math.sqrt(1 - ratio) - (push or 0)
	return CFrame.new(x, y, depth)
end

local function addFeature(shell, size, offset, color, shape)
	local feature = Instance.new("Part")
	feature.Name = "Rasgo"
	feature.Shape = shape or Enum.PartType.Ball
	feature.Size = size
	feature.Color = color
	feature.Material = Enum.Material.SmoothPlastic
	feature.Anchored = false
	feature.CanCollide = false
	feature.CanQuery = false
	feature.CanTouch = false
	feature.Massless = true
	feature.TopSurface = Enum.SurfaceType.Smooth
	feature.BottomSurface = Enum.SurfaceType.Smooth
	feature.CFrame = shell.CFrame * offset
	feature.Parent = shell.Parent

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = shell
	weld.Part1 = feature
	weld.Parent = feature

	return feature
end

local function createFace(shell)
	local ink = Config.Colors.Ink

	for _, side in ipairs({ -1, 1 }) do
		addFeature(shell, Vector3.new(0.5, 0.62, 0.35), onEggSurface(0.62 * side, 0.42, 0.02), ink)
		addFeature(
			shell,
			Vector3.new(0.55, 0.11, 0.11),
			onEggSurface(0.62 * side, 0.98, 0.02) * CFrame.Angles(0, 0, math.rad(18 * side)),
			ink,
			Enum.PartType.Block
		)
	end

	addFeature(shell, Vector3.new(0.24, 0.32, 0.24), onEggSurface(0.9, -0.05, 0.03), Config.Colors.Tear)

	for index = -2, 2 do
		local x = index * 0.2
		local y = -0.78 + 0.22 * (1 - (index / 2) ^ 2)
		addFeature(shell, Vector3.new(0.2, 0.11, 0.1), onEggSurface(x, y, 0.03), ink, Enum.PartType.Block)
	end
end

local function createShell(player, root)
	local shell = Instance.new("Part")
	shell.Name = "Cascara"
	shell.Shape = Enum.PartType.Ball
	shell.Size = Config.Egg.ShellSize
	shell.Color = player:GetAttribute("ShellColor") or Config.Egg.DefaultColor
	shell.Material = Enum.Material.SmoothPlastic
	shell.Anchored = false
	shell.CanCollide = false
	shell.CanQuery = false
	shell.CanTouch = false
	shell.Massless = true
	shell.TopSurface = Enum.SurfaceType.Smooth
	shell.BottomSurface = Enum.SurfaceType.Smooth
	shell.CFrame = root.CFrame * Config.Egg.BodyOffset

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = root
	weld.Part1 = shell
	weld.Parent = shell

	return shell
end

function EggCharacter.attach(player, character)
	if character:FindFirstChild("HuevoVisual") then
		return
	end

	local humanoid = character:WaitForChild("Humanoid")
	local root = character:WaitForChild("HumanoidRootPart")

	humanoid.UseJumpPower = true
	humanoid.WalkSpeed = Config.Egg.WalkSpeed
	humanoid.JumpPower = Config.Egg.JumpPower

	hideOriginalBody(character)

	-- Sin animaciones de avatar: el huevo se queda quieto y no se sacude.
	local animate = character:FindFirstChild("Animate")
	if animate then
		animate:Destroy()
	end

	local visual = Instance.new("Folder")
	visual.Name = "HuevoVisual"
	visual.Parent = character

	local shell = createShell(player, root)
	shell.Parent = visual
	createFace(shell)
	shellByPlayer[player] = shell

	character.AncestryChanged:Connect(function()
		if not character.Parent and shellByPlayer[player] == shell then
			shellByPlayer[player] = nil
		end
	end)

	-- Los accesorios del avatar a veces llegan un instante después.
	task.delay(0.5, function()
		if character.Parent and visual.Parent then
			hideOriginalBody(character)
		end
	end)
end

function EggCharacter.setColor(player, color)
	player:SetAttribute("ShellColor", color)
	local shell = shellByPlayer[player]
	if shell and shell.Parent then
		shell.Color = color
	end
end

function EggCharacter.init()
	local function onPlayerAdded(player)
		if player:GetAttribute("ShellColor") == nil then
			player:SetAttribute("ShellColor", Config.Egg.DefaultColor)
		end

		player.CharacterAdded:Connect(function(character)
			EggCharacter.attach(player, character)
		end)

		if player.Character then
			EggCharacter.attach(player, player.Character)
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		onPlayerAdded(player)
	end
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(function(player)
		shellByPlayer[player] = nil
	end)
end

return EggCharacter
