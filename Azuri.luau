--[[ // HEADER ----------------------------------------]]

local Mouse = Owner:GetMouse()
local Character = Owner.Character
local Humanoid = Character:WaitForChild("Humanoid")
local Assets = game:GetObjects("rbxassetid://78538014263390")[2].Azuri
print(Assets.Name)
--[[for i,v in Assets:GetChildren() do
  print(v.Name)
end]]
local MusicId = "rbxassetid://91283569878673"
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local RootJoint = Character.HumanoidRootPart.RootJoint
local Left_Shoulder = Character.Torso["Left Shoulder"]
local Right_Shoulder = Character.Torso["Right Shoulder"]
local Neck = Character.Torso.Neck
local alpha = .1

local x = 0
local inAction = false

--[[ // CHARACTER ----------------------------------------]]
NLS([[
    local character = Owner.Character
    local humanoid = character:WaitForChild("Humanoid")
	local mouse = Owner:GetMouse()
    local Animate = character:FindFirstChild("Animate")
    if Animate then
        Animate:Destroy()
    end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in animator:GetPlayingAnimationTracks() do
            track:Stop(0)
            track:Destroy()
        end
    end
	mouse.TargetFilter = character
]])

for i,v in Character:GetDescendants() do
  if v:IsA("BasePart") then
    v.Transparency = 1
  end
end

local Music = Instance.new("Sound")
Music.SoundId = MusicId
Music.Volume = .5
Music.Looped = true
Music.Parent = Character.HumanoidRootPart

Music:Play()

Assets.Humanoid:Destroy()
local OverlapCharacter = Instance.new("Model")
OverlapCharacter.Name = "OverlapCharacter"
OverlapCharacter.Parent = Character
for i,v in Assets:GetChildren() do
  if v.Name == "Handle" then continue end

  local matchingPart = Character:FindFirstChild(v.Name)

    if matchingPart and matchingPart:IsA("BasePart") then
        v.Anchored = false
        v.Massless = true
        v.CFrame = matchingPart.CFrame
        local Weld = Instance.new("Weld")
        Weld.Part0 = v
        Weld.Part1 = matchingPart
        Weld.Parent = v
		v.Parent = matchingPart
    end

    --[[v.Parent = OverlapCharacter]]
end
for i,v in Assets:GetDescendants() do
	if v:IsA("BasePart") then
		v.CanCollide = false
		v.CanQuery = false
		v.Massless = true
	end
end

local BackgroundStaff = Assets.Handle:Clone()
local Hold = Instance.new("Weld")
Hold.Part0 = Assets.Handle
Hold.Part1 = Character["Right Arm"]
Hold.Parent = Character["Right Arm"]
Hold.C0 = CFrame.new(-0.05, -1.50, 1.00) * CFrame.Angles(math.rad(70.00), math.rad(-100.00), math.rad(0.00))
Assets.Handle.Parent = Character
Assets.Legs.Parent = Character
print(Assets.Handle)



--[[ // FUNCTIONS ----------------------------------------]]

local function SummonSFX(SoundID, RemoveAfterPlayed, Volume, PlaybackSpeed, Parent, PlaybackRegion)
	Volume = Volume or 1
	PlaybackSpeed = PlaybackSpeed or 1
	
	if RemoveAfterPlayed == nil then RemoveAfterPlayed = true end
	Parent = Parent or Character.HumanoidRootPart

	local Sound = Instance.new("Sound")
	Sound.SoundId = SoundID
	Sound.Volume = Volume
	Sound.PlaybackSpeed = PlaybackSpeed
    
	if PlaybackRegion then
		Sound.PlaybackRegionsEnabled = true
		Sound.PlaybackRegion = PlaybackRegion
	end
    
	Sound.Parent = Parent
	
	if RemoveAfterPlayed then
		Debris:AddItem(Sound, 5)
	end

	return Sound
end

local function HitboxAoE(Character, Hit, Range, Size)
	local _CFrame = Hit * CFrame.new(0, 0, -Range / 2)
	local Size = Vector3.new(Size.X, Size.Y, Range)

	local Params = OverlapParams.new()
	Params.FilterType = Enum.RaycastFilterType.Exclude
	Params.FilterDescendantsInstances = {Character, Character:FindFirstChild("OverlapCharacter")}

	local Parts = workspace:GetPartBoundsInBox(_CFrame, Size, Params)

	local hitCharacters = {}
	for _, part in Parts do
		local hitCharacter = part.Parent
		if hitCharacter and hitCharacter:FindFirstChildOfClass("Humanoid") then
			if not table.find(hitCharacters, hitCharacter) then
				table.insert(hitCharacters, hitCharacter)
			end
		end
	end

	return hitCharacters
end

local function HitPatcher(CastFrom, TargetPosition, Filter)
	local Params = RaycastParams.new()
	Params.FilterDescendantsInstances = Filter or {}
	Params.FilterType = Enum.RaycastFilterType.Exclude
	
	local Dir = (TargetPosition - CastFrom)
	
	local Result = workspace:Raycast(CastFrom, Dir, Params)
	return Result and CFrame.new(Result.Position) or CFrame.new(TargetPosition)
end

local function GetExclusions()
	local Exclusions = {Character}
	return Exclusions
end

local function AzureBlast()
  	local Hit = Mouse.Hit
  	local Origin = Character.HumanoidRootPart.Position
	local MousePosition = Mouse.Hit.Position
	local Exclusions = GetExclusions()
	local ReliableCFrame = HitPatcher(Origin, MousePosition, Exclusions)
  	local Offset = ReliableCFrame * CFrame.new(0, 10, 0)


  	inAction = true
  	local Attachm = Instance.new("Attachment", Character.Torso)
  	local nebula1 = BackgroundStaff.StarPartics.nebula1:Clone()
  	local nebula2 = BackgroundStaff.StarPartics.nebula2:Clone()
  	local rays3   = BackgroundStaff.StarPartics.rays3:Clone()

   	local RedColor = ColorSequence.new(Color3.fromRGB(255, 0, 0))

   	nebula1.Color = RedColor
   	nebula1.Size = NumberSequence.new(5)
   	nebula1.Parent = Attachm

   	nebula2.Color = RedColor
   	nebula2.Size = NumberSequence.new(5)
   	nebula2.Parent = Attachm

   
   	rays3.Color = RedColor
   	rays3.Size = NumberSequence.new(3.75, 5)
   	rays3.Parent = Attachm

   

  	SummonSFX("rbxassetid://99173388", true, 1, 0.95, Character.HumanoidRootPart):Play()
  	for i = 1, 55 do
		RunService.Heartbeat:Wait()
		Left_Shoulder.C0 = Left_Shoulder.C0:Lerp(CFrame.new(-1.00, 0.20, 0.00) * CFrame.Angles(math.rad(-20.00), math.rad(-50.00), math.rad(-50.00)), alpha)
		Right_Shoulder.C0 = Right_Shoulder.C0:Lerp(CFrame.new(1.00, 0.60, 0.00) * CFrame.Angles(math.rad(50.00), math.rad(50.00), math.rad(90.00)), alpha)
		Neck.C0 = Neck.C0:Lerp(CFrame.new(0.00, 1.00, 0.00) * CFrame.Angles(math.rad(-70.00), math.rad(0.00), math.rad(-230.00)), alpha)
		RootJoint.C0 = RootJoint.C0:Lerp(CFrame.new(0.00, 0.00 + math.sin(x/45) * 0.15, 0.00) * CFrame.Angles(math.rad(-90.00), math.rad(0.00), math.rad(-180.00)), alpha)
		Hold.C0 = Hold.C0:Lerp(CFrame.new(0.00, -1.50, 1.00) * CFrame.Angles(math.rad(90.00), math.rad(0.00), math.rad(-0.00)), alpha)
  	end
  	task.wait(2)
  	nebula1:Destroy() nebula2:Destroy() rays3:Destroy()
  	for i = 1, 25 do
		RunService.Heartbeat:Wait()
		x += 1
		Left_Shoulder.C0 = Left_Shoulder.C0:Lerp(CFrame.new(-1.00, 0.20, 0.00) * CFrame.Angles(math.rad(50.00), math.rad(-120.00), math.rad(-90.00)), alpha)
		Right_Shoulder.C0 = Right_Shoulder.C0:Lerp(CFrame.new(1.00, 0.60, 0.00) * CFrame.Angles(math.rad(50.00), math.rad(120.00), math.rad(90.00)), alpha)
		Neck.C0 = Neck.C0:Lerp(CFrame.new(0.00, 1.00, 0.00) * CFrame.Angles(math.rad(-90.00), math.rad(0.00), math.rad(-180.00)), alpha)
		RootJoint.C0 = CFrame.new(0.00, 1.50, 0.00) * CFrame.Angles(math.rad(-90.00) - (x/9), math.rad(0.00), math.rad(-180.00))
		Hold.C0 = Hold.C0:Lerp(CFrame.new(0.00, -1.50, 1.00) * CFrame.Angles(math.rad(90.00), math.rad(0.00), math.rad(-0.00)), alpha)
  	end
  	local AttackAttach = Instance.new("Attachment", workspace:FindFirstChildOfClass("Terrain"))
  	local idle = BackgroundStaff.StarPartics.idle:Clone()
  	local idle2 = BackgroundStaff.StarPartics.idle2:Clone()
  	local Scale = NumberSequence.new({
    	NumberSequenceKeypoint.new(0.0, 0.5, 0),
    	NumberSequenceKeypoint.new(0.5, 5.0, 0),
    	NumberSequenceKeypoint.new(1.0, 0.5, 0)
   	})
   	idle.Size = Scale
	idle2.Size = Scale
	idle.Parent = AttackAttach
	idle2.Parent = AttackAttach
	idle:Emit(30)
    idle2:Emit(30)
	AttackAttach.CFrame = Offset
	Debris:AddItem(AttackAttach, 5)
  	SummonSFX("rbxassetid://11984351", true, 1, 1, AttackAttach):Play()

	local ExplodedRadius = 55
	local TargetsHit = HitboxAoE(Character, Offset, ExplodedRadius, Vector3.new(ExplodedRadius, ExplodedRadius, ExplodedRadius))

	for _, victim in TargetsHit do
    	local vHum = victim:FindFirstChildOfClass("Humanoid")
		if vHum == Humanoid then continue end
		local vRoot = victim:FindFirstChild("HumanoidRootPart")
		local dmg = vHum.MaxHealth * (40 / 60) 
		vHum:TakeDamage(dmg)
	end


  	inAction = false
end


--[[ // MOUSE ----------------------------------------]]

Mouse.KeyDown:Connect(function(key)
  if inAction == true then return end
  if key == "t" then
    AzureBlast()
  end
end)

--[[ // MAIN ----------------------------------------]]


RunService.Heartbeat:Connect(function()
  x += 1
  if inAction == false then
     Left_Shoulder.C0 = Left_Shoulder.C0:Lerp(CFrame.new(-1.00, 0.20 + math.sin(x/45) * 0.15, 0.00) * CFrame.Angles(math.rad(-60.00), math.rad(-120.00), math.rad(-180.00)), alpha)
	  Right_Shoulder.C0 = Right_Shoulder.C0:Lerp(CFrame.new(1.00, 0.30 + math.sin(x/45) * 0.15, 0.00) * CFrame.Angles(math.rad(50.00), math.rad(50.00), math.rad(20.00)), alpha)
	  Neck.C0 = Neck.C0:Lerp(CFrame.new(0.00, 1.00, 0.00) * CFrame.Angles(math.rad(-100.00) + math.sin(x/45) * 0.15, math.rad(0.00), math.rad(-180.00)), alpha)
	  RootJoint.C0 = RootJoint.C0:Lerp(CFrame.new(0.00, 0.00 + math.sin(x/45) * 0.15, 0.00) * CFrame.Angles(math.rad(-90.00), math.rad(0.00), math.rad(-180.00)), alpha)
	  Hold.C0 = Hold.C0:Lerp(CFrame.new(-0.05, -1.50, 1.00) * CFrame.Angles(math.rad(70.00), math.rad(-100.00), math.rad(0.00)), alpha)
  end
 
end)



