local module = {}

module.__index = module

export type attackedBy = typeof(module.new())

function module.new()
	local self = setmetatable({}, module)

	self.beingAttackedBy = {}
	self.beingAggroedBy = {}

	return self
end

function module:addAttacker(attackerId)
	table.insert(self.beingAttackedBy, attackerId)
end

function module:getAttackers()
	return table.clone(self.beingAttackedBy)
end

function module:removeAttacker(attackerId)
	
	for i, id in self.beingAttackedBy do
		if id == attackerId then
			table.remove(self.beingAttackedBy, i)
			return
		end
	end
	
end


function module:addAggro(aggroId)
	table.insert(self.beingAggroedBy, aggroId)
end

function module:getAggros()
	return table.clone(self.beingAggroedBy)
end

function module:removeAggro(aggroId)
	for i, id in self.beingAggroedBy do
		if id == aggroId then
			table.remove(self.beingAggroedBy, i)
			return
		end
	end
end

return module
