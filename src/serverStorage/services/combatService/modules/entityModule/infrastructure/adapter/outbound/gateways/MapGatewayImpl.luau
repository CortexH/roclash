local module = {}

local gateway = require(script.Parent.Parent.Parent.Parent.Parent.domain.ports.gateways.MapGatewayPort)
local mapAPI = game.ServerStorage.Server.services.combatService.API.mapModule

local mapModuleAPI = require(mapAPI.MapModuleAPI)

local position = require(script.Parent.Parent.Parent.Parent.Parent.domain.valueObjects.Position)

gateway.validateUnitPlacement = function(cell, context)
	return true
end

gateway.getPositionFromCell = function(cell) : typeof(mapModuleAPI.getWorldPositionByCell())
	local request : mapModuleAPI.cellType = cell
	local response : Vector2 = mapModuleAPI.getWorldPositionByCell(request)
	return position.new(response.X, response.Y)
end

gateway.getCellFromPosition = function(position)
	return mapModuleAPI.getCellByWorldPosition(position)
end

gateway.isPositionCenteredInCell = function(position, cell)
	local request : mapModuleAPI.cellType = cell
	local correctPos : typeof(mapModuleAPI.getWorldPositionByCell()) = mapModuleAPI.getWorldPositionByCell(request)
	return correctPos.X == position.X and correctPos.Y == position.Y
end

gateway.getNextAllowedCell = function(startCell : {x:number,y:number}, context)

	local directions = {
		{ x = 1,  y = 0 },  -- direita
		{ x = -1, y = 0 },  -- esquerda
		{ x = 0,  y = 1 },  -- cima
		{ x = 0,  y = -1 }, -- baixo

		{ x = 1,  y = 1 },  -- diagonal
		{ x = 1,  y = -1 },
		{ x = -1, y = 1 },
		{ x = -1, y = -1 },
	}

	local visited = {}
	local queue = {}

	local function cellKey(cell)
		return cell.x .. "," .. cell.y
	end

	table.insert(queue, startCell)
	visited[cellKey(startCell)] = true

	while #queue > 0 do
		local current = table.remove(queue, 1)

		local walkable = mapModuleAPI.isCellWalkable(current, context)
		local reserved = mapModuleAPI.isCellReserved(current, context)

		if walkable and not reserved then
			return current
		end

		for _, dir in ipairs(directions) do
			local nextCell = {
				x = current.x + dir.x,
				y = current.y + dir.y
			}

			local key = cellKey(nextCell)

			if not visited[key] then
				visited[key] = true
				table.insert(queue, nextCell)

			end
		end
	end

	return nil
end

gateway.getForwardCell = function(currentPos, startPos, goalPos)
	
	local function toGridStep(dir)
		return {
			x = (dir.X > 0 and 1) or (dir.X < 0 and -1) or 0,
			y = (dir.Y > 0 and 1) or (dir.Y < 0 and -1) or 0,
		}
	end
	
	local moveDir = currentPos:directionTo(goalPos)

	local currentCell = mapModuleAPI.getCellByWorldPosition(currentPos)
	
	local step = toGridStep(moveDir)

	local nextCell = {
		x = currentCell.x + step.x,
		y = currentCell.y + step.y
	}

	return nextCell
end

return module
