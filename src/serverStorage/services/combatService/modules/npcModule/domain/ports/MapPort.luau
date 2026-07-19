local module = {
	getNearestPossibleCell = function(npcUnitId, targetUnitId, context) : {x: number, y: number}? end,
	hasWallOnBorder = function(cellA, cellB, context) : (boolean, string) end,
	isCellWalkable = function(cell, context) : boolean end,
}

return module
