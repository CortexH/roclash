local module = {}

local interactionState = require(script.Parent.Parent.state.InteractionState)
local eventsAPI = require(script.Parent.Parent.network.CommandSender)
local PointingService = require(script.Parent.Parent.service.PointingService)
local selectionManager = require(script.Parent.Parent.managers.SelecionManager)

local pointingServiceInstance
local highlightedModels: {[Model]: Highlight} = {}

local function highlightModel(model: Model)
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
    highlight.Parent = model
    return highlight
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
            local model = view.model
            if model and not highlightedModels[model] then
                highlightedModels[model] = highlightModel(model)
            end
            interactionState.clientState.selection.currentHoveredUnit = unitId
        end,
        onHoverEnd = function(view, unitId)
            local model = view.model
            if model and highlightedModels[model] then
                highlightedModels[model]:Destroy()
                highlightedModels[model] = nil
            end
            if interactionState.clientState.selection.currentHoveredUnit == unitId then
                interactionState.clientState.selection.currentHoveredUnit = nil
            end
        end,
    }

    pointingServiceInstance = PointingService.new("UNIT", configs, "UNIT_SELECT")
    selectionManager.setInteraction(pointingServiceInstance)
end

function module.stopSelect()
    selectionManager.clearInteraction()

    for model, highlight in pairs(highlightedModels) do
        highlight:Destroy()
    end
    highlightedModels = {}
    pointingServiceInstance = nil
end

-- Limpa a seleção atual se ela apontar para a unit informada (ex.: unit morta).
function module.clearUnitSelection(unitId : string)
    if interactionState.clientState.selection.currentSelectedUnit == unitId then
        interactionState.clientState.selection.currentSelectedUnit = nil
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