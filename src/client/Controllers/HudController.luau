local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Levels = require(ReplicatedStorage.Shared.Levels)

local player = Players.LocalPlayer

local HudController = {}

local function createLabel(parent: Instance): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = "StageLabel"
	label.AnchorPoint = Vector2.new(0.5, 0)
	label.Position = UDim2.new(0.5, 0, 0, 12)
	label.Size = UDim2.new(0, 280, 0, 44)
	label.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	label.BackgroundTransparency = 0.3
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Text = ""

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = label

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 6)
	padding.PaddingBottom = UDim.new(0, 6)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = label

	label.Parent = parent
	return label
end

function HudController.Start()
	local gui = Instance.new("ScreenGui")
	gui.Name = "Hud"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local label = createLabel(gui)
	local total = Levels.GetTotalStages()

	local stage = player:WaitForChild("leaderstats"):WaitForChild("Stage") :: IntValue

	local function update()
		if stage.Value > total then
			label.Text = "FINISH!"
			return
		end
		local level = Levels.List[Levels.GetLevelIndex(stage.Value)]
		label.Text = level.Name .. "  •  " .. stage.Value .. "/" .. total
	end

	update()
	stage.Changed:Connect(update)
end

return HudController
