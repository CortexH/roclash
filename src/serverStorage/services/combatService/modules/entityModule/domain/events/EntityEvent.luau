local module = {}

export type defaultEventType = {
	["eventType"] : string,
	["delay"] : number,
	["shouldRender"] : boolean?,
	["type"] : "EVENT" | "COMMAND" | "COMMAND_RESPONSE",
	["data"] : {any}
}

export type unitSpawnedEvent = {
	["eventType"] : "UnitSpawnedEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["behavior"] : string,
		["position"] : {x : number, y : number},
		["rotation"] : number,
		["entityId"] : string,
		["reason"] : "INITIAL" | "SUMMON" | "CASTLE",
		["type"] : {
			["unitType"] : "NPC" | "STRUCTURE",
			["structureTypeId"] : number | nil
		}
	}
}

export type unitMovementStartedEvent = {
	["eventType"] : "UnitMovementStartedEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["beginPosition"] : {x : number, y : number},
		["finalPosition"] : {x : number, y : number},
		["unitId"] : string,
		["unitVersion"] : string,
		["walkSpeed"] : number,
		["movementTime"] : number
	}
}

export type unitMovementInterruptedEvent = {
	["eventType"] : "UnitMovementInterruptedEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["unitMovementVersion"] : string,
		["REASON"] : "PATH_BLOCKED" | "TARGET_FOUND" | "COMMAND" | "UNIT_DIED"
	}
}

export type unitMovementResolvedEvent = {
	["eventType"] : "UnitMovementResolvedEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["position"] : {x : number, y : number},
		["unitId"] : string,
		["unitVersion"] : string
	}
}


export type unitEnteredTowerRangeEvent = {
	["eventType"] : "UnitEnteredTowerRangeEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["towerUnitId"] : string,
		["targetUnitId"] : string,
		["towerUnitVersion"] : string,
		["targetUnitVersion"] : string
	},
	["isValid"] : boolean
}

export type unitLeftTowerRangeEvent = {
	["eventType"] : "UnitLeftTowerRangeEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["towerUnitId"] : string,
		["targetUnitId"] : string,
		["towerUnitVersion"] : string,
		["targetUnitVersion"] : string
	},
	["isValid"] : boolean
}

export type UnitAggroStartedEvent = {
	["delay"] : number,
	["eventType"] : "UnitAggroStartedEvent",
	["type"] : "EVENT",
	["data"] : {
		["aggroingUnitId"] : string,
		["aggroedUnitId"] : string,
		["aggroingUnitVersion"] : string,
		["aggroedUnitVersion"] : string
	}
}

export type unitAggroStoppedEvent = {
	["delay"] : number,
	["eventType"] : "UnitAggroStoppedEvent",
	["type"] : "EVENT",
	["data"] : {
		["aggroingUnitId"] : string,
		["aggroedUnitId"] : string,
		--["aggroingUnitVersion"] : string,
		--["aggroedUnitVersion"] : string
	}
}

export type attackStartedEvent = {
	["delay"] : number,
	["eventType"] : "AttackStartedEvent",
	["type"] : "EVENT",
	["data"] : {
		["attackerId"] : string,
		["targetId"] : string,
		["attackerVersion"] : string,
		["targetVersion"] : string
	}
}

export type attackResolvedEvent = {
	["delay"] : number,
	["eventType"] : "AttackResolvedEvent",
	["type"] : "EVENT",
	["data"] : {
		["attackerId"] : string,
		["attackerVersion"] : string
	}
}

export type attackImpactEvent = {
	["delay"] : number,
	["eventType"] : "AttackImpactEvent",
	["type"] : "EVENT",
	["data"] : {
		["impactType"] : "UNIT" | "POSITION",
		["impactPosition"] : {X : number, Y : number}?,
		["impactUnitId"] : string,
		["sourceUnitId"] : string,
		["impactNumber"] : number
	}
}

export type projectileLaunchedEvent = {
	["delay"] : number,
	["eventType"] : "ProjectileLaunchedEvent",
	["type"] : "EVENT",
	["data"] : {
		["targetType"] : "UNIT" | "POSITION",
		["projectileSpeed"] : number,
		["source"] : string,
		["targetPosition"] : {X : number, Y : number}?,
		["targetId"] : string,
		["timeToHit"] : number

	}
}

export type damageAppliedEvent = {
	["delay"] : number,
	["eventType"] : "DamageAppliedEvent",
	["type"] : "EVENT",
	["data"] : {
		["targetId"] : string,
		["sourceId"] : string,
		["damage"] : number,
		["sourceDamageType"] : "SWORD" | "MELEE" | "PROJECTILE" | "MAGIC" | "HEALING"
	}
}

export type unitDiedEvent = {
	["delay"] : number,
	["eventType"] : "UnitDiedEvent",
	["type"] : "EVENT",
	["data"] : {
		["targetId"] : string,
		["sourceId"] : string
	}
}

export type cooldownReadyEvent = {
	["delay"] : number,
	["eventType"] : "CooldownReadyEvent",
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["unitVersion"] : string,
	}
}

export type targetAcquiredEvent = {
	["eventType"] : "TargetAcquiredEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["sourceId"] : string,
		["targetId"] : string,
		["sourceMovementVersion"] : string,
		["targetMovementVersion"] : string
	}
}

export type targetLostEvent = {
	["eventType"] : "TargetLostEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["sourceId"] : string,
		["targetId"] : string
	}
}

--[[
	Descrição dos eventos:
	
	- UnitSpawnedEvent: Evento disparado quando uma unidade é spawnada. 
	- AttackStartedEvent: evento disparado quando uma entidade começa o ataque.

]]

return module
