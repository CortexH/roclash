local module = {}

module.applies = {
	["UnitDiedEvent"] = require(script.Parent.ListenUnitDiedEvent).handle
}

module.generates = {
	"UnitDiedNotificationEvent"
}

return module
