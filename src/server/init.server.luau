local Services = script:WaitForChild("Services")

local DataService = require(Services.DataService)
local HazardService = require(Services.HazardService)
local StageService = require(Services.StageService)

DataService.Start()
HazardService.Start()
StageService.Start()
