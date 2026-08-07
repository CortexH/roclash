local module = {}

local interactionState = require(script.Parent.Parent.state.InteractionState)
local eventsAPI = require(script.Parent.Parent.network.CommandSender)
local PointingService = require(script.Parent.Parent.service.PointingService)
local selectionManager = require(script.Parent.Parent.managers.SelecionManager)
local mapUtils = require(script.Parent.Parent.utils.MapUtils)
local cellHighlight = require(script.Parent.Parent.render.CellHighlightRender)

local pointingServiceInstance

function module.beginSelect(selectedUnitId)
    if pointingServiceInstance then
        pointingServiceInstance:stop()
    end
    selectionManager.clearInteraction()

    local configs: PointingService.lambdaConfigs = {
        onClick = function(cell)
            module.selectCell(cell, selectedUnitId)
        end,
        onHoverStart = function(cell)
            cellHighlight.showAtCell(cell)
        end,
        onHoverEnd = function()
            cellHighlight.hide()
        end,
    }

    pointingServiceInstance = PointingService.new("CELL", configs, "UNIT_MOVE_SELECT")
    selectionManager.setInteraction(pointingServiceInstance)
end

function module.stopSelect()
    selectionManager.clearInteraction()
    cellHighlight.hide()
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