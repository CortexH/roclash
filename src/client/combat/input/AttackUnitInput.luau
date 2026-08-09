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
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
    highlight.Parent = model
    return highlight
end

function module.beginSelect(selectedUnitId)
    if pointingServiceInstance then
        pointingServiceInstance:stop()
    end
    selectionManager.clearInteraction()

    local configs: PointingService.lambdaConfigs = {
        onClick = function(view, unitId)
            module.selectUnit(unitId, selectedUnitId)
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

    pointingServiceInstance = PointingService.new("UNIT", configs, "UNIT_ATTACK_SELECT")
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

-- Encerra a interação de ataque apenas se ela estiver ativa para a unit informada.
function module.stopSelectIfUnit(unitId : string)
    if interactionState.clientState.selection.currentSelectedUnit == unitId then
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
end
return module