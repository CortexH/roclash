local module = {}

export type UnitAggroCommand = {
	["delay"] : number,
	["eventType"] : "UnitAggroCommand",
	["type"] : "COMMAND",
	["requesterId"] : string,
	["data"] : {
		["unitId"] : string,
		["targetId"] : string
	}
}

export type unitAggroCommandSuccess = {
	["delay"] : number,
	["eventType"] : "UnitAggroCommandSuccess",
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["targetId"] : string
	},
	["isValid"] : boolean
}

export type unitAggroCommandFail = {
	["delay"] : number,
	["eventType"] : "UnitAggroCommandFail",
	["type"] : "EVENT",
	["data"] : {
		["unitId"] : string,
		["targetId"] : string,
		["reason"] : string
	},
	["isValid"] : boolean
}

return module