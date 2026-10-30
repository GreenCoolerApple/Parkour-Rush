local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage.Shared.Config)

local PlatformService = {}

local fadeInfo = TweenInfo.new(Config.FadeTime, Enum.EasingStyle.Linear)

local function bindFade(instance: Instance)
	if not instance:IsA("BasePart") then
		return
	end

	local part = instance
	local busy = false

	part.Touched:Connect(function(hit)
		if busy then
			return
		end
		local character = hit.Parent
		if not character or not character:FindFirstChildOfClass("Humanoid") then
			return
		end

		busy = true
		local tween = TweenService:Create(part, fadeInfo, { Transparency = 0.85 })
		tween:Play()
		tween.Completed:Wait()

		part.CanCollide = false
		part.Transparency = 1
		task.wait(Config.FadeRespawn)
		part.CanCollide = true
		part.Transparency = 0
		busy = false
	end)
end

function PlatformService.Start()
	for _, instance in CollectionService:GetTagged(Config.FadeTag) do
		bindFade(instance)
	end
	CollectionService:GetInstanceAddedSignal(Config.FadeTag):Connect(bindFade)
end

return PlatformService
