local module = {}

export type AStarRequest = {
	unitId: string,          -- quem está se movendo
	fromCell: {x: number, y: number},  -- célula atual do NPC
	toCell: {x: number, y: number},    -- célula do alvo de aggro
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

local mapPort = require(script.Parent.Parent.ports.MapPort)

function module.AStarPathRequest(request : AStarRequest, context) : AStarResult
	local fromCell = request.fromCell
	local toCell = request.toCell

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

			-- verifica blocker no último segmento
			if #segments > 0 then
				local last = segments[#segments]
				local hasWall, wallId = mapPort.hasWallOnBorder(last.fromCell, last.toCell, context)

				if hasWall then
					last.blocker = wallId
				end
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

	return {
		path = segments,
		reachable = false
	}
end

return module
