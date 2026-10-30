local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local HazardService = {}

local function bindKillPart(instance: Instance)
	if not instance:IsA("BasePart") then
		return
	end

	instance.Touched:Connect(function(hit)
		local character = hit.Parent
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 then
			humanoid.Health = 0
		end
	end)
end

function HazardService.Start()
	for _, instance in CollectionService:GetTagged(Config.KillPartTag) do
		bindKillPart(instance)
	end
	CollectionService:GetInstanceAddedSignal(Config.KillPartTag):Connect(bindKillPart)
end

return HazardService
