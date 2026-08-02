local module = {}

local factory = require(script.Parent.Parent.Parent.factory.UnitViewFactory)
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

function module.getByInstance(item) : unitView.unitView
	if not item then return nil end
	
	local model = item:IsA("Model") and item or item:FindFirstAncestorOfClass("Model")
	
	if not model then return nil end
		
	local config = model:FindFirstChild("Configuration")

	local uniqueId = config and config:FindFirstChild("uniqueId")
		
	if not uniqueId then return nil end

	return module.get(uniqueId.Value)
end

return module
