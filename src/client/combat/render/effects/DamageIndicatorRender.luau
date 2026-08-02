local module = {}

local rs = game:GetService("RunService")

local damageIndicatorRegistry = require(script.Parent.Parent.Parent.state.DamageIndicatorRegistry)
local unitViewRegistry = require(script.Parent.Parent.Parent.state.UnitViewRegistry)
local gameState = require(script.Parent.Parent.Parent.state.GameState)

local damageIndicator = require(script.Parent.Parent.Parent.ui.components.DamageIndicator)

rs.Heartbeat:Connect(function()
	local all = damageIndicatorRegistry.getAll()
	local ct = gameState.getCurrentTime()
	for id, indicator in pairs(all) do
		runUpdate(id, indicator, ct)
	end
end)

function module.spawn(id : string)
	local indicator = damageIndicatorRegistry.get(id)
	if not indicator then return end

	local unitView = unitViewRegistry.get(indicator.unitId)
	if not unitView then return end

	local component = damageIndicator.new(indicator.amount)
	component:attach(unitView.model)
	indicator.component = component
end

function runUpdate(id : string, indicator, ct)
	local elapsed = ct - indicator.startTime
	local t = math.clamp(elapsed / indicator.duration, 0, 1)

	if t >= 1 then
		damageIndicatorRegistry.unregister(id)
		if indicator.component then
			indicator.component:destroy()
		end
		return
	end

	if indicator.component then
		indicator.component:update(t)
	end
end

return module
