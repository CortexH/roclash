local module = {}

local port = require(script.Parent.Parent.Parent.Parent.Parent.domain.ports.MapPort)

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local aggroService = require(domain.service.AggroService)
local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

local mapAPI = require(game.ServerStorage.Server.services.combatService.API.mapModule.MapModuleAPI)

port.getNearestPossibleCell = function(npcUnitId, targetUnitId, context)
	local npcView = viewPort.getSelfBattleView(npcUnitId, context)
	local targetView = viewPort.getSelfBattleView(targetUnitId, context)

	if not npcView or not targetView then return nil end

	local targetCell = targetView.currentCell
	local npcCell = npcView.currentCell

	local adjacents = {
		{x = targetCell.x - 1, y = targetCell.y + 1},
		{x = targetCell.x,     y = targetCell.y + 1},
		{x = targetCell.x + 1, y = targetCell.y + 1},
		{x = targetCell.x - 1, y = targetCell.y    },
		{x = targetCell.x + 1, y = targetCell.y    },
		{x = targetCell.x - 1, y = targetCell.y - 1},
		{x = targetCell.x,     y = targetCell.y - 1},
		{x = targetCell.x + 1, y = targetCell.y - 1},
	}

	local bestCell = nil
	local bestDistance = math.huge
	
	for _, cell in ipairs(adjacents) do
		if mapAPI.isCellWalkable(cell, context) and not mapAPI.isCellReserved(cell, context) then
			local distance = math.sqrt(
				(cell.x - npcCell.x)^2 + 
					(cell.y - npcCell.y)^2
			)
			if distance < bestDistance then
				bestDistance = distance
				bestCell = cell
			end
		end
	end

	return bestCell
end

port.isCellWalkable = function(cell, context)
	return mapAPI.isCellWalkable(cell, context)
end

-- TODO: ajustar caso onde celulas adjacentes perpendiculares retornam nil
port.hasWallOnBorder = function(cellA, cellB, context)
	local dx = cellB.x - cellA.x
	local dy = cellB.y - cellA.y

	local borderFacing
	if dx == 1 then borderFacing = 2
	elseif dx == -1 then borderFacing = 0
	elseif dy == 1 then borderFacing = 1
	elseif dy == -1 then borderFacing = 3
	end

	local unitsInCell = context.UnitsBC:getActiveUnitByCell(cellA)
	for _, unit in pairs(unitsInCell) do
		if unit:getStructureConfig() and 
			unit:getStructureConfig():getBlockCellType() == "BORDER" then
			if unit:getFacing() == borderFacing then
				return true, unit:getId()
			end
		end
	end

	return false, nil
end

return module
