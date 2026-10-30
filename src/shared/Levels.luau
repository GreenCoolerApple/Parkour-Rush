local Levels = {}

Levels.List = {
	{
		Name = "Rooftops",
		Theme = {
			Platform = Color3.fromRGB(163, 162, 165),
			PlatformMaterial = Enum.Material.Concrete,
			Checkpoint = Color3.fromRGB(80, 200, 120),
			CheckpointMaterial = Enum.Material.SmoothPlastic,
			Accent = Color3.fromRGB(255, 190, 60),
			Hazard = Color3.fromRGB(30, 60, 110),
			HazardMaterial = Enum.Material.Glass,
			HazardTransparency = 0.2,
			Decor = Color3.fromRGB(90, 95, 110),
			DecorMaterial = Enum.Material.Concrete,
			Style = "Towers",
			Clouds = true,
			Lighting = {
				ClockTime = 14,
				Brightness = 2,
				Ambient = Color3.fromRGB(90, 90, 100),
				OutdoorAmbient = Color3.fromRGB(128, 128, 140),
				Density = 0.3,
				Color = Color3.fromRGB(199, 220, 255),
				Decay = Color3.fromRGB(106, 112, 125),
				Haze = 1,
				Glare = 0,
				Tint = Color3.fromRGB(255, 255, 255),
			},
		},
		Stages = {
			{
				{ Type = "Jumps", Count = 3, Gap = 5, Size = Vector3.new(8, 1, 8) },
			},
			{
				{ Type = "Jumps", Count = 4, Gap = 6, Rise = 1, Zigzag = 3 },
				{ Type = "Narrow", Length = 20 },
			},
			{
				{ Type = "Truss", Height = 12 },
				{ Type = "Jumps", Count = 3, Gap = 6 },
			},
			{
				{ Type = "Conveyor", Length = 24, Speed = 8 },
				{ Type = "Jumps", Count = 3, Gap = 7, Rise = -1 },
			},
		},
	},
	{
		Name = "Sky Islands",
		Theme = {
			Platform = Color3.fromRGB(110, 170, 80),
			PlatformMaterial = Enum.Material.Grass,
			Checkpoint = Color3.fromRGB(255, 220, 90),
			CheckpointMaterial = Enum.Material.SmoothPlastic,
			Accent = Color3.fromRGB(255, 140, 200),
			Hazard = Color3.fromRGB(240, 240, 255),
			HazardMaterial = Enum.Material.SmoothPlastic,
			HazardTransparency = 0,
			Decor = Color3.fromRGB(120, 95, 70),
			DecorMaterial = Enum.Material.Slate,
			Style = "Islands",
			Clouds = true,
			Lighting = {
				ClockTime = 17.6,
				Brightness = 2.5,
				Ambient = Color3.fromRGB(120, 100, 110),
				OutdoorAmbient = Color3.fromRGB(150, 120, 120),
				Density = 0.35,
				Color = Color3.fromRGB(255, 200, 170),
				Decay = Color3.fromRGB(180, 120, 140),
				Haze = 1.5,
				Glare = 0.5,
				Tint = Color3.fromRGB(255, 235, 220),
			},
		},
		Stages = {
			{
				{ Type = "Fade", Count = 4, Gap = 5 },
			},
			{
				{ Type = "Bounce", Height = 14, Power = 95 },
				{ Type = "Jumps", Count = 2, Gap = 6 },
			},
			{
				{ Type = "Moving", Count = 2, Range = 8, Speed = 6 },
			},
			{
				{ Type = "Fade", Count = 3, Gap = 6 },
				{ Type = "Bounce", Height = 16, Power = 100 },
			},
		},
	},
	{
		Name = "Lava Factory",
		Theme = {
			Platform = Color3.fromRGB(70, 70, 75),
			PlatformMaterial = Enum.Material.DiamondPlate,
			Checkpoint = Color3.fromRGB(255, 170, 40),
			CheckpointMaterial = Enum.Material.SmoothPlastic,
			Accent = Color3.fromRGB(255, 220, 0),
			Hazard = Color3.fromRGB(255, 85, 0),
			HazardMaterial = Enum.Material.Neon,
			HazardTransparency = 0,
			Decor = Color3.fromRGB(50, 50, 55),
			DecorMaterial = Enum.Material.Metal,
			Style = "Pipes",
			Clouds = false,
			Lighting = {
				ClockTime = 0,
				Brightness = 1,
				Ambient = Color3.fromRGB(110, 50, 40),
				OutdoorAmbient = Color3.fromRGB(90, 40, 30),
				Density = 0.45,
				Color = Color3.fromRGB(255, 120, 70),
				Decay = Color3.fromRGB(90, 30, 20),
				Haze = 2,
				Glare = 0,
				Tint = Color3.fromRGB(255, 220, 200),
			},
		},
		Stages = {
			{
				{ Type = "Spinner", Speed = 1.5 },
				{ Type = "Jumps", Count = 2, Gap = 6 },
			},
			{
				{ Type = "Conveyor", Length = 30, Speed = 12 },
				{ Type = "Moving", Count = 2, Range = 8, Speed = 7 },
			},
			{
				{ Type = "Spinner", Speed = 2.5 },
				{ Type = "Truss", Height = 14 },
			},
			{
				{ Type = "Narrow", Length = 24 },
				{ Type = "Spinner", Speed = 3 },
				{ Type = "Moving", Count = 1, Range = 10, Speed = 8 },
			},
		},
	},
	{
		Name = "Neon Void",
		Theme = {
			Platform = Color3.fromRGB(35, 30, 55),
			PlatformMaterial = Enum.Material.SmoothPlastic,
			Checkpoint = Color3.fromRGB(255, 0, 200),
			CheckpointMaterial = Enum.Material.Neon,
			Accent = Color3.fromRGB(0, 255, 255),
			Hazard = Color3.fromRGB(120, 0, 255),
			HazardMaterial = Enum.Material.ForceField,
			HazardTransparency = 0,
			Decor = Color3.fromRGB(0, 200, 255),
			DecorMaterial = Enum.Material.Neon,
			Style = "Grid",
			Clouds = false,
			Lighting = {
				ClockTime = 0,
				Brightness = 0.5,
				Ambient = Color3.fromRGB(60, 40, 90),
				OutdoorAmbient = Color3.fromRGB(40, 20, 70),
				Density = 0.4,
				Color = Color3.fromRGB(80, 40, 160),
				Decay = Color3.fromRGB(20, 0, 60),
				Haze = 0,
				Glare = 0,
				Tint = Color3.fromRGB(230, 210, 255),
			},
		},
		Stages = {
			{
				{ Type = "Jumps", Count = 5, Gap = 7, Zigzag = 4, Size = Vector3.new(4, 1, 4) },
			},
			{
				{ Type = "Fade", Count = 5, Gap = 6 },
				{ Type = "Bounce", Height = 16, Power = 100 },
			},
			{
				{ Type = "Moving", Count = 3, Range = 10, Speed = 8 },
				{ Type = "Spinner", Speed = 3 },
			},
			{
				{ Type = "Narrow", Length = 30 },
				{ Type = "Fade", Count = 3, Gap = 6 },
				{ Type = "Truss", Height = 16 },
				{ Type = "Jumps", Count = 3, Gap = 8, Size = Vector3.new(5, 1, 5) },
			},
		},
	},
}

function Levels.GetTotalStages(): number
	local total = 0
	for _, level in Levels.List do
		total += #level.Stages
	end
	return total
end

function Levels.GetLevelIndex(stage: number): number
	local count = 0
	for index, level in Levels.List do
		count += #level.Stages
		if stage <= count then
			return index
		end
	end
	return #Levels.List
end

return Levels
