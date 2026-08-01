local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local eventType = require(root.events.buttons.SelectInterfaceClientEvent)
local controller = require(root.ui.controllers.battleHudSubControllers.PlaceUnitController)

function module.apply(event: eventType.SelectUnitButtonClicked)
    if event.btnSelected then buttonSelect() else buttonDeselect() end
end

function buttonSelect()
    controller.hideAll()
end

function buttonDeselect()
    controller.showAll()
end

return module