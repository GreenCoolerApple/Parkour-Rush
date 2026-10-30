local Players = game:GetService("Players")

local player = Players.LocalPlayer

local HudController = {}

local function createLabel(parent: Instance): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = "StageLabel"
	label.AnchorPoint = Vector2.new(0.5, 0)
	label.Position = UDim2.new(0.5, 0, 0, 12)
	label.Size = UDim2.new(0, 220, 0, 44)
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

	local stage = player:WaitForChild("leaderstats"):WaitForChild("Stage") :: IntValue

	local function update()
		label.Text = "Stage " .. stage.Value
	end

	update()
	stage.Changed:Connect(update)
end

return HudController
