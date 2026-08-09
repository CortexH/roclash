local module = {}

-- IMPLEMENTS_MapModuleAPI

local api = require(game.ServerStorage.Server.services.combatService.API.mapModule.MapModuleAPI)
local cellService = require(game.ServerStorage.Server.services.combatService.modules.mapModule.application.services.CellService)
local positionService = require(script.Parent.Parent.Parent.Parent.Parent.application.services.PositionService)
local constsPort = require(script.Parent.Parent.Parent.Parent.Parent.domain.ports.ConstsDataPort)

-- Verifica se a célula está dentro dos limites do campo de batalha.
-- Usa o mapa atual (ConstsBC.mapConsts, populado por mapa) quando disponível;
-- caso contrário, recorre às consts globais.
local function isCellInBattleField(cell, context)
	local first, last

	local mapConsts = context and context["ConstsBC"] and context["ConstsBC"].mapConsts
	if mapConsts and mapConsts.firstCornerPosition and mapConsts.lastCornerPosition then
		first = mapConsts.firstCornerPosition
		last = mapConsts.lastCornerPosition
	else
		local firstX, firstZ = constsPort.getFirstCornerPosition()
		local lastX, lastZ = constsPort.getLastCornerPosition()
		first = {x = firstX, y = firstZ}
		last = {x = lastX, y = lastZ}
	end

	local pos = positionService.getPositionByCell(cell)

	local minX = math.min(first.x, last.x)
	local maxX = math.max(first.x, last.x)
	local minY = math.min(first.y, last.y)
	local maxY = math.max(first.y, last.y)

	return pos.X >= minX and pos.X <= maxX and pos.Y >= minY and pos.Y <= maxY
end

api.isCellInBattleField = isCellInBattleField

-- PERFORMANCE: solução temporária, refazer mais tarde
api.isCellWalkable = function(cell, context)
	-- Células fora do campo de batalha não são walkable.
	if not isCellInBattleField(cell, context) then return false end

	local unitsInCell = context["UnitsBC"]:getActiveUnitByCell(cell)
    for _, unit in pairs(unitsInCell) do
		if unit:isDead() then continue end
        local blockType = unit:getStructureConfig() and unit:getStructureConfig():getBlockCellType()
        if
        blockType == "ENTIRE_CELL"
        or blockType == "ONLY_CENTER"
        then
            return false
        end
    end
    return true
end

api.reserveCell = function(cell, context)
	cellService.reserveCell(cell, context)
end

api.unreserveCell = function(cell, context)
	cellService.unreserveCell(cell, context)
end

api.isCellReserved = function(cell, context)
	return cellService.isCellReserved(cell, context)
end

api.getCellByWorldPosition = function(req)
	return positionService.getCellByPosition({x = req.X, y = req.Y})
end

api.getWorldPositionByCell = function(request)
	return positionService.getPositionByCell({x = request.x, y = request.y})
end

return module
