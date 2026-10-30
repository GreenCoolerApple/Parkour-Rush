local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Config = require(ReplicatedStorage.Shared.Config)
local Levels = require(ReplicatedStorage.Shared.Levels)

local player = Players.LocalPlayer

local EnvironmentController = {}

local currentLevel = 0

local function getEffect(className: string): Instance
	local effect = Lighting:FindFirstChildOfClass(className)
	if not effect then
		effect = Instance.new(className)
		effect.Parent = Lighting
	end
	return effect
end

local function apply(levelIndex: number, instant: boolean)
	if levelIndex == currentLevel then
		return
	end
	currentLevel = levelIndex

	local settings = Levels.List[levelIndex].Theme.Lighting
	local info = TweenInfo.new(if instant then 0 else Config.LightingTweenTime, Enum.EasingStyle.Sine)

	local atmosphere = getEffect("Atmosphere")
	local correction = getEffect("ColorCorrectionEffect")

	TweenService:Create(Lighting, info, {
		ClockTime = settings.ClockTime,
		Brightness = settings.Brightness,
		Ambient = settings.Ambient,
		OutdoorAmbient = settings.OutdoorAmbient,
	}):Play()

	TweenService:Create(atmosphere, info, {
		Density = settings.Density,
		Color = settings.Color,
		Decay = settings.Decay,
		Haze = settings.Haze,
		Glare = settings.Glare,
	}):Play()

	TweenService:Create(correction, info, {
		TintColor = settings.Tint,
	}):Play()
end

function EnvironmentController.Start()
	local stage = player:WaitForChild("leaderstats"):WaitForChild("Stage") :: IntValue

	apply(Levels.GetLevelIndex(stage.Value), true)

	stage.Changed:Connect(function(value)
		apply(Levels.GetLevelIndex(value), false)
	end)
end

return EnvironmentController
