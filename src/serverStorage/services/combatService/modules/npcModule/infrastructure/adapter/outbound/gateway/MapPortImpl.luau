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
	local fallbackCell = nil
	local fallbackDistance = math.huge
	
	for _, cell in ipairs(adjacents) do
		if mapAPI.isCellWalkable(cell, context) and not mapAPI.isCellReserved(cell, context) then
			local distance = math.sqrt(
				(cell.x - npcCell.x)^2 +
					(cell.y - npcCell.y)^2
			)

			-- Fallback: melhor célula walkable, mesmo que tenha parede entre ela
			-- e o alvo. Usado quando o alvo está cercado por paredes, para a unit
			-- ainda conseguir se mover até lá e resolver o blocker.
			if distance < fallbackDistance then
				fallbackDistance = distance
				fallbackCell = cell
			end

			-- Descarta células onde existe uma Wall (diferente do próprio alvo)
			-- entre a célula e o alvo. Isso garante que a unit se mova até uma
			-- posição de onde consiga atacar o alvo diretamente, sem precisar
			-- atacar um blocker. A parede que é o próprio alvo não é descartada.
			local hasWall, wallId = port.hasWallToward(cell, targetCell, context)
			if hasWall and wallId ~= targetUnitId then continue end

			if distance < bestDistance then
				bestDistance = distance
				bestCell = cell
			end
		end
	end

	return bestCell or fallbackCell
end

port.isCellWalkable = function(cell, context)
	return mapAPI.isCellWalkable(cell, context)
end

-- Detecta uma Wall (BORDER) bloqueando a transição entre cellA e cellB.
-- A barreira pode estar em duas posições:
--   * borda de cellA voltada para cellB (facing = direção do deslocamento)
--   * borda de cellB voltada para cellA (facing = direção oposta)
-- Convenção de facing: WEST=0, NORTH=1, EAST=2, SOUTH=3
port.hasWallOnBorder = function(cellA, cellB, context)
	local dx = cellB.x - cellA.x
	local dy = cellB.y - cellA.y

	local facingOut
	if dx == 1 then facingOut = 2       -- EAST
	elseif dx == -1 then facingOut = 0  -- WEST
	elseif dy == 1 then facingOut = 1   -- NORTH
	elseif dy == -1 then facingOut = 3  -- SOUTH
	else
		-- não é uma transição ortogonal entre células vizinhas
		return false, nil
	end

	local facingIn = (facingOut + 2) % 4

	local function findBorderWall(cell, facing)
		local unitsInCell = context.UnitsBC:getActiveUnitByCell(cell)
		for _, unit in pairs(unitsInCell) do
			if not unit:isDead()
				and unit:getStructureConfig()
				and unit:getStructureConfig():getBlockCellType() == "BORDER"
				and unit.currentFacing == facing then
				return true, unit:getId()
			end
		end

		return false, nil
	end

	local hasWall, wallId = findBorderWall(cellA, facingOut)
	if hasWall then
		return true, wallId
	end

	return findBorderWall(cellB, facingIn)
end

-- Verifica se existe uma Wall bloqueando o caminho de `cell` até `goal`,
-- percorrendo as bordas cruzadas passo a passo (eixo dominante por iteração).
-- Isso garante detecção mesmo em transições diagonais ou com múltiplas células de distância.
port.hasWallToward = function(cell, goal, context)
	local dx = goal.x - cell.x
	local dy = goal.y - cell.y

	if dx == 0 and dy == 0 then
		return false, nil
	end

	local curr = {x = cell.x, y = cell.y}

	while curr.x ~= goal.x or curr.y ~= goal.y do
		local remX = goal.x - curr.x
		local remY = goal.y - curr.y

		local next
		if math.abs(remX) >= math.abs(remY) then
			next = {x = curr.x + (remX > 0 and 1 or -1), y = curr.y}
		else
			next = {x = curr.x, y = curr.y + (remY > 0 and 1 or -1)}
		end

		local hasWall, wallId = port.hasWallOnBorder(curr, next, context)
		if hasWall then
			return true, wallId
		end

		curr = next
	end

	return false, nil
end

return module
