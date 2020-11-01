local uis = game:GetService("UserInputService")
local maxRayDistance = 1000

--[[
* Fetches the normal vector from a raycast
* to the mouse from the mouse's screen position
* @param {number} x The mouse X position
* @param {number} y The Mouse Y position
* @returns {Vector3|nil} Returns a Vector3 or nil if no normal
]]
local function getRayCollisionNormal(x,y)
	local cam = workspace.CurrentCamera
	local unitRay = cam:ScreenPointToRay(x,y)
	local rayResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * maxRayDistance)
	if (rayResult) then
		local instance = rayResult.Instance
		local normal = rayResult.Normal

		-- Get an object-space normal for rotated instance
		if (instance) then
			normal = instance.CFrame:VectorToObjectSpace(normal)
		end

		return normal or nil;
	end
end

uis.InputChanged:Connect(function(io)
	if (io.UserInputType == Enum.UserInputType.MouseMovement) then
		local hitNormal = getRayCollisionNormal(io.Position.X, io.Position.Y)
		local surface = nil;

		if (hitNormal) then
			local dotY = hitNormal:Dot(Vector3.new(0,1,0))
			local dotX = hitNormal:Dot(Vector3.new(1,0,0))
			local dotZ = hitNormal:Dot(Vector3.new(0,0,1))
			if (math.abs(dotY) >= 0.9) then
				if (dotY < 0) then
					surface = Enum.NormalId.Bottom
				else
					surface = Enum.NormalId.Top
				end
			elseif (math.abs(dotX) >= 0.9) then
				if (dotX < 0) then
					surface = Enum.NormalId.Left
				else
					surface = Enum.NormalId.Right
				end
			else
				if (dotZ < 0) then
					surface = Enum.NormalId.Front
				else
					surface = Enum.NormalId.Back
				end
			end
		end

		-- surface variable holds either nil or the NormalId enum of the mouse's hit surface
		print(surface)
	end
end)
