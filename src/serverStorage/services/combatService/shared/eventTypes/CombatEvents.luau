local module = {}

export type unitSpawnedEvent = {
	["eventType"] : "UnitSpawnedEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["behavior"] : string,
		["position"] : {x : number, y : number},
		["rotation"] : number,
		["reason"] : "INITIAL" | "SUMMON" | "CASTLE",
		["type"] : {
			["unitType"] : "NPC" | "STRUCTURE",
			["structureTypeId"] : number | nil
		},
		["entityId"] : string
	},
	["isValid"] : boolean
}

export type unitDiedEvent = {
	["delay"] : number,
	["eventType"] : "UnitDiedEvent",
	["type"] : "EVENT",
	["data"] : {
		["targetId"] : string,
		["sourceId"] : string
	},
	["isValid"] : boolean
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

export type damageAppliedEvent = {
	["delay"] : number,
	["eventType"] : "DamageAppliedEvent",
	["type"] : "EVENT",
	["data"] : {
		["targetId"] : string,
		["sourceId"] : string,
		["damage"] : number,
		["sourceDamageType"] : "SWORD" | "MELEE" | "PROJECTILE" | "MAGIC" | "HEALING"
	},
	["isValid"] : boolean
}

export type targetAcquiredEvent = {
	["eventType"] : "TargetAcquiredEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["targetId"] : string
	}
}

export type targetChangedEvent = {
	eventType : "TargetChangedEvent",
	delay : number,
	type : "EVENT",
	data : {
		unitId : string,
		newTargetsIds : {string},
		addedTargetsIds : {string},
		removedTargetsIds : {string},
		maintainedTargetsIds : {string}
	}
}

export type targetLostEvent = {
	["eventType"] : "TargetLostEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["targetId"] : string
	}
}

export type unitIdleEvent = {
	["eventType"] : "UnitIdleEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string
	}
}

export type unitMovementRequestedEvent = {
	["eventType"] : "UnitMovementRequestedEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["targetCell"] : {x : number, y : number}?,
		["targetUnit"] : string
	}
}

export type unitMovementPlanningEvent = {
	["eventType"] : "UnitMovementPlanningEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["startCell"] : string,
		["path"] : {
			{
				["fromCell"] : {x : number, y : number},
				["toCell"] : {x : number, y : number},
				["blocker"] : string?
			}
		},
		["reachable"] : boolean
	}
}

export type unitMovementIntentEvent = {
	["eventType"] : "UnitMovementIntentEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["startCell"] : string,
		["path"] : {
			{
				["fromCell"] : {x : number, y : number},
				["toCell"] : {x : number, y : number},
				["blocker"] : string?
			}
		},
		["reachable"] : boolean
	}
}

export type unitReachedAggroEvent = {
	["eventType"] : "UnitReachedAggroEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["aggroVersion"] : string
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

export type unitMovementSegmentEvent = {
	["eventType"] : "UnitMovementSegmentEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["beginPosition"] : {X:number, Y:number},
		["finalPosition"] : {X:number, Y:number},
		["unitVersion"] : string
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

export type unitMovementInterruptedEvent = {
	["eventType"] : "UnitMovementInterruptedEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["finalPos"] : {X:number,Y:number}
	},
	["isValid"] : boolean
}

export type unitMovementStoppedEvent = {
	["eventType"] : "UnitMovementStoppedEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["movementVersion"] : string,
		["movementBeginPosition"] : {X:number,Y:number},
		["movementFinalPosition"] : {X:number,Y:number}
	},
	["isValid"] : boolean
}

export type unitStructureBlockingPathEvent = {
	["eventType"] : "UnitStructureBlockingPathEvent",
	["delay"] : number,
	["type"] : "EVENT",
	["data"] : {
		["blockerId"] : string,
		["unitId"] : string
	},
	["isValid"] : boolean
}

export type attackStartedEvent = {
	["delay"] : number,
	["eventType"] : "AttackStartedEvent",
	["type"] : "EVENT",
	["data"] : {
		["attackerId"] : string,
		["targetId"] : string
	},
	["isValid"] : boolean
}

export type attackResolvedEvent = {
	["delay"] : number,
	["eventType"] : "AttackResolvedEvent",
	["type"] : "EVENT",
	["data"] : {
		["attackerId"] : string
	},
	["isValid"] : boolean
}

export type cooldownReadyEvent = {
	["delay"] : number,
	["eventType"] : "CooldownReadyEvent",
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string
	},
	["isValid"] : boolean
}

return module
