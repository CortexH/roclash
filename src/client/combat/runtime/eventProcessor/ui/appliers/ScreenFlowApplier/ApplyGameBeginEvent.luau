local module = {}

local eventTypes = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.FrontEventTypes)
local root = script.Parent.Parent.Parent.Parent.Parent.Parent

local uiService = require(root.ui.CombatUIService)


function module.apply(event : eventTypes.gameBeginEvent)
    uiService.show("battleHud")
end

return module