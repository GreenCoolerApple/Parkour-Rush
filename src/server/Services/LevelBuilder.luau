local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Levels = require(ReplicatedStorage.Shared.Levels)

local LevelBuilder = {}

type Context = {
	Theme: any,
	Folder: Folder,
	MinY: number,
	StartZ: number,
	EndZ: number,
}

local cursor = Vector3.new(0, Config.CourseHeight, 6)
local checkpointIndex = 0
local checkpointsFolder: Folder
local courseFolder: Folder

local function createPart(className: string, size: Vector3, cframe: CFrame, color: Color3, material: Enum.Material): BasePart
	local part = Instance.new(className) :: BasePart
	part.Anchored = true
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

local function createDecor(size: Vector3, cframe: CFrame, color: Color3, material: Enum.Material, parent: Instance): BasePart
	local part = createPart("Part", size, cframe, color, material)
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Parent = parent
	return part
end

local function createAnchor(cframe: CFrame, parent: Instance): BasePart
	local anchor = createPart("Part", Vector3.one, cframe, Color3.new(), Enum.Material.SmoothPlastic)
	anchor.Name = "Anchor"
	anchor.Transparency = 1
	anchor.CanCollide = false
	anchor.CanTouch = false
	anchor.CanQuery = false
	anchor.Parent = parent
	return anchor
end

local function surface(ctx: Context, size: Vector3, gap: number, rise: number, x: number, className: string?): BasePart
	local top = cursor.Y + rise
	local z = cursor.Z - gap - size.Z / 2
	local part = createPart(
		className or "Part",
		size,
		CFrame.new(x, top - size.Y / 2, z),
		ctx.Theme.Platform,
		ctx.Theme.PlatformMaterial
	)
	cursor = Vector3.new(x, top, z - size.Z / 2)
	ctx.MinY = math.min(ctx.MinY, top - size.Y)
	return part
end

local function addCheckpoint(ctx: Context, levelIndex: number): BasePart
	checkpointIndex += 1
	local isSpawn = checkpointIndex == 1
	local part = surface(
		ctx,
		Vector3.new(12, 1, 12),
		if isSpawn then 0 else Config.CheckpointGap,
		0,
		0,
		if isSpawn then "SpawnLocation" else "Part"
	)
	part.Name = tostring(checkpointIndex)
	part.Color = ctx.Theme.Checkpoint
	part.Material = ctx.Theme.CheckpointMaterial
	part:SetAttribute("Level", levelIndex)
	if part:IsA("SpawnLocation") then
		part.Neutral = true
		part.Duration = 0
	end
	part.Parent = checkpointsFolder
	return part
end

local function addSign(checkpoint: BasePart, text: string, color: Color3)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Sign"
	billboard.Size = UDim2.fromOffset(320, 70)
	billboard.StudsOffset = Vector3.new(0, 9, 0)
	billboard.MaxDistance = 150
	billboard.LightInfluence = 0

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color
	label.TextStrokeTransparency = 0.2
	label.Font = Enum.Font.GothamBlack
	label.TextScaled = true
	label.Parent = billboard

	billboard.Parent = checkpoint
end

local Segments = {}

function Segments.Jumps(ctx: Context, segment)
	local size = segment.Size or Vector3.new(6, 1, 6)
	local zigzag = segment.Zigzag or 0
	for index = 1, segment.Count do
		local x = if zigzag == 0 then 0 elseif index % 2 == 0 then zigzag else -zigzag
		local part = surface(ctx, size, segment.Gap, segment.Rise or 0, x)
		part.Name = "Jump"
		part.Parent = ctx.Folder
	end
end

function Segments.Narrow(ctx: Context, segment)
	local part = surface(ctx, Vector3.new(1.4, 1, segment.Length), segment.Gap or 4, 0, 0)
	part.Name = "Beam"
	part.Parent = ctx.Folder
end

