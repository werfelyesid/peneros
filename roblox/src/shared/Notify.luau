local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Notify = {}

local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ShowMessage")

function Notify.toast(player, text)
	remote:FireClient(player, text)
end

return Notify
