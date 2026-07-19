local module = {}

local domain = game.ServerStorage.Server.services.combatService.modules.entityModule.domain
local eventType = require(domain.events.EntityEvent)

function module.filterEvent(event : eventType.defaultEventType)
	if not event.shouldRender then return false end
	return true
end

return module
