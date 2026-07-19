local module = {}

local rs = game:GetService("RunService")

local unitViewsRegistry = require(script.Parent.Parent.Parent.state.UnitViewRegistry)
local gameState = require(script.Parent.Parent.Parent.state.GameState)

rs.Heartbeat:Connect(function()
	local allViews = unitViewsRegistry.getAll()
	local ct = gameState.getCurrentTime()
	for _, v in pairs(allViews) do
		runMovementUpdate(v, ct)
	end
end)

function runMovementUpdate(view : typeof(unitViewsRegistry.get("")), ct)
	if not view.visual then return end
	if not view.visual.currentMovement then return end
	if view.visual.currentMovement:isFinished(ct) then return end
	local pos = view.visual.currentMovement:getPosition(ct)
	if not pos then return end
	
	view.model:PivotTo(CFrame.new(pos))
end

return module
