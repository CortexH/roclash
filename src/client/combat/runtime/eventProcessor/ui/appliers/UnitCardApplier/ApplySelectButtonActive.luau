local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local eventType = require(root.events.buttons.SelectInterfaceClientEvent)
local cardController = require(root.ui.controllers.battleHudSubControllers.CardController)

function module.apply(event: eventType.SelectUnitButtonClicked)
    if not event.btnSelected then
       cardController.hideSelectedUnitCard()
    end
end

return module