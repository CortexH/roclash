local module = {}

local position = require(script.Parent.Parent.valueObjects.Position)
local mapAPI = require(script.Parent.Parent.ports.gateways.MapGatewayPort)

--[[
	Casos de teste:
	CT01 - Validar iniciar com posição 'inicial' e 'final' fora do raio, intersectando a circunferência
	CT02 - Validar iniciar com posição 'inicial' e 'final' fora do raio, sem intersectar a circunferência
	CT03 - Validar iniciar com posição 'inicial' fora do raio e 'final' dentro do raio
	CT04 - Validar iniciar com posição 'inicial' dentro do raio e 'final' fora
	CT05 - Validar iniciar com posição 'inicial' dentro do raio e final dentro
	CT06 - Validar realizar 0 movimento
]]

local EPSILON = 1e-6
local epsilonGridRaycast = 1e-9

function module.getTimeInsideHitbox(
	firstPosition : position.position, 
	finalPosition : position.position, 
	circleCenter : position.position, 
	radius : number, 
	totalTime : number
)

	local d = finalPosition:sub(firstPosition)
	local a = d:dot(d)

	local r2 = radius * radius

	local fStart = firstPosition:sub(circleCenter)
	local fEnd   = finalPosition:sub(circleCenter)

	local startDistSq = fStart:dot(fStart)
	local endDistSq = fEnd:dot(fEnd)

	local startInside = startDistSq <= r2
	local endInside = endDistSq   <= r2

	if a < EPSILON then
		if startInside then
			return 0, totalTime
		else
			return nil
		end
	end

	if startInside and endInside then
		return 0, totalTime
	end

	local b = 2 * fStart:dot(d)
	local c = startDistSq - r2

	local discriminant = b*b - 4*a*c

	if discriminant < -EPSILON then
		return nil
	end

	discriminant = math.max(0, discriminant)
	local sqrtDisc = math.sqrt(discriminant)

	local t1 = (-b - sqrtDisc) / (2*a)
	local t2 = (-b + sqrtDisc) / (2*a)

	if t1 > t2 then
		t1, t2 = t2, t1
	end

	if t2 < 0 or t1 > 1 then
		return nil
	end

	t1 = math.max(0, t1)
	t2 = math.min(1, t2)
	
	if t1 > t2 then
		return nil
	end

	return t1 * totalTime, t2 * totalTime
end

function module.getTravelTime(
	from : position.position,
	to : position.position,
	movementRate : number
)
	assert(movementRate > 0, "movementRate must be greater than zero")

	local distance = from:distanceTo(to)

	return distance / movementRate
end

local function worldToCell(worldPos, cellSize: number)
	return {
		x = math.floor(worldPos.X / cellSize),
		y = math.floor(worldPos.Y / cellSize)
	}
end

local function cellToCenterWorld(cellPos, cellSize: number)
	return {
		x = (cellPos.X * cellSize) + (cellSize / 2),
		y = (cellPos.Y * cellSize) + (cellSize / 2)
	}
end

export type getCellFromTraverseGridType = {
	cell : {x : number, y : number},
	enteredFrom : string,
	leftFrom : string,
	tEntry : number,
	tExit : number
}

