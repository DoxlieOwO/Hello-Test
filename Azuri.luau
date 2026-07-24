---------- // HEADER \\ ----------

local Mouse = Owner:GetMouse()
local Character = Owner.Character
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

---------- // CHARACTER \\ ----------
NLS([[
    local character = Owner.Character
    local humanoid = character:WaitForChild("Humanoid")

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
local OverlapCharacter = Instance.new("Folder")
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
    end

    v.Parent = OverlapCharacter
end

local HoldStaff = Instance.new("Weld")
HoldStaff.Part0 = Assets.Handle
HoldStaff.Part1 = Character["Right Arm"]
HoldStaff.Parent = Character["Right Arm"]
HoldStaff.C0 = CFrame.new(-0.05, -1.50, 1.00) * CFrame.Angles(math.rad(70.00), math.rad(-100.00), math.rad(0.00))
Assets.Handle.Parent = OverlapCharacter
print(Assets.Handle)



---------- // FUNCTIONS \\ ----------

local function SummonSFX(SoundID, RemoveAfterPlayed, Volume, PlaybackSpeed, Parent, PlaybackRegion) -- RemoveAfterPlayed doesn't work as intended, you can put false but it will still delete the audio when done anyway.
	Volume = Volume or 1
	PlaybackSpeed = PlaybackSpeed or 1
	RemoveAfterPlayed = RemoveAfterPlayed or true
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
	if RemoveAfterPlayed == false then
		return Sound
	elseif RemoveAfterPlayed == true then
		Services.Debris:AddItem(Sound, Sound.TimeLength + 5)
	end

	return Sound
end

local function AzureBlast()
  local Hit = Mouse.Hit
  local Offset = Hit * CFrame.new(0, 10, 0)
  SummonSFX("rbxassetid://11984351", true, 1, 1, Character.HumanoidRootPart):Play()
end



---------- // MOUSE \\ ----------

Mouse.KeyDown:Connect(function(key)
  if key == "t" then
    AzureBlast()
  end
end)

---------- // MAIN \\ ----------


RunService.Heartbeat:Connect(function()
  x += 1
  if not inAction then
     Left_Shoulder.C0 = Left_Shoulder.C0:Lerp(CFrame.new(-1.00, 0.20 + math.sin(x/45) * 0.15, 0.00) * CFrame.Angles(math.rad(-60.00), math.rad(-120.00), math.rad(-180.00)), alpha)
	  Right_Shoulder.C0 = Right_Shoulder.C0:Lerp(CFrame.new(1.00, 0.30 + math.sin(x/45) * 0.15, 0.00) * CFrame.Angles(math.rad(50.00), math.rad(50.00), math.rad(20.00)), alpha)
	  Neck.C0 = Neck.C0:Lerp(CFrame.new(0.00, 1.00, 0.00) * CFrame.Angles(math.rad(-100.00) + math.sin(x/45) * 0.15, math.rad(0.00), math.rad(-180.00)), alpha)
	  RootJoint.C0 = RootJoint.C0:Lerp(CFrame.new(0.00, 0.00 + math.sin(x/45) * 0.15, 0.00) * CFrame.Angles(math.rad(-90.00), math.rad(0.00), math.rad(-180.00)), alpha)
  end
 
end)



