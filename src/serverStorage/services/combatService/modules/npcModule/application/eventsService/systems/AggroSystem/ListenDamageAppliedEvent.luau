local module = {}

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local brainPort = require(domain.ports.NpcBrainPort)

function module.handle(event : combatEventTypes.damageAppliedEvent, context)
	if event.isValid == false then return {} end

	local unitId = event.data.targetId
	local targetId = event.data.sourceId

	if type(unitId) ~= "string" or unitId == "" then return {} end
	if type(targetId) ~= "string" or targetId == "" then return {} end
	if not brainPort.getNpcBrain(unitId, context) then return {} end

	return {{
		delay = 0,
		eventType = "AggroIntent",
		type = "EVENT",
		data = {
			source = unitId,
			target = targetId,
			origin = {
				type = "DAMAGE_RECEIVED",
				playerId = nil
			},
			policy = "AUTO"
		},
		isValid = true
	}}
end

return module
