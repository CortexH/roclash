local module = {}

local rs = game:GetService("RunService")

local lifecycleRender = require(script.Parent.ProjectileLifecycleRender)

local viewRegistry = require(script.Parent.Parent.Parent.state.ProjectileViewRegistry)
local gameState = require(script.Parent.Parent.Parent.state.GameState)

rs.Heartbeat:Connect(function()
	local allViews = viewRegistry.getAll()
	local ct = gameState.getCurrentTime()
	for _, v in pairs(allViews) do
		runMovementUpdate(v, ct)
	end
end)

function runMovementUpdate(view : typeof(viewRegistry.get("")), ct)
	if not view.visual then return end
	if not view.visual.movement then return end
	if view.visual.movement:isFinished(ct) then
		lifecycleRender.despawn(view.registryId)
		return 
	end
	local pos = view.visual.movement:getPosition(ct)
	if not pos then return end
	view.model:PivotTo(CFrame.new(pos))
	
end

return module
