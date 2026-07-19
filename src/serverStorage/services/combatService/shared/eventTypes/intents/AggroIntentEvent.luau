local module = {}

export type AggroIntent = {
	["delay"] : number,
	["eventType"] : "UnitAggroIntentEvent",
	["type"] : "EVENT",
	["data"] : {
		["source"] : string,
		["target"] : string
	},
	["isValid"] : boolean
}

export type AggroIntentRejected = {
	["delay"] : number,
	["eventType"] : "AggroIntentRejected",
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["targetId"] : string,
		["reason"] : string
	},
	["isValid"] : boolean
}

return module