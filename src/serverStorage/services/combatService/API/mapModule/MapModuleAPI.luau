export type cellType = {x : number, y : number}

local module = {
	validateMapPosition = function() end,
	validateDominatedRegion = function() end,
	getWorldPositionByCell = function() : Vector2 end,
	getEntitiesInRadius = function() end,
	getCellByWorldPosition = function() end,
	
	reserveCell = function(cell : cellType, context : {}) return end,
	unreserveCell = function(cell : cellType, context : {}) return end,

	isCellWalkable = function(cell : cellType, context : {}) end,
	isCellReserved = function(cell : cellType, context : {}) return end,
	isCellInBattleField = function(cell : cellType, context : {}) return true end,
}

return module
