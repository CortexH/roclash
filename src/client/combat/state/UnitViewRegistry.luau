local module = {}

local factory = require(script.Parent.Parent.factory.UnitViewFactory)
local unitView = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.UnitView)

module.registry = {}

function module.create(def, state)
	if def.unitType == "STRUCTURE" then return factory.createStructure(def, state) end
	if def.unitType == "NPC" then return factory.createNpc(def, state) end
end

function module.getAll() : {unitView.unitView}
	return module.registry
end

function module.register(id, view) : unitView.unitView
	module.registry[id] = view
end

function module.unregister(id) : unitView.unitView
	module.registry[id] = nil
end

function module.get(id) : unitView.unitView
	return module.registry[id]
end

return module