function Segments.Truss(ctx: Context, segment)
	local height = segment.Height
	local front = cursor.Z - 2
	local truss = createPart(
		"TrussPart",
		Vector3.new(2, height + 4, 2),
		CFrame.new(0, cursor.Y + (height - 4) / 2, front - 1),
		ctx.Theme.Accent,
		Enum.Material.Metal
	)
	truss.Name = "Truss"
	truss.Parent = ctx.Folder

	cursor = Vector3.new(0, cursor.Y, front - 2)
	local top = surface(ctx, Vector3.new(8, 1, 8), 0, height, 0)
	top.Name = "TrussTop"
	top.Parent = ctx.Folder
end

function Segments.Conveyor(ctx: Context, segment)
	local part = surface(ctx, Vector3.new(10, 1, segment.Length), 4, 0, 0)
	part.Name = "Conveyor"
	part.Color = ctx.Theme.Accent
	part.Material = Enum.Material.DiamondPlate
	part.Parent = ctx.Folder
	part.AssemblyLinearVelocity = Vector3.new(segment.Speed, 0, 0)
end

function Segments.Fade(ctx: Context, segment)
	for _ = 1, segment.Count do
		local part = surface(ctx, Vector3.new(6, 1, 6), segment.Gap, 0, 0)
		part.Name = "Fade"
		part.Color = ctx.Theme.Accent
		part.Material = Enum.Material.SmoothPlastic
		part.Parent = ctx.Folder
		CollectionService:AddTag(part, Config.FadeTag)
	end
end

function Segments.Bounce(ctx: Context, segment)
	local pad = surface(ctx, Vector3.new(6, 1, 6), 4, 0, 0)
	pad.Name = "BouncePad"
	pad.Color = ctx.Theme.Accent
	pad.Material = Enum.Material.Neon
	pad:SetAttribute("Power", segment.Power)
	pad.Parent = ctx.Folder
	CollectionService:AddTag(pad, Config.BounceTag)

	local landing = surface(ctx, Vector3.new(10, 1, 10), 4, segment.Height, 0)
	landing.Name = "Landing"
	landing.Parent = ctx.Folder
end

function Segments.Moving(ctx: Context, segment)
	for index = 1, segment.Count do
		local platform = surface(ctx, Vector3.new(6, 1, 6), 5, 0, 0)
		platform.Name = "Moving"
		platform.Color = ctx.Theme.Accent

		local model = Instance.new("Model")
		model.Name = "MovingPlatform"
		model.Parent = ctx.Folder

		local anchor = createAnchor(platform.CFrame, model)

		local attachment0 = Instance.new("Attachment")
		attachment0.Parent = anchor
		local attachment1 = Instance.new("Attachment")
		attachment1.Parent = platform

		local prismatic = Instance.new("PrismaticConstraint")
		prismatic.Attachment0 = attachment0
		prismatic.Attachment1 = attachment1
		prismatic.ActuatorType = Enum.ActuatorType.Servo
		prismatic.ServoMaxForce = math.huge
		prismatic.Speed = segment.Speed
		prismatic.LimitsEnabled = true
		prismatic.LowerLimit = -segment.Range
		prismatic.UpperLimit = segment.Range
		prismatic.Parent = platform

		platform.Anchored = false
		platform.Parent = model
		platform:SetNetworkOwner(nil)

		local direction = if index % 2 == 0 then 1 else -1
		local travelTime = segment.Range * 2 / segment.Speed
		task.spawn(function()
			while prismatic.Parent do
				prismatic.TargetPosition = segment.Range * direction
				task.wait(travelTime)
				direction = -direction
			end
		end)
	end
end

