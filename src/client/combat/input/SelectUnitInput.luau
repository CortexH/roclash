local module = {}

local interactionState = require(script.Parent.Parent.state.InteractionState)
local eventsAPI = require(script.Parent.Parent.network.CommandSender)
local PointingService = require(script.Parent.Parent.service.PointingService)
local selectionManager = require(script.Parent.Parent.managers.SelecionManager)
local eventQueue = require(script.Parent.Parent.network.EnqueueEvent)
local signatures = require(script.Parent.Parent.consts.SelectSignatures)

local pointingServiceInstance

-- Emite o evento de hover/unhover da unit para os listeners (ex.: highlight).
local function emitHover(unitId : string, hovering : boolean)
	eventQueue.enqueueEvent({
		delay = 0,
		eventType = "UnitHoverClient",
		data = {
			unitId = unitId,
			hovering = hovering,
			signature = signatures.UNIT_SELECT
		}
	})
end

function module.beginSelect()
    if pointingServiceInstance then
        pointingServiceInstance:stop()
    end
    selectionManager.clearInteraction()
    local configs: PointingService.lambdaConfigs = {
        onClick = function(view, unitId)
            module.selectUnit(unitId)
        end,
        onHoverStart = function(view, unitId)
            emitHover(unitId, true)
            interactionState.clientState.selection.currentHoveredUnit = unitId
        end,
        onHoverEnd = function(view, unitId)
            emitHover(unitId, false)
            if interactionState.clientState.selection.currentHoveredUnit == unitId then
                interactionState.clientState.selection.currentHoveredUnit = nil
            end
        end,
    }

    pointingServiceInstance = PointingService.new("UNIT", configs, signatures.UNIT_SELECT)
    selectionManager.setInteraction(pointingServiceInstance)
end

function module.stopSelect()
    selectionManager.clearInteraction()

    -- Emite unhover para a unit atualmente hovered, limpando o highlight.
    local hovered = interactionState.clientState.selection.currentHoveredUnit
    if hovered then
        emitHover(hovered, false)
        interactionState.clientState.selection.currentHoveredUnit = nil
    end
end

function module.deselectUnit(unitId : string)
    eventsAPI.sendCommand({
        type = "DESELECT_UNIT",
        target = "UNIT",
        unitId = unitId
    })
    if interactionState.clientState.selection.currentSelectedUnit == unitId then
        interactionState.clientState.selection.currentSelectedUnit = nil
    end
end

function module.selectUnit(unitId : string)
    interactionState.clientState.selection.currentSelectedUnit = unitId
    eventsAPI.sendCommand({
        type = "SELECT_UNIT",
        target = "UNIT",
        signature = "UNIT_CARD",
        unitId = unitId
    })
end

return module
