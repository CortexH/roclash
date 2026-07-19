local module = {}

local npcEntity = require(script.Parent.Parent.entity.NpcEntity)

function module.toInbound(entity : {}) : npcEntity.entity
		
	local mapped : npcEntity.entity = {
		currentHealth = entity["maxHealth"],
		maxHealth = entity["maxHealth"],
		party = entity["party"],
		stats = {
			aggroRange = entity["stats"]["aggroRange"],
			damage = entity["stats"]["damage"],
			damageType = entity["stats"]["damageType"],
			movementSpeed = entity["stats"]["movementSpeed"],
			range = entity["stats"]["range"],
			attackSpeed = entity["stats"]["attackSpeed"]
		},
		uniqueId = entity["uniqueId"],
		state = {
			currentState = entity["state"]["currentState"],
			currentEffectState = entity["state"]["currentEffectState"]
		},
		cell = entity["cell"]
	}
	
	return mapped
	
end

return module
