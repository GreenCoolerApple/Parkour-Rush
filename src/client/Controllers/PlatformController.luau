local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local player = Players.LocalPlayer

local PlatformController = {}

local lastBounce = 0

local function bindBounce(instance: Instance)
	if not instance:IsA("BasePart") then
		return
	end

	instance.Touched:Connect(function(hit)
		local character = player.Character
		if not character or not hit:IsDescendantOf(character) then
			return
		end

		local now = os.clock()
		if now - lastBounce < Config.BounceCooldown then
			return
		end

		local root = character:FindFirstChild("HumanoidRootPart") :: BasePart?
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid or humanoid.Health <= 0 then
			return
		end

		lastBounce = now
		local power = instance:GetAttribute("Power") or 90
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		local velocity = root.AssemblyLinearVelocity
		root.AssemblyLinearVelocity = Vector3.new(velocity.X, power, velocity.Z)
	end)
end

function PlatformController.Start()
	for _, instance in CollectionService:GetTagged(Config.BounceTag) do
		bindBounce(instance)
	end
	CollectionService:GetInstanceAddedSignal(Config.BounceTag):Connect(bindBounce)
end

return PlatformController
