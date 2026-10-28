local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage.Shared.Config)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screen = Instance.new("ScreenGui")
screen.Name = "HuevoHud"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Position = UDim2.fromOffset(16, 16)
panel.Size = UDim2.fromOffset(220, 92)
panel.BackgroundColor3 = Color3.fromRGB(38, 32, 50)
panel.BackgroundTransparency = 0.2
panel.BorderSizePixel = 0
panel.Parent = screen

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = panel

local coinsLabel = Instance.new("TextLabel")
coinsLabel.Name = "Monedas"
coinsLabel.Position = UDim2.fromOffset(14, 10)
coinsLabel.Size = UDim2.fromOffset(192, 34)
coinsLabel.BackgroundTransparency = 1
coinsLabel.Font = Enum.Font.GothamBold
coinsLabel.TextSize = 26
coinsLabel.TextXAlignment = Enum.TextXAlignment.Left
coinsLabel.TextColor3 = Color3.fromRGB(255, 214, 130)
coinsLabel.Text = "💰 0"
coinsLabel.Parent = panel

local stageLabel = Instance.new("TextLabel")
stageLabel.Name = "Etapa"
stageLabel.Position = UDim2.fromOffset(14, 48)
stageLabel.Size = UDim2.fromOffset(192, 30)
stageLabel.BackgroundTransparency = 1
stageLabel.Font = Enum.Font.GothamMedium
stageLabel.TextSize = 20
stageLabel.TextXAlignment = Enum.TextXAlignment.Left
stageLabel.TextColor3 = Color3.fromRGB(235, 235, 245)
stageLabel.Text = "🥚 Etapa 0/" .. #Config.Stages
stageLabel.Parent = panel

local message = Instance.new("TextLabel")
message.Name = "Mensaje"
message.AnchorPoint = Vector2.new(0.5, 0.5)
message.Position = UDim2.fromScale(0.5, 0.72)
message.Size = UDim2.fromScale(0.7, 0.12)
message.BackgroundTransparency = 1
message.Font = Enum.Font.GothamBlack
message.TextScaled = true
message.TextColor3 = Color3.fromRGB(255, 236, 160)
message.TextStrokeTransparency = 0.2
message.TextTransparency = 1
message.Text = ""
message.Parent = screen

local function refresh(coins, stage)
	coinsLabel.Text = "💰 " .. tostring(coins.Value)
	stageLabel.Text = string.format("🥚 Etapa %d/%d", stage.Value, #Config.Stages)
end

task.spawn(function()
	local stats = player:WaitForChild("leaderstats")
	local coins = stats:WaitForChild("Monedas")
	local stage = stats:WaitForChild("Etapa")

	coins.Changed:Connect(function()
		refresh(coins, stage)
	end)
	stage.Changed:Connect(function()
		refresh(coins, stage)
	end)
	refresh(coins, stage)
end)

local showMessage = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ShowMessage")
local activeFade = nil

showMessage.OnClientEvent:Connect(function(text)
	if activeFade then
		activeFade:Cancel()
	end

	message.Text = text
	message.TextTransparency = 0

	local fade = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 1.8)
	activeFade = TweenService:Create(message, fade, { TextTransparency = 1 })
	activeFade:Play()
end)
