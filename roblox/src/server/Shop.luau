local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Notify = require(ReplicatedStorage.Shared.Notify)
local EggCharacter = require(script.Parent.EggCharacter)

local Shop = {}

function Shop.init(world)
	for _, stand in ipairs(world.ShopStands) do
		local item = stand.item

		stand.prompt.Triggered:Connect(function(player)
			local stats = player:FindFirstChild("leaderstats")
			local coins = stats and stats:FindFirstChild("Monedas")
			if not coins then
				return
			end

			local current = player:GetAttribute("ShellColor")
			if typeof(current) == "Color3" and current == item.color then
				Notify.toast(player, "Ya tienes esa cáscara 🥚")
				return
			end

			if coins.Value < item.price then
				Notify.toast(player, string.format("Te faltan %d monedas", item.price - coins.Value))
				return
			end

			coins.Value -= item.price
			EggCharacter.setColor(player, item.color)
			Notify.toast(player, string.format("¡Compraste %s!", item.name))
		end)
	end
end

return Shop
