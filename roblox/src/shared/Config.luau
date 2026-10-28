local Config = {}

Config.Game = {
	Name = "Bebé Huevo Triste",
	KillHeight = -40,
	FinishReward = 150,
}

Config.Egg = {
	ShellSize = Vector3.new(3.2, 4.2, 3.2),
	DefaultColor = Color3.fromRGB(252, 250, 244),
	WalkSpeed = 22,
	JumpPower = 60,
	BodyOffset = CFrame.new(0, 0.9, 0),
}

Config.Plaza = {
	Size = Vector3.new(90, 2, 70),
	FloorColor = Color3.fromRGB(255, 226, 194),
	SpawnPosition = Vector3.new(0, 0.5, 8),
	RespawnPoint = CFrame.new(0, 4, 8),
	ShopZ = 26,
}

Config.Coins = {
	Value = 1,
	PerStage = 25,
	Chance = 0.45,
}

-- Cada etapa se genera sola: mismas reglas y misma semilla = mismo obby.
Config.Stages = {
	{
		name = "Huevo Mojado",
		platforms = 12,
		width = 10,
		gapMin = 3,
		gapMax = 5,
		drift = 4,
		baseY = 2,
		seed = 101,
		patterns = { "plain", "plain", "vanish", "conveyor" },
	},
	{
		name = "Huevo Resbaloso",
		platforms = 12,
		width = 8,
		gapMin = 4,
		gapMax = 6,
		drift = 5,
		baseY = 6,
		seed = 202,
		patterns = { "plain", "small", "vanish", "spinner", "conveyor" },
	},
	{
		name = "Huevo Volador",
		platforms = 14,
		width = 6,
		gapMin = 5,
		gapMax = 7,
		drift = 5,
		baseY = 10,
		seed = 303,
		patterns = { "plain", "small", "vanish", "spinner" },
	},
}

Config.Shop = {
	Shells = {
		{ name = "Huevo Clásico", color = Color3.fromRGB(252, 250, 244), price = 0 },
		{ name = "Huevo Fresa", color = Color3.fromRGB(255, 138, 158), price = 30 },
		{ name = "Huevo Menta", color = Color3.fromRGB(146, 230, 190), price = 60 },
		{ name = "Huevo Galaxia", color = Color3.fromRGB(126, 120, 255), price = 120 },
	},
}

Config.Colors = {
	Ink = Color3.fromRGB(40, 34, 52),
	Tear = Color3.fromRGB(120, 200, 255),
	Coin = Color3.fromRGB(255, 205, 60),
	Checkpoint = Color3.fromRGB(120, 200, 255),
	CheckpointDone = Color3.fromRGB(120, 255, 160),
	StageA = Color3.fromRGB(255, 170, 190),
	StageB = Color3.fromRGB(170, 220, 255),
	StageC = Color3.fromRGB(200, 180, 255),
	Danger = Color3.fromRGB(255, 110, 110),
	Steel = Color3.fromRGB(120, 130, 150),
}

return Config
