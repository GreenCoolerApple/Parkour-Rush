local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local DataService = require(script.Parent.DataService)

local checkpoints = workspace:WaitForChild(Config.CheckpointFolder)

local StageService = {}

local function getCheckpoint(stage: number): BasePart?
	local checkpoint = checkpoints:FindFirstChild(tostring(stage))
	if checkpoint and checkpoint:IsA("BasePart") then
		return checkpoint
	end
	return nil
end

local function teleportToStage(player: Player, character: Model)
	local data = DataService.Get(player)
	if not data then
		return
	end

	local checkpoint = getCheckpoint(data.Stage)
	if not checkpoint then
		return
	end

	character:WaitForChild("HumanoidRootPart")
	task.defer(function()
		character:PivotTo(checkpoint.CFrame + Config.SpawnOffset)
	end)
end

local function setupPlayer(player: Player)
	local data = DataService.Load(player)

	if not getCheckpoint(data.Stage) then
		data.Stage = 1
	end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"

	local stage = Instance.new("IntValue")
	stage.Name = "Stage"
	stage.Value = data.Stage
	stage.Parent = leaderstats

	leaderstats.Parent = player

	stage.Changed:Connect(function(value)
		data.Stage = value
	end)

	player.CharacterAdded:Connect(function(character)
		teleportToStage(player, character)
	end)

	if player.Character then
		teleportToStage(player, player.Character)
	end
end

local function bindCheckpoint(checkpoint: Instance)
	if not checkpoint:IsA("BasePart") then
		return
	end

	local number = tonumber(checkpoint.Name)
	if not number then
		return
	end

	checkpoint.Touched:Connect(function(hit)
		local character = hit.Parent
		if not character then
			return
		end

		local player = Players:GetPlayerFromCharacter(character)
		if not player then
			return
		end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then
			return
		end

		local leaderstats = player:FindFirstChild("leaderstats")
		local stage = leaderstats and leaderstats:FindFirstChild("Stage") :: IntValue?
		if stage and number == stage.Value + 1 then
			stage.Value = number
		end
	end)
end

function StageService.Start()
	for _, checkpoint in checkpoints:GetChildren() do
		bindCheckpoint(checkpoint)
	end
	checkpoints.ChildAdded:Connect(bindCheckpoint)

	Players.PlayerAdded:Connect(setupPlayer)
	for _, player in Players:GetPlayers() do
		task.spawn(setupPlayer, player)
	end
end

return StageService
