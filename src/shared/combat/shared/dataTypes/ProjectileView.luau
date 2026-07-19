local module = {}

local movement = require(script.Parent.Parent.entity.UnitClientProjectileMovement)

export type projectileView = {
	registryId : string,
	relatedUnitId : string,
	projectileType : string,
	movementId : number,
	
	model : Model,
	
	visual : {
		movement : movement.projectileMovement
	}
	
}

return module
