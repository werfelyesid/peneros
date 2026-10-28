local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local ObbyBuilder = require(script.ObbyBuilder)
local EggCharacter = require(script.EggCharacter)
local Progress = require(script.Progress)
local Shop = require(script.Shop)

EggCharacter.init()

local world = ObbyBuilder.build()

Progress.init(world)
Shop.init(world)

print(string.format("[%s] listo: %d etapas, %d monedas, %d vitrinas", Config.Game.Name, #Config.Stages, #world.Coins, #world.ShopStands))
