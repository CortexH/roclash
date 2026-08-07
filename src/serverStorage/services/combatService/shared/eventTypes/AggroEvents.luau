local module = {}

export type unitAggroSearchEvent = {
	["delay"] : number,
	["eventType"] : "UnitAggroSearchEvent",
	["type"] : "EVENT",
	["data"] : {
		["aggroingUnitId"] : string,
		["aggroVersion"] : string,
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
		["aggroingUnitMovementVersion"] : string,
		["aggroedUnitMovementVersion"] : string
	},
	["isValid"] : boolean
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
	},
	["isValid"] : boolean
}

return module
