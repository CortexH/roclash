local module = {}

local interactionState = require(script.Parent.Parent.state.InteractionState)
local eventsAPI = require(script.Parent.Parent.network.CommandSender)
local PointingService = require(script.Parent.Parent.service.PointingService)
local selectionManager = require(script.Parent.Parent.managers.SelecionManager)
local eventQueue = require(script.Parent.Parent.network.EnqueueEvent)
local signatures = require(script.Parent.Parent.consts.SelectSignatures)
local unitCellMonitor = require(script.Parent.Parent.service.UnitCellMonitor)
local unitStateCache = require(script.Parent.Parent.state.cache.UnitStateCache)
local pathPreview = require(script.Parent.Parent.render.PathPreviewRender)
local selectInput = require(script.Parent.Parent.input.SelectUnitInput)
local uiState = require(script.Parent.Parent.state.UIState)

local pointingServiceInstance
local currentSelectedUnitId = nil

-- Emite o evento de hover/unhover da unit para os listeners (ex.: highlight).
local function emitHover(unitId : string, hovering : boolean)
	eventQueue.enqueueEvent({
		delay = 0,
		eventType = "UnitHoverClient",
		data = {
			unitId = unitId,
			hovering = hovering,
			signature = signatures.UNIT_ATTACK_SELECT
		}
	})
end

local function getUnitCurrentCell(unitId : string) : {x : number, y : number}?
	local state = unitStateCache.get(unitId)
	if state and state.placed and state.placed.cell then
		return state.placed.cell
	end
	return nil
end

-- Solicita ao backend o preview do caminho da unit selecionada até a unit alvo.
local function requestPathToUnit(targetUnitId : string)
	if not currentSelectedUnitId then return end

	local start = unitCellMonitor.getCurrentCell(currentSelectedUnitId) or getUnitCurrentCell(currentSelectedUnitId)
	if not start then return end

	eventsAPI.sendCommand({
		type = "PATHFIND_UNIT",
		target = "UNIT",
		signature = "UNIT_ATTACK_PREVIEW",
		unitId = currentSelectedUnitId,
		start = start,
		goalUnitId = targetUnitId
	})
end

function module.beginSelect(selectedUnitId)
    currentSelectedUnitId = selectedUnitId

    if pointingServiceInstance then
        pointingServiceInstance:stop()
    end
    selectionManager.clearInteraction()

    local configs: PointingService.lambdaConfigs = {
        onClick = function(view, unitId)
            module.selectUnit(unitId, selectedUnitId)
        end,
        onHoverStart = function(view, unitId)
            emitHover(unitId, true)
            requestPathToUnit(unitId)
            interactionState.clientState.selection.currentHoveredUnit = unitId
        end,
        onHoverEnd = function(view, unitId)
            emitHover(unitId, false)
            pathPreview.hide()
            if interactionState.clientState.selection.currentHoveredUnit == unitId then
                interactionState.clientState.selection.currentHoveredUnit = nil
            end
        end,
    }

    pointingServiceInstance = PointingService.new("UNIT", configs, signatures.UNIT_ATTACK_SELECT)
    selectionManager.setInteraction(pointingServiceInstance)

    -- Recalcula o path quando a unit selecionada troca de célula durante a interação.
    unitCellMonitor.monitor(selectedUnitId, function()
        local current = selectionManager.getCurrentInteraction()
        if not current or current:getId() ~= signatures.UNIT_ATTACK_SELECT then
            unitCellMonitor.unmonitor(selectedUnitId)
            currentSelectedUnitId = nil
            return
        end
        local hovered = interactionState.clientState.selection.currentHoveredUnit
        if hovered then
            requestPathToUnit(hovered)
        end
    end)
end

function module.stopSelect()
    selectionManager.clearInteraction()

    -- Emite unhover para a unit atualmente hovered, limpando o highlight.
    local hovered = interactionState.clientState.selection.currentHoveredUnit
    if hovered then
        emitHover(hovered, false)
        interactionState.clientState.selection.currentHoveredUnit = nil
    end

    pathPreview.hide()

    if currentSelectedUnitId then
        unitCellMonitor.unmonitor(currentSelectedUnitId)
    end

    currentSelectedUnitId = nil
end

-- Encerra a interação de ataque se a unit informada é a unit em interação.
-- Usado quando a unit morre, para encerrar o modo de seleção de alvo.
function module.stopIfUnit(unitId : string)
    if currentSelectedUnitId == unitId then
        module.stopSelect()
    end
end

function module.selectUnit(unitId : string, selectedUnitId : string)
    eventsAPI.sendCommand({
        type = "AGGRO_UNIT",
        target = "UNIT",
        targetAggro = unitId,
        unitId = selectedUnitId
    })

    -- Após escolher o alvo, encerra o modo de ataque e volta ao select de unit.
    module.stopSelect()
    if uiState.uiState.unitSelection.isSelectionButtonActivated then
        selectInput.beginSelect()
    end
end
return module
