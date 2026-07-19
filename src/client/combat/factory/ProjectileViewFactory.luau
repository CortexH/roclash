local module = {}

local modelUtils = require(game.ReplicatedStorage.Shared.combat.shared.utils.ModelsUtils)
local projectileViewType = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.ProjectileView)

function module.create(
	relatedUnitId,
	projectileType,
	movementId,
	uniqueId
)
	
	local projectile = modelUtils.getProjectileModelById(projectileType)
	
	projectile.Configuration.relatedUnitId.Value = relatedUnitId
	
	local item : projectileViewType.projectileView = {
		registryId = uniqueId,
		relatedUnitId = relatedUnitId,
		projectileType = projectileType,
		movementId = movementId,
		
		model = projectile,
		
		visual = {}
	}
	
	return item
end

return module