function Segments.Spinner(ctx: Context, segment)
	local base = surface(ctx, Vector3.new(16, 1, 16), 4, 0, 0)
	base.Name = "SpinnerBase"
	base.Parent = ctx.Folder

	local model = Instance.new("Model")
	model.Name = "Spinner"
	model.Parent = ctx.Folder

	local pivot = CFrame.new(base.Position.X, cursor.Y + 1.5, base.Position.Z)
	local anchor = createAnchor(pivot, model)

	local bar = createPart("Part", Vector3.new(15, 1, 1), pivot, ctx.Theme.Hazard, Enum.Material.Neon)
	bar.Name = "Bar"
	bar.Anchored = false

	local attachment0 = Instance.new("Attachment")
	attachment0.Axis = Vector3.yAxis
	attachment0.SecondaryAxis = Vector3.xAxis
	attachment0.Parent = anchor

	local attachment1 = Instance.new("Attachment")
	attachment1.Axis = Vector3.yAxis
	attachment1.SecondaryAxis = Vector3.xAxis
	attachment1.Parent = bar

	local hinge = Instance.new("HingeConstraint")
	hinge.Attachment0 = attachment0
	hinge.Attachment1 = attachment1
	hinge.ActuatorType = Enum.ActuatorType.Motor
	hinge.AngularVelocity = segment.Speed
	hinge.MotorMaxTorque = math.huge
	hinge.MotorMaxAcceleration = math.huge
	hinge.Parent = bar

	bar.Parent = model
	bar:SetNetworkOwner(nil)
	CollectionService:AddTag(bar, Config.KillPartTag)
end

local function buildHazard(ctx: Context)
	local length = ctx.StartZ - ctx.EndZ + 60
	local hazard = createPart(
		"Part",
		Vector3.new(Config.HazardWidth, 2, length),
		CFrame.new(0, ctx.MinY - Config.HazardDepth, (ctx.StartZ + ctx.EndZ) / 2),
		ctx.Theme.Hazard,
		ctx.Theme.HazardMaterial
	)
	hazard.Name = "Hazard"
	hazard.Transparency = ctx.Theme.HazardTransparency
	hazard.Parent = ctx.Folder
	CollectionService:AddTag(hazard, Config.KillPartTag)
end

