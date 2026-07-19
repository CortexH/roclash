local module = {}

local constsPort = require(script.Parent.Parent.Parent.domain.ports.ConstsDataPort)

function module.getPositionByCell(cell : {x : number, y : number}) : Vector3
	
	local originX, originZ = constsPort.getFirstCornerPosition()
	local cellSize = constsPort.getCellSize()

	local centerX = originX + (cell.x * cellSize) + (cellSize / 2)
	local centerZ = originZ + (cell.y * cellSize) + (cellSize / 2)
	
	return Vector2.new(centerX, centerZ)
end

function module.getCellByPosition(position : {x : number, y : number}) : {x : number, y : number}
	
	local originX, originZ = constsPort.getFirstCornerPosition()
	local cellSize = constsPort.getCellSize()

	local cellX = math.floor((position.x - originX) / cellSize)
	local cellY = math.floor((position.y - originZ) / cellSize)

	return {x = cellX,y = cellY}
end

function module.getCellElevationInStuds(cell : {x : number, y : number})
	return 1
end

function module.getRotationByNumber(number : number)
	return number * 90
end

return module
