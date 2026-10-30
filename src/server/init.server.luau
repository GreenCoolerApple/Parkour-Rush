local Services = script:WaitForChild("Services")

local LevelBuilder = require(Services.LevelBuilder)
local DataService = require(Services.DataService)
local HazardService = require(Services.HazardService)
local PlatformService = require(Services.PlatformService)
local StageService = require(Services.StageService)

LevelBuilder.Build()
DataService.Start()
HazardService.Start()
PlatformService.Start()
StageService.Start()
