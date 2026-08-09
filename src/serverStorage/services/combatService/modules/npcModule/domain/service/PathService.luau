local module = {}

export type AStarRequest = {
	unitId: string,          -- quem está se movendo
	fromCell: {x: number, y: number},  -- célula atual do NPC
	toCell: {x: number, y: number},    -- célula do alvo de aggro
	toTargetCell: {x: number, y: number}?,  -- célula real do alvo (ex: Tower)
}

export type AStarSegment = {
	fromCell: {x: number, y: number},
	toCell: {x: number, y: number},
	blocker: string?  -- structureId, só no último segmento se houver
}

export type AStarResult = {
	path: {AStarSegment},
	reachable: boolean
}

export type AStarResultWithBlockers = {
	path: {AStarSegment},
	reachable: boolean,
	blockers: {string}
}

local mapPort = require(script.Parent.Parent.ports.MapPort)

function module.AStarPathRequest(request : AStarRequest, context) : AStarResult
	local fromCell = request.fromCell
	local toCell = request.toCell
	local toTargetCell = request.toTargetCell

	local openList = {}
	local closedList = {}
	local cameFrom = {}

	local gScore = {}
	local fScore = {}

	local function cellKey(cell)
		return cell.x .. "," .. cell.y
	end

	local function heuristic(a, b)
		return math.abs(a.x - b.x) + math.abs(a.y - b.y)
	end

	local function getNeighbors(cell)
		return {
			{x = cell.x,     y = cell.y + 1},
			{x = cell.x,     y = cell.y - 1},
			{x = cell.x + 1, y = cell.y    },
			{x = cell.x - 1, y = cell.y    },
		}
	end

	local function getDirection(a, b)
		return {
			x = b.x - a.x,
			y = b.y - a.y
		}
	end

	local function sameDirection(d1, d2)
		return d1.x == d2.x and d1.y == d2.y
	end

	-- Descobre a Wall (BORDER) que bloqueia o caminho de `cell` em direção ao `goal`.
	-- Percorre as bordas cruzadas até o alvo, cobrindo transições ortogonais e diagonais.
	local function findBlockerToward(cell, goal)
		return mapPort.hasWallToward(cell, goal, context)
	end

	local function reconstructRawPath(endCell)
		local rawPath = {}
		local curr = endCell

		table.insert(rawPath, 1, curr)

		while cameFrom[cellKey(curr)] do
			curr = cameFrom[cellKey(curr)]
			table.insert(rawPath, 1, curr)
		end

		return rawPath
	end

	local function compressPath(rawPath)
		if #rawPath < 2 then return {} end

		local segments = {}

		local segmentStart = rawPath[1]
		local lastDir = getDirection(rawPath[1], rawPath[2])

		for i = 2, #rawPath do
			local curr = rawPath[i]
			local prev = rawPath[i - 1]

			local dir = getDirection(prev, curr)

			if not sameDirection(dir, lastDir) then
				table.insert(segments, {
					fromCell = segmentStart,
					toCell = prev,
					blocker = nil
				})

				segmentStart = prev
				lastDir = dir
			end
		end

		table.insert(segments, {
			fromCell = segmentStart,
			toCell = rawPath[#rawPath],
			blocker = nil
		})

		return segments
	end

	local function applyBlockerToLastSegment(segments, goalCell)
		if #segments == 0 then return end

		local last = segments[#segments]
		local hasWall, wallId = findBlockerToward(last.toCell, goalCell)

		if hasWall then
			last.blocker = wallId
		end
	end

	local startKey = cellKey(fromCell)
	local goalKey = cellKey(toCell)

	gScore[startKey] = 0
	fScore[startKey] = heuristic(fromCell, toCell)

	table.insert(openList, {cell = fromCell, f = fScore[startKey]})

	while #openList > 0 do
		table.sort(openList, function(a, b) return a.f < b.f end)

		local current = table.remove(openList, 1)
		local currentCell = current.cell
		local currentKey = cellKey(currentCell)

		if currentKey == goalKey then
			local rawPath = reconstructRawPath(currentCell)
			local segments = compressPath(rawPath)

			-- Wall além do goal só é relevante quando existe um alvo real (ex: Tower)
			if toTargetCell then
				applyBlockerToLastSegment(segments, toTargetCell)
			end

			return {
				path = segments,
				reachable = true
			}
		end

		closedList[currentKey] = currentCell

		for _, neighbor in ipairs(getNeighbors(currentCell)) do
			local neighborKey = cellKey(neighbor)

			if not closedList[neighborKey] and mapPort.isCellWalkable(neighbor, context) then
				-- não atravessa bordas bloqueadas por Walls (BORDER)
				local hasWall = mapPort.hasWallOnBorder(currentCell, neighbor, context)
				if hasWall then
					continue
				end

				local tentativeG = gScore[currentKey] + 1

				if not gScore[neighborKey] or tentativeG < gScore[neighborKey] then
					cameFrom[neighborKey] = currentCell
					gScore[neighborKey] = tentativeG
					fScore[neighborKey] = tentativeG + heuristic(neighbor, toCell)

					table.insert(openList, {
						cell = neighbor,
						f = fScore[neighborKey]
					})
				end
			end
		end
	end

	-- 🟥 fallback (caminho parcial)

	local bestCell = nil
	local bestDistance = math.huge

	for _, cell in pairs(closedList) do
		local distance = heuristic(cell, toCell)

		if distance < bestDistance then
			bestDistance = distance
			bestCell = cell
		end
	end

	if not bestCell then
		return {
			path = {},
			reachable = false
		}
	end

	local rawPath = reconstructRawPath(bestCell)
	local segments = compressPath(rawPath)

	-- Se não foi possível gerar segmentos (ex: unit já está colada no obstáculo),
	-- ainda assim identifica o blocker na direção do alvo.
	if #segments == 0 then
		local hasWall, wallId = mapPort.hasWallToward(bestCell, toTargetCell or toCell, context)
		if hasWall then
			segments = {
				{
					fromCell = bestCell,
					toCell = bestCell,
					blocker = wallId
				}
			}
		end
	else
		-- blocker no último segmento: wall que impede o avanço em direção ao alvo
		applyBlockerToLastSegment(segments, toTargetCell or toCell)
	end

	return {
		path = segments,
		reachable = false
	}
end

-- Pathfinding recursivo: continua o caminho a partir de cada blocker
-- (simulando a destruição da wall/estrutura), acumulando os segmentos e
-- retornando a lista de blockers encontrados no caminho.
-- Usado no preview de path (movimento e ataque) para mostrar o caminho completo.
function module.AStarPathRequestWithBlockers(request : AStarRequest, context) : AStarResultWithBlockers
	local allSegments = {}
	local blockers = {}
	local fromCell = request.fromCell
	local goal = request.toCell
	local toTargetCell = request.toTargetCell
	local maxIterations = 5

	for _ = 1, maxIterations do
		local result = module.AStarPathRequest({
			unitId = request.unitId,
			fromCell = fromCell,
			toCell = goal,
			toTargetCell = toTargetCell,
		}, context)

		if result == nil then
			return { path = allSegments, reachable = false, blockers = blockers }
		end

		for _, seg in ipairs(result.path) do
			table.insert(allSegments, seg)
		end

		local last = result.path[#result.path]
		local blockerId = last and last.blocker

		if not blockerId then
			return { path = allSegments, reachable = result.reachable, blockers = blockers }
		end

		table.insert(blockers, blockerId)

		local blockerUnit = context["UnitsBC"]:getActiveUnitById(blockerId)
		if not blockerUnit then
			return { path = allSegments, reachable = false, blockers = blockers }
		end

		fromCell = blockerUnit.currentCell
	end

	return { path = allSegments, reachable = false, blockers = blockers }
end

return module
