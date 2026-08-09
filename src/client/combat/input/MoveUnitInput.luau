local module = {}

local interactionState = require(script.Parent.Parent.state.InteractionState)
local eventsAPI = require(script.Parent.Parent.network.CommandSender)
local PointingService = require(script.Parent.Parent.service.PointingService)
local selectionManager = require(script.Parent.Parent.managers.SelecionManager)
local mapUtils = require(script.Parent.Parent.utils.MapUtils)
local mapConsts = require(script.Parent.Parent.consts.MapConsts)
local cellHighlight = require(script.Parent.Parent.render.CellHighlightRender)
local pathPreview = require(script.Parent.Parent.render.PathPreviewRender)
local unitStateCache = require(script.Parent.Parent.state.cache.UnitStateCache)
local unitCellMonitor = require(script.Parent.Parent.service.UnitCellMonitor)
local signatures = require(script.Parent.Parent.consts.SelectSignatures)

local pointingServiceInstance
local currentGoalCell = nil
local currentUnitId = nil

local function getUnitCurrentCell(unitId : string) : {x : number, y : number}?
	local state = unitStateCache.get(unitId)
	if state and state.placed and state.placed.cell then
		return state.placed.cell
	end
	return nil
end

-- Verifica se a célula está dentro dos limites do campo de batalha.
-- Se os limites do mapa ainda não foram carregados, bloqueia (não envia a Query),
-- evitando goals infinitos que travam o pathfinding no backend.
local function isCellInBounds(cell : {x : number, y : number}) : boolean
	local first = mapConsts.consts.firstCornerPosition
	local last = mapConsts.consts.lastCornerPosition
	if not first or not last then return false end

	local pos = mapUtils.getPositionByCell(cell)

	local minX = math.min(first.x, last.x)
	local maxX = math.max(first.x, last.x)
	local minY = math.min(first.y, last.y)
	local maxY = math.max(first.y, last.y)

	return pos.X >= minX and pos.X <= maxX and pos.Y >= minY and pos.Y <= maxY
end

local function requestPathPreview(unitId : string, goal : {x : number, y : number})
	local start = unitCellMonitor.getCurrentCell(unitId) or getUnitCurrentCell(unitId)
	if not start then return end

	eventsAPI.sendCommand({
		type = "PATHFIND_UNIT",
		target = "UNIT",
		signature = "UNIT_MOVE_PREVIEW",
		unitId = unitId,
		start = start,
		goal = goal
	})
end

-- Recalcula o preview usando a célula atual da unit como origem.
local function refreshPathPreview()
	if not currentUnitId or not currentGoalCell then return end
	if not isCellInBounds(currentGoalCell) then
		pathPreview.hide()
		return
	end
	requestPathPreview(currentUnitId, currentGoalCell)
end

function module.beginSelect(selectedUnitId)
	if not selectedUnitId then return end

	if pointingServiceInstance then
		pointingServiceInstance:stop()
	end
	selectionManager.clearInteraction()

	currentUnitId = selectedUnitId
	currentGoalCell = nil

	local configs: PointingService.lambdaConfigs = {
		onClick = function(cell)
			module.selectCell(cell, selectedUnitId)
		end,
		onHoverStart = function(cell)
			currentGoalCell = cell
			cellHighlight.showAtCell(cell)
			if isCellInBounds(cell) then
				requestPathPreview(selectedUnitId, cell)
			else
				pathPreview.hide()
			end
		end,
		onHoverEnd = function()
			currentGoalCell = nil
			cellHighlight.hide()
			pathPreview.hide()
		end,
	}

	pointingServiceInstance = PointingService.new("CELL", configs, signatures.UNIT_MOVE_SELECT)
	selectionManager.setInteraction(pointingServiceInstance)

	-- Recalcula o preview quando a unit troca de célula durante a interação.
	unitCellMonitor.monitor(selectedUnitId, function()
		-- Se a interação de mover não é mais a ativa (ex.: trocou para ATACAR/seleção),
		-- encerra apenas o monitoramento e o estado local do mover, sem limpar a
		-- interação atual (que pode ser outra, ex.: ataque).
		local current = selectionManager.getCurrentInteraction()
		if not current or current:getId() ~= signatures.UNIT_MOVE_SELECT then
			unitCellMonitor.unmonitor(selectedUnitId)
			currentUnitId = nil
			currentGoalCell = nil
			return
		end
		refreshPathPreview()
	end)
end

function module.stopSelect()
	selectionManager.clearInteraction()
	cellHighlight.hide()
	pathPreview.hide()

	if currentUnitId then
		unitCellMonitor.unmonitor(currentUnitId)
	end

	currentUnitId = nil
	currentGoalCell = nil
end

-- Encerra a interação de mover se a unit informada é a unit em interação.
-- Usado quando a unit morre, para parar de disparar UnitPathfindingQuery.
function module.stopIfUnit(unitId : string)
	if currentUnitId == unitId then
		module.stopSelect()
	end
end

function module.selectCell(cell : {x : number, y : number}, selectedUnitId : string)
	eventsAPI.sendCommand({
		type = "MOVE_UNIT",
		target = "UNIT",
		targetCell = cell,
		unitId = selectedUnitId
	})
end

return module
