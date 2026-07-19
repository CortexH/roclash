local module = {}

export type unitSpawn = {
	time : number,
	eventType : "UnitSpawn",
	data : {
		unitId : string,
		position : {x : number, y : number},
		rotation : number,
		reason : "INITIAL" | "SUMMON" | "CASTLE",
		unitType : {
			unitType : "NPC" | "STRUCTURE",
			structureTypeId : number?
		},
		behavior : string
	}
}

export type unitDied = {
	time : number,
	eventType : "UnitDied",
	data : {
		unitId : string
	}
}

export type unitMove = {
	time : number,
	eventType : "UnitMove",
	data : {
		unitId : string,
		origin : {X : number, Y : number},
		destination : {X : number, Y : number},
		movementTime : number
	}
}

export type unitTarget = {}

-- tempo de 'preparação' do ataque.
-- se for melee, é o tempo de animação do ataque antes do 'golpe efetivo' (impacto)
-- se for ranged, é o tempo de 'lançamento' do projétil (ex: tempo do golpe carregar, por exemplo)
export type attackStarted = {
	time : number,
	eventType : "AttackStarted",
	data : {
		attackType : "RANGED" | "MELEE",
		attackId : string,
		unitId : string,
		timeToLaunch : number?
	}
}

export type projectileLaunch = {
	time : number,
	eventType : "ProjectileLaunch",
	data : {
		projectileTypeId : number,
		targetType : "UNIT" | "POSITION",
		timeToHit : number,
		source : string,
		targetPosition : {X : number, Y : number}?,
		targetId : string,
		attackTypeId : string,
		movementTypeId : number?
	}
}

export type attackImpact = {
	time : number,
	eventType : "AttackImpact",
	data : {
		impactType : "UNIT" | "POSITION",
		position : {X : number, Y : number}?,
		targetId : string,
		sourceId : string,
		impactTypeId : string,
	}
}

export type damageApplied = {
	time : number,
	eventType : "DamageApplied",
	data : {
		amount : number,
		target : string
	}
}

-- VFX

export type impactVFX = {
	time : number,
	eventType : "ImpactVFX",
	data : {
		position : Vector3,
		vfxId : string
	}
}

-- logic

export type gameBeginEvent = {
	time : number,
	eventType : "GameBeginEvent",
	data : {}
}

return module
