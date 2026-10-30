local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local store = DataStoreService:GetDataStore(Config.DataStoreName)

export type PlayerData = {
	Stage: number,
}

local DataService = {}

local profiles: { [Player]: PlayerData } = {}
local savable: { [Player]: boolean } = {}

local function getKey(player: Player): string
	return "Player_" .. player.UserId
end

function DataService.Load(player: Player): PlayerData
	local data = table.clone(Config.DefaultData) :: PlayerData

	local success, result = pcall(function()
		return store:GetAsync(getKey(player))
	end)

	if success then
		if type(result) == "table" then
			for key, value in result do
				data[key] = value
			end
		end
		savable[player] = true
	end

	profiles[player] = data
	return data
end

function DataService.Get(player: Player): PlayerData?
	return profiles[player]
end

function DataService.Save(player: Player)
	local data = profiles[player]
	if not data or not savable[player] then
		return
	end

	pcall(function()
		store:UpdateAsync(getKey(player), function()
			return data
		end)
	end)
end

function DataService.Release(player: Player)
	DataService.Save(player)
	profiles[player] = nil
	savable[player] = nil
end

function DataService.Start()
	Players.PlayerRemoving:Connect(DataService.Release)

	game:BindToClose(function()
		local pending = 0
		for player in profiles do
			pending += 1
			task.spawn(function()
				DataService.Save(player)
				pending -= 1
			end)
		end
		while pending > 0 do
			task.wait()
		end
	end)

	task.spawn(function()
		while true do
			task.wait(Config.AutoSaveInterval)
			for player in profiles do
				task.spawn(DataService.Save, player)
			end
		end
	end)
end

return DataService
