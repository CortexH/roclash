local module = {}

function module.getCellByPosition(position : {x : number, y : number}, mapConsts) : {x : number, y : number}
	
	local originX, originY = mapConsts.consts.firstCornerPosition.x, mapConsts.consts.firstCornerPosition.y
	local cellSize = mapConsts.consts.cellSize

	local cellX = math.floor((position.x - originX) / cellSize)
	local cellY = math.floor((position.y - originY) / cellSize)
	
	return {x = cellX,y = cellY}
end

function module.getPositionByCell(cell : {x : number, y : number}, mapConsts) : Vector2

	local originX, originZ =  mapConsts.consts.firstCornerPosition.x, mapConsts.consts.firstCornerPosition.y
	local cellSize = mapConsts.consts.cellSize

	local centerX = originX + (cell.x * cellSize) + (cellSize / 2)
	local centerZ = originZ + (cell.y * cellSize) + (cellSize / 2)

	return Vector2.new(centerX, centerZ)
end

function module.getCellElevation(cell : {x : number, y : number})
	
end

function module.getMapBaseElevation()
	return 1
end

return module
