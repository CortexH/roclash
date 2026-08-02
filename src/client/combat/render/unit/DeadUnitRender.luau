local module = {}

local rs = game:GetService("RunService")

local deadUnitRegistry = require(script.Parent.Parent.Parent.state.DeadUnitRegistry)
local gameState = require(script.Parent.Parent.Parent.state.GameState)

local unitLifecycleRender = require(script.Parent.UnitLifecycleRender)

-- Remove de fato as units mortas após o delay determinístico, baseado em currentTime.
rs.Heartbeat:Connect(function()
	local ct = gameState.getCurrentTime()
	for unitId, dead in pairs(deadUnitRegistry.getAll()) do
		if ct - dead.deathTime >= dead.duration then
			deadUnitRegistry.unregister(unitId)
			unitLifecycleRender.despawn(unitId)
		end
	end
end)

return module
