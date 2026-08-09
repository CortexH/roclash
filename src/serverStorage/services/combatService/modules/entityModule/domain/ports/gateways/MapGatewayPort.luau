local module = {
	getPositionFromCell = function(cell : {x : number, y : number}) end,
	getCellFromPosition = function(position) end,
	getCellSize = function() return 4 end,
	validateAreaDominated = function(cell : {x:number, y:number}) return true end,
	isPositionValid = function(position) return true end,
	isCellValid = function(cell : {x:number, y:number}, context : {}) return true end,
	isCellBelongToPlayer = function(cell : {x:number, y:number}, player : Player) return true end,
	isPositionCenteredInCell = function(position : {X:number, Y:number}, cell : {x:number,y:number}) end,
	getNextAllowedCell = function(currentCell : {x:number, y:number}, context) end,
	getForwardCell = function(startPos, currentPos, finalMovementPos) end
}

return module
