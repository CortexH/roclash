local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local port = require(domain.ports.NpcBrainPort)

port.getNpcBrain = function(unitId, context)
	return context["NpcsBC"]:getBrain(unitId)
end

port.saveBrain = function(unitId, brain, context)
	context["NpcsBC"]:addBrain(unitId, brain)
end

port.getAllNpcBrains = function(context)
	return context["NpcsBC"]:getAllBrainsList()
end

port.getAllNpcsBrainsWithId = function(context)
	return context["NpcsBC"]:getAllBrains()
end

return module