local function buildScenery(ctx: Context, levelIndex: number)
	local theme = ctx.Theme
	local rng = Random.new(levelIndex)
	local floorY = ctx.MinY - Config.HazardDepth + 1

	local scenery = Instance.new("Folder")
	scenery.Name = "Scenery"
	scenery.Parent = ctx.Folder

	local function tint(): Color3
		return theme.Decor:Lerp(Color3.new(1, 1, 1), rng:NextNumber(0, 0.15))
	end

	local z = ctx.StartZ + 20
	while z > ctx.EndZ - 20 do
		for _, side in { -1, 1 } do
			local width = rng:NextNumber(8, 18)
			local x = side * (rng:NextNumber(26, 80) + width / 2)
			local offsetZ = z + rng:NextNumber(-5, 5)

			if theme.Style == "Towers" then
				local height = rng:NextNumber(20, 90)
				createDecor(
					Vector3.new(width, height, width),
					CFrame.new(x, floorY + height / 2, offsetZ),
					tint(),
					theme.DecorMaterial,
					scenery
				)
			elseif theme.Style == "Islands" then
				local y = ctx.MinY + rng:NextNumber(-10, 30)
				createDecor(
					Vector3.new(width, width * 0.6, width),
					CFrame.new(x, y, offsetZ) * CFrame.Angles(0, rng:NextNumber(0, math.pi), 0),
					tint(),
					theme.DecorMaterial,
					scenery
				)
				createDecor(
					Vector3.new(width, 1.2, width),
					CFrame.new(x, y + width * 0.3 + 0.6, offsetZ) * CFrame.Angles(0, rng:NextNumber(0, math.pi), 0),
					theme.Platform,
					Enum.Material.Grass,
					scenery
				)
			elseif theme.Style == "Pipes" then
				local height = rng:NextNumber(30, 100)
				local diameter = width * 0.6
				local pipe = createDecor(
					Vector3.new(height, diameter, diameter),
					CFrame.new(x, floorY + height / 2, offsetZ) * CFrame.Angles(0, 0, math.pi / 2),
					tint(),
					theme.DecorMaterial,
					scenery
				)
				pipe.Shape = Enum.PartType.Cylinder
				if rng:NextNumber() < 0.4 then
					local ring = createDecor(
						Vector3.new(1.5, diameter + 1, diameter + 1),
						CFrame.new(x, floorY + height * rng:NextNumber(0.4, 0.9), offsetZ) * CFrame.Angles(0, 0, math.pi / 2),
						theme.Hazard,
						Enum.Material.Neon,
						scenery
					)
					ring.Shape = Enum.PartType.Cylinder
				end
			elseif theme.Style == "Grid" then
				local height = rng:NextNumber(30, 120)
				createDecor(
					Vector3.new(1.5, height, 1.5),
					CFrame.new(x, floorY + height / 2, offsetZ),
					tint(),
					theme.DecorMaterial,
					scenery
				)
				if rng:NextNumber() < 0.5 then
					local cubeSize = rng:NextNumber(3, 7)
					createDecor(
						Vector3.one * cubeSize,
						CFrame.new(x, ctx.MinY + rng:NextNumber(15, 45), offsetZ)
							* CFrame.Angles(rng:NextNumber(0, math.pi), rng:NextNumber(0, math.pi), 0),
						theme.Accent,
						Enum.Material.Neon,
						scenery
					)
				end
			end
		end
		z -= 16
	end

	if theme.Clouds then
		local length = ctx.StartZ - ctx.EndZ
		for _ = 1, math.floor(length / 25) do
			local cloud = createDecor(
				Vector3.new(rng:NextNumber(20, 50), 4, rng:NextNumber(14, 30)),
				CFrame.new(
					rng:NextNumber(-150, 150),
					ctx.MinY + rng:NextNumber(40, 80),
					rng:NextNumber(ctx.EndZ, ctx.StartZ)
				),
				Color3.new(1, 1, 1),
				Enum.Material.SmoothPlastic,
				scenery
			)
			cloud.Transparency = 0.25
			cloud.CastShadow = false
		end
	end
end

function LevelBuilder.Build()
	local existingCheckpoints = workspace:FindFirstChild(Config.CheckpointFolder)
	if existingCheckpoints then
		existingCheckpoints:Destroy()
	end
	local existingCourse = workspace:FindFirstChild(Config.CourseFolder)
	if existingCourse then
		existingCourse:Destroy()
	end

	courseFolder = Instance.new("Folder")
	courseFolder.Name = Config.CourseFolder
	courseFolder.Parent = workspace

	checkpointsFolder = Instance.new("Folder")
	checkpointsFolder.Name = Config.CheckpointFolder
	checkpointsFolder.Parent = workspace

	local lastCheckpoint: BasePart? = nil

	for levelIndex, level in Levels.List do
		local folder = Instance.new("Folder")
		folder.Name = level.Name
		folder.Parent = courseFolder

		local ctx: Context = {
			Theme = level.Theme,
			Folder = folder,
			MinY = cursor.Y - 1,
			StartZ = cursor.Z,
			EndZ = cursor.Z,
		}

		if not lastCheckpoint then
			lastCheckpoint = addCheckpoint(ctx, levelIndex)
		end
		addSign(lastCheckpoint :: BasePart, level.Name, level.Theme.Accent)

		for _, stage in level.Stages do
			for _, segment in stage do
				local handler = Segments[segment.Type]
				if handler then
					handler(ctx, segment)
				end
			end
			lastCheckpoint = addCheckpoint(ctx, levelIndex)
		end

		ctx.EndZ = cursor.Z
		buildHazard(ctx)
		buildScenery(ctx, levelIndex)
	end

	if lastCheckpoint then
		addSign(lastCheckpoint, "FINISH", Color3.fromRGB(255, 255, 255))
	end
end

return LevelBuilder
