local module = {}

module.__index = module

local targeting = require(script.Parent.BrainAgg.Targeting)
local aggro = require(script.Parent.BrainAgg.Aggro)

function module.new()
	local self = setmetatable({}, module)
	
	self.targeting = nil
	self.aggro = nil
	
	return self
end

function module:getTargeting() : targeting.Targeting
	return self.targeting
end

function module:getAggro() : aggro.Aggro
	return self.aggro
end

function module:initTargeting(maxTargets)
	self.targeting = targeting.new(maxTargets)
end

function module:initAggro()
	self.aggro = aggro.new()
end

-- serve para apgar toda a memoria do npc quando ele morre.
function module:clear()
	
end

export type Brain = typeof(module.new())

return module
