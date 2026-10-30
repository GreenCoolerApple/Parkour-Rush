local Controllers = script:WaitForChild("Controllers")

local EnvironmentController = require(Controllers.EnvironmentController)
local HudController = require(Controllers.HudController)
local PlatformController = require(Controllers.PlatformController)

PlatformController.Start()
task.spawn(EnvironmentController.Start)
HudController.Start()
