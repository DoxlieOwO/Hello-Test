-- [[MouseWrapV2 : for COLEO's xWrap]]

local Character = Owner.Character
local Event = Instance.new("UnreliableRemoteEvent")
Event.Name = "MouseWrapV2"
Event.Parent = Character

local LiveMouseData = {
    Position = Vector3.new(),
    Target = nil
}

Event.OnServerEvent:Connect(function(player, position, target)
    if player == Owner then
        print(position, target)
        LiveMouseData.Position = position or Vector3.new()
        LiveMouseData.Target = target
    end
end)

local LS = NLS([[
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
  
    local Character = Owner.Character
    local Event = Character:WaitForChild("MouseWrapV2")
    local RayDistance = 900

  
    RunService.RenderStepped:Connect(function() 
        local camera = workspace.CurrentCamera
        local mousePos = UserInputService:GetMouseLocation()
        local viewportMouseRay = camera:ViewportPointToRay(mousePos.X, mousePos.Y)

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {Character}

        local raycastRes = workspace:Raycast(viewportMouseRay.Origin, viewportMouseRay.Direction * RayDistance, params)
        local hitPosition
        local hitInstance = nil
    
        if raycastRes and typeof(raycastRes) ~= "number" then
            hitPosition = raycastRes.Position
            hitInstance = raycastRes.Instance
        else
            hitPosition = (viewportMouseRay.Origin + viewportMouseRay.Direction * RayDistance)
        end

        Event:FireServer(hitPosition, hitInstance)
      end)
]])

return {
    GetPosition = function()
        return LiveMouseData.Position
    end,
    GetTarget = function()
        return LiveMouseData.Target
    end,
    GetCFrame = function()
        return CFrame.new(LiveMouseData.Position)
    end
}
