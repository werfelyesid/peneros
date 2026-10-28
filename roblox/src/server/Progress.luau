local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Notify = require(ReplicatedStorage.Shared.Notify)

local Progress = {}

local checkpointSpawns = {}
local maxStageByPlayer = {}
local finishedByPlayer = {}
local warnCooldown = {}
local initialized = false

local function playerFromHit(hit)
	local character = hit.Parent
	if character and character:IsA("Model") then
		return Players:GetPlayerFromCharacter(character)
	end
	return nil
end

local function getCoins(player)
	local stats = player:FindFirstChild("leaderstats")
	return stats and stats:FindFirstChild("Monedas")
end

local function getStage(player)
	local stats = player:FindFirstChild("leaderstats")
	return stats and stats:FindFirstChild("Etapa")
end

local function award(player, amount)
	local coins = getCoins(player)
	if coins then
		coins.Value += amount
	end
end

Progress.award = award
Progress.getCoins = getCoins

local function teleport(player, target)
	local character = player.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if humanoid and humanoid.Health > 0 and root then
		character:PivotTo(target)
		root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end
end

local function setupPlayer(player)
	if player:FindFirstChild("leaderstats") then
		return
	end

	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"

	local coins = Instance.new("IntValue")
	coins.Name = "Monedas"
	coins.Parent = stats

	local stage = Instance.new("IntValue")
	stage.Name = "Etapa"
	stage.Value = 0
	stage.Parent = stats

	stats.Parent = player
end

local function onCharacterAdded(player, character)
	character:WaitForChild("HumanoidRootPart")
	task.wait(0.1)
	teleport(player, checkpointSpawns[maxStageByPlayer[player] or 0] or Config.Plaza.RespawnPoint)
end

local function watchFalls()
	task.spawn(function()
		while true do
			task.wait(0.25)
			for _, player in ipairs(Players:GetPlayers()) do
				local character = player.Character
				local root = character and character:FindFirstChild("HumanoidRootPart")
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				if root and humanoid and humanoid.Health > 0 and root.Position.Y < Config.Game.KillHeight then
					teleport(player, checkpointSpawns[maxStageByPlayer[player] or 0] or Config.Plaza.RespawnPoint)
				end
			end
		end
	end)
end

local function connectCheckpoints(world)
	for _, checkpoint in ipairs(world.Checkpoints) do
		checkpointSpawns[checkpoint.stage] = checkpoint.spawn

		checkpoint.pad.Touched:Connect(function(hit)
			local player = playerFromHit(hit)
			if not player then
				return
			end
			if (maxStageByPlayer[player] or 0) >= checkpoint.stage then
				return
			end

			maxStageByPlayer[player] = checkpoint.stage
			local stageValue = getStage(player)
			if stageValue then
				stageValue.Value = checkpoint.stage
			end
			award(player, Config.Coins.PerStage)
			checkpoint.pad.Color = Config.Colors.CheckpointDone
			Notify.toast(
				player,
				string.format(
					"¡Etapa %d: %s! +%d monedas",
					checkpoint.stage,
					Config.Stages[checkpoint.stage].name,
					Config.Coins.PerStage
				)
			)
		end)
	end
end

local function connectCoins(world)
	for _, coin in ipairs(world.Coins) do
		local taken = false
		coin.Touched:Connect(function(hit)
			if taken then
				return
			end
			local player = playerFromHit(hit)
			if not player then
				return
			end
			taken = true
			award(player, Config.Coins.Value)
			coin:Destroy()
		end)
	end
end

local function connectFinish(world)
	world.FinishPad.Touched:Connect(function(hit)
		local player = playerFromHit(hit)
		if not player then
			return
		end

		if (maxStageByPlayer[player] or 0) < #Config.Stages then
			local now = os.clock()
			if (warnCooldown[player] or 0) < now then
				warnCooldown[player] = now + 3
				Notify.toast(player, "Te faltan checkpoints 🥚")
			end
			return
		end

		if finishedByPlayer[player] then
			return
		end
		finishedByPlayer[player] = true

		award(player, Config.Game.FinishReward)
		Notify.toast(player, string.format("¡TERMINASTE! +%d monedas 🎉", Config.Game.FinishReward))
		task.delay(2, function()
			teleport(player, Config.Plaza.RespawnPoint)
		end)
	end)
end

function Progress.init(world)
	connectCheckpoints(world)
	connectCoins(world)
	connectFinish(world)

	local function onPlayerAdded(player)
		setupPlayer(player)
		player.CharacterAdded:Connect(function(character)
			onCharacterAdded(player, character)
		end)
		if player.Character then
			onCharacterAdded(player, player.Character)
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		onPlayerAdded(player)
	end
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(function(player)
		maxStageByPlayer[player] = nil
		finishedByPlayer[player] = nil
		warnCooldown[player] = nil
	end)

	if not initialized then
		initialized = true
		watchFalls()
	end
end

return Progress
