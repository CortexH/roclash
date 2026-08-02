local module = {}

local factory = require(script.Parent.Parent.Parent.factory.ProjectileViewFactory)
local projectileView = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.ProjectileView)

module.registry = {}

function module.create(
	relatedUnitId,
	projectileType,
	movementId,
	id
)	 : projectileView.projectileView
	return factory.create(relatedUnitId, projectileType, movementId, id)
end

function module.getAll() : {projectileView.projectileView}
	return module.registry
end

function module.register(id, unitView)
	module.registry[id] = unitView
end

function module.unregister(id)
	module.registry[id] = nil
end

function module.get(id) : projectileView.projectileView
	return module.registry[id]
end



return module