function module.getCellsFromTraverseGrid(startWorld, endWorld, cellSize) : {getCellFromTraverseGridType}
	local EPSILON = 1e-6

	-- 1. IDENTIFICAR CÉLULAS E SNAP PARA O CENTRO
	-- Isso resolve o problema de o ponto 61 ser "quase" o 60. 
	-- Ao traçar do centro pro centro, a matemática das diagonais fica perfeita.
	local startCell = worldToCell(startWorld, cellSize)
	local endCell = worldToCell(endWorld, cellSize)

	local startPos = position.new((startCell.x * cellSize) + (cellSize / 2), (startCell.y * cellSize) + (cellSize / 2))
	local endPos = position.new((endCell.x * cellSize) + (cellSize / 2), (endCell.y * cellSize) + (cellSize / 2))

	local result = {}

	local dx = endPos.X - startPos.X
	local dy = endPos.Y - startPos.Y

	local stepX = (dx > 0 and 1) or (dx < 0 and -1) or 0
	local stepY = (dy > 0 and 1) or (dy < 0 and -1) or 0

	local currentX = startCell.x
	local currentY = startCell.y

	local tMaxX, tMaxY
	local tDeltaX, tDeltaY

	if stepX ~= 0 then
		local nextBoundaryX = (stepX > 0) and ((currentX + 1) * cellSize) or (currentX * cellSize)
		tMaxX = (nextBoundaryX - startPos.X) / dx
		tDeltaX = cellSize / math.abs(dx)
	else
		tMaxX = math.huge
		tDeltaX = math.huge
	end

	if stepY ~= 0 then
		local nextBoundaryY = (stepY > 0) and ((currentY + 1) * cellSize) or (currentY * cellSize)
		tMaxY = (nextBoundaryY - startPos.Y) / dy
		tDeltaY = cellSize / math.abs(dy)
	else
		tMaxY = math.huge
		tDeltaY = math.huge
	end

	local tCurrent = 0
	local lastEnteredFrom = "START"

	-- Seguranca para evitar loops infinitos
	local maxSteps = math.abs(endCell.x - startCell.x) + math.abs(endCell.y - startCell.y) + 5
	local steps = 0

	while steps < maxSteps do
		steps += 1
		local tNext = math.min(tMaxX, tMaxY, 1)
		local leftFrom = "END"

		-- Detectar se estamos saindo por uma diagonal (Supercover)
		local isDiagonal = math.abs(tMaxX - tMaxY) < EPSILON and tNext < 1

		if tNext < 1 then
			if isDiagonal then
				leftFrom = "CORNER"
			elseif tMaxX < tMaxY then
				leftFrom = (stepX == 1) and "EAST" or "WEST"
			else
				leftFrom = (stepY == 1) and "NORTH" or "SOUTH"
			end
		end

		-- Adiciona a célula atual
		table.insert(result, {
			cell = { x = currentX, y = currentY },
			enteredFrom = lastEnteredFrom,
			leftFrom = leftFrom,
			tEntry = tCurrent,
			tExit = tNext
		})

		if tNext >= 1 or (currentX == endCell.x and currentY == endCell.y) then
			break
		end

		-- LÓGICA DE AVANÇO
		if isDiagonal then
			-- CASO ESPECIAL: Cruzando um vértice.
			-- Inserimos as duas células "laterais" que a linha apenas encosta na quina.
			-- Elas tecnicamente têm tEntry e tExit iguais (o ponto do vértice).

			-- Célula lateral X
			table.insert(result, {
				cell = { x = currentX + stepX, y = currentY },
				enteredFrom = (stepX == 1) and "WEST" or "EAST",
				leftFrom = (stepY == 1) and "NORTH" or "SOUTH",
				tEntry = tMaxX,
				tExit = tMaxX
			})

			-- Célula lateral Y
			table.insert(result, {
				cell = { x = currentX, y = currentY + stepY },
				enteredFrom = (stepY == 1) and "SOUTH" or "NORTH",
				leftFrom = (stepX == 1) and "EAST" or "WEST",
				tEntry = tMaxY,
				tExit = tMaxY
			})

			-- Move para a célula diagonal
			currentX += stepX
			currentY += stepY
			tMaxX += tDeltaX
			tMaxY += tDeltaY
			lastEnteredFrom = "CORNER"
		elseif tMaxX < tMaxY then
			currentX += stepX
			tMaxX += tDeltaX
			lastEnteredFrom = (stepX == 1) and "WEST" or "EAST"
		else
			currentY += stepY
			tMaxY += tDeltaY
			lastEnteredFrom = (stepY == 1) and "SOUTH" or "NORTH"
		end

		tCurrent = tNext
	end

	return result
end

function module.vectorUntilRange(currentPosition, targetPosition, range : number)
	local distance = currentPosition:distanceTo(targetPosition)
	
	if distance <= range then
		return currentPosition
	end

	local direction = currentPosition:directionTo(targetPosition)

	local stopPosition = targetPosition:sub(direction:mul(range))

	return stopPosition
end

function getConvertedCellSize(num, cellsize)
	return (num * cellsize) + (cellsize / 2)
end

function convertToCell(x,y)
	return {x = x, y = y}
end

return module
